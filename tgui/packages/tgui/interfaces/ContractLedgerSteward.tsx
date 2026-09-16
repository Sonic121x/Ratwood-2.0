import { type ReactNode, useState } from 'react';

import { useBackend } from '../backend';

type DefenseLogEntry = {
  title: string;
  type: string;
  region: string;
  cost: number;
  day: number;
};

type BlockadeRecallEntry = {
  region: string;
  recall_eligible: number | boolean;
  recall_blocker: string | null;
  seconds_until_recallable: number;
  refund: number;
  refund_fund: string | null;
};

type StewardData = {
  pledge_balance: number;
  pledge_refill_base: number;
  pledge_refill_per_player: number;
  pledge_active_players: number;
  pledge_available: number | boolean;
  pledge_guild_bonus: number;
  pledge_golden_active: number | boolean;
  crown_purse_balance: number;
  defense_costs: Record<string, number>;
  defense_regions_by_type: Record<string, string[]>;
  blockade_region_labels: Record<string, string>;
  region_tp_multipliers: Record<string, number>;
  defense_destinations: string[];
  defense_log: DefenseLogEntry[];
  blockade_recall_list: BlockadeRecallEntry[];
  blockade_recall_window_seconds: number;
  bonus_pay_light_mult: number;
  bonus_pay_full_mult: number;
  directives_per_day: number;
  directives_issued_today: number;
  is_alderman_acting: number | boolean;
};

type FundingSource = 'pledge' | 'crown' | 'directive';

type SubTab = 'compose' | 'history';
const RECOVERY_TYPE = 'Recovery';
const BLOCKADE_TYPE = 'Blockade Defense';
const DISPATCH_DEBOUNCE_MS = 500;

const COMMISSION_LABELS: Record<string, string> = {
  'Blockade Defense': '封锁防御',
  Kill: '击杀',
  'Clear Out': '清剿',
  Bounty: '悬赏',
  Raid: '突袭',
  'Hoard Recovery': '寻宝',
};

const coin = (n: number) => `${n}m`;

// Reduces a decimal (like 0.5, 0.2, 0.25) to a simple X/Y fraction via gcd on
// percentage integers. Works cleanly for the multipliers we ship (0.75, 1.2, 1.5).
const formatMultiplierDelta = (delta: number): string => {
  const pct = Math.round(delta * 100);
  return `${pct}%`;
};

// Turns a region's TP multiplier into a short flavor line. Returns null for baseline
// (mult=1) so the UI doesn't clutter itself with "nothing special" chrome.
const regionRewardFlavor = (
  regionName: string,
  mult: number | undefined,
): string | null => {
  if (typeof mult !== 'number' || mult === 1) return null;
  if (mult > 1) {
    const descriptor = mult >= 1.4 ? '荒芜' : '危险';
    return `${regionName} 是一片${descriptor}之地 - 来自该地区的契约往往多赚 ${formatMultiplierDelta(mult - 1)}.`;
  }
  return `${regionName} 是一片安定之地 - 来自该地区的契约往往少赚 ${formatMultiplierDelta(1 - mult)}.`;
};

const FormRow = (props: { label: string; children: ReactNode }) => (
  <div className="ContractLedger__InnkeeperFormRow">
    <label className="ContractLedger__InnkeeperLabel">{props.label}</label>
    {props.children}
  </div>
);

const BonusPayOption = (props: {
  active: boolean;
  onClick: () => void;
  label: string;
  sublabel: string;
}) => (
  <button
    type="button"
    onClick={props.onClick}
    style={{
      padding: '3px 10px',
      border: `1px solid ${props.active ? '#7a5616' : '#8a7250'}`,
      background: props.active ? 'rgba(200,170,100,0.25)' : 'transparent',
      color: props.active ? '#3a2a14' : '#6b4e2a',
      fontWeight: props.active ? 'bold' : 'normal',
      cursor: 'pointer',
      borderRadius: '2px',
      fontSize: '12px',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      minWidth: '60px',
    }}
  >
    <span>{props.label}</span>
    <span style={{ fontSize: '10px', color: '#8a7250' }}>{props.sublabel}</span>
  </button>
);

const Select = (props: {
  value: string;
  onChange: (v: string) => void;
  options: string[];
  placeholder: string;
  disabled?: boolean;
  disabledPlaceholder?: string;
}) => (
  <select
    className="ContractLedger__InnkeeperSelect"
    value={props.value}
    onChange={(e) => props.onChange(e.target.value)}
    disabled={props.disabled}
  >
    <option value="">
      {props.disabled && props.disabledPlaceholder
        ? props.disabledPlaceholder
        : props.placeholder}
    </option>
    {props.options.map((o) => (
      <option key={o} value={o}>
        {o}
      </option>
    ))}
  </select>
);

const SubTabBar = (props: {
  active: SubTab;
  onSelect: (t: SubTab) => void;
  historyCount: number;
}) => {
  const tabs: { id: SubTab; label: string }[] = [
    { id: 'compose', label: '委任' },
    { id: 'history', label: `历史 (${props.historyCount})` },
  ];
  return (
    <div className="ContractLedger__InnkeeperSubTabBar">
      {tabs.map((t) => (
        <div
          key={t.id}
          className={
            'ContractLedger__InnkeeperSubTab' +
            (t.id === props.active
              ? ' ContractLedger__InnkeeperSubTab--active'
              : '')
          }
          onClick={() => props.onSelect(t.id)}
        >
          {t.label}
        </div>
      ))}
    </div>
  );
};

const HistoryView = (props: { log: DefenseLogEntry[] }) => {
  if (!props.log.length) {
    return (
      <div className="ContractLedger__InnkeeperEmpty">
        本周尚未有委任自市民认捐中支取.
      </div>
    );
  }
  const rows = [...props.log].reverse();
  return (
    <div className="ContractLedger__InnkeeperHistory">
      {rows.map((r, i) => (
        <div key={i} className="ContractLedger__InnkeeperHistoryRow">
          <span className="ContractLedger__InnkeeperHistoryTitle">
            {r.title}
          </span>
          <span className="ContractLedger__InnkeeperHistoryMeta">
            {COMMISSION_LABELS[r.type] || r.type} &middot; {r.region}{' '}
            &middot; 第 {r.day} 天 &middot; {coin(r.cost)}
          </span>
        </div>
      ))}
    </div>
  );
};

type DispatchMode = 'board' | 'hands';

const ModeRadio = (props: {
  value: DispatchMode;
  selected: DispatchMode;
  onChange: (v: DispatchMode) => void;
  label: string;
}) => (
  <label>
    <input
      type="radio"
      name="defenseMode"
      checked={props.selected === props.value}
      onChange={() => props.onChange(props.value)}
    />
    &nbsp;{props.label}
  </label>
);

const LevyStampRow = (props: {
  aldermanActing: boolean;
  levyExempt: boolean;
  onChange: (v: boolean) => void;
}) => (
  <FormRow label="关税印戳">
    <label
      style={
        props.aldermanActing
          ? { textDecoration: 'line-through', color: '#8a7250' }
          : undefined
      }
      title={
        props.aldermanActing
          ? '议会参事无权豁免王室税项.'
          : undefined
      }
    >
      <input
        type="checkbox"
        checked={props.levyExempt}
        disabled={props.aldermanActing}
        onChange={(e) => props.onChange(e.target.checked)}
      />
      &nbsp;盖印为免征关税 (豁免王室契约关税)
    </label>
  </FormRow>
);

const ComposeView = () => {
  const { act, data } = useBackend<StewardData>();

  const typeOptions = Object.keys(data.defense_costs || {});
  const [type, setType] = useState<string>(typeOptions[0] || '');
  const [region, setRegion] = useState<string>('');
  const [destination, setDestination] = useState<string>('');
  const [mode, setMode] = useState<DispatchMode>('board');
  const [levyExempt, setLevyExempt] = useState<boolean>(false);
  // 0 = none, 1 = light (1.25x), 2 = full (1.5x). Matches COMMISSION_BONUS_PAY_* defines.
  const [bonusPayLevel, setBonusPayLevel] = useState<0 | 1 | 2>(0);
  const [funding, setFunding] = useState<FundingSource>('pledge');
  const [inflight, setInflight] = useState<boolean>(false);

  const aldermanActing = !!data.is_alderman_acting;
  const regionsForType = data.defense_regions_by_type?.[type] || [];
  const cost = data.defense_costs?.[type] ?? 0;
  const needsDestination = type === RECOVERY_TYPE;
  const isBlockade = type === BLOCKADE_TYPE;
  // The picked blockade's recall entry, if any. Present when a writ is already in
  // circulation for that region - the entry tells us whether it is still recallable
  // and drives the Recall button below.
  const recallEntry =
    isBlockade && region
      ? (data.blockade_recall_list || []).find((e) => e.region === region)
      : undefined;
  const regionHasActiveWrit = !!recallEntry;
  const directivesRemaining =
    (data.directives_per_day ?? 0) - (data.directives_issued_today ?? 0);
  const pledgeAvailable = !!data.pledge_available;
  const bonusLightMult = data.bonus_pay_light_mult ?? 1.25;
  const bonusFullMult = data.bonus_pay_full_mult ?? 1.5;
  // Bonus Pay is disabled for Requests (no reward to sweeten, no coin to burn).
  const bonusPayEligible = funding !== 'directive';
  const effectiveLevel = bonusPayEligible ? bonusPayLevel : 0;
  const bonusMult =
    effectiveLevel === 2 ? bonusFullMult : effectiveLevel === 1 ? bonusLightMult : 1;
  const scaledCost = effectiveLevel !== 0 ? Math.round(cost * bonusMult) : cost;
  const effectiveCost = funding === 'directive' ? 0 : scaledCost;

  // If the currently-selected funding disappears (pledge repealed, quota spent), fall back.
  if (funding === 'pledge' && !pledgeAvailable) {
    setFunding('crown');
  }
  if (funding === 'directive' && directivesRemaining <= 0) {
    setFunding(pledgeAvailable ? 'pledge' : 'crown');
  }
  // Aldermen are restricted to the Pledge - if they wandered onto another source via stale state,
  // snap them back. Server enforces this independently; the UI just keeps the state coherent.
  if (aldermanActing && funding !== 'pledge') {
    setFunding('pledge');
  }
  if (aldermanActing && levyExempt) {
    setLevyExempt(false);
  }

  const onTypeChange = (next: string) => {
    setType(next);
    const newRegions = data.defense_regions_by_type?.[next] || [];
    if (!newRegions.includes(region)) setRegion('');
    if (next !== RECOVERY_TYPE) setDestination('');
  };

  const fundingDisabledReason =
    funding === 'pledge' && data.pledge_balance < scaledCost
      ? `市民认捐不足 (需要 ${coin(scaledCost)}, 现有 ${coin(data.pledge_balance)}).`
      : funding === 'crown' && data.crown_purse_balance < scaledCost
        ? `王室金库不足 (需要 ${coin(scaledCost)}, 现有 ${coin(data.crown_purse_balance)}).`
        : funding === 'directive' && directivesRemaining <= 0
          ? '今日的指令配额已用尽.'
          : undefined;

  const disabledReason = inflight
    ? '拟写中...'
    : !type
      ? '请选择委任类型.'
      : !region
        ? isBlockade
          ? '没有可解除的封锁.'
          : '请选择地区.'
        : isBlockade && regionHasActiveWrit
          ? '此封锁已有令状在流通中.'
          : needsDestination && !destination
            ? '请选择货物目的地.'
            : fundingDisabledReason;

  const dispatch = () => {
    if (disabledReason) return;
    setInflight(true);
    const isDirective = funding === 'directive';
    act('commission_defense', {
      type,
      region,
      destination: needsDestination ? destination : null,
      // Blockade + directive writs are always bearer-bond; ignore the mode control.
      in_hands: isBlockade || isDirective ? 1 : mode === 'hands' ? 1 : 0,
      // Directives skip the levy-exempt stamp (no reward to exempt).
      levy_exempt: isDirective ? 0 : levyExempt ? 1 : 0,
      // Bonus Pay forced off for Requests (directive) server-side as well.
      bonus_pay_level: effectiveLevel,
      funding,
    });
    setTimeout(() => setInflight(false), DISPATCH_DEBOUNCE_MS);
  };

  return (
    <>
      <div className="ContractLedger__InnkeeperFlavor">
        委任冒险者讨伐国度的敌人.
      </div>

      <FormRow label="委任类型">
        <select
          className="ContractLedger__InnkeeperSelect"
          value={type}
          onChange={(e) => onTypeChange(e.target.value)}
        >
          {typeOptions.map((t) => (
            <option key={t} value={t}>
              {COMMISSION_LABELS[t] || t} ({coin(data.defense_costs[t])})
            </option>
          ))}
        </select>
      </FormRow>

      <FormRow label={isBlockade ? '被封锁地区' : '地区'}>
        <select
          className="ContractLedger__InnkeeperSelect"
          value={region}
          onChange={(e) => setRegion(e.target.value)}
          disabled={regionsForType.length === 0}
        >
          <option value="">
            {regionsForType.length === 0
              ? isBlockade
                ? '当前没有活跃的封锁.'
                : '没有地区能容纳此类型'
              : isBlockade
                ? '- 请选择封锁 -'
                : '- 请选择地区 -'}
          </option>
          {regionsForType.map((r) => {
            const mult = data.region_tp_multipliers?.[r];
            // Only annotate non-blockade regions - blockade rows route through economic
            // regions, which don't carry a TP multiplier.
            const suffix =
              !isBlockade && typeof mult === 'number' && mult !== 1
                ? ` (×${mult} 奖赏)`
                : '';
            const label = isBlockade
              ? data.blockade_region_labels?.[r] || r
              : r;
            return (
              <option key={r} value={r}>
                {label}
                {suffix}
              </option>
            );
          })}
        </select>
      </FormRow>

      {!isBlockade &&
        region &&
        (() => {
          const flavor = regionRewardFlavor(
            region,
            data.region_tp_multipliers?.[region],
          );
          if (!flavor) return null;
          return (
            <div
              style={{
                fontSize: '12px',
                color: '#6b4e2a',
                padding: '2px 0 6px 0',
                marginLeft: '6px',
              }}
            >
              {flavor}
            </div>
          );
        })()}

      {needsDestination && (
        <FormRow label="货物目的地">
          <Select
            value={destination}
            onChange={setDestination}
            options={data.defense_destinations || []}
            placeholder="- 请选择目的地 -"
          />
        </FormRow>
      )}

      <FormRow label="资金来源">
        <div className="ContractLedger__InnkeeperModeRow">
          <label>
            <input
              type="radio"
              name="fundingSource"
              checked={funding === 'pledge'}
              disabled={!pledgeAvailable}
              onChange={() => setFunding('pledge')}
            />
            &nbsp;市民认捐 ({coin(data.pledge_balance)})
          </label>
          <label
            style={
              aldermanActing
                ? { textDecoration: 'line-through', color: '#8a7250' }
                : undefined
            }
            title={
              aldermanActing
                ? '议会参事只能自平民的认捐中委任.'
                : undefined
            }
          >
            <input
              type="radio"
              name="fundingSource"
              checked={funding === 'crown'}
              disabled={aldermanActing}
              onChange={() => setFunding('crown')}
            />
            &nbsp;王室金库 ({coin(data.crown_purse_balance)})
          </label>
          <label
            style={
              aldermanActing
                ? { textDecoration: 'line-through', color: '#8a7250' }
                : undefined
            }
            title={
              aldermanActing
                ? '请令乃总管家之权柄, 而非议会参事之权柄.'
                : undefined
            }
          >
            <input
              type="radio"
              name="fundingSource"
              checked={funding === 'directive'}
              disabled={aldermanActing || directivesRemaining <= 0}
              onChange={() => setFunding('directive')}
            />
            &nbsp;请令 (剩余 {directivesRemaining}/{data.directives_per_day ?? 0})
          </label>
        </div>
      </FormRow>

      {funding === 'directive' && (
        <div className="ContractLedger__InnkeeperFlavor">
          请令乃召唤某人出于职责而响应.
          并无钱财易手; 卷轴会绘制到你手中,
          且必须直接交给愿意履行之人.
        </div>
      )}

      {bonusPayEligible && (
        <FormRow label="额外酬金">
          <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
            <BonusPayOption
              active={bonusPayLevel === 0}
              onClick={() => setBonusPayLevel(0)}
              label="无"
              sublabel="x1.0"
            />
            <BonusPayOption
              active={bonusPayLevel === 1}
              onClick={() => setBonusPayLevel(1)}
              label="轻度"
              sublabel={`x${bonusLightMult}`}
            />
            <BonusPayOption
              active={bonusPayLevel === 2}
              onClick={() => setBonusPayLevel(2)}
              label="全额"
              sublabel={`x${bonusFullMult}`}
            />
          </div>
        </FormRow>
      )}

      {!isBlockade && funding !== 'directive' && (
        <FormRow label="交付方式">
          <div className="ContractLedger__InnkeeperModeRow">
            <ModeRadio
              value="board"
              selected={mode}
              onChange={setMode}
              label="张贴于公共告示板"
            />
            <ModeRadio
              value="hands"
              selected={mode}
              onChange={setMode}
              label="置于我手中"
            />
          </div>
        </FormRow>
      )}

      {funding !== 'directive' && (
        <LevyStampRow
          aldermanActing={aldermanActing}
          levyExempt={levyExempt}
          onChange={setLevyExempt}
        />
      )}
      {isBlockade && funding !== 'directive' && (
        <div className="ContractLedger__InnkeeperFlavor">
          封锁令状总会绘制到你手中. 钉上大契约台账,
          即可要求一支三人的冒险团; 留在手中,
          则可直接派遣一支可信的队伍. 第三名之后的每一位
          驻守封锁线的防守者, 至多六人, 都会将波次与
          赏金各提高 20%.
        </div>
      )}

      {isBlockade && recallEntry && (
        <div className="ContractLedger__InnkeeperFlavor">
          {recallEntry.recall_eligible
            ? `${recallEntry.region} 已有令状在流通中, 且无人应答. 现在可以召回它${
                recallEntry.refund > 0 && recallEntry.refund_fund
                  ? ` (退还 ${coin(recallEntry.refund)} 至 ${recallEntry.refund_fund})`
                  : ''
              }.`
            : `${recallEntry.region} 已有令状在流通中. 它无法被召回: ${recallEntry.recall_blocker ?? '原因不明'}.`}
        </div>
      )}

      <div className="ContractLedger__InnkeeperFormFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={!!disabledReason}
          title={disabledReason}
          onClick={dispatch}
        >
          {funding === 'directive'
            ? '提交请令'
            : isBlockade
              ? `印制令状 (${coin(effectiveCost)})`
              : `委任 (${coin(effectiveCost)})`}
        </button>
        {isBlockade && !!recallEntry?.recall_eligible && (
          <button
            type="button"
            className="ContractLedger__SignButton"
            onClick={() => act('recall_blockade_writ', { region })}
          >
            召回令状
            {recallEntry.refund > 0 ? ` (退还 ${coin(recallEntry.refund)})` : ''}
          </button>
        )}
      </div>
    </>
  );
};

export const StewardDefensePanel = () => {
  const { data } = useBackend<StewardData>();
  const [subTab, setSubTab] = useState<SubTab>('compose');

  const guildBonus = data.pledge_guild_bonus || 0;
  const baseDailyRefill =
    data.pledge_refill_base +
    data.pledge_refill_per_player * data.pledge_active_players;
  const dailyRefill = baseDailyRefill + guildBonus;

  return (
    <div className="ContractLedger__Innkeeper">
      <div className="ContractLedger__InnkeeperHeader">
        <div className="ContractLedger__InnkeeperTitle">
          以市民之认捐起誓&hellip;
        </div>
        <div className="ContractLedger__InnkeeperBalance">
          市民认捐:&nbsp;<b>{coin(data.pledge_balance)}</b>
          <span className="ContractLedger__InnkeeperBalanceFormula">
            {' '}
            (+{coin(data.pledge_refill_base)} 基础, +
            {coin(data.pledge_refill_per_player)}/玩家 &times;{' '}
            {data.pledge_active_players}
            {guildBonus > 0
              ? `, +${coin(guildBonus)} 武备行会贡奉`
              : ''}{' '}
            = {coin(dailyRefill)}/日, 上限 {coin(2 * dailyRefill)})
          </span>
        </div>
        {!data.pledge_golden_active && (
          <div
            className="ContractLedger__InnkeeperBalanceFormula"
            style={{ color: '#c84' }}
          >
            金玺诏书已中止 - 认捐不再回补.
          </div>
        )}
      </div>

      <SubTabBar
        active={subTab}
        onSelect={setSubTab}
        historyCount={(data.defense_log || []).length}
      />

      {subTab === 'compose' ? (
        <ComposeView />
      ) : (
        <HistoryView log={data.defense_log || []} />
      )}
    </div>
  );
};

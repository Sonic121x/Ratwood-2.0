import { type ReactNode, useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';

type RumorLogEntry = {
  title: string;
  type: string;
  region: string;
  in_hands: BooleanLike;
  day: number;
};

type InnkeeperData = {
  rumor_points: number;
  rumor_refill_base: number;
  rumor_refill_per_player: number;
  rumor_active_players: number;
  rumor_costs: Record<string, number>;
  rumor_regions_by_type: Record<string, string[]>;
  rumor_destinations: string[];
  rumor_log: RumorLogEntry[];
  rumor_lucrative_mult: number;
  region_tp_multipliers: Record<string, number>;
  region_delivery_multipliers: Record<string, number>;
};

type DispatchMode = 'board' | 'hands';
type SubTab = 'compose' | 'history';
const RECOVERY_TYPE = 'Recovery';
const DISPATCH_DEBOUNCE_MS = 500;

const QUEST_TYPE_LABELS: Record<string, string> = {
  Retrieval: '寻回',
  Courier: '递送',
  Kill: '击杀',
  'Clear Out': '清剿',
  Raid: '突袭',
  Bounty: '悬赏',
  Recovery: '追回',
  'Blockade Defense': '封锁防御',
  'Hoard Recovery': '寻宝',
  'Smith Caravan': '铁匠商队',
  'Ore Vein': '矿脉',
  'Notorious Bounty': '恶名悬赏',
};

const pts = (n: number) => `${n}\u00A0点`;

const formatMultiplierDelta = (delta: number): string => {
  const pct = Math.round(delta * 100);
  return `${pct}%`;
};

const regionRewardFlavor = (
  regionName: string,
  mult: number | undefined,
): string | null => {
  if (typeof mult !== 'number' || mult === 1) return null;
  if (mult > 1) {
    const descriptor = mult >= 1.4 ? '荒芜' : '危险';
    return `${regionName} 是一片${descriptor}之地 - 来自该地区的流言往往多赚 ${formatMultiplierDelta(mult - 1)}.`;
  }
  return `${regionName} 是一片安定之地 - 来自该地区的流言往往少赚 ${formatMultiplierDelta(1 - mult)}.`;
};

const FormRow = (props: { label: string; children: ReactNode }) => (
  <div className="ContractLedger__InnkeeperFormRow">
    <label className="ContractLedger__InnkeeperLabel">{props.label}</label>
    {props.children}
  </div>
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

const ModeRadio = (props: {
  value: DispatchMode;
  selected: DispatchMode;
  onChange: (v: DispatchMode) => void;
  label: string;
}) => (
  <label>
    <input
      type="radio"
      name="rumorMode"
      checked={props.selected === props.value}
      onChange={() => props.onChange(props.value)}
    />
    &nbsp;{props.label}
  </label>
);

const SubTabBar = (props: {
  active: SubTab;
  onSelect: (t: SubTab) => void;
  historyCount: number;
}) => {
  const tabs: { id: SubTab; label: string }[] = [
    { id: 'compose', label: '撰写' },
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

const HistoryView = (props: { log: RumorLogEntry[] }) => {
  if (!props.log.length) {
    return (
      <div className="ContractLedger__InnkeeperEmpty">
        本周尚无流言传出.
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
            {QUEST_TYPE_LABELS[r.type] || r.type} &middot; {r.region}{' '}
            &middot; 第 {r.day} 天 &middot; {r.in_hands ? '手中' : '告示板上'}
          </span>
        </div>
      ))}
    </div>
  );
};

const ComposeView = () => {
  const { act, data } = useBackend<InnkeeperData>();

  const typeOptions = Object.keys(data.rumor_costs || {});
  const [type, setType] = useState<string>(typeOptions[0] || '');
  const [region, setRegion] = useState<string>('');
  const [destination, setDestination] = useState<string>('');
  const [mode, setMode] = useState<DispatchMode>('board');
  const [lucrative, setLucrative] = useState<boolean>(false);
  const [inflight, setInflight] = useState<boolean>(false);

  const regionsForType = data.rumor_regions_by_type?.[type] || [];
  const baseCost = data.rumor_costs?.[type] ?? 0;
  const lucrativeMult = data.rumor_lucrative_mult ?? 1.5;
  const cost = lucrative ? Math.round(baseCost * lucrativeMult) : baseCost;
  const needsDestination = type === RECOVERY_TYPE;

  const onTypeChange = (next: string) => {
    setType(next);
    const newRegions = data.rumor_regions_by_type?.[next] || [];
    if (!newRegions.includes(region)) setRegion('');
    if (next !== RECOVERY_TYPE) setDestination('');
  };

  const disabledReason = inflight
    ? '低语中...'
    : !type
      ? '请选择流言类型.'
      : !region
        ? '请选择地区.'
        : needsDestination && !destination
          ? '请选择传言中的货主.'
          : data.rumor_points < cost
            ? `流言点数不足 (需要 ${cost}, 现有 ${data.rumor_points}).`
            : undefined;

  const dispatch = () => {
    if (disabledReason) return;
    setInflight(true);
    act('compose_rumor', {
      type,
      region,
      destination: needsDestination ? destination : null,
      in_hands: mode === 'hands' ? 1 : 0,
      lucrative: lucrative ? 1 : 0,
    });
    setTimeout(() => setInflight(false), DISPATCH_DEBOUNCE_MS);
  };

  return (
    <>
      <div className="ContractLedger__InnkeeperFlavor">
        向行会低语一句自有分量. 选择一则流言传出;
        点数消耗随其将引来的麻烦而增加.
      </div>

      <FormRow label="流言类型">
        <select
          className="ContractLedger__InnkeeperSelect"
          value={type}
          onChange={(e) => onTypeChange(e.target.value)}
        >
          {typeOptions.map((t) => (
            <option key={t} value={t}>
              {QUEST_TYPE_LABELS[t] || t} ({pts(data.rumor_costs[t])})
            </option>
          ))}
        </select>
      </FormRow>

      <FormRow label="地区">
        <select
          className="ContractLedger__InnkeeperSelect"
          value={region}
          onChange={(e) => setRegion(e.target.value)}
          disabled={regionsForType.length === 0}
        >
          <option value="">
            {regionsForType.length === 0
              ? '没有地区能容纳此类型'
              : '- 请选择地区 -'}
          </option>
          {regionsForType.map((r) => {
            const mult =
              type === RECOVERY_TYPE
                ? data.region_delivery_multipliers?.[r]
                : data.region_tp_multipliers?.[r];
            const suffix =
              typeof mult === 'number' && mult !== 1
                ? ` (×${mult} 奖赏)`
                : '';
            return (
              <option key={r} value={r}>
                {r}
                {suffix}
              </option>
            );
          })}
        </select>
      </FormRow>

      {region &&
        (() => {
          const mult =
            type === RECOVERY_TYPE
              ? data.region_delivery_multipliers?.[region]
              : data.region_tp_multipliers?.[region];
          const flavor = regionRewardFlavor(region, mult);
          if (!flavor) return null;
          return (
            <div
              style={{
                fontSize: '11px',
                fontStyle: 'italic',
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
        <FormRow label="传言货物">
          <Select
            value={destination}
            onChange={setDestination}
            options={data.rumor_destinations || []}
            placeholder="- 请选择目的地 -"
          />
        </FormRow>
      )}

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

      <FormRow label="重利">
        <label>
          <input
            type="checkbox"
            checked={lucrative}
            onChange={(e) => setLucrative(e.target.checked)}
          />
          &nbsp;花费 {pts(Math.round(baseCost * lucrativeMult))} 而非{' '}
          {pts(baseCost)}, 以换取 x{lucrativeMult} 的奖赏. 你的介绍抽成会随
          赏金一同增长.
        </label>
      </FormRow>

      <div className="ContractLedger__InnkeeperFormFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={!!disabledReason}
          title={disabledReason}
          onClick={dispatch}
        >
          低语流言 ({pts(cost)})
          {lucrative ? ' - 重利' : ''}
        </button>
      </div>
    </>
  );
};

export const InnkeeperRumorPanel = () => {
  const { data } = useBackend<InnkeeperData>();
  const [subTab, setSubTab] = useState<SubTab>('compose');

  return (
    <div className="ContractLedger__Innkeeper">
      <div className="ContractLedger__InnkeeperHeader">
        <div className="ContractLedger__InnkeeperTitle">
          如此说来, 我有所耳闻&hellip;
        </div>
        <div className="ContractLedger__InnkeeperBalance">
          流言点数:&nbsp;<b>{data.rumor_points}</b>
          <span className="ContractLedger__InnkeeperBalanceFormula">
            {' '}
            (+{data.rumor_refill_base} 基础, +
            {data.rumor_refill_per_player.toFixed(2)}/玩家 &times;{' '}
            {data.rumor_active_players} ={' '}
            {(
              data.rumor_refill_base +
              data.rumor_refill_per_player * data.rumor_active_players
            ).toFixed(2)}
            /日, 上限{' '}
            {Math.round(
              2 *
                (data.rumor_refill_base +
                  data.rumor_refill_per_player * data.rumor_active_players),
            )}
            )
          </span>
        </div>
      </div>

      <SubTabBar
        active={subTab}
        onSelect={setSubTab}
        historyCount={(data.rumor_log || []).length}
      />

      {subTab === 'compose' ? (
        <ComposeView />
      ) : (
        <HistoryView log={data.rumor_log || []} />
      )}
    </div>
  );
};

import { useState } from 'react';
import { Button, Dialog } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InnkeeperRumorPanel } from './ContractLedgerInnkeeper';
import { StewardDefensePanel } from './ContractLedgerSteward';
import { TownerPostingPanel } from './ContractLedgerTowner';

type Contract = {
  ref: string;
  title: string;
  type: string;
  difficulty: string;
  reward: number;
  deposit: number;
  area: string;
  region: string;
  objective: string;
  expected_count: number;
  threat_bands: number;
  levy_exempt: BooleanLike;
  guild_cut_exempt: BooleanLike;
  is_rumor: BooleanLike;
  is_defense: BooleanLike;
  is_towner: BooleanLike;
  is_standing: BooleanLike;
  required_fellowship_size: number;
  lapse_minutes: number;
};

type ActiveContract = {
  ref: string;
  title: string;
  type: string;
  difficulty: string;
  area: string;
  region: string;
  progress_current: number;
  progress_required: number;
  complete: BooleanLike;
};

type ContractLedgerData = {
  is_handler: BooleanLike;
  balance: number;
  has_account: BooleanLike;
  active_count: number;
  active_max: number;
  active_max_base: number;
  active_fellowship_bonus: number;
  take_cooldown_remaining: number;
  user_fellowship_size: number;
  pool: Contract[];
  active: ActiveContract[];
  regions: string[];
  tax_rate: number;
  guild_cut_rate: number;
  can_proxy_turnin: BooleanLike;
  dynamic_role: string | null;
  dynamic_roles?: string[];
  rumor_points?: number;
  rumor_costs?: Record<string, number>;
  rumor_regions_by_type?: Record<string, string[]>;
  rumor_destinations?: string[];
};

const ALL_REGIONS = 'All';
const ALL_DIFFICULTIES = 'All';
const STANDING_FILTER = 'Standing';
const DIFFICULTIES = ['Easy', 'Medium', 'Hard'];
const FILTER_BUTTONS = [ALL_DIFFICULTIES, STANDING_FILTER, ...DIFFICULTIES];

const FILTER_LABELS: Record<string, string> = {
  All: '全部',
  Standing: '常设',
  Easy: '简单',
  Medium: '中等',
  Hard: '困难',
};

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

type LedgerMode = { kind: 'contracts' } | { kind: 'dynamic'; role: string };

const DYNAMIC_TAB_LABELS: Record<string, string> = {
  innkeeper: '流言',
  steward: '委任',
  towner: '告示',
};

const renderDynamicPanel = (role: string) => {
  switch (role) {
    case 'innkeeper':
      return <InnkeeperRumorPanel />;
    case 'steward':
      return <StewardDefensePanel />;
    case 'towner':
      return <TownerPostingPanel />;
    default:
      return null;
  }
};

const difficultyPinClass = (difficulty: string) => {
  switch (difficulty) {
    case 'Easy':
      return 'ContractLedger__Pin ContractLedger__Pin--easy';
    case 'Medium':
      return 'ContractLedger__Pin ContractLedger__Pin--medium';
    case 'Hard':
      return 'ContractLedger__Pin ContractLedger__Pin--hard';
    default:
      return 'ContractLedger__Pin';
  }
};

export const ContractLedger = () => {
  const { data } = useBackend<ContractLedgerData>();
  const [mode, setMode] = useState<LedgerMode>({ kind: 'contracts' });
  const [activeRegion, setActiveRegion] = useState<string>(ALL_REGIONS);
  const [activeDifficulty, setActiveDifficulty] =
    useState<string>(ALL_DIFFICULTIES);

  const dynamicRoles =
    data.dynamic_roles && data.dynamic_roles.length > 0
      ? data.dynamic_roles
      : data.dynamic_role
        ? [data.dynamic_role]
        : [];
  const showingDynamic = mode.kind === 'dynamic';
  const activeDynamicRole =
    mode.kind === 'dynamic' ? mode.role : null;

  const matchesRegion = (c: Contract) =>
    activeRegion === ALL_REGIONS || c.region === activeRegion;
  const matchesDifficulty = (c: Contract) => {
    if (activeDifficulty === ALL_DIFFICULTIES) return true;
    if (activeDifficulty === STANDING_FILTER) return !!c.is_standing;
    return c.difficulty === activeDifficulty;
  };

  const filtered = data.pool
    .filter((c) => matchesRegion(c) && matchesDifficulty(c))
    .sort((a, b) => {
      const sa = a.is_standing ? 0 : 1;
      const sb = b.is_standing ? 0 : 1;
      return sa - sb;
    });

  const regionTabs = [ALL_REGIONS, ...(data.regions || [])];

  return (
    <Window
      title="大契约台账"
      width={1000}
      height={760}
      theme="grimoire"
    >
      <Window.Content fitted>
        <div className="ContractLedger">
          <div className="ContractLedger__Header">
            {dynamicRoles.length > 0 ? (
              <>
                <span
                  className={
                    'ContractLedger__HeaderMode' +
                    (!showingDynamic ? ' ContractLedger__HeaderMode--active' : '')
                  }
                  onClick={() => setMode({ kind: 'contracts' })}
                >
                  大契约台账
                </span>
                {dynamicRoles.map((role) => (
                  <span key={role}>
                    <span className="ContractLedger__HeaderSep">|</span>
                    <span
                      className={
                        'ContractLedger__HeaderMode' +
                        (activeDynamicRole === role
                          ? ' ContractLedger__HeaderMode--active'
                          : '')
                      }
                      onClick={() => setMode({ kind: 'dynamic', role })}
                    >
                      {DYNAMIC_TAB_LABELS[role] || role}
                    </span>
                  </span>
                ))}
              </>
            ) : (
              <span className="ContractLedger__HeaderStatic">
                大契约台账
              </span>
            )}
          </div>

          {!showingDynamic && (
            <div className="ContractLedger__TabBar">
              {regionTabs.map((region) => {
                const count = data.pool.filter(
                  (c) => region === ALL_REGIONS || c.region === region,
                ).length;
                const isActive = region === activeRegion;
                return (
                  <div
                    key={region}
                    className={
                      'ContractLedger__Tab' +
                      (isActive ? ' ContractLedger__Tab--active' : '')
                    }
                    onClick={() => setActiveRegion(region)}
                  >
                    {FILTER_LABELS[region] || region} ({count})
                  </div>
                );
              })}
            </div>
          )}

          {!showingDynamic && (
            <div className="ContractLedger__FilterBar">
              {FILTER_BUTTONS.map((diff) => {
                const isActive = diff === activeDifficulty;
                const count = data.pool.filter((c) => {
                  if (!matchesRegion(c)) return false;
                  if (diff === ALL_DIFFICULTIES) return true;
                  if (diff === STANDING_FILTER) return !!c.is_standing;
                  return c.difficulty === diff;
                }).length;
                return (
                  <Button
                    key={diff}
                    selected={isActive}
                    onClick={() => setActiveDifficulty(diff)}
                  >
                    {FILTER_LABELS[diff] || diff} ({count})
                  </Button>
                );
              })}
            </div>
          )}

          <div className="ContractLedger__Board">
            {showingDynamic && activeDynamicRole ? (
              renderDynamicPanel(activeDynamicRole)
            ) : filtered.length === 0 ? (
              <div className="ContractLedger__Empty">
                没有契约符合此筛选. 请放宽条件,
                或稍后再来.
              </div>
            ) : (
              <div className="ContractLedger__Grid">
                {filtered.map((c) => (
                  <ContractCard key={c.ref} contract={c} />
                ))}
              </div>
            )}
          </div>

          <ActiveStrip
            active={data.active}
            activeMax={data.active_max}
            balance={data.balance}
          />
        </div>
      </Window.Content>
    </Window>
  );
};

const ContractCard = (props: { contract: Contract }) => {
  const { act, data } = useBackend<ContractLedgerData>();
  const c = props.contract;
  const noAccount = !data.has_account;
  const takeCooldown = data.take_cooldown_remaining || 0;
  const atCap = data.active_count >= data.active_max;
  const cantAfford = data.balance < c.deposit;
  const fellowshipShort =
    c.required_fellowship_size > 0 &&
    (data.user_fellowship_size || 0) < c.required_fellowship_size;
  const disabled =
    noAccount ||
    takeCooldown > 0 ||
    atCap ||
    cantAfford ||
    fellowshipShort;
  const title = noAccount
    ? '没有银行账户. 请先在神经锁上注册.'
    : takeCooldown > 0
      ? `行会冷却中, 再签署一份前请等待 ${takeCooldown}s.`
      : atCap
        ? `你已持有 ${data.active_max} 份契约.`
        : cantAfford
          ? `需要账户中有 ${c.deposit} 玛门.`
          : fellowshipShort
            ? `需要一支 ${c.required_fellowship_size} 人的冒险团, 你目前有 ${data.user_fellowship_size || 0} 人.`
            : undefined;
  const stamps: { label: string; modifier: string }[] = [];
  if (c.is_rumor) stamps.push({ label: '传言!', modifier: 'rumor' });
  if (c.is_defense) stamps.push({ label: '已受命', modifier: 'commissioned' });
  if (c.levy_exempt) stamps.push({ label: '免征关税', modifier: 'exempt' });
  const contentTopPad = stamps.length > 0 ? 8 + stamps.length * 16 : 0;
  return (
    <div className="ContractLedger__Card">
      <div className={difficultyPinClass(c.difficulty)} />
      {stamps.map((s, i) => (
        <div
          key={s.modifier}
          className={`ContractLedger__Stamp ContractLedger__Stamp--${s.modifier}`}
          style={{ top: `${6 + i * 16}px` }}
        >
          {s.label}
        </div>
      ))}
      <div
        className="ContractLedger__CardTitle"
        style={{ marginTop: `${contentTopPad}px` }}
      >
        {c.title}
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">地点</span>
        <span className="ContractLedger__CardValue">
          {c.area || c.region || '未知'}
        </span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">类型</span>
        <span className="ContractLedger__CardValue">
          {QUEST_TYPE_LABELS[c.type] || c.type}
        </span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">难度</span>
        <span className="ContractLedger__CardValue">
          {FILTER_LABELS[c.difficulty] || c.difficulty}
        </span>
      </div>
      {c.required_fellowship_size > 0 && (
        <div className="ContractLedger__CardRow">
          <span className="ContractLedger__CardLabel">冒险团</span>
          <span
            className="ContractLedger__CardValue"
            style={{
              color: fellowshipShort ? '#c44' : '#8b1a1a',
              fontWeight: 'bold',
            }}
          >
            {data.user_fellowship_size || 0} / {c.required_fellowship_size}
            {fellowshipShort ? ' (不足)' : ''}
          </span>
        </div>
      )}
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">奖赏</span>
        <span className="ContractLedger__CardValue">{c.reward}</span>
      </div>
      {(() => {
        const levyRate = c.levy_exempt ? 0 : data.tax_rate;
        const guildRate = c.is_defense || c.guild_cut_exempt ? 0 : data.guild_cut_rate || 0;
        const levy = Math.round(c.reward * levyRate);
        const guild = Math.round(c.reward * guildRate);
        const purse = c.reward - levy - guild;
        return (
          <>
            {!c.levy_exempt && data.tax_rate > 0 && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">
                  王室关税 ({Math.round(data.tax_rate * 100)}%)
                </span>
                <span className="ContractLedger__CardValue" style={{ color: '#c44' }}>
                  -{levy}
                </span>
              </div>
            )}
            {guildRate > 0 && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">
                  行会抽成 ({Math.round(guildRate * 100)}%)
                </span>
                <span className="ContractLedger__CardValue" style={{ color: '#c44' }}>
                  -{guild}
                </span>
              </div>
            )}
            {(levy > 0 || guild > 0) && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">实得</span>
                <span className="ContractLedger__CardValue" style={{ fontWeight: 'bold' }}>
                  {purse}
                </span>
              </div>
            )}
          </>
        );
      })()}
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">押金</span>
        <span className="ContractLedger__CardValue">{c.deposit}</span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">失效</span>
        <span className="ContractLedger__CardValue">
          {c.lapse_minutes > 0 ? `~${c.lapse_minutes}分钟` : '<1分钟'}
        </span>
      </div>
      {c.threat_bands > 0 && (
        <div className="ContractLedger__CardRow">
          <span className="ContractLedger__CardLabel">清除</span>
          <span className="ContractLedger__CardValue">
            {c.threat_bands} 波威胁
          </span>
        </div>
      )}
      {c.objective && (
        <div className="ContractLedger__CardObjective">{c.objective}</div>
      )}
      <div className="ContractLedger__CardFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={disabled}
          title={title}
          onClick={() => act('sign', { ref: c.ref })}
        >
          签署
        </button>
      </div>
    </div>
  );
};

const ActiveStrip = (props: {
  active: ActiveContract[];
  activeMax: number;
  balance: number;
}) => {
  const { act, data } = useBackend<ContractLedgerData>();
  const [showFellowshipHelp, setShowFellowshipHelp] = useState(false);
  const gateRemaining = data.townie_gate_remaining || 0;
  const takeCooldown = data.take_cooldown_remaining || 0;
  const blockReason = !data.has_account
    ? '你没有银行账户. 签署任何契约前, 请先在神经锁上注册.'
    : takeCooldown > 0
      ? `行会冷却中, 再签署一份契约前请等待 ${takeCooldown}秒.`
      : null;
  const fellowshipBonus = data.active_fellowship_bonus || 0;
  const fellowshipNote =
    fellowshipBonus > 0
      ? `+${fellowshipBonus} 来自你领导的冒险团`
      : '组建一支冒险团以获得更多契约名额.';
  return (
    <div className="ContractLedger__ActiveStrip">
      <div className="ContractLedger__ActiveStripHeader">
        <span>
          你的契约 ({props.active.length} / {props.activeMax})
          <span
            style={{
              marginLeft: '10px',
              fontSize: '0.85em',
              color: fellowshipBonus > 0 ? '#2a6b2a' : '#7a6a4a',
              fontWeight: 'normal',
            }}
          >
            {fellowshipNote}
          </span>
          <Button
            compact
            ml={0.5}
            icon="question-circle"
            selected={showFellowshipHelp}
            tooltip="冒险团福利"
            onClick={() => setShowFellowshipHelp(true)}
          />
        </span>
        <span>神经锁余额: {props.balance} 玛门</span>
      </div>
      {!!data.can_proxy_turnin && (
        <div
          style={{
            fontSize: '0.85em',
            fontStyle: 'italic',
            color: '#7a6a4a',
            marginBottom: '4px',
          }}
        >
          你可以在此代契约持有人交付任何已完成的契约, 奖赏会记入
          持有人名下, 你不会抽取任何分成.
        </div>
      )}
      {showFellowshipHelp && (
        <Dialog
          title="组建冒险团以获得更多福利"
          width="420px"
          onClose={() => setShowFellowshipHelp(false)}
        >
          <div style={{ padding: '10px 14px', fontSize: '0.95em' }}>
            <div style={{ marginBottom: '6px' }}>
              打开 IC 标签页以组建冒险团, 并邀请附近的人.
            </div>
            <div style={{ marginBottom: '6px' }}>
              带领一支 2 人及以上的冒险团可获得更多契约名额 (+1 于 2 人时,
              +2 于 3 人及以上).
            </div>
            <div>
              冒险团成员可以互相代为交付彼此的契约.
              奖赏会记入实际交付者的名下,
              并适用其免税状态 (若有).
            </div>
          </div>
        </Dialog>
      )}
      {blockReason && (
        <div
          className="ContractLedger__ActiveRow"
          style={{ color: '#c44', fontWeight: 'bold' }}
        >
          {blockReason}
        </div>
      )}
      {props.active.length === 0 ? (
        <div className="ContractLedger__ActiveRow">
          <span className="ContractLedger__ActiveRow__Meta">
            你没有任何生效中的契约.
          </span>
        </div>
      ) : (
        props.active.map((a) => (
          <div key={a.ref} className="ContractLedger__ActiveRow">
            <span className="ContractLedger__ActiveRow__Title">{a.title}</span>
            <span className="ContractLedger__ActiveRow__Meta">
              {QUEST_TYPE_LABELS[a.type] || a.type} &middot;{' '}
              {FILTER_LABELS[a.difficulty] || a.difficulty} &middot;{' '}
              {a.region || a.area || '未知'}
              {a.progress_required > 1 &&
                ` - ${a.progress_current}/${a.progress_required}`}
              {!!a.complete && ' - 可以交付'}
            </span>
            {!a.complete && (
              <Button
                icon="times"
                color="bad"
                tooltip="没收押金并作废该契约."
                onClick={() => act('abandon', { ref: a.ref })}
              >
                放弃
              </Button>
            )}
          </div>
        ))
      )}
    </div>
  );
};

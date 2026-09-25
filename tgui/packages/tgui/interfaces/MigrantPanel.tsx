import { useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type Role = {
  ref: string;
  name: string;
  amount: number;
  kind: 'required' | 'optional';
  stars: number;
  queued: BooleanLike;
  can_be: BooleanLike;
  desc: string;
};

const KIND_LABEL: Record<Role['kind'], string> = {
  required: '必需',
  optional: '可选',
};

type WaveInfo = {
  ref: string;
  name: string;
  track: string;
  weight: number;
  roll_chance: number;
  triumph_total: number;
  triumph_threshold: number;
  my_contribution: number;
  maxed: BooleanLike;
  locked_until: number;
  queued: BooleanLike;
  min_optional_fills: number;
  roles: Role[];
};

type FormingWave = {
  track: string;
  ref: string;
  name: string;
  arrival_at: number;
  queued: BooleanLike;
  min_optional_fills: number;
  roles: Role[];
};

type Data = {
  server_time: number;
  wave_number: number;
  player_triumph: number;
  active_migrants: number;
  round_time: number;
  queued_wave: string | null;
  queued_role: string | null;
  forming: FormingWave[];
  next_regular_at: number;
  next_special_at: number;
  waves: WaveInfo[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const TRACK_REGULAR = 'regular';
const TRACK_SPECIAL = 'special';
const TRACK_TRIUMPH = 'triumph';
const TRACK_EVENT = 'event';

const fmtClock = (deciseconds: number): string => {
  const total = Math.max(0, Math.round(deciseconds / 10));
  const m = Math.floor(total / 60);
  const s = total % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
};

const kindColor = (kind: Role['kind']): string =>
  kind === 'required' ? SEAL_AMBER : SEAL_BLUE;

const roleTooltip = (role: Role): string =>
  role.desc ? `[${KIND_LABEL[role.kind]}] ${role.desc}` : '';

const QueueRoleRow = (props: {
  waveRef: string;
  waveQueued: BooleanLike;
  role: Role;
  act: ActFn;
}) => {
  const { waveRef, waveQueued, role, act } = props;
  const claimed = !!waveQueued && !!role.queued;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '6px',
        padding: '2px 4px',
        fontFamily: SERIF,
      }}
    >
      <button
        type="button"
        title={roleTooltip(role)}
        style={{
          ...inkButtonStyle({ disabled: !role.can_be, color: claimed ? SEAL_GREEN : INK }),
          flex: 1,
          textAlign: 'left',
          fontWeight: claimed ? 'bold' : 'normal',
        }}
        disabled={!role.can_be}
        onClick={() => act('queue_role', { wave: waveRef, role: role.ref })}
      >
        {claimed ? '✓ ' : ''}
        {role.name} <span style={{ color: INK_SOFT }}>x{role.amount}</span>
      </button>
      {role.stars > 0 && (
        <span style={{ color: SEAL_AMBER, fontSize: '11px' }}>
          {'★'.repeat(Math.min(role.stars, 5))}
        </span>
      )}
    </div>
  );
};

const StaticRoleLine = (props: { roles: Role[] }) => {
  const { roles } = props;
  return (
    <div style={{ fontSize: '11px', color: INK_SOFT, lineHeight: 1.4 }}>
      {roles.map((r, i) => (
        <span
          key={r.ref}
          title={roleTooltip(r)}
          style={{ cursor: r.desc ? 'help' : 'default' }}
        >
          {i > 0 && ', '}
          <span style={{ color: kindColor(r.kind) }}>{r.name}</span>
          {r.amount > 1 ? ` x${r.amount}` : ''}
        </span>
      ))}
    </div>
  );
};

const sectionLabelStyle = (color: string) => ({
  fontSize: '13px',
  fontVariant: 'small-caps' as const,
  fontWeight: 'bold' as const,
  color: color,
  marginTop: '4px',
});

const noteStyle = {
  fontSize: '12px',
  color: INK_SOFT,
  marginBottom: '2px',
};

const FormingRoster = (props: {
  forming: FormingWave;
  now: number;
  act: ActFn;
}) => {
  const { forming, now, act } = props;
  const required = forming.roles.filter((r) => r.kind === 'required');
  const optional = forming.roles.filter((r) => r.kind !== 'required');
  const hasFloor = forming.min_optional_fills > 0;
  const rowFor = (r: Role) => (
    <QueueRoleRow
      key={r.ref}
      waveRef={forming.ref}
      waveQueued={forming.queued}
      role={r}
      act={act}
    />
  );
  return (
    <div style={{ ...cardStyle, marginBottom: 0, padding: '6px 8px' }}>
      <div style={{ fontWeight: 'bold', color: INK, fontSize: '13px' }}>
        {forming.name}
      </div>
      <div style={{ color: SEAL_GREEN, fontSize: '12px', marginBottom: '3px' }}>
        抵达倒计时：{fmtClock(forming.arrival_at - now)}
      </div>
      {required.length > 0 && (
        <>
          <div style={sectionLabelStyle(SEAL_AMBER)}>必需角色</div>
          <div style={noteStyle}>必须全部有人担任，否则此批移民无法抵达。</div>
          {required.map(rowFor)}
        </>
      )}
      {optional.length > 0 && (
        <>
          <div style={sectionLabelStyle(SEAL_BLUE)}>
            {hasFloor ? '可选角色（有人数要求）' : '可选角色'}
          </div>
          <div style={noteStyle}>
            {hasFloor
              ? `这些名额中至少须有 ${forming.min_optional_fills} 人加入，但不要求每种角色都有人担任。`
              : '额外的同行者，名额可以空缺。'}
          </div>
          {optional.map(rowFor)}
        </>
      )}
    </div>
  );
};

const FormingCard = (props: {
  label: string;
  color: string;
  forming: FormingWave | undefined;
  emptyText: string;
  now: number;
  act: ActFn;
}) => {
  const { label, color, forming, emptyText, now, act } = props;
  return (
    <div style={{ flex: 1, minWidth: 0 }}>
      <div
        style={{
          textAlign: 'center',
          fontVariant: 'small-caps',
          fontWeight: 'bold',
          color: color,
          borderBottom: `1px solid ${color}`,
          marginBottom: '4px',
        }}
      >
        {label}
      </div>
      {forming ? (
        <FormingRoster forming={forming} now={now} act={act} />
      ) : (
        <div
          style={{
            ...cardStyle,
            marginBottom: 0,
            color: INK_FAINT,
            textAlign: 'center',
            padding: '6px 8px',
          }}
        >
          {emptyText}
        </div>
      )}
    </div>
  );
};

const ProgressBar = (props: { value: number; max: number; color: string }) => {
  const { value, max, color } = props;
  const pct = Math.min((value / max) * 100, 100);
  return (
    <div
      style={{
        background: PARCHMENT_SHADOW,
        height: '6px',
        borderRadius: '2px',
        margin: '2px 0',
      }}
    >
      <div
        style={{ background: color, width: `${pct}%`, height: '100%', borderRadius: '2px' }}
      />
    </div>
  );
};

const PurchaseCard = (props: { wave: WaveInfo; now: number; act: ActFn }) => {
  const { wave, now, act } = props;
  const ready = wave.triumph_total >= wave.triumph_threshold;
  const locked = wave.locked_until > now;
  const pledged = wave.triumph_total > 0;
  return (
    <div style={{ ...cardStyle, marginBottom: '8px', padding: '6px 8px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <span style={{ fontWeight: 'bold', color: ready ? SEAL_AMBER : INK, fontSize: '13px' }}>
          {wave.name}
          {!!wave.maxed && <span style={{ color: INK_FAINT }}>（已达出现次数上限）</span>}
          {ready && !wave.maxed && <span style={{ color: SEAL_AMBER }}>（贡献已达标！）</span>}
        </span>
        <span style={{ fontSize: '11px', color: INK_SOFT }}>
          {locked ? `解锁倒计时：${fmtClock(wave.locked_until - now)}` : `${wave.roll_chance}%`}
        </span>
      </div>
      <div style={{ minHeight: '32px' }}>
        <StaticRoleLine roles={wave.roles} />
      </div>
      <ProgressBar
        value={wave.triumph_total}
        max={wave.triumph_threshold}
        color={ready ? SEAL_AMBER : SEAL_BLUE}
      />
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <span style={{ fontSize: '11px', color: INK_SOFT }}>
          {wave.triumph_total}/{wave.triumph_threshold}
          {wave.my_contribution > 0 ? `（你的贡献：${wave.my_contribution}）` : ''}
          {wave.min_optional_fills > 0
            ? ` · 可选角色至少需 ${wave.min_optional_fills} 人`
            : ''}
        </span>
        <button
          type="button"
          style={{ ...inkButtonStyle({ disabled: !!wave.maxed }), padding: '1px 8px', fontSize: '11px' }}
          disabled={!!wave.maxed}
          onClick={() => act('buy_wave', { wave: wave.ref })}
        >
          贡献
        </button>
      </div>
    </div>
  );
};

type PurchaseTab = 'regular' | 'special';

export const MigrantPanel = () => {
  const { act, data } = useBackend<Data>();
  const [now, setNow] = useState(data.server_time);
  const [tab, setTab] = useState<PurchaseTab>('regular');

  if (now < data.server_time) {
    setNow(data.server_time);
  }

  const formingRegular = data.forming.find((f) => f.track === TRACK_REGULAR);
  const formingSpecial = data.forming.find((f) => f.track === TRACK_SPECIAL);
  const formingTriumph = data.forming.find((f) => f.track === TRACK_TRIUMPH);
  const formingEvent = data.forming.find((f) => f.track === TRACK_EVENT);

  const tabWaves = data.waves.filter(
    (w) => w.track === (tab === 'special' ? TRACK_SPECIAL : TRACK_REGULAR),
  );

  const queuedWave = data.queued_wave
    ? data.waves.find((w) => w.ref === data.queued_wave)
    : undefined;

  return (
    <Window width={760} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>寻找人生目标</div>
          <div style={subtitleStyle}>
            迷雾散去，旅人们循路而来，踏入腐木谷地。
          </div>

          <div
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              marginBottom: '8px',
            }}
          >
            <span>
              第 {data.wave_number} 批 &middot; 凯旋点：{data.player_triumph}
            </span>
            {queuedWave ? (
              <button
                type="button"
                style={inkButtonStyle({ color: SEAL_GREEN })}
                onClick={() => act('clear_queue')}
              >
                已排队：{queuedWave.name}（退出）
              </button>
            ) : (
              <span style={{ color: INK_FAINT }}>
                选择正在集结的移民中的角色以加入队列
              </span>
            )}
            <span style={{ color: INK_SOFT }}>排队人数：{data.active_migrants}</span>
          </div>

          <div style={rulerStyle} />

          <div style={sectionHeaderStyle}>正在集结——在此排队</div>
          <div style={{ display: 'flex', gap: '8px', marginBottom: '10px', alignItems: 'flex-start' }}>
            <FormingCard
              label="常规"
              color={SEAL_BLUE}
              forming={formingRegular}
              emptyText={`下次集结：${fmtClock(data.next_regular_at - now)}`}
              now={now}
              act={act}
            />
            <FormingCard
              label="特殊"
              color={SEAL_AMBER}
              forming={formingSpecial}
              emptyText={`下次集结：${fmtClock(data.next_special_at - now)}`}
              now={now}
              act={act}
            />
            <FormingCard
              label="凯旋点"
              color={SEAL_GREEN}
              forming={formingTriumph}
              emptyText="贡献凯旋点以召集移民"
              now={now}
              act={act}
            />
            {formingEvent && (
              <FormingCard
                label="事件"
                color={SEAL_RED}
                forming={formingEvent}
                emptyText=""
                now={now}
                act={act}
              />
            )}
          </div>

          <div style={rulerStyle} />

          <div style={tabBarStyle}>
            <div style={tabStyle(tab === 'regular')} onClick={() => setTab('regular')}>
              常规移民
            </div>
            <div style={tabStyle(tab === 'special')} onClick={() => setTab('special')}>
              特殊来客
            </div>
          </div>

          <div style={subtitleStyle}>
            贡献凯旋点可提高某批移民被选中的概率，达到门槛后可确保其被选中集结。
          </div>
          {tabWaves.length === 0 ? (
            <div style={{ ...cardStyle, color: INK_SOFT, textAlign: 'center' }}>
              暂无可选移民。
            </div>
          ) : (
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1fr',
                columnGap: '8px',
              }}
            >
              {tabWaves.map((w) => (
                <PurchaseCard key={w.ref} wave={w} now={now} act={act} />
              ))}
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';
import { NativeButton, NativeSpan } from '../components/Localized';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  BUTTON_BG,
  cardStyle,
  fieldRowStyle,
  FONT_BODY,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type FlightDirection = 'outbound' | 'return';

type ZadcoteSlot = {
  slot: number;
  name: string;
  label: string;
  severed: boolean;
  bonded: boolean;
  in_flight: boolean;
  cage_occupied?: boolean;
  cage_has_payload?: boolean;
  flight_zads?: number;
  flight_arrival_seconds?: number;
  flight_direction?: FlightDirection;
  flight_bombs?: number;
  allow_summons?: boolean;
};

type PayloadItem = {
  name: string;
  ref: string;
  w_class: number;
};

type MailEntry = {
  slot: number;
  sender: string;
  message: string;
  items: string[];
  stamp: string;
  kind: 'sent' | 'returned';
  lost?: number;
  zads_used?: number;
  bombs?: number;
  summoned?: boolean;
};

const WEIGHT_CLASS_TINY = 1;
const WEIGHT_CLASS_SMALL = 2;
const WEIGHT_CLASS_NORMAL = 3;
const WEIGHT_CLASS_BULKY = 4;

const maxWeightForTier = (tier: number): number => {
  if (tier === 1) return WEIGHT_CLASS_SMALL;
  if (tier === 2) return WEIGHT_CLASS_NORMAL;
  return WEIGHT_CLASS_BULKY;
};

const weightLabel = (wc: number): string => {
  if (wc <= WEIGHT_CLASS_TINY) return '微小';
  if (wc === WEIGHT_CLASS_SMALL) return '小型';
  if (wc === WEIGHT_CLASS_NORMAL) return '普通';
  if (wc === WEIGHT_CLASS_BULKY) return '大件';
  return '过重';
};

type ZadcoteData = {
  faction: 'merchant' | 'steward' | 'regent' | 'bathhouse';
  motto: string;
  reserve: number;
  reserve_start: number;
  flights: number;
  flight_cap: number;
  bomb_stock: number;
  bomb_stock_cap: number;
  bomb_cooldown_remaining: number;
  allows_voyeur: boolean;
  voyeur_fund: number;
  voyeur_cost: number;
  slots: ZadcoteSlot[];
  payload_in_hand: PayloadItem[];
  mail_log: MailEntry[];
};

const MESSAGE_MAX = 500;

const formatCountdown = (totalSeconds: number): string => {
  if (totalSeconds <= 0) return '00:00';
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
};

const captionStyle = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
};

const HeaderStat = (props: {
  label: string;
  value: React.ReactNode;
}) => (
  <div style={{ flex: 1, minWidth: 0 }}>
    <div
      style={{
        fontFamily: SERIF,
        fontSize: FONT_SMALL,
        color: SEAL_AMBER,
        letterSpacing: '0.04em',
      }}
    >
      {props.label}
    </div>
    <div style={{ fontFamily: SERIF, fontSize: FONT_LEAD, color: INK }}>
      {props.value}
    </div>
  </div>
);

const ReserveHeader = (props: {
  data: ZadcoteData;
  onHelp: () => void;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const { data, onHelp, act } = props;
  const lowReserve = data.reserve <= Math.max(2, Math.floor(data.reserve_start * 0.2));
  const bombsReady = data.bomb_cooldown_remaining <= 0;
  return (
    <div style={{ position: 'relative' }}>
      <NativeButton
        type="button"
        title="Open the zadcote handbook" display_title="打开扎德鸟舍手册"
        style={{ ...inkButtonStyle({}), position: 'absolute', top: 8, right: 8 }}
        onClick={onHelp}
      >
        ?
      </NativeButton>
      <div style={{ ...titleStyle, paddingRight: '40px' }}>{data.motto || '扎德鸟舍'}</div>
      <div style={subtitleStyle}>一群训练有素的扎德鸟，随时听候差遣。</div>
      <hr style={rulerStyle} />
      <div style={cardStyle}>
        <div style={fieldRowStyle}>
          <HeaderStat
            label="留舍数量"
            value={
              <>
                <span style={{ color: lowReserve ? SEAL_RED : INK, fontWeight: 'bold' }}>
                  {data.reserve}
                </span>
                <span style={{ color: INK_SOFT }}> / {data.reserve_start}</span>
              </>
            }
          />
          <HeaderStat
            label="在途批次"
            value={
              <>
                <span style={{ fontWeight: 'bold' }}>{data.flights}</span>
                <span style={{ color: INK_SOFT }}> / {data.flight_cap}</span>
              </>
            }
          />
          <HeaderStat
            label="炸弹"
            value={
              <>
                <span style={{ fontWeight: 'bold' }}>{data.bomb_stock}</span>
                <span style={{ color: INK_SOFT }}> / {data.bomb_stock_cap}</span>
              </>
            }
          />
          {!bombsReady && (
            <HeaderStat
              label="炸弹补充倒计时"
              value={
                <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                  {formatCountdown(data.bomb_cooldown_remaining)}
                </span>
              }
            />
          )}
          {data.allows_voyeur && (
            <HeaderStat
              label="窥视资金"
              value={
                <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
                  <div>
                    <span style={{ color: data.voyeur_fund < data.voyeur_cost ? SEAL_RED : INK, fontWeight: 'bold' }}>
                      {data.voyeur_fund}m
                    </span>
                    <span style={{ color: INK_SOFT }}> （{data.voyeur_cost}m / 次窥视）</span>
                  </div>
                  <NativeButton display_title={data.voyeur_fund <= 0 ? '窥视盆已空。' : `将窥视盆中的 ${data.voyeur_fund}m 提取为硬币。`}
                    type="button"
                    disabled={data.voyeur_fund <= 0}
                    style={inkButtonStyle({ disabled: data.voyeur_fund <= 0 })}
                    title={
                      data.voyeur_fund <= 0
                        ? 'The scrying basin is empty.'
                        : `Drain ${data.voyeur_fund}m from the scrying basin into coin.`
                    }
                    onClick={() => {
                      if (data.voyeur_fund <= 0) return;
                      act('withdraw_voyeur');
                    }}
                  >
                    提取
                  </NativeButton>
                </div>
              }
            />
          )}
        </div>
      </div>
    </div>
  );
};

const StatusPill = (props: { slot: ZadcoteSlot }) => {
  const { slot } = props;
  if (slot.in_flight) {
    const direction = slot.flight_direction === 'return' ? 'returning' : 'outbound';
    const arriving = slot.flight_arrival_seconds ?? 0;
    return (
      <NativeSpan display_title={`扎德鸟正在${direction === 'returning' ? '返航' : '去程飞行'}，将于 ${formatCountdown(arriving)} 后抵达`}
        style={{
          color: SEAL_AMBER,
          fontWeight: 'bold',
          fontSize: FONT_BODY,
        }}
        title={`A flight is ${direction}, arriving in ${formatCountdown(arriving)}`}
      >
        {direction === 'returning' ? '返航中' : '去程中'}
        {slot.flight_zads ? ` (${slot.flight_zads})` : ''}
        {' — '}
        <span style={{ color: INK_SOFT, fontWeight: 'normal', fontVariantNumeric: 'tabular-nums' }}>
          {formatCountdown(arriving)}
        </span>
      </NativeSpan>
    );
  }
  if (slot.severed) {
    return (
      <span
        style={{
          color: SEAL_RED,
          fontWeight: 'bold',
          fontSize: FONT_BODY,
        }}
      >
        已断开
      </span>
    );
  }
  if (!slot.bonded) {
    return (
      <span
        style={{
          color: INK_FAINT,
          fontStyle: 'italic',
          fontSize: FONT_BODY,
        }}
      >
        等待连接鸟笼
      </span>
    );
  }
  return (
    <span
      style={{
        color: SEAL_GREEN,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
      }}
    >
      已连结
    </span>
  );
};

const SegmentedPicker = (props: {
  options: number[];
  value: number;
  onChange: (v: number) => void;
  disabled?: boolean;
}) => {
  const { options, value, onChange, disabled } = props;
  return (
    <div style={{ display: 'flex', gap: '4px' }}>
      {options.map((opt) => {
        const active = opt === value;
        return (
          <button
            key={opt}
            type="button"
            disabled={disabled}
            style={{
              ...inkButtonStyle({ disabled }),
              padding: '2px 12px',
              background: active ? 'var(--p-tab-active-bg)' : BUTTON_BG,
              borderColor: active ? INK : INK_FAINT,
              fontWeight: active ? 'bold' : 'normal',
              color: active ? INK : INK_SOFT,
            }}
            onClick={() => {
              if (disabled) return;
              onChange(opt);
            }}
          >
            {opt}
          </button>
        );
      })}
    </div>
  );
};

const SendPanel = (props: {
  data: ZadcoteData;
  slot: ZadcoteSlot;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const { data, slot, act, onClose } = props;
  const [message, setMessage] = useState('');
  const [zads, setZads] = useState(1);
  const [bombs, setBombs] = useState(0);
  const [bombCaw, setBombCaw] = useState('');
  const [selectedRefs, setSelectedRefs] = useState<Record<string, boolean>>({});

  const bombsAvailable = data.bomb_stock > 0 && data.bomb_cooldown_remaining <= 0;
  const bombOptions = bombsAvailable
    ? [0, 1, 2, 3].filter((n) => n <= data.bomb_stock)
    : [0];
  const effectiveZads = bombs > 0 ? Math.max(zads, bombs) : zads;
  const overLimit = message.length > MESSAGE_MAX;
  // Only submit parcels that are BOTH selected and light enough for the current zad tier.
  // Mirrors the checkbox's own `on` derivation (selected && !tooHeavy): lowering the Zads count
  // leaves a now-too-heavy parcel checked in state, and sending its ref makes the backend reject
  // the entire flight. Filtering here keeps a stale heavy selection from poisoning the dispatch.
  const refsList = data.payload_in_hand
    .filter(
      (item) =>
        !!selectedRefs[item.ref] &&
        item.w_class <= maxWeightForTier(effectiveZads),
    )
    .map((item) => item.ref);

  const refusedReason = (() => {
    if (slot.severed) return '扎德鸟连结已断开。';
    if (!slot.bonded) return '此栏位尚未连接鸟笼。';
    if (slot.in_flight) return '此栏位已有扎德鸟在途。';
    if (slot.cage_occupied) return '该扎德鸟笼已被占用。';
    if (slot.cage_has_payload) return '该鸟笼内还有未领取的包裹。';
    if (data.flights >= data.flight_cap) return '在途批次过多。';
    if (data.reserve < effectiveZads) return `鸟舍中只剩 ${data.reserve} 只扎德鸟。`;
    if (overLimit) return `消息超过 ${MESSAGE_MAX} 字符。`;
    return null;
  })();

  const sendable = !refusedReason;

  return (
    <div
      style={{
        marginTop: '8px',
        padding: '8px 10px',
        background: 'var(--p-card-bg)',
        border: `1px dashed ${INK_FAINT}`,
        borderRadius: '2px',
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '6px',
        }}
      >
        <span
          style={{
            fontFamily: SERIF,
            fontSize: FONT_TITLE,
            color: INK,
            fontWeight: 'bold',
          }}
        >
          寄往 {slot.label}
        </span>
        <button type="button" style={inkButtonStyle({})} onClick={onClose}>
          关闭
        </button>
      </div>

      <div style={{ marginBottom: '8px' }}>
        <div style={{ display: 'flex', alignItems: 'baseline' }}>
          <div style={{ ...captionStyle, flex: 1 }}>消息</div>
          <div
            style={{
              color: overLimit ? SEAL_RED : INK_FAINT,
              fontSize: FONT_BODY,
            }}
          >
            {message.length} / {MESSAGE_MAX}
          </div>
        </div>
        <textarea
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          rows={4}
          style={{
            width: '100%',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            background: BUTTON_BG,
            border: `1px solid ${INK_FAINT}`,
            color: INK,
            padding: '4px 6px',
            resize: 'vertical',
          }}
        />
      </div>

      <div style={{ marginBottom: '8px', opacity: bombs > 0 ? 0.4 : 1 }}>
        <div style={captionStyle}>手持载荷</div>
        {bombs > 0 ? (
          <div
            style={{
              color: SEAL_AMBER,
              fontSize: FONT_SMALL,
              fontStyle: 'italic',
              padding: '4px 0',
            }}
          >
            已装载炸弹，无法同时携带其他物品。
          </div>
        ) : data.payload_in_hand.length === 0 ? (
          <div
            style={{
              color: INK_FAINT,
              fontSize: FONT_SMALL,
              fontStyle: 'italic',
              padding: '4px 0',
            }}
          >
            用当前选中的手拿着包裹，即可交由扎德鸟寄送。
          </div>
        ) : (
          data.payload_in_hand.map((item) => {
            const tierMax = maxWeightForTier(effectiveZads);
            const tooHeavy = item.w_class > tierMax;
            const on = !!selectedRefs[item.ref] && !tooHeavy;
            const disabled = bombs > 0 || tooHeavy;
            return (
              <label
                key={item.ref}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  padding: '2px 0',
                  fontSize: FONT_BODY,
                  color: tooHeavy ? INK_FAINT : INK,
                  cursor: disabled ? 'not-allowed' : 'pointer',
                  opacity: tooHeavy ? 0.6 : 1,
                }}
              >
                <input
                  type="checkbox"
                  checked={on}
                  disabled={disabled}
                  onChange={() =>
                    setSelectedRefs((prev) => ({ ...prev, [item.ref]: !prev[item.ref] }))
                  }
                />
                <span>{item.name}</span>
                <span
                  style={{
                    color: tooHeavy ? SEAL_RED : INK_FAINT,
                    fontSize: FONT_SMALL,
                    marginLeft: 'auto',
                  }}
                >
                  {tooHeavy
                    ? `${weightLabel(item.w_class)} - 需要更多扎德鸟`
                    : weightLabel(item.w_class)}
                </span>
              </label>
            );
          })
        )}
      </div>

      <div style={{ display: 'flex', gap: '24px', marginBottom: '8px' }}>
        <div>
          <div style={captionStyle}>扎德鸟</div>
          <SegmentedPicker
            options={[1, 2, 3]}
            value={effectiveZads}
            onChange={(v) => {
              setZads(v);
              if (bombs > v) setBombs(v);
            }}
            disabled={bombs > 0}
          />
          <div style={{ color: INK_FAINT, fontSize: FONT_SMALL, marginTop: '4px' }}>
            {effectiveZads === 1
              ? '1 只扎德鸟：微小或小型包裹。'
              : effectiveZads === 2
                ? '2 只扎德鸟：小袋、头盔或普通大小的物品。'
                : '3 只扎德鸟：大件包裹、大型容器或重型武器。'}
          </div>
        </div>
        {bombsAvailable && (
          <div>
            <div style={captionStyle}>瓶装炸弹</div>
            <SegmentedPicker
              options={bombOptions}
              value={bombs}
              onChange={(v) => {
                setBombs(v);
                if (v > zads) setZads(v);
              }}
            />
          </div>
        )}
      </div>
      {bombs > 0 && (
        <div style={{ marginBottom: '8px' }}>
          <div style={captionStyle}>投弹喊话（选填，40 字符）</div>
          <Input
            fluid
            value={bombCaw}
            maxLength={40}
            placeholder="扎德鸟会在投弹前喊出这句话。留空则保持安静。"
            onChange={setBombCaw}
          />
        </div>
      )}

      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <NativeButton display_title={refusedReason ?? '放飞扎德鸟'}
          type="button"
          disabled={!sendable}
          style={inkButtonStyle({ disabled: !sendable })}
          title={refusedReason ?? 'Loose the zads'}
          onClick={() => {
            if (!sendable) return;
            act('dispatch', {
              slot: slot.slot,
              zads: effectiveZads,
              bombs,
              message,
              payload_refs: refsList,
              bomb_caw: bombs > 0 ? bombCaw : '',
            });
            onClose();
          }}
        >
          寄送
        </NativeButton>
        {refusedReason && (
          <span style={{ color: SEAL_RED, fontSize: FONT_BODY }}>
            {refusedReason}
          </span>
        )}
      </div>
    </div>
  );
};

const SlotNameField = (props: {
  slot: ZadcoteSlot;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const { slot, act } = props;
  const [draft, setDraft] = useState(slot.name);

  useEffect(() => {
    setDraft(slot.name);
  }, [slot.name]);

  const dirty = draft.trim() !== slot.name.trim();
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: '6px', flex: 1, minWidth: 0 }}>
      <span
        style={{
          color: INK_SOFT,
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          width: '32px',
          flex: '0 0 32px',
          textAlign: 'right',
          fontVariantNumeric: 'tabular-nums',
        }}
      >
        #{slot.slot}
      </span>
      <Input
        value={draft}
        onChange={setDraft}
        placeholder={`栏位 ${slot.slot}`}
        maxLength={32}
        width="220px"
      />
      <button
        type="button"
        disabled={!dirty}
        style={inkButtonStyle({ disabled: !dirty })}
        onClick={() => {
          if (!dirty) return;
          act('set_slot_name', { slot: slot.slot, name: draft });
        }}
      >
        设定
      </button>
    </div>
  );
};

const SlotRow = (props: {
  data: ZadcoteData;
  slot: ZadcoteSlot;
  expanded: boolean;
  onToggle: () => void;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const { data, slot, expanded, onToggle, act } = props;
  const canSever = slot.bonded && !slot.severed;
  const fundsOk = data.voyeur_fund >= data.voyeur_cost;
  const canVoyeur = data.allows_voyeur && slot.bonded && !slot.severed && fundsOk;
  return (
    <div
      style={{
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
        <SlotNameField slot={slot} act={act} />
        <div style={{ flexShrink: 0, whiteSpace: 'nowrap', textAlign: 'right' }}>
          <StatusPill slot={slot} />
        </div>
      </div>
      <div style={{ display: 'flex', gap: '4px', marginTop: '4px', justifyContent: 'flex-end' }}>
        <NativeButton display_title={slot.in_flight ? '通过此栏位寄送。当前在途的扎德鸟会先落地。' : '通过此栏位寄送。'}
          type="button"
          style={inkButtonStyle({ disabled: slot.severed })}
          disabled={slot.severed}
          title={
            slot.in_flight
              ? 'Send a dispatch on this slot. The zad in flight will land first.'
              : 'Send a dispatch on this slot.'
          }
          onClick={onToggle}
        >
          {expanded ? '收起' : '寄送'}
        </NativeButton>
        {data.allows_voyeur && (
          <NativeButton display_title={!fundsOk ? `窥视资金不足。向扎德鸟舍投入玛门币（需要 ${data.voyeur_cost}m）。` : canVoyeur ? `通过连结的扎德鸟窥视，消耗鸟舍窥视资金 ${data.voyeur_cost}m。` : '无法窥视。'}
            type="button"
            style={inkButtonStyle({ disabled: !canVoyeur })}
            disabled={!canVoyeur}
            title={
              !fundsOk
                ? `Scrying fund empty. Feed mammon coins into the zadcote (needs ${data.voyeur_cost}m).`
                : canVoyeur
                  ? `Scry through the bonded zad. Costs ${data.voyeur_cost}m from the zadcote's scrying fund.`
                  : 'Voyeur unavailable.'
            }
            onClick={() => {
              if (!canVoyeur) return;
              act('voyeur', { slot: slot.slot });
            }}
          >
            窥视
          </NativeButton>
        )}
        <NativeButton display_title={slot.allow_summons ? '允许召唤：持笼者可以随时召唤扎德鸟。' : '禁止召唤：持笼者无法召唤扎德鸟。'}
          type="button"
          style={inkButtonStyle({ disabled: !canSever })}
          disabled={!canSever}
          title={
            slot.allow_summons
              ? 'Summons are allowed. The cage holder may summon a zad on demand.'
              : 'Summons are blocked. The cage holder cannot summon zads.'
          }
          onClick={() => {
            if (!canSever) return;
            act('toggle_summons', { slot: slot.slot });
          }}
        >
          {slot.allow_summons ? '召唤：允许' : '召唤：禁止'}
        </NativeButton>
        <NativeButton display_title={canSever ? '断开此扎德鸟连结。在途的扎德鸟会先完成行程。' : '没有可断开的连结。'}
          type="button"
          style={inkButtonStyle({ disabled: !canSever })}
          disabled={!canSever}
          title={
            canSever
              ? 'Sever this zadlink. A zad in flight will complete its trip first.'
              : 'Nothing to sever.'
          }
          onClick={() => {
            if (!canSever) return;
            act('sever', { slot: slot.slot });
          }}
        >
          断开
        </NativeButton>
      </div>
      {expanded && !slot.severed && slot.bonded && (
        <SendPanel data={data} slot={slot} act={act} onClose={onToggle} />
      )}
    </div>
  );
};

export const Zadcote = () => {
  const { data, act } = useBackend<ZadcoteData>();
  const [expandedSlot, setExpandedSlot] = useState<number | null>(null);
  const [tab, setTab] = useState<'slots' | 'log'>('slots');

  return (
    <Window title="Zadcote" display_title="扎德鸟舍" width={720} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <ReserveHeader data={data} onHelp={() => act('help')} act={act} />
          <div style={{ display: 'flex', gap: '6px', margin: '8px 0' }}>
            <TabButton active={tab === 'slots'} onClick={() => setTab('slots')}>
              扎德鸟连结
            </TabButton>
            <TabButton active={tab === 'log'} onClick={() => setTab('log')}>
              邮递账簿 {data.mail_log.length > 0 ? `(${data.mail_log.length})` : ''}
            </TabButton>
          </div>
          {tab === 'slots' && (
            <div style={cardStyle}>
              {data.slots.length === 0 ? (
                <div
                  style={{
                    textAlign: 'center',
                    color: INK_SOFT,
                    fontStyle: 'italic',
                    padding: '6px 0',
                  }}
                >
                  暂无扎德鸟连结。用扎德鸟笼敲击鸟舍即可建立连结。
                </div>
              ) : (
                data.slots.map((slot) => (
                  <SlotRow
                    key={slot.slot}
                    data={data}
                    slot={slot}
                    expanded={expandedSlot === slot.slot}
                    onToggle={() =>
                      setExpandedSlot((prev) => (prev === slot.slot ? null : slot.slot))
                    }
                    act={act}
                  />
                ))
              )}
            </div>
          )}
          {tab === 'log' && <MailLog entries={data.mail_log} />}
        </div>
      </Window.Content>
    </Window>
  );
};

const TabButton = (props: {
  active: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) => (
  <button
    type="button"
    onClick={props.onClick}
    style={{
      ...inkButtonStyle({}),
      fontWeight: props.active ? 'bold' : 'normal',
      background: props.active ? BUTTON_BG : 'transparent',
      borderColor: props.active ? INK : INK_FAINT,
    }}
  >
    {props.children}
  </button>
);

const MailLog = (props: { entries: MailEntry[] }) => {
  const { entries } = props;
  const sent = entries.filter((e) => e.kind === 'sent');
  const received = entries.filter((e) => e.kind === 'returned');
  return (
    <div style={{ display: 'flex', gap: '8px' }}>
      <MailColumn title="SENT" entries={sent} accent={SEAL_AMBER} />
      <MailColumn title="RECEIVED" entries={received} accent={SEAL_GREEN} />
    </div>
  );
};

const MailColumn = (props: {
  title: string;
  entries: MailEntry[];
  accent: string;
}) => {
  const { title, entries, accent } = props;
  const [expandedIdx, setExpandedIdx] = useState<number | null>(null);
  return (
    <div style={{ ...cardStyle, flex: 1, minWidth: 0 }}>
      <div
        style={{
          ...sectionHeaderStyle,
          marginTop: 0,
          color: accent,
          borderBottomColor: accent,
        }}
      >
        {title === 'SENT' ? '已寄出' : title === 'RECEIVED' ? '已收回' : title} ({entries.length})
      </div>
      {entries.length === 0 ? (
        <div
          style={{
            textAlign: 'center',
            color: INK_SOFT,
            fontStyle: 'italic',
            padding: '6px 0',
            fontSize: FONT_SMALL,
          }}
        >
          暂无记录。
        </div>
      ) : (
        entries.map((entry, idx) => {
          const expanded = expandedIdx === idx;
          const hasMessage = !!entry.message && entry.message.length > 0;
          return (
            <div
              key={idx}
              style={{
                padding: '4px 0',
                borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
                fontSize: FONT_BODY,
                cursor: hasMessage ? 'pointer' : 'default',
              }}
              onClick={() => {
                if (hasMessage) setExpandedIdx(expanded ? null : idx);
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: '6px' }}>
                <span style={{ fontWeight: 'bold', color: INK, overflow: 'hidden', textOverflow: 'ellipsis' }}>
                  #{entry.slot} {entry.sender}
                  {hasMessage && (
                    <span style={{ color: INK_FAINT, marginLeft: '4px' }}>
                      {expanded ? '▾' : '▸'}
                    </span>
                  )}
                </span>
                <span style={{ color: INK_FAINT, fontSize: FONT_SMALL, fontFamily: 'monospace', flexShrink: 0 }}>
                  {entry.stamp}
                </span>
              </div>
              {(() => {
                const zads = entry.zads_used ?? 0;
                if (zads <= 0) return null;
                const verb =
                  entry.kind === 'returned'
                    ? '已返回'
                    : entry.summoned
                      ? '已召唤'
                      : '已派出';
                return (
                  <div style={{ color: INK_SOFT, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                    {verb}：{zads} 只扎德鸟
                  </div>
                );
              })()}
              {entry.items && entry.items.length > 0 ? (
                <div style={{ color: INK_SOFT, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                  {entry.kind === 'sent' ? '寄出物品' : '带回物品'}：{entry.items.join('、')}
                </div>
              ) : null}
              {entry.kind === 'sent' && (entry.bombs ?? 0) > 0 ? (
                <div style={{ color: SEAL_RED, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                  携带 {entry.bombs} 枚瓶装炸弹
                </div>
              ) : null}
              {entry.kind === 'returned' && (entry.lost ?? 0) > 0 ? (
                <div style={{ color: SEAL_RED, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                  {entry.zads_used} 只扎德鸟中有 {entry.lost} 只因力竭而损失
                </div>
              ) : null}
              {hasMessage && expanded && (
                <div
                  style={{
                    color: INK,
                    fontStyle: 'italic',
                    padding: '4px 8px',
                    marginTop: '4px',
                    background: 'rgba(0,0,0,0.04)',
                    borderLeft: `2px solid ${INK_FAINT}`,
                    fontSize: FONT_SMALL,
                  }}
                >
                  &ldquo;{entry.message}&rdquo;
                </div>
              )}
            </div>
          );
        })
      )}
    </div>
  );
};

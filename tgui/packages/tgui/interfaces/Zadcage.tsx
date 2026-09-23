import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  bannerStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type PayloadItem = { name: string; ref: string; w_class?: number };
type StoredItem = { name: string };

const WEIGHT_CLASS_SMALL = 2;
const WEIGHT_CLASS_NORMAL = 3;
const WEIGHT_CLASS_BULKY = 4;

const maxWeightForTier = (tier: number): number => {
  if (tier === 1) return WEIGHT_CLASS_SMALL;
  if (tier === 2) return WEIGHT_CLASS_NORMAL;
  return WEIGHT_CLASS_BULKY;
};

const weightLabel = (wc: number): string => {
  if (wc <= 1) return '微小';
  if (wc === 2) return '小型';
  if (wc === 3) return '普通';
  if (wc === 4) return '大型';
  return '过重';
};

type ZadcageData = {
  bonded: boolean;
  severed: boolean;
  slot_label: string;
  slot_index: number;
  cote_name: string;
  cote_motto: string;
  allow_summons: boolean;
  pending_flight: boolean;
  occupied: boolean;
  time_remaining?: number;
  warning_tail?: boolean;
  capacity?: number;
  has_bombs?: boolean;
  reply_message?: string;
  payload_in_hand: PayloadItem[];
  stored_payload: StoredItem[];
};

const formatCountdown = (seconds: number) => {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
};

const helpButtonStyle = {
  position: 'absolute' as const,
  top: '8px',
  right: '8px',
  ...inkButtonStyle(),
};

export const Zadcage = () => {
  const { act, data } = useBackend<ZadcageData>();
  return (
    <Window title="Zadcage" display_title="扎德鸟笼" width={480} height={560} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <button style={helpButtonStyle} onClick={() => act('help')}>
            ?
          </button>
          <div style={titleStyle}>扎德鸟笼</div>
          <div style={subtitleStyle}>
            {data.bonded
              ? `${data.cote_name} - ${data.slot_index}号栏位：${data.slot_label}`
              : '尚未绑定 - 对扎德鸟舍使用即可绑定。'}
          </div>
          <hr style={rulerStyle} />
          {!!data.severed && (
            <div style={bannerStyle(SEAL_RED)}>扎德鸟链路已被切断。</div>
          )}
          {!data.occupied && data.bonded && !data.severed && data.stored_payload.length === 0 && (
            <div style={{ color: INK_SOFT, fontStyle: 'italic', textAlign: 'center', margin: '14px 0' }}>
              笼中没有扎德鸟。请等待鸟儿到来。
            </div>
          )}
          <SummonPanel />
          {data.stored_payload.length > 0 && <StoredPanel />}
          {!!data.occupied && <OccupancyPanel />}
        </div>
      </Window.Content>
    </Window>
  );
};

const SummonPanel = () => {
  const { act, data } = useBackend<ZadcageData>();
  const pending = !!data.pending_flight;
  const [zads, setZads] = useState(1);

  const may_summon = !data.occupied && data.bonded && !data.severed && data.allow_summons;

  if(!may_summon) return null;

  return (
    <div style={cardStyle}>
      <div style={{ fontWeight: 'bold', color: INK, marginBottom: '4px' }}>
        召唤鸟群
      </div>
      <div style={{ color: INK_SOFT, fontSize: FONT_BODY, marginBottom: '6px' }}>
        {pending
          ? '已有鸟群正在途中。'
          : `从${data.cote_name || '扎德鸟舍'}召来鸟群。约一分钟后抵达，落地后即可装载包裹。`}
      </div>
      {!pending && (
        <div style={{ marginBottom: '8px' }}>
          <div
            style={{
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginBottom: '2px',
            }}
          >
            扎德鸟数量
          </div>
          <div style={{ display: 'flex', gap: '4px' }}>
            {[1, 2, 3].map((opt) => {
              const active = opt === zads;
              return (
                <button
                  key={opt}
                  type="button"
                  style={{
                    ...inkButtonStyle(),
                    padding: '2px 12px',
                    fontWeight: active ? 'bold' : 'normal',
                    borderColor: active ? INK : INK_FAINT,
                    color: active ? INK : INK_SOFT,
                  }}
                  onClick={() => setZads(opt)}
                >
                  {opt}
                </button>
              );
            })}
          </div>
          <div
            style={{
              color: INK_FAINT,
              fontSize: FONT_BODY,
              marginTop: '2px',
            }}
          >
            {zads === 1
              ? '1只扎德鸟：可寄回微小或小型包裹。'
              : zads === 2
                ? '2只扎德鸟：可寄回小袋、头盔或普通大小的物品。'
                : '3只扎德鸟：可寄回大型包裹或大容器。'}
          </div>
        </div>
      )}
      <div style={{ textAlign: 'center' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: pending })}
          disabled={pending}
          onClick={() => act('request_summon', { zads })}
        >
          召唤
        </button>
      </div>
    </div>
  );
};

const StoredPanel = () => {
  const { act, data } = useBackend<ZadcageData>();
  if (!data.stored_payload.length) return null;
  return (
    <div style={cardStyle}>
      <div style={{ fontWeight: 'bold', color: INK, marginBottom: '4px' }}>
        笼中物品
      </div>
      {data.stored_payload.map((item, idx) => (
        <div key={idx} style={{ fontSize: FONT_BODY, color: INK }}>
          - {item.name}
        </div>
      ))}
      <div style={{ marginTop: '8px', textAlign: 'center' }}>
        <button type="button" style={inkButtonStyle()} onClick={() => act('retrieve')}>
          取出
        </button>
      </div>
    </div>
  );
};

const OccupancyPanel = () => {
  const { act, data } = useBackend<ZadcageData>();
  const remaining = data.time_remaining ?? 0;
  const warning = !!data.warning_tail;
  const capacity = data.capacity ?? 1;
  const serverReply = data.reply_message ?? '';
  const [draft, setDraft] = useState(serverReply);
  const [selectedRef, setSelectedRef] = useState<string | null>(null);
  useEffect(() => {
    setDraft(serverReply);
  }, [serverReply]);
  useEffect(() => {
    if (
      selectedRef &&
      !data.payload_in_hand.find((item) => item.ref === selectedRef)
    ) {
      setSelectedRef(null);
    }
  }, [data.payload_in_hand, selectedRef]);
  const dirty = draft.trim() !== serverReply.trim();
  const tierMax = maxWeightForTier(capacity);
  return (
    <div>
      <div style={cardStyle}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ fontWeight: 'bold', color: INK }}>
              鸟群正在笼中等候
            </div>
            <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
              返程运力：{capacity} 只扎德鸟
            </div>
          </div>
          <div
            style={{
              fontFamily: SERIF,
              fontWeight: 'bold',
              color: warning ? SEAL_RED : INK,
              fontSize: '18px',
            }}
          >
            {formatCountdown(remaining)}
          </div>
        </div>
        {warning && (
          <div style={{ color: SEAL_RED, fontSize: FONT_BODY, marginTop: '4px' }}>
            即将自动离开。自动离开时不会携带你的回信或包裹。
          </div>
        )}
      </div>
      <div style={sectionHeaderStyle}>回信</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
        <Input
          fluid
          value={draft}
          maxLength={500}
          placeholder="写几句回复..."
          onChange={setDraft}
        />
        <button
          type="button"
          disabled={!dirty}
          style={inkButtonStyle({ disabled: !dirty })}
          onClick={() => {
            if (!dirty) return;
            act('set_reply_message', { message: draft });
          }}
        >
          保存
        </button>
      </div>
      <div style={sectionHeaderStyle}>回寄包裹</div>
      <div style={{ color: INK_FAINT, fontSize: FONT_BODY, marginBottom: '6px' }}>
        将包裹拿在当前使用的手中，即可寄回。
        {capacity === 1
          ? ' 此次返程可携带微小或小型物品。'
          : capacity === 2
            ? ' 此次返程最多可携带普通大小的物品（头盔、小袋）。'
            : ' 此次返程可携带大型包裹或大容器。'}
      </div>
      {data.payload_in_hand.length === 0 ? (
        <div style={{ color: INK_FAINT, fontStyle: 'italic', fontSize: FONT_BODY }}>
          手中空无一物 - 请拿起要寄回的物品。
        </div>
      ) : (
        <div>
          {data.payload_in_hand.map((item) => {
            const wc = item.w_class ?? 0;
            const tooHeavy = wc > tierMax;
            const checked = !tooHeavy && selectedRef === item.ref;
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
                  cursor: tooHeavy ? 'not-allowed' : 'pointer',
                  opacity: tooHeavy ? 0.6 : 1,
                }}
              >
                <input
                  type="checkbox"
                  checked={checked}
                  disabled={tooHeavy}
                  onChange={() =>
                    setSelectedRef(checked ? null : item.ref)
                  }
                />
                <span>{item.name}</span>
                <span
                  style={{
                    color: tooHeavy ? SEAL_RED : INK_FAINT,
                    marginLeft: 'auto',
                  }}
                >
                  {tooHeavy
                    ? `${weightLabel(wc)} - 超出${capacity}只扎德鸟的运力`
                    : weightLabel(wc)}
                </span>
              </label>
            );
          })}
        </div>
      )}
      <div style={{ marginTop: '14px', textAlign: 'center' }}>
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() =>
            act('send_reply', selectedRef ? { payload_ref: selectedRef } : {})
          }
        >
          寄出回信
        </button>
      </div>
    </div>
  );
};

import { useState } from 'react';
import { Input } from 'tgui-core/components';

import {
  cardStyle,
  fieldRowStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../common/parchment';
import type { ActFn, CommissionerData } from './types';

const starsIf = (text: string, canRead: boolean) =>
  canRead ? text : text.replace(/[A-Za-z0-9]/g, '*');

const CapStatus = (props: { data: CommissionerData }) => {
  const { data } = props;
  const cap = data.item_cap_per_order;
  const count = data.my_manifest_items;
  const overCap = count > cap;
  return (
    <div
      style={{
        ...cardStyle,
        marginBottom: '8px',
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        color: INK_FAINT,
      }}
    >
      你的委托清单已有{' '}
      <b style={{ color: overCap ? SEAL_RED : INK }}>{count}</b> / {cap}{' '}
      件物品（每份委托的数量上限）。
    </div>
  );
};

export const ManifestTab = (props: {
  data: CommissionerData;
  act: ActFn;
  canRead: boolean;
}) => {
  const { data, act, canRead } = props;
  const lines = data.manifest;
  const total = data.manifest_total;
  const deposit = data.my_deposit;
  const cap = data.item_cap_per_order;
  const itemCount = data.my_manifest_items;
  const hasActive = !!data.has_active_order;
  const overCap = itemCount > cap;
  const canSubmit =
    lines.length > 0 &&
    deposit >= total &&
    total > 0 &&
    !overCap &&
    !hasActive;
  const shortfall = total - deposit;
  const [note, setNote] = useState('');

  if (lines.length === 0) {
    return (
      <>
        <CapStatus data={data} />
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
          }}
        >
          你的委托清单为空。请浏览配方，添加想要委托制作的物品。
        </div>
        {deposit > 0 && (
          <div
            style={{
              ...cardStyle,
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              fontFamily: SERIF,
            }}
          >
            <div style={{ flex: 1, color: INK }}>
              你有 <b style={{ color: SEAL_AMBER }}>{deposit}m</b> 存款，
              尚未用于任何委托。
            </div>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('refund_deposit')}
            >
              取出 {deposit}m
            </button>
          </div>
        )}
      </>
    );
  }

  return (
    <>
      <CapStatus data={data} />
      <div>
        {lines.map((line) => (
          <div
            key={line.ref}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '6px 8px',
              borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
              fontFamily: SERIF,
            }}
          >
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: FONT_BODY, color: INK }}>
                {starsIf(line.name, canRead)}
              </div>
              <div
                style={{
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                }}
              >
                {line.category}
              </div>
            </div>
            <div
              style={{
                flex: '0 0 auto',
                color: SEAL_AMBER,
                fontSize: FONT_BODY,
              }}
            >
              每件 {line.unit_price}m
            </div>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() =>
                act('manifest_dec', { ref: line.ref, delta: 1 })
              }
            >
              -
            </button>
            <span
              style={{
                flex: '0 0 32px',
                textAlign: 'center',
                fontSize: FONT_BODY,
                color: INK,
                fontWeight: 'bold',
              }}
            >
              {line.qty}
            </span>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() =>
                act('manifest_inc', { ref: line.ref, delta: 1 })
              }
            >
              +
            </button>
            <div
              style={{
                flex: '0 0 60px',
                textAlign: 'right',
                fontSize: FONT_BODY,
                color: SEAL_AMBER,
                fontWeight: 'bold',
              }}
            >
              {line.line_total}m
            </div>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('manifest_remove', { ref: line.ref })}
              title="Remove this line"
            >
              x
            </button>
          </div>
        ))}
      </div>

      <div
        style={{
          ...fieldRowStyle,
          marginTop: '8px',
          paddingTop: '8px',
        }}
      >
        <div
          style={{
            flex: 1,
            fontFamily: SERIF,
            color: SEAL_AMBER,
          }}
        >
          清单总价
        </div>
        <div
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            fontWeight: 'bold',
          }}
        >
          {total}m
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div
          style={{
            flex: 1,
            fontFamily: SERIF,
            color: SEAL_AMBER,
          }}
        >
          已存款项
        </div>
        <div
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: deposit >= total ? SEAL_GREEN : SEAL_RED,
            fontWeight: 'bold',
          }}
        >
          {deposit}m
        </div>
      </div>

      {!canSubmit && shortfall > 0 && (
        <div
          style={{
            marginTop: '8px',
            textAlign: 'center',
            fontSize: FONT_BODY,
            color: SEAL_RED,
          }}
        >
          再投入 {shortfall}m 钱币即可提交此委托。
        </div>
      )}

      {overCap && (
        <div
          style={{
            marginTop: '8px',
            textAlign: 'center',
            fontSize: FONT_BODY,
            color: SEAL_RED,
          }}
        >
          此委托要求 {itemCount} 件物品，上限为 {cap} 件。请减少
          清单中的物品数量。
        </div>
      )}

      {hasActive && (
        <div
          style={{
            marginTop: '8px',
            textAlign: 'center',
            fontSize: FONT_BODY,
            color: SEAL_RED,
          }}
        >
          你在此已有一份进行中的委托。请先完成或取消，
          再发布新的委托。
        </div>
      )}

      <div
        style={{
          marginTop: '12px',
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          fontFamily: SERIF,
        }}
      >
        <span
          style={{
            fontSize: FONT_BODY,
            color: INK_SOFT,
          }}
        >
          给铁匠的备注（选填）：
        </span>
        <Input
          value={note}
          onChange={setNote}
          placeholder="民兵用的。急需。"
          width="100%"
          maxLength={180}
        />
      </div>

      <div
        style={{
          marginTop: '12px',
          display: 'flex',
          gap: '8px',
          justifyContent: 'center',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({ disabled: !canSubmit })}
          disabled={!canSubmit}
          onClick={() => {
            act('submit_manifest', { note });
            setNote('');
          }}
        >
          发布委托
        </button>
        <button
          type="button"
          style={inkButtonStyle({ disabled: deposit <= 0 })}
          disabled={deposit <= 0}
          onClick={() => act('refund_deposit')}
        >
          退还存款
        </button>
      </div>

      <div
        style={{
          marginTop: '10px',
          textAlign: 'center',
          fontSize: FONT_BODY,
          color: INK_SOFT,
        }}
      >
        将钱币投入机器即可存款。发布委托后，款项将被锁定托管，
        由铁匠在完成订单后领取。
      </div>

      <div
        style={{
          marginTop: '6px',
          textAlign: 'center',
          fontSize: FONT_BODY,
          color: SEAL_RED,
        }}
      >
        注意：已发布的委托会显示你的真实姓名。
      </div>
    </>
  );
};

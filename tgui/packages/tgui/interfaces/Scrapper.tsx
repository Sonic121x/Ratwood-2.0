import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
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

type MaterialRow = {
  path: string;
  name: string;
  price: number;
  cap: number;
  held: number;
  items: number;
  left: number;
  advertise: BooleanLike;
  enabled: BooleanLike;
};

type Data = {
  budget: number;
  is_keyholder: BooleanLike;
  materials: MaterialRow[];
  total_items: number;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const PriceCapEditor = (props: {
  row: MaterialRow;
  act: ActFn;
}) => {
  const { row, act } = props;
  const [priceDraft, setPriceDraft] = useState(row.price);
  const [capDraft, setCapDraft] = useState(row.cap);
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
      }}
    >
      <NumberInput
        value={priceDraft}
        minValue={0}
        maxValue={9999}
        step={1}
        stepPixelSize={4}
        width="60px"
        onChange={(v: number) => setPriceDraft(v)}
      />
      <button
        type="button"
        style={inkButtonStyle({ disabled: priceDraft === row.price })}
        disabled={priceDraft === row.price}
        onClick={() => act('set_price', { path: row.path, value: priceDraft })}
      >
        价格
      </button>
      <NumberInput
        value={capDraft}
        minValue={0}
        maxValue={9999}
        step={1}
        stepPixelSize={4}
        width="60px"
        onChange={(v: number) => setCapDraft(v)}
      />
      <button
        type="button"
        style={inkButtonStyle({ disabled: capDraft === row.cap })}
        disabled={capDraft === row.cap}
        onClick={() => act('set_cap', { path: row.path, value: capDraft })}
      >
        上限
      </button>
    </div>
  );
};

const MaterialRowView = (props: {
  row: MaterialRow;
  isKeyholder: boolean;
  act: ActFn;
}) => {
  const { row, isKeyholder, act } = props;
  const advertising = !!row.advertise;
  const enabled = !!row.enabled;
  const capText =
    row.cap > 0 ? `剩余 ${row.left} / ${row.cap}` : '无上限';
  const full = row.cap > 0 && row.left === 0;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        opacity: enabled ? 1 : 0.5,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          <b>{row.name}</b>
          {!enabled && (
            <span
              style={{
                color: INK_FAINT,
                fontSize: FONT_BODY,
              }}
            >
              {' '}
              - 已停用
            </span>
          )}
        </div>
        <div style={{ fontSize: FONT_BODY, color: INK_SOFT }}>
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {row.price}m
          </span>{' '}
          每件
          {' - '}
          <span style={{ color: full ? SEAL_RED : INK_SOFT }}>
            {capText}
          </span>
          {advertising && enabled && (
            <span style={{ color: SEAL_GREEN }}>
              {' '}
              - 正在宣传
            </span>
          )}
        </div>
      </div>
      {isKeyholder ? (
        <>
          <PriceCapEditor row={row} act={act} />
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() =>
              act('toggle_enable', { path: row.path })
            }
          >
            {enabled ? '停用' : '启用'}
          </button>
          <button
            type="button"
            style={inkButtonStyle({ disabled: !enabled })}
            disabled={!enabled}
            onClick={() =>
              act('toggle_advertise', { path: row.path })
            }
          >
            {advertising ? '停止宣传' : '宣传'}
          </button>
          {row.items > 0 && (
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('dump_held', { path: row.path })}
            >
              清空（{row.items}）
            </button>
          )}
        </>
      ) : null}
    </div>
  );
};

export const Scrapper = () => {
  const { act, data } = useBackend<Data>();
  const isKeyholder = !!data.is_keyholder;
  return (
    <Window width={isKeyholder ? 780 : 480} height={620} theme="parchment" display_title="废料回收机">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>废料回收机</div>
          <div style={subtitleStyle}>
            送来破布和损坏的货物，回收机会称重、付款并将其
            熔解。收购价格由经营者设定。
          </div>
          <div style={rulerStyle} />

          <div
            style={{
              ...cardStyle,
              display: 'flex',
              alignItems: 'baseline',
              gap: '12px',
              fontFamily: SERIF,
              marginBottom: '12px',
            }}
          >
            <div style={{ flex: 1 }}>
              <div
                style={{
                  fontSize: FONT_BODY,
                  color: SEAL_AMBER,
                }}
              >
                钱箱
              </div>
              <div
                style={{
                  fontSize: '16px',
                  color: data.budget > 0 ? INK : INK_FAINT,
                  fontWeight: 'bold',
                }}
              >
                {data.budget}m
              </div>
            </div>
            {isKeyholder && (
              <div
                style={{
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                  flex: 1,
                  textAlign: 'right',
                }}
              >
                向机器投入硬币，充作收购资金。
              </div>
            )}
            {isKeyholder && (
              <button
                type="button"
                style={inkButtonStyle({ disabled: data.budget <= 0 })}
                disabled={data.budget <= 0}
                onClick={() => act('withdraw')}
              >
                提取
              </button>
            )}
            {isKeyholder && (
              <button
                type="button"
                style={inkButtonStyle({ disabled: data.total_items <= 0 })}
                disabled={data.total_items <= 0}
                onClick={() => act('dump_all')}
              >
                全部清空（{data.total_items}）
              </button>
            )}
          </div>

          <div style={sectionHeaderStyle}>收购材料</div>
          {data.materials.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              尚未设置收购材料。
            </div>
          ) : (
            data.materials.map((row) => (
              <MaterialRowView
                key={row.path}
                row={row}
                isKeyholder={isKeyholder}
                act={act}
              />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

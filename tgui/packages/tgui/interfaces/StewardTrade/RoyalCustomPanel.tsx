import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
} from '../common/parchment';
import type { Data } from './types';

export const RoyalCustomPanel = () => {
  const { act, data } = useBackend<Data>();
  const [marginDraft, setMarginDraft] = useState(data.royal_custom_margin);
  const unlocked = !!data.royal_custom_unlocked;
  return (
    <div
      style={{
        ...cardStyle,
        marginBottom: '10px',
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          flexWrap: 'wrap',
        }}
      >
        <span
          style={{
            color: SEAL_AMBER,
            fontWeight: 'bold',
          }}
        >
          王权关税特许状
        </span>
        {!unlocked ? (
          <span style={{ color: INK_SOFT }}>
            未解锁 - 交易量{' '}
            <b style={{ color: INK }}>{data.royal_custom_volume}m</b> 所需{' '}
            <b style={{ color: INK }}>{data.royal_custom_threshold}m</b>
          </span>
        ) : (
          <>
            <span style={{ color: SEAL_GREEN, fontWeight: 'bold' }}>
              已生效
            </span>
            <span style={{ color: INK_SOFT }}>
              进口加价{' '}
              <b style={{ color: INK }}>{data.royal_custom_margin}%</b>
            </span>
            <div
              style={{
                marginLeft: 'auto',
                display: 'flex',
                gap: '6px',
                alignItems: 'center',
              }}
            >
              <span style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
                加价 %
              </span>
              <NumberInput
                value={marginDraft}
                minValue={0}
                maxValue={500}
                step={5}
                stepPixelSize={4}
                width="60px"
                onChange={(v: number) => setMarginDraft(v)}
              />
              <button
                type="button"
                style={inkButtonStyle({
                  disabled: marginDraft === data.royal_custom_margin,
                })}
                disabled={marginDraft === data.royal_custom_margin}
                onClick={() =>
                  act('set_royal_custom_margin', { value: marginDraft })
                }
              >
                设置
              </button>
            </div>
          </>
        )}
      </div>
      <div
        style={{
          color: INK_SOFT,
          fontSize: FONT_BODY,
          marginTop: '4px',
        }}
      >
        交易量达到阈值后生效;
        此后进口附加费将流入王室金库.
      </div>
    </div>
  );
};

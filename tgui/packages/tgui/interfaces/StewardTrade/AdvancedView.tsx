import { useBackend } from '../../backend';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
} from '../common/parchment';
import type { Data } from './types';

export const AdvancedView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { data } = props;
  const aldermanActing = !!data.is_alderman_acting;
  const blockTitle =
    "Reserved to the Steward's office.";
  const barred = data.autoexport_barred;
  const shortageOpen = data.shortage_goods_open;
  return (
    <div
      style={{
        ...cardStyle,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        color: INK,
      }}
    >
      <div style={sectionHeaderStyle}>自动出口</div>
      <div style={{ color: INK_SOFT, marginBottom: '8px' }}>
        每天, 超过出口阈值的货物会被运走. 若禁止出口则会被囤积. 在自动出口关闭时向已满的库存存入货物也会将其囤积. 这有助于让王权保留套利收益并防止过度采购. 出口正处于
        短缺状态的货物有助于提前结束短缺.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          flexWrap: 'wrap',
          marginBottom: '8px',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({
            color: SEAL_RED,
            disabled: aldermanActing || shortageOpen <= 0,
          })}
          disabled={aldermanActing || shortageOpen <= 0}
          onClick={() => act('bar_autoexport_shortages')}
          title={
            aldermanActing
              ? blockTitle
              : 'Bar autoexport on every good currently under a shortage, so the sweep cannot sell off the scarcity or shorten the shortage.'
          }
        >
          禁止自动出口短缺货物 ({shortageOpen})
        </button>
        <button
          type="button"
          style={inkButtonStyle({
            color: SEAL_GREEN,
            disabled: aldermanActing || barred <= 0,
          })}
          disabled={aldermanActing || barred <= 0}
          onClick={() => act('allow_autoexport_all')}
          title={
            aldermanActing
              ? blockTitle
              : 'Clear every autoexport bar across the whole warehouse.'
          }
        >
          允许自动出口全部货物
        </button>
        <span style={{ color: barred > 0 ? SEAL_AMBER : INK_SOFT }}>
          {barred} 项已禁止
        </span>
      </div>
    </div>
  );
};

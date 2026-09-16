import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { MarketView } from './Noticeboard/AvisaSections/MarketSection';
import type { MarketData } from './Noticeboard/types';

type NavigatorData = {
  motto: string;
  next_airlift_seconds: number;
  handler_fee_percent: number;
  duty_rate: number;
  pay_taxes: boolean;
  levy_rate: number;
  pay_merchant_share: boolean;
  duty_collected_here: number;
  duty_evaded_here: number;
  levy_collected_here: number;
  is_proprietor: boolean;
  is_smuggler: boolean;
  is_readable: boolean;
  facilitator_present: boolean;
  market_data: MarketData;
};

const formatCountdown = (totalSeconds: number): string => {
  if (totalSeconds <= 0) return '00:00';
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
};

const obscure = (s: string): string => s.replace(/[^\s]/g, '?');

export const Navigator = () => {
  const { data, act } = useBackend<NavigatorData>();
  const readable = !!data.is_readable;
  const motto = readable ? data.motto : obscure(data.motto);
  const dutyRatePct = Math.round((data.duty_rate || 0) * 100);
  const isProprietor = !!data.is_proprietor;
  const isSmuggler = !!data.is_smuggler;

  return (
    <Window title="引航机" width={720} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, position: 'relative' }}>
          <button
            type="button"
            title="打开经济指南"
            style={{
              ...inkButtonStyle({}),
              position: 'absolute',
              top: 8,
              right: 8,
            }}
            onClick={() => act('help')}
          >
            ?
          </button>
          <button
            type="button"
            title="刷新市场数据 (5s 冷却)"
            style={{
              ...inkButtonStyle({}),
              position: 'absolute',
              top: 8,
              right: 40,
            }}
            onClick={() => act('refresh_market')}
          >
            ↻
          </button>
          <div style={titleStyle}>{motto}</div>
          <div style={subtitleStyle}>
            下一班气球还有 {formatCountdown(data.next_airlift_seconds)}
            {data.handler_fee_percent > 0 && (
              <> - 经手费 {data.handler_fee_percent}%</>
            )}
          </div>
          <hr style={rulerStyle} />

          {isSmuggler ? (
            <div style={cardStyle}>
              <div style={fieldRowStyle}>
                <div style={fieldLabelStyle}>中介人</div>
                <div
                  style={{
                    ...fieldValueStyle,
                    color: data.facilitator_present ? SEAL_GREEN : SEAL_RED,
                    fontWeight: 'bold',
                  }}
                >
                  {data.facilitator_present
                    ? '在岗 - 经手人免收费用'
                    : '离岗 - 经手人抽成 50%'}
                </div>
              </div>
              <div style={fieldRowStyle}>
                <div style={fieldLabelStyle}>王室关税</div>
                <div
                  style={{
                    ...fieldValueStyle,
                    color: INK_FAINT,
                    fontStyle: 'italic',
                  }}
                >
                  无 - 气球暗中飞行.
                </div>
              </div>
            </div>
          ) : (
            <div style={cardStyle}>
              <div style={fieldRowStyle}>
                <div style={fieldLabelStyle}>王室出口关税</div>
                <div style={fieldValueStyle}>
                  <span style={{ fontWeight: 'bold' }}>{dutyRatePct}%</span>
                  {isProprietor && (
                    <span
                      style={{
                        marginLeft: 10,
                        color: data.pay_taxes ? SEAL_GREEN : SEAL_RED,
                        fontWeight: 'bold',
                      }}
                    >
                      {data.pay_taxes ? '(缴纳中)' : '(逃税中)'}
                    </span>
                  )}
                  {isProprietor && (
                    <button
                      type="button"
                      style={{ ...inkButtonStyle(), marginLeft: 12 }}
                      onClick={() => act('toggle_duty')}
                    >
                      {data.pay_taxes ? '停止缴纳' : '恢复缴纳'}
                    </button>
                  )}
                </div>
              </div>
              <div style={fieldRowStyle}>
                <div style={fieldLabelStyle}>商人征缴</div>
                <div style={fieldValueStyle}>
                  <span style={{ fontWeight: 'bold' }}>{data.levy_rate}%</span>
                  {isProprietor && (
                    <span
                      style={{
                        marginLeft: 10,
                        color: data.pay_merchant_share
                          ? SEAL_GREEN
                          : SEAL_AMBER,
                        fontWeight: 'bold',
                      }}
                    >
                      {data.pay_merchant_share ? '(征收中)' : '(已豁免)'}
                    </span>
                  )}
                  {isProprietor && (
                    <button
                      type="button"
                      style={{ ...inkButtonStyle(), marginLeft: 12 }}
                      onClick={() => act('toggle_levy')}
                    >
                      {data.pay_merchant_share ? '豁免征缴' : '恢复征缴'}
                    </button>
                  )}
                </div>
              </div>
              {isProprietor && (
                <div style={fieldRowStyle}>
                  <div style={fieldLabelStyle}>统计</div>
                  <div style={fieldValueStyle}>
                    <span style={{ color: SEAL_GREEN }}>
                      王室已缴: {data.duty_collected_here}m
                    </span>
                    <span style={{ color: INK_SOFT }}> &middot; </span>
                    <span style={{ color: SEAL_RED }}>
                      王室逃漏: {data.duty_evaded_here}m
                    </span>
                    <span style={{ color: INK_SOFT }}> &middot; </span>
                    <span style={{ color: INK }}>
                      征缴已收: {data.levy_collected_here}m
                    </span>
                  </div>
                </div>
              )}
            </div>
          )}

          {!isSmuggler && (
            <div
              style={{
                marginTop: 10,
                marginBottom: 10,
                padding: '8px 12px',
                border: `1px dashed ${SEAL_AMBER}`,
                color: INK_SOFT,
                fontSize: FONT_BODY,
                fontStyle: 'italic',
                lineHeight: 1.4,
              }}
            >
              <b style={{ color: SEAL_AMBER }}>贵重品饱和了?</b> 若
              贵重品仓库已淤塞且无船求购,
              不妨考虑总管府的储备库用于铸币,
              浴场, 或某个更阴暗的中介人愿意接手
              这类东西.
            </div>
          )}

          <MarketView
            market={data.market_data}
            headerLabel={
              isSmuggler ? '黑市行情' : '市场行情'
            }
            headerNote={isSmuggler ? '黑市资金池 - 不入账' : undefined}
          />
        </div>
      </Window.Content>
    </Window>
  );
};

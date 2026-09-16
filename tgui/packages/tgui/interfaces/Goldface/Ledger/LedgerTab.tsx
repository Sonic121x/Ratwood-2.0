import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  pageStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
} from '../../common/parchment';
import type { FundLogEntry, HarborData } from '../types';

const labelStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: SEAL_AMBER,
  letterSpacing: '0.04em',
};

const valueStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: INK,
};

const noteStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  fontStyle: 'italic' as const,
  color: INK_SOFT,
  lineHeight: 1.4,
};

const BalanceCard = (props: { balance: number }) => (
  <div
    style={{
      ...cardStyle,
      marginTop: '4px',
      marginBottom: '6px',
      padding: '4px 12px',
      display: 'grid',
      gridTemplateColumns: '1fr auto',
      alignItems: 'baseline',
      columnGap: '12px',
    }}
  >
    <span style={labelStyle}>商人基金余额</span>
    <span
      style={{
        fontFamily: SERIF,
        fontSize: '18px',
        fontWeight: 'bold',
        color: INK,
      }}
    >
      {props.balance}m
    </span>
  </div>
);

const StatRow = (props: { label: string; value: string; tone?: string }) => (
  <>
    <span style={{ color: INK }}>{props.label}</span>
    <span
      style={{
        ...valueStyle,
        textAlign: 'right',
        fontWeight: 'bold',
        color: props.tone || INK,
      }}
    >
      {props.value}
    </span>
  </>
);

const FundLogRow = (props: { entry: FundLogEntry }) => {
  const { entry } = props;
  const color = entry.amount >= 0 ? SEAL_GREEN : SEAL_RED;
  const sign = entry.amount >= 0 ? '+' : '';
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'minmax(0, 1fr) 80px',
        columnGap: '8px',
        padding: '3px 4px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontSize: FONT_BODY,
        color: INK,
      }}
    >
      <span
        style={{
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}
      >
        {entry.source}
      </span>
      <span style={{ textAlign: 'right', color, fontWeight: 'bold' }}>
        {sign}
        {entry.amount}m
      </span>
    </div>
  );
};

export const LedgerTab = (props: { harbor?: HarborData }) => {
  const { harbor } = props;
  if (!harbor) {
    return (
      <div style={pageStyle}>
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          账簿尚未拟就.
        </div>
      </div>
    );
  }
  const ledger = harbor.ledger;
  return (
    <div style={pageStyle}>
      <BalanceCard balance={ledger.merchant_fund_balance} />

      <div
        style={{
          ...cardStyle,
          marginTop: '0',
          marginBottom: '6px',
          padding: '6px 12px',
        }}
      >
        <div
          style={{ ...sectionHeaderStyle, marginTop: 0, marginBottom: '4px' }}
        >
          本周审计
        </div>
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '1fr auto',
            rowGap: '4px',
            columnGap: '12px',
            paddingTop: '4px',
          }}
        >
          <StatRow
            label="已征收的商人征缴"
            value={`+${ledger.levy_collected}m`}
            tone={SEAL_GREEN}
          />
          <StatRow
            label="就征缴缴纳的王室关税"
            value={`-${ledger.levy_taxed}m`}
            tone={SEAL_RED}
          />
          <StatRow
            label="公司侏儒加价"
            value={`+${ledger.gnome_margin_collected}m`}
            tone={SEAL_GREEN}
          />
        </div>
        <div style={{ ...noteStyle, marginTop: '6px' }}>
          所有入账都会存入你在颌口金库的商人基金. 王室按现行
          出口税率对征缴征税; 侏儒加价则按所列的银面
          费率抽取.
        </div>
      </div>

      <div
        style={{
          ...cardStyle,
          marginTop: '0',
          marginBottom: '6px',
          padding: '6px 12px',
        }}
      >
        <div
          style={{ ...sectionHeaderStyle, marginTop: 0, marginBottom: '4px' }}
        >
          近期基金变动
        </div>
        {ledger.fund_log.length === 0 ? (
          <div style={{ ...noteStyle, padding: '4px 0' }}>
            本周尚无变动记录.
          </div>
        ) : (
          ledger.fund_log.map((entry, idx) => (
            <FundLogRow key={idx} entry={entry} />
          ))
        )}
        {ledger.fund_log.length > 0 && (
          <div style={{ ...noteStyle, marginTop: '6px' }}>
            最新在前. 超过十二条的旧记录会滚出.
          </div>
        )}
      </div>

      <div
        style={{
          ...cardStyle,
          marginTop: '0',
          marginBottom: '6px',
          padding: '6px 12px',
        }}
      >
        <div
          style={{ ...sectionHeaderStyle, marginTop: 0, marginBottom: '4px' }}
        >
          银面加价
        </div>
        {harbor.favor.gnome_unlocked ? (
          <>
            <div style={{ ...noteStyle, marginBottom: '4px' }}>
              凭费伦提亚侏儒挑夫行会的令状, 公共摊位
              如今由他们经手. 他们以劳力抵偿成本, 并将每笔
              销售的加价 <b>+{ledger.silverface_margin_percent}%</b> 上缴
              商人基金. 你可视需要在管理
              标签页调整该费率.
            </div>
            <div
              style={{
                color: INK_FAINT,
                fontSize: FONT_BODY,
                fontStyle: 'italic',
              }}
            >
              加价越重, 每笔销售为基金带来的收益越多; 加价越轻,
              则能吸引更多买家光顾摊位.
            </div>
          </>
        ) : (
          <div style={noteStyle}>
            依长期契约, 费伦提亚挑夫与装卸工行会每周
            按固定的贸易额提取加价. 若你经公司账簿
            推动足够的货物流通, 你的声望将
            为你赢得召来其侏儒的权利 - 他们只以
            劳力为酬, 并将加价上缴你的基金.
          </div>
        )}
      </div>
    </div>
  );
};

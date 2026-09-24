import {
  FONT_BODY,
  SEAL_GREEN,
  SEAL_RED,
  subtitleStyle,
} from '../common/parchment';
import {
  Breakdown,
  compactCardStyle,
  dividerStyle,
  formatPct,
  Row,
  SectionTitle,
  twoColTable,
  twoColumnLayout,
} from './styles';
import type { TreasurySnapshot } from './types';

type Props = {
  t: TreasurySnapshot;
  balance: number;
};

const RevenueColumn = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="初始国库余额" value={t.starting} />
          <Row label="已收乡村税" value={t.rural_taxes} />
          <Row label="已收人头税" value={t.poll.total} />
        </tbody>
      </table>
      <Breakdown>
        贵族 {t.poll.noble} &bull; 神职人员 {t.poll.clergy} &bull; 审判庭{' '}
        {t.poll.inquisition} &bull; 廷臣 {t.poll.courtier} &bull; 驻军{' '}
        {t.poll.garrison} &bull; 公会 {t.poll.guilds} &bull; 商人{' '}
        {t.poll.merchant} &bull; 市民 {t.poll.burgher} &bull; 冒险者{' '}
        {t.poll.adventurer} &bull; 佣兵 {t.poll.mercenary} &bull; 农民{' '}
        {t.poll.peasant}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="已收王室罚款" value={t.fines_income} />
          <Row label="已收王室税款" value={t.royal.total} />
        </tbody>
      </table>
      <Breakdown>
        契约税 {t.royal.contract_levy} &bull; 食首税{' '}
        {t.royal.headeater_levy} &bull; 进口关税 {t.royal.import_tariff}{' '}
        &bull; 出口税 {t.royal.export_duty} &bull; 其他{' '}
        {t.royal.other_fees}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="库存出口额" value={t.stockpile_exports} />
          <Row label="库存销售收入" value={t.stockpile_revenue} />
          <Row
            label="直接进口额"
            value={t.stockpile_direct_imports}
          />
          <Row label="常备订单收入" value={t.standing.revenue} />
        </tbody>
      </table>
      <Breakdown>
        {t.standing.fulfilled} 份已完成 &bull; {t.standing.expired} 份已过期{' '}
        &bull; {t.standing.petitioned} 份已请愿（消耗
        {t.standing.petition_pledge_spent} 点认捐）
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="提前解除的短缺" value={t.shortages_ended} />
        </tbody>
      </table>
      <div style={dividerStyle} />
      <table style={twoColTable}>
        <tbody>
          <Row label="总收入" value={t.total_revenue} color={SEAL_GREEN} />
        </tbody>
      </table>
    </div>
  );
};

const ExpensesColumn = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  const debtLabel = t.bankruptcy_count > 0 ? '破产接管' : '拖欠债务';
  const debtColor = t.bankruptcy_count > 0 ? '#c0392b' : '#e07b39';
  const debtPieces = [
    t.arrears_count > 0 ? `${t.arrears_count} 次拖欠` : '',
    t.bankruptcy_count > 0 ? `${t.bankruptcy_count} 次破产` : '',
  ].filter(Boolean);
  const debtValue = debtPieces.join(', ');
  const showDebtRow =
    t.bankruptcy_count > 0 ||
    t.arrears_count > 0 ||
    t.treasury_debt_repaid > 0 ||
    t.treasury_debt_owed > 0;
  const showForfeiture = t.forfeiture_amount > 0 || t.forfeiture_count > 0;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="薪资支出" value={t.wages_paid} />
          <Row label="国库转账" value={t.treasury_transfers} />
          <Row label="库存进口额" value={t.stockpile_imports} />
          <Row
            label="匪患损失"
            value={t.banditry_losses}
            color={SEAL_RED}
          />
        </tbody>
      </table>
      {t.banditry_owed > 0 && (
        <Breakdown>尚欠 {t.banditry_owed}</Breakdown>
      )}
      {showDebtRow && (
        <table style={twoColTable}>
          <tbody>
            <Row label={debtLabel} value={debtValue} color={debtColor} />
          </tbody>
        </table>
      )}
      {(t.treasury_debt_repaid > 0 || t.treasury_debt_owed > 0) && (
        <Breakdown>
          {t.treasury_debt_repaid > 0 && `已偿还 ${t.treasury_debt_repaid}`}
          {t.treasury_debt_repaid > 0 && t.treasury_debt_owed > 0 && ', '}
          {t.treasury_debt_owed > 0 && `尚欠 ${t.treasury_debt_owed}`}
        </Breakdown>
      )}
      {showForfeiture && (
        <>
          <table style={twoColTable}>
            <tbody>
              <Row label="没收款项" value={`${t.forfeiture_amount}玛门`} />
            </tbody>
          </table>
          {t.forfeiture_count > 0 && (
            <Breakdown>
              来自 {t.forfeiture_count} 名离任的城堡内部人员
              {t.forfeiture_count === 1 ? '' : ''}
            </Breakdown>
          )}
        </>
      )}
      <table style={twoColTable}>
        <tbody>
          <Row label="豁免税费总额" value={t.exempt.total} />
        </tbody>
      </table>
      <Breakdown>
        契约税 {t.exempt.contract} &bull; 食首税 {t.exempt.headeater}{' '}
        &bull; 进口税 {t.exempt.import} &bull; 出口税 {t.exempt.export}{' '}
        &bull; 罚款 {t.exempt.fines} &bull; 人头税 {t.exempt.poll_tax}
      </Breakdown>
      <div style={dividerStyle} />
      <table style={twoColTable}>
        <tbody>
          <Row label="总支出" value={t.total_expenses} color={SEAL_RED} />
        </tbody>
      </table>
    </div>
  );
};

const RealmInsight = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  const netColor = t.net_treasury >= 0 ? SEAL_GREEN : SEAL_RED;
  const tradeColor = t.trade_balance >= 0 ? SEAL_GREEN : SEAL_RED;
  const netSign = t.net_treasury >= 0 ? '+' : '';
  const tradeSign = t.trade_balance >= 0 ? '+' : '';
  return (
    <div
      style={{
        ...subtitleStyle,
        marginTop: '6px',
        marginBottom: 0,
        textAlign: 'left',
        fontSize: FONT_BODY,
      }}
    >
      <table style={twoColTable}>
        <tbody>
          <Row
            label="国库净收支"
            value={`${netSign}${t.net_treasury}`}
            color={netColor}
          />
          <Row
            label="贸易差额"
            value={`${tradeSign}${t.trade_balance}`}
            color={tradeColor}
          />
          <Row label="对外贸易总额" value={t.foreign_trade_volume} />
          <Row
            label="实际税率"
            value={formatPct(t.effective_tax_rate)}
          />
          <Row label="豁免占比" value={formatPct(t.exemption_share)} />
        </tbody>
      </table>
    </div>
  );
};

export const TreasurySection = (props: Props) => {
  const { t, balance } = props;
  return (
    <div style={compactCardStyle}>
      <SectionTitle>领地国库 - 余额： {balance}</SectionTitle>
      <div style={twoColumnLayout}>
        <RevenueColumn t={t} />
        <ExpensesColumn t={t} />
      </div>
      <RealmInsight t={t} />
    </div>
  );
};

import { SEAL_RED } from '../common/parchment';
import {
  Breakdown,
  columnSubheadStyle,
  compactCardStyle,
  Row,
  SectionTitle,
  threeColumnLayout,
  twoColTable,
} from './styles';
import type { EconomySnapshot } from './types';

type Props = {
  e: EconomySnapshot;
};

const GeneralMammonsColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>玛门收支概况</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="流通玛门" value={e.mammons_held} />
          <Row label="存入玛门" value={e.mammons_deposited} />
          <Row label="取出玛门" value={e.mammons_withdrawn} />
          <Row label="贵族领地收入" value={e.noble_income} />
          <Row label="浴场金库收入" value={e.bathmatron_vault} />
          <Row label="向库存出售所得" value={e.sold_to_stockpile} />
          <Row label="行商收入" value={e.peddler} />
        </tbody>
      </table>
    </div>
  );
};

const RoyalCrownColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>王室 &amp; 王权</div>
      <table style={twoColTable}>
        <tbody>
          <Row
            label="已收商人征缴"
            value={e.merchant_levy_collected}
          />
          <Row label="征缴中的王室税" value={e.merchant_levy_taxed} />
          <Row
            label="逃缴王室税款"
            value={e.taxes_evaded}
            color={SEAL_RED}
          />
        </tbody>
      </table>
      <div style={{ ...columnSubheadStyle, marginTop: '6px' }}>售货机</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="金面进口额" value={e.goldface} />
          <Row label="银面进口额" value={e.silverface} />
          <Row label="铜面进口额" value={e.copperface} />
          <Row label="纯净进口额" value={e.purity} />
        </tbody>
      </table>
    </div>
  );
};

const TradeMarketsColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>贸易 &amp; 市场</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="出口总值" value={e.trade_exported_total} />
        </tbody>
      </table>
      <Breakdown>
        正规市场 {e.trade_exported_real} &bull; 黑市{' '}
        {e.trade_exported_bm}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="进口总值" value={e.trade_imported} />
          <Row label="公司侏儒加价收入" value={e.gnome_margin} />
          <Row label="恩惠 - 送行" value={e.favor_from_sendoffs} />
          <Row label="恩惠 - 引航机" value={e.favor_from_navigator} />
          <Row label="恩惠 - 金面" value={e.favor_from_goldface} />
          <Row label="恩惠 - 银面" value={e.favor_from_silverface} />
          <Row
            label="恩惠 - 惩罚扣除"
            value={e.favor_penalties}
            color={SEAL_RED}
          />
          <Row label="恩惠 - 历史峰值" value={e.favor_high} />
        </tbody>
      </table>
    </div>
  );
};

export const EconomySection = (props: Props) => {
  return (
    <div style={compactCardStyle}>
      <SectionTitle>经济概况</SectionTitle>
      <div style={threeColumnLayout}>
        <GeneralMammonsColumn e={props.e} />
        <RoyalCrownColumn e={props.e} />
        <TradeMarketsColumn e={props.e} />
      </div>
    </div>
  );
};

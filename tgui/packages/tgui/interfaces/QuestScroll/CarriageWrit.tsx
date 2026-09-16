import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const CarriageWrit = (props: {
  realm: string;
  circumstance?: string;
  pickupRegion?: string | null;
  destination?: string | null;
  deliveryItem?: string | null;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const {
    realm,
    circumstance,
    pickupRegion,
    destination,
    deliveryItem,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    rulerTitle,
    issuedBy,
    issuedOn,
    bearer,
  } = props;
  const dest = destination || '其指定受领人';
  const pickup = pickupRegion || realm;
  const what = deliveryItem ? `一包 ${deliveryItem}` : '一封缄封之包裹';
  return (
    <>
      <p style={writParagraph}>
        <i>兹依 {rulerTitle} 之令状晓谕:</i>
      </p>
      <p style={writParagraph}>
        {what} 待自 {pickup} 运送至 <b>{dest}</b>. 持此
        令状者于运送期间在公爵大道上
        享有安全通行之权.
      </p>
      {circumstance && <p style={writParagraph}>{circumstance}</p>}
      <p style={writParagraph}>
        交付包裹后, 将此令状交回契约台账; 所悬之
        赏金{' '}
        <RewardClause
          reward={reward}
          levyRate={levyRate}
          levyExempt={levyExempt}
          guildCutRate={guildCutRate}
        />{' '}
        即可领取.
      </p>
      <p style={writParagraph}>
        令状识得此包裹, 待运送完成之时
        自会留痕.
      </p>
      <SealLine
        rulerTitle={rulerTitle}
        issuedBy={issuedBy}
        issuedOn={issuedOn}
        bearer={bearer}
      />
    </>
  );
};

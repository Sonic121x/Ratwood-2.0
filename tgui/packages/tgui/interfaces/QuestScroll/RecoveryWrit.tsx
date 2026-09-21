import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const RecoveryWrit = (props: {
  realm: string;
  circumstance?: string;
  pickupRegion?: string | null;
  fetchItem?: string | null;
  fetchCount?: number;
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
    fetchItem,
    fetchCount,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    rulerTitle,
    issuedBy,
    issuedOn,
    bearer,
  } = props;
  const region = pickupRegion || realm;
  const itemLabel =
    fetchItem && fetchCount && fetchCount > 1
      ? `${fetchCount} ${fetchItem}s`
      : fetchItem
        ? `一件 ${fetchItem}`
        : '国度之货物';
  return (
    <>
      <p style={writParagraph}>
        <i>兹依 {rulerTitle} 之令状晓谕:</i>
      </p>
      {circumstance && <p style={writParagraph}>{circumstance}</p>}
      <p style={writParagraph}>
        凡自 {region} 寻回 {itemLabel} 并将其送至
        契约台账者, 可得赏金{' '}
        <RewardClause
          reward={reward}
          levyRate={levyRate}
          levyExempt={levyExempt}
          guildCutRate={guildCutRate}
        />
        .
      </p>
      <p style={writParagraph}>
        令状识得此货物, 事成之时自会留痕.
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

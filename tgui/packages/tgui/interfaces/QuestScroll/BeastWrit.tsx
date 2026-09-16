import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const BeastWrit = (props: {
  nameSingular?: string | null;
  realm: string;
  crimes: string[];
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
  hasRecoveryAddendum?: boolean;
  recoveryShipment?: string | null;
  recoveryDestination?: string | null;
  recoveryCircumstance?: string;
}) => {
  const {
    nameSingular,
    realm,
    crimes,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    rulerTitle,
    issuedBy,
    issuedOn,
    bearer,
    hasRecoveryAddendum,
    recoveryShipment,
    recoveryDestination,
    recoveryCircumstance,
  } = props;
  const beast = nameSingular || '野兽';
  const deeds =
    crimes && crimes.length > 0 ? (
      <>
        其曾犯下{' '}
        {crimes.map((c, i) => (
          <span key={i}>
            {c}
            {i < crimes.length - 2 ? ', ' : i === crimes.length - 2 ? ', 及 ' : ''}
          </span>
        ))}
        .
      </>
    ) : null;
  return (
    <>
      <p style={writParagraph}>
        一头 {beast} 正祸害 {realm}, 令乡野大受其苦.
      </p>
      {deeds && <p style={writParagraph}>{deeds}</p>}
      <p style={writParagraph}>
        令状识得此兽, 事成之时自会留痕.
        届时将其交回契约台账, 所悬之赏金{' '}
        <RewardClause
          reward={reward}
          levyRate={levyRate}
          levyExempt={levyExempt}
          guildCutRate={guildCutRate}
        />{' '}
        即可领取.
      </p>
      {hasRecoveryAddendum && (
        <RecoveryAddendum
          shipment={recoveryShipment}
          destination={recoveryDestination}
          circumstance={recoveryCircumstance}
          category="beast"
        />
      )}
      <SealLine
        rulerTitle={rulerTitle}
        issuedBy={issuedBy}
        issuedOn={issuedOn}
        bearer={bearer}
      />
    </>
  );
};

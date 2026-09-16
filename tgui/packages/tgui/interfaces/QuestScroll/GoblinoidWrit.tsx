import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { caputLupinum, writParagraph } from './shared';

export const GoblinoidWrit = (props: {
  realm: string;
  rulerTitle: string;
  groupWord?: string | null;
  namePlural?: string | null;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
  hasRecoveryAddendum?: boolean;
  recoveryShipment?: string | null;
  recoveryDestination?: string | null;
  recoveryCircumstance?: string;
}) => {
  const {
    realm,
    rulerTitle,
    groupWord,
    namePlural,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    issuedBy,
    issuedOn,
    bearer,
    hasRecoveryAddendum,
    recoveryShipment,
    recoveryDestination,
    recoveryCircumstance,
  } = props;
  const folk = namePlural || '孽种';
  const band = groupWord || '战团';
  return (
    <>
      <p style={writParagraph}>
        <i>兹依 {rulerTitle} 之令状张布此告示:</i>
      </p>
      <p style={writParagraph}>
        一伙 {band} <b>{folk}</b> 侵扰 {realm} 之地.
        此乃暗星之孽种, 向伪神歌唱, 不服任何律法.
        此类之物无名可召, 无誓可违,
        无魂可称.
      </p>
      <p style={writParagraph}>
        <span style={caputLupinum}>尽诛之</span>, 连根拔起,
        于其巢穴之处. 令状识得此巢, 事成之时
        自会留痕.
      </p>
      <p style={writParagraph}>
        将此令状交回契约台账, 所悬之赏金{' '}
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
          category="goblinoid"
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

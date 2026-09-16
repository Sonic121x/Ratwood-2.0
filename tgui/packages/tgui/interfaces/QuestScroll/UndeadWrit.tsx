import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const UndeadWrit = (props: {
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
  const folk = namePlural || '不宁亡者';
  const host = groupWord || '一群';

  return (
    <>
      <p style={writParagraph}>
        <i>依 {rulerTitle} 之令状, 由内克拉掌管:</i>
      </p>
      <p style={writParagraph}>
        亡者再行于 {realm} 之上. 一群 {host} {folk}, 被夺去
        应得之安息, 自泥土与坟冢中躁动而起. 其等
        无名可称, 无誓可违, 无魂可量: 唯有那道
        尚未愈合之伤.
      </p>
      <p style={writParagraph}>
        <i>
          赐彼永恒之安息. 彼等不应被憎恨. 当将其交还
          内克拉的掌管之中, 使她的帷幕再度
          覆于他们之上.
        </i>
      </p>
      <p style={writParagraph}>
        以钢铁, 以火焰, 以祈祷将其击倒. 令状识得
        其躁动, 待安宁复归之时自会留痕. 将此
        令状交回契约台账, 所悬之赏金{' '}
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
          category="undead"
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

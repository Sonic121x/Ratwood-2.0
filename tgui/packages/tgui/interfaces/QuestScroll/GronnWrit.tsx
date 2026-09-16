import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import {
  capitalize,
  caputLupinum,
  indictmentItem,
  indictmentList,
  writParagraph,
} from './shared';

export const GronnWrit = (props: {
  realm: string;
  rulerTitle: string;
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  namePlural?: string | null;
  crimes: string[];
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
    named,
    ringleader,
    groupWord,
    namePlural,
    crimes,
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
  const folk = namePlural || '劫掠者';
  const band = groupWord || '战团';

  let subject: React.ReactNode;
  if (named) subject = <b>{named}</b>;
  else if (ringleader)
    { subject = (
      <>
        一队 {band} {folk}, 其首名为 <b>{ringleader}</b>
      </>
    ); }
  else subject = <>一队 {band} {folk}</>;

  return (
    <>
      <p style={writParagraph}>
        <i>兹晓谕所有为 {realm} 执兵御敌之人:</i>
      </p>
      <p style={writParagraph}>
        查 {subject} 已现于此岸, 宣誓效忠伪
        四神, 拒受十神之圣油.
      </p>
      {crimes.length > 0 && (
        <>
          <p style={{ ...writParagraph, marginBottom: '4px' }}>
            其等所被控之罪如下:
          </p>
          <ul style={indictmentList}>
            {crimes.map((c, i) => (
              <li key={i} style={indictmentItem}>
                {capitalize(c)};
              </li>
            ))}
          </ul>
        </>
      )}
      <p style={writParagraph}>
        依 {rulerTitle} 之令状, 并经教廷之谏议,
        判 {subject} 为{' '}
        <span style={caputLupinum}>绝罚</span>: 自信徒之体中
        割除, 无殿可容, 无祭司为之哀悼. 追之于
        滩岸与崖壁; 勿使其在钢铁及身之前
        入海.
      </p>
      <p style={writParagraph}>
        其等身死之时, 令状自会沉寂留痕; 届时
        将其交回契约台账, 所悬之赏金{' '}
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
          category="gronn"
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

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

export const DrowWrit = (props: {
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
  const folk = namePlural || '卓尔';
  const band = groupWord || '巡逻队';

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
        <i>兹依 {rulerTitle} 与教廷之令状:</i>
      </p>
      <p style={writParagraph}>
        查 {subject} 已自幽深之暗处现身于{' '}
        {realm} 之地: 此辈背弃阿斯特拉塔, 交易受缚之魂, 贩卖奴隶
        并与大敌勾连.
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
        任何人皆不得与其谈判, 不得与其交易, 亦不得有
        司祭听其恳求. 依 {rulerTitle} 之令状与教廷之
        谏议, {subject} 当被判处
        <span style={caputLupinum}>处以绝罚</span>: 在十神面前受诅,
        被逐出阳光与谷物, 既不享休战, 亦不得赎金.
      </p>
      <p style={writParagraph}>
        见之即杀, 焚其所携之物, 以免其身上
        之秽气污染大地. 其等身死之时, 令状自会
        沉寂留痕; 将其交回契约台账, 所悬之
        赏金{' '}
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
          category="drow"
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

import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import {
  capitalize,
  caputLupinum,
  CONDEMNATION_CAPUT_LUPINUM,
  CONDEMNATION_UTLAGATUS,
  CONDEMNATION_VOLKOMIR,
  indictmentItem,
  indictmentList,
  sacralPlea,
  writParagraph,
} from './shared';

export const WritOpening = (props: { realm: string }) => (
  <p style={writParagraph}>
    <i>兹晓谕所有为 {props.realm} 执兵御敌之人:</i>
  </p>
);

export const SummonsClause = (props: {
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  namePlural?: string | null;
  realm: string;
}) => {
  const { named, ringleader, groupWord, namePlural, realm } = props;
  const courts = `${realm} 的法庭`;
  let body: React.ReactNode;
  if (named) {
    body = (
      <>
        该 <b>{named}</b> 已三度受传唤至 {courts}, 却
        未有一次应召到庭.
      </>
    );
  } else if (ringleader && groupWord && namePlural) {
    body = (
      <>
        一{groupWord} {namePlural} 聚集在名为 <b>{ringleader}</b> 者
        之下, 已三度受传唤至 {courts}, 而首恶
        及其任何同伙皆未应召到庭.
      </>
    );
  } else if (groupWord && namePlural) {
    body = (
      <>
        一{groupWord} {namePlural} 已三度受传唤至 {courts}
        , 却无人应召到庭.
      </>
    );
  } else {
    body = <>被告已三度受传唤, 却未应召到庭.</>;
  }
  return <p style={writParagraph}>{body}</p>;
};

export const IndictmentList = (props: { crimes: string[] }) => {
  if (!props.crimes || props.crimes.length === 0) return null;
  return (
    <>
      <p style={{ ...writParagraph, marginBottom: '4px' }}>
        其等所被控之罪如下:
      </p>
      <ul style={indictmentList}>
        {props.crimes.map((c, i) => (
          <li key={i} style={indictmentItem}>
            {capitalize(c)};
          </li>
        ))}
      </ul>
    </>
  );
};

export const SacralPlea = (props: { rulerTitle: string }) => (
  <p style={sacralPlea}>
    为此, 十神的诸神殿已向 {props.rulerTitle} 请愿,
    望此事速速办妥, 以免更多亵渎使罪愆愈积愈重.
  </p>
);

type CondemnationProps = {
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  rulerTitle: string;
};

const subjectNoun = (
  named?: string | null,
  ringleader?: string | null,
  groupWord?: string | null,
) => {
  if (named) return <b>{named}</b>;
  if (ringleader)
    { return (
      <>
        <b>{ringleader}</b> 及其麾下所有随从
      </>
    ); }
  return <>此{groupWord ?? '匪帮'}之中的每一条性命</>;
};

const CondemnationCaputLupinum = (props: CondemnationProps) => {
  const { named, ringleader, groupWord, rulerTitle } = props;
  const subject = subjectNoun(named, ringleader, groupWord);
  const plural = !!ringleader || !named;
  return (
    <p style={writParagraph}>
      依 {rulerTitle} 之令状, 并经议会谏议, {subject}{' '}
      {plural ? '众人' : '此人'}被判处{' '}
      <span style={caputLupinum}>狼首之刑</span>, 即献上沃尔夫
      {plural ? '们的首级' : '的首级'}, 因沃尔夫
      乃人人憎恶之野兽.
    </p>
  );
};

const CondemnationUtlagatus = (props: CondemnationProps) => {
  const { named, ringleader, groupWord, rulerTitle } = props;
  const subject = subjectNoun(named, ringleader, groupWord);
  const plural = !!ringleader || !named;
  return (
    <p style={writParagraph}>
      依 {rulerTitle} 之令状, 并经议会谏议, {subject}{' '}
      {plural ? '众人' : '此人'}被判处{' '}
      <span style={caputLupinum}>法外之刑</span>, 逐出法外, 此后无人
      当供其面包, 火种与屋檐, 且凡庇护之者
      皆与其同罪.
    </p>
  );
};

const CondemnationVolkomir = (props: CondemnationProps) => {
  const { named, ringleader, groupWord, rulerTitle } = props;
  const subject = subjectNoun(named, ringleader, groupWord);
  return (
    <p style={writParagraph}>
      依 {rulerTitle} 之令状, 并经议会谏议, 判 {subject}{' '}
      名为 <span style={caputLupinum}>沃尔科米尔</span>, 即逐出国度安宁之沃尔夫. 将其
      逐出每一灶火与厅堂, 亲族不得收容, 友人不得哀悼.
    </p>
  );
};

export const CondemnationDeclaration = (
  props: CondemnationProps & { variant?: string },
) => {
  switch (props.variant) {
    case CONDEMNATION_UTLAGATUS:
      return <CondemnationUtlagatus {...props} />;
    case CONDEMNATION_VOLKOMIR:
      return <CondemnationVolkomir {...props} />;
    case CONDEMNATION_CAPUT_LUPINUM:
    default:
      return <CondemnationCaputLupinum {...props} />;
  }
};

export const CorruptionOfBloodClause = () => (
  <p style={{ ...writParagraph, fontStyle: 'italic' }}>
    又因其等背弃于拉沃克斯面前所立之誓, 其血被
    判为污浊: 其血脉之亲属不得承其名, 其地, 其荣,
    亦不得以血统主张任何头衔. 此污随血脉
    相传, 至其而止.
  </p>
);

export const LicenceToSlay = (props: {
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
}) => (
  <p style={writParagraph}>
    自今日起, 任何人皆可将其视作沃尔夫加以诛杀. 其等
    身死之时, 令状自会沉寂留痕; 届时将其交回
    契约台账, 所悬之赏金{' '}
    <RewardClause
      reward={props.reward}
      levyRate={props.levyRate}
      levyExempt={props.levyExempt}
      guildCutRate={props.guildCutRate}
    />{' '}
    即可领取.
  </p>
);

export const RecoveryAddendum = (props: {
  shipment?: string | null;
  destination?: string | null;
  circumstance?: string;
  category?: string | null;
}) => {
  const { shipment, destination, circumstance, category } = props;
  const what = shipment ? <b>{shipment}</b> : <>所失之货物</>;
  const dest = destination || '其合法保管人';
  let lead: React.ReactNode;
  switch (category) {
    case 'beast':
      lead = (
        <>
          再者: 野兽行凶之处散落着{what}, 已自
          合法运送途中失落.
        </>
      );
      break;
    case 'undead':
      lead = (
        <>
          再者: 亡者游荡之处散布着{what}, 于合法
          运送被劫之时遗落.
        </>
      );
      break;
    default:
      lead = (
        <>
          再者: 此伙匪类所掠之物中藏有{what}, 乃自
          合法运送途中夺取.
        </>
      );
  }
  return (
    <p style={writParagraph}>
      {lead} 寻回那封缄之包裹, 并将其送至 <b>{dest}</b>.
      {circumstance ? <> {circumstance}</> : null}
    </p>
  );
};

export const HumanoidWrit = (props: {
  realm: string;
  rulerTitle: string;
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  namePlural?: string | null;
  crimes: string[];
  sacralInvoked: boolean;
  oathBreach: boolean;
  condemnation?: string;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  hasRecoveryAddendum: boolean;
  recoveryShipment?: string | null;
  recoveryDestination?: string | null;
  recoveryCircumstance?: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => (
  <>
    <WritOpening realm={props.realm} />
    <SummonsClause
      named={props.named}
      ringleader={props.ringleader}
      groupWord={props.groupWord}
      namePlural={props.namePlural}
      realm={props.realm}
    />
    <IndictmentList crimes={props.crimes} />
    {props.sacralInvoked && <SacralPlea rulerTitle={props.rulerTitle} />}
    <CondemnationDeclaration
      variant={props.condemnation}
      named={props.named}
      ringleader={props.ringleader}
      groupWord={props.groupWord}
      rulerTitle={props.rulerTitle}
    />
    <LicenceToSlay
      reward={props.reward}
      levyRate={props.levyRate}
      levyExempt={props.levyExempt}
      guildCutRate={props.guildCutRate}
    />
    {props.oathBreach && <CorruptionOfBloodClause />}
    {props.hasRecoveryAddendum && (
      <RecoveryAddendum
        shipment={props.recoveryShipment}
        destination={props.recoveryDestination}
        circumstance={props.recoveryCircumstance}
        category="humanoid"
      />
    )}
    <SealLine
      rulerTitle={props.rulerTitle}
      issuedBy={props.issuedBy}
      issuedOn={props.issuedOn}
      bearer={props.bearer}
    />
  </>
);

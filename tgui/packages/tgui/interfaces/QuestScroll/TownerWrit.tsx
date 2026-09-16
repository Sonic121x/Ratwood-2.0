import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const TownerWrit = (props: {
  intro?: string;
  sealNote?: string;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const {
    intro,
    sealNote,
    reward,
    levyRate,
    levyExempt,
    rulerTitle,
    issuedBy,
    issuedOn,
    bearer,
  } = props;
  const showLevy = !levyExempt && levyRate > 0;
  const net = showLevy ? Math.round(reward * (1 - levyRate)) : reward;
  const posterName = issuedBy || '悬赏人';
  return (
    <>
      <p style={writParagraph}>
        <i>兹依 {posterName} 亲自签押用印晓谕:</i>
      </p>
      {!!intro && <p style={writParagraph}>{intro}</p>}
      {!!sealNote && <p style={writParagraph}>{sealNote}</p>}
      <p style={writParagraph}>
        此役持状人可得 <b>{reward} 玛门</b>
        {showLevy ? (
          <>
            , 扣除王室关税后为 <b>{net} 玛门</b>
          </>
        ) : null}
        .
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

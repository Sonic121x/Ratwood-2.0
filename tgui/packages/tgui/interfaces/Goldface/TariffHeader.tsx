import { PUBLIC_MARGIN_LABELS } from '../common/displayNames';
import {
  FONT_BODY,
  INK_FAINT,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { starsIfIlliterate } from './util';
type Props = {
  motto: string;
  canRead: boolean;
  tariffRatePct: number;
  tariffPaid: number;
  tariffEvaded: number;
  isProprietor: boolean;
  dodging: boolean;
  publicMarginPct?: number;
  publicMarginLabel?: string;
};

export const TariffHeader = (props: Props) => {
  const {
    motto,
    canRead,
    tariffRatePct,
    tariffPaid,
    tariffEvaded,
    isProprietor,
    dodging,
    publicMarginPct,
    publicMarginLabel,
  } = props;
  return (
    <>
      <div style={titleStyle}>{starsIfIlliterate(motto, canRead)}</div>
      <div style={subtitleStyle}>
        王室进口关税: <b>{tariffRatePct}%</b>
        {isProprietor && dodging && (
          <span style={{ color: SEAL_RED, marginLeft: '8px' }}>
            <b>(逃税中)</b>
          </span>
        )}
        {publicMarginPct !== undefined && (
          <span style={{ color: SEAL_AMBER, marginLeft: '8px' }}>
            · {PUBLIC_MARGIN_LABELS[publicMarginLabel || ''] || publicMarginLabel || '公共加价'}: <b>+{publicMarginPct}%</b>
          </span>
        )}
      </div>
      {isProprietor && (
        <div
          style={{
            textAlign: 'center',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            marginBottom: '4px',
          }}
        >
          <span style={{ color: SEAL_GREEN }}>已缴: {tariffPaid}m</span>
          <span style={{ color: INK_FAINT, margin: '0 6px' }}>·</span>
          <span style={{ color: SEAL_RED }}>逃漏: {tariffEvaded}m</span>
        </div>
      )}
      <div style={rulerStyle} />
    </>
  );
};

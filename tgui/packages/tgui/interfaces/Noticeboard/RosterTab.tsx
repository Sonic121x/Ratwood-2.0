import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { type MercenaryEntry, type TabProps } from './types';

export const RosterTab = ({ data }: TabProps) => {
  const roster = data.mercenary_roster;
  const total =
    (roster?.available_count ?? 0) +
    (roster?.contracted_count ?? 0) +
    (roster?.dnd_count ?? 0);

  return (
    <>
      <div
        style={{
          ...titleStyle,
          fontSize: '20px',
          marginTop: 6,
        }}
      >
        佣兵名册
      </div>
      <div style={subtitleStyle}>
        在佣兵行会登记者的姓名与简历
      </div>
      <hr style={rulerStyle} />

      {!roster || total === 0 ? (
        <EmptyMessage text="还没有佣兵登记在册." />
      ) : (
        <>
          <SummaryLine roster={roster} total={total} />
          {roster.available.length > 0 && (
            <RosterGroup
              label="可受雇佣"
              color={SEAL_GREEN}
              entries={roster.available}
            />
          )}
          {roster.contracted.length > 0 && (
            <RosterGroup
              label="已受雇佣"
              color={SEAL_AMBER}
              entries={roster.contracted}
            />
          )}
          {roster.dnd.length > 0 && (
            <RosterGroup
              label="谢绝打扰"
              color={SEAL_RED}
              entries={roster.dnd}
            />
          )}
        </>
      )}

      <div
        style={{
          color: INK_FAINT,
          textAlign: 'center',
          padding: '12px 0 4px 0',
          fontSize: FONT_BODY,
        }}
      >
        如需进一步联系, 请前往佣兵雕像.
      </div>
    </>
  );
};

const SummaryLine = ({
  roster,
  total,
}: {
  roster: TabProps['data']['mercenary_roster'];
  total: number;
}) => (
  <div
    style={{
      textAlign: 'center',
      fontSize: FONT_BODY,
      color: INK,
      padding: '4px 0 12px 0',
    }}
  >
    总计: <b>{total}</b>
    <span style={{ color: INK_FAINT }}> &middot; </span>
    <span style={{ color: SEAL_GREEN }}>
      可雇佣: {roster.available_count}
    </span>
    <span style={{ color: INK_FAINT }}> &middot; </span>
    <span style={{ color: SEAL_AMBER }}>
      已雇佣: {roster.contracted_count}
    </span>
    <span style={{ color: INK_FAINT }}> &middot; </span>
    <span style={{ color: SEAL_RED }}>
      谢绝打扰: {roster.dnd_count}
    </span>
  </div>
);

const RosterGroup = ({
  label,
  color,
  entries,
}: {
  label: string;
  color: string;
  entries: MercenaryEntry[];
}) => (
  <div style={{ marginBottom: 12 }}>
    <div style={{ marginBottom: 6 }}>
      <span style={badgeStyle(color)}>{label}</span>
    </div>
    {entries.map((m, i) => (
      <div
        key={i}
        style={{
          ...cardStyle,
          paddingTop: 4,
          paddingBottom: 4,
          marginBottom: 4,
        }}
      >
        <div style={{ fontFamily: SERIF, fontSize: FONT_BODY, color: INK }}>
          <b>{m.name}</b>
          <span
            style={{
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginLeft: 6,
            }}
          >
            ({m.advjob})
          </span>
        </div>
        {!!m.message && (
          <div
            style={{
              color: INK_SOFT,
              fontStyle: 'italic',
              fontSize: FONT_BODY,
              marginTop: 2,
            }}
          >
            &ldquo;{m.message}&rdquo;
          </div>
        )}
      </div>
    ))}
  </div>
);

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    {text}
  </div>
);

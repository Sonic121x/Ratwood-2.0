import type { CSSProperties } from 'react';

import {
  FONT_BODY,
  INK,
  INK_FAINT,
  SERIF,
} from '../common/parchment';
import {
  dashedHeaderStyle,
  detailPanelStyle,
  emptyHintStyle,
} from './parchment_calendar';
import type { CalendarEvent } from './shared';

const eventTitleStyle = (color: string): CSSProperties => ({
  fontFamily: SERIF,
  fontWeight: 'bold',
  fontSize: FONT_BODY,
  color: color || INK,
  marginBottom: '2px',
});

const eventDescStyle: CSSProperties = {
  fontSize: FONT_BODY,
  color: INK,
  marginBottom: '6px',
  lineHeight: 1.45,
};

const splitParagraphs = (text: string): string[] =>
  text.split(/\n{2,}/).map((p) => p.trim()).filter((p) => p.length > 0);

const eventSpanStyle: CSSProperties = {
  fontSize: FONT_BODY,
  color: INK_FAINT,
};

const eventRowStyle: CSSProperties = {
  marginBottom: '10px',
};

type DayDetailProps = {
  monthName: string;
  year: number;
  selectedDay: number | null;
  events: CalendarEvent[];
};

export const DayDetail = (props: DayDetailProps) => {
  const { monthName, year, selectedDay, events } = props;
  return (
    <div style={detailPanelStyle}>
      {selectedDay === null ? (
        <div style={emptyHintStyle}>点击日期查看当日节庆。</div>
      ) : (
        <>
          <div style={dashedHeaderStyle}>
            普赛顿纪元{year}年 {monthName}{selectedDay}日
          </div>
          {events.length === 0 ? (
            <div style={emptyHintStyle}>这一天没有节庆。</div>
          ) : (
            events.map((e) => (
              <div key={e.id} style={eventRowStyle}>
                <div style={eventTitleStyle(e.color_tag)}>{e.display_title || e.title}</div>
                {e.desc &&
                  splitParagraphs(e.desc).map((para, i) => (
                    <div key={i} style={eventDescStyle}>
                      {para}
                    </div>
                  ))}
                {e.duration_days > 1 && (
                  <div style={eventSpanStyle}>
                    {monthName}{e.day}日
                    {' - '}
                    {monthName}{e.day + e.duration_days - 1}日
                  </div>
                )}
              </div>
            ))
          )}
        </>
      )}
    </div>
  );
};

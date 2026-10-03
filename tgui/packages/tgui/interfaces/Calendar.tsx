import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { DayDetail } from './Calendar/DayDetail';
import { MonthGrid } from './Calendar/MonthGrid';
import { Nav } from './Calendar/Nav';
import { type CalendarData, eventsForDay } from './Calendar/shared';
import { WeekdayHeader } from './Calendar/WeekdayHeader';
import {
  FONT_BODY,
  INK_FAINT,
  pageStyle,
  rulerStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

const WRAP_NOTES = [
  '咦。我明明记得还是同一年。',
  '书页翻过，年份却没有。',
  '轮盘理应转动，年份却仍停在原处。',
  '普赛顿纪元1514年。有一个大公国建在——',
  '普赛顿纪元1514年。普赛顿纪元1514年。普赛顿纪元1514年。',
  '普赛顿？你在何处，普赛顿？年份依旧，世界却已不复往昔。',
  '我们以前不是来过这里吗？如此多熟悉的景色与面孔，心碎又愈合，人死去又复生。还是同一年？',
  '什么',
  '时间又一次折回了自身。',
];

const wrapNoteStyle = {
  textAlign: 'center' as const,
  fontStyle: 'italic' as const,
  color: INK_FAINT,
  fontSize: FONT_BODY,
  marginTop: '-4px',
  marginBottom: '8px',
};
const display_title = '日历';
export const Calendar = () => {
  const { act, data } = useBackend<CalendarData>();
  const {
    today_day,
    today_month,
    today_year,
    today_week,
    view_month,
    view_year,
    weekday_names,
    days_in_month,
    days_in_week,
    months,
    events,
    wrap_count,
  } = data;

  const [selectedDay, setSelectedDay] = useState<number | null>(null);

  const viewingToday =
    view_month === today_month && view_year === today_year;
  const currentMeta = months.find((m) => m.number === view_month);
  const monthName = currentMeta?.name ?? `第${view_month}月`;
  const seasonLine = currentMeta
    ? `${currentMeta.phase}${currentMeta.season}`
    : '';

  const detailDay = selectedDay ?? (viewingToday ? today_day : null);
  const detailEvents =
    detailDay !== null ? eventsForDay(events, detailDay) : [];

  const goPrev = () => {
    setSelectedDay(null);
    act('prev_month');
  };
  const goNext = () => {
    setSelectedDay(null);
    act('next_month');
  };
  const goToday = () => {
    setSelectedDay(null);
    act('today');
  };

  return (
    <Window width={620} height={680} title={display_title} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>国度历书</div>
          <div style={subtitleStyle}>普赛顿纪元{view_year}年</div>
          <hr style={rulerStyle} />

          <Nav
            monthName={monthName}
            seasonLine={seasonLine}
            showReturn={!viewingToday}
            onPrev={goPrev}
            onNext={goNext}
            onReturn={goToday}
          />

          {wrap_count > 0 && (
            <div style={wrapNoteStyle}>
              {WRAP_NOTES[Math.min(wrap_count - 1, WRAP_NOTES.length - 1)]}
            </div>
          )}

          <WeekdayHeader names={weekday_names} />

          <MonthGrid
            events={events}
            daysInMonth={days_in_month}
            daysInWeek={days_in_week}
            selectedDay={selectedDay}
            todayDay={today_day}
            todayWeek={today_week}
            viewingToday={viewingToday}
            onSelectDay={setSelectedDay}
          />

          <DayDetail
            monthName={monthName}
            year={view_year}
            selectedDay={detailDay}
            events={detailEvents}
          />
        </div>
      </Window.Content>
    </Window>
  );
};

import { useEffect, useRef, useState } from 'react';
import { BooleanLike } from 'tgui-core/react';
import { NativeButton } from '../components/Localized';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type DecreeCategory = 'ancient' | 'new';

type Decree = {
  id: string;
  name: string;
  year: number;
  category: DecreeCategory;
  mechanical: string;
  flavor: string;
};

type DecreeState = {
  id: string;
  active: BooleanLike;
  cooldown_left: number;
};

type Data = {
  decrees: Decree[];
  states: DecreeState[];
  revoke_used_today: BooleanLike;
  restore_used_today: BooleanLike;
};

const formatCooldown = (seconds: number): string => {
  if (seconds <= 0) return '';
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  if (m > 0) return `${m}分 ${s}秒`;
  return `${s}秒`;
};

const CATEGORY_LABELS: Record<DecreeCategory, string> = {
  ancient: '古老特许状',
  new: '新特许状',
};

const cardHeaderStyle: React.CSSProperties = {
  display: 'flex',
  alignItems: 'baseline',
  gap: '8px',
  marginBottom: '6px',
};

const cardTitleStyle: React.CSSProperties = {
  fontSize: FONT_TITLE,
  fontWeight: 'bold',
  color: INK,
  flex: 1,
};

const cardYearStyle: React.CSSProperties = {
  color: INK_FAINT,
  fontSize: FONT_BODY,
};

const mechanicalStyle: React.CSSProperties = {
  fontSize: FONT_BODY,
  color: INK,
  margin: '4px 0 6px',
};

const flavorToggleStyle: React.CSSProperties = {
  fontSize: FONT_BODY,
  color: INK_SOFT,
  cursor: 'pointer',
  userSelect: 'none',
  display: 'inline-block',
  marginTop: '2px',
};

const flavorBodyStyle: React.CSSProperties = {
  fontSize: FONT_BODY,
  color: INK,
  marginTop: '6px',
  whiteSpace: 'pre-wrap',
  borderTop: `1px dashed ${INK_FAINT}`,
  paddingTop: '6px',
  fontFamily: SERIF,
  lineHeight: 1.55,
};

const proclamationNoteStyle: React.CSSProperties = {
  textAlign: 'center',
  fontSize: FONT_BODY,
  color: SEAL_AMBER,
  margin: '4px 0 8px',
};

type DecreeCardProps = {
  decree: Decree;
  state: DecreeState | undefined;
  revokeUsed: boolean;
  restoreUsed: boolean;
  onToggle: () => void;
};

const CONFIRM_TIMEOUT_MS = 3000;

const DecreeCard = (props: DecreeCardProps) => {
  const { decree, state, revokeUsed, restoreUsed, onToggle } = props;
  const [expanded, setExpanded] = useState(false);
  const [armed, setArmed] = useState(false);
  const armedTimerRef = useRef<number | null>(null);
  const active = !!state?.active;
  const cooldownLeft = state?.cooldown_left ?? 0;
  const onCooldown = cooldownLeft > 0;
  const slotUsed = active ? revokeUsed : restoreUsed;
  const disabled = onCooldown || slotUsed;
  const tooltip = onCooldown
    ? `On cooldown: ${formatCooldown(cooldownLeft)}`
    : slotUsed
      ? active
        ? 'A revocation has already been proclaimed today.'
        : 'A restoration has already been proclaimed today.'
      : armed
        ? 'Click again to confirm. Auto-cancels in 3 seconds.'
        : active
          ? 'Suspend this decree'
          : 'Restore this decree';

  const statusColor = active ? SEAL_GREEN : SEAL_RED;
  const statusLabel = active ? '生效中' : '已暂停';
  const baseLabel = active ? '暂停' : '恢复';
  const buttonLabel = armed ? `确认${baseLabel}？` : baseLabel;
  const buttonColor = active ? SEAL_RED : SEAL_GREEN;

  useEffect(() => {
    return () => {
      if (armedTimerRef.current !== null) {
        window.clearTimeout(armedTimerRef.current);
      }
    };
  }, []);

  // Re-arm cancellation when state changes (e.g. toggle succeeded, button now means the opposite).
  useEffect(() => {
    setArmed(false);
    if (armedTimerRef.current !== null) {
      window.clearTimeout(armedTimerRef.current);
      armedTimerRef.current = null;
    }
  }, [active]);

  const handleClick = () => {
    if (disabled) return;
    if (!armed) {
      setArmed(true);
      armedTimerRef.current = window.setTimeout(() => {
        setArmed(false);
        armedTimerRef.current = null;
      }, CONFIRM_TIMEOUT_MS);
      return;
    }
    if (armedTimerRef.current !== null) {
      window.clearTimeout(armedTimerRef.current);
      armedTimerRef.current = null;
    }
    setArmed(false);
    onToggle();
  };

  return (
    <div style={cardStyle}>
      <div style={cardHeaderStyle}>
        <span style={cardTitleStyle}>{decree.name}</span>
        <span style={cardYearStyle}>{decree.year}年</span>
        <span style={badgeStyle(statusColor)}>{statusLabel}</span>
        <NativeButton
          type="button"
          style={inkButtonStyle({ color: buttonColor, disabled })}
          disabled={disabled}
          title={tooltip} display_title={onCooldown ? `冷却中：${formatCooldown(cooldownLeft)}` : slotUsed ? (active ? '今日已颁布过废止令。' : '今日已颁布过恢复令。') : armed ? '再次点击确认，3 秒后自动取消。' : active ? '暂停此法令' : '恢复此法令'}
          onClick={handleClick}
        >
          {buttonLabel}
        </NativeButton>
      </div>
      {decree.mechanical && (
        <div style={mechanicalStyle}>{decree.mechanical}</div>
      )}
      {onCooldown && (
        <div style={{ fontSize: FONT_BODY, color: SEAL_AMBER }}>
          冷却时间：{formatCooldown(cooldownLeft)}
        </div>
      )}
      {decree.flavor && (
        <>
          <span
            style={flavorToggleStyle}
            onClick={() => setExpanded((v) => !v)}
          >
            {expanded ? '▼ 收起特许状正文' : '▶ 阅读特许状正文'}
          </span>
          {expanded && <div style={flavorBodyStyle}>{decree.flavor}</div>}
        </>
      )}
    </div>
  );
};

export const DecreeSetter = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<DecreeCategory>('ancient');

  const stateById = Object.fromEntries(
    (data.states ?? []).map((s) => [s.id, s]),
  );
  const revokeUsed = !!data.revoke_used_today;
  const restoreUsed = !!data.restore_used_today;

  const decrees = data.decrees ?? [];
  const ancient = decrees.filter((d) => d.category === 'ancient');
  const newer = decrees.filter((d) => d.category === 'new');
  const visible = tab === 'ancient' ? ancient : newer;

  return (
    <Window
      width={620}
      height={720}
      title="Charters of the Realm" display_title="领地特许状"
      theme="parchment"
    >
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>领地特许状</div>
          <div style={subtitleStyle}>
            援引古老文书，或颁布新的特许状。
          </div>
          <hr style={rulerStyle} />

          {(revokeUsed || restoreUsed) && (
            <div style={proclamationNoteStyle}>
              {revokeUsed && '今日已颁布过废止令。 '}
              {restoreUsed && '今日已颁布过恢复令。 '}
              同类法令须待明日方可再次颁布。
            </div>
          )}

          <div style={tabBarStyle}>
            <div style={tabStyle(tab === 'ancient')} onClick={() => setTab('ancient')}>
              {CATEGORY_LABELS.ancient} ({ancient.length})
            </div>
            <div style={tabStyle(tab === 'new')} onClick={() => setTab('new')}>
              {CATEGORY_LABELS.new} ({newer.length})
            </div>
          </div>

          {visible.length === 0 ? (
            <div
              style={{
                textAlign: 'center',
                color: INK_SOFT,
                padding: '20px',
              }}
            >
              此类别暂无特许状。
            </div>
          ) : (
            visible.map((d) => (
              <DecreeCard
                key={d.id}
                decree={d}
                state={stateById[d.id]}
                revokeUsed={revokeUsed}
                restoreUsed={restoreUsed}
                onToggle={() => act('toggle', { id: d.id })}
              />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

import { useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type RosterEntry = {
  key: string;
  name: string;
  status: string;
  message: string;
  advjob: string;
  nom_de_guerre: string;
};

type Data = {
  is_merc: BooleanLike;
  is_adventurer: BooleanLike;
  is_wretch: BooleanLike;
  is_bathhouse: BooleanLike;
  my_key: string;
  message_char_limit: number;
  merc_status_options: string[];
  adv_status_options: string[];
  wretch_status_options: string[];
  mercenaries: RosterEntry[];
  adventurers: RosterEntry[];
  wretches: RosterEntry[];
};

type Tab = 'mercs' | 'adventurers' | 'wretches';

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const STATUS_COLOR: Record<string, string> = {
  Available: SEAL_GREEN,
  Contracted: SEAL_AMBER,
  Away: SEAL_BLUE,
  Resting: SEAL_AMBER,
  'On a Job': SEAL_AMBER,
  'Lying Low': SEAL_BLUE,
  'Do not Disturb': SEAL_RED,
};

const STATUS_LABELS: Record<string, string> = {
  Available: '可雇',
  Contracted: '已受雇',
  Away: '外出',
  Resting: '歇息',
  'On a Job': '执行任务中',
  'Lying Low': '蛰伏',
  'Do not Disturb': '请勿打扰',
};

const RosterRow = (props: {
  entry: RosterEntry;
  showAdvjob: boolean;
  action?: { label: string; onClick: () => void };
}) => {
  const { entry, showAdvjob, action } = props;
  const color = STATUS_COLOR[entry.status] || INK_SOFT;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '8px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          <b>{entry.name}</b>
          {showAdvjob && entry.advjob && (
            <span style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
              {' '}
              - {entry.advjob}
            </span>
          )}
        </div>
        {entry.message && (
          <div
            style={{
              fontSize: FONT_BODY,
              fontStyle: 'italic',
              color: INK_SOFT,
            }}
          >
            &ldquo;{entry.message}&rdquo;
          </div>
        )}
      </div>
      <span style={badgeStyle(color)}>
        {STATUS_LABELS[entry.status] || entry.status}
      </span>
      {action && (
        <button type="button" style={inkButtonStyle()} onClick={action.onClick}>
          {action.label}
        </button>
      )}
    </div>
  );
};

const OwnControls = (props: {
  myEntry: RosterEntry | undefined;
  registeredLabel: string;
  statusOptions: string[];
  setAction: string;
  editAction: string;
  extraButtons?: React.ReactNode;
  act: ActFn;
}) => {
  const {
    myEntry,
    registeredLabel,
    statusOptions,
    setAction,
    editAction,
    extraButtons,
    act,
  } = props;
  return (
    <div
      style={{
        ...cardStyle,
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
        marginBottom: '8px',
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: FONT_BODY, color: SEAL_AMBER }}>
          {registeredLabel}
        </div>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          状态:{' '}
          <b style={{ color: STATUS_COLOR[myEntry?.status || ''] || INK }}>
            {STATUS_LABELS[myEntry?.status || ''] || '未登记'}
          </b>
        </div>
        {myEntry?.message && (
          <div
            style={{
              fontSize: FONT_BODY,
              fontStyle: 'italic',
              color: INK_SOFT,
            }}
          >
            &ldquo;{myEntry.message}&rdquo;
          </div>
        )}
      </div>
      <select
        value={myEntry?.status || statusOptions[0]}
        onChange={(e) => act(setAction, { status: e.target.value })}
        style={{ ...inkButtonStyle(), fontFamily: SERIF }}
      >
        {statusOptions.map((s) => (
          <option key={s} value={s}>
            {STATUS_LABELS[s] || s}
          </option>
        ))}
      </select>
      <button
        type="button"
        style={inkButtonStyle()}
        onClick={() => act(editAction)}
      >
        编辑讯息
      </button>
      {extraButtons}
    </div>
  );
};

const MercTab = (props: { data: Data; act: ActFn }) => {
  const { data, act } = props;
  const myEntry = data.mercenaries.find((e) => e.key === data.my_key);
  const sortedByStatus = [...data.mercenaries].sort(
    (a, b) => a.status.localeCompare(b.status) || a.name.localeCompare(b.name),
  );
  return (
    <>
      {!!data.is_merc && (
        <OwnControls
          myEntry={myEntry}
          registeredLabel="佣兵名册"
          statusOptions={data.merc_status_options}
          setAction="set_merc_status"
          editAction="edit_merc_message"
          act={act}
        />
      )}

      <div
        style={{
          display: 'flex',
          gap: '8px',
          marginBottom: '8px',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('contact_merc')}
        >
          联络一名佣兵
        </button>
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('broadcast_mercs')}
        >
          向全体广播
        </button>
      </div>

      <div style={sectionHeaderStyle}>
        佣兵名册 ({data.mercenaries.length})
      </div>
      {data.mercenaries.length === 0 ? (
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
          }}
        >
          尚无佣兵登记.
        </div>
      ) : (
        sortedByStatus.map((entry) => (
          <RosterRow key={entry.key} entry={entry} showAdvjob />
        ))
      )}
    </>
  );
};

const AdventurerTab = (props: { data: Data; act: ActFn }) => {
  const { data, act } = props;
  const myEntry = data.adventurers.find((e) => e.key === data.my_key);
  const sortedByStatus = [...data.adventurers].sort(
    (a, b) =>
      (a.status === 'Available' ? 0 : 1) - (b.status === 'Available' ? 0 : 1) ||
      a.status.localeCompare(b.status) ||
      a.name.localeCompare(b.name),
  );
  return (
    <>
      {!!data.is_adventurer && (
        <OwnControls
          myEntry={myEntry}
          registeredLabel="冒险者大厅名册"
          statusOptions={data.adv_status_options}
          setAction="set_adv_status"
          editAction="edit_adv_message"
          extraButtons={
            myEntry && (
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => act('leave_adv')}
              >
                将我除名
              </button>
            )
          }
          act={act}
        />
      )}

      <div
        style={{
          ...subtitleStyle,
          fontSize: FONT_BODY,
          marginBottom: '8px',
          color: INK_SOFT,
        }}
      >
        冒险者在此处张贴以寻求工作. 任何人都可以给他们发送一条
        讯息; 他们无法通过这块石头反过来联络你.
      </div>

      <div style={{ marginBottom: '8px' }}>
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('pick_adventurer')}
        >
          联络一名冒险者
        </button>
      </div>

      <div style={sectionHeaderStyle}>
        冒险者名册 ({data.adventurers.length})
      </div>
      {data.adventurers.length === 0 ? (
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
          }}
        >
          尚无冒险者登记.
        </div>
      ) : (
        sortedByStatus.map((entry) => (
          <RosterRow
            key={entry.key}
            entry={entry}
            showAdvjob
            action={
              entry.status !== 'Do not Disturb'
                ? {
                    label: '发讯息',
                    onClick: () =>
                      act('contact_adventurer', { key: entry.key }),
                  }
                : undefined
            }
          />
        ))
      )}
    </>
  );
};

const WretchTab = (props: { data: Data; act: ActFn }) => {
  const { data, act } = props;
  const myEntry = data.wretches.find((e) => e.key === data.my_key);
  const sortedByStatus = [...data.wretches].sort(
    (a, b) => a.status.localeCompare(b.status) || a.name.localeCompare(b.name),
  );
  return (
    <>
      {!!data.is_wretch && (
        <OwnControls
          myEntry={myEntry}
          registeredLabel="弃民名册 (仅浴场可见此列表)"
          statusOptions={data.wretch_status_options}
          setAction="set_wretch_status"
          editAction="edit_wretch_message"
          extraButtons={
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('edit_wretch_nom')}
            >
              化名
            </button>
          }
          act={act}
        />
      )}

      <div
        style={{
          ...subtitleStyle,
          fontSize: FONT_BODY,
          marginBottom: '8px',
          color: INK_SOFT,
        }}
      >
        此名册仅对弃民与浴场人员可见. 浴场可以
        透过弃民所选定的化名与他们联络,
        以委托隐秘的差事.
      </div>

      {!!data.is_bathhouse && (
        <div style={{ marginBottom: '8px' }}>
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() => act('pick_wretch')}
          >
            联络一名弃民
          </button>
        </div>
      )}

      <div style={sectionHeaderStyle}>
        弃民名册 ({data.wretches.length})
      </div>
      {data.wretches.length === 0 ? (
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
          }}
        >
          尚无弃民登记.
        </div>
      ) : (
        sortedByStatus.map((entry) => (
          <RosterRow
            key={entry.key}
            entry={entry}
            showAdvjob={false}
            action={
              data.is_bathhouse &&
              entry.status !== 'Do not Disturb' &&
              entry.key !== data.my_key
                ? {
                    label: '发讯息',
                    onClick: () => act('contact_wretch', { key: entry.key }),
                  }
                : undefined
            }
          />
        ))
      )}
    </>
  );
};

export const Talkstatue = () => {
  const { act, data } = useBackend<Data>();
  const wretchVisible = !!data.is_wretch || !!data.is_bathhouse;
  const [tab, setTab] = useState<Tab>('mercs');
  const activeTab: Tab = tab === 'wretches' && !wretchVisible ? 'mercs' : tab;
  return (
    <Window width={620} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>会说话的雕像</div>
          <div style={subtitleStyle}>
            这块石头将以你的名义, 向路过之人开口.
          </div>
          <div style={rulerStyle} />

          <div style={tabBarStyle}>
            <div
              style={tabStyle(activeTab === 'mercs')}
              onClick={() => setTab('mercs')}
            >
              佣兵{' '}
              {data.mercenaries.length > 0 && `(${data.mercenaries.length})`}
            </div>
            <div
              style={tabStyle(activeTab === 'adventurers')}
              onClick={() => setTab('adventurers')}
            >
              冒险者{' '}
              {data.adventurers.length > 0 && `(${data.adventurers.length})`}
            </div>
            {wretchVisible && (
              <div
                style={tabStyle(activeTab === 'wretches')}
                onClick={() => setTab('wretches')}
              >
                弃民{' '}
                {data.wretches.length > 0 && `(${data.wretches.length})`}
              </div>
            )}
          </div>

          {activeTab === 'mercs' && <MercTab data={data} act={act} />}
          {activeTab === 'adventurers' && (
            <AdventurerTab data={data} act={act} />
          )}
          {activeTab === 'wretches' && wretchVisible && (
            <WretchTab data={data} act={act} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

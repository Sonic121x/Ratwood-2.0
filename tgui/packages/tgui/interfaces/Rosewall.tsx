import { Dropdown } from 'tgui-core/components';
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
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type AdvertEntry = {
  key: string;
  name: string;
  status: string;
  message: string;
  advjob: string;
};

type Data = {
  is_bathhouse: BooleanLike;
  my_key: string;
  message_char_limit: number;
  status_options: string[];
  adverts: AdvertEntry[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const STATUS_DISPLAY: Record<string, { color: string; label: string }> = {
  Available: { color: SEAL_GREEN, label: '可接待' },
  Hired: { color: SEAL_AMBER, label: '已受雇' },
  'Do not Disturb': { color: SEAL_RED, label: '请勿打扰' },
};

const statusSortWeight = (status: string): number => {
  if (status === 'Available') return 0;
  if (status === 'Hired') return 1;
  return 2;
};

const AdvertRow = (props: {
  entry: AdvertEntry;
  isOwn: boolean;
  act: ActFn;
}) => {
  const { entry, isOwn, act } = props;
  const color = STATUS_DISPLAY[entry.status]?.color || INK_SOFT;
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
          {entry.advjob && (
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
      <span style={badgeStyle(color)}>{STATUS_DISPLAY[entry.status]?.label || entry.status}</span>
      <button
        type="button"
        style={inkButtonStyle()}
        onClick={() => act('examine_headshot', { key: entry.key })}
      >
        查看肖像
      </button>
      {!isOwn && entry.status !== 'Do not Disturb' && (
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('send_offer', { key: entry.key })}
        >
          发出邀约
        </button>
      )}
    </div>
  );
};

const OwnControls = (props: {
  myEntry: AdvertEntry | undefined;
  statusOptions: string[];
  act: ActFn;
}) => {
  const { myEntry, statusOptions, act } = props;
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
          浴场名册
        </div>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          状态：{' '}
          <b style={{ color: STATUS_DISPLAY[myEntry?.status || '']?.color || INK }}>
            {STATUS_DISPLAY[myEntry?.status || '']?.label || myEntry?.status || '尚未张贴'}
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
      <Dropdown
        width="150px"
        menuWidth="150px"
        selected={myEntry?.status || statusOptions[0]} displayText={STATUS_DISPLAY[myEntry?.status || statusOptions[0]]?.label}
        options={statusOptions.map((value) => ({ value, displayText: STATUS_DISPLAY[value]?.label || value }))}
        onSelected={(value) => act('set_status', { status: value })}
        style={{ margin: 0 }}
      />
      <button
        type="button"
        style={inkButtonStyle()}
        onClick={() => act('edit_advert')}
      >
        {myEntry ? '编辑告示' : '张贴告示'}
      </button>
      {myEntry && (
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('remove_advert')}
        >
          撤下告示
        </button>
      )}
    </div>
  );
};

export const Rosewall = () => {
  const { act, data } = useBackend<Data>();
  const myEntry = data.adverts.find((e) => e.key === data.my_key);
  const sortedAdverts = [...data.adverts].sort(
    (a, b) =>
      statusSortWeight(a.status) - statusSortWeight(b.status) ||
      a.name.localeCompare(b.name),
  );
  return (
    <Window display_title="蔷薇墙" width={620} height={600} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>蔷薇墙</div>
          <div style={subtitleStyle}>
            浴场侍者在此张贴了散发芬芳的纸笺。请随意浏览，
            向心仪之人发出邀约。
          </div>
          <div style={rulerStyle} />

          {!!data.is_bathhouse && (
            <OwnControls
              myEntry={myEntry}
              statusOptions={data.status_options}
              act={act}
            />
          )}

          <div style={sectionHeaderStyle}>
            已张贴的告示（{data.adverts.length}）
          </div>
          {data.adverts.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              还没有人张贴告示。
            </div>
          ) : (
            sortedAdverts.map((entry) => (
              <AdvertRow
                key={entry.key}
                entry={entry}
                isOwn={entry.key === data.my_key}
                act={act}
              />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

import { useLayoutEffect, useRef } from 'react';
import { Box, Button, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ShopRow = {
  id: number;
  name: string;
  description: string;
  cost: number;
  action: string;
  tier?: string;
  current?: number;
  blocked_reason?: string | null;
};

type Data = {
  points: number;
  spell_points: number;
  current_tab: string;
  busy: BooleanLike;
  tabs: { id: string; name: string }[];
  rows: ShopRow[];
  daily: {
    day: number;
    checked_in: BooleanLike;
    check_result: string;
    notice: string;
    offers: QuestRow[];
    active: QuestRow[];
  };
};

type QuestRow = {
  id: number;
  name: string;
  description: string;
  difficulty: string;
  reward: number;
  location: string;
  current: number;
  required: number;
  failed: BooleanLike;
  item_task: BooleanLike;
  carried: number;
  can_submit: BooleanLike;
  submit_blocked_reason?: string | null;
  tracking?: BooleanLike;
  tracking_hint?: string;
  track_blocked_reason?: string | null;
  party_size: number;
  hunt_timer_label?: string;
  hunt_timer_seconds?: number;
  blocked_reason?: string;
};

const QuestCard = ({
  quest,
  candidate,
}: {
  quest: QuestRow;
  candidate?: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const send = (action: string) =>
    act(action, { tab: 'quests', id: quest.id, day: data.daily.day });

  return (
    <Section title={quest.name}>
      <Box color="#e2c58b" mb={1}>
        {quest.difficulty} · {quest.reward} 积分
      </Box>
      <Box mb={1}>{quest.description}</Box>
      <Box color="label" mb={1}>
        目标地区：{quest.location}
        {quest.party_size > 0 && ` · 需要 ${quest.party_size} 人冒险团`}
      </Box>
      {!candidate && (
        <>
          <Box mb={1}>
            {quest.item_task
              ? `随身任务物品：${quest.carried} / ${quest.required}`
              : `击杀进度：${quest.current} / ${quest.required}`}
          </Box>
          <Box mb={1} color={quest.can_submit ? 'good' : 'label'}>
            {quest.can_submit
              ? '条件已满足，可在任意地点提交'
              : quest.submit_blocked_reason}
          </Box>
          {!!quest.tracking_hint && (
            <Box mb={1} color={quest.tracking ? '#e2c58b' : 'label'}>
              {quest.tracking ? '正在追踪：' : ''}
              {quest.tracking_hint}
            </Box>
          )}
        </>
      )}
      {quest.hunt_timer_seconds !== undefined && (
        <Box color="orange" mb={1}>
          {quest.hunt_timer_label}：{Math.floor(quest.hunt_timer_seconds / 60)}{' '}
          分 {quest.hunt_timer_seconds % 60} 秒
        </Box>
      )}
      {candidate ? (
        <Button
          disabled={!!data.busy || !!quest.blocked_reason}
          tooltip={quest.blocked_reason}
          onClick={() => send('quest_accept')}
        >
          {quest.blocked_reason || '接受任务'}
        </Button>
      ) : (
        <>
          <Button
            icon="location-arrow"
            selected={!!quest.tracking}
            disabled={
              !!data.busy || (!quest.tracking && !!quest.track_blocked_reason)
            }
            tooltip={
              quest.tracking
                ? '停止仅自己可见的头顶指引'
                : quest.track_blocked_reason ||
                  '显示私人箭头；距离档位、楼层或目标变化时提示位置'
            }
            onClick={() =>
              send(quest.tracking ? 'quest_untrack' : 'quest_track')
            }
          >
            {quest.tracking ? '停止追踪' : '追踪目标'}
          </Button>
          <Button
            disabled={!!data.busy || !quest.can_submit || !!quest.failed}
            tooltip={quest.submit_blocked_reason || undefined}
            onClick={() => send('quest_submit')}
          >
            提交任务（{quest.reward} 积分）
          </Button>
          <Button.Confirm
            color="bad"
            disabled={!!data.busy}
            confirmContent="确认放弃，不返还名额？"
            onClick={() => send('quest_abandon')}
          >
            放弃任务
          </Button.Confirm>
        </>
      )}
    </Section>
  );
};

const tierColors = {
  普通: '#b4c9ae',
  强力: '#dfbd7b',
  超模: '#db9fea',
};

export const RpgSystem = () => {
  const { act, data } = useBackend<Data>();
  const {
    points,
    spell_points,
    current_tab,
    busy,
    tabs = [],
    rows = [],
    daily,
  } = data;
  const scrollRef = useRef<HTMLDivElement>(null);

  // 仅切换分类时回到顶部；积分更新和连续购买始终复用同一滚动容器。
  useLayoutEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = 0;
    }
  }, [current_tab]);

  return (
    <Window width={850} height={700} title="RPG 系统">
      <Window.Content>
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            height: '100%',
            gap: '12px',
          }}
        >
          <div
            style={{
              flexShrink: 0,
              padding: '14px 18px',
              border: '1px solid #66543a',
              background: 'rgba(42, 34, 24, 0.7)',
            }}
          >
            <Box bold fontSize={1.5} color="#e2c58b" mb={1}>
              世界旅人的 RPG 系统
            </Box>
            <Box inline mr={3}>
              系统积分：<b>{points}</b>
            </Box>
            <Box inline>
              可用法术点：<b>{spell_points}</b>
            </Box>
            <Box mt={1}>
              <Button
                icon="calendar-check"
                disabled={!!busy || !!daily.checked_in}
                onClick={() => act('check_in', { day: daily.day })}
                tooltip="每日黎明刷新，随机获得 100–1000 积分；当前 storyteller 与信仰相符时，有 10% 概率获得双倍积分。"
              >
                {daily.checked_in ? '今日已签到' : '每日签到'}
              </Button>
              <Box inline ml={1} color="label">
                {daily.check_result || '每个游戏日可签到一次，黎明刷新。'}
              </Box>
            </Box>
          </div>
          <div style={{ display: 'flex', flex: 1, minHeight: 0, gap: '12px' }}>
            <nav style={{ width: '112px', flexShrink: 0, overflowY: 'auto' }}>
              {tabs.map((tab) => (
                <Button
                  key={tab.id}
                  fluid
                  mb={0.6}
                  selected={current_tab === tab.id}
                  disabled={!!busy}
                  onClick={() => act('tab', { tab: tab.id })}
                >
                  {tab.name}
                </Button>
              ))}
            </nav>
            <div
              ref={scrollRef}
              style={{
                flex: 1,
                minWidth: 0,
                overflowY: 'auto',
                paddingRight: 8,
              }}
            >
              {current_tab === 'quests' && (
                <>
                  <Box mb={1} color="label">
                    每日六个候选，同时最多持有三个任务；所有未提交任务均占用槽位。达到目标后可随处提交，物品类任务会收取随身任务物品。已接任务跨日保留，原有时限继续计时，不收押金。
                  </Box>
                  {!!daily.notice && <Box mb={1}>{daily.notice}</Box>}
                  <Section title={`持有任务（${daily.active.length} / 3）`}>
                    {daily.active.length === 0 && (
                      <Box color="label">尚未接受任务。</Box>
                    )}
                    {daily.active.map((quest) => (
                      <QuestCard key={quest.id} quest={quest} />
                    ))}
                  </Section>
                  <Section title={`今日可接取（${daily.offers.length}）`}>
                    {daily.offers.length === 0 && (
                      <Box color="label">
                        今日候选已用完，或当前地图暂无可用任务模板。
                      </Box>
                    )}
                    {daily.offers.map((quest) => (
                      <QuestCard key={quest.id} quest={quest} candidate />
                    ))}
                  </Section>
                </>
              )}
              {rows.map((row) => (
                <div
                  key={`${current_tab}-${row.id}`}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '14px',
                    padding: '12px',
                    marginBottom: '6px',
                    border: '1px solid rgba(170, 151, 116, 0.25)',
                    background: 'rgba(0, 0, 0, 0.16)',
                  }}
                >
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <Box bold fontSize={1.1} mb={0.5}>
                      {row.name}
                    </Box>
                    <Box color="label" style={{ lineHeight: 1.5 }}>
                      {row.description}
                    </Box>
                    {row.tier && (
                      <Box mt={0.5} color={tierColors[row.tier] || 'label'}>
                        {row.tier}特性
                      </Box>
                    )}
                    {row.current !== undefined && (
                      <Box mt={0.5}>
                        当前：{row.current}
                        {current_tab === 'skill' ? ' 级' : ''}
                      </Box>
                    )}
                  </div>
                  <div
                    style={{
                      width: '112px',
                      flexShrink: 0,
                      textAlign: 'right',
                    }}
                  >
                    <Box bold color="#e2c58b" mb={0.7}>
                      {row.cost ? `${row.cost} 积分` : '已达上限'}
                    </Box>
                    <Button
                      fluid
                      disabled={!!busy || !!row.blocked_reason}
                      tooltip={row.blocked_reason || undefined}
                      onClick={() =>
                        act(row.action, { tab: current_tab, id: row.id })
                      }
                    >
                      {row.blocked_reason ||
                        (row.action.startsWith('enhance_')
                          ? '强化 +1'
                          : '兑换')}
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

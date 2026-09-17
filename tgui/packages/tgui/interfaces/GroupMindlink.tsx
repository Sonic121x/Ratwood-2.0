import { useEffect, useRef, useState } from 'react';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type Person = { id: string; name: string; online: BooleanLike };
type Message = {
  seq: number;
  name: string;
  speaker: string | null;
  text: string;
  time: string;
  system: BooleanLike;
};
type Room = {
  id: string;
  name: string;
  kind: 'main' | 'dm' | 'room';
  unread: number;
};
type ActiveRoom = Room & {
  link: string;
  creator: string;
  owner: string;
  members: Person[];
  people: Person[];
  messages: Message[];
  sequence: number;
};
type VisionPermission = {
  id: string;
  link: string;
  link_name: string;
  person: string;
  name: string;
  approved: BooleanLike;
  watching: BooleanLike;
};
type Data = {
  self: string;
  feedback: string;
  selecting: BooleanLike;
  busy: BooleanLike;
  selection: string[];
  candidates: Person[];
  groups: {
    id: string;
    name: string;
    remaining: number;
    rooms: Room[];
  }[];
  active: ActiveRoom | null;
  ack: { nonce?: string; room?: string };
  vision: {
    current: { id: string; name: string } | null;
    incoming: VisionPermission[];
    outgoing: VisionPermission[];
  };
};

const kindLabel = { main: '主群', dm: '私聊', room: '小房间' };

const VisionButton = ({ person, link }: { person: Person; link: string }) => {
  const { act, data } = useBackend<Data>();
  const permission = data.vision.outgoing.find(
    (entry) => entry.link === link && entry.person === person.id,
  );
  const watching = !!permission && data.vision.current?.id === permission.id;
  return (
    <Button
      icon="eye"
      disabled={!person.online || (!!permission && !permission.approved)}
      tooltip={!person.online ? '对方需要在线且清醒，才能本人同意' : undefined}
      onClick={() => {
        if (watching) {
          act('vision_stop');
        } else if (permission?.approved) {
          act('vision_start', { id: permission.id });
        } else {
          act('vision_request', { link, person: person.id });
        }
      }}
    >
      {watching
        ? '返回自身'
        : permission?.approved
          ? '观看视角'
          : permission
            ? '等待同意'
            : '请求视角'}
    </Button>
  );
};

const VisionPanel = () => {
  const { act, data } = useBackend<Data>();
  const { current, incoming, outgoing } = data.vision;
  const [expanded, setExpanded] = useState(false);
  const pending = incoming.filter((entry) => !entry.approved).length;
  return (
    <Section title="心灵视角">
      <Stack align="center">
        <Stack.Item grow>
          <Box color={current ? 'good' : 'label'}>
            {current
              ? `正在观看：${current.name} · 身体暂时不能主动行动`
              : '当前为自身视角 · 借用他人视角须先征得同意'}
          </Box>
        </Stack.Item>
        {!!current && (
          <Stack.Item>
            <Button
              icon="eye-slash"
              color="good"
              onClick={() => act('vision_stop')}
            >
              返回自身视角
            </Button>
          </Stack.Item>
        )}
        <Stack.Item>
          <Button onClick={() => setExpanded(!expanded)}>
            {expanded ? '收起授权' : '管理授权'}
            {pending > 0 && `（${pending} 个请求）`}
          </Button>
        </Stack.Item>
      </Stack>
      {expanded && (
        <Box mt={1} maxHeight="180px" overflowY="auto">
          <Box bold mb={0.5}>
            谁可以观看我
          </Box>
          {!incoming.length && <Box color="label">尚未授权任何人。</Box>}
          {incoming.map((entry) => (
            <Stack key={entry.id} align="center" mb={0.5}>
              <Stack.Item grow>
                {entry.name} · {entry.link_name} ·{' '}
                {entry.watching
                  ? '正在观看我'
                  : entry.approved
                    ? '已授权'
                    : '等待我同意'}
              </Stack.Item>
              {!entry.approved && (
                <Stack.Item>
                  <Button
                    color="good"
                    onClick={() => act('vision_accept', { id: entry.id })}
                  >
                    同意
                  </Button>
                </Stack.Item>
              )}
              <Stack.Item>
                <Button
                  color="bad"
                  onClick={() =>
                    act(entry.approved ? 'vision_revoke' : 'vision_decline', {
                      id: entry.id,
                    })
                  }
                >
                  {entry.approved ? '撤销授权' : '拒绝'}
                </Button>
              </Stack.Item>
            </Stack>
          ))}
          {incoming.length > 0 && (
            <Button color="bad" mb={1} onClick={() => act('vision_revoke_all')}>
              撤销全部授权与待处理请求
            </Button>
          )}
          <Box bold mt={1} mb={0.5}>
            我可以观看谁
          </Box>
          {!outgoing.length && (
            <Box color="label">在右侧成员列表中请求视角。</Box>
          )}
          {outgoing.map((entry) => (
            <Stack key={entry.id} align="center" mb={0.5}>
              <Stack.Item grow>
                {entry.name} · {entry.link_name} ·{' '}
                {entry.approved ? '对方已同意' : '等待对方同意'}
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon={entry.approved ? 'eye' : 'xmark'}
                  disabled={current?.id === entry.id}
                  onClick={() =>
                    act(entry.approved ? 'vision_start' : 'vision_cancel', {
                      id: entry.id,
                    })
                  }
                >
                  {current?.id === entry.id
                    ? '正在观看'
                    : entry.approved
                      ? '观看视角'
                      : '取消请求'}
                </Button>
              </Stack.Item>
            </Stack>
          ))}
          <Box color="label" mt={1} fontSize="11px">
            授权仅在对应主链接内有效。关闭聊天窗口会返回自身视角，授权仍可由对方随时撤销。
          </Box>
        </Box>
      )}
    </Section>
  );
};

const PeoplePicker = (props: {
  people: Person[];
  selected: string[];
  toggle: (id: string) => void;
  disabled?: boolean;
}) => {
  const [query, setQuery] = useState('');
  const { people, selected, toggle, disabled } = props;
  const matches = people.filter((person) => person.name.includes(query.trim()));
  return (
    <>
      <Input fluid placeholder="搜索姓名" value={query} onChange={setQuery} />
      <Box mt={1} maxHeight="240px" overflowY="auto">
        {matches.map((person) => (
          <Button.Checkbox
            key={person.id}
            fluid
            checked={selected.includes(person.id)}
            disabled={disabled}
            onClick={() => toggle(person.id)}
          >
            {person.name}
            {!person.online && '（未在线）'}
          </Button.Checkbox>
        ))}
        {!matches.length && <Box color="label">没有符合条件的人。</Box>}
      </Box>
    </>
  );
};

const MemberActions = ({ room }: { room: ActiveRoom }) => {
  const { act, data } = useBackend<Data>();
  const [selected, setSelected] = useState<string[]>([]);
  const [known, setKnown] = useState<string[]>([]);
  const [name, setName] = useState('');
  const toggle = (id: string) =>
    setSelected((ids) =>
      ids.includes(id) ? ids.filter((entry) => entry !== id) : [...ids, id],
    );
  const eligible = room.people.filter((person) => person.id !== data.self);
  const validSelected = selected.filter((id) =>
    eligible.some((person) => person.id === id),
  );
  const validKnown = known.filter((id) =>
    data.candidates.some((person) => person.id === id),
  );
  const canManage =
    (room.kind === 'main' && room.owner === data.self) ||
    (room.kind === 'room' && room.creator === data.self);
  const addable = validSelected.filter(
    (id) => !room.members.some((person) => person.id === id),
  );

  return (
    <>
      <Section title={`会话成员 · ${room.members.length}`}>
        {room.members.map((person) => (
          <Stack key={person.id} align="center" mb={0.5}>
            <Stack.Item grow>
              {person.name}
              {person.id === data.self && '（我）'}
              {!person.online && '（未在线）'}
            </Stack.Item>
            {person.id !== data.self && (
              <Stack.Item>
                <VisionButton person={person} link={room.link} />
              </Stack.Item>
            )}
            {canManage && person.id !== data.self && (
              <Stack.Item>
                <Button.Confirm
                  icon="user-minus"
                  color="bad"
                  tooltip="移除此成员"
                  confirmContent="确认移除"
                  onClick={() => act('kick', { room: room.id, id: person.id })}
                />
              </Stack.Item>
            )}
          </Stack>
        ))}
        <Box mt={1}>
          <Button.Confirm
            color="bad"
            confirmContent="确认退出"
            onClick={() => act('leave', { room: room.id })}
          >
            {room.kind === 'main' ? '退出主链接' : '退出会话'}
          </Button.Confirm>
          {canManage && (
            <Button.Confirm
              color="bad"
              confirmContent="确认结束"
              onClick={() => act('close_room', { room: room.id })}
            >
              {room.kind === 'main' ? '结束链接' : '解散房间'}
            </Button.Confirm>
          )}
        </Box>
        <Box color="label" mt={1} fontSize="11px">
          {room.kind === 'main'
            ? '退出主链接也会退出其下全部会话；施法者退出将结束链接。'
            : '私聊任一方退出或房间创建者退出时，该会话结束。'}
        </Box>
      </Section>
      <Section title="选择链接成员">
        <PeoplePicker
          people={eligible}
          selected={validSelected}
          toggle={toggle}
        />
        <Box color="label" my={1}>
          已选 {validSelected.length} 人，你会自动加入新会话。
        </Box>
        {validSelected.length === 1 && (
          <Box mb={1}>
            <VisionButton
              person={
                eligible.find((person) => person.id === validSelected[0])!
              }
              link={room.link}
            />
          </Box>
        )}
        <Button
          fluid
          icon="comment"
          disabled={validSelected.length !== 1}
          onClick={() =>
            act('create_dm', { room: room.id, ids: validSelected })
          }
        >
          单人私聊
        </Button>
        <Input
          fluid
          mt={1}
          maxLength={40}
          placeholder="小房间名称（可选）"
          value={name}
          onChange={setName}
        />
        <Button
          fluid
          mt={0.5}
          icon="users"
          disabled={!validSelected.length}
          onClick={() =>
            act('create_room', { room: room.id, ids: validSelected, name })
          }
        >
          创建小房间
        </Button>
        {room.kind === 'room' && room.creator === data.self && (
          <Button
            fluid
            mt={0.5}
            disabled={!addable.length}
            onClick={() =>
              act('add_room_members', { room: room.id, ids: addable })
            }
          >
            将所选成员加入当前房间
          </Button>
        )}
      </Section>
      {room.owner === data.self && (
        <Section title="追加熟人到主链接">
          <PeoplePicker
            people={data.candidates}
            selected={validKnown}
            toggle={(id) =>
              setKnown((ids) =>
                ids.includes(id)
                  ? ids.filter((entry) => entry !== id)
                  : [...ids, id],
              )
            }
          />
          <Button
            fluid
            mt={1}
            disabled={!validKnown.length}
            onClick={() => {
              act('add_known', { room: room.id, ids: validKnown });
              setKnown([]);
            }}
          >
            加入主链接（不延长时间）
          </Button>
        </Section>
      )}
    </>
  );
};

export const GroupMindlink = () => {
  const { act, data } = useBackend<Data>();
  const { active, selecting, busy } = data;
  // 仅保存在本地窗口状态中，不使用会向其他客户端共享的状态接口。
  const [drafts, setDrafts] = useLocalState<Record<string, string>>(
    `group-mindlink-drafts-${data.self}`,
    {},
  );
  const sent = useRef<Record<string, { room: string; text: string }>>({});
  const counter = useRef(0);
  const acknowledged = useRef('');
  const lastRead = useRef('');
  const log = useRef<HTMLDivElement>(null);
  const autoScroll = useRef(true);
  const activeId = active?.id;
  const sequence = active?.sequence;

  useEffect(() => {
    const nonce = data.ack.nonce;
    if (!nonce || acknowledged.current === nonce) {
      return;
    }
    acknowledged.current = nonce;
    const message = sent.current[nonce];
    if (message && data.ack.room === message.room) {
      // 成功回执只清除对应草稿；发送失败或发送后继续输入时保留文字。
      if (drafts[message.room] === message.text) {
        setDrafts({ ...drafts, [message.room]: '' });
      }
      delete sent.current[nonce];
    }
  }, [data.ack.nonce, data.ack.room]);

  useEffect(() => {
    const markRead = () => {
      const key = `${activeId}:${sequence}`;
      if (
        activeId &&
        !selecting &&
        !document.hidden &&
        lastRead.current !== key
      ) {
        lastRead.current = key;
        act('read', { room: activeId, sequence });
      }
    };
    markRead();
    window.addEventListener('focus', markRead);
    return () => window.removeEventListener('focus', markRead);
  }, [activeId, sequence, selecting]);

  useEffect(() => {
    autoScroll.current = true;
    if (log.current) {
      log.current.scrollTop = log.current.scrollHeight;
    }
  }, [activeId, selecting]);

  useEffect(() => {
    if (log.current && autoScroll.current) {
      log.current.scrollTop = log.current.scrollHeight;
    }
  }, [sequence]);

  const send = () => {
    if (!activeId || selecting || !drafts[activeId]?.trim()) {
      return;
    }
    const text = drafts[activeId];
    const nonce = `${Date.now()}-${++counter.current}`;
    sent.current = { [nonce]: { room: activeId, text } };
    act('send', { room: activeId, text, nonce });
  };

  return (
    <Window width={1060} height={720} title="群体心灵链接" theme="wizard">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Box color="label" p={1} backgroundColor="rgba(0, 0, 0, 0.25)">
              {data.feedback}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <VisionPanel />
          </Stack.Item>
          <Stack.Item grow style={{ minHeight: 0 }}>
            <Stack fill>
              <Stack.Item basis="200px" shrink={0}>
                <Section fill scrollable title="我的会话">
                  {!data.groups.length && (
                    <Box color="label">尚未加入心灵链接。</Box>
                  )}
                  {data.groups.map((group) => (
                    <Box key={group.id} mb={2}>
                      <Box bold mb={0.5}>
                        {group.name}
                      </Box>
                      <Box color="label" fontSize="11px" mb={1}>
                        剩余 {Math.floor(group.remaining / 60)} 分{' '}
                        {group.remaining % 60} 秒
                      </Box>
                      {group.rooms.map((room) => (
                        <Button
                          key={room.id}
                          fluid
                          mb={0.5}
                          selected={!selecting && activeId === room.id}
                          disabled={!!busy}
                          icon={room.kind === 'dm' ? 'comment' : 'users'}
                          onClick={() => act('select_room', { id: room.id })}
                        >
                          {room.name}
                          {room.unread > 0 && ` · ${room.unread} 条未读`}
                        </Button>
                      ))}
                    </Box>
                  ))}
                  <Box color="label" fontSize="11px">
                    私聊与小房间只对房内成员可见。关闭窗口不会退出链接。
                  </Box>
                </Section>
              </Stack.Item>
              {!!selecting && (
                <Stack.Item grow>
                  <Section fill scrollable title="选择熟人建立链接">
                    <Box mb={2} color="label">
                      施法者自动加入。确认后引导五秒，链接持续十五分钟。
                      未在线的熟人也可加入，在线后可重开窗口交流。
                    </Box>
                    <PeoplePicker
                      people={data.candidates}
                      selected={data.selection}
                      disabled={!!busy}
                      toggle={(id) => act('toggle_person', { id })}
                    />
                    <Box my={2}>
                      已选 {data.selection.length} 人
                      <Button
                        ml={1}
                        disabled={!!busy}
                        onClick={() => act('select_all')}
                      >
                        全选
                      </Button>
                      <Button
                        disabled={!!busy}
                        onClick={() => act('clear_selection')}
                      >
                        清空
                      </Button>
                    </Box>
                    <Button
                      icon={busy ? 'spinner' : 'link'}
                      disabled={!!busy || !data.selection.length}
                      onClick={() => act('cast')}
                    >
                      {busy ? '正在引导……' : '确认施法'}
                    </Button>
                    <Button
                      disabled={!!busy}
                      onClick={() => act('cancel_selection')}
                    >
                      取消
                    </Button>
                  </Section>
                </Stack.Item>
              )}
              {!selecting && !active && (
                <Stack.Item grow>
                  <Section fill title="请选择会话">
                    <Box color="label">
                      从左侧选择发送目标。原会话结束后，,m
                      不会自动改发到其他会话。
                    </Box>
                  </Section>
                </Stack.Item>
              )}
              {!selecting && active && (
                <>
                  <Stack.Item grow style={{ minWidth: 0 }}>
                    <Section
                      fill
                      title={`${kindLabel[active.kind]} · ${active.name}`}
                    >
                      <Stack vertical fill>
                        <Stack.Item>
                          <Box color="good">
                            发送目标：{active.name}（,m 同步）
                          </Box>
                        </Stack.Item>
                        <Stack.Item grow style={{ minHeight: 0 }}>
                          <div
                            ref={log}
                            style={{
                              height: '100%',
                              overflowY: 'auto',
                              padding: '6px',
                            }}
                            onScroll={() => {
                              const node = log.current;
                              if (node) {
                                autoScroll.current =
                                  node.scrollHeight -
                                    node.scrollTop -
                                    node.clientHeight <
                                  60;
                              }
                            }}
                          >
                            {active.messages.map((message) => (
                              <Box
                                key={message.seq}
                                mb={1}
                                p={1}
                                backgroundColor={
                                  message.speaker === data.self
                                    ? 'rgba(115, 78, 160, 0.3)'
                                    : 'rgba(0, 0, 0, 0.2)'
                                }
                              >
                                <Box color="label" fontSize="11px" mb={0.5}>
                                  {message.name} · {message.time}
                                </Box>
                                <Box
                                  color={message.system ? 'label' : undefined}
                                  style={{
                                    whiteSpace: 'pre-wrap',
                                    overflowWrap: 'anywhere',
                                  }}
                                >
                                  {message.text}
                                </Box>
                              </Box>
                            ))}
                            {!active.messages.length && (
                              <Box color="label">
                                还没有消息。仅显示本次加入后的记录。
                              </Box>
                            )}
                          </div>
                        </Stack.Item>
                        <Stack.Item>
                          <textarea
                            aria-label={`发送至${active.name}`}
                            placeholder="输入心念……回车发送，Shift + 回车换行"
                            maxLength={1024}
                            rows={3}
                            value={drafts[active.id] || ''}
                            style={{
                              width: '100%',
                              boxSizing: 'border-box',
                              resize: 'none',
                              background: '#191523',
                              color: '#eee7f6',
                              border: '1px solid #66527e',
                              padding: '8px',
                              fontFamily: 'inherit',
                            }}
                            onChange={(event) =>
                              setDrafts({
                                ...drafts,
                                [active.id]: event.target.value,
                              })
                            }
                            onKeyDown={(event) => {
                              if (
                                event.key === 'Enter' &&
                                !event.shiftKey &&
                                !event.nativeEvent.isComposing &&
                                event.keyCode !== 229
                              ) {
                                event.preventDefault();
                                send();
                              }
                            }}
                          />
                          <Button
                            fluid
                            icon="paper-plane"
                            disabled={!drafts[active.id]?.trim()}
                            onClick={send}
                          >
                            发送至{active.name}
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </Section>
                  </Stack.Item>
                  <Stack.Item basis="250px" shrink={0}>
                    <Box height="100%" overflowY="auto">
                      <MemberActions key={active.id} room={active} />
                    </Box>
                  </Stack.Item>
                </>
              )}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

import { useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Input,

  Stack,
  Tabs,
} from 'tgui-core/components'; import { Section } from '../components/Localized';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Message = {
  timestamp: string;
  author: string;
  message: string;
  is_admin: BooleanLike;
  full_text: string;
  embed_type?: string;
  embed_url?: string;
};

type Ticket = {
  id: number;
  name: string;
  state: string;
  initiator_ckey: string;
  initiator_name: string;
  opened_at: number;
  closed_at: number | null;
  initiator_connected: BooleanLike;
};

type Data = {
  active_tickets: Ticket[];
  closed_tickets: Ticket[];
  resolved_tickets: Ticket[];
  selected_ticket: {
    ticket_id: number;
    ticket_name: string;
    ticket_state: string;
    initiator_ckey: string;
    initiator_name: string;
    opened_at: number;
    closed_at: number | null;
    messages: Message[];
    can_send: BooleanLike;
    is_admin: BooleanLike;
    initiator_connected: BooleanLike;
  } | null;
};

export const AdminTicketPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    active_tickets,
    closed_tickets,
    resolved_tickets,
    selected_ticket,
  } = data;

  const [tabIndex, setTabIndex] = useState(0);
  const [inputText, setInputText] = useState('');
  const [showEmbedInput, setShowEmbedInput] = useState<
    'image' | 'video' | null
  >(null);
  const [embedUrl, setEmbedUrl] = useState('');
  const [inputRows, setInputRows] = useState(1);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const chatTextareaRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [selected_ticket?.messages.length, selected_ticket?.ticket_id]);

  const handleSend = () => {
    if (inputText.trim() && selected_ticket) {
      act('send_message', {
        ticket_id: selected_ticket.ticket_id,
        message: inputText,
      });
      setInputText('');
      setInputRows(1);
      if (chatTextareaRef.current) {
        chatTextareaRef.current.style.height = 'auto';
      }
    }
  };

  const handleSelectTicket = (ticketId: number) => {
    act('select_ticket', { ticket_id: ticketId });
  };

  const handleEmbedSend = () => {
    if (embedUrl.trim() && selected_ticket && showEmbedInput) {
      act('embed_media', {
        ticket_id: selected_ticket.ticket_id,
        url: embedUrl.trim(),
        embed_type: showEmbedInput,
      });
      setEmbedUrl('');
      setShowEmbedInput(null);
    }
  };

  const getTickets = () => {
    switch (tabIndex) {
      case 0:
        return active_tickets;
      case 1:
        return closed_tickets;
      case 2:
        return resolved_tickets;
      default:
        return [];
    }
  };

  const getStatusColor = (state: string) => {
    switch (state) {
      case 'ACTIVE':
        return 'good';
      case 'CLOSED':
        return 'bad';
      case 'RESOLVED':
        return 'average';
      default:
        return 'default';
    }
  };

  const tickets = getTickets();

  return (
    <Window width={1200} height={800} title={`Admin Ticket Panel (${active_tickets.length} active)`} display_title={`管理员求助面板（${active_tickets.length} 条待处理）`}>
      <Window.Content>
        <Stack fill>
          {/* Left Panel - Ticket List */}
          <Stack.Item width="350px">
            <Section fill scrollable title="Tickets" display_title="工单">
              <Tabs>
                <Tabs.Tab
                  selected={tabIndex === 0}
                  onClick={() => setTabIndex(0)}
                >
                  待处理 ({active_tickets.length})
                </Tabs.Tab>
                <Tabs.Tab
                  selected={tabIndex === 1}
                  onClick={() => setTabIndex(1)}
                >
                  已关闭 ({closed_tickets.length})
                </Tabs.Tab>
                <Tabs.Tab
                  selected={tabIndex === 2}
                  onClick={() => setTabIndex(2)}
                >
                  已解决 ({resolved_tickets.length})
                </Tabs.Tab>
              </Tabs>
              <Box mt={1}>
                {tickets.length === 0 ? (
                  <Box color="label" italic>
                    此分类下没有求助
                  </Box>
                ) : (
                  tickets.map((ticket) => (
                    <Box
                      key={ticket.id}
                      className="candystripe"
                      p={1}
                      mb={0.5}
                      backgroundColor={
                        selected_ticket?.ticket_id === ticket.id
                          ? 'rgba(0, 100, 200, 0.3)'
                          : undefined
                      }
                      style={{ cursor: 'pointer' }}
                      onClick={() => handleSelectTicket(ticket.id)}
                    >
                      <Stack>
                        <Stack.Item grow>
                          <Box bold>
                            #{ticket.id} - {ticket.initiator_name}
                          </Box>
                          <Box fontSize="0.9em" color="label">
                            {ticket.name.substring(0, 50)}
                            {ticket.name.length > 50 ? '...' : ''}
                          </Box>
                        </Stack.Item>
                        <Stack.Item>
                          <Box color={getStatusColor(ticket.state)}>
                            {{ ACTIVE: '待处理', CLOSED: '已关闭', RESOLVED: '已解决' }[ticket.state] || ticket.state}
                          </Box>
                          {!ticket.initiator_connected && (
                            <Box color="bad" fontSize="0.8em">
                              [已断线]
                            </Box>
                          )}
                        </Stack.Item>
                      </Stack>
                    </Box>
                  ))
                )}
              </Box>
            </Section>
          </Stack.Item>

          {/* Right Panel - Ticket Details & Chat */}
          <Stack.Item grow>
            <Stack vertical fill>

              {selected_ticket ? (
                <>
                  {/* Action Buttons */}
                  <Stack.Item>
                    <Section>
                      <Stack>
                        <Stack.Item>
                          <Box bold fontSize="1.2em">
                            求助 #{selected_ticket.ticket_id}
                          </Box>
                          <Box color="label">{selected_ticket.ticket_name}</Box>
                        </Stack.Item>
                        <Stack.Item grow />
                      </Stack>
                      {/* Admin quick tools row */}
                      {selected_ticket.is_admin && (
                        <Stack mt={1} wrap>
                          <Stack.Item>
                            <Button
                              compact
                              tooltip="玩家面板（PP）- 打开此角色的玩家面板。"
                              onClick={() =>
                                act('ticket_pp', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              玩家面板
                            </Button>
                            <Button
                              compact
                              tooltip="查看变量（VV）- 打开此角色的变量查看器。"
                              onClick={() =>
                                act('ticket_vv', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              查看变量
                            </Button>
                            <Button
                              compact
                              tooltip="隐秘消息（SM）- 向此玩家的意识发送一条角色内消息。"
                              onClick={() =>
                                act('ticket_sm', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              隐秘消息
                            </Button>
                            <Button
                              compact
                              tooltip="跟随（FLW）- 以观察者幽灵的身份跟随此角色。"
                              onClick={() =>
                                act('ticket_flw', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              跟随
                            </Button>
                            <Button
                              compact
                              tooltip="反派面板（TP）- 打开此角色的反派面板。"
                              onClick={() =>
                                act('ticket_tp', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              反派面板
                            </Button>
                            <Button
                              compact
                              color="bad"
                              tooltip="神罚 - 降下神明的惩罚！请尽量少用。"
                              onClick={() =>
                                act('ticket_smite', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              神罚
                            </Button>
                            <Button
                              compact
                              tooltip="蛋糕 - 给玩家一块随机口味的蛋糕。"
                              onClick={() =>
                                act('ticket_cake', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              蛋糕
                            </Button>
                            <Button
                              compact
                              color="good"
                              tooltip="管理员治疗 - 迅速复活并完全治愈玩家。"
                              onClick={() =>
                                act('ticket_aheal', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              管理员治疗
                            </Button>
                            <Button
                              compact
                              tooltip="玩家质量分（PQ）- 打开此玩家的质量分面板。"
                              onClick={() =>
                                act('ticket_pq', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              PQ
                            </Button>
                            <Button
                              compact
                              tooltip="拉取角色（GM）- 将此角色传送到你身边。"
                              onClick={() =>
                                act('ticket_gm', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              拉取角色
                            </Button>
                            <Button
                              compact
                              tooltip="前往角色（JM）- 传送到此角色所在位置。"
                              onClick={() =>
                                act('ticket_jm', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              前往角色
                            </Button>
                            <Button
                              compact
                              tooltip="直接旁白（ND）- 向此玩家发送一条旁白消息。"
                              onClick={() =>
                                act('ticket_nd', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              直接旁白
                            </Button>
                            <Button
                              compact
                              tooltip="对象过程调用（AP）- 在此角色上调用指定过程。请谨慎使用。"
                              onClick={() =>
                                act('ticket_ap', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              过程调用
                            </Button>
                          </Stack.Item>
                        </Stack>
                      )}
                      <Stack mt={1}>
                        <Stack.Item>
                          <Button
                            icon="exclamation-triangle"
                            color="bad"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('reject', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            拒绝
                          </Button>
                          <Button
                            icon="gamepad"
                            color="average"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('ic_issue', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            角色内问题
                          </Button>
                          <Button
                            icon="times"
                            color="bad"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('close', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            关闭
                          </Button>
                          <Button
                            icon="check"
                            color="good"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('resolve', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            解决
                          </Button>
                          <Button
                            icon="hand-paper"
                            color="average"
                            disabled={selected_ticket.ticket_state !== 'ACTIVE'}
                            onClick={() =>
                              act('handle', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            接手
                          </Button>
                          {selected_ticket.ticket_state !== 'ACTIVE' && (
                            <Button
                              icon="redo"
                              color="good"
                              onClick={() =>
                                act('reopen', {
                                  ticket_id: selected_ticket.ticket_id,
                                })
                              }
                            >
                              重新打开
                            </Button>
                          )}
                          <Button
                            icon="edit"
                            onClick={() =>
                              act('retitle', {
                                ticket_id: selected_ticket.ticket_id,
                              })
                            }
                          >
                            更改标题
                          </Button>
                        </Stack.Item>
                      </Stack>
                    </Section>
                  </Stack.Item>

                  {/* Conversation view + input */}
                  <>
                      <Stack.Item grow>
                        <Section fill scrollable title="Conversation" display_title="对话">
                          <Stack vertical>
                            {selected_ticket.messages.length === 0 ? (
                              <Stack.Item>
                                <Box color="label" italic>
                                  暂无消息
                                </Box>
                              </Stack.Item>
                            ) : (
                              selected_ticket.messages.map((msg, index) => (
                                <Stack.Item key={index}>
                                  <Box
                                    backgroundColor={
                                      msg.is_admin
                                        ? 'rgba(0, 100, 200, 0.12)'
                                        : 'rgba(40, 40, 40, 0.5)'
                                    }
                                    p={1}
                                    mb={0.6}
                                    style={{
                                      borderRadius: '4px',
                                      borderLeft: msg.is_admin
                                        ? '3px solid #4a90e2'
                                        : '3px solid #888',
                                      wordBreak: 'break-word',
                                      whiteSpace: 'pre-wrap',
                                    }}
                                  >
                                    <Stack>
                                      <Stack.Item>
                                        <Box
                                          bold
                                          color={msg.is_admin ? 'blue' : 'white'}
                                        >
                                          {msg.author}
                                        </Box>
                                      </Stack.Item>
                                      <Stack.Item grow />
                                      <Stack.Item>
                                        <Box fontSize="0.9em" color="label">
                                          {msg.timestamp}
                                        </Box>
                                      </Stack.Item>
                                    </Stack>
                                    {msg.embed_type === 'image' &&
                                    msg.embed_url ? (
                                      <img
                                        src={msg.embed_url}
                                        alt="嵌入图片"
                                        style={{
                                          maxWidth: '100%',
                                          maxHeight: '400px',
                                          borderRadius: '4px',
                                          marginTop: '4px',
                                          display: 'block',
                                        }}
                                      />
                                    ) : msg.embed_type === 'video' &&
                                      msg.embed_url ? (
                                      <video
                                        src={msg.embed_url}
                                        controls
                                        style={{
                                          maxWidth: '100%',
                                          maxHeight: '300px',
                                          borderRadius: '4px',
                                          marginTop: '4px',
                                          display: 'block',
                                        }}
                                      />
                                    ) : (
                                      <Box mt={0.4}>{msg.message}</Box>
                                    )}
                                  </Box>
                                </Stack.Item>
                              ))
                            )}
                            <div ref={messagesEndRef} />
                          </Stack>
                        </Section>
                      </Stack.Item>

                      {selected_ticket.is_admin && (
                        <Stack.Item>
                          <Section>
                            <Stack>
                              <Stack.Item grow>
                                <textarea
                                  ref={chatTextareaRef}
                                  className="Input TextArea Input--fluid"
                                  placeholder="输入回复……（Shift+Enter 换行）"
                                  value={inputText}
                                  rows={inputRows}
                                  onChange={(e) => {
                                    const val = e.target.value;
                                    setInputText(val);
                                    e.target.style.height = 'auto';
                                    e.target.style.height = `${Math.min(e.target.scrollHeight, 144)}px`;
                                    const lines = (val.match(/\n/g) || []).length + 1;
                                    setInputRows(Math.min(Math.max(lines, 1), 6));
                                  }}
                                  onKeyDown={(e) => {
                                    if (e.key === 'Enter' && !e.shiftKey) {
                                      e.preventDefault();
                                      handleSend();
                                    }
                                  }}
                                  disabled={!selected_ticket.can_send}
                                  maxLength={1024}
                                  style={{ resize: 'none', overflow: 'hidden' }}
                                />
                              </Stack.Item>
                              <Stack.Item>
                                <Button
                                  icon="paper-plane"
                                  color="good"
                                  disabled={
                                    !selected_ticket.can_send ||
                                    !inputText.trim()
                                  }
                                  onClick={handleSend}
                                >
                                  发送
                                </Button>
                                <Button
                                  icon="image"
                                  color="blue"
                                  tooltip="在求助中嵌入图片链接（仅限 https）"
                                  disabled={!selected_ticket.can_send}
                                  selected={showEmbedInput === 'image'}
                                  onClick={() =>
                                    setShowEmbedInput(
                                      showEmbedInput === 'image'
                                        ? null
                                        : 'image',
                                    )
                                  }
                                >
                                  图片
                                </Button>
                                <Button
                                  icon="film"
                                  color="purple"
                                  tooltip="在求助中嵌入视频链接（仅限 https）"
                                  disabled={!selected_ticket.can_send}
                                  selected={showEmbedInput === 'video'}
                                  onClick={() =>
                                    setShowEmbedInput(
                                      showEmbedInput === 'video'
                                        ? null
                                        : 'video',
                                    )
                                  }
                                >
                                  视频
                                </Button>
                              </Stack.Item>
                            </Stack>
                            {showEmbedInput && (
                              <Box mt={0.5}>
                                <Stack>
                                  <Stack.Item grow>
                                    <Input
                                      fluid
                                      placeholder={`粘贴${showEmbedInput === 'image' ? '图片' : '视频'}链接（必须以 https:// 开头）……`}
                                      value={embedUrl}
                                      onChange={setEmbedUrl}
                                      onEnter={handleEmbedSend}
                                    />
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button
                                      color="good"
                                      disabled={
                                        !embedUrl
                                          .trim()
                                          .startsWith('https://')
                                      }
                                      onClick={handleEmbedSend}
                                    >
                                      嵌入{showEmbedInput === 'image' ? '图片' : '视频'}
                                    </Button>
                                    <Button
                                      onClick={() => {
                                        setShowEmbedInput(null);
                                        setEmbedUrl('');
                                      }}
                                    >
                                      取消
                                    </Button>
                                  </Stack.Item>
                                </Stack>
                                <Box
                                  mt={0.5}
                                  p={0.75}
                                  fontSize="0.85em"
                                  color="label"
                                  style={{
                                    borderRadius: '4px',
                                    border: '1px solid rgba(255,255,255,0.1)',
                                    background: 'rgba(0,0,0,0.3)',
                                  }}
                                >
                                  <Box bold color="white" mb={0.3}>
                                    如何嵌入媒体
                                  </Box>
                                  <Box>
                                    1. 找到一个{' '}
                                    {showEmbedInput === 'image'
                                      ? '图片直链'
                                      : '视频直链'}{' '}
                                    ——右键点击网页上的{' '}
                                    {showEmbedInput === 'image'
                                      ? '图片'
                                      : '视频'}{' '}
                                    并选择{' '}
                                    <Box
                                      as="span"
                                      bold
                                      color="white"
                                    >
                                      &quot;复制媒体地址&quot;
                                    </Box>
                                    。
                                  </Box>
                                  <Box mt={0.3}>
                                    2. 链接必须以{' '}
                                    <Box
                                      as="span"
                                      bold
                                      color="good"
                                    >
                                      https://
                                    </Box>{' '}
                                    开头，并以文件扩展名结尾（例如{' '}
                                    {showEmbedInput === 'image'
                                      ? '.png, .jpg, .gif, .webp'
                                      : '.mp4, .webm, .ogg'}
                                    ）。
                                  </Box>
                                  <Box mt={0.3}>
                                    3. 将链接粘贴到上方，然后点击{' '}
                                    <Box as="span" bold color="white">
                                      嵌入{showEmbedInput === 'image' ? '图片' : '视频'}
                                    </Box>
                                    。你和玩家都能看到该媒体。
                                  </Box>
                                  {showEmbedInput === 'image' && (
                                    <Box mt={0.3} color="average">
                                      提示：可以使用 Imgur、Discord CDN，或 GitHub
                                      原始文件的直接链接。
                                    </Box>
                                  )}
                                  {showEmbedInput === 'video' && (
                                    <Box mt={0.3} color="average">
                                      提示：不支持 YouTube/Twitch 视频页面，
                                      请使用 .mp4 或 .webm 文件的直接链接。
                                    </Box>
                                  )}
                                </Box>
                              </Box>
                            )}
                            {!selected_ticket.can_send && (
                              <Box
                                color="bad"
                                mt={0.5}
                                fontSize="0.9em"
                              >
                                此求助已关闭
                              </Box>
                            )}
                          </Section>
                        </Stack.Item>
                      )}
                    </>


                </>
              ) : (
                <Stack.Item grow>
                  <Section fill>
                    <Stack fill vertical align="center" justify="center">
                      <Stack.Item>
                        <Box fontSize="1.5em" color="label">
                          选择一条求助以查看详情
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

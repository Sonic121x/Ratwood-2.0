import { useState } from 'react';
import { Button, Input, Section, Stack, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Member = {
  name: string;
  is_leader: BooleanLike;
  is_self: BooleanLike;
};

type OutgoingInvite = {
  name: string;
  expires_at: number;
};

type IncomingInvite = {
  fellowship_name: string;
  leader_name: string;
  member_count: number;
  max_members: number;
  expires_at: number;
  ref: string;
};

type FellowshipData = {
  user_name: string;
  in_fellowship: BooleanLike;
  max_members: number;
  server_time: number;
  // Not in fellowship
  pending_invites?: IncomingInvite[];
  // In fellowship
  fellowship_name?: string;
  is_leader?: BooleanLike;
  leader_name?: string | null;
  leader_present?: BooleanLike;
  members?: Member[];
  outgoing_invites?: OutgoingInvite[];
};

// world.time is in deciseconds.
const secondsLeft = (expires_at: number, server_time: number) =>
  Math.max(0, Math.ceil((expires_at - server_time) / 10));

export const FellowshipPanel = () => {
  const { data } = useBackend<FellowshipData>();
  return (
    <Window title="冒险团" width={520} height={560}>
      <Window.Content>
        {data.in_fellowship ? <FellowshipView /> : <NoFellowshipView />}
      </Window.Content>
    </Window>
  );
};

const NoFellowshipView = () => {
  const { act, data } = useBackend<FellowshipData>();
  const [name, setName] = useState('');
  const invites = data.pending_invites || [];
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="组建冒险团">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                placeholder="冒险团名称"
                value={name}
                onChange={(value) => setName(value)}
                maxLength={32}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="flag"
                disabled={name.trim().length < 3}
                onClick={() => act('create', { name: name.trim() })}
              >
                创建
              </Button>
            </Stack.Item>
          </Stack>
          <div style={{ marginTop: '6px', opacity: 0.8 }}>
            冒险团成员可以在大契约台账处互相代为交付彼此的契约,
            首领则能获得额外的契约名额.
          </div>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="待处理的邀请" fill scrollable>
          {invites.length === 0 ? (
            <i>你没有任何待处理的邀请.</i>
          ) : (
            <Table>
              {invites.map((inv) => (
                <Table.Row key={inv.ref}>
                  <Table.Cell>
                    <b>{inv.fellowship_name}</b>
                    <br />
                    <span style={{ opacity: 0.7 }}>
                      由 {inv.leader_name} 领导 &middot; {inv.member_count}/
                      {inv.max_members} 名成员 &middot;{' '}
                      剩余 {secondsLeft(inv.expires_at, data.server_time)}秒
                    </span>
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      icon="check"
                      color="good"
                      onClick={() => act('accept_invite', { ref: inv.ref })}
                    >
                      接受
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const FellowshipView = () => {
  const { act, data } = useBackend<FellowshipData>();
  const members = data.members || [];
  const outgoing = data.outgoing_invites || [];
  const isLeader = !!data.is_leader;
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title={data.fellowship_name}>
          <Stack>
            <Stack.Item grow>
              {data.leader_present ? (
                <>由 <b>{data.leader_name}</b> 领导</>
              ) : (
                <i>无首领 (创建者已离去).</i>
              )}
              <br />
              <span style={{ opacity: 0.7 }}>
                {members.length} / {data.max_members} 名成员
              </span>
            </Stack.Item>
            <Stack.Item>
              {isLeader ? (
                <Button
                  icon="ban"
                  color="bad"
                  onClick={() => act('disband')}
                >
                  解散
                </Button>
              ) : (
                <Button
                  icon="sign-out-alt"
                  color="bad"
                  onClick={() => act('leave')}
                >
                  离开
                </Button>
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="共享契约">
          任何成员都可以在大契约台账处代为交付同伴已完成的契约,
          即便持有人已经倒下. 奖赏会记入实际交付者的名下,
          并适用其自身的免税状态 (若有).
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="成员" fill scrollable>
          <Table>
            {members.map((m) => (
              <Table.Row key={m.name}>
                <Table.Cell>
                  {m.name}
                  {!!m.is_leader && ' (首领)'}
                  {!!m.is_self && ' (你)'}
                </Table.Cell>
                <Table.Cell collapsing>
                  {isLeader && !m.is_self && !m.is_leader && (
                    <Button
                      icon="user-slash"
                      color="bad"
                      onClick={() => act('kick', { name: m.name })}
                    >
                      移出
                    </Button>
                  )}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
      {isLeader && (
        <Stack.Item>
          <Section
            title="邀请"
            buttons={
              <Button
                icon="user-plus"
                disabled={members.length >= (data.max_members || 6)}
                onClick={() => act('invite')}
              >
                邀请附近的人
              </Button>
            }
          >
            {outgoing.length === 0 ? (
              <i>没有待处理的邀请.</i>
            ) : (
              <Table>
                {outgoing.map((inv) => (
                  <Table.Row key={inv.name}>
                    <Table.Cell>
                      {inv.name}
                      <span style={{ opacity: 0.6 }}>
                        {' '}
                        &middot; 剩余 {secondsLeft(inv.expires_at, data.server_time)}秒
                      </span>
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        icon="times"
                        onClick={() => act('rescind', { name: inv.name })}
                      >
                        撤回
                      </Button>
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

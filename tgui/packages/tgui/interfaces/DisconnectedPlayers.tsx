import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { ADMIN_PANEL_LABELS } from './common/displayNames';
type DisconnectedPlayer = {
  ref: string;
  ckey: string;
  name: string;
  role: string;
  slots_open: number | null;
  slots_total: number | null;
  time_away: number;
  time_away_text: string;
};

// A total of -1 means the job has unlimited slots.
const slotsText = (player: DisconnectedPlayer) => {
  if (player.slots_total === null || player.slots_open === null) {
    return '-';
  }
  if (player.slots_total < 0) {
    return '∞';
  }
  return `${Math.max(player.slots_open, 0)}/${player.slots_total}`;
};

type Data = {
  players: DisconnectedPlayer[];
};

export const DisconnectedPlayers = () => {
  const { act, data } = useBackend<Data>();
  const players = [...(data.players || [])].sort(
    (a, b) => b.time_away - a.time_away,
  );
  const [selected, setSelected] = useState<string[]>([]);

  // Drop selections for players who are no longer listed after a refresh.
  const selectedRefs = selected.filter((ref) =>
    players.some((player) => player.ref === ref),
  );
  const allSelected =
    players.length > 0 && selectedRefs.length === players.length;

  // Each ref is sent with its ckey so the server can tell if the ref now points at someone else.
  const fartravel = (refs: string[]) =>
    act('fartravel', {
      targets: Object.fromEntries(
        refs.map((ref) => [
          ref,
          players.find((player) => player.ref === ref)?.ckey,
        ]),
      ),
    });

  const toggle = (ref: string) => {
    setSelected(
      selectedRefs.includes(ref)
        ? selectedRefs.filter((r) => r !== ref)
        : [...selectedRefs, ref],
    );
  };

  return (
    <Window width={820} height={520} title="Disconnected Players" display_title={ADMIN_PANEL_LABELS['Disconnected Players']}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Button icon="sync" onClick={() => act('refresh')}>
              刷新
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title={`${ADMIN_PANEL_LABELS.Disconnected} (${players.length})`}>
              {players.length === 0 ? (
                <NoticeBox>没有离线玩家。</NoticeBox>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell collapsing>
                      <Button.Checkbox
                        checked={allSelected}
                        tooltip="全选"
                        onClick={() =>
                          setSelected(
                            allSelected ? [] : players.map((p) => p.ref),
                          )
                        }
                      />
                    </Table.Cell>
                    <Table.Cell>账号</Table.Cell>
                    <Table.Cell>角色</Table.Cell>
                    <Table.Cell>职业</Table.Cell>
                    <Table.Cell collapsing>空缺名额</Table.Cell>
                    <Table.Cell>离线时长</Table.Cell>
                    <Table.Cell collapsing />
                  </Table.Row>
                  {players.map((player) => (
                    <Table.Row key={player.ref} className="candystripe">
                      <Table.Cell collapsing>
                        <Button.Checkbox
                          checked={selectedRefs.includes(player.ref)}
                          onClick={() => toggle(player.ref)}
                        />
                      </Table.Cell>
                      <Table.Cell>{player.ckey}</Table.Cell>
                      <Table.Cell>{player.name}</Table.Cell>
                      <Table.Cell>{player.role}</Table.Cell>
                      <Table.Cell collapsing textAlign="center">
                        {slotsText(player)}
                      </Table.Cell>
                      <Table.Cell>{player.time_away_text}</Table.Cell>
                      <Table.Cell collapsing>
                        <Box nowrap>
                          <Button
                            icon="eye"
                            tooltip="以幽灵身份跟随该角色"
                            onClick={() => act('follow', { ref: player.ref })}
                          >
                            跟随
                          </Button>
                          <Button
                            icon="user"
                            tooltip="打开玩家面板"
                            onClick={() =>
                              act('player_panel', { ref: player.ref })
                            }
                          >
                            玩家面板
                          </Button>
                          <Button
                            color="bad"
                            icon="door-open"
                            onClick={() => fartravel([player.ref])}
                          >
                            远行
                          </Button>
                        </Box>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Button
              color="bad"
              icon="door-open"
              disabled={selectedRefs.length === 0}
              onClick={() => fartravel(selectedRefs)}
            >
              让所选玩家远行（{selectedRefs.length}）
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

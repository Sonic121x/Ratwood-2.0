import {
  Box,
  Button,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { ADMIN_PANEL_LABELS } from './common/displayNames';
type ForensicAction = {
  time: string;
  // Null, as is name, for something no player did
  ckey: string | null;
  name: string | null;
  action: string;
  count: number;
};

type Touch = {
  ckey: string;
  first: string;
  last: string | null;
};

type Reagent = {
  name: string;
  volume: number;
  poison: BooleanLike;
};

type Contents = {
  reagents: Reagent[];
  total_volume: number;
  maximum_volume: number;
  // For a spiked drink, the reagent its next sip draws from first
  rim: string | null;
  items: string[];
};

type Report = {
  generated_at: string;
  type: string;
  location: string;
  is_item: BooleanLike;
  evidence: ForensicAction[];
  routine: ForensicAction[];
  touches: Touch[];
  last_toucher: string | null;
  contents: Contents | null;
};

type Data = {
  target_name: string;
  report: Report | null;
};

// About ten rows, after which the section scrolls instead of growing
const SCROLL_HEIGHT = '15em';

const PlayerButtons = (props: { ckey: string }) => {
  const { act } = useBackend();
  const { ckey } = props;
  return (
    <Box nowrap>
      <Button
        icon="eye"
        tooltip="以幽灵身份跟随该玩家"
        onClick={() => act('follow', { ckey })}
      >
        跟随
      </Button>
      <Button
        icon="user"
        tooltip="打开玩家面板"
        onClick={() => act('pp', { ckey })}
      >
        玩家面板
      </Button>
      <Button
        icon="envelope"
        tooltip="发送私信"
        onClick={() => act('pm', { ckey })}
      >
        私信
      </Button>
    </Box>
  );
};

const ActionsSection = (props: {
  title: string;
  actions: ForensicAction[];
}) => {
  const { title, actions } = props;
  return (
    <Section title={`${ADMIN_PANEL_LABELS[title] || title} (${actions.length})`}>
      {actions.length === 0 ? (
        <NoticeBox>暂无记录。</NoticeBox>
      ) : (
        <Box style={{ maxHeight: SCROLL_HEIGHT, overflowY: 'auto' }}>
          <Table>
            <Table.Row header>
              <Table.Cell collapsing>时间</Table.Cell>
              <Table.Cell>账号</Table.Cell>
              <Table.Cell>操作</Table.Cell>
              <Table.Cell collapsing />
            </Table.Row>
            {actions.map((entry, i) => (
              <Table.Row key={i} className="candystripe">
                <Table.Cell collapsing>
                  <Box nowrap>{entry.time}</Box>
                </Table.Cell>
                <Table.Cell>
                  <Box nowrap italic={!entry.ckey}>
                    {entry.ckey
                      ? `${entry.ckey} (${entry.name})`
                      : '非玩家操作'}
                  </Box>
                </Table.Cell>
                <Table.Cell>
                  <Box nowrap>
                    {entry.action}
                    {entry.count > 1 && ` (x${entry.count})`}
                  </Box>
                </Table.Cell>
                <Table.Cell collapsing>
                  {entry.ckey && <PlayerButtons ckey={entry.ckey} />}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Box>
      )}
    </Section>
  );
};

const TouchesSection = (props: {
  touches: Touch[];
  lastToucher: string | null;
}) => {
  const { touches, lastToucher } = props;
  return (
    <Section title={`${ADMIN_PANEL_LABELS['Touched by hand']} (${touches.length})`}>
      {touches.length === 0 ? (
        <NoticeBox>暂无记录。</NoticeBox>
      ) : (
        <Box style={{ maxHeight: SCROLL_HEIGHT, overflowY: 'auto' }}>
          <Table>
            <Table.Row header>
              <Table.Cell collapsing>账号</Table.Cell>
              <Table.Cell>接触记录</Table.Cell>
              <Table.Cell collapsing />
            </Table.Row>
            {touches.map((touch) => (
              <Table.Row key={touch.ckey} className="candystripe">
                <Table.Cell collapsing>
                  <Box nowrap>{touch.ckey}</Box>
                </Table.Cell>
                <Table.Cell>
                  <Box nowrap>首次：{touch.first}</Box>
                  {touch.last && <Box nowrap>最后：{touch.last}</Box>}
                </Table.Cell>
                <Table.Cell collapsing>
                  <PlayerButtons ckey={touch.ckey} />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Box>
      )}
      {lastToucher && (
        <Box color="label" mt={1}>
          最后接触者：{lastToucher}。
        </Box>
      )}
    </Section>
  );
};

const ContentsSection = (props: { contents: Contents }) => {
  const { reagents, total_volume, maximum_volume, rim, items } = props.contents;
  return (
    <Section title={`${ADMIN_PANEL_LABELS.Contents} (${total_volume}/${maximum_volume}u)`}>
      {rim && (
        <NoticeBox danger>
          容器边缘被下了药，下一口会优先摄入{rim}。请查看可疑操作，
          确认被撒入的物质。
        </NoticeBox>
      )}
      {reagents.length === 0 ? (
        <NoticeBox>空。</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>试剂</Table.Cell>
            <Table.Cell collapsing>含量</Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {reagents.map((reagent, i) => (
            <Table.Row key={i} className="candystripe">
              <Table.Cell>{reagent.name}</Table.Cell>
              <Table.Cell collapsing>
                <Box nowrap>{reagent.volume}u</Box>
              </Table.Cell>
              <Table.Cell collapsing>
                {!!reagent.poison && (
                  <Box nowrap bold color="bad">
                    毒物
                  </Box>
                )}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
      {items.length > 0 && (
        <Box color="label" mt={1}>
          内含物品：{items.join('、')}
        </Box>
      )}
    </Section>
  );
};

export const ViewForensics = () => {
  const { act, data } = useBackend<Data>();
  const { target_name, report } = data;

  return (
    <Window width={780} height={700} title={`Forensics: ${target_name}`} display_title={`${ADMIN_PANEL_LABELS.Forensics}：${target_name}`}>
      <Window.Content scrollable>
        <Section>
          <Stack align="center">
            <Stack.Item>
              <Button icon="file" onClick={() => act('generate')}>
                {report ? '重新生成记录' : '生成记录'}
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              {report && (
                <Box color="label">
                  <Box>生成时间：{report.generated_at}</Box>
                  <Box>{report.type}</Box>
                  <Box>{report.location}</Box>
                </Box>
              )}
            </Stack.Item>
            <Stack.Item>
              <Tooltip content="所有时间均为从本回合开始计算的回合时间。">
                <Box color="label" nowrap>
                  <Icon name="clock" mr={0.5} />
                  回合时间
                </Box>
              </Tooltip>
            </Stack.Item>
            <Stack.Item>
              <Button icon="location-arrow" onClick={() => act('jump')}>
                跳转
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        {!report ? (
          <NoticeBox>
            点击“生成记录”以读取此物体的取证信息。
          </NoticeBox>
        ) : (
          <>
            {report.contents && <ContentsSection contents={report.contents} />}
            <ActionsSection
              title={
                report.is_item
                  ? 'Picked up and dropped'
                  : 'Opened, closed and locked'
              }
              actions={report.routine}
            />
            <ActionsSection
              title="Suspicious actions"
              actions={report.evidence}
            />
            <TouchesSection
              touches={report.touches}
              lastToucher={report.last_toucher}
            />
          </>
        )}
        {report && (
          <Box color="label">
            每个列表保留最近30条记录。连续重复的操作合并显示在
            同一行。
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};

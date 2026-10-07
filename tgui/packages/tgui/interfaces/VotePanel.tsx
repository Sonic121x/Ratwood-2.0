import {
  BlockQuote,
  Box,
  Button,
  Dimmer,
  Icon,
  LabeledList,
  NoticeBox,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { Section } from '../components/Localized';

import { useBackend } from '../backend';
import { Window } from '../layouts';

enum VoteConfig {
  None = -1,
  Disabled = 0,
  Enabled = 1,
}

type Vote = {
  name: string;
  canBeInitiated: BooleanLike;
  config: VoteConfig;
  message: string;
};

type Option = {
  name: string;
  votes: number;
};

type ActiveVote = {
  vote: Vote;
  question: string | null;
  timeRemaining: number;
  displayStatistics: boolean;
  choices: Option[];
  countMethod: number;
};

type UserData = {
  ckey: string;
  isGhost: BooleanLike;
  isLowerAdmin: BooleanLike;
  isUpperAdmin: BooleanLike;
  singleSelection: string | null;
  multiSelection: string[] | null;
  countMethod: VoteSystem;
};

enum VoteSystem {
  VOTE_SINGLE = 1,
  VOTE_MULTI = 2,
}

type Data = {
  currentVote: ActiveVote;
  possibleVotes: Vote[];
  user: UserData;
  LastVoteTime: number;
  VoteCD: number;
  deadVoteEnabled: BooleanLike;
};
const displayVoteName = (name: string) => ({ Custom: '自定义', endround: '结束本轮', Map: '地图', Restart: '重启回合', chaos: '回合类型' })[name] || name;
export const VotePanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentVote, user, LastVoteTime, VoteCD } = data;

  let windowTitle = 'Vote';
  if (currentVote) {
    windowTitle +=
      ': ' +
      (currentVote.question || currentVote.vote.name).replace(/^\w/, (c) =>
        c.toUpperCase(),
      );
  }

  return (
    <Window title={windowTitle} display_title={`投票${currentVote ? `：${currentVote.question || displayVoteName(currentVote.vote.name)}` : ''}`} width={400} height={500}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section
              title="New Vote" display_title="发起投票"
              buttons={
                !!user.isLowerAdmin && (
                  <Stack>
                    <Stack.Item>
                      <Button
                        icon="refresh"
                        disabled={LastVoteTime + VoteCD <= 0}
                        onClick={() => act('resetCooldown')}
                      >
                        重置冷却时间
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button.Checkbox
                        disabled={!user.isUpperAdmin}
                        onClick={() => act('toggleDeadVote')}
                        checked={!data.deadVoteEnabled}
                        color="primary"
                      >
                        亡者投票
                      </Button.Checkbox>
                    </Stack.Item>
                  </Stack>
                )
              }
            >
              <VoteOptions />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title="Active Vote" display_title="正在进行的投票">
              <ChoicesPanel />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <TimePanel />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const VoteOptionDimmer = (props) => {
  const { data } = useBackend<Data>();
  const { LastVoteTime, VoteCD } = data;

  return (
    <Dimmer>
      <Box textAlign="center">
        <Box fontSize={2} bold>
          投票冷却中
        </Box>
        <Box fontSize={1.5}>{Math.floor((VoteCD + LastVoteTime) / 10)}秒</Box>
      </Box>
    </Dimmer>
  );
};

const VoteOptions = (props) => {
  const { act, data } = useBackend<Data>();
  const { possibleVotes, user, LastVoteTime, VoteCD } = data;

  return (
    <Stack.Item>
      {LastVoteTime + VoteCD > 0 && <VoteOptionDimmer />}
      <Stack vertical justify="space-between">
        {possibleVotes.map((option) => (
          <Stack.Item key={option.name}>
            <Stack>
              {!!user.isLowerAdmin && (
                <Stack.Item>
                  <Button.Checkbox
                    color="primary"
                    checked={
                      option.config === VoteConfig.Enabled ||
                      option.config === VoteConfig.None
                    }
                    disabled={
                      !user.isUpperAdmin || option.config === VoteConfig.None
                    }
                    tooltip={
                      option.config === VoteConfig.None
                        ? '此投票不可禁用。'
                        : null
                    }
                    onClick={() =>
                      act('toggleVote', {
                        voteName: option.name,
                      })
                    }
                  >
                    启用
                  </Button.Checkbox>
                </Stack.Item>
              )}
              <Stack.Item>
                <Button
                  disabled={!option.canBeInitiated}
                  onClick={() =>
                    act('callVote', {
                      voteName: option.name,
                    })
                  }
                  icon="play"
                />
              </Stack.Item>
              <Stack.Item>
                <Tooltip content={option.message}>
                  <BlockQuote style={{ lineHeight: '1.7em' }}>
                    {displayVoteName(option.name)}投票
                  </BlockQuote>
                </Tooltip>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Stack.Item>
  );
};

const ChoicesPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentVote, user } = data;

  return (
    <>
      {currentVote && currentVote.countMethod === VoteSystem.VOTE_SINGLE ? (
        <NoticeBox success>请选择一项</NoticeBox>
      ) : null}
      {currentVote &&
      currentVote.choices.length !== 0 &&
      currentVote.countMethod === VoteSystem.VOTE_SINGLE ? (
        <LabeledList>
          {currentVote.choices.map((choice) => (
            <Box key={choice.name}>
              <LabeledList.Item
                label={choice.name.replace(/^\w/, (c) => c.toUpperCase())}
                textAlign="right"
                buttons={
                  <Button
                    tooltip={
                      user.isGhost && '管理员已禁止幽灵投票。'
                    }
                    disabled={
                      user.singleSelection === choice.name || user.isGhost
                    }
                    onClick={() => {
                      act('voteSingle', { voteOption: choice.name });
                    }}
                  >
                    投票
                  </Button>
                }
              >
                {user.singleSelection &&
                  choice.name === user.singleSelection && (
                    <Icon align="right" mr={2} color="green" name="vote-yea" />
                  )}
                {currentVote.displayStatistics ? `${choice.votes} 票` : null}
              </LabeledList.Item>
              <LabeledList.Divider />
            </Box>
          ))}
        </LabeledList>
      ) : null}
      {currentVote && currentVote.countMethod === VoteSystem.VOTE_MULTI ? (
        <NoticeBox success>可选择任意数量的选项</NoticeBox>
      ) : null}
      {currentVote &&
      currentVote.choices.length !== 0 &&
      currentVote.countMethod === VoteSystem.VOTE_MULTI ? (
        <LabeledList>
          {currentVote.choices.map((choice) => (
            <Box key={choice.name}>
              <LabeledList.Item
                label={choice.name.replace(/^\w/, (c) => c.toUpperCase())}
                textAlign="right"
                buttons={
                  <Button
                    tooltip={
                      user.isGhost && '管理员已禁止幽灵投票。'
                    }
                    disabled={user.isGhost}
                    onClick={() => {
                      act('voteMulti', { voteOption: choice.name });
                    }}
                  >
                    投票
                  </Button>
                }
              >
                {user.multiSelection &&
                user.multiSelection[user.ckey.concat(choice.name)] === 1 ? (
                  <Icon align="right" mr={2} color="blue" name="vote-yea" />
                ) : null}
                {choice.votes} 票
              </LabeledList.Item>
              <LabeledList.Divider />
            </Box>
          ))}
        </LabeledList>
      ) : null}
      {currentVote ? null : <NoticeBox>当前没有进行中的投票！</NoticeBox>}
    </>
  );
};

const TimePanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentVote, user } = data;

  return (
    <Stack.Item>
      <Stack justify="space-between">
        <Box fontSize={1.5}>
          {currentVote
            ? `剩余时间：${currentVote.timeRemaining}秒`
            : '当前没有投票'}
        </Box>
        {!!user.isLowerAdmin && (
          <Stack>
            <Stack.Item>
              <Button
                color="green"
                disabled={!user.isLowerAdmin || !currentVote}
                onClick={() => act('endNow')}
                style={{ lineHeight: '1.8em' }}
              >
                立即结束
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                color="red"
                disabled={!user.isLowerAdmin || !currentVote}
                onClick={() => act('cancel')}
                style={{ lineHeight: '1.8em' }}
              >
                取消
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Stack>
    </Stack.Item>
  );
};

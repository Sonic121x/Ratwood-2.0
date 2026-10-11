import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Command = {
  id: string;
  name: string;
  description: string | null;
  category: string;
  favorite: BooleanLike;
  available: BooleanLike;
  reason: string;
};

type Data = {
  commands: Command[];
  notice: string;
  notice_error: BooleanLike;
};

export const IntegratedCommands = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState('favorites');
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState('');
  const commands = data.commands || [];
  const tabCommands = commands.filter(
    (command) => tab === 'all' || command.favorite,
  );
  const categories = Array.from(
    new Set(tabCommands.map((command) => command.category)),
  ).sort((left, right) => left.localeCompare(right, 'zh-CN'));
  const selectedCategory = categories.includes(category) ? category : '';
  const normalizedQuery = query.trim().toLocaleLowerCase();
  const rows = tabCommands.filter(
    (command) =>
      (!selectedCategory || command.category === selectedCategory) &&
      command.name.toLocaleLowerCase().includes(normalizedQuery),
  );
  if (tab === 'all') {
    rows.sort((left, right) => left.name.localeCompare(right.name, 'zh-CN'));
  }

  return (
    <Window title="集成指令" width={760} height={650}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                icon="star"
                selected={tab === 'favorites'}
                onClick={() => setTab('favorites')}
              >
                我的收藏（
                {commands.filter((command) => command.favorite).length}）
              </Tabs.Tab>
              <Tabs.Tab
                icon="list"
                selected={tab === 'all'}
                onClick={() => setTab('all')}
              >
                全部指令
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Input
                  fluid
                  placeholder="搜索指令名称"
                  value={query}
                  onChange={setQuery}
                />
              </Stack.Item>
              <Stack.Item>
                <Dropdown
                  width={18}
                  options={['全部分类', ...categories]}
                  selected={selectedCategory || '全部分类'}
                  onSelected={(value) =>
                    setCategory(value === '全部分类' ? '' : value)
                  }
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <NoticeBox danger={!!data.notice_error}>{data.notice}</NoticeBox>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title={`指令列表（${rows.length}）`}>
              {rows.length === 0 && (
                <Box color="label">
                  {tab === 'favorites' && tabCommands.length === 0
                    ? '尚未收藏指令，请到“全部指令”中点击星标添加。'
                    : '没有符合筛选条件的指令。'}
                </Box>
              )}
              {rows.map((command) => (
                <Section key={command.id} mb={1}>
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        icon="star"
                        selected={!!command.favorite}
                        color={command.favorite ? 'yellow' : undefined}
                        tooltip={command.favorite ? '取消收藏' : '收藏指令'}
                        disabled={!command.favorite && !command.available}
                        onClick={() =>
                          act(command.favorite ? 'unfavorite' : 'favorite', {
                            id: command.id,
                          })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box bold>{command.name}</Box>
                      <Box color="label" fontSize="0.9em">
                        {command.category}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="play"
                        disabled={!command.available}
                        tooltip={command.reason || '使用原指令'}
                        onClick={() => act('execute', { id: command.id })}
                      >
                        执行
                      </Button>
                    </Stack.Item>
                  </Stack>
                  {command.description && (
                    <Box mt={0.5}>{command.description}</Box>
                  )}
                  {!!command.reason && (
                    <Box mt={0.5} color="bad">
                      {command.reason}
                    </Box>
                  )}
                </Section>
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

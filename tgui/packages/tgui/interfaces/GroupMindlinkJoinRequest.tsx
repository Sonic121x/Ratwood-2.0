import { type KeyboardEvent } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { isEscape } from 'tgui-core/keys';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Loader } from './common/Loader';

type Data = {
  message: string;
  timeout: number;
  title: string;
};

export const GroupMindlinkJoinRequest = () => {
  const { act, data } = useBackend<Data>();
  const { message = '', timeout, title } = data;
  // 按每行二十二个全角字保守预留正文高度，并为标题和固定按钮额外留白。
  const contentLines = message
    .split('\n')
    .reduce(
      (total, line) =>
        total + Math.max(1, Math.ceil(Array.from(line).length / 22)),
      0,
    );
  const height = Math.max(460, 180 + contentLines * 26);

  const handleKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    if (isEscape(event.key)) {
      event.preventDefault();
      act('cancel');
    }
  };

  return (
    <Window width={560} height={height} title={title}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={handleKeyDown}>
        <Stack fill vertical>
          <Stack.Item grow minHeight={0}>
            <Section fill scrollable>
              <Box
                color="label"
                style={{ overflowWrap: 'anywhere', lineHeight: 1.6 }}
              >
                {message}
              </Box>
            </Section>
          </Stack.Item>
          {/* 按钮位于滚动区外，不随说明文字增长而被挤出窗口。 */}
          <Stack.Item shrink={0}>
            <Stack>
              <Stack.Item grow>
                <Button
                  fluid
                  textAlign="center"
                  py={1}
                  onClick={() => act('choose', { choice: '拒绝' })}
                >
                  拒绝
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  textAlign="center"
                  py={1}
                  onClick={() => act('choose', { choice: '同意' })}
                >
                  同意
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

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

export const LocatePersonRequest = () => {
  const { act, data } = useBackend<Data>();
  const { message = '', timeout, title } = data;
  // 按原双按钮弹窗的尺寸公式，将宽高分别扩大到两倍。
  const width = 345 * 2;
  const height =
    (120 + (message.length > 30 ? Math.ceil(message.length / 4) : 0)) * 2;

  const handleKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    if (isEscape(event.key)) {
      event.preventDefault();
      act('cancel');
    }
  };

  return (
    <Window width={width} height={height} title={title}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={handleKeyDown}>
        <Stack fill vertical>
          <Stack.Item grow minHeight={0}>
            <Section fill scrollable>
              <Box
                color="label"
                style={{ overflowWrap: 'anywhere', whiteSpace: 'pre-wrap' }}
              >
                {message}
              </Box>
            </Section>
          </Stack.Item>
          {/* 按钮固定在正文滚动区外，长姓名或较大字体也不会遮住选择。 */}
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

import { type KeyboardEvent, useState } from 'react';
import { Autofocus, Box, Button, Section, Stack } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Loader } from './common/Loader';

type Data = {
  autofocus: BooleanLike;
  buttons: string[];
  message: string;
  timeout: number;
  title: string;
};

export const YandereCrushConfirm = () => {
  const { act, data } = useBackend<Data>();
  const { autofocus, buttons = [], message = '', timeout, title } = data;
  const [selected, setSelected] = useState(0);

  const handleKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    if (isEscape(event.key)) {
      event.preventDefault();
      act('cancel');
    } else if (event.key === KEY.Enter || event.key === KEY.Space) {
      event.preventDefault();
      act('choose', { choice: buttons[selected] });
    } else if (
      event.key === KEY.Left ||
      event.key === KEY.Right ||
      event.key === KEY.Tab
    ) {
      event.preventDefault();
      setSelected((selected + 1) % buttons.length);
    }
  };

  return (
    <Window width={560} height={320} title={title}>
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
          {/* Keep the choices outside the scrollable text area. */}
          <Stack.Item shrink={0}>
            {!!autofocus && <Autofocus />}
            <Stack>
              {buttons.map((button, index) => (
                <Stack.Item grow key={button}>
                  <Button
                    fluid
                    textAlign="center"
                    py={1}
                    selected={selected === index}
                    onClick={() => act('choose', { choice: button })}
                  >
                    {button}
                  </Button>
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

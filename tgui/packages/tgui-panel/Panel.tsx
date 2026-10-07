/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Pane } from 'tgui/layouts';
import { Button, Section, Stack } from 'tgui-core/components';

import { NowPlayingWidget, useAudio } from './audio';
import { ChatPanel, ChatTabs } from './chat';
import { useGame } from './game';
import { Notifications } from './Notifications';
import { PingIndicator } from './ping';
import { ReconnectButton } from './reconnect';
import { SettingsPanel, useSettings } from './settings';

export const Panel = (props) => {
  const audio = useAudio();
  const settings = useSettings();
  const game = useGame();
  if (process.env.NODE_ENV !== 'production') {
    const { useDebug, KitchenSink } = require('tgui/debug');
    const debug = useDebug();
    if (debug.kitchenSink) {
      return <KitchenSink panel />;
    }
  }

  return (
    <Pane theme="dark">
      <Stack fill vertical>
        <Stack.Item fontSize={1.2}>
          <Section fitted>
            <Stack mr={1} align="center">
              <Stack.Item grow overflowX="auto">
                <ChatTabs />
              </Stack.Item>
              <Stack.Item>
                <PingIndicator />
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="grey"
                  selected={audio.visible}
                  icon="music"
                  tooltip="音乐播放器"
                  tooltipPosition="bottom-start"
                  onClick={() => audio.toggle()}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon={settings.visible ? 'times' : 'cog'}
                  selected={settings.visible}
                  tooltip={
                    settings.visible ? '关闭设置' : '打开设置'
                  }
                  tooltipPosition="bottom-start"
                  onClick={() => settings.toggle()}
                />
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        {audio.visible && (
          <Stack.Item fontSize={1.2}>
            <Section>
              <NowPlayingWidget />
            </Section>
          </Stack.Item>
        )}
        {settings.visible && (
          <Stack.Item fontSize={1.2}>
            <SettingsPanel />
          </Stack.Item>
        )}
        <Stack.Item grow>
          <Section fill fitted position="relative">
            <Pane.Content scrollable>
              <ChatPanel lineHeight={settings.lineHeight} />
            </Pane.Content>
            <Notifications>
              {game.connectionLostAt && (
                <Notifications.Item rightSlot={<ReconnectButton />}>
                  你可能已暂离、遇到延迟，或连接已经
                  断开。
                </Notifications.Item>
              )}
              {game.roundRestartedAt && (
                <Notifications.Item>
                  服务器正在重启，连接已断开。
                  请等待自动重连。
                </Notifications.Item>
              )}
            </Notifications>
          </Section>
        </Stack.Item>
      </Stack>
    </Pane>
  );
};

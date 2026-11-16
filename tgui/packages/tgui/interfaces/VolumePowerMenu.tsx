import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { DragSlider } from 'tgui/components';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';

type Data = {
  master: number;
  effects: number;
  instruments: number;
  replace_uploaded_songs: boolean;
  music: number;
  adminmusic: number;
  streamedmusic: number;
  combat: number;
  ambience: number;
  lobby: number;
  point_ambience_volume: number;
  point_ambience_independent: boolean;
  point_ambience: boolean;
  point_ambience_torch: boolean;
};

type VolumeRowProps = {
  label: string;
  value: number;
  id: string;
  hint: string;
};

const VolumeRow = ({ label, value, id, hint }: VolumeRowProps) => {
  const { act } = useBackend<Data>();

  return (
    <DragSlider
      label={label}
      hint={hint}
      value={value}
      minValue={0}
      maxValue={100}
      unit="%"
      onChange={(volume) => act('set_volume', { id, value: volume })}
    />
  );
};

type ToggleRowProps = {
  label: string;
  enabled: boolean;
  id: string;
  hint: string;
};

const ToggleRow = ({ label, enabled, id, hint }: ToggleRowProps) => {
  const { act } = useBackend<Data>();

  return (
    <Stack align="center" mb={0.75}>
      <Stack.Item basis="36%" shrink={0}>
        <Tooltip content={hint} position="right">
          <b>{label}</b>
        </Tooltip>
      </Stack.Item>
      <Stack.Item grow>
        <Button
          width={5}
          textAlign="center"
          icon={enabled ? 'volume-up' : 'volume-mute'}
          selected={enabled}
          onClick={() => act('toggle', { id })}
        >
          {enabled ? '开启' : '关闭'}
        </Button>
      </Stack.Item>
    </Stack>
  );
};

export const VolumePowerMenu = () => {
  const { act, data, config } = useBackend<Data>();
  const [tab, setTab] = useState(0);
  const [content, setContent] = useState<HTMLDivElement | null>(null);
  const [height, setHeight] = useState(420);
  const muted = data.master === 0;
  const pointAmbienceIndependent = data.point_ambience_independent ?? true;
  const effectivePointVolume =
    (pointAmbienceIndependent ? 1 : (data.master ?? 100) / 100) *
    (data.point_ambience_volume ?? 100);
  const lowPointVolume =
    (data.point_ambience ?? true) && effectivePointVolume < 50;
  const volumeNotice = muted
    ? pointAmbienceIndependent &&
      (data.point_ambience ?? true) &&
      (data.point_ambience_volume ?? 100) > 0
      ? '主音量已静音，但独立音量的局部环境音仍在播放。其他持续循环的声音可用“停止声音”关闭。'
      : '游戏已静音。部分循环音可能继续播放；请使用“停止声音”，或等待它们结束。'
    : lowPointVolume
      ? '局部环境音的实际音量低于 50%，可能无法呈现预期效果。'
      : null;
  useEffect(() => {
    if (!content) return;
    let cancelled = false;
    const fitHeight = () => {
      if (cancelled) return;
      const scale = config.window.scale ? 1 : window.devicePixelRatio;
      const padding = parseFloat(
        getComputedStyle(document.documentElement).fontSize,
      );
      const bounds = content.getBoundingClientRect();
      const zoom = content.offsetHeight
        ? bounds.height / content.offsetHeight
        : 1;
      const titleHeight =
        content.closest('.Window__rest')?.getBoundingClientRect().top ?? 0;
      setHeight(
        Math.ceil((titleHeight + bounds.height + padding * 2 * zoom) * scale),
      );
    };
    const frame = requestAnimationFrame(fitHeight);
    document.fonts.ready.then(fitHeight);
    return () => {
      cancelled = true;
      cancelAnimationFrame(frame);
    };
  }, [content, config.window.scale, config.window.theme, tab, volumeNotice]);
  const {
    master,
    effects,
    instruments,
    replace_uploaded_songs,
    music,
    adminmusic,
    streamedmusic,
    combat,
    ambience,
    lobby,
    point_ambience_volume,
    point_ambience_independent,
    point_ambience,
    point_ambience_torch,
  } = data;

  return (
    <Window width={440} height={height}>
      <Window.Content scrollable>
        <div ref={setContent} className="AudioSettings">
          <Section title="主音量" className="AudioSettings__panel">
            <VolumeRow
              label="主音量"
              value={master ?? 100}
              id="master"
              hint="调整所有声音的音量比例，使用独立音量的局部环境音除外。"
            />
            <Box fontSize="0.85em">
              设为 0% 时，管理员求助和管理员私信提示音仍会播放。
            </Box>
          </Section>
          <Section className="AudioSettings__panel">
            <Tabs fluid className="AudioSettings__tabs">
              <Tabs.Tab
                icon="volume-up"
                selected={tab === 0}
                onClick={() => setTab(0)}
              >
                游戏音效
              </Tabs.Tab>
              <Tabs.Tab
                icon="music"
                selected={tab === 1}
                onClick={() => setTab(1)}
              >
                其他音频
              </Tabs.Tab>
              <Tabs.Tab
                icon="fire"
                selected={tab === 2}
                onClick={() => setTab(2)}
              >
                局部环境音
              </Tabs.Tab>
            </Tabs>
            {tab === 0 && (
              <Box mt={1}>
                <VolumeRow
                  label="音效"
                  value={effects ?? 50}
                  id="effects"
                  hint="游戏世界中的声音：战斗、脚步、物品和门。"
                />
                <VolumeRow
                  label="区域环境音"
                  value={ambience ?? 100}
                  id="ambience"
                  hint="所在区域的循环环境音和雨声。"
                />
                <VolumeRow
                  label="乐器"
                  value={instruments ?? 50}
                  id="instruments"
                  hint="吟游诗人、音乐盒和蜡筒音乐装置。"
                />
                <Box ml={1} mt={-0.5} mb={0.5}>
                  <Button.Checkbox
                    checked={replace_uploaded_songs ?? false}
                    color="transparent"
                    compact
                    fontSize="0.85em"
                    tooltip="节省带宽：用内置曲目替代玩家上传的乐器和音乐盒曲目，不向你传输上传的文件。"
                    tooltipPosition="right"
                    onClick={() =>
                      act('toggle', { id: 'replace_uploaded_songs' })
                    }
                  >
                    改用游戏内置曲目
                  </Button.Checkbox>
                </Box>
                <VolumeRow
                  label="世界音乐"
                  value={music ?? 100}
                  id="music"
                  hint="游戏世界自带的背景音乐。"
                />
                <VolumeRow
                  label="战斗音乐"
                  value={combat ?? 50}
                  id="combat"
                  hint="战斗模式下的音乐。"
                />
              </Box>
            )}
            {tab === 1 && (
              <Box mt={1}>
                <VolumeRow
                  label="流媒体音乐"
                  value={streamedmusic ?? 50}
                  id="streamedmusic"
                  hint="在聊天面板中播放的流媒体音乐。"
                />
                <VolumeRow
                  label="管理员播放的声音"
                  value={adminmusic ?? 50}
                  id="adminmusic"
                  hint="管理员播放的声音。不影响管理员求助提示音。"
                />
                <VolumeRow
                  label="大厅音乐"
                  value={lobby ?? 100}
                  id="lobby"
                  hint="标题画面的音乐。"
                />
              </Box>
            )}
            {tab === 2 && (
              <Box mt={1}>
                <Box mb={1}>
                  附近的火焰、喷泉、河流等环境声音。
                </Box>
                <VolumeRow
                  label="音量"
                  value={point_ambience_volume ?? 100}
                  id="point_ambience_volume"
                  hint="附近环境声音的音量。"
                />
                <ToggleRow
                  label="独立音量"
                  enabled={point_ambience_independent ?? true}
                  id="point_ambience_independent"
                  hint="改变主音量时，局部环境音仍保持所选音量。建议开启，以获得预期的环境音平衡。"
                />
                <ToggleRow
                  label="局部环境音"
                  enabled={point_ambience ?? true}
                  id="point_ambience"
                  hint="开启或关闭全部局部环境音。"
                />
                <ToggleRow
                  label="火炬环境音"
                  enabled={point_ambience_torch ?? true}
                  id="point_ambience_torch"
                  hint="壁灯、立式火盆，以及你手中的火炬。"
                />
              </Box>
            )}
          </Section>
          {volumeNotice && (
            <Box textAlign="center">
              <Box className="AudioSettings__muteNote">{volumeNotice}</Box>
            </Box>
          )}
          <Box
            mt={0.5}
            fontSize="0.75em"
            textAlign="center"
            style={{ opacity: 0.7 }}
          >
            将鼠标悬停在设置上可查看说明。
          </Box>
        </div>
      </Window.Content>
    </Window>
  );
};

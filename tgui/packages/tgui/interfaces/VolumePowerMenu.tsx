import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { NumberInput, Stack } from 'tgui-core/components';
import { Section } from '../components/Localized';
type Data = {
  master: number;
  music: number;
  combat: number;
  ambience: number;
  lobby: number;
};

type VolumeRowProps = {
  label: string;
  value: number;
  id: string;
  description: string;
};

const VolumeRow = ({ label, value, id, description }: VolumeRowProps) => {
  const { act } = useBackend<Data>();

  return (
    <Stack align="center" mb={1.5}>
      <Stack.Item basis="50%">
        <b>{label}</b>
      </Stack.Item>
      <Stack.Item grow>
        <NumberInput
          minValue={0}
          maxValue={100}
          step={1}
          value={value}
          width="100%"
          onChange={(newValue: number) =>
            act('set_volume', { id, value: newValue })
          }
        />
      </Stack.Item>
      <Stack.Item basis="10%" textAlign="right">
        %
      </Stack.Item>
      <Stack.Item basis="100%">
        <span className="color-label">{description}</span>
      </Stack.Item>
    </Stack>
  );
};

export const VolumePowerMenu = () => {
  const { data } = useBackend<Data>();
  const {
    master,
    music,
    combat,
    ambience,
    lobby,
  } = data;

  const masterValue = master ?? 100;
  const musicValue = music ?? 100;
  const combatValue = combat ?? 50;
  const ambienceValue = ambience ?? 100;
  const lobbyValue = lobby ?? 100;

  return (
    <Window width={470} height={390} display_title="音量设置">
      <Window.Content>
        <Section title="Volume Levels" display_title="音量" fill>
          <VolumeRow
            label="音效"
            value={masterValue}
            id="master"
            description="音乐与环境声以外的音效。"
          />
          <VolumeRow
            label="音乐"
            value={musicValue}
            id="music"
            description="非战斗音乐与管理员播放的音乐。"
          />
          <VolumeRow
            label="战斗音乐"
            value={combatValue}
            id="combat"
            description="战斗及相关音乐频道。"
          />
          <VolumeRow
            label="环境声"
            value={ambienceValue}
            id="ambience"
            description="氛围音与循环环境声频道。"
          />
          <VolumeRow
            label="大厅音乐"
            value={lobbyValue}
            id="lobby"
            description="标题界面与大厅音乐的播放音量。"
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

import { Button, LabeledList, Stack } from 'tgui-core/components'; import { Section } from '../../components/Localized';

import { useBackend } from '../../backend';
import { ControllerData } from './types';

export const OverviewSection = (props) => {
  const { act, data } = useBackend<ControllerData>();
  const {
    fast_update,
    rolling_length,
    map_cpu,
    subsystems = [],
    world_time,
  } = data;

  let avgUsage = 0;
  let overallOverrun = 0;
  for (let i = 0; i < subsystems.length; i++) {
    avgUsage += subsystems[i].usage_per_tick;
    overallOverrun += subsystems[i].overtime;
  }

  return (
    <Section
      fill
      title="Master Overview" display_title="主控制器总览"
      buttons={
        <>
          <Button
            tooltip="快速刷新"
            icon={fast_update ? 'check-square-o' : 'square-o'}
            color={fast_update && 'average'}
            onClick={() => {
              act('toggle_fast_update');
            }}
          >
            快速
          </Button>
          <Button.Input
            currentValue={(rolling_length / 10).toString()}
            onCommit={(e, value) => {
              act('set_rolling_length', {
                rolling_length: value,
              });
            }}
          >
            平均值统计时段：{rolling_length / 10} 秒
          </Button.Input>
        </>
      }
    >
      <Stack fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="世界时间">
              {world_time.toFixed(1)}
            </LabeledList.Item>
            <LabeledList.Item label="地图 CPU 占用">
              {map_cpu.toFixed(2)}%
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="总体平均占用">
              {avgUsage.toFixed(2)}%
            </LabeledList.Item>
            <LabeledList.Item label="总体超时占用">
              {overallOverrun.toFixed(2)}%
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

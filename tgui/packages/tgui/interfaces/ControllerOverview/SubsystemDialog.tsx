import {
  Box,
  Button,
  Divider,
  LabeledList,
  Modal,
  Stack,
} from 'tgui-core/components';

import { SubsystemData } from './types';

type Props = {
  subsystem: SubsystemData;
  onClose: () => void;
};

export const SubsystemDialog = (props: Props) => {
  const { subsystem, onClose } = props;
  const {
    cost_ms,
    init_order,
    initialization_failure_message,
    last_fire,
    name,
    next_fire,
    overtime,
    tick_usage,
    usage_per_tick,
  } = subsystem;

  return (
    <Modal width="85%" ml={7}>
      <Stack fill>
        <Stack.Item grow fontSize="22px">
          {name}
        </Stack.Item>
        <Stack.Item>
          <Button color="bad" icon="times" onClick={onClose} />
        </Stack.Item>
      </Stack>
      <Divider />
      <Box p={1}>
        <LabeledList>
          <LabeledList.Item label="初始化顺序">{init_order}</LabeledList.Item>
          <LabeledList.Item label="上次执行">{last_fire}</LabeledList.Item>
          <LabeledList.Item label="下次执行">{next_fire}</LabeledList.Item>
          <LabeledList.Item label="耗时">
            {cost_ms.toFixed(2)}ms
          </LabeledList.Item>
          <LabeledList.Item label="当前帧占用">
            {tick_usage.toFixed(2)}%
          </LabeledList.Item>
          <LabeledList.Item label="平均每帧占用">
            {usage_per_tick.toFixed(2)}%
          </LabeledList.Item>
          <LabeledList.Item label="帧超时占用">
            {overtime.toFixed(2)}%
          </LabeledList.Item>
          {initialization_failure_message && (
            <LabeledList.Item color="bad">
              {initialization_failure_message}
            </LabeledList.Item>
          )}
        </LabeledList>
      </Box>
      <Stack fill justify="space-between">
        <Stack.Item />
        <Stack.Item>
          <Button color="good" onClick={onClose} px={3} py={1}>
            关闭
          </Button>
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

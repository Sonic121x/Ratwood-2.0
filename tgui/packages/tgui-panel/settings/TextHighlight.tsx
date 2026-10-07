import { useDispatch, useSelector } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Icon,
  Input,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';

import { rebuildChat } from '../chat/actions';
import {
  addHighlightSetting,
  removeHighlightSetting,
  updateHighlightSetting,
} from './actions';
import { WARN_AFTER_HIGHLIGHT_AMT } from './constants';
import {
  selectHighlightSettingById,
  selectHighlightSettings,
} from './selectors';

export function TextHighlightSettings(props) {
  const highlightSettings = useSelector(selectHighlightSettings);
  const dispatch = useDispatch();

  return (
    <Section fill scrollable height="250px">
      <Stack vertical>
        {highlightSettings.map((id, i) => (
          <TextHighlightSetting
            key={i}
            id={id}
            mb={i + 1 === highlightSettings.length ? 0 : '10px'}
          />
        ))}
        <Stack.Item>
          <Box>
            <Button
              color="transparent"
              icon="plus"
              onClick={() => {
                dispatch(addHighlightSetting());
              }}
            >
              添加高亮规则
            </Button>
            {highlightSettings.length >= WARN_AFTER_HIGHLIGHT_AMT && (
              <Box inline fontSize="0.9em" ml={1} color="red">
                <Icon mr={1} name="triangle-exclamation" />
                高亮规则过多可能导致性能
                问题！
              </Box>
            )}
          </Box>
        </Stack.Item>
      </Stack>
      <Divider />
      <Box>
        <Button icon="check" onClick={() => dispatch(rebuildChat())}>
          立即应用
        </Button>
        <Box inline fontSize="0.9em" ml={1} color="label">
          可能使聊天界面暂时卡顿。
        </Box>
      </Box>
    </Section>
  );
}

function TextHighlightSetting(props) {
  const { id, ...rest } = props;
  const highlightSettingById = useSelector(selectHighlightSettingById);
  const dispatch = useDispatch();
  const {
    highlightColor,
    highlightText,
    highlightWholeMessage,
    matchWord,
    matchCase,
  } = highlightSettingById[id];

  return (
    <Stack.Item {...rest}>
      <Stack mb={1} color="label" align="baseline">
        <Stack.Item grow>
          <Button
            color="transparent"
            icon="times"
            onClick={() =>
              dispatch(
                removeHighlightSetting({
                  id: id,
                }),
              )
            }
          >
            删除
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={highlightWholeMessage}
            tooltip="启用后，整条消息都会以黄色高亮显示。"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightWholeMessage: !highlightWholeMessage,
                }),
              )
            }
          >
            整条消息
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={matchWord}
            tooltipPosition="bottom-start"
            tooltip="启用后，仅完整词语匹配时触发（前后不能有其他字母）。不兼容标点符号；使用正则表达式时，此选项不生效。"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchWord: !matchWord,
                }),
              )
            }
          >
            完整词语
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            tooltip="启用后，高亮匹配将区分大小写。"
            checked={matchCase}
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchCase: !matchCase,
                }),
              )
            }
          >
            区分大小写
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <ColorBox mr={1} color={highlightColor} />
          <Input
            width="5em"
            monospace
            placeholder="#ffffff"
            value={highlightColor}
            onBlur={(value) =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightColor: value,
                }),
              )
            }
          />
        </Stack.Item>
      </Stack>
      <TextArea
        fluid
        height="3em"
        value={highlightText}
        placeholder="在此输入需高亮的词语，以英文逗号分隔，例如：词语1, 词语2, 词语3"
        onBlur={(value) =>
          dispatch(
            updateHighlightSetting({
              id: id,
              highlightText: value,
            }),
          )
        }
      />
    </Stack.Item>
  );
}

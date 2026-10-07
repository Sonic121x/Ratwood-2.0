import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Button,
  Collapsible,
  Divider,
  Input,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { clearChat, saveChatToDisk } from '../chat/actions';
import { exportSettings, updateSettings } from './actions';
import { FONTS } from './constants';
import { selectSettings } from './selectors';
import { importChatSettings } from './settingsImExport';

export function SettingsGeneral(props) {
  const { fontFamily, fontSize, lineHeight } = useSelector(selectSettings);
  const dispatch = useDispatch();
  const [freeFont, setFreeFont] = useState(false);

  const [editingPanes, setEditingPanes] = useState(false);

  return (
    <Section>
      <LabeledList>
        {/* <LabeledList.Item label="UI sizes">
          <Stack>
            <Stack.Item>
              <Button
                onClick={() =>
                  setEditingPanes((val) => {
                    setEditPaneSplitters(!val);
                    return !val;
                  })
                }
                color={editingPanes ? 'red' : undefined}
                icon={editingPanes ? 'save' : undefined}
              >
                {editingPanes ? 'Save' : 'Adjust UI Sizes'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={resetPaneSplitters} icon="refresh" color="red">
                Reset
              </Button>
            </Stack.Item>
          </Stack>
        </LabeledList.Item> */}
        <LabeledList.Item label="字体样式">
          <Stack.Item>
            {!freeFont ? (
              <Collapsible
                title={fontFamily}
                width={'100%'}
                buttons={
                  <Button
                    icon={freeFont ? 'lock-open' : 'lock'}
                    color={freeFont ? 'good' : 'bad'}
                    onClick={() => {
                      setFreeFont(!freeFont);
                    }}
                  >
                    自定义字体
                  </Button>
                }
              >
                {FONTS.map((FONT) => (
                  <Button
                    key={FONT}
                    fontFamily={FONT}
                    selected={fontFamily === FONT}
                    color="transparent"
                    onClick={() =>
                      dispatch(
                        updateSettings({
                          fontFamily: FONT,
                        }),
                      )
                    }
                  >
                    {FONT === 'Default' ? '默认' : FONT}
                  </Button>
                ))}
              </Collapsible>
            ) : (
              <Stack>
                <Input
                  fluid
                  value={fontFamily}
                  onBlur={(value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
                <Button
                  ml={0.5}
                  icon={freeFont ? 'lock-open' : 'lock'}
                  color={freeFont ? 'good' : 'bad'}
                  onClick={() => {
                    setFreeFont(!freeFont);
                  }}
                >
                  自定义字体
                </Button>
              </Stack>
            )}
          </Stack.Item>
        </LabeledList.Item>
        <LabeledList.Item label="字号" verticalAlign="middle">
          <Stack textAlign="center">
            <Stack.Item grow>
              <Slider
                width="100%"
                step={1}
                stepPixelSize={20}
                minValue={8}
                maxValue={32}
                value={fontSize}
                unit="px"
                format={(value) => toFixed(value)}
                onChange={(e, value) =>
                  dispatch(updateSettings({ fontSize: value }))
                }
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="行高">
          <Slider
            width="100%"
            step={0.01}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onChange={(e, value) =>
              dispatch(
                updateSettings({
                  lineHeight: value,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Stack fill>
        <Stack.Item mt={0.15}>
          <Button
            icon="compact-disc"
            tooltip="导出聊天设置"
            onClick={() => dispatch(exportSettings())}
          >
            导出设置
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.File
            accept=".json"
            tooltip="导入聊天设置"
            icon="arrow-up-from-bracket"
            onSelectFiles={(files) => importChatSettings(files)}
          >
            导入设置
          </Button.File>
        </Stack.Item>
        <Stack.Item grow mt={0.15}>
          <Button
            icon="save"
            tooltip="将当前标签页的聊天记录导出为 HTML 文件"
            onClick={() => dispatch(saveChatToDisk())}
          >
            保存聊天记录
          </Button>
        </Stack.Item>
        <Stack.Item mt={0.15}>
          <Button.Confirm
            icon="trash"
            tooltip="清空当前标签页的聊天记录"
            onClick={() => dispatch(clearChat())}
          >
            清空聊天
          </Button.Confirm>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

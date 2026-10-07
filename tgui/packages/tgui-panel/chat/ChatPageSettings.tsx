/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useDispatch, useSelector } from 'tgui/backend';
import {
  Button,
  Divider,
  Input,
  Stack,
} from 'tgui-core/components';
import { Collapsible, Section } from 'tgui/components/Localized';


import {
  moveChatPageLeft,
  moveChatPageRight,
  removeChatPage,
  toggleAcceptedType,
  updateChatPage,
} from './actions';
import { MESSAGE_TYPES } from './constants';
import { selectCurrentChatPage } from './selectors';

export function ChatPageSettings(props) {
  const page = useSelector(selectCurrentChatPage);
  const dispatch = useDispatch();

  return (
    <Section>
      <Stack align="center">
        {!page.isMain && (
          <Stack.Item>
            <Button
              color="blue"
              icon="angles-left"
              tooltip="将标签页左移"
              onClick={() =>
                dispatch(
                  moveChatPageLeft({
                    pageId: page.id,
                  }),
                )
              }
            />
          </Stack.Item>
        )}
        <Stack.Item grow ml={0.5}>
          <Input
            fluid
            value={page.name}
            onBlur={(value) =>
              dispatch(
                updateChatPage({
                  pageId: page.id,
                  name: value,
                }),
              )
            }
          />
        </Stack.Item>
        {!page.isMain && (
          <Stack.Item ml={0.5}>
            <Button
              color="blue"
              icon="angles-right"
              tooltip="将标签页右移"
              onClick={() =>
                dispatch(
                  moveChatPageRight({
                    pageId: page.id,
                  }),
                )
              }
            />
          </Stack.Item>
        )}
        <Stack.Item>
          <Button.Checkbox
            checked={page.hideUnreadCount}
            icon={page.hideUnreadCount ? 'bell-slash' : 'bell'}
            tooltip="关闭未读消息计数"
            onClick={() =>
              dispatch(
                updateChatPage({
                  pageId: page.id,
                  hideUnreadCount: !page.hideUnreadCount,
                }),
              )
            }
          >
            静音
          </Button.Checkbox>
        </Stack.Item>
        {!page.isMain && (
          <Stack.Item>
            <Button
              color="red"
              icon="times"
              onClick={() =>
                dispatch(
                  removeChatPage({
                    pageId: page.id,
                  }),
                )
              }
            >
              移除
            </Button>
          </Stack.Item>
        )}
      </Stack>
      <Divider />
      <Section title="Messages to display" display_title="显示的消息类型">
        {MESSAGE_TYPES.filter(
          (typeDef) => !typeDef.important && !typeDef.admin,
        ).map((typeDef) => (
          <Button.Checkbox
            key={typeDef.type}
            checked={page.acceptedTypes[typeDef.type]}
            onClick={() =>
              dispatch(
                toggleAcceptedType({
                  pageId: page.id,
                  type: typeDef.type,
                }),
              )
            }
          >
            {typeDef.name}
          </Button.Checkbox>
        ))}
        <Collapsible mt={1} color="transparent" title="Admin stuff" display_title="管理相关">
          {MESSAGE_TYPES.filter(
            (typeDef) => !typeDef.important && typeDef.admin,
          ).map((typeDef) => (
            <Button.Checkbox
              key={typeDef.type}
              checked={page.acceptedTypes[typeDef.type]}
              onClick={() =>
                dispatch(
                  toggleAcceptedType({
                    pageId: page.id,
                    type: typeDef.type,
                  }),
                )
              }
            >
              {typeDef.name}
            </Button.Checkbox>
          ))}
        </Collapsible>
      </Section>
    </Section>
  );
}

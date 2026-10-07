import { Button, Stack, Table } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { Section } from '../components/Localized';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Language = {
  name: string;
  desc: string;
  key: string;
};

type KnownLanguage = Language & {
  is_default: BooleanLike;
  shadow: BooleanLike;
  can_speak: BooleanLike;
};

type Data = {
  is_living: BooleanLike;
  languages: KnownLanguage[];
  admin_mode: BooleanLike;
  omnitongue: BooleanLike;
  unknown_languages: Language[];
};

export const LanguageMenu = (props) => {
  const { data } = useBackend<Data>();
  const { admin_mode } = data;

  return (
    <Window width={600} display_title="语言">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <KnownLanguages />
          </Stack.Item>
          {admin_mode ? (
            <Stack.Item grow>
              <AdminMenu />
            </Stack.Item>
          ) : null}
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const KnownLanguages = (props) => {
  const { data } = useBackend<Data>();

  const { languages, admin_mode } = data;

  return (
    <Section title="Known Languages" display_title="已掌握的语言" fill scrollable>
      <Table>
        <Table.Row header>
          <Table.Cell header>名称</Table.Cell>
          <Table.Cell header collapsing textAlign="right">
            按键
          </Table.Cell>
          <Table.Cell header collapsing textAlign="center">
            默认？
          </Table.Cell>
          {admin_mode ? (
            <Table.Cell header collapsing textAlign="center">
              删除
            </Table.Cell>
          ) : null}
        </Table.Row>
        {languages.map((lang) => (
          <KnownLanguageRow key={lang.name} lang={lang} />
        ))}
      </Table>
    </Section>
  );
};

export const KnownLanguageRow = (props: { lang: KnownLanguage }) => {
  const { act, data } = useBackend<Data>();
  const { admin_mode } = data;
  const { lang } = props;

  return (
    <Table.Row>
      <Table.Cell>{lang.name}</Table.Cell>
      <Table.Cell textAlign="right">{lang.key}</Table.Cell>
      <Table.Cell textAlign="center">
        <Button.Checkbox
          checked={lang.is_default}
          selected={lang.is_default}
          onClick={() => act('select_default', { language_name: lang.name })}
        />
      </Table.Cell>
      {admin_mode ? (
        <Table.Cell textAlign="Right">
          <Button
            onClick={() => act('remove_language', { language_name: lang.name })}
          >
            删除
          </Button>
        </Table.Cell>
      ) : null}
    </Table.Row>
  );
};

export const AdminMenu = (props) => {
  const { act, data } = useBackend<Data>();

  const { unknown_languages, omnitongue } = data;

  return (
    <Section
      title="Unknown Languages" display_title="未掌握的语言"
      buttons={
        <Button selected={omnitongue} onClick={() => act('toggle_omnitongue')}>
          通晓万语：{omnitongue ? '开启' : '关闭'}
        </Button>
      }
      fill
      scrollable
    >
      <Table>
        <Table.Row header>
          <Table.Cell header>名称</Table.Cell>
          <Table.Cell header collapsing>
            按键
          </Table.Cell>
          <Table.Cell header collapsing textAlign="center">
            添加
          </Table.Cell>
        </Table.Row>
        {unknown_languages.map((lang) => (
          <Table.Row key={lang.name}>
            <Table.Cell>{lang.name}</Table.Cell>
            <Table.Cell collapsing>{lang.key}</Table.Cell>
            <Table.Cell collapsing>
              <Button
                onClick={() =>
                  act('grant_language', { language_name: lang.name })
                }
              >
                添加
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

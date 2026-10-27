import { useState } from 'react';
import {
  Button,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { getArchiveDisplay, getArchiveHeading, getArchiveOptions } from './common/playerArchiveDisplay';
type ArchiveEntry = {
  filename: string;
  title: string;
  author: string;
  category?: string;
  date: string;
};

type Data = {
  archive_type: 'book' | 'painting';
  entries: ArchiveEntry[];
};

const ALL_CATEGORIES = 'All';

export const PrintingPressArchive = (props) => {
  const { act, data } = useBackend<Data>();
  const { archive_type, entries = [] } = data;
  const [titleSearch, setTitleSearch] = useState('');
  const [authorSearch, setAuthorSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState(ALL_CATEGORIES);

  const isBookArchive = archive_type !== 'painting';
  const noun = getArchiveDisplay(isBookArchive ? 'book' : 'painting');

  const categories = [
    ALL_CATEGORIES,
    ...new Set(
      entries
        .map((entry) => entry.category)
        .filter((category): category is string => !!category)
        .sort((a, b) => a.localeCompare(b)),
    ),
  ];

  const shownEntries = entries
    .filter(
      (entry) =>
        entry.title.toLowerCase().includes(titleSearch.toLowerCase()) &&
        entry.author.toLowerCase().includes(authorSearch.toLowerCase()) &&
        (categoryFilter === ALL_CATEGORIES ||
          entry.category === categoryFilter),
    )
    .sort((a, b) => a.title.localeCompare(b.title));

  return (
    <Window width={520} height={520}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title={getArchiveDisplay('Search')}>
              <LabeledList>
                <LabeledList.Item label="标题">
                  <Input
                    fluid
                    value={titleSearch}
                    placeholder={`搜索${noun}标题……`}
                    onChange={setTitleSearch}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="作者">
                  <Input
                    fluid
                    value={authorSearch}
                    placeholder="搜索作者……"
                    onChange={setAuthorSearch}
                  />
                </LabeledList.Item>
                {isBookArchive && (
                  <LabeledList.Item label="分类">
                    <Dropdown
                      width="100%"
                      selected={categoryFilter} displayText={getArchiveDisplay(categoryFilter)}
                      options={getArchiveOptions(categories)}
                      onSelected={setCategoryFilter}
                    />
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title={getArchiveHeading(noun, shownEntries.length)}
              fill
              scrollable
            >
              {shownEntries.length === 0 ? (
                <NoticeBox>未找到符合条件的{noun}。</NoticeBox>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell>标题</Table.Cell>
                    <Table.Cell>作者</Table.Cell>
                    {isBookArchive && (
                      <Table.Cell collapsing>分类</Table.Cell>
                    )}
                    <Table.Cell collapsing>创作日期</Table.Cell>
                    <Table.Cell collapsing />
                  </Table.Row>
                  {shownEntries.map((entry) => (
                    <Table.Row key={entry.filename} className="candystripe">
                      <Table.Cell>{entry.title}</Table.Cell>
                      <Table.Cell>{entry.author}</Table.Cell>
                      {isBookArchive && (
                        <Table.Cell collapsing>{getArchiveDisplay(entry.category)}</Table.Cell>
                      )}
                      <Table.Cell collapsing>{entry.date}</Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="print"
                          onClick={() =>
                            act('print', { filename: entry.filename })
                          }
                        >
                          印刷
                        </Button>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

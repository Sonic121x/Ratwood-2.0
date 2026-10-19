import { Dispatch, SetStateAction, useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Stack,
} from 'tgui-core/components';
import { Section } from '../components/Localized';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type TechNode = {
  name: string;
  desc: string;
  cost: number;
  path: string;
  required_tier: number;
  can_afford: boolean;
};

type Data = {
  choices: TechNode[];
  points: number;
  tier: number;
};

// Reusable search bar component
export const SearchBar = (props: {
  search: string;
  setSearch: Dispatch<SetStateAction<string>>;
}) => {
  const { search, setSearch } = props;
  return <Input value={search} onChange={setSearch} fluid />;
};


export const ChimericTechWeb = (props) => {
  const [search, setSearch] = useState('');
  const { act, data } = useBackend<Data>();

  const { choices = [], points, tier } = data;

  // We only filter by search text here. Eligibility is handled by DM/SS.
  const filteredChoices = (Array.isArray(choices) ? choices : [])
  /*
    .filter((node) => {
      if (search) {
        return node.name.toLowerCase().includes(search.toLowerCase());
      }
      return true;
    })*/
    .sort(
      // Sort by affordability, then tier, then name
      (a, b) => 
        (b.can_afford as any) - (a.can_afford as any) ||
        a.required_tier - b.required_tier ||
        a.name.localeCompare(b.name),
    );

  return (
    <Window width={600} height={500} title="Chimeric Tech Web" display_title="嵌合科技树">
      <Window.Content>
        <Section title="Current Status" display_title="当前状态">
          <Stack>
            <Stack.Item grow>
                <Box bold color="label">科技点：</Box> {points}
            </Stack.Item>
            <Stack.Item grow>
                <Box bold color="label">语言等级：</Box> {tier}
            </Stack.Item>
          </Stack>
        </Section>

        <Section
          title="Available Research" display_title="可进行的研究"
          fill
          scrollable
          buttons={<SearchBar search={search} setSearch={setSearch} />}
        >
          {filteredChoices.length === 0 && (
            <NoticeBox>
                目前没有新的研究可供选择。 
                你可能需要更多科技点、更高的语言等级，或尚未完成其余研究节点所需的前置研究。
            </NoticeBox>
          )}

          {filteredChoices.map((node) => (
            <Box key={node.path} mb={1}>
              <Stack align="center" justify="space-between">
                <Stack.Item grow>
                  <Box bold>{node.name}</Box>
                  <Box color="label">等级 {node.required_tier} | 消耗 {node.cost}</Box>
                  <Box className="text-desc">{node.desc}</Box>
                </Stack.Item>

                <Stack.Item>
                  <Button
                    icon="gear"
                    color={node.can_afford ? 'good' : 'bad'}
                    disabled={!node.can_afford}
                    onClick={() => act('unlock_node', { path: node.path })}
                  >
                    {node.can_afford ? '解锁' : '科技点不足'}
                  </Button>
                </Stack.Item>
              </Stack>
            </Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};

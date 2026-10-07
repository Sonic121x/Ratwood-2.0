import {
  Button,
  LabeledList,
  TimeDisplay,
  Box,
  Stack,
} from 'tgui-core/components';
import { Section } from '../components/Localized';

import { useBackend } from '../backend';
import { Window } from '../layouts';

enum PrefToColorEnum {
  null = 'red',
  'low' = 'orange',
  'medium' = 'green',
  'high' = 'red',
}

enum PrefToTextEnum {
  null = '从不',
  'low' = '+',
  'medium' = '++',
  'high' = '+++',
}

interface Clan {
  clanName: string;
  description: string;
  type: string;
  priority: number;
  icon: string;
}

interface Data {
  clans: Clan[];
  timeLeft: number;
}

export const VampireVote = (props: any, context: any) => {
  const { data, act } = useBackend<Data>();

  return (
    <Window width={690} height={590} display_title="血族氏族投票">
      <Window.Content>
        <Section
          fill
          scrollable
          title={'Clan vote'} display_title="氏族投票"
          buttons={<TimeDisplay value={data.timeLeft} />}
        >
          <LabeledList>
            {data.clans.map((clan, index) => (
              <LabeledList.Item
                textAlign="Left"
                key={index}
                label={
                  <Stack fill vertical justify="space-around">
                    <Stack.Item grow>
                      <b>{clan.clanName} </b>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Box className={clan.icon} mr={2} inline />
                    </Stack.Item>
                  </Stack>
                }
                buttons={
                  <Button
                    fluid
                    minWidth="6em"
                    maxWidth="6em"
                    textAlign="Center"
                    color={PrefToColorEnum[clan.priority]}
                    onClick={() => {
                      act('select_priority', { selected_clan: clan.type });
                    }}
                  >
                    {PrefToTextEnum[clan.priority]}
                  </Button>
                }
              >
                {clan.description}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

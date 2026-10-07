import { Dispatch, SetStateAction, useState } from 'react';
import {
  Box,
  Button,
  Input,
  Stack,
} from 'tgui-core/components';
import { Section } from '../components/Localized';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Carving = {
  name: string;
  ref: string;
  icon: string;
};

type Data = {
  carvings: Carving[];
};

export const Carving = (props) => {
  const { data } = useBackend<Data>();

  if (!data.carvings) {
    return (
      <Window width={320} height={400} display_title="雕刻">
        <Window.Content>
          <Carveless />
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={320} height={400} display_title="雕刻">
      <Window.Content>
        <CarvingDisplay />
      </Window.Content>
    </Window>
  );
};

export const Carveless = (props) => {
  return (
    <Stack align="center" justify="center" fill>
      <Stack.Item>
        <Stack vertical align="center" justify="center">
          <Stack.Item fontSize={2}>真遗憾，没有可雕刻的东西。</Stack.Item>
          <Stack.Item fontSize={1}>你本不该看到这个界面！</Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const SearchBar = (props: {
  search: string;
  setSearch: Dispatch<SetStateAction<string>>;
}) => {
  const { search, setSearch } = props;
  return <Input value={search} onChange={setSearch} fluid />;
};

export const CarvingDisplay = (props) => {
  const [search, setSearch] = useState('');

  const { act, data } = useBackend<Data>();

  const { carvings } = data;

  const availableCarvings = carvings
    .filter((carving) => {
      if (search) {
        return carving.name.toLowerCase().includes(search.toLowerCase());
      } else {
        return true;
      }
    })
    .sort(
      (a, b) =>
        a.name.localeCompare(b.name),
    );

  return (
    <Section
      title="Carvings" display_title="雕刻制品"
      fill
      scrollable
      buttons={<SearchBar search={search} setSearch={setSearch} />}
    >
      {availableCarvings.map((carving) => (
        <Button
          key={carving.ref}
          fluid
          onClick={() => act('choose_carving', { ref: carving.ref })}
        >
          <Stack align="center">
            <Stack.Item>
              <Box className={carving.icon} mr={2} inline />
            </Stack.Item>
            <Stack.Item>
              {carving.name}
            </Stack.Item>
          </Stack>
        </Button>
      ))}
    </Section>
  );
};

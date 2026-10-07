import { useState } from 'react';
import { Box, Button, Section, Stack, TextArea } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const MAX_LAW_LENGTH = 500;

type LawRecord = {
  index: number;
  text: string;
};

type Data = {
  max_laws: number;
  current_laws: LawRecord[];
};

export const LawsMenu = () => {
  return (
    <Window width={560} height={640} display_title="制定法律">
      <Window.Content>
        <LawsDisplay />
      </Window.Content>
    </Window>
  );
};

const LawEntry = (props: {
  index: number;
  value: string;
  onChange: (value: string) => void;
  onRemove: () => void;
  canRemove: boolean;
}) => {
  const { index, value, onChange, onRemove, canRemove } = props;

  return (
    <Box mb={3}>
      <Stack align="start">
        <Stack.Item>
          <Box bold fontSize={1.05} color="label" width={2.2} textAlign="right">
            {index + 1}.
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <TextArea
            fluid
            maxLength={MAX_LAW_LENGTH}
            height="75px"
            placeholder={`第 ${index + 1} 条法律……`}
            value={value}
            onChange={(val: string) => onChange(val)}
            dontUseTabForIndent
          />
          <Box color="label" fontSize={0.75} textAlign="right">
            {value.length}/{MAX_LAW_LENGTH}
          </Box>
        </Stack.Item>
        <Stack.Item>
          {canRemove ? (
            <Button
              icon="times"
              color="bad"
              tooltip="删除此条法律"
              onClick={onRemove}
            />
          ) : (
            <Box width={2} />
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};

/** Purge All button with inline confirmation */
const PurgeButton = (props: { onPurge: () => void; lawCount: number }) => {
  const [confirming, setConfirming] = useState(false);

  if (props.lawCount <= 1) {
    return null;
  }

  if (confirming) {
    return (
      <Box inline>
        <Box inline color="bad" bold mr={1}>
          清空所有条文？
        </Box>
        <Button
          icon="trash"
          color="bad"
          onClick={() => {
            props.onPurge();
            setConfirming(false);
          }}
        >
          是
        </Button>
        <Button ml={0.5} onClick={() => setConfirming(false)}>
          取消
        </Button>
      </Box>
    );
  }

  return (
    <Button icon="trash" color="bad" onClick={() => setConfirming(true)}>
      全部清空
    </Button>
  );
};

const LawsDisplay = () => {
  const { act, data } = useBackend<Data>();
  const { current_laws, max_laws } = data;

  // Initialize local state from server data.
  const [laws, setLaws] = useState<string[]>(() => {
    if (current_laws && current_laws.length > 0) {
      return current_laws.map((law) => law.text);
    }
    return [''];
  });

  // Track whether local state has diverged from server state
  const serverTexts = current_laws ? current_laws.map((l) => l.text) : [];
  const nonEmptyLaws = laws.filter((law) => law.trim().length > 0);
  const hasChanges =
    nonEmptyLaws.length !== serverTexts.length ||
    nonEmptyLaws.some((law, i) => law.trim() !== (serverTexts[i] || ''));

  const addLaw = () => {
    if (laws.length < max_laws) {
      setLaws([...laws, '']);
    }
  };

  const removeLaw = (index: number) => {
    const updated = laws.filter((_, i) => i !== index);
    // Always keep at least one field
    setLaws(updated.length > 0 ? updated : ['']);
  };

  const updateLaw = (index: number, value: string) => {
    setLaws(laws.map((law, i) => (i === index ? value : law)));
  };

  const clearAll = () => {
    setLaws(['']);
  };

  const submitLaws = () => {
    const payload = nonEmptyLaws.map((text, i) => ({
      index: i + 1,
      text: text.trim(),
    }));
    act('set_laws', { laws: payload });
  };

  return (
    <Stack fill vertical>
      {/* Header */}
      <Stack.Item>
        <Box px={1} pt={0.5} pb={0.3}>
          <Box bold fontSize={1.15}>
            制定法律
          </Box>
          <Box color="label" fontSize={0.85} mt={0.3}>
            起草臣民应当遵守的法律。修改须经
            颁布后生效，最多可制定 <b>{max_laws}</b> 条法律。
          </Box>
        </Box>
      </Stack.Item>

      {/* Scrollable law fields */}
      <Stack.Item grow>
        <Section fill scrollable>
          {laws.map((law, index) => (
            <LawEntry
              key={index}
              index={index}
              value={law}
              onChange={(val) => updateLaw(index, val)}
              onRemove={() => removeLaw(index)}
              canRemove={laws.length > 1}
            />
          ))}

          {/* Add new law button */}
          {laws.length < max_laws ? (
            <Box textAlign="center" mt={0.5} mb={1}>
              <Button icon="plus" onClick={addLaw}>
                添加法律（{laws.length}/{max_laws}）
              </Button>
            </Box>
          ) : (
            <Box
              textAlign="center"
              color="label"
              fontSize={0.85}
              mt={0.5}
              mb={1}
            >
              已达到 {max_laws} 条法律的上限。
            </Box>
          )}
        </Section>
      </Stack.Item>

      {/* Footer: clear + count + enact */}
      <Stack.Item>
        <Box px={1} py={0.4}>
          <Stack align="center">
            <Stack.Item>
              <PurgeButton lawCount={laws.length} onPurge={clearAll} />
            </Stack.Item>
            <Stack.Item grow>
              <Box inline color="label" fontSize={0.85}>
                已起草 {nonEmptyLaws.length} 条
                法律
                {hasChanges && (
                  <Box inline color="average" ml={1}>
                    （有未保存的修改）
                  </Box>
                )}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="scroll"
                color="good"
                fontSize={1.1}
                disabled={!hasChanges && nonEmptyLaws.length > 0}
                tooltip={
                  !hasChanges && nonEmptyLaws.length > 0
                    ? '没有待颁布的修改'
                    : nonEmptyLaws.length === 0
                      ? '这将废除全部现行法律！'
                      : undefined
                }
                onClick={submitLaws}
              >
                颁布法律
              </Button>
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
    </Stack>
  );
};

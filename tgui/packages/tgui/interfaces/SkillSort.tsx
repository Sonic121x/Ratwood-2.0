import { useEffect, useState } from 'react';
import { Box, Button, NumberInput, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Skill = {
  id: string;
  name: string;
  position: number;
};

type Data = {
  skills: Skill[];
  total: number;
};

const SkillRow = ({ skill, total }: { skill: Skill; total: number }) => {
  const { act } = useBackend<Data>();
  const [target, setTarget] = useState(skill.position);

  useEffect(() => {
    setTarget(skill.position);
  }, [skill.position, total]);

  return (
    <Section>
      <Stack align="center">
        <Stack.Item width="3rem">
          <Box bold textAlign="center">
            {skill.position}
          </Box>
        </Stack.Item>
        <Stack.Item grow minWidth={0}>
          <Box bold style={{ overflowWrap: 'anywhere' }}>
            {skill.name}
          </Box>
          <Box color={skill.position <= 9 ? 'good' : 'label'}>
            {skill.position <= 9
              ? `默认快捷键：Alt+${skill.position}`
              : '无默认数字快捷键'}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="arrow-up"
            disabled={skill.position <= 1}
            onClick={() => act('up', { id: skill.id })}
          >
            上移
          </Button>
          <Button
            icon="arrow-down"
            disabled={skill.position >= total}
            onClick={() => act('down', { id: skill.id })}
          >
            下移
          </Button>
        </Stack.Item>
        <Stack.Item>
          <NumberInput
            value={target}
            minValue={1}
            maxValue={total}
            step={1}
            width="4rem"
            onChange={(value: number) => {
              if (Number.isFinite(value)) {
                setTarget(Math.max(1, Math.min(total, Math.round(value))));
              }
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            tooltip="移至指定序号，其余能力依次顺移"
            disabled={target === skill.position}
            onClick={() => act('move', { id: skill.id, position: target })}
          >
            移至
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const SkillSort = () => {
  const { data } = useBackend<Data>();

  return (
    <Window title="技能排序" width={720} height={550}>
      <Window.Content scrollable>
        <Section title={`已有能力（${data.total}）`}>
          <Box>调整后立即同步能力栏；前九项对应默认快捷键 Alt+1～9。</Box>
          <Box color="label" mt={1}>
            自定义按键沿用原设置。排序仅对当前身体、本局有效。
          </Box>
        </Section>
        {data.skills.length === 0 ? (
          <Section>
            <Box color="label">你目前没有可以排序的能力。</Box>
          </Section>
        ) : (
          data.skills.map((skill) => (
            <SkillRow key={skill.id} skill={skill} total={data.total} />
          ))
        )}
      </Window.Content>
    </Window>
  );
};

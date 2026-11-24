import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

// 自定义修改：为金手指提供属性、特性与技能编辑界面。
type Trait = { id: string; symbol: string };
type Skill = {
  id: string;
  name: string;
  category: string;
  base: number;
  effective: number;
};
type Data = {
  stats: { id: string; name: string; value: number }[];
  catalog: Trait[];
  owned: string[];
  skills: Skill[];
};

export function GoldenFinger() {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState('属性');
  const [ownedOnly, setOwnedOnly] = useState(true);
  const [traitQuery, setTraitQuery] = useState('');
  const [skillQuery, setSkillQuery] = useState('');
  const [category, setCategory] = useState('全部分类');
  const { stats, skills, owned, catalog } = data;
  const ownedIds = new Set(owned);
  const symbols = new Map(catalog.map(({ id, symbol }) => [id, symbol]));
  const traitIds = ownedOnly ? owned : catalog.map((trait) => trait.id);
  const traits = traitIds.filter(
    (id) =>
      (ownedOnly || !ownedIds.has(id)) &&
      `${id} ${symbols.get(id) || ''}`
        .toLowerCase()
        .includes(traitQuery.trim().toLowerCase()),
  );
  const categories = [...new Set(skills.map((skill) => skill.category))];
  const visibleSkills = skills.filter(
    (skill) =>
      (category === '全部分类' || skill.category === category) &&
      `${skill.name} ${skill.id}`
        .toLowerCase()
        .includes(skillQuery.trim().toLowerCase()),
  );

  return (
    <Window title="金手指" width={620} height={610}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Tabs>
              {['属性', '特性', '技能'].map((label) => (
                <Tabs.Tab
                  key={label}
                  selected={tab === label}
                  onClick={() => setTab(label)}
                >
                  {label}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          {tab === '特性' && (
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <Input
                    fluid
                    placeholder="搜索特性名称或标识"
                    value={traitQuery}
                    onChange={setTraitQuery}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={ownedOnly}
                    onClick={() => setOwnedOnly(true)}
                  >
                    已拥有
                  </Button>
                  <Button
                    selected={!ownedOnly}
                    onClick={() => setOwnedOnly(false)}
                  >
                    可添加
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          )}
          {tab === '技能' && (
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <Input
                    fluid
                    placeholder="搜索技能"
                    value={skillQuery}
                    onChange={setSkillQuery}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    options={['全部分类', ...categories]}
                    selected={category}
                    onSelected={setCategory}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section fill scrollable>
              {tab === '属性' && (
                <LabeledList>
                  {stats.map(({ id, name, value }) => (
                    <LabeledList.Item key={id} label={name}>
                      <Button
                        icon="minus"
                        tooltip="减少 1 点"
                        disabled={value <= 1}
                        onClick={() => act('step_stat', { id, value: -1 })}
                      />
                      <NumberInput
                        value={value}
                        minValue={1}
                        maxValue={20}
                        step={1}
                        width="5em"
                        onChange={(next) =>
                          act('set_stat', { id, value: next })
                        }
                      />
                      <Button
                        icon="plus"
                        tooltip="增加 1 点"
                        disabled={value >= 20}
                        onClick={() => act('step_stat', { id, value: 1 })}
                      />
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              )}
              {tab === '特性' && (
                <>
                  {ownedOnly && (
                    <Box color="label" mb={1}>
                      移除会清除该特性的全部当前来源，包括职业、种族和装备。
                    </Box>
                  )}
                  {!traits.length && (
                    <Box color="label">没有符合条件的特性。</Box>
                  )}
                  {traits.map((id) => (
                    <Stack key={id} align="center" mb={0.5}>
                      <Stack.Item grow>
                        {id}
                        {symbols.has(id) && symbols.get(id) !== id && (
                          <Box color="label" fontSize="0.85em">
                            {symbols.get(id)}
                          </Box>
                        )}
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          color={ownedOnly ? 'bad' : 'good'}
                          onClick={() =>
                            act(ownedOnly ? 'remove_trait' : 'add_trait', {
                              id,
                            })
                          }
                        >
                          {ownedOnly ? '移除' : '添加'}
                        </Button>
                      </Stack.Item>
                    </Stack>
                  ))}
                </>
              )}
              {tab === '技能' && (
                <>
                  {!visibleSkills.length && (
                    <Box color="label">没有符合条件的技能。</Box>
                  )}
                  {visibleSkills.map((skill) => (
                    <Stack key={skill.id} align="center" mb={0.5}>
                      <Stack.Item grow>
                        {skill.name}
                        <Box color="label" fontSize="0.85em">
                          {skill.category} · 基础 {skill.base} 级
                          {skill.effective !== skill.base &&
                            ` · 生效 ${skill.effective} 级`}
                        </Box>
                      </Stack.Item>
                      <Stack.Item>
                        {[0, 1, 2, 3, 4, 5, 6].map((level) => (
                          <Button
                            key={level}
                            selected={skill.base === level}
                            onClick={() =>
                              act('set_skill', { id: skill.id, value: level })
                            }
                          >
                            {level}
                          </Button>
                        ))}
                      </Stack.Item>
                    </Stack>
                  ))}
                </>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}

import { useMemo, useState } from 'react';
import { Box, Button, Icon, Input, Section, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Spell = {
  name: string;
  desc: string;
  cost: number;
  tier: number;
  path: string;
  school?: string;
  range?: number;
  charge_time?: number;
  cooldown?: number;
  fatigue?: number;
  img64?: string;
  is_known: boolean;
  can_afford: boolean;
  tier_locked: boolean;
  evil_locked: boolean;
};

type Data = {
  user_points?: number;
  spells: Spell[];
};

export const SpellLibrary = () => {
  const { act, data } = useBackend<Data>();

  const [searchText, setSearchText] = useState('');
  const [activeTier, setActiveTier] = useState<number | 'all'>('all');
  const [selectedSchool, setSelectedSchool] = useState<string>('All');
  const [hideKnown, setHideKnown] = useState<boolean>(false);
  const [sortByCost, setSortByCost] = useState<'asc' | 'desc' | null>(null);

  const { user_points = 0, spells = [] } = data || {};

  const tiers = useMemo(() => {
    const set = new Set<number>();
    spells.forEach((s) => set.add(s.tier));
    return Array.from(set).sort((a, b) => a - b);
  }, [spells]);

  const schools = useMemo(() => {
    const names: Record<string, string> = { All: '全部', abjuration: '防护术', conjuration: '咒法术', divination: '预言术', enchantment: '惑控术', evocation: '塑能术', illusion: '幻术', necromancy: '死灵术', restoration: '恢复术', transmutation: '变化术', generic: '通用' };
    const set = new Set<string>(['All']);
    spells.forEach((s) => {
      if (s.school) set.add(s.school);
    });
    return Array.from(set, (school) => ({ id: school, label: names[school] || school }));
  }, [spells]);

  const processedSpells = useMemo(() => {
    const query = searchText.trim().toLowerCase();

    let list = spells.filter((s) => {
      if (activeTier !== 'all' && s.tier !== activeTier) return false;
      if (selectedSchool !== 'All' && s.school !== selectedSchool) return false;
      if (hideKnown && s.is_known) return false;

      if (query) {
        const nameMatch = (s.name || '').toLowerCase().includes(query);
        const descMatch = (s.desc || '').toLowerCase().includes(query);
        if (!nameMatch && !descMatch) {
          return false;
        }
      }

      return true;
    });

    if (sortByCost) {
      list.sort((a, b) => (sortByCost === 'asc' ? a.cost - b.cost : b.cost - a.cost));
    } else {
      list.sort((a, b) => a.tier - b.tier || a.cost - b.cost);
    }

    return list;
  }, [spells, activeTier, selectedSchool, hideKnown, searchText, sortByCost]);
  return (
    <Window
      title="Grimoire of Arcane Arts"
      display_title="奥术秘典"
      width={900}
      height={720}
      theme="dark"
    >
      <Window.Content style={{ padding: '8px' }}>
        <style>
          {`
            .TitleBar, .TitleBar__title, .TitleBar__titleText {
              padding-left: 16px !important;
            }
          `}
        </style>

        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center" justify="space-between">
                <Stack.Item>
                  <Stack align="center">
                    <Icon name="hat-wizard" size={2} color="#00e1ff" mr={1.5} />
                    <Box>
                      <Box fontSize="0.75em" color="label">
                        可用法术点
                      </Box>
                      <Box bold fontSize="1.35em" color={user_points > 0 ? '#4caf50' : '#e74c3c'}>
                        {user_points} <span style={{ fontSize: '0.65em' }}>点</span>
                      </Box>
                    </Box>
                  </Stack>
                </Stack.Item>

                <Stack.Item grow ml={3} mr={2}>
                  <Input
                    fluid
                    placeholder="搜索咒语或效果..."
                    value={searchText}
                    onChange={(value) => setSearchText(value)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Stack align="center">
                    <Button
                      icon={sortByCost === 'asc' ? 'sort-numeric-down' : 'sort-numeric-up'}
                      selected={!!sortByCost}
                      onClick={() =>
                        setSortByCost((prev) => (prev === 'asc' ? 'desc' : prev === 'desc' ? null : 'asc'))
                      }
                    >
                      消耗 {sortByCost ? (sortByCost === 'asc' ? '▲' : '▼') : ''}
                    </Button>
                    <Button
                      icon={hideKnown ? 'eye-slash' : 'eye'}
                      selected={hideKnown}
                      onClick={() => setHideKnown(!hideKnown)}
                    >
                      隐藏已学
                    </Button>
                  </Stack>
                </Stack.Item>
              </Stack>

              <Box mt={1}>
                <Tabs>
                  <Tabs.Tab selected={activeTier === 'all'} onClick={() => setActiveTier('all')}>
                    全部阶位
                  </Tabs.Tab>
                  {tiers.map((t) => (
                    <Tabs.Tab key={t} selected={activeTier === t} onClick={() => setActiveTier(t)}>
                      阶位 {t}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Box>

              {schools.length > 2 && (
                <Box mt={1} style={{ display: 'flex', gap: '4px', flexWrap: 'wrap' }}>
                  {schools.map((school) => (
                    <Button
                      key={school.id}
                      selected={selectedSchool === school.id}
                      onClick={() => setSelectedSchool(school.id)}
                      style={{ fontSize: '0.8em', textTransform: 'capitalize' }}
                    >
                      {school.label}
                    </Button>
                  ))}
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow style={{ overflowY: 'auto' }}>
            <div
              style={{
                display: 'flex',
                flexWrap: 'wrap',
                alignContent: 'flex-start',
                width: '100%',
              }}
            >
              {processedSpells.map((spell) => {
                const isLocked = !spell.is_known && (!spell.can_afford || spell.tier_locked || spell.evil_locked);

                const borderColor = spell.is_known ? '#4caf50' : isLocked ? '#422' : '#2e7d32';
                const bgColor = spell.is_known
                  ? 'rgba(27, 38, 27, 0.96)'
                  : isLocked
                  ? 'rgba(28, 20, 20, 0.95)'
                  : 'rgba(20, 32, 22, 0.95)';

                return (
                  <div
                    key={spell.path}
                    style={{
                      width: '32%',
                      margin: '0.6%',
                      boxSizing: 'border-box',
                      display: 'flex',
                    }}
                  >
                    <div
                      className="candystripe"
                      style={{
                        border: `1px solid ${borderColor}`,
                        padding: '10px',
                        display: 'flex',
                        flexDirection: 'column',
                        width: '100%',
                        opacity: isLocked ? 0.7 : 1,
                        backgroundColor: bgColor,
                        borderRadius: '4px',
                        boxShadow: '0 4px 6px rgba(0,0,0,0.3)',
                      }}
                    >
                      <div
                        style={{
                          display: 'flex',
                          justifyContent: 'space-between',
                          alignItems: 'center',
                          marginBottom: '6px',
                        }}
                      >
                        <span
                          style={{
                            fontWeight: 'bold',
                            color: spell.is_known ? '#81c784' : '#fff',
                            fontSize: '12px',
                            whiteSpace: 'nowrap',
                            overflow: 'hidden',
                            textOverflow: 'ellipsis',
                            maxWidth: '180px',
                          }}
                        >
                          {spell.name}
                        </span>
                        <span
                          style={{
                            background: '#1b2028',
                            border: '1px solid #3d4a5d',
                            color: '#00e1ff',
                            padding: '1px 5px',
                            fontSize: '10px',
                            borderRadius: '3px',
                            fontWeight: 'bold',
                          }}
                        >
                          {spell.tier}阶
                        </span>
                      </div>

                      <div style={{ display: 'flex', marginBottom: '8px', gap: '8px' }}>
                        <div
                          style={{
                            width: '46px',
                            height: '46px',
                            border: '1px solid #444',
                            background: '#000',
                            flexShrink: 0,
                            padding: '2px',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                          }}
                        >
                          {spell.img64 && spell.img64 !== 'blank' ? (
                            <img
                              src={`data:image/png;base64,${spell.img64}`}
                              style={{
                                width: '32px',
                                height: '32px',
                                imageRendering: 'pixelated',
                              }}
                            />
                          ) : (
                            <Icon name="hat-wizard" color="#555" />
                          )}
                        </div>
                        <div
                          style={{
                            fontSize: '10.5px',
                            color: '#aab',
                            height: '46px',
                            overflowY: 'auto',
                            lineHeight: '1.25',
                            flexGrow: 1,
                          }}
                        >
                          {spell.desc || '典籍中没有相关说明。'}
                        </div>
                      </div>

                      <div
                        style={{
                          fontSize: '10px',
                          color: '#778',
                          display: 'flex',
                          gap: '6px',
                          flexWrap: 'wrap',
                          borderTop: '1px solid rgba(255, 255, 255, 0.08)',
                          paddingTop: '4px',
                          marginBottom: '8px',
                        }}
                      >
                        {spell.charge_time ? <span>蓄力: {spell.charge_time}秒</span> : null}
                        {spell.cooldown ? <span>冷却: {spell.cooldown}秒</span> : null}
                        {spell.fatigue ? <span>耐力: {spell.fatigue}</span> : null}
                        {spell.school && <span style={{ color: '#6882a8' }}>[{schools.find((school) => school.id === spell.school)?.label || spell.school}]</span>}
                      </div>

                      <div style={{ marginTop: 'auto' }}>
                        {spell.is_known ? (
                          <div
                            style={{
                              width: '100%',
                              textAlign: 'center',
                              border: '1px solid #444',
                              backgroundColor: '#2c3038',
                              color: '#888',
                              padding: '5px 0',
                              fontSize: '10.5px',
                              fontWeight: 'bold',
                              borderRadius: '3px',
                              cursor: 'default',
                              userSelect: 'none',
                            }}
                          >
                            ✓ 已学会
                          </div>
                        ) : spell.tier_locked ? (
                          <div
                            style={{
                              width: '100%',
                              textAlign: 'center',
                              backgroundColor: '#5a1d1d',
                              border: '1px solid #e74c3c',
                              color: '#ffaaaa',
                              fontWeight: 'bold',
                              fontSize: '10.5px',
                              padding: '5px 0',
                              borderRadius: '3px',
                              cursor: 'not-allowed',
                              userSelect: 'none',
                            }}
                          >
                            未解锁 (阶位 {spell.tier})
                          </div>
                        ) : spell.evil_locked ? (
                          <div
                            style={{
                              width: '100%',
                              textAlign: 'center',
                              backgroundColor: '#5a1d1d',
                              border: '1px solid #e74c3c',
                              color: '#ffaaaa',
                              fontWeight: 'bold',
                              fontSize: '10.5px',
                              padding: '5px 0',
                              borderRadius: '3px',
                              cursor: 'not-allowed',
                              userSelect: 'none',
                            }}
                          >
                            需要异端知识
                          </div>
                        ) : spell.can_afford ? (
                          <div
                            className="btn"
                            onClick={() => act('learn', { path: spell.path })}
                            style={{
                              width: '100%',
                              textAlign: 'center',
                              backgroundColor: '#2e7d32',
                              color: '#fff',
                              fontWeight: 'bold',
                              fontSize: '10.5px',
                              border: '1px solid #4caf50',
                              padding: '5px 0',
                              cursor: 'pointer',
                              borderRadius: '3px',
                              userSelect: 'none',
                              transition: 'all 0.1s ease-in-out',
                            }}
                          >
                            学习 ({spell.cost} 点)
                          </div>
                        ) : (
                          <div
                            style={{
                              width: '100%',
                              textAlign: 'center',
                              backgroundColor: '#5a1d1d',
                              border: '1px solid #721c24',
                              color: '#e7a0a0',
                              fontWeight: 'bold',
                              fontSize: '10.5px',
                              padding: '5px 0',
                              cursor: 'not-allowed',
                              borderRadius: '3px',
                              userSelect: 'none',
                            }}
                          >
                            点数不足 (需要 {spell.cost} 点)
                          </div>
                        )}
                      </div>

                    </div>
                  </div>
                );
              })}
            </div>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

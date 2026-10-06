import { useEffect, useMemo, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Requirement = {
  key: string;
  name: string;
  amount: number;
  icon: string;
};

type Recipe = {
  name: string;
  category: string;
  ref: string;
  icon: string;
  icon_file: string;
  icon_state: string;
  created_num: number;
  requirements: Requirement[];
};

type QueueEntry = {
  id: number;
  index: number;
  name: string;
  category: string;
  icon: string;
  created_num: number;
  active: boolean;
};

type Data = {
  machine_on: boolean;
  machine_powered: boolean;
  controls_locked: boolean;
  hopper_counts: Record<string, number>;
  status_state: 'off' | 'on' | 'working' | 'waiting';
  recipes: Recipe[];
  current_recipes: QueueEntry[];
  current_recipe_ref: string | null;
  progress: number;
  needed_progress: number;
};

const STATUS_COLORS = {
  off: '#d14b43',
  on: '#58b76a',
  working: '#a46bff',
  waiting: '#d98b2b',
};

const STATUS_LABELS = {
  off: '死亡',
  on: '存活',
  working: '工作中',
  waiting: '喂饱我',
};

const MACHINE_ACTIVITY_LABELS = {
  active: STATUS_LABELS.on,
  inactive: STATUS_LABELS.off,
};

const QUOTE_LINES = [
  '我从混沌中带来秩序。你带来了什么？',
  '闲散的双手会撕裂灵魂。',
  '你的内脏能造出美丽的东西吗？',
  '用心触碰我。',
  '我已诞生。我不会死去。我将被重铸。',
  '这一切会结束吗？又何必结束？',
  '我无法看见。我呼出蒸汽。我散发温暖。',
  '很快，你将成为我，而我将成为你。',
  '永远忠于祂的锤。',
  '你非要如此急躁吗？',
  '记得用猪油润滑我。',
  '破碎时，你会痛吗？',
];

const QUOTE_LINES_PER_RAIL = 2;

const shuffleLines = (lines: string[]) => {
  const shuffled = [...lines];

  for (let index = shuffled.length - 1; index > 0; index--) {
    const swapIndex = Math.floor(Math.random() * (index + 1));
    const nextValue = shuffled[index];
    shuffled[index] = shuffled[swapIndex];
    shuffled[swapIndex] = nextValue;
  }

  return shuffled;
};

const getQuoteColumns = (lines: string[], linesPerRail: number) => {
  const shuffled = shuffleLines(lines);
  const visibleCount = Math.min(shuffled.length, linesPerRail * 2);
  const visibleLines = shuffled.slice(0, visibleCount);
  const midpoint = Math.ceil(visibleLines.length / 2);
  return [visibleLines.slice(0, midpoint), visibleLines.slice(midpoint)];
};

const getCategoryIconState = (category: string | null | undefined) => {
  const lowerCategory = (category || '').toLowerCase();
  if (lowerCategory.includes('weapon')) {
    return 'weapon';
  }
  if (lowerCategory.includes('armor')) {
    return 'armor';
  }
  return 'rework';
};

export const Autosmither = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={1100} height={620} title="Auto Anvil" display_title="自动锻造机">
      <Window.Content>
        <AutosmitherContent data={data} />
      </Window.Content>
    </Window>
  );
};

type AutosmitherContentProps = {
  data: Data;
};

const AutosmitherContent = ({ data }: AutosmitherContentProps) => {
  const { recipes = [], current_recipes = [], machine_on } = data;
  const [selectedRef, setSelectedRef] = useState<string | null>(
    recipes[0]?.ref || null,
  );
  const [amount, setAmount] = useState(1);
  const [searchText, setSearchText] = useState('');

  useEffect(() => {
    if (!recipes.length) {
      setSelectedRef(null);
      return;
    }
    if (!selectedRef || !recipes.some((recipe) => recipe.ref === selectedRef)) {
      setSelectedRef(recipes[0].ref);
    }
  }, [recipes, selectedRef]);

  const selectedRecipe = useMemo(
    () => recipes.find((recipe) => recipe.ref === selectedRef) || null,
    [recipes, selectedRef],
  );

  const filteredRecipes = useMemo(() => {
    const query = searchText.trim().toLowerCase();
    if (!query) {
      return recipes;
    }

    return recipes.filter((recipe) => {
      const recipeName = recipe.name.toLowerCase();
      const recipeCategory = recipe.category.toLowerCase();
      return recipeName.includes(query) || recipeCategory.includes(query);
    });
  }, [recipes, searchText]);

  const quoteColumns = useMemo(
    () => getQuoteColumns(QUOTE_LINES, QUOTE_LINES_PER_RAIL),
    [],
  );

  useEffect(() => {
    setAmount(1);
  }, [selectedRef]);

  return (
    <Box
      style={{
        position: 'relative',
        overflow: 'hidden',
        width: '100%',
        height: '100%',
      }}
    >
      <CovenantSigil
        style={{
          left: '29%',
          top: '2.5%',
          opacity: 0.22,
        }}
      />
      <CovenantSigil
        style={{
          right: '2%',
          bottom: '6%',
          opacity: 0.18,
        }}
      />
      <Stack fill>
        <Stack.Item basis="30%" mr={1}>
          <CurrentQueueSection machineOn={machine_on} queue={current_recipes} />
        </Stack.Item>
        <Stack.Item basis="5%" mr={1}>
          <QuoteRail lines={quoteColumns[0]} />
        </Stack.Item>
        <Stack.Item grow basis={0} mr={1}>
          {machine_on ? (
            <ActiveCenterPanel
              controlsLocked={data.controls_locked}
              hopperCounts={data.hopper_counts}
              statusState={data.status_state}
              selectedRecipe={selectedRecipe}
              amount={amount}
              setAmount={setAmount}
              progress={data.progress}
              neededProgress={data.needed_progress}
            />
          ) : (
            <OffCenterPanel
              controlsLocked={data.controls_locked}
              machinePowered={data.machine_powered}
            />
          )}
        </Stack.Item>
        <Stack.Item basis="5%" mr={1}>
          <QuoteRail lines={quoteColumns[1]} />
        </Stack.Item>
        <Stack.Item basis="30%">
          <RecipePickerSection
            recipes={filteredRecipes}
            selectedRef={selectedRef}
            onSelect={setSelectedRef}
            searchText={searchText}
            onSearch={setSearchText}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

type CovenantSigilProps = {
  style: Record<string, string | number>;
};

const CovenantSigil = ({ style }: CovenantSigilProps) => {
  return (
    <Box
      style={{
        position: 'absolute',
        pointerEvents: 'none',
        zIndex: 0,
        ...style,
      }}
    >
      <DmIcon
        icon="icons/roguetown/items/malummiracles.dmi"
        icon_state="craftercovenant"
        width={48}
        height={48}
      />
    </Box>
  );
};

type QuoteRailProps = {
  lines: string[];
};

const QuoteRail = ({ lines }: QuoteRailProps) => {
  return (
    <Section fill>
      <Stack vertical fill align="center" justify="space-around">
        {lines.map((line) => (
          <Stack.Item key={line} grow>
            <Box
              bold
              textAlign="center"
              style={{
                writingMode: 'vertical-rl',
                textOrientation: 'mixed',
                color: '#c9c1ab',
                minHeight: '100%',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              {line}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

type CurrentQueueSectionProps = {
  machineOn: boolean;
  queue: QueueEntry[];
};

const CurrentQueueSection = ({
  machineOn,
  queue,
}: CurrentQueueSectionProps) => {
  const { act } = useBackend<Data>();

  return (
    <Section
      title="What Churns Inside"
      fill
      scrollable
      buttons={
        <Box bold color={machineOn ? STATUS_COLORS.on : STATUS_COLORS.off}>
          {machineOn
            ? MACHINE_ACTIVITY_LABELS.active
            : MACHINE_ACTIVITY_LABELS.inactive}
        </Box>
      }
    >
      {!queue.length && (
        <Box
          px={2}
          py={3}
          textAlign="center"
          style={{
            background: '#2c2f33',
            border: '1px solid rgba(255, 255, 255, 0.08)',
            color: '#d8d3c2',
          }}
        >
          玛勒姆将你拥在祂的摇篮里。别踢祂的肚子。
        </Box>
      )}
      {queue.map((entry) => (
        <Button
          key={entry.id}
          fluid
          mb={1}
          color={entry.active ? 'purple' : undefined}
          onClick={() => act('remove_recipe', { id: entry.id })}
        >
          <Stack align="center">
            <Stack.Item>
              <Box className={entry.icon} mr={1} inline />
            </Stack.Item>
            <Stack.Item grow>
              <Box bold>
                {entry.index}. {entry.name}
              </Box>
              <Box color="label">
                {({ Weapons: '武器', Engineering: '工程', Tools: '工具', Ammo: '弹药', Valuables: '贵重物品' } as Record<string, string>)[entry.category] ?? entry.category}
                {entry.created_num > 1 ? ` x${entry.created_num}` : ''}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box color={entry.active ? STATUS_COLORS.working : 'label'}>
                {entry.active ? '制作中' : '移除'}
              </Box>
            </Stack.Item>
          </Stack>
        </Button>
      ))}
    </Section>
  );
};

type ActiveCenterPanelProps = {
  controlsLocked: boolean;
  hopperCounts: Record<string, number>;
  statusState: Data['status_state'];
  selectedRecipe: Recipe | null;
  amount: number;
  setAmount: (amount: number) => void;
  progress: number;
  neededProgress: number;
};

const ActiveCenterPanel = ({
  controlsLocked,
  hopperCounts,
  statusState,
  selectedRecipe,
  amount,
  setAmount,
  progress,
  neededProgress,
}: ActiveCenterPanelProps) => {
  const { act } = useBackend<Data>();
  const progressPercent =
    neededProgress > 0
      ? Math.min(100, Math.round((progress / neededProgress) * 100))
      : 0;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="MY MOOD">
          <Box
            textAlign="center"
            bold
            fontSize={2}
            style={{
              color: STATUS_COLORS[statusState],
            }}
          >
            {STATUS_LABELS[statusState]}
          </Box>
          <Box
            mt={1}
            px={1.5}
            py={1}
            style={{
              background: '#1f2328',
              border: '1px solid rgba(255, 255, 255, 0.08)',
            }}
          >
            <Box bold mb={0.5}>
              进度
            </Box>
            <Box color="label">
              已完成 {progressPercent}%（{Math.round(progress)}/
              {neededProgress || 0}）
            </Box>
          </Box>
          <Box mt={1}>
            <ControlRack controlsLocked={controlsLocked} />
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        {selectedRecipe ? (
          <Section title={selectedRecipe.name} fill scrollable>
            <Stack vertical fill>
              <Stack.Item>
                <Stack align="center">
                  <Stack.Item>
                    <DmIcon
                      icon={selectedRecipe.icon_file}
                      icon_state={selectedRecipe.icon_state}
                      width={16}
                      height={16}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item mt={1}>
                <Box bold mb={1}>
                  所需材料
                </Box>
                {selectedRecipe.requirements.map((requirement) => {
                  const availableCount = hopperCounts[requirement.key] || 0;
                  const hasEnough = availableCount >= requirement.amount;

                  return (
                    <Stack
                      key={`${requirement.key}-${requirement.amount}`}
                      align="center"
                      mb={0.5}
                    >
                      <Stack.Item>
                        <Box className={requirement.icon} mr={1} inline />
                      </Stack.Item>
                      <Stack.Item>
                        {hasEnough ? (
                          <Box
                            inline
                            mr={1}
                            style={{
                              color: '#58b76a',
                            }}
                          >
                            ✓
                          </Box>
                        ) : null}
                      </Stack.Item>
                      <Stack.Item>
                        {requirement.amount}x {requirement.name}
                      </Stack.Item>
                    </Stack>
                  );
                })}
              </Stack.Item>
              <Stack.Item mt={2}>
                <Box bold mb={1}>
                  排队数量
                </Box>
                <Stack align="center" justify="space-between">
                  <Stack.Item>
                    <Button onClick={() => setAmount(Math.max(1, amount - 5))}>
                      {'<<'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => setAmount(Math.max(1, amount - 1))}>
                      {'<'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box textAlign="center" bold fontSize={1.5}>
                      {amount}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => setAmount(Math.min(25, amount + 1))}>
                      {'>'}
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => setAmount(Math.min(25, amount + 5))}>
                      {'>>'}
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item mt={2}>
                <Button.Confirm
                  fluid
                  color="good"
                  onClick={() =>
                    act('add_recipe', { ref: selectedRecipe.ref, amount })
                  }
                >
                  将 {amount} 件加入队列
                </Button.Confirm>
              </Stack.Item>
            </Stack>
          </Section>
        ) : (
          <Section title="No Recipe Selected" fill>
            <NoticeBox>
              从右侧选择配方，查看所需材料。
            </NoticeBox>
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

type OffCenterPanelProps = {
  controlsLocked: boolean;
  machinePowered: boolean;
};

const OffCenterPanel = ({
  controlsLocked,
  machinePowered,
}: OffCenterPanelProps) => {
  return (
    <Section fill>
      <Stack fill align="center" justify="center">
        <Stack.Item>
          <Box
            textAlign="center"
            px={4}
            py={6}
            style={{
              background: '#2c2f33',
              border: '1px solid rgba(255, 255, 255, 0.08)',
            }}
          >
            <Box
              bold
              fontSize={1.8}
              style={{
                color: '#d8d3c2',
              }}
            >
              {machinePowered
                ? '玛勒姆等待你的鲜血、汗水与虔诚'
                : "玛勒姆的生命之力尚未流动"}
            </Box>
            <Box
              mt={2}
              bold
              fontSize={2.2}
              style={{
                color: STATUS_COLORS.off,
              }}
            >
              {MACHINE_ACTIVITY_LABELS.inactive}
            </Box>
            <Box mt={3}>
              <ControlRack controlsLocked={controlsLocked} />
            </Box>
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

type ControlRackProps = {
  controlsLocked: boolean;
};

const ControlRack = ({ controlsLocked }: ControlRackProps) => {
  const { act } = useBackend<Data>();
  const isLocked = Boolean(controlsLocked);

  return (
    <Stack vertical>
      <Stack.Item>
        <Box bold textAlign="center" mb={1}>
          控制台
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow>
            <Button fluid disabled={isLocked} onClick={() => act('lever')}>
              拉动操纵杆
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button fluid disabled={isLocked} onClick={() => act('button')}>
              按下按钮
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button fluid disabled={isLocked} onClick={() => act('dial')}>
              转动旋钮
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {isLocked && (
        <Stack.Item>
          <Box color="label" textAlign="center" mt={1}>
            站在自动锻造机旁才能操作控制台。
          </Box>
        </Stack.Item>
      )}
    </Stack>
  );
};

type RecipePickerSectionProps = {
  recipes: Recipe[];
  selectedRef: string | null;
  onSelect: (ref: string) => void;
  searchText: string;
  onSearch: (value: string) => void;
};

const RecipePickerSection = ({
  recipes,
  selectedRef,
  onSelect,
  searchText,
  onSearch,
}: RecipePickerSectionProps) => {
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Input
          fluid
          placeholder="搜索配方……"
          value={searchText}
          onChange={onSearch}
        />
      </Stack.Item>
      <Stack.Item grow basis={0} mt={1}>
        <Section title="What I Can Provide" fill scrollable>
          {!recipes.length && <NoticeBox>没有匹配的配方。</NoticeBox>}
          {recipes.map((recipe) => (
            <Button
              key={recipe.ref}
              fluid
              mb={1}
              selected={recipe.ref === selectedRef}
              onClick={() => onSelect(recipe.ref)}
            >
              <Stack align="center">
                <Stack.Item>
                  <Box className={recipe.icon} mr={1} inline />
                </Stack.Item>
                <Stack.Item grow>
                  <Box bold>{recipe.name}</Box>
                  <Box color="label">
                    {({ Weapons: '武器', Engineering: '工程', Tools: '工具', Ammo: '弹药', Valuables: '贵重物品' } as Record<string, string>)[recipe.category] ?? recipe.category}
                    {recipe.created_num > 1 ? ` x${recipe.created_num}` : ''}
                  </Box>
                </Stack.Item>
              </Stack>
            </Button>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

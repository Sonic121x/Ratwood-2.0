import { useEffect, useState } from 'react';
import { Box, Button, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type CatalogRow = {
  id: number;
  name: string;
  description: string;
  source: string;
  category: string;
  terrain: BooleanLike;
};

type TraitRow = {
  id: string;
  name: string;
  description: string;
  owned: BooleanLike;
};

type Page<T> = {
  rows: T[];
  page: number;
  pages: number;
  total: number;
};

type ValueRow = { id: string | number; name: string; value: number };

type Data = {
  tab: string;
  busy: BooleanLike;
  notice: string;
  body: BooleanLike;
  character: string;
  godmode: BooleanLike;
  held_item: string | null;
  position: string;
  source: string;
  category: string;
  catalog?: Page<CatalogRow> & { categories: string[] };
  weather_options?: { id: number; name: string }[];
  weather?: string;
  tod?: string;
  tod_override?: string;
  clock?: string;
  day?: number;
  stats?: ValueRow[];
  skills?: ValueRow[];
  traits?: Page<TraitRow>;
  trait_query?: string;
  owned_only?: BooleanLike;
};

const tabs = [
  ['world', '世界环境', 'globe'],
  ['items', '调用物品', 'box-open'],
  ['buildings', '调用建筑', 'hammer'],
  ['creatures', '生成生物', 'paw'],
  ['stats', '自身属性', 'user'],
  ['skills', '自身技能', 'book'],
  ['traits', '自身特性', 'star'],
];

const sources = {
  all: '全部来源',
  craft: '制作菜单',
  rpg: 'RPG 商店',
  purchase: '购买目录',
};

const times = {
  natural: '自然昼夜',
  dawn: '黎明',
  day: '白昼',
  dusk: '黄昏',
  night: '夜晚',
};

const inputStyle = {
  background: '#211e1a',
  border: '1px solid #766448',
  color: '#eee5d3',
  padding: '6px 8px',
  borderRadius: '3px',
};

const sourceName = (source: string) => sources[source] || source;

const Pagination = ({
  page,
  pages,
  total,
  action,
}: {
  page: number;
  pages: number;
  total: number;
  action: string;
}) => {
  const { act, data } = useBackend<Data>();
  return (
    <Box mt={1} mb={1}>
      <Button
        icon="chevron-left"
        disabled={!!data.busy || page <= 1}
        onClick={() => act(action, { page: page - 1 })}
      >
        上一页
      </Button>
      <Box inline mx={1}>
        {page} / {pages} 页 · 共 {total} 项
      </Box>
      <Button
        icon="chevron-right"
        disabled={!!data.busy || page >= pages}
        onClick={() => act(action, { page: page + 1 })}
      >
        下一页
      </Button>
    </Box>
  );
};

const ValueEditor = ({ row, skill }: { row: ValueRow; skill: boolean }) => {
  const { act, data } = useBackend<Data>();
  const [value, setValue] = useState(String(row.value));
  useEffect(() => setValue(String(row.value)), [row.value, row.id]);
  const min = skill ? 0 : 1;
  const max = skill ? 6 : 20;
  const number = Number(value);
  const valid =
    value.trim() !== '' &&
    Number.isInteger(number) &&
    number >= min &&
    number <= max;

  return (
    <Section title={row.name}>
      <Box inline mr={2}>
        当前：{row.value}
      </Box>
      <input
        aria-label={`设置${row.name}`}
        style={{ ...inputStyle, width: 75, marginRight: 8 }}
        type="number"
        min={min}
        max={max}
        step={1}
        value={value}
        disabled={!data.body || !!data.busy}
        onChange={(event) => setValue(event.target.value)}
      />
      <Button
        disabled={!data.body || !!data.busy || !valid}
        onClick={() =>
          act(skill ? 'skill' : 'stat', { id: row.id, value: number })
        }
      >
        应用
      </Button>
    </Section>
  );
};

const WorldControls = () => {
  const { act, data } = useBackend<Data>();
  return (
    <>
      <Section title="昼夜调制">
        <Box mb={1}>
          第 {data.day} 天 · 时钟 {data.clock} · 当前阶段：
          {times[data.tod || ''] || data.tod}
        </Box>
        {Object.entries(times).map(([value, label]) => (
          <Button
            key={value}
            selected={data.tod_override === value}
            disabled={!!data.busy}
            onClick={() => act('tod', { value })}
          >
            {label}
          </Button>
        ))}
        <Box color="label" mt={1}>
          固定昼夜阶段时，时钟继续运行。切换与恢复不增加天数或触发每日结算。
        </Box>
      </Section>
      <Section title={`天气调制 · ${data.weather || '晴天'}`}>
        <Button
          icon="sun"
          disabled={!!data.busy}
          onClick={() => act('weather', { id: 0 })}
        >
          放晴
        </Button>
        <Box mt={1}>
          {data.weather_options?.map((weather) => (
            <Button
              key={weather.id}
              mb={0.7}
              disabled={!!data.busy}
              onClick={() => act('weather', { id: weather.id })}
            >
              {weather.name}
            </Button>
          ))}
        </Box>
        <Box color="label" mt={1}>
          立即替换当前及排队天气，持续时间沿用天气本身的规则。
        </Box>
      </Section>
    </>
  );
};

const Catalog = () => {
  const { act, data } = useBackend<Data>();
  const catalog = data.catalog;
  if (!catalog) {
    return null;
  }
  return (
    <>
      <Section title="选择目录">
        <Box mb={1}>
          {Object.entries(sources).map(([source, name]) => (
            <Button
              key={source}
              selected={data.source === source}
              disabled={!!data.busy}
              onClick={() => act('source', { source })}
            >
              {name}
            </Button>
          ))}
        </Box>
        <select
          aria-label="目录分类"
          style={{ ...inputStyle, width: '100%', marginBottom: 10 }}
          value={data.category}
          disabled={!!data.busy}
          onChange={(event) =>
            act('category', { category: event.target.value })
          }
        >
          {catalog.categories.map((category) => (
            <option key={category} value={category}>
              {category}
            </option>
          ))}
        </select>
        <Box>
          生成位置：
          <Button
            selected={data.position === 'here'}
            disabled={!!data.busy}
            onClick={() => act('position', { position: 'here' })}
          >
            当前格（物品优先入手）
          </Button>
          <Button
            selected={data.position === 'front'}
            disabled={!!data.busy}
            onClick={() => act('position', { position: 'front' })}
          >
            面前一格
          </Button>
        </Box>
        <Box color="label" mt={1}>
          每次调用一个产物，不扣材料、积分、货币或商店库存。
        </Box>
      </Section>
      <Pagination {...catalog} action="page" />
      {!catalog.rows.length && (
        <Box color="label">此分类中没有可调用条目。</Box>
      )}
      {catalog.rows.map((row) => (
        <Section
          key={row.id}
          title={row.name}
          buttons={
            row.terrain ? (
              <Button.Confirm
                color="orange"
                disabled={!!data.busy}
                confirmContent="替换目标格地形？"
                onClick={() => act('spawn', { id: row.id })}
              >
                替换地形
              </Button.Confirm>
            ) : (
              <Button
                icon="plus"
                disabled={!!data.busy}
                onClick={() => act('spawn', { id: row.id })}
              >
                生成
              </Button>
            )
          }
        >
          <Box color="label" mb={0.5}>
            {sourceName(row.source)} · {row.category}
          </Box>
          {row.description}
        </Section>
      ))}
      <Pagination {...catalog} action="page" />
    </>
  );
};

const Traits = () => {
  const { act, data } = useBackend<Data>();
  const [customTrait, setCustomTrait] = useState('');
  const traits = data.traits;
  if (!traits) {
    return null;
  }
  return (
    <>
      <Section title="特性目录">
        <input
          aria-label="筛选特性"
          placeholder="筛选特性名称或说明"
          style={{ ...inputStyle, width: '65%', marginRight: 8 }}
          value={data.trait_query || ''}
          maxLength={128}
          onChange={(event) =>
            act('trait_query', { value: event.target.value })
          }
        />
        <Button selected={!!data.owned_only} onClick={() => act('owned_only')}>
          仅已拥有
        </Button>
        <Box mt={1}>
          <input
            aria-label="自定义特性键"
            placeholder="未登记的底层 Trait 键"
            style={{ ...inputStyle, width: '65%', marginRight: 8 }}
            value={customTrait}
            maxLength={128}
            onChange={(event) => setCustomTrait(event.target.value)}
          />
          <Button
            disabled={!data.body || !!data.busy || !customTrait.trim()}
            onClick={() => act('custom_trait', { id: customTrait.trim() })}
          >
            添加特性
          </Button>
        </Box>
        <Box color="label" mt={1}>
          操作底层 Trait；不授予或撤销完整美德的法术、组件和动作。
          移除会清除该特性的全部来源，其他系统仍可能在之后重新授予。
        </Box>
      </Section>
      <Pagination {...traits} action="trait_page" />
      {traits.rows.map((trait) => (
        <Section
          key={trait.id}
          title={trait.name}
          buttons={
            trait.owned ? (
              <Button.Confirm
                color="bad"
                disabled={!data.body || !!data.busy}
                confirmContent="移除全部来源？"
                onClick={() => act('remove_trait', { id: trait.id })}
              >
                移除
              </Button.Confirm>
            ) : (
              <Button
                disabled={!data.body || !!data.busy}
                onClick={() => act('add_trait', { id: trait.id })}
              >
                添加
              </Button>
            )
          }
        >
          <Box color={trait.owned ? 'good' : 'label'} mb={0.5}>
            {trait.owned ? '已拥有' : '未拥有'}
          </Box>
          {trait.description || '此特性尚无说明。'}
        </Section>
      ))}
      <Pagination {...traits} action="trait_page" />
    </>
  );
};

export const WorldModulation = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={1000} height={780} title="世界调制系统">
      <Window.Content>
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            height: '100%',
            gap: 10,
          }}
        >
          <Section title={`世界调制系统 · ${data.character}`}>
            <Button
              icon="shield-alt"
              selected={!!data.godmode}
              disabled={!data.body || !!data.busy}
              onClick={() => act('godmode')}
            >
              无敌模式：{data.godmode ? '开启' : '关闭'}
            </Button>
            <Button
              icon="clone"
              disabled={!data.body || !data.held_item || !!data.busy}
              onClick={() => act('duplicate')}
              tooltip="复制活动手物品、容器内物品和药液；不完整复制组件、法术及特殊储物空间逻辑。"
            >
              复制手中物品
            </Button>
            <Box inline ml={1} color="label">
              {data.held_item || '活动手为空'}
            </Box>
            <Box mt={1} color="#e2c58b">
              {data.notice}
            </Box>
            {!data.body && (
              <Box mt={1} color="orange">
                当前没有生物躯体；自身编辑和复制不可用，世界控制与目录生成仍可使用。
              </Box>
            )}
          </Section>
          <div style={{ display: 'flex', flex: 1, minHeight: 0, gap: 12 }}>
            <nav style={{ width: 120, flexShrink: 0 }}>
              {tabs.map(([id, name, icon]) => (
                <Button
                  key={id}
                  fluid
                  mb={0.8}
                  icon={icon}
                  selected={data.tab === id}
                  disabled={!!data.busy}
                  onClick={() => act('tab', { tab: id })}
                >
                  {name}
                </Button>
              ))}
            </nav>
            <div
              key={data.tab}
              style={{
                flex: 1,
                minWidth: 0,
                overflowY: 'auto',
                paddingRight: 8,
              }}
            >
              {data.tab === 'world' && <WorldControls />}
              {['items', 'buildings', 'creatures'].includes(data.tab) && (
                <Catalog />
              )}
              {data.tab === 'stats' && (
                <>
                  <Box mb={1} color="label">
                    设置自身当前属性（1—20），同时清除该项隐藏的越界缓冲。
                  </Box>
                  {data.stats?.map((row) => (
                    <ValueEditor key={row.id} row={row} skill={false} />
                  ))}
                </>
              )}
              {data.tab === 'skills' && (
                <>
                  <Box mb={1} color="label">
                    0 无训练 · 1 新手 · 2 学徒 · 3 熟练 · 4 专家 · 5 大师 · 6
                    传奇
                  </Box>
                  {data.skills?.map((row) => (
                    <ValueEditor key={row.id} row={row} skill />
                  ))}
                </>
              )}
              {data.tab === 'traits' && <Traits />}
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

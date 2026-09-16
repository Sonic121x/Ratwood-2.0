import { type CSSProperties, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Input,
  NumberInput,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Item = {
  id: string;
  name: string;
  description: string;
  icon?: string;
  icon_state?: string;
  mode: 'counted' | 'sealed';
  quantity: number;
  children: number;
  volume: number;
  liquids: { name: string; volume: number }[];
  integrity?: number;
  max_integrity?: number;
  error?: string;
  legacy?: boolean;
  expanded?: boolean;
  contents?: Item[];
  tree_limited?: boolean;
};

type Data = {
  hands: Item[];
  entries: Item[];
  detail: Item | null;
  kinds: number;
  units: number;
  sealed: number;
  query: string;
  filter: 'all' | 'counted' | 'sealed';
  page: number;
  pages: number;
  matches: number;
  message: string;
  busy: boolean;
  extract_limit: number;
};

const colors = {
  text: '#ece7f4',
  muted: '#b3a7c5',
  brass: '#dec18b',
  violet: '#c3a2f2',
  border: '#443650',
  danger: '#f2acac',
};

const panel: CSSProperties = {
  padding: '14px',
  marginBottom: '12px',
  border: `1px solid ${colors.border}`,
  borderRadius: '8px',
  background: 'rgba(32, 25, 44, 0.94)',
};

const heading: CSSProperties = {
  fontSize: '14px',
  fontWeight: 'bold',
  color: colors.brass,
  marginBottom: '12px',
};

const muted: CSSProperties = {
  color: colors.muted,
  fontSize: '12px',
  lineHeight: 1.7,
};

const badge = (counted: boolean): CSSProperties => ({
  display: 'inline-block',
  padding: '2px 7px',
  borderRadius: '4px',
  fontSize: '11px',
  color: counted ? colors.violet : colors.brass,
  background: counted ? '#3c2c54' : '#403526',
});

const ItemIcon = ({ item }: { item: Item }) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: '44px',
      height: '44px',
      flexShrink: 0,
      overflow: 'hidden',
      background: '#14101c',
      border: `1px solid ${colors.border}`,
      borderRadius: '6px',
    }}
  >
    {item.icon && item.icon_state ? (
      <DmIcon
        icon={item.icon}
        icon_state={item.icon_state}
        // Numeric Box dimensions are rem, so constrain the sprite in pixels.
        style={{
          display: 'block',
          width: 'auto',
          height: 'auto',
          maxWidth: '32px',
          maxHeight: '32px',
          flexShrink: 0,
        }}
      />
    ) : (
      <Box color={colors.violet} fontSize={2}>
        ◇
      </Box>
    )}
  </div>
);

const Summary = ({ item }: { item: Item }) => (
  <span style={muted}>
    数量 {item.quantity}
    {item.children > 0 && ` · 内含 ${item.children} 件`}
    {item.volume > 0 && ` · 试剂 ${item.volume} 单位`}
  </span>
);

const Extract = ({ item }: { item: Item }) => {
  const { act, data } = useBackend<Data>();
  const [requested, setRequested] = useState(1);
  const counted = item.mode === 'counted';
  const limit = Math.max(1, Math.min(item.quantity, data.extract_limit));
  const amount = Math.max(1, Math.min(requested, limit));
  return (
    <Stack align="center">
      {counted && (
        <Stack.Item>
          <NumberInput
            value={amount}
            minValue={1}
            maxValue={limit}
            step={1}
            width="62px"
            onChange={(value: number) => {
              if (Number.isFinite(value)) {
                setRequested(Math.floor(value));
              }
            }}
          />
        </Stack.Item>
      )}
      <Stack.Item>
        <Button
          icon="arrow-up"
          color="purple"
          disabled={data.busy || !!item.error}
          tooltip={counted ? '优先放入手中，多余的放在脚下' : '完整取回原物品'}
          onClick={() => act('extract', { id: item.id, amount })}
        >
          {counted ? '提取' : '取回'}
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const Liquids = ({ item }: { item: Item }) => (
  <>
    {item.liquids?.map((liquid, index) => (
      <div key={index} style={muted}>
        {liquid.name} · {liquid.volume} 单位
      </div>
    ))}
  </>
);

const ContentsTree = ({ items }: { items: Item[] }) => {
  const { act } = useBackend<Data>();
  return (
    <div
      style={{ borderLeft: `1px solid ${colors.border}`, paddingLeft: '10px' }}
    >
      {items.map((item) => (
        <div key={item.id} style={{ padding: '6px 0' }}>
          <div style={{ display: 'flex', alignItems: 'center' }}>
            <div style={{ flex: 1, minWidth: 0, overflowWrap: 'anywhere' }}>
              <div>{item.name}</div>
              <Summary item={item} />
            </div>
            {(item.children > 0 || item.volume > 0) && (
              <Button
                compact
                color="transparent"
                icon={item.expanded ? 'chevron-down' : 'chevron-right'}
                tooltip={item.expanded ? '收起内容' : '展开内容'}
                onClick={() => act('expand', { node: item.id })}
              />
            )}
          </div>
          {!!item.expanded && (
            <>
              <Liquids item={item} />
              <ContentsTree items={item.contents ?? []} />
            </>
          )}
        </div>
      ))}
    </div>
  );
};

const Details = () => {
  const { data } = useBackend<Data>();
  const item = data.detail;
  return (
    <div style={panel}>
      <div style={heading}>物品详情</div>
      {!item ? (
        <div style={{ ...muted, padding: '22px 0', textAlign: 'center' }}>
          选择一条库存记录
          <br />
          查看属性、液体与背包内容
        </div>
      ) : (
        <>
          <Stack align="center" mb={1}>
            <Stack.Item>
              <ItemIcon item={item} />
            </Stack.Item>
            <Stack.Item grow style={{ minWidth: 0, overflowWrap: 'anywhere' }}>
              <Box bold mb={0.5}>
                {item.name}
              </Box>
              <span style={badge(item.mode === 'counted')}>
                {item.mode === 'counted' ? '数据化' : '原物品封存'}
              </span>
            </Stack.Item>
          </Stack>
          <p
            style={{
              ...muted,
              whiteSpace: 'pre-wrap',
              overflowWrap: 'anywhere',
            }}
          >
            {item.description || '没有额外描述。'}
          </p>
          <Summary item={item} />
          {item.error && <p style={{ color: colors.danger }}>{item.error}</p>}
          {item.mode === 'counted' ? (
            <p style={{ ...muted, color: colors.violet }}>
              取出时恢复默认状态，不保留原耐久、血迹、改名或其他自定义属性。
            </p>
          ) : (
            <>
              {item.integrity != null && (
                <p style={muted}>
                  耐久 {item.integrity}
                  {item.max_integrity != null && ` / ${item.max_integrity}`}
                </p>
              )}
              <Liquids item={item} />
              {!!item.legacy && (
                <p style={muted}>旧版快照：仅恢复当时记录的属性。</p>
              )}
              {!!item.contents?.length && (
                <div style={{ marginTop: '12px' }}>
                  <div style={heading}>封存内容</div>
                  <ContentsTree items={item.contents} />
                  <p style={muted}>
                    内容随容器整体取回，不可单独提取。内容树最多显示 20 层、200
                    项。
                  </p>
                </div>
              )}
              {!!item.tree_limited && (
                <p style={muted}>其余内容已保留，取回容器后可查看。</p>
              )}
            </>
          )}
          <Box mt={1.5}>
            <Extract key={item.id} item={item} />
          </Box>
        </>
      )}
    </div>
  );
};

export const VoidCube = () => {
  const { data, act } = useBackend<Data>();
  return (
    <Window width={900} height={700} title="虚空魔方">
      <Window.Content scrollable>
        <div
          style={{
            minHeight: '100%',
            padding: '18px',
            color: colors.text,
            fontFamily: '"Microsoft YaHei", "Noto Sans SC", sans-serif',
            background: 'linear-gradient(140deg, #251a36 0%, #131019 55%)',
          }}
        >
          <Stack align="center" mb={2}>
            <Stack.Item grow>
              <div
                style={{
                  color: colors.brass,
                  fontSize: '25px',
                  fontWeight: 'bold',
                }}
              >
                ◈ 虚空魔方
              </div>
              <div style={{ ...muted, marginTop: '5px' }}>
                容量不限 · 数据化存储 / 原物品封存
              </div>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="sync"
                color="transparent"
                onClick={() => act('refresh')}
              >
                刷新
              </Button>
            </Stack.Item>
          </Stack>

          <Stack mb={1.5}>
            {[
              ['数据种类', data.kinds],
              ['数据总量', data.units],
              ['封存件数', data.sealed],
            ].map(([label, value]) => (
              <Stack.Item grow key={label}>
                <div style={{ ...panel, marginBottom: 0 }}>
                  <div style={muted}>{label}</div>
                  <div
                    style={{
                      color: colors.brass,
                      fontSize: '24px',
                      marginTop: '4px',
                    }}
                  >
                    {value ?? 0}
                  </div>
                </div>
              </Stack.Item>
            ))}
          </Stack>

          <div
            role="status"
            style={{
              ...muted,
              padding: '9px 12px',
              marginBottom: '14px',
              background: '#2e233d',
              borderLeft: `3px solid ${colors.violet}`,
            }}
          >
            {data.message}
          </div>

          <div style={panel}>
            <div style={heading}>手持物品</div>
            {!data.hands?.length ? (
              <div style={muted}>
                请先将物品拿在手上。穿戴装备和口袋中的物品不会列入。
              </div>
            ) : (
              data.hands.map((item) => (
                <Stack key={item.id} align="center" mb={1}>
                  <Stack.Item>
                    <ItemIcon item={item} />
                  </Stack.Item>
                  <Stack.Item grow style={{ minWidth: 0 }}>
                    <Box bold style={{ overflowWrap: 'anywhere' }}>
                      {item.name}
                    </Box>
                    <Summary item={item} />
                    <div
                      style={{
                        ...muted,
                        color: item.error ? colors.danger : colors.muted,
                      }}
                    >
                      {item.error ||
                        (item.mode === 'counted'
                          ? '数据化 · 取出时恢复默认状态'
                          : '封存 · 保留原物品及内部内容')}
                    </div>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="arrow-down"
                      color="purple"
                      disabled={data.busy || !!item.error}
                      onClick={() => act('store', { item: item.id })}
                    >
                      {item.mode === 'counted' ? '数据化存入' : '封存物品'}
                    </Button>
                  </Stack.Item>
                </Stack>
              ))
            )}
          </div>

          <div
            style={{
              display: 'flex',
              alignItems: 'flex-start',
              gap: '12px',
              flexWrap: 'wrap',
            }}
          >
            <div style={{ flex: '2 1 440px', minWidth: 0 }}>
              <div style={panel}>
                <div style={heading}>已存物品</div>
                <Input
                  fluid
                  expensive
                  placeholder="搜索物品名称…"
                  value={data.query}
                  maxLength={100}
                  onChange={(query: string) => act('search', { query })}
                />
                <Box mt={1} mb={1}>
                  {[
                    ['all', '全部'],
                    ['counted', '数据化'],
                    ['sealed', '封存'],
                  ].map(([filter, label]) => (
                    <Button
                      key={filter}
                      color="transparent"
                      selected={data.filter === filter}
                      onClick={() => act('filter', { filter })}
                    >
                      {label}
                    </Button>
                  ))}
                </Box>

                {!data.entries?.length && (
                  <div
                    style={{ ...muted, padding: '36px 0', textAlign: 'center' }}
                  >
                    ◇<br />
                    暂无匹配的物品
                  </div>
                )}
                {data.entries?.map((item) => (
                  <div
                    key={item.id}
                    style={{
                      padding: '12px 0',
                      borderTop: `1px solid ${colors.border}`,
                      background:
                        data.detail?.id === item.id ? '#2b2039' : 'transparent',
                    }}
                  >
                    <Stack align="center">
                      <Stack.Item>
                        <ItemIcon item={item} />
                      </Stack.Item>
                      <Stack.Item
                        grow
                        style={{ minWidth: 0, overflowWrap: 'anywhere' }}
                      >
                        <Box bold mb={0.5}>
                          {item.name}
                        </Box>
                        <Summary item={item} />
                      </Stack.Item>
                      <Stack.Item>
                        <span style={badge(item.mode === 'counted')}>
                          {item.mode === 'counted'
                            ? '数据化'
                            : item.legacy
                              ? '旧快照'
                              : '封存'}
                        </span>
                      </Stack.Item>
                    </Stack>
                    <Stack align="center" justify="space-between" mt={1}>
                      <Stack.Item>
                        <Button
                          icon="search"
                          color="transparent"
                          selected={data.detail?.id === item.id}
                          onClick={() => act('inspect', { id: item.id })}
                        >
                          详情
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Extract item={item} />
                      </Stack.Item>
                    </Stack>
                    {item.error && (
                      <div style={{ ...muted, color: colors.danger }}>
                        {item.error}
                      </div>
                    )}
                  </div>
                ))}

                <Stack align="center" justify="space-between" mt={1.5}>
                  <Stack.Item>
                    <Button
                      icon="chevron-left"
                      color="transparent"
                      disabled={data.page <= 1}
                      onClick={() => act('page', { page: data.page - 1 })}
                    >
                      上一页
                    </Button>
                  </Stack.Item>
                  <Stack.Item style={muted}>
                    {data.page} / {data.pages} · {data.matches} 条
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="chevron-right"
                      color="transparent"
                      disabled={data.page >= data.pages}
                      onClick={() => act('page', { page: data.page + 1 })}
                    >
                      下一页
                    </Button>
                  </Stack.Item>
                </Stack>
              </div>
            </div>
            <div style={{ flex: '1 1 250px', minWidth: 0 }}>
              <Details />
              <div style={{ ...muted, padding: '0 8px 12px' }}>
                每次最多提取 {data.extract_limit} 个基础单位。
                <br />
                背包及其内容整体封存、整体取回。
                <br />
                封存不会暂停腐败或其他计时效果。
              </div>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

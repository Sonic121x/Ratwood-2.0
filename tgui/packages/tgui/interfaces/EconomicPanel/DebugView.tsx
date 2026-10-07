import {
  Box,
  Button,
  LabeledList,

  Stack,
} from 'tgui-core/components';
import { Section } from '../../components/Localized';
export type DebugCounts = {
  derived_price_count: number;
  categorized_count: number;
  uncategorized_item_count: number;
  total_item_count: number;
};

type Props = {
  debug: DebugCounts;
  act: (action: string, payload?: Record<string, unknown>) => void;
};

export const DebugView = (props: Props) => {
  const { debug, act } = props;
  return (
    <Stack>
      <Stack.Item grow basis={0}>
        <Section title="Pricing Engine" display_title="定价引擎">
          <LabeledList>
            <LabeledList.Item label="推导价格数量">
              {debug.derived_price_count}
            </LabeledList.Item>
            <LabeledList.Item label="已分类子类型">
              {debug.categorized_count}
            </LabeledList.Item>
            <LabeledList.Item label="未分类 /obj/item">
              {debug.uncategorized_item_count >= 0 ? (
                <>
                  {debug.uncategorized_item_count} / {debug.total_item_count} (
                  {debug.total_item_count > 0
                    ? Math.round(
                        (debug.uncategorized_item_count /
                          debug.total_item_count) *
                          100,
                      )
                    : 0}
                  %)
                </>
              ) : (
                <i>尚未扫描，请点击刷新</i>
              )}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1} mb={1}>
            <Button icon="sync" onClick={() => act('refresh_debug_counts')}>
              刷新计数
            </Button>
          </Box>
          <Box mb={1}>
            <i>
              CSV 文件保存在项目根目录。完整重新计算需要数百毫秒；
              仅导出未分类物品耗时更短。
            </i>
          </Box>
          <Stack vertical>
            <Stack.Item>
              <Button.Confirm
                icon="file-csv"
                onClick={() => act('dump_pricing_audits')}
              >
                导出全部定价审计（重新计算）
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="file-csv"
                onClick={() => act('dump_uncategorized_items')}
              >
                仅导出未分类物品
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <Section title="Chronicle Stats" display_title="编年史统计">
          <Box mb={1}>
            <i>
              写入 data/chronicle_stats/chroniclestats_YYYY-MM-WN.txt，
              每回合对应一个数据块。回合中途点击导出会覆盖当前
              回合对应的数据块。
            </i>
          </Box>
          <Stack vertical>
            <Stack.Item>
              <Button
                icon="file-pen"
                onClick={() => act('dump_chronicle_stats')}
              >
                导出当前回合
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="download"
                onClick={() => act('download_chronicle_this_week')}
              >
                下载（本周）
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="download"
                onClick={() => act('download_chronicle_last_week')}
              >
                下载（上周）
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

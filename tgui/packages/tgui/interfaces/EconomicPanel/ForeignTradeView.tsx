import {
  Box,
  Button,

  Stack,
  Table,
} from 'tgui-core/components';
import { Section } from '../../components/Localized';
export type ForeignRealm = {
  id: string;
  name: string;
  cultural_goods_count: number;
  bulk_demand_count: number;
  bulk_supply_count: number;
};

export type TradeShip = {
  ship_id: string;
  realm_id: string;
  ship_name: string;
  captain_name: string;
  ship_type: string;
  tonnage: number;
  expected_favor: number;
  dock_state: string;
  favor_earned: number;
};

export type ForeignTrade = {
  realms: ForeignRealm[];
  ships?: TradeShip[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

export const ForeignTradeView = (props: {
  foreignTrade: ForeignTrade;
  act: ActFn;
}) => {
  const { foreignTrade, act } = props;
  return (
    <Stack vertical>
      <Stack.Item>
        <RealmsSection foreignTrade={foreignTrade} act={act} />
      </Stack.Item>
      <Stack.Item>
        <ShipsSection foreignTrade={foreignTrade} act={act} />
      </Stack.Item>
    </Stack>
  );
};

const RealmsSection = (props: {
  foreignTrade: ForeignTrade;
  act: ActFn;
}) => {
  const { foreignTrade, act } = props;
  return (
    <Section
      title="Foreign Trade - Realms" display_title="对外贸易 - 国度"
      buttons={
        <Button.Confirm color="bad" onClick={() => act('clear_trade_ships')}>
          清除所有船只
        </Button.Confirm>
      }
    >
      <Table>
        <Table.Row header>
          <Table.Cell>国度</Table.Cell>
          <Table.Cell collapsing>特色商品</Table.Cell>
          <Table.Cell collapsing>需求/供应</Table.Cell>
          <Table.Cell collapsing>&nbsp;</Table.Cell>
        </Table.Row>
        {foreignTrade.realms.map((r) => (
          <Table.Row key={r.id}>
            <Table.Cell>
              <b>{r.name}</b>
              <Box italic color="gray" fontSize="11px">
                {r.id}
              </Box>
            </Table.Cell>
            <Table.Cell collapsing>{r.cultural_goods_count}</Table.Cell>
            <Table.Cell collapsing>
              {r.bulk_demand_count} / {r.bulk_supply_count}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                onClick={() =>
                  act('spawn_trade_ship', { realm_id: r.id })
                }
              >
                生成船只
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const ShipsSection = (props: {
  foreignTrade: ForeignTrade;
  act: ActFn;
}) => {
  const { foreignTrade, act } = props;
  const ships = foreignTrade.ships ?? [];
  return (
    <Section
      title={`Foreign Trade - Ships (${ships.length})`} display_title={`对外贸易 - 船只（${ships.length} 艘）`}
      buttons={
        <>
          <Button onClick={() => act('regen_hails')}>重新生成呼叫</Button>
          <Button ml={1} onClick={() => act('force_auto_hail')}>
            强制自动呼叫
          </Button>
          <Button ml={1} onClick={() => act('reroll_trade_ships')}>
            重新生成每日船只池
          </Button>
        </>
      }
    >
      {ships.length === 0 ? (
        <Box italic color="gray">
          尚未生成船只。请使用上方的生成船只按钮。
        </Box>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>船只</Table.Cell>
            <Table.Cell>船长</Table.Cell>
            <Table.Cell collapsing>国度</Table.Cell>
            <Table.Cell collapsing>类型</Table.Cell>
            <Table.Cell collapsing>吨位</Table.Cell>
            <Table.Cell collapsing>状态</Table.Cell>
            <Table.Cell collapsing>预计商人好感</Table.Cell>
            <Table.Cell collapsing>已获好感</Table.Cell>
          </Table.Row>
          {ships.map((s) => (
            <Table.Row key={s.ship_id}>
              <Table.Cell>{s.ship_name}</Table.Cell>
              <Table.Cell>{s.captain_name}</Table.Cell>
              <Table.Cell collapsing>{{ aavnr: '阿瓦尔', grenzelhoft: '格伦泽尔霍夫特', otava: '奥塔瓦', kazengun: '风郡', hammerhold: '铁锤堡', etrusca: '伊特鲁斯卡', gronn: '格隆恩', vakra: '瓦克兰', underdark: '幽暗地域', naledi: '纳莱迪', zybantium: '兹班图' }[s.realm_id] || s.realm_id}</Table.Cell>
              <Table.Cell collapsing>{s.ship_type}</Table.Cell>
              <Table.Cell collapsing>{s.tonnage}吨</Table.Cell>
              <Table.Cell collapsing>{{ available: '可派遣', docked: '已停靠' }[s.dock_state] || s.dock_state}</Table.Cell>
              <Table.Cell collapsing>{s.expected_favor}</Table.Cell>
              <Table.Cell collapsing>{s.favor_earned}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};

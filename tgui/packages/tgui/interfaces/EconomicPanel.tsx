import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NumberInput,

  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import { Section } from '../components/Localized';
type EconomicPanelTab =
  | 'dashboard'
  | 'solvency'
  | 'players'
  | 'charters'
  | 'assembly'
  | 'internal'
  | 'foreign'
  | 'ledger'
  | 'debug';

const TAB_LABELS: Record<EconomicPanelTab, string> = {
  dashboard: '总览',
  solvency: '偿付能力',
  players: '玩家',
  charters: '特许状',
  assembly: '市民议会',
  internal: '国内',
  foreign: '对外贸易',
  ledger: '账簿',
  debug: '调试',
};

const TAB_ORDER: EconomicPanelTab[] = [
  'dashboard',
  'solvency',
  'players',
  'charters',
  'assembly',
  'internal',
  'foreign',
  'ledger',
  'debug',
];
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { type DebugCounts, DebugView } from './EconomicPanel/DebugView';
import { type ForeignTrade, ForeignTradeView } from './EconomicPanel/ForeignTradeView';

type Dashboard = {
  discretionary: number;
  burgher_pledge: number;
  total_bank: number;
  avg_balance: number;
  held_accounts: number;
  under_50m: number;
  in_advance: number;
  in_arrears: number;
  debtor_count: number;
  loans_outstanding: number;
  loan_exposure: number;
  rural_tax_total: number;
  expected_rural_revenue: number;
  expected_wage_outlay: number;
  noble_income_total: number;
  tax_rates: Record<string, number>;
  poll_tax_rates: Record<string, number>;
};

type PlayerRow = {
  ref: string;
  name: string;
  job: string; display_job?: string;
  category: string | null;
  category_name: string;
  rate: number;
  raw_rate: number;
  exempt: BooleanLike;
  advance: number;
  owed: number;
  overdue: number;
  balance: number;
  on_person: number;
  has_loan: BooleanLike;
  is_debtor: BooleanLike;
};

type Filter = {
  category: string;
  status: string;
  search: string;
};

type FilterOptions = {
  categories: string[];
  statuses: string[];
};

type Charter = {
  id: string;
  name: string;
  active: BooleanLike;
  cooldown_remaining: number;
};

type Blockade = {
  region_id: string;
  region_name: string;
  threat_region: string;
  faction_name: string;
  day_started: number;
  has_active_scroll: BooleanLike;
  ref: string;
};

type BlockadeRegionOption = {
  id: string;
  name: string;
  blockaded: BooleanLike;
};

type BlockadeFactionOption = {
  id: string;
  name: string;
};

type LedgerEntry = {
  kind: string;
  from: string;
  to: string;
  amount: number;
  currency: string | null;
  reason: string | null;
  time_label: string;
};

type Assembly = {
  session_number?: number;
  alderman_name?: string | null;
  alderman_ckey?: string | null;
  history_count?: number;
  censured_count?: number;
  trade_cap?: number;
  trade_remaining?: number;
  defense_cap?: number;
  defense_remaining?: number;
};

type SuspendedCharter = {
  id: string;
  name: string;
};

type DailyPayrollRow = {
  job: string; display_job?: string;
  amount: number;
  headcount: number;
  suspended_count: number;
  row_total: number;
};

type Bankruptcy = {
  state: number;
  state_label: string;
  debt: number;
  bankruptcy_count: number;
  concession_picks: number;
  operating_floor: number;
  arrears_loan_floor: number;
  recovery_reset: number;
  autoexport_override: number;
  suspended_charters: SuspendedCharter[];
  atc_loan_min: number;
  atc_loan_max: number;
  // 已移除紧急贷款截止日字段，服务在整个回合持续开放。
  atc_loan_available: BooleanLike;
  atc_loan_blocker: string;
  atc_loan_arrears_consumed: BooleanLike;
  atc_loans_drawn: number;
  daily_payroll: DailyPayrollRow[];
  daily_payroll_total: number;
};

type Data = {
  dashboard: Dashboard;
  filter: Filter;
  filter_options: FilterOptions;
  players: PlayerRow[];
  selected: PlayerRow | null;
  day: number;
  charters: Charter[];
  simulated_player_scalar: number;
  effective_player_count: number;
  live_player_count: number;
  blockades: Blockade[];
  blockade_region_options: BlockadeRegionOption[];
  blockade_faction_options: BlockadeFactionOption[];
  assembly: Assembly;
  bankruptcy: Bankruptcy;
  ledger: LedgerEntry[];
  ledger_total: number;
  ledger_cap: number;
  ledger_full_minted: number;
  ledger_full_burned: number;
  foreign_trade: ForeignTrade;
  debug: DebugCounts;
};

const STATUS_LABELS: Record<string, string> = {
  all: '全部',
  arrears: '欠税',
  advance: '已预缴',
  debtor: '债务人',
  low_balance: '余额不足（低于 50m）',
  exempt: '特许状豁免',
};

const CATEGORY_LABELS: Record<string, string> = {
  all: '全部类别',
  poll_noble: '贵族',
  poll_clergy: '神职人员',
  poll_inquisition: '宗教审判所',
  poll_courtier: '廷臣',
  poll_garrison: '驻军',
  poll_guilds: '行会',
  poll_merchant: '商人',
  poll_burgher: '市民',
  poll_adventurer: '冒险者',
  poll_mercenary: '佣兵',
  poll_peasant: '农民',
};

export const EconomicPanel = () => {
  const { act, data } = useBackend<Data>();
  const {
    dashboard,
    filter,
    filter_options,
    players,
    selected,
    day,
    charters,
    simulated_player_scalar,
    effective_player_count,
    live_player_count,
    blockades,
    blockade_region_options,
    blockade_faction_options,
    assembly,
    bankruptcy,
    ledger,
    ledger_total,
    ledger_cap,
    ledger_full_minted,
    ledger_full_burned,
    foreign_trade,
    debug,
  } = data;

  const [tab, setTab] = useState<EconomicPanelTab>('dashboard');
  const [searchDraft, setSearchDraft] = useState(filter.search);
  const [ledgerKind, setLedgerKind] = useState<
    'all' | 'mint' | 'burn' | 'transfer'
  >('all');
  const [ledgerFund, setLedgerFund] = useState('');
  const [ledgerReason, setLedgerReason] = useState('');
  const [ledgerGroup, setLedgerGroup] = useState(false);
  const [ledgerPage, setLedgerPage] = useState(0);
  const [blockadeRegion, setBlockadeRegion] = useState('');
  const [blockadeFaction, setBlockadeFaction] = useState('');
  const LEDGER_PAGE_SIZE = 50;
  const filteredLedger = ledger.filter((e) => {
    if (ledgerKind !== 'all' && e.kind !== ledgerKind) return false;
    if (ledgerFund) {
      const needle = ledgerFund.toLowerCase();
      if (
        !e.from.toLowerCase().includes(needle) &&
        !e.to.toLowerCase().includes(needle)
      ) {
        return false;
      }
    }
    if (ledgerReason) {
      const needle = ledgerReason.toLowerCase();
      if (!(e.reason || '').toLowerCase().includes(needle)) return false;
    }
    return true;
  });
  const ledgerWindowTotals = filteredLedger.reduce(
    (acc, e) => {
      if (e.kind === 'mint') acc.minted += e.amount;
      else if (e.kind === 'burn') acc.burned += e.amount;
      return acc;
    },
    { minted: 0, burned: 0 },
  );
  type DisplayRow = LedgerEntry & { count: number };
  const displayRows: DisplayRow[] = (() => {
    if (!ledgerGroup) {
      return filteredLedger.map((e) => ({ ...e, count: 1 }));
    }
    const groups = new Map<string, DisplayRow>();
    for (const e of filteredLedger) {
      const key = `${e.kind}|${e.from}|${e.to}|${e.reason || ''}`;
      const existing = groups.get(key);
      if (existing) {
        existing.amount += e.amount;
        existing.count += 1;
      } else {
        groups.set(key, { ...e, count: 1 });
      }
    }
    return Array.from(groups.values());
  })();
  const totalPages = Math.max(
    1,
    Math.ceil(displayRows.length / LEDGER_PAGE_SIZE),
  );
  const safePage = Math.min(Math.max(0, ledgerPage), totalPages - 1);
  const pageRows = displayRows.slice(
    safePage * LEDGER_PAGE_SIZE,
    (safePage + 1) * LEDGER_PAGE_SIZE,
  );
  const setLedgerKindAndReset = (
    k: 'all' | 'mint' | 'burn' | 'transfer',
  ) => {
    setLedgerKind(k);
    setLedgerPage(0);
  };
  const setLedgerFundAndReset = (v: string) => {
    setLedgerFund(v);
    setLedgerPage(0);
  };
  const setLedgerReasonAndReset = (v: string) => {
    setLedgerReason(v);
    setLedgerPage(0);
  };
  const toggleLedgerGroup = () => {
    setLedgerGroup(!ledgerGroup);
    setLedgerPage(0);
  };
  const clearLedgerFilters = () => {
    setLedgerKind('all');
    setLedgerFund('');
    setLedgerReason('');
    setLedgerGroup(false);
    setLedgerPage(0);
  };
  const [mintAmount, setMintAmount] = useState(100);
  const [burnAmount, setBurnAmount] = useState(100);
  const [favorAmount, setFavorAmount] = useState(500);
  const [bulkAdvanceDays, setBulkAdvanceDays] = useState(1);
  const [playerAdvanceDays, setPlayerAdvanceDays] = useState(1);
  const [playerMintAmount, setPlayerMintAmount] = useState(50);
  const [simPop, setSimPop] = useState(simulated_player_scalar);
  const [assemblyTradeCap, setAssemblyTradeCap] = useState(300);
  const [assemblyDefenseCap, setAssemblyDefenseCap] = useState(500);

  const applyFilter = (overrides: Partial<Filter> = {}) => {
    act('set_filter', {
      category: overrides.category ?? filter.category,
      status: overrides.status ?? filter.status,
      search: overrides.search ?? searchDraft,
    });
  };

  const stateColor =
    bankruptcy.state === 2
      ? '#c0392b'
      : bankruptcy.state === 1
        ? '#e07b39'
        : '#5cb85c';
  const [atcLoanAmount, setAtcLoanAmount] = useState(bankruptcy.atc_loan_min);

  return (
    <Window width={1080} height={780} display_title="经济管理面板">
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <Tabs>
              {TAB_ORDER.map((t) => (
                <Tabs.Tab
                  key={t}
                  selected={tab === t}
                  onClick={() => setTab(t)}
                >
                  {TAB_LABELS[t]}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>

          {tab === 'solvency' && (
          <Stack.Item>
            <Section
              display_title={`偿付能力 - ${bankruptcy.state_label}`} title={
                <span>
                  Solvency &mdash;{' '}
                  <span style={{ color: stateColor }}>
                    {bankruptcy.state_label}
                  </span>
                </span>
              }
            >
              <Stack>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="状态">
                      <b style={{ color: stateColor }}>
                        {bankruptcy.state_label}
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="未偿债务">
                      <b style={{ color: stateColor }}>
                        {bankruptcy.debt}m
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="本回合破产次数">
                      {bankruptcy.bankruptcy_count}
                    </LabeledList.Item>
                    {bankruptcy.concession_picks > 0 && (
                      <LabeledList.Item label="剩余让步选择次数">
                        <b style={{ color: '#5cb85c' }}>
                          {bankruptcy.concession_picks}
                        </b>
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="欠款贷款底线">
                      {bankruptcy.arrears_loan_floor}m
                    </LabeledList.Item>
                    <LabeledList.Item label="接管底线">
                      {bankruptcy.operating_floor}m
                    </LabeledList.Item>
                    <LabeledList.Item label="恢复重置金额">
                      {bankruptcy.recovery_reset}m
                    </LabeledList.Item>
                    <LabeledList.Item label="接管期间自动出口比例">
                      {bankruptcy.autoexport_override}%
                    </LabeledList.Item>
                    <LabeledList.Item label="本回合 FTC 贷款次数">
                      {bankruptcy.atc_loans_drawn}
                      {!!bankruptcy.atc_loan_arrears_consumed && (
                        <span style={{ color: '#e07b39', marginLeft: '6px' }}>
                          - 已失去欠款宽限
                        </span>
                      )}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
              <Box mt={1} mb={1}>
                <Stack align="center">
                  <Stack.Item>
                    <b>ATC 紧急贷款：</b>
                  </Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      value={atcLoanAmount}
                      minValue={bankruptcy.atc_loan_min}
                      maxValue={bankruptcy.atc_loan_max}
                      step={50}
                      stepPixelSize={4}
                      width="80px"
                      onChange={(v: number) => setAtcLoanAmount(v)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      disabled={!bankruptcy.atc_loan_available}
                      tooltip={
                        bankruptcy.atc_loan_available
                          ? `向 ATC 借入 ${atcLoanAmount}m，将消耗欠款宽限。`
                          : `无法贷款：${bankruptcy.atc_loan_blocker}`
                      }
                      onClick={() =>
                        act('take_atc_loan', { amount: atcLoanAmount })
                      }
                    >
                      借款
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item color="gray" italic>
                    {bankruptcy.atc_loan_min}-{bankruptcy.atc_loan_max}m.
                    {/* 已移除截止日期提示，借款服务在整个回合持续开放。 */}
                  </Stack.Item>
                </Stack>
              </Box>
              <Stack mt={1} wrap>
                <Stack.Item>
                  <Button.Confirm
                    disabled={bankruptcy.state !== 0}
                    onClick={() => act('force_arrears')}
                  >
                    强制进入欠款状态
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    disabled={bankruptcy.state === 2}
                    onClick={() => act('force_bankruptcy')}
                  >
                    强制破产
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    disabled={bankruptcy.state === 0}
                    onClick={() => act('force_recovery')}
                  >
                    强制恢复
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
              {bankruptcy.daily_payroll.length > 0 && (
                <Box mt={1}>
                  <Box mb={1}>
                    <b>每日薪资</b> -{' '}
                    {bankruptcy.state === 2 ? (
                      <span style={{ color: '#c0392b', fontWeight: 'bold' }}>
                        已暂停（接管中）
                      </span>
                    ) : (
                      <span style={{ color: '#888' }}>
                        每次黎明共 {bankruptcy.daily_payroll_total}m
                      </span>
                    )}
                  </Box>
                  <Table>
                    <Table.Row header>
                      <Table.Cell>职业</Table.Cell>
                      <Table.Cell collapsing>薪资</Table.Cell>
                      <Table.Cell collapsing>人数</Table.Cell>
                      <Table.Cell collapsing>停薪人数</Table.Cell>
                      <Table.Cell collapsing>支出</Table.Cell>
                    </Table.Row>
                    {bankruptcy.daily_payroll.map((row) => {
                      const sequestered = bankruptcy.state === 2;
                      const allSuspended =
                        sequestered ||
                        (row.headcount > 0 &&
                          row.suspended_count >= row.headcount);
                      return (
                        <Table.Row
                          key={row.job}
                          style={{
                            opacity: allSuspended ? 0.55 : 1,
                            textDecoration: allSuspended
                              ? 'line-through'
                              : undefined,
                          }}
                        >
                          <Table.Cell>{row.display_job || row.job}</Table.Cell>
                          <Table.Cell collapsing>{row.amount}m</Table.Cell>
                          <Table.Cell collapsing>{row.headcount}</Table.Cell>
                          <Table.Cell collapsing>
                            {row.suspended_count > 0 && (
                              <span style={{ color: '#e07b39' }}>
                                {row.suspended_count}
                              </span>
                            )}
                          </Table.Cell>
                          <Table.Cell collapsing>
                            {sequestered ? (
                              <span
                                style={{
                                  color: '#c0392b',
                                  fontWeight: 'bold',
                                }}
                              >
                                已暂停
                              </span>
                            ) : (
                              `${row.row_total}m`
                            )}
                          </Table.Cell>
                        </Table.Row>
                      );
                    })}
                  </Table>
                </Box>
              )}
              {bankruptcy.suspended_charters.length > 0 && (
                <Box mt={1}>
                  <Box italic color="gray" mb={1}>
                    因接管而暂停（
                    剩余 {bankruptcy.concession_picks} 次让步
                    {bankruptcy.concession_picks === 1 ? '' : ''}选择）：
                  </Box>
                  <Stack wrap>
                    {bankruptcy.suspended_charters.map((c) => (
                      <Stack.Item key={c.id}>
                        <Button
                          disabled={bankruptcy.concession_picks <= 0}
                          tooltip={
                            bankruptcy.concession_picks <= 0
                              ? '已无剩余的让步选择次数'
                              : `恢复 ${c.name}，无需冷却`
                          }
                          onClick={() =>
                            act('concession_restore', { decree_id: c.id })
                          }
                        >
                          恢复：{c.name}
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Box>
              )}
            </Section>
          </Stack.Item>
          )}

          {tab === 'dashboard' && (
          <Stack.Item>
            <Section title={`Dashboard  -  Day ${day}`} display_title={`总览 - 第 ${day} 天`}>
              <Stack>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="王室金库">
                      {dashboard.discretionary}m
                    </LabeledList.Item>
                    <LabeledList.Item label="市民认捐">
                      {dashboard.burgher_pledge}
                    </LabeledList.Item>
                    <LabeledList.Item label="银行货币总额">
                      共 {dashboard.held_accounts} 个账户，合计 {dashboard.total_bank}m
                    </LabeledList.Item>
                    <LabeledList.Item label="平均余额">
                      {dashboard.avg_balance}m
                    </LabeledList.Item>
                    <LabeledList.Item label="余额低于 50m">
                      {dashboard.under_50m}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="已预缴人数">
                      {dashboard.in_advance}
                    </LabeledList.Item>
                    <LabeledList.Item label="欠款人数">
                      {dashboard.in_arrears}
                    </LabeledList.Item>
                    <LabeledList.Item label="债务人数">
                      {dashboard.debtor_count}
                    </LabeledList.Item>
                    <LabeledList.Item label="未结清贷款">
                      {dashboard.loans_outstanding}（风险敞口 {dashboard.loan_exposure}m）
                    </LabeledList.Item>
                    <LabeledList.Item label="预计乡村收入">
                      每日 {dashboard.expected_rural_revenue}m
                    </LabeledList.Item>
                    <LabeledList.Item label="预计薪资支出">
                      每日 {dashboard.expected_wage_outlay}m
                    </LabeledList.Item>
                    <LabeledList.Item label="年初至今乡村税收">
                      {dashboard.rural_tax_total}m
                    </LabeledList.Item>
                    <LabeledList.Item label="年初至今贵族收入">
                      {dashboard.noble_income_total}m
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          )}

          {tab === 'ledger' && (
          <Stack.Item>
            <Section
              title={`Treasury Ledger  -  ${ledger_total} entries this round`} display_title={`国库账簿 - 本回合 ${ledger_total} 条记录`}
            >
              <Stack mb={1}>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="本回合流入（铸币）">
                      <b style={{ color: '#5cb85c' }}>{ledger_full_minted}m</b>
                    </LabeledList.Item>
                    <LabeledList.Item label="本回合流出（销毁）">
                      <b style={{ color: '#e07b39' }}>{ledger_full_burned}m</b>
                    </LabeledList.Item>
                    <LabeledList.Item label="本回合净额">
                      <b>{ledger_full_minted - ledger_full_burned}m</b>
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="筛选后流入">
                      <b style={{ color: '#5cb85c' }}>
                        {ledgerWindowTotals.minted}m
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="筛选后流出">
                      <b style={{ color: '#e07b39' }}>
                        {ledgerWindowTotals.burned}m
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="筛选后净额">
                      <b>
                        {ledgerWindowTotals.minted - ledgerWindowTotals.burned}m
                      </b>
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
              <Stack align="center" wrap mb={1}>
                <Stack.Item>类型：</Stack.Item>
                {(['all', 'mint', 'burn', 'transfer'] as const).map((k) => (
                  <Stack.Item key={k}>
                    <Button
                      selected={ledgerKind === k}
                      onClick={() => setLedgerKindAndReset(k)}
                    >
                      {{ all: '全部', mint: '铸币', burn: '销毁', transfer: '转账' }[k]}
                    </Button>
                  </Stack.Item>
                ))}
                <Stack.Item ml={2}>资金：</Stack.Item>
                <Stack.Item>
                  <Input
                    value={ledgerFund}
                    onChange={(v: string) => setLedgerFundAndReset(v)}
                    placeholder="例如：王室金库"
                  />
                </Stack.Item>
                <Stack.Item ml={2}>原因：</Stack.Item>
                <Stack.Item grow>
                  <Input
                    fluid
                    value={ledgerReason}
                    onChange={(v: string) => setLedgerReasonAndReset(v)}
                    placeholder="例如：常设命令、手动导入、薪资"
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={ledgerGroup}
                    tooltip="合并类型、来源、去向和原因相同的记录。"
                    onClick={toggleLedgerGroup}
                  >
                    合并相似记录
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={clearLedgerFilters}>清除</Button>
                </Stack.Item>
              </Stack>
              {ledger_total > ledger_cap && (
                <Box italic color="gray" mb={1}>
                  共 {ledger_total} 条记录，显示最近 {ledger_cap} 条。
                  上方汇总包含整个回合。
                </Box>
              )}
              <Box height="540px" mb={1} style={{ overflowY: 'auto' }}>
                {pageRows.length === 0 ? (
                  <Box italic color="gray">
                    没有符合当前筛选条件的记录。
                  </Box>
                ) : (
                  <Table>
                    <Table.Row header>
                      <Table.Cell>时间</Table.Cell>
                      <Table.Cell>类型</Table.Cell>
                      <Table.Cell>来源</Table.Cell>
                      <Table.Cell>去向</Table.Cell>
                      <Table.Cell>金额</Table.Cell>
                      {ledgerGroup && <Table.Cell>次数</Table.Cell>}
                      <Table.Cell>原因</Table.Cell>
                    </Table.Row>
                    {pageRows.map((e, idx) => (
                      <Table.Row key={safePage * LEDGER_PAGE_SIZE + idx}>
                        <Table.Cell>{e.time_label}</Table.Cell>
                        <Table.Cell>
                          <span
                            style={{
                              color:
                                e.kind === 'mint'
                                  ? '#5cb85c'
                                  : e.kind === 'burn'
                                    ? '#e07b39'
                                    : undefined,
                            }}
                          >
                            {{ mint: '铸币', burn: '销毁', transfer: '转账' }[e.kind] || e.kind}
                          </span>
                        </Table.Cell>
                        <Table.Cell>{e.from}</Table.Cell>
                        <Table.Cell>{e.to}</Table.Cell>
                        <Table.Cell>
                          {e.amount}
                          {e.currency ? e.currency.charAt(0) : ''}
                        </Table.Cell>
                        {ledgerGroup && (
                          <Table.Cell>
                            {e.count > 1 ? `×${e.count}` : ''}
                          </Table.Cell>
                        )}
                        <Table.Cell>{e.reason || ''}</Table.Cell>
                      </Table.Row>
                    ))}
                  </Table>
                )}
              </Box>
              {pageRows.length > 0 && (
                <>
                  <Stack align="center" mt={1}>
                    <Stack.Item grow>
                      <Box italic color="gray">
                        第 {safePage + 1} / {totalPages} 页 -{' '}
                        {displayRows.length}{' '}
                        {ledgerGroup ? '组' : '行'}
                        {ledgerGroup
                          ? `（合并自 ${filteredLedger.length} 条记录）`
                          : ''}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="angle-double-left"
                        disabled={safePage === 0}
                        onClick={() => setLedgerPage(0)}
                        tooltip="首页"
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="chevron-left"
                        disabled={safePage === 0}
                        onClick={() => setLedgerPage(safePage - 1)}
                      >
                        上一页
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="chevron-right"
                        disabled={safePage >= totalPages - 1}
                        onClick={() => setLedgerPage(safePage + 1)}
                      >
                        下一页
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="angle-double-right"
                        disabled={safePage >= totalPages - 1}
                        onClick={() => setLedgerPage(totalPages - 1)}
                        tooltip="末页"
                      />
                    </Stack.Item>
                  </Stack>
                </>
              )}
            </Section>
          </Stack.Item>

          )}

          {tab === 'debug' && (
          <Stack.Item>
            <DebugView debug={debug} act={act} />
          </Stack.Item>
          )}

          {tab === 'solvency' && (
          <Stack.Item>
            <Section title="Tick Actions" display_title="结算操作">
              <Stack wrap>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('advance_day')}>
                    推进一天
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_rural_tick')}>
                    执行乡村结算
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_poll_tick')}>
                    执行人头税结算
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_loan_tick')}>
                    执行贷款结算
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_pledge_tick')}>
                    执行认捐结算
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_estate_incomes')}>
                    分配地产收入
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_payroll')}>
                    发放薪资
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_economy_tick')}>
                    执行经济结算
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_brassface_tick')}>
                    执行黄铜面结算
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          )}

          {tab === 'solvency' && (
          <Stack.Item>
            <Section title="Simulated Population (economy pop scaling)" display_title="模拟人口（经济人口缩放）">
              <Box mb={1} color="label">
                实时活跃玩家：<b>{live_player_count}</b>。
                经济人口缩放使用的有效人数：{' '}
                <b>{effective_player_count}</b>
                {simulated_player_scalar > 0 ? '（管理员覆盖）' : '（实时）'}。
                设为 0 使用实时人数。
              </Box>
              <Stack align="center">
                <Stack.Item>模拟人数：</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={1}
                    minValue={0}
                    maxValue={500}
                    value={simPop}
                    onChange={(v: number) => setSimPop(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() =>
                      act('set_simulated_population', { amount: simPop })
                    }
                  >
                    应用
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() => {
                      setSimPop(0);
                      act('set_simulated_population', { amount: 0 });
                    }}
                  >
                    清除覆盖
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          )}

          {tab === 'internal' && (
          <Stack.Item>
            <Section title={`Blockades (${blockades.length} active)`} display_title={`封锁（${blockades.length} 处生效）`}>
              <Stack wrap mb={1} align="center">
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_blockade_roll')}>
                    执行封锁判定
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    width="11em"
                    placeholder="地区……"
                    selected={blockadeRegion}
                    options={blockade_region_options.map((o) => ({
                      value: o.id,
                      displayText: o.blockaded ? `${o.name}（已封锁）` : o.name,
                    }))}
                    onSelected={(value) => setBlockadeRegion(value)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Dropdown
                    width="11em"
                    placeholder="势力（自动）……"
                    selected={blockadeFaction}
                    options={[
                      { value: '', displayText: '自动（按地区）' },
                      ...blockade_faction_options.map((o) => ({
                        value: o.id,
                        displayText: o.name,
                      })),
                    ]}
                    onSelected={(value) => setBlockadeFaction(value)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    disabled={!blockadeRegion}
                    onClick={() =>
                      act('place_blockade', {
                        region_id: blockadeRegion,
                        faction_id: blockadeFaction || null,
                      })
                    }
                  >
                    封锁地区
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
              {blockades.length === 0 ? (
                <Box italic color="gray">
                  当前没有封锁，商路畅通。
                </Box>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell>地区</Table.Cell>
                    <Table.Cell>威胁</Table.Cell>
                    <Table.Cell>势力</Table.Cell>
                    <Table.Cell>天数</Table.Cell>
                    <Table.Cell>有文书？</Table.Cell>
                    <Table.Cell>&nbsp;</Table.Cell>
                  </Table.Row>
                  {blockades.map((b) => (
                    <Table.Row key={b.ref}>
                      <Table.Cell>{b.region_name}</Table.Cell>
                      <Table.Cell>{b.threat_region}</Table.Cell>
                      <Table.Cell>{b.faction_name}</Table.Cell>
                      <Table.Cell>第 {b.day_started} 天</Table.Cell>
                      <Table.Cell>{b.has_active_scroll ? '是' : '-'}</Table.Cell>
                      <Table.Cell>
                        <Button.Confirm
                          color="bad"
                          onClick={() =>
                            act('clear_blockade', { ref: b.ref })
                          }
                        >
                          强制清除
                        </Button.Confirm>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>
          )}

          {tab === 'foreign' && (
          <Stack.Item>
            <ForeignTradeView foreignTrade={foreign_trade} act={act} />
          </Stack.Item>
          )}

          {tab === 'assembly' && (
          <Stack.Item>
            <Section
              title={`City Assembly  -  Session #${assembly.session_number || 0}`} display_title={`市民议会 - 第 ${assembly.session_number || 0} 届会期`}
            >
              <Stack>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="市政长老">
                      {assembly.alderman_name || '（空缺）'}
                    </LabeledList.Item>
                    <LabeledList.Item label="贸易授权">
                      {assembly.trade_remaining ?? 0}m / {assembly.trade_cap ?? 0}m
                    </LabeledList.Item>
                    <LabeledList.Item label="防务授权">
                      {assembly.defense_remaining ?? 0}p / {assembly.defense_cap ?? 0}p
                    </LabeledList.Item>
                    <LabeledList.Item label="受谴责人数">
                      {assembly.censured_count ?? 0}
                    </LabeledList.Item>
                    <LabeledList.Item label="已结算会期">
                      {assembly.history_count ?? 0}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <Stack vertical>
                    <Stack.Item>
                      <Button.Confirm
                        onClick={() => act('assembly_resolve')}
                      >
                        立即结算（静默）
                      </Button.Confirm>
                      <Button.Confirm
                        ml={1}
                        onClick={() => act('assembly_resolve_skip_quorum')}
                      >
                        结算并跳过法定人数
                      </Button.Confirm>
                      <Button.Confirm
                        ml={1}
                        onClick={() => act('assembly_divine_complete')}
                      >
                        神明干预
                      </Button.Confirm>
                    </Stack.Item>
                    <Stack.Item>
                      <Button onClick={() => act('assembly_refresh_warrant')}>
                        刷新授权
                      </Button>
                      <Button.Confirm
                        ml={1}
                        color="bad"
                        onClick={() => act('assembly_drain_warrant')}
                      >
                        耗尽授权
                      </Button.Confirm>
                    </Stack.Item>
                    {assembly.alderman_ckey ? (
                      <Stack.Item>
                        <Button.Confirm
                          color="bad"
                          onClick={() => act('assembly_demote_alderman')}
                        >
                          罢免市政长老
                        </Button.Confirm>
                      </Stack.Item>
                    ) : null}
                  </Stack>
                </Stack.Item>
              </Stack>
              <Stack align="center" mt={1}>
                <Stack.Item>贸易上限：</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={50}
                    minValue={0}
                    maxValue={10000}
                    value={assemblyTradeCap}
                    onChange={(v: number) => setAssemblyTradeCap(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() =>
                      act('assembly_set_trade_cap', { amount: assemblyTradeCap })
                    }
                  >
                    设置
                  </Button>
                </Stack.Item>
                <Stack.Item>防务上限：</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={50}
                    minValue={0}
                    maxValue={10000}
                    value={assemblyDefenseCap}
                    onChange={(v: number) => setAssemblyDefenseCap(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() =>
                      act('assembly_set_defense_cap', { amount: assemblyDefenseCap })
                    }
                  >
                    设置
                  </Button>
                </Stack.Item>
              </Stack>
              <Box italic color="gray" mt={1}>
                要任命或谴责某位玩家，请在下方玩家列表中选择，
                然后使用详情面板中的市政长老按钮。
              </Box>
            </Section>
          </Stack.Item>

          )}

          {tab === 'dashboard' && (
          <Stack.Item>
            <Section title="Crown's Purse Mint / Burn" display_title="王室金库铸币/销毁">
              <Stack align="center">
                <Stack.Item>铸币：</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={10}
                    minValue={1}
                    maxValue={100000}
                    value={mintAmount}
                    onChange={(v: number) => setMintAmount(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() => act('mint_discretionary', { amount: mintAmount })}
                  >
                    铸币
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item ml={3}>销毁：</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={10}
                    minValue={1}
                    maxValue={100000}
                    value={burnAmount}
                    onChange={(v: number) => setBurnAmount(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() => act('burn_discretionary', { amount: burnAmount })}
                  >
                    销毁
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          )}

          {tab === 'dashboard' && (
          <Stack.Item>
            <Section title="Merchant Favor (testing)" display_title="商人好感（调试）">
              <Stack align="center">
                <Stack.Item>数量：</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={100}
                    minValue={1}
                    maxValue={100000}
                    value={favorAmount}
                    onChange={(v: number) => setFavorAmount(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    color="good"
                    onClick={() => act('adjust_merchant_favor', { amount: favorAmount })}
                  >
                    授予
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    color="bad"
                    onClick={() => act('adjust_merchant_favor', { amount: -favorAmount })}
                  >
                    撤销
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          )}

          {tab === 'charters' && (
          <Stack.Item>
            <Section title="Charters" display_title="特许状">
              <Stack vertical>
                {charters.map((c) => (
                  <Stack.Item key={c.id}>
                    <Button.Confirm
                      fluid
                      color={c.active ? 'good' : 'bad'}
                      onClick={() => act('toggle_charter', { decree_id: c.id })}
                    >
                      {c.name}: {c.active ? '生效' : '暂停'}
                    </Button.Confirm>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>

          )}

          {tab === 'players' && (
          <Stack.Item>
            <Section title="Filter" display_title="筛选">
              <Stack align="center" wrap>
                <Stack.Item>类别：</Stack.Item>
                {filter_options.categories.map((cat) => (
                  <Stack.Item key={cat}>
                    <Button
                      selected={filter.category === cat}
                      onClick={() => applyFilter({ category: cat })}
                    >
                      {CATEGORY_LABELS[cat] || cat}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
              <Stack align="center" mt={1} wrap>
                <Stack.Item>状态：</Stack.Item>
                {filter_options.statuses.map((s) => (
                  <Stack.Item key={s}>
                    <Button
                      selected={filter.status === s}
                      onClick={() => applyFilter({ status: s })}
                    >
                      {STATUS_LABELS[s] || s}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
              <Stack align="center" mt={1}>
                <Stack.Item>搜索：</Stack.Item>
                <Stack.Item grow>
                  <Input
                    fluid
                    value={searchDraft}
                    onChange={(v: string) => setSearchDraft(v)}
                    placeholder="按姓名中的文字搜索……"
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => applyFilter({ search: searchDraft })}>
                    应用
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() => {
                      setSearchDraft('');
                      act('set_filter', { category: 'all', status: 'all', search: '' });
                    }}
                  >
                    清除
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          )}

          {tab === 'players' && (
          <Stack.Item>
            <Section title={`Players (${players.length} matching filter)`} display_title={`玩家（${players.length} 人符合筛选）`}>
              {players.length === 0 ? (
                <Box italic color="gray">
                  没有符合当前筛选条件的玩家。请放宽条件，或在上方
                  选择其他类别或状态。
                </Box>
              ) : (
                <>
                  <Table>
                    <Table.Row header>
                      <Table.Cell>姓名</Table.Cell>
                      <Table.Cell>职业</Table.Cell>
                      <Table.Cell>类别</Table.Cell>
                      <Table.Cell>税率</Table.Cell>
                      <Table.Cell>余额</Table.Cell>
                      <Table.Cell>预缴</Table.Cell>
                      <Table.Cell>欠款</Table.Cell>
                      <Table.Cell>逾期天数</Table.Cell>
                      <Table.Cell>标记</Table.Cell>
                      <Table.Cell>&nbsp;</Table.Cell>
                    </Table.Row>
                    {players.map((p) => {
                      const isSelected = selected && selected.ref === p.ref;
                      return (
                      <Table.Row key={p.ref}>
                        <Table.Cell>
                          {isSelected ? <b>{'> '}{p.name}</b> : p.name}
                        </Table.Cell>
                        <Table.Cell>{p.display_job || p.job}</Table.Cell>
                        <Table.Cell>{p.category_name}</Table.Cell>
                        <Table.Cell>
                          {p.rate}m{p.raw_rate !== p.rate ? `（原始税率 ${p.raw_rate}m）` : ''}
                        </Table.Cell>
                        <Table.Cell>{p.balance}m</Table.Cell>
                        <Table.Cell>{p.advance}</Table.Cell>
                        <Table.Cell>{p.owed}m</Table.Cell>
                        <Table.Cell>{p.overdue}</Table.Cell>
                        <Table.Cell>
                          {p.exempt ? '免税 ' : ''}
                          {p.is_debtor ? '债务 ' : ''}
                          {p.has_loan ? '贷款 ' : ''}
                        </Table.Cell>
                        <Table.Cell>
                          <Button onClick={() => act('select', { ref: p.ref })}>
                            选择
                          </Button>
                        </Table.Cell>
                      </Table.Row>
                      );
                    })}
                  </Table>

                  <Stack mt={1} wrap>
                    <Stack.Item>
                      <Button.Confirm
                        color="bad"
                        onClick={() => act('bulk_clear_debt')}
                      >
                        批量清除筛选出的 {players.length} 人的欠税
                      </Button.Confirm>
                    </Stack.Item>
                    <Stack.Item>
                      <NumberInput
                        step={1}
                        minValue={1}
                        maxValue={30}
                        value={bulkAdvanceDays}
                        onChange={(v: number) => setBulkAdvanceDays(v)}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button.Confirm
                        onClick={() =>
                          act('bulk_add_advance', { days: bulkAdvanceDays })
                        }
                      >
                        为筛选出的所有人增加 {bulkAdvanceDays} 天预缴
                      </Button.Confirm>
                    </Stack.Item>
                  </Stack>
                </>
              )}
            </Section>
          </Stack.Item>
          )}

          {tab === 'players' && selected && (
            <Stack.Item>
              <Section
                title={`Detail: ${selected.name} (${selected.job})`} display_title={`详情：${selected.name}（${selected.display_job || selected.job}）`}
                buttons={
                  <Button onClick={() => act('clear_selection')}>关闭</Button>
                }
              >
                <LabeledList>
                  <LabeledList.Item label="类别">
                    {selected.category_name}
                  </LabeledList.Item>
                  <LabeledList.Item label="实际税率">
                    每日 {selected.rate}m
                    {selected.raw_rate !== selected.rate
                      ? `（原始税率 ${selected.raw_rate}m，受特许状或上限调整）`
                      : ''}
                  </LabeledList.Item>
                  <LabeledList.Item label="特许状豁免">
                    {selected.exempt ? '是' : '否'}
                  </LabeledList.Item>
                  <LabeledList.Item label="账户余额">
                    {selected.balance}m
                  </LabeledList.Item>
                  <LabeledList.Item label="随身货币">
                    {selected.on_person}m
                  </LabeledList.Item>
                  <LabeledList.Item label="预缴天数">
                    {selected.advance}
                  </LabeledList.Item>
                  <LabeledList.Item label="欠税">
                    {selected.owed}m，逾期 {selected.overdue} 天
                  </LabeledList.Item>
                  <LabeledList.Item label="债务人标记">
                    {selected.is_debtor ? '是' : '否'}
                  </LabeledList.Item>
                  <LabeledList.Item label="当前贷款">
                    {selected.has_loan ? '是' : '否'}
                  </LabeledList.Item>
                </LabeledList>

                <Stack mt={1} wrap>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_clear_debt', { ref: selected.ref })
                      }
                    >
                      清除人头税欠款
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_toggle_debtor', { ref: selected.ref })
                      }
                    >
                      切换债务人特性（TRAIT_DEBTOR）
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} wrap>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('assembly_promote_alderman', { ref: selected.ref })
                      }
                    >
                      任命市政长老
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      color="bad"
                      onClick={() =>
                        act('assembly_censure', { ref: selected.ref })
                      }
                    >
                      谴责
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('assembly_clear_censure', { ref: selected.ref })
                      }
                    >
                      撤销谴责
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} align="center">
                  <Stack.Item>预缴天数：</Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      step={1}
                      minValue={1}
                      maxValue={999}
                      value={playerAdvanceDays}
                      onChange={(v: number) => setPlayerAdvanceDays(v)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_add_advance', {
                          ref: selected.ref,
                          days: playerAdvanceDays,
                        })
                      }
                    >
                      增加
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_remove_advance', {
                          ref: selected.ref,
                          days: playerAdvanceDays,
                        })
                      }
                    >
                      减少
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} align="center">
                  <Stack.Item>账户铸币/销毁：</Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      step={10}
                      minValue={1}
                      maxValue={10000}
                      value={playerMintAmount}
                      onChange={(v: number) => setPlayerMintAmount(v)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_mint_account', {
                          ref: selected.ref,
                          amount: playerMintAmount,
                        })
                      }
                    >
                      铸币
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      color="bad"
                      onClick={() =>
                        act('player_burn_account', {
                          ref: selected.ref,
                          amount: playerMintAmount,
                        })
                      }
                    >
                      销毁
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} align="center">
                  <Stack.Item>负债缺陷：</Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_fire_indebted', { ref: selected.ref })
                      }
                      tooltip="立即对所选玩家执行赡养费结算，需要负债缺陷。"
                    >
                      执行负债结算
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

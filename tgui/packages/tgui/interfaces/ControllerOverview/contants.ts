type SortType = {
  label: string;
  propName: string;
  inDeciseconds: boolean;
};

export const SORTING_TYPES: readonly SortType[] = [
  {
    label: '名称字母顺序',
    propName: 'name',
    inDeciseconds: false,
  },
  {
    label: '耗时',
    propName: 'cost_ms',
    inDeciseconds: true,
  },
  {
    label: '初始化顺序',
    propName: 'init_order',
    inDeciseconds: false,
  },
  {
    label: '上次执行',
    propName: 'last_fire',
    inDeciseconds: false,
  },
  {
    label: '下次执行',
    propName: 'next_fire',
    inDeciseconds: false,
  },
  {
    label: '当前帧占用',
    propName: 'tick_usage',
    inDeciseconds: true,
  },
  {
    label: '平均每帧占用',
    propName: 'usage_per_tick',
    inDeciseconds: true,
  },
  {
    label: '子系统超时占用',
    propName: 'overtime',
    inDeciseconds: true,
  },
];

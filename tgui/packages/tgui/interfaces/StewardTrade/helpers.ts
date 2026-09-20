// Display order and human labels for the TRADE_CATEGORY_* strings emitted by DM.

export const CATEGORY_ORDER: string[] = [
  'grain',
  'vegetable',
  'fruit',
  'animal',
  'seafood',
  'cloth',
  'artisan',
  'basic_mineral',
  'rare_metal',
  'precious_metal',
  'intermediary',
  'gem_common',
  'gem_rare',
  'gem_legendary',
  'Equipment',
  'misc',
];

export const CATEGORY_LABEL: Record<string, string> = {
  grain: '谷物',
  vegetable: '蔬菜',
  fruit: '水果',
  animal: '畜产品',
  seafood: '海产',
  cloth: '纺织品',
  artisan: '工艺原料',
  basic_mineral: '基础矿物',
  rare_metal: '稀有金属',
  precious_metal: '贵金属',
  intermediary: '半成品',
  gem_common: '普通宝石',
  gem_rare: '稀有宝石',
  gem_legendary: '传奇宝石',
  Equipment: '装备',
  misc: '杂项',
};

/// Group an array of rows by their category (looked up via good_catalog).
/// Returns an ordered list of { category, label, rows } preserving CATEGORY_ORDER.
export function groupByCategory<T extends { good_id: string }>(
  rows: T[],
  good_catalog: Record<string, { category: string }>,
): { category: string; label: string; rows: T[] }[] {
  const byCat: Record<string, T[]> = {};
  for (const row of rows) {
    const cat = good_catalog[row.good_id]?.category ?? 'misc';
    if (!byCat[cat]) byCat[cat] = [];
    byCat[cat].push(row);
  }
  const ordered = [
    ...CATEGORY_ORDER.filter((c) => byCat[c]?.length),
    ...Object.keys(byCat).filter((c) => !CATEGORY_ORDER.includes(c)),
  ];
  return ordered.map((category) => ({
    category,
    label: CATEGORY_LABEL[category] ?? category,
    rows: byCat[category],
  }));
}

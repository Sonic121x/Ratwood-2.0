const ARCHIVE_LABELS: Record<string, string> = {
  book: '书籍',
  painting: '画作',
  All: '全部',
  Fiction: '小说',
  'Non-fiction': '纪实',
  Religion: '宗教',
  Adult: '成人',
  Reference: '参考',
  Misc: '其他',
  Search: '搜索',
};

export const getArchiveDisplay = (value?: string): string =>
  ARCHIVE_LABELS[value ?? ''] ?? value ?? '';

export const getArchiveOptions = (categories: string[]) =>
  categories.map((value) => ({ value, displayText: getArchiveDisplay(value) }));

export const getArchiveHeading = (noun: string, count: number): string =>
  `已归档${noun}（${count}）`;

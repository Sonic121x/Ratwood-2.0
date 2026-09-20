import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
} from '../common/parchment';
import type { Data, LedgerEntry } from './types';

const signFor = (entry: LedgerEntry): { color: string; prefix: string } => {
  switch (entry.kind) {
    case 'mint':
      return { color: SEAL_GREEN, prefix: '+' };
    case 'burn':
      return { color: SEAL_RED, prefix: '-' };
    default:
      return { color: INK, prefix: '' };
  }
};
const FUND_LABEL: Record<string, string> = { "Crown's Purse": '王室金库', 'Burgher Pledge': '市民认捐', 'Church Fund': '教会基金', 'Merchant Fund': '商人基金', 'Bathhouse Fund': '浴场基金', 'Tavern Earnings': '酒馆收入', void: '无' };
const partyFor = (entry: LedgerEntry): string => {
  switch (entry.kind) {
    case 'mint':
      return FUND_LABEL[entry.to] || entry.to;
    case 'burn':
      return FUND_LABEL[entry.from] || entry.from;
    case 'transfer':
      return `${FUND_LABEL[entry.from] || entry.from} → ${FUND_LABEL[entry.to] || entry.to}`;
    default:
      return `${FUND_LABEL[entry.from] || entry.from} → ${FUND_LABEL[entry.to] || entry.to}`;
  }
};

const LedgerRow = (props: { entry: LedgerEntry }) => {
  const { entry } = props;
  const { color, prefix } = signFor(entry);
  return (
    <div style={denseRowStyle}>
      <div style={{ ...ellipsisCellStyle, color: INK }}>{partyFor(entry)}</div>
      <div style={{ ...ellipsisCellStyle, flex: 2, color: INK_SOFT }}>
        {entry.reason}
      </div>
      <div
        style={{
          flexShrink: 0,
          color,
          fontWeight: 'bold',
          whiteSpace: 'nowrap',
        }}
      >
        {prefix}
        {entry.amount}m
      </div>
    </div>
  );
};

export const LedgerView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const page = props.data.ledger_page;

  const [draft, setDraft] = useState('');
  const [touched, setTouched] = useState(false);

  useEffect(() => {
    if (!touched) return;
    const id = setTimeout(() => {
      act('ledger_filter', { filter: draft });
    }, 250);
    return () => clearTimeout(id);
  }, [draft, touched, act]);

  const onSearch = (value: string) => {
    setTouched(true);
    setDraft(value);
  };

  if (!page) {
    return (
      <div style={{ color: INK_SOFT, fontStyle: 'italic', padding: '12px 0' }}>
        正在打开台账...
      </div>
    );
  }

  const pageNum = page.page;
  const hasMore = !!page.has_more;
  const canPrev = pageNum > 1;

  return (
    <div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          margin: '8px 0',
        }}
      >
        <span
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK_SOFT,
          }}
        >
          搜索:
        </span>
        <Input
          value={draft}
          onChange={onSearch}
          placeholder="账户名称或事由..."
          width="240px"
        />
        {!!draft && (
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() => onSearch('')}
          >
            清除
          </button>
        )}
        <button
          type="button"
          style={inkButtonStyle({ color: SEAL_AMBER })}
          onClick={() => act('ledger_refresh')}
        >
          刷新
        </button>
      </div>

      <div style={sectionHeaderStyle}>
        国库台账 &mdash; 最新记录在前
      </div>

      <div style={{ height: '540px', overflowY: 'auto' }}>
        {page.entries.length === 0 ? (
          <div
            style={{ color: INK_SOFT, fontStyle: 'italic', padding: '8px 0' }}
          >
            {page.filtered
              ? '没有符合搜索条件的账目.'
              : '台账为空.'}
          </div>
        ) : (
          page.entries.map((entry, i) => <LedgerRow key={i} entry={entry} />)
        )}
      </div>

      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          marginTop: '10px',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({ disabled: !canPrev })}
          disabled={!canPrev}
          onClick={() => canPrev && act('ledger_page', { page: pageNum - 1 })}
        >
          &lsaquo; 较新
        </button>
        <span style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
          第 {pageNum} 页 &middot; 已显示 {page.shown} 条
        </span>
        <button
          type="button"
          style={inkButtonStyle({ disabled: !hasMore })}
          disabled={!hasMore}
          onClick={() => hasMore && act('ledger_page', { page: pageNum + 1 })}
        >
          较旧 &rsaquo;
        </button>
      </div>
    </div>
  );
};

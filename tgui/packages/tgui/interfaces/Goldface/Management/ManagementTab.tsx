import { useState } from 'react';

import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  pageStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
} from '../../common/parchment';
import type {
  ActFn,
  CatalogData,
  FavorData,
  FavorLedgerEntry,
  HarborData,
} from '../types';

const labelStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: SEAL_AMBER,
  letterSpacing: '0.04em',
};

const valueStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: INK,
};

const noteStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  fontStyle: 'italic' as const,
  color: INK_SOFT,
  lineHeight: 1.4,
};

const LevyControl = (props: { current: number; cap: number; act: ActFn }) => {
  const { current, cap, act } = props;
  const [draft, setDraft] = useState<string>(String(current));
  const numeric = Number(draft);
  const valid = !Number.isNaN(numeric) && numeric >= 0 && numeric <= cap;
  const dirty = valid && numeric !== current;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>商人征缴</div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        你从经由公共引航机与船只履约箱售出的每笔出口中抽取的分成.
        王室按现行出口税率将你的分成作为收入征税.
        上限为 {cap}%.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
          paddingBottom: '6px',
        }}
      >
        <span style={labelStyle}>当前</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>{current}%</span>
        <span style={{ flex: 1 }} />
        <span style={labelStyle}>设为</span>
        <input
          type="number"
          min={0}
          max={cap}
          step={1}
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          style={{
            width: '64px',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            background: 'var(--p-button-bg)',
            border: `1px solid ${INK_FAINT}`,
            borderRadius: '2px',
            padding: '2px 6px',
          }}
        />
        <button
          type="button"
          disabled={!dirty}
          style={inkButtonStyle({ disabled: !dirty })}
          onClick={() => {
            if (!dirty) return;
            act('set_levy', { percent: numeric });
          }}
        >
          设定
        </button>
      </div>
    </div>
  );
};

const GnomeMarginControl = (props: { current: number; act: ActFn }) => {
  const { current, act } = props;
  const [draft, setDraft] = useState<string>(String(current));
  const numeric = Number(draft);
  const valid = !Number.isNaN(numeric) && numeric >= 0 && numeric <= 100;
  const dirty = valid && numeric !== current;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>银面加价</div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        公司侏儒将每个银面摊位的价格定为基础成本加此加价.
        加价流入商人基金. 费率越高, 每笔销售的收益越多,
        却会把顾客赶走; 费率越低则能赢得销量.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
          paddingBottom: '6px',
        }}
      >
        <span style={labelStyle}>当前</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>{current}%</span>
        <span style={{ flex: 1 }} />
        <span style={labelStyle}>设为</span>
        <input
          type="number"
          min={0}
          max={100}
          step={1}
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          style={{
            width: '64px',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            background: 'var(--p-button-bg)',
            border: `1px solid ${INK_FAINT}`,
            borderRadius: '2px',
            padding: '2px 6px',
          }}
        />
        <button
          type="button"
          disabled={!dirty}
          style={inkButtonStyle({ disabled: !dirty })}
          onClick={() => {
            if (!dirty) return;
            act('set_gnome_margin', { percent: numeric });
          }}
        >
          设定
        </button>
      </div>
    </div>
  );
};

const outcomeStyles: Record<
  FavorLedgerEntry['outcome'],
  { label: string; color: string }
> = {
  honored: { label: '受敬', color: SEAL_GREEN },
  partial: { label: '部分', color: SEAL_AMBER },
  dishonored: { label: '失敬', color: SEAL_RED },
};

const TriumphLever = (props: { favor: FavorData }) => {
  const { favor } = props;
  const { high_water, triumph_bonus, triumph_cap, bracket_next, brackets } =
    favor;
  const atCap = triumph_bonus >= triumph_cap || bracket_next === 0;
  return (
    <div style={{ marginBottom: '10px' }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={labelStyle}>凯旋加成</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>
          +{triumph_bonus}
          <span style={{ color: INK_SOFT, fontWeight: 'normal' }}>
            {' '}
            / +{triumph_cap}
          </span>
        </span>
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: `repeat(${brackets.length}, 1fr)`,
          gap: '2px',
        }}
      >
        {brackets.map((threshold, idx) => {
          const prev = idx === 0 ? 0 : brackets[idx - 1];
          const earned = high_water >= threshold;
          const active = !earned && high_water >= prev;
          const span = Math.max(1, threshold - prev);
          const fill = earned
            ? 1
            : active
              ? Math.min(1, Math.max(0, (high_water - prev) / span))
              : 0;
          return (
            <div
              key={idx}
              title={`达到 ${threshold}m 贸易额时 +${idx + 1} 凯旋`}
              style={{
                position: 'relative',
                height: '12px',
                background: 'var(--p-card-bg)',
                border: `1px solid ${earned ? SEAL_GREEN : PARCHMENT_SHADOW}`,
                borderRadius: '2px',
                overflow: 'hidden',
              }}
            >
              <div
                style={{
                  width: `${fill * 100}%`,
                  height: '100%',
                  background: earned ? SEAL_GREEN : SEAL_AMBER,
                  transition: 'width 200ms ease',
                }}
              />
            </div>
          );
        })}
      </div>
      <div
        style={{
          ...noteStyle,
          display: 'flex',
          justifyContent: 'space-between',
          marginTop: '3px',
          fontStyle: 'normal',
        }}
      >
        <span>已赚得 {high_water}m 贸易额</span>
        <span>
          {atCap
            ? '加成已达上限'
            : `下一级 +${triumph_bonus + 1} 需 ${bracket_next}m`}
        </span>
      </div>
    </div>
  );
};

const LedgerRow = (props: { entry: FavorLedgerEntry }) => {
  const { entry } = props;
  const style = outcomeStyles[entry.outcome] || outcomeStyles.dishonored;
  const sign = entry.awarded >= 0 ? '+' : '';
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '70px minmax(0, 1fr) 70px',
        columnGap: '8px',
        alignItems: 'baseline',
        padding: '2px 0',
        fontSize: FONT_BODY,
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
      }}
    >
      <span style={{ color: style.color, fontWeight: 'bold' }}>
        {style.label}
      </span>
      <span
        style={{
          color: INK,
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}
      >
        {entry.ship_name}{' '}
        <span style={{ color: INK_SOFT }}>- {entry.realm_label}</span>
        {entry.refunded_hail ? (
          <span style={{ color: SEAL_GREEN }}> (已退还招呼)</span>
        ) : null}
      </span>
      <span
        style={{
          textAlign: 'right',
          color: entry.awarded >= 0 ? SEAL_GREEN : SEAL_RED,
          fontWeight: 'bold',
        }}
      >
        {sign}
        {entry.awarded}m
      </span>
    </div>
  );
};

const SinkButton = (props: {
  label: string;
  flavor: string;
  cost: number;
  current: number;
  done: boolean;
  doneLabel: string;
  action: string;
  params?: Record<string, unknown>;
  act: ActFn;
}) => {
  const { label, flavor, cost, current, done, doneLabel, action, params, act } =
    props;
  const canAfford = current >= cost;
  const disabled = done || !canAfford;
  return (
    <div
      style={{
        padding: '8px 10px',
        border: `1px solid ${INK_FAINT}`,
        background: done ? 'rgba(180,200,160,0.18)' : 'var(--p-card-bg)',
        borderRadius: '2px',
        marginTop: '6px',
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={{ ...labelStyle, color: INK, fontSize: FONT_BODY }}>
          {label}
        </span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>
          {done ? (
            <span style={{ color: SEAL_GREEN }}>{doneLabel}</span>
          ) : (
            <>
              {cost}m
              <span
                style={{
                  color: canAfford ? INK_SOFT : SEAL_RED,
                  fontWeight: 'normal',
                }}
              >
                {' '}
                ({current}m 在手)
              </span>
            </>
          )}
        </span>
      </div>
      <div style={{ ...noteStyle, marginBottom: '6px' }}>{flavor}</div>
      <button
        type="button"
        disabled={disabled}
        style={inkButtonStyle({ disabled })}
        onClick={() => {
          if (disabled) return;
          act(action, params);
        }}
      >
        {done
          ? '已生效'
          : canAfford
            ? '花费恩惠'
            : '恩惠不足'}
      </button>
    </div>
  );
};

const FavorCard = (props: {
  favor: FavorData;
  catalogs: CatalogData[];
  act: ActFn;
}) => {
  const { favor, catalogs, act } = props;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>你在公司的声望</div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        通过将船只满意送行, 或经由银面、金面与引航机进行的被动
        交易(按 0.5 倍价值)赚取. 用于花费以换取公司恩惠.
        所达贸易额也决定商人及店伙计的回合结束凯旋加成 -
        花费恩惠不会削减该加成.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '8px',
        }}
      >
        <span style={labelStyle}>持有恩惠</span>
        <span style={{ ...valueStyle, fontWeight: 'bold', fontSize: '16px' }}>
          {favor.current}m
        </span>
      </div>
      <TriumphLever favor={favor} />
      <div
        style={{
          ...labelStyle,
          marginTop: '10px',
          marginBottom: '4px',
          color: INK,
          fontSize: FONT_BODY,
        }}
      >
        本周恩惠来源
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr auto',
          rowGap: '3px',
          columnGap: '12px',
          fontSize: FONT_BODY,
          marginBottom: '6px',
        }}
      >
        <span style={{ color: INK }}>船只送行</span>
        <span
          style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}
        >
          +{favor.from_sendoffs}m
        </span>
        <span style={{ color: INK }}>引航机交易</span>
        <span
          style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}
        >
          +{favor.from_navigator}m
        </span>
        <span style={{ color: INK }}>金面进口</span>
        <span
          style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}
        >
          +{favor.from_goldface}m
        </span>
        <span style={{ color: INK }}>银面进口</span>
        <span
          style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}
        >
          +{favor.from_silverface}m
        </span>
        {favor.penalties > 0 && (
          <>
            <span style={{ color: INK }}>失敬罚款</span>
            <span
              style={{
                color: SEAL_RED,
                fontWeight: 'bold',
                textAlign: 'right',
              }}
            >
              -{favor.penalties}m
            </span>
          </>
        )}
        <span style={{ color: INK_SOFT }}>生涯峰值</span>
        <span
          style={{ color: SEAL_AMBER, fontWeight: 'bold', textAlign: 'right' }}
        >
          {favor.high_water}m
        </span>
      </div>
      <div
        style={{
          ...labelStyle,
          marginTop: '10px',
          marginBottom: '4px',
          color: INK,
          fontSize: FONT_BODY,
        }}
      >
        近期送行
      </div>
      {favor.ledger.length === 0 ? (
        <div style={{ ...noteStyle, padding: '4px 0' }}>
          本周尚无船只送行.
        </div>
      ) : (
        favor.ledger.map((entry, idx) => <LedgerRow key={idx} entry={entry} />)
      )}
      <div
        style={{
          ...labelStyle,
          marginTop: '10px',
          marginBottom: '4px',
          color: INK,
          fontSize: FONT_BODY,
        }}
      >
        花费恩惠
      </div>
      <SinkButton
        label="租下渔夫的码头"
        flavor="动用你的影响力, 本周在港口额外租下一处码头, 让更多船只停靠. 反正渔夫们也用不上它."
        cost={favor.pier_cost}
        current={favor.current}
        done={!!favor.pier_rented}
        doneLabel="本周已租"
        action="rent_pier"
        act={act}
      />
      <SinkButton
        label="召来公司侏儒"
        flavor="援引与费伦提亚侏儒挑夫行会的契约, 让他们经手银面的销售, 并将加价收归你自己. 出于某些奇怪的原因, 从未有人见过这些侏儒. 别为此却步, 本周余下的时间里你无需动一根手指便能大赚一笔."
        cost={favor.gnome_cost}
        current={favor.current}
        done={!!favor.gnome_unlocked}
        doneLabel="已在薪酬名册"
        action="unlock_gnomes"
        act={act}
      />
      {!favor.auto_hailer_unlocked ? (
        <SinkButton
          label="聘留港口装卸队"
          flavor="将装卸工头聘为长期雇员. 一经付清, 你便可随时派他们驻守港口, 随机招呼船只, 并遣走那些滞留过久的船. 当你无法亲自打点码头时十分有用 - 但请当心: 未能履行贸易义务的船只仍会拖累你在公司的声望, 甚至跌入赤字."
          cost={favor.auto_hailer_cost}
          current={favor.current}
          done={false}
          doneLabel="已长期聘用"
          action="unlock_auto_hailer"
          act={act}
        />
      ) : (
        <AutoHailerToggle on={!!favor.auto_hailer_on} act={act} />
      )}
      {/* TODO: flavor - charter button label + flavor (catalog.desc from DM, origin note inline) */}
      {catalogs.map((catalog) => (
        <SinkButton
          key={catalog.id}
          label={`开启 ${catalog.name}`}
          flavor={
            catalog.desc +
            (catalog.origin_access
              ? ` 你的 ${catalog.home_label} 已以 ${catalog.discount_pct}% 折扣对你开放; 付费可将特许状扩展至整个公司.`
              : '')
          }
          cost={catalog.favor_cost}
          current={favor.current}
          done={!!catalog.unlocked}
          doneLabel="特许已开启"
          action="unlock_catalog"
          params={{ catalog: catalog.id }}
          act={act}
        />
      ))}
    </div>
  );
};

const AutoHailerToggle = (props: { on: boolean; act: ActFn }) => {
  const { on, act } = props;
  return (
    <div
      style={{
        padding: '8px 10px',
        border: `1px solid ${INK_FAINT}`,
        background: on ? 'rgba(180,200,160,0.18)' : 'var(--p-card-bg)',
        borderRadius: '2px',
        marginTop: '6px',
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={{ ...labelStyle, color: INK, fontSize: FONT_BODY }}>
          自动招呼机 (港口装卸队)
        </span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>
          {on ? (
            <span style={{ color: SEAL_GREEN }}>运作中</span>
          ) : (
            <span style={{ color: INK_SOFT }}>已歇工</span>
          )}
        </span>
      </div>
      <div style={{ ...noteStyle, marginBottom: '6px' }}>
        装卸队工作时, 会招呼船只直至每日上限, 并在船只
        完成其吨位或停港满一日后将其遣走.{' '}
        <b>失敬遣走会将你的声望拖入赤字</b> - 让它继续运作,
        你回来时可能已欠下一笔债.
      </div>
      <button
        type="button"
        style={inkButtonStyle({})}
        onClick={() => act('toggle_auto_hailer')}
      >
        {on ? '歇工' : '让装卸队开工'}
      </button>
    </div>
  );
};

export const ManagementTab = (props: { harbor?: HarborData; act: ActFn }) => {
  const { harbor, act } = props;
  if (!harbor) {
    return (
      <div style={pageStyle}>
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          账簿尚未拟就.
        </div>
      </div>
    );
  }
  return (
    <div style={pageStyle}>
      <FavorCard
        favor={harbor.favor}
        catalogs={harbor.catalogs ?? []}
        act={act}
      />
      <LevyControl
        current={harbor.merchant_levy_percent}
        cap={harbor.merchant_levy_cap}
        act={act}
      />
      {!!harbor.favor.gnome_unlocked && (
        <GnomeMarginControl
          current={harbor.ledger.silverface_margin_percent}
          act={act}
        />
      )}
    </div>
  );
};

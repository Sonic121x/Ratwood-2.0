import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type DemandLine = {
  good: string;
  good_name: string;
  qty_target: number;
  qty_fulfilled: number;
  offered_price: number;
  kin_offered_price?: number;
  tag?: string;
};

type Manifest = {
  ship_id: string;
  ship_name: string;
  realm_id: string;
  is_kin?: BooleanLike;
  typical_provisions?: string;
  lines: DemandLine[];
};

type Data = {
  manifests: Manifest[];
  middleman_cut_percent: number;
  kinship_sell_pct?: number;
  can_manage?: BooleanLike;
  duty_suspended?: BooleanLike;
  duty_rate_pct?: number;
  duty_collected_here?: number;
  duty_evaded_here?: number;
};

const TAG_VICTUALLING_FRESH = 'victualling_fresh';
const TAG_VICTUALLING_PRESERVED = 'victualling_preserved';
const TAG_VICTUALLING_DRINKS = 'victualling_drinks';

const SUBSECTION_LABELS: Record<string, string> = {
  bulk: '大宗贸易',
  [TAG_VICTUALLING_FRESH]: '补给 - 生鲜',
  [TAG_VICTUALLING_PRESERVED]: '补给 - 耐储食品',
  [TAG_VICTUALLING_DRINKS]: '补给 - 酒水',
};

const SUBSECTION_HINT: Record<string, string> = {
  bulk: '船舶准备运回本国的大宗货物需求。',
  [TAG_VICTUALLING_FRESH]:
    '供船员食用的新鲜补给。',
  [TAG_VICTUALLING_PRESERVED]:
    '供航行途中食用的耐储食品。',
  [TAG_VICTUALLING_DRINKS]:
    '供船员饮用或运回本国转售的酒水。按桶出售 - 将酿制完成且未开封的发酵桶拖到货箱上。不收零散酒瓶。',
};

const SUBSECTION_ORDER = [
  'bulk',
  TAG_VICTUALLING_FRESH,
  TAG_VICTUALLING_PRESERVED,
  TAG_VICTUALLING_DRINKS,
];

const SUBSECTION_GROUP: Record<string, 'goods' | 'food' | 'drinks'> = {
  bulk: 'goods',
  [TAG_VICTUALLING_FRESH]: 'food',
  [TAG_VICTUALLING_PRESERVED]: 'food',
  [TAG_VICTUALLING_DRINKS]: 'drinks',
};

const GROUP_LABEL: Record<'goods' | 'food' | 'drinks', string> = {
  goods: '货物',
  food: '食品',
  drinks: '酒水',
};

const GroupDivider = (props: { label: string }) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      gap: '8px',
      margin: '10px 0 4px',
    }}
  >
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
    <span
      style={{
        color: SEAL_AMBER,
        fontFamily: SERIF,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
        letterSpacing: '2px',
      }}
    >
      {props.label}
    </span>
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
  </div>
);

const LineRow = (props: { line: DemandLine; cutPercent: number }) => {
  const { line, cutPercent } = props;
  const remaining = Math.max(0, line.qty_target - line.qty_fulfilled);
  const done = remaining === 0;
  const hasKin =
    line.kin_offered_price !== undefined &&
    line.kin_offered_price > line.offered_price;
  const effectivePrice = hasKin
    ? (line.kin_offered_price as number)
    : line.offered_price;
  const producerPayout = Math.round(effectivePrice * (1 - cutPercent / 100));
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '12px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        opacity: done ? 0.55 : 1,
      }}
      title={
        hasKin
          ? `${effectivePrice}m each (Kinship +${effectivePrice - line.offered_price}m over base ${line.offered_price}m)`
          : undefined
      }
    >
      <span style={{ flex: 1, color: INK, fontWeight: 'bold' }}>
        {line.good_name}
      </span>
      <span style={{ flex: '0 0 90px', color: INK_SOFT }}>
        {line.qty_fulfilled} / {line.qty_target}
      </span>
      <span
        style={{
          flex: '0 0 110px',
          textAlign: 'right',
          fontWeight: 'bold',
        }}
      >
        {hasKin && (
          <span
            style={{
              color: INK_FAINT,
              textDecoration: 'line-through',
              marginRight: '4px',
              fontWeight: 'normal',
            }}
          >
            {line.offered_price}m
          </span>
        )}
        <span style={{ color: done ? INK_FAINT : hasKin ? SEAL_GREEN : SEAL_AMBER }}>
          每份 {effectivePrice}m
        </span>
      </span>
      <span
        style={{
          flex: '0 0 130px',
          textAlign: 'right',
          color: done ? INK_FAINT : SEAL_GREEN,
        }}
      >
        你可得 {producerPayout}m
      </span>
    </div>
  );
};

const Subsection = (props: {
  tag: string;
  lines: DemandLine[];
  cutPercent: number;
}) => {
  const { tag, lines, cutPercent } = props;
  if (lines.length === 0) return null;
  return (
    <div style={{ marginTop: '6px' }}>
      <div
        style={{
          fontFamily: SERIF,
          color: SEAL_AMBER,
          fontSize: FONT_BODY,
          marginBottom: '2px',
        }}
      >
        {SUBSECTION_LABELS[tag] || tag}
      </div>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          fontStyle: 'italic',
          color: INK_FAINT,
          marginBottom: '4px',
        }}
      >
        {SUBSECTION_HINT[tag] || ''}
      </div>
      {lines.map((line) => (
        <LineRow key={`${tag}|${line.good}`} line={line} cutPercent={cutPercent} />
      ))}
    </div>
  );
};

const ManifestSection = (props: {
  manifest: Manifest;
  cutPercent: number;
}) => {
  const { manifest, cutPercent } = props;
  const grouped: Record<string, DemandLine[]> = {};
  for (const line of manifest.lines) {
    const key = line.tag || 'bulk';
    if (!grouped[key]) grouped[key] = [];
    grouped[key].push(line);
  }
  return (
    <div style={{ marginBottom: '14px' }}>
      <div style={sectionHeaderStyle}>
        {manifest.ship_name}
        <span
          style={{
            color: SEAL_AMBER,
            fontSize: FONT_BODY,
            marginLeft: '8px',
          }}
        >
          {manifest.realm_id}
        </span>
        {!!manifest.is_kin && (
          <span
            title="Kin ship - bulk demand payouts get the Kinship bonus"
            style={{
              marginLeft: '6px',
              padding: '0 6px',
              border: `1px solid ${SEAL_GREEN}`,
              borderRadius: '8px',
              color: SEAL_GREEN,
              fontSize: FONT_BODY,
              fontWeight: 'bold',
              letterSpacing: '0.5px',
              verticalAlign: 'middle',
            }}
          >
            同乡
          </span>
        )}
      </div>
      {!!manifest.typical_provisions && (
        <div
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK_SOFT,
            marginTop: '2px',
            marginBottom: '6px',
            paddingLeft: '4px',
            borderLeft: `2px solid ${PARCHMENT_SHADOW}`,
          }}
        >
          常用补给：{manifest.typical_provisions}
        </div>
      )}
      {(() => {
        const renderable = SUBSECTION_ORDER.filter(
          (tag) => (grouped[tag] || []).length > 0,
        );
        let lastGroup: 'goods' | 'food' | 'drinks' | null = null;
        return renderable.map((tag) => {
          const group = SUBSECTION_GROUP[tag];
          const insertDivider = group !== lastGroup;
          lastGroup = group;
          return (
            <div key={tag}>
              {insertDivider && <GroupDivider label={GROUP_LABEL[group]} />}
              <Subsection
                tag={tag}
                lines={grouped[tag] || []}
                cutPercent={cutPercent}
              />
            </div>
          );
        });
      })()}
    </div>
  );
};

// Ratwood deviation: AP's Underledger passes `inkButtonStyle({ danger: !!duty_suspended })`,
// but ES's (and AP's own) parchment.tsx `inkButtonStyle` only accepts `{ color, disabled }`
// - there is no `danger` option. Swapped for an explicit `color` (red while dodging duty,
// green while paying it) to get the same "this is a toggle with a warning state" affordance
// without relying on a prop that doesn't exist.
const Underledger = () => {
  const { data, act } = useBackend<Data>();
  const {
    duty_suspended,
    duty_rate_pct = 0,
    duty_collected_here = 0,
    duty_evaded_here = 0,
  } = data;
  return (
    <div style={{ ...cardStyle, marginTop: '14px', borderColor: SEAL_AMBER }}>
      <div style={{ ...sectionHeaderStyle, color: SEAL_AMBER }}>暗账</div>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: '11px',
          fontStyle: 'italic',
          color: INK_SOFT,
          marginBottom: '6px',
        }}
      >
        出口关税税率为 {duty_rate_pct}%。逃税后，此处出售的货物
        将不再扣缴该税。少缴的数额只有商人或店伙计知晓，王室只能猜测。
      </div>
      <button
        type="button"
        style={inkButtonStyle({ color: duty_suspended ? SEAL_RED : SEAL_GREEN })}
        onClick={() => act('toggle_duty')}
      >
        王室关税：{duty_suspended ? '逃避缴纳' : '正常缴纳'}
      </button>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: '11px',
          color: INK_SOFT,
          marginTop: '6px',
        }}
      >
        此处已缴：{duty_collected_here}m。此处逃缴：{duty_evaded_here}m。
      </div>
    </div>
  );
};

export const ShipFulfillment = () => {
  const { data, act } = useBackend<Data>();
  const { manifests, middleman_cut_percent, can_manage } = data;

  return (
    <Window display_title="船舶履约货箱" width={620} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, position: 'relative' }}>
          <button
            type="button"
            title="Open the economy guidebook"
            style={{ ...inkButtonStyle({}), position: 'absolute', top: 8, right: 8 }}
            onClick={() => act('help')}
          >
            ?
          </button>
          <div style={titleStyle}>大宗需求清单</div>
          <div style={subtitleStyle}>
            将符合需求的货物交给货箱即可履约。商人将收取{' '}
            {middleman_cut_percent}% 的中介费。
          </div>
          <div style={rulerStyle} />
          {manifests.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              码头目前没有收购货物的船舶。请招呼一艘船入港，开启贸易。
            </div>
          ) : (
            manifests.map((m) => (
              <ManifestSection
                key={m.ship_id}
                manifest={m}
                cutPercent={middleman_cut_percent}
              />
            ))
          )}
          {!!can_manage && <Underledger />}
        </div>
      </Window.Content>
    </Window>
  );
};

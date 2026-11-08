import { useState } from 'react';
import { Button, Section } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { CARD_DISPLAY } from './common/displayNames';
type Side = 'one' | 'two';
type CardRow = 'infantry' | 'archers' | 'siege';
type CardType = CardRow | 'weather' | 'special';
type CardRarity = 'base' | 'rare' | 'unique';

type Card = {
  id: string;
  name: string;
  desc: string;
  row: CardType;
  power: number;
  currentPower?: number;
  playId?: number;
  rarity: CardRarity;
  effect: string;
  combo: string;
  targetRow?: CardRow;
  art?: string;
  artAtlas?: CardAtlasPosition;
  hero?: boolean;
  known?: boolean;
};

type CardAtlasPosition = {
  column: number;
  row: number;
};

type Leader = {
  id: string;
  name: string;
  desc: string;
  effect: string;
  targetRow?: CardRow;
  used: boolean;
};

type CcgFaction = {
  id: string;
  name: string;
  desc: string;
  effect: string;
  defaultLeader: string;
};

type Data = {
  waiting?: boolean;
  offeredName?: string;
  mySide?: Side;
  isSpectator?: boolean;
  spectatorCount?: number;
  turn?: Side;
  players?: Record<Side, string>;
  wins?: Record<Side, number>;
  passed?: Record<Side, boolean>;
  scores?: Record<Side, number>;
  round?: number;
  inMulligan?: boolean;
  mulligansLeft?: number;
  mulliganReady?: boolean;
  result?: string;
  message?: string;
  leader?: Leader;
  faction?: CcgFaction;
  weather?: string[];
  weatherCards?: Card[];
  rowEffects?: Record<Side, Record<CardRow, Card[]>>;
  hand?: Card[];
  discard?: Card[];
  deckCount?: number;
  discardCount?: number;
  soundtrackEnabled?: boolean;
  soundtrackTitle?: string;
  targets?: {
    revive?: Card[];
    decoy?: Card[];
  };
  opponentHandCount?: number;
  board?: Record<Side, Record<CardRow, Card[]>>;
};

const rowLabels: Record<CardRow, string> = {
  infantry: '步兵',
  archers: '弓手',
  siege: '攻城',
};

const cardTypeLabels: Record<CardType, string> = {
  ...rowLabels,
  weather: '天气',
  special: '特殊',
};

const rarityColor: Record<CardRarity, string> = {
  base: '#f8fafc',
  rare: '#60a5fa',
  unique: '#fbbf24',
};

const cardAtlasAsset = 'ccg_cards/cards.png';
const cardAtlasColumns = 16;
const cardAtlasRows = 10;

const atlasPercent = (index: number, size: number) =>
  `${(index / (size - 1)) * 100}%`;

const cardAtlasStyle = (atlas: CardAtlasPosition | undefined) => {
  if (!atlas) {
    return undefined;
  }
  return {
    position: 'absolute' as const,
    inset: 0,
    backgroundImage: `url(${resolveAsset(cardAtlasAsset)})`,
    backgroundPosition: `${atlasPercent(atlas.column, cardAtlasColumns)} ${atlasPercent(atlas.row, cardAtlasRows)}`,
    backgroundRepeat: 'no-repeat',
    backgroundSize: `${cardAtlasColumns * 100}% ${cardAtlasRows * 100}%`,
    imageRendering: 'pixelated' as const,
    zIndex: 0,
  };
};

const rowWeatherFrameAssets: Record<CardRow, string> = {
  infantry: 'ccg_cards/effects/frost.png',
  archers: 'ccg_cards/effects/fog.png',
  siege: 'ccg_cards/effects/rain.png',
};

const rowEffectFrameAssets = {
  horn: 'ccg_cards/effects/horn.png',
  mardroeme: 'ccg_cards/effects/mushroom.png',
};

const GwyntVisualEffects = () => (
  <style>
    {`
      @keyframes ccg-card-drop {
        0% {
          opacity: 0;
          transform: translateY(-54px) scale(1.24) rotateX(28deg);
          filter: brightness(2.25) saturate(1.32);
        }
        54% {
          opacity: 1;
          transform: translateY(8px) scale(0.96) rotateX(0deg);
          filter: brightness(1.35) saturate(1.15);
        }
        100% {
          opacity: 1;
          transform: translateY(0) scale(1);
          filter: brightness(1);
        }
      }

      @keyframes ccg-card-impact {
        0% {
          opacity: 0;
          transform: scale(0.55);
        }
        24% {
          opacity: 0.96;
          transform: scale(1.06);
        }
        100% {
          opacity: 0;
          transform: scale(1.42);
        }
      }

      @keyframes ccg-card-shine {
        0% { transform: translateX(-150%) rotate(18deg); opacity: 0; }
        18% { opacity: 0.55; }
        70% { opacity: 0.18; }
        100% { transform: translateX(190%) rotate(18deg); opacity: 0; }
      }

      @keyframes ccg-rarity-flash {
        0% {
          opacity: 0;
          transform: scale(0.84);
        }
        28% {
          opacity: 0.95;
          transform: scale(1.08);
        }
        100% {
          opacity: 0;
          transform: scale(1.45);
        }
      }

      @keyframes ccg-weather-rain {
        from { background-position: 0 0, 0 0; }
        to { background-position: -44px 88px, -68px 136px; }
      }

      @keyframes ccg-weather-fog {
        0% { transform: translateX(-8%); opacity: 0.24; }
        50% { opacity: 0.42; }
        100% { transform: translateX(8%); opacity: 0.24; }
      }

      @keyframes ccg-weather-frost {
        0%, 100% { opacity: 0.34; filter: brightness(1); }
        50% { opacity: 0.58; filter: brightness(1.28); }
      }

      @keyframes ccg-weather-snow {
        from { background-position: 0 0, 18px 10px, 0 0; }
        to { background-position: 22px 70px, 42px 92px, 0 0; }
      }

      @keyframes ccg-horn-pulse {
        0%, 100% {
          opacity: 0.26;
          transform: scaleX(0.98);
        }
        50% {
          opacity: 0.62;
          transform: scaleX(1.02);
        }
      }

      @keyframes ccg-horn-rays {
        from { background-position: 0 0; }
        to { background-position: 112px 0; }
      }

      @keyframes ccg-mardroeme-drift {
        0% { transform: translateX(-8%) scale(1); opacity: 0.2; }
        50% { opacity: 0.48; }
        100% { transform: translateX(8%) scale(1.04); opacity: 0.2; }
      }

      @keyframes ccg-board-sheen {
        0%, 42% { transform: translateX(-120%); opacity: 0; }
        52% { opacity: 0.18; }
        72% { opacity: 0.08; }
        100% { transform: translateX(120%); opacity: 0; }
      }

      .ccg-card-played {
        animation: ccg-card-drop 240ms cubic-bezier(0.18, 0.89, 0.32, 1.28);
      }

      .ccg-card-impact {
        position: absolute;
        inset: -10px;
        border-radius: 8px;
        pointer-events: none;
        z-index: 5;
        background:
          radial-gradient(circle at 50% 50%, rgba(255,255,255,0.76), rgba(250,204,21,0.34) 34%, transparent 68%);
        animation: ccg-card-impact 440ms ease-out forwards;
      }

      .ccg-card-shine {
        position: absolute;
        top: -18%;
        bottom: -18%;
        width: 34%;
        left: 0;
        z-index: 3;
        pointer-events: none;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.68), transparent);
        mix-blend-mode: screen;
        animation: ccg-card-shine 740ms ease-out forwards;
      }

      .ccg-card-effect--horn {
        box-shadow:
          0 0 0 1px rgba(0,0,0,0.72),
          0 0 14px rgba(251,191,36,0.52),
          inset 0 0 10px rgba(251,191,36,0.14) !important;
      }

      .ccg-rarity-flash {
        position: absolute;
        inset: -9px;
        border-radius: 8px;
        pointer-events: none;
        z-index: 4;
        animation: ccg-rarity-flash 620ms ease-out forwards;
      }

      .ccg-rarity-flash--rare {
        border: 2px solid rgba(96, 165, 250, 0.95);
        box-shadow:
          0 0 18px rgba(96, 165, 250, 0.9),
          inset 0 0 16px rgba(147, 197, 253, 0.48);
      }

      .ccg-rarity-flash--unique {
        border: 2px solid rgba(251, 191, 36, 0.98);
        box-shadow:
          0 0 22px rgba(251, 191, 36, 0.95),
          inset 0 0 18px rgba(253, 224, 71, 0.5);
      }

      .ccg-row-vfx {
        position: absolute;
        top: 2px;
        right: 45px;
        bottom: 2px;
        left: 62px;
        border-radius: 4px;
        overflow: hidden;
        pointer-events: none;
        z-index: 0;
      }

      .ccg-row-frame {
        position: absolute;
        top: 0;
        left: 62px;
        width: calc(100% - 116px);
        height: 100%;
        object-fit: fill;
        image-rendering: pixelated;
        pointer-events: none;
        z-index: 3;
        opacity: 0.8;
        mix-blend-mode: screen;
        filter: drop-shadow(0 0 8px rgba(15,23,42,0.55));
        transform-origin: center center;
      }

      .ccg-row-frame--archers {
        --frame-scale-x: 1.491;
        --frame-scale-y: 1.202;
      }

      .ccg-row-frame--infantry {
        --frame-scale-x: 1.649;
        --frame-scale-y: 1.175;
      }

      .ccg-row-frame--siege {
        --frame-scale-x: 1.934;
        --frame-scale-y: 1.184;
      }

      .ccg-row-weather--siege {
        background-image:
          linear-gradient(
            106deg,
            transparent 0 47%,
            rgba(147,197,253,0.18) 48%,
            rgba(191,219,254,0.12) 49%,
            transparent 50% 100%
          ),
          linear-gradient(
            106deg,
            transparent 0 45%,
            rgba(96,165,250,0.13) 46%,
            rgba(191,219,254,0.09) 47%,
            transparent 48% 100%
          );
        background-size: 44px 88px, 68px 136px;
        animation: ccg-weather-rain 1.55s linear infinite;
        opacity: 0.24;
      }

      .ccg-row-weather--archers {
        background:
          radial-gradient(ellipse at 18% 48%, rgba(134,239,172,0.22), transparent 42%),
          radial-gradient(ellipse at 82% 46%, rgba(187,247,208,0.18), transparent 52%),
          radial-gradient(ellipse at 48% 52%, rgba(226,232,240,0.16), transparent 60%),
          linear-gradient(90deg, transparent, rgba(74,222,128,0.13), transparent);
        filter: blur(7px) saturate(1.12);
        animation: ccg-weather-fog 5.2s ease-in-out infinite alternate;
        opacity: 0.68;
      }

      .ccg-row-weather--infantry {
        background:
          radial-gradient(circle, rgba(240,249,255,0.76) 0 1px, transparent 2px),
          radial-gradient(circle, rgba(186,230,253,0.58) 0 1px, transparent 2px),
          linear-gradient(135deg, rgba(59,130,246,0.14), rgba(191,219,254,0.18) 42%, rgba(14,165,233,0.1));
        background-size: 44px 44px, 62px 62px, 100% 100%;
        animation:
          ccg-weather-snow 5.8s linear infinite,
          ccg-weather-frost 2.6s ease-in-out infinite;
        opacity: 0.56;
      }

      .ccg-row-horn {
        background:
          linear-gradient(90deg, transparent, rgba(251,191,36,0.14), transparent),
          radial-gradient(ellipse at 50% 50%, rgba(251,191,36,0.3), transparent 68%);
        background-size: 100% 100%, 100% 100%;
        animation:
          ccg-horn-pulse 1.15s ease-in-out infinite;
        mix-blend-mode: screen;
      }

      .ccg-row-frame--horn {
        --frame-scale-x: 1.662;
        --frame-scale-y: 1.175;
        opacity: 0.785;
        animation: ccg-horn-rays 2.1s linear infinite;
      }

      .ccg-row-mardroeme {
        background:
          radial-gradient(ellipse at 22% 52%, rgba(34,197,94,0.14), transparent 56%),
          radial-gradient(ellipse at 74% 50%, rgba(168,85,247,0.12), transparent 58%),
          linear-gradient(90deg, transparent, rgba(74,222,128,0.1), transparent);
        filter: blur(8px);
        animation: ccg-mardroeme-drift 3.4s ease-in-out infinite alternate;
        mix-blend-mode: screen;
      }

      .ccg-row-frame--mardroeme {
        --frame-scale-x: 1.981;
        --frame-scale-y: 1.158;
        opacity: 0.75;
      }

      .ccg-board-sheen {
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        width: 42%;
        pointer-events: none;
        z-index: 3;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.14), transparent);
        transform: translateX(-120%);
        animation: ccg-board-sheen 5.5s ease-in-out infinite;
      }
    `}
  </style>
);

const sideLabels: Record<Side, string> = {
  one: '玩家一',
  two: '玩家二',
};

const sideAccent: Record<Side, string> = {
  one: '#38bdf8',
  two: '#ef4444',
};

const effectBadges: Record<string, string> = {
  morale: '士气',
  scorch: '焦土',
  scorch_infantry: '焦土',
  scorch_global: '焦土',
  spy: '间谍',
  medic: '医师',
  bond: '连结',
  agile: '敏捷',
  muster: '集结',
  horn: '号角',
  decoy: '诱饵',
  berserk: '狂战',
  mardroeme: '蘑菇',
  avenger: '复仇',
};

const rowIconAssets: Record<CardType, string> = {
  infantry: 'ccg_cards/icons/melee.png',
  archers: 'ccg_cards/icons/ranged.png',
  siege: 'ccg_cards/icons/siege.png',
  weather: 'ccg_cards/icons/sun.png',
  special: 'ccg_cards/icons/command.png',
};

const effectIconAssets: Record<string, string> = {
  morale: 'ccg_cards/icons/morale.png',
  scorch: 'ccg_cards/icons/burn.png',
  scorch_infantry: 'ccg_cards/icons/incinerate.png',
  scorch_global: 'ccg_cards/icons/scorch.png',
  spy: 'ccg_cards/icons/spy.png',
  medic: 'ccg_cards/icons/heal.png',
  bond: 'ccg_cards/icons/bond.png',
  agile: 'ccg_cards/icons/agile.png',
  muster: 'ccg_cards/icons/bond.png',
  horn: 'ccg_cards/icons/horn.png',
  decoy: 'ccg_cards/icons/decoy.png',
  berserk: 'ccg_cards/icons/berserk.png',
  mardroeme: 'ccg_cards/icons/mushroom.png',
  avenger: 'ccg_cards/icons/avenger.png',
  clear_weather: 'ccg_cards/icons/sun.png',
  frost: 'ccg_cards/icons/frost.png',
  fog: 'ccg_cards/icons/fog.png',
  rain: 'ccg_cards/icons/rain.png',
};

const effectDescriptions: Record<string, string> = {
  morale: '士气提升：本列所有其他单位战力+1。',
  scorch: "焦土：摧毁对手最强的卡牌。",
  scorch_infantry:
    "焦土：敌方步兵总战力达到10时，摧毁其中最强的步兵。",
  scorch_global: '焦土：摧毁场上战力最高的所有卡牌。',
  spy: "间谍：部署到对手场上，并为你抽取两张牌。",
  medic: '医师：将弃牌堆中最强的卡牌放回场上。',
  bond: '紧密连结：具有此能力的同名卡牌会互相增强。',
  agile: '敏捷：灵活部署卡牌的试行标记。',
  muster: '集结：打出手牌与牌库中所有匹配的卡牌。',
  horn: "指挥号角：在本小局中使所选列的战力翻倍。",
  decoy: '诱饵：将己方场上最强卡牌收回手牌。',
  berserk: '狂战士：受到狂战蘑菇影响时变成熊。',
  mardroeme: '狂战蘑菇：将本列狂战士变成熊。',
  avenger:
    '复仇者：被摧毁时召唤一张强力卡牌替代自身。',
  clear_weather: '晴空：清除所有天气效果。',
  frost: '冰霜：将所有步兵的战力降为1。',
  fog: '浓雾：将所有弓手的战力降为1。',
  rain: '大雨：将所有攻城单位的战力降为1。',
};

const CardIconBadge = ({
  asset,
  label,
  compact,
  title,
}: {
  asset?: string;
  label?: string;
  compact: boolean;
  title: string;
}) => {
  const size = compact ? 14 : 20;
  return (
    <div
      title={title}
      style={{
        width: `${size}px`,
        height: `${size}px`,
        borderRadius: '50%',
        backgroundColor: 'rgba(5,7,11,0.82)',
        border: '1px solid rgba(248,250,252,0.72)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
        boxShadow: '0 1px 4px rgba(0,0,0,0.65)',
      }}
    >
      {asset ? (
        <img
          src={resolveAsset(asset)}
          style={{
            width: compact ? '11px' : '16px',
            height: compact ? '11px' : '16px',
            objectFit: 'contain',
            imageRendering: 'pixelated',
          }}
        />
      ) : (
        <span
          style={{
            color: '#f8fafc',
            fontSize: compact ? '4px' : '6px',
            fontWeight: 900,
            lineHeight: 1,
          }}
        >
          {label}
        </span>
      )}
    </div>
  );
};

const cardTooltip = (card: Card) => {
  if (card.known === false) {
    return ['未知'];
  }
  const lines = [
    card.name,
    `类型：${cardTypeLabels[card.row]}`,
    `战力：${card.power}`,
  ];
  if (effectDescriptions[card.effect]) {
    lines.push(`效果：${effectDescriptions[card.effect]}`);
  } else if (card.desc) {
    lines.push(card.desc);
  }
  if (card.hero) {
    lines.push('英雄：免疫天气与特殊效果。');
  }
  return lines;
};

const cardBoxStyle = (card: Card, compact = false) => ({
  position: 'relative' as const,
  width: compact ? '54px' : '86px',
  aspectRatio: '1 / 1.6',
  padding: compact ? '3px' : '4px',
  border: `2px solid ${rarityColor[card.rarity]}`,
  borderRadius: '4px',
  background:
    'linear-gradient(180deg, rgba(35,39,48,0.98), rgba(14,16,22,0.98))',
  boxShadow: `0 0 0 1px rgba(0,0,0,0.7), 0 0 10px ${rarityColor[card.rarity]}33`,
  display: 'flex',
  flexDirection: 'column' as const,
  justifyContent: 'space-between',
  overflow: 'visible',
});

const CardView = ({
  card,
  compact = false,
  onClick,
}: {
  card: Card;
  compact?: boolean;
  onClick?: () => void;
}) => {
  const [hovered, setHovered] = useState(false);
  const [tooltipPlacement, setTooltipPlacement] = useState<{
    side: 'left' | 'center' | 'right';
    vertical: 'above' | 'below';
  }>({ side: 'center', vertical: 'below' });
  const tooltip = cardTooltip(card);
  const tooltipWidth = compact ? 108 : 172;
  const tooltipGap = compact ? 8 : 10;
  const effectIcon = effectIconAssets[card.effect];
  const effectBadge = effectBadges[card.effect];
  const singleTypeIcon = card.row === 'weather' || card.row === 'special';
  const typeIcon = singleTypeIcon
    ? effectIcon || rowIconAssets[card.row]
    : rowIconAssets[card.row];
  const typeTitle = singleTypeIcon
    ? effectDescriptions[card.effect] || card.effect || cardTypeLabels[card.row]
    : cardTypeLabels[card.row];
  const cardClassName = [
    card.playId ? 'ccg-card-played' : '',
    card.effect === 'horn' ? 'ccg-card-effect--horn' : '',
  ]
    .filter(Boolean)
    .join(' ');
  const updateTooltipPlacement = (cardElement: HTMLElement) => {
    const rect = cardElement.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const tooltipHeight = compact
      ? Math.min(200, 42 + tooltip.length * 17)
      : Math.min(260, 52 + tooltip.length * 22);
    let side: 'left' | 'center' | 'right' = 'center';
    if (centerX - tooltipWidth / 2 < 12) {
      side = 'left';
    } else if (centerX + tooltipWidth / 2 > window.innerWidth - 12) {
      side = 'right';
    }
    setTooltipPlacement({
      side,
      vertical:
        rect.bottom + tooltipHeight + tooltipGap <= window.innerHeight
          ? 'below'
          : 'above',
    });
  };
  return (
    <div
      className={cardClassName || undefined}
      style={{
        ...cardBoxStyle(card, compact),
        cursor: onClick ? 'pointer' : 'default',
        transform: hovered ? 'scale(1.15)' : 'scale(1)',
        transformOrigin: 'center center',
        transition: 'transform 140ms ease, z-index 140ms ease',
        zIndex: hovered ? 50 : 1,
      }}
      onClick={onClick}
      onMouseEnter={(event) => {
        updateTooltipPlacement(event.currentTarget);
        setHovered(true);
      }}
      onMouseMove={(event) => updateTooltipPlacement(event.currentTarget)}
      onMouseLeave={() => setHovered(false)}
    >
      {!!card.playId && <div className="ccg-card-impact" />}
      {!!card.playId && <div className="ccg-card-shine" />}
      {!!card.playId && card.rarity !== 'base' && (
        <div className={`ccg-rarity-flash ccg-rarity-flash--${card.rarity}`} />
      )}
      {!!card.artAtlas && <div style={cardAtlasStyle(card.artAtlas)} />}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background:
            'linear-gradient(180deg, rgba(0,0,0,0.34), rgba(0,0,0,0.04) 32%, rgba(0,0,0,0.62))',
          zIndex: 0,
        }}
      />
      <div
        style={{
          position: 'relative',
          zIndex: 2,
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          width: '100%',
        }}
      >
        <CardIconBadge
          asset={typeIcon}
          compact={compact}
          title={typeTitle}
        />
        {!singleTypeIcon && (!!effectIcon || !!effectBadge) && (
          <CardIconBadge
            asset={effectIcon}
            label={effectBadge}
            compact={compact}
            title={effectDescriptions[card.effect] || card.effect}
          />
        )}
      </div>
      {card.hero && (
        <div
          style={{
            position: 'absolute',
            left: '50%',
            top: compact ? '4px' : '5px',
            transform: 'translateX(-50%)',
            width: compact ? '16px' : '22px',
            height: compact ? '13px' : '17px',
            borderRadius: '8px',
            backgroundColor: 'rgba(251,191,36,0.94)',
            color: '#111827',
            fontSize: compact ? '5px' : '7px',
            fontWeight: 900,
            lineHeight: compact ? '13px' : '17px',
            textAlign: 'center',
            zIndex: 2,
          }}
        >
          英雄
        </div>
      )}
      {hovered && (
        <div
          style={{
            position: 'absolute',
            left:
              tooltipPlacement.side === 'right'
                ? undefined
                : tooltipPlacement.side === 'left'
                  ? 0
                  : '50%',
            right: tooltipPlacement.side === 'right' ? 0 : undefined,
            top:
              tooltipPlacement.vertical === 'below'
                ? `calc(100% + ${tooltipGap}px)`
                : undefined,
            bottom:
              tooltipPlacement.vertical === 'above'
                ? `calc(100% + ${tooltipGap}px)`
                : undefined,
            width: `${tooltipWidth}px`,
            maxWidth: '70vw',
            padding: compact ? '10px' : '14px',
            border: '2px solid rgba(248,250,252,0.85)',
            borderRadius: '6px',
            backgroundColor: 'rgba(5,7,11,0.96)',
            color: '#f8fafc',
            fontSize: compact ? '12px' : '16px',
            lineHeight: 1.25,
            zIndex: 1000,
            boxShadow: '0 8px 24px rgba(0,0,0,0.85)',
            pointerEvents: 'none',
            transform:
              tooltipPlacement.side === 'center'
                ? 'translateX(-50%)'
                : undefined,
            whiteSpace: 'normal',
            overflowWrap: 'break-word',
          }}
        >
          <div
            style={{
              color: rarityColor[card.rarity],
              fontWeight: 900,
              marginBottom: compact ? '6px' : '8px',
            }}
          >
            {tooltip[0]}
          </div>
          {tooltip.slice(1).map((line) => (
            <div key={line}>{line}</div>
          ))}
        </div>
      )}

      <div
        style={{
          position: 'relative',
          zIndex: 1,
          display: 'grid',
          gridTemplateColumns: compact ? '16px 1fr' : '23px 1fr',
          alignItems: 'center',
          width: '100%',
          minHeight: compact ? '16px' : '22px',
        }}
      >
        <div
          style={{
            width: compact ? '16px' : '23px',
            height: compact ? '16px' : '23px',
            borderRadius: '50%',
            backgroundColor: '#05070b',
            border: `2px solid ${rarityColor[card.rarity]}`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: '#f8fafc',
            fontSize: compact ? '8px' : '12px',
            fontWeight: 700,
            zIndex: 1,
          }}
        >
          {card.currentPower ?? card.power}
        </div>
        <div
          style={{
            marginLeft: compact ? '-3px' : '-4px',
            padding: compact ? '1px 3px 1px 5px' : '2px 4px 2px 7px',
            border: `1px solid ${rarityColor[card.rarity]}`,
            backgroundColor: 'rgba(5,7,11,0.92)',
            color: '#f8fafc',
            fontWeight: 700,
            lineHeight: 1.1,
            overflow: 'hidden',
          }}
        >
          <div
            style={{
              fontSize: compact ? '6px' : '8px',
              whiteSpace: 'nowrap',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}
          >
            {card.name}
          </div>
          <div
            style={{
              color: rarityColor[card.rarity],
              fontSize: compact ? '4px' : '6px',
              fontWeight: 900,
              lineHeight: 1,
              textTransform: 'uppercase',
              whiteSpace: 'nowrap',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}
          >
            {cardTypeLabels[card.row]}
          </div>
        </div>
      </div>
    </div>
  );
};

const RowView = ({
  row,
  title,
  cards,
  weathered,
  effects,
}: {
  row: CardRow;
  title: string;
  cards: Card[];
  weathered: boolean;
  effects: Card[];
}) => {
  const total = cards.reduce(
    (sum, card) => sum + (card.currentPower ?? card.power),
    0,
  );
  const hasHorn = effects.some((card) => card.effect === 'horn');
  const hasMardroeme = effects.some((card) => card.effect === 'mardroeme');
  const weatherAccent =
    row === 'infantry' ? '#7dd3fc' : row === 'archers' ? '#cbd5e1' : '#93c5fd';
  return (
    <div
      style={{
        position: 'relative',
        display: 'grid',
        gridTemplateColumns: '54px 1fr 42px',
        gap: '8px',
        alignItems: 'center',
        minHeight: '100px',
        padding: '7px 8px',
        borderTop: '1px solid rgba(255,255,255,0.16)',
        borderBottom: '1px solid rgba(0,0,0,0.6)',
        background:
          'linear-gradient(90deg, rgba(45,30,18,0.92), rgba(116,91,58,0.78) 18%, rgba(72,55,35,0.84) 74%, rgba(22,19,18,0.9)), repeating-linear-gradient(0deg, rgba(255,255,255,0.05) 0 1px, transparent 1px 18px)',
        boxShadow: 'inset 0 0 16px rgba(0,0,0,0.55)',
        overflow: 'visible',
      }}
    >
      {weathered && (
        <div className={`ccg-row-vfx ccg-row-weather--${row}`} />
      )}
      {hasHorn && <div className="ccg-row-vfx ccg-row-horn" />}
      {hasMardroeme && <div className="ccg-row-vfx ccg-row-mardroeme" />}
      {weathered && (
        <img
          alt=""
          className={`ccg-row-frame ccg-row-frame--${row}`}
          src={resolveAsset(rowWeatherFrameAssets[row])}
        />
      )}
      {hasHorn && (
        <img
          alt=""
          className="ccg-row-frame ccg-row-frame--horn"
          src={resolveAsset(rowEffectFrameAssets.horn)}
        />
      )}
      {hasMardroeme && (
        <img
          alt=""
          className="ccg-row-frame ccg-row-frame--mardroeme"
          src={resolveAsset(rowEffectFrameAssets.mardroeme)}
        />
      )}
      <div
        style={{
          position: 'relative',
          zIndex: 1,
          color: weathered ? weatherAccent : '#e5e7eb',
          fontSize: '11px',
          fontWeight: 700,
          textTransform: 'uppercase',
        }}
      >
        {title}
      </div>
      <div
        style={{
          position: 'relative',
          zIndex: 1,
          display: 'flex',
          gap: '4px',
          minHeight: '88px',
          alignItems: 'center',
          justifyContent: 'center',
          flexWrap: 'wrap',
          borderLeft: '1px solid rgba(15,23,42,0.55)',
          borderRight: '1px solid rgba(15,23,42,0.55)',
          padding: '2px 6px',
        }}
      >
        {cards.map((card, index) => (
          <CardView
            key={card.playId ? `played-${card.playId}` : `${card.id}-${index}`}
            card={card}
            compact
          />
        ))}
      </div>
      <div
        style={{
          position: 'relative',
          zIndex: 1,
          width: '34px',
          height: '34px',
          borderRadius: '4px',
          border: `2px solid ${weathered ? weatherAccent : '#111827'}`,
          background: weathered
            ? `linear-gradient(180deg, ${weatherAccent}44, #101722)`
            : 'linear-gradient(180deg, #263447, #0f172a)',
          color: weathered ? weatherAccent : '#f8fafc',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          textAlign: 'center',
          fontSize: '17px',
          fontWeight: 800,
          boxShadow:
            '0 1px 0 rgba(255,255,255,0.15), inset 0 0 8px rgba(0,0,0,0.65)',
        }}
      >
        {total}
      </div>
    </div>
  );
};

const PlayerBoard = ({ side, data }: { side: Side; data: Data }) => {
  const board = data.board?.[side];
  const weather = data.weather || [];
  const score = data.scores?.[side] ?? 0;
  const rows: CardRow[] =
    side === 'two'
      ? ['siege', 'archers', 'infantry']
      : ['infantry', 'archers', 'siege'];
  return (
    <div
      style={{
        border: `2px solid ${sideAccent[side]}99`,
        background:
          'linear-gradient(180deg, rgba(15,23,42,0.92), rgba(8,11,17,0.94))',
        boxShadow: 'inset 0 0 18px rgba(0,0,0,0.65)',
      }}
    >
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr auto auto',
          gap: '10px',
          alignItems: 'center',
          padding: '5px 8px',
          background: `linear-gradient(90deg, ${sideAccent[side]}33, rgba(15,23,42,0.92))`,
          borderBottom: '1px solid rgba(255,255,255,0.12)',
        }}
      >
        <div style={{ color: '#f8fafc', fontWeight: 800 }}>
          {data.players?.[side] || sideLabels[side]}
          {data.passed?.[side] ? ' | 已放弃本小局' : ''}
        </div>
        <div style={{ color: '#cbd5e1' }}>胜局 {data.wins?.[side] ?? 0}</div>
        <div
          style={{
            minWidth: '46px',
            color: sideAccent[side],
            fontSize: '22px',
            fontWeight: 900,
            textAlign: 'right',
          }}
        >
          {score}
        </div>
      </div>
      {rows.map((row) => (
        <RowView
          key={row}
          row={row}
          title={rowLabels[row]}
          cards={board?.[row] || []}
          weathered={weather.includes(row)}
          effects={data.rowEffects?.[side]?.[row] || []}
        />
      ))}
    </div>
  );
};

const BoardEffectsPanel = ({
  data,
  weatherCards,
}: {
  data: Data;
  weatherCards: Card[];
}) => (
  <div
    style={{
      padding: '8px',
      border: '1px solid rgba(148,163,184,0.22)',
      borderRadius: '5px',
      background:
        'linear-gradient(180deg, rgba(15,18,27,0.9), rgba(5,7,12,0.72))',
      boxShadow: 'inset 0 0 18px rgba(0,0,0,0.36)',
      marginBottom: '8px',
    }}
  >
    <div
      style={{
        color: '#94a3b8',
        fontSize: '10px',
        fontWeight: 900,
        textTransform: 'uppercase',
        marginBottom: '5px',
      }}
    >
      天气
    </div>
    <div
      style={{
        height: '96px',
        display: 'flex',
        gap: '5px',
        flexWrap: 'nowrap',
        alignItems: 'center',
        padding: '5px',
        border: '1px solid rgba(148,163,184,0.18)',
        background: 'rgba(2,6,12,0.45)',
        marginBottom: '8px',
        overflowX: 'auto',
        overflowY: 'hidden',
      }}
    >
      {weatherCards.map((card, index) => (
        <CardView key={`${card.id}-${index}`} card={card} compact />
      ))}
      {!weatherCards.length && (
        <div style={{ color: '#64748b', fontSize: '11px' }}>晴朗</div>
      )}
    </div>
    <div
      style={{
        color: '#94a3b8',
        fontSize: '10px',
        fontWeight: 900,
        textTransform: 'uppercase',
        marginBottom: '5px',
      }}
    >
      列效果
    </div>
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(3, 1fr)',
        gap: '5px',
      }}
    >
      {(['infantry', 'archers', 'siege'] as CardRow[]).map((row) => {
        const rowCards = (['two', 'one'] as Side[]).flatMap(
          (side) => data.rowEffects?.[side]?.[row] || [],
        );
        return (
          <div
            key={row}
            style={{
              height: '96px',
              display: 'flex',
              flexDirection: 'column',
              gap: '4px',
              padding: '4px',
              border: '1px dashed rgba(203,213,225,0.24)',
              background: 'rgba(2,6,12,0.32)',
              overflow: 'hidden',
            }}
          >
            <div
              style={{
                color: '#94a3b8',
                fontSize: '10px',
                fontWeight: 800,
                textTransform: 'uppercase',
                textAlign: 'center',
              }}
            >
              {rowLabels[row]}
            </div>
            <div
              style={{
                display: 'flex',
                justifyContent: 'center',
                gap: '4px',
                overflowX: 'auto',
                overflowY: 'hidden',
              }}
            >
              {rowCards.map((card, index) => (
                <CardView
                  key={`${row}-${card.id}-${index}`}
                  card={card}
                  compact
                />
              ))}
            </div>
          </div>
        );
      })}
    </div>
  </div>
);

const BattleBoard = ({ data }: { data: Data }) => (
  <div
    style={{
      position: 'relative',
      padding: '10px',
      border: '1px solid rgba(161,98,7,0.55)',
      borderRadius: '6px',
      background:
        'radial-gradient(circle at 50% 48%, rgba(120,82,42,0.55), transparent 44%), linear-gradient(90deg, #17100b, #5a3b1e 9%, #2a1c12 50%, #5a3b1e 91%, #130d09)',
      boxShadow:
        'inset 0 0 0 2px rgba(255,255,255,0.08), inset 0 0 38px rgba(0,0,0,0.9), 0 12px 30px rgba(0,0,0,0.55)',
      overflow: 'visible',
    }}
  >
    <div
      style={{
        position: 'absolute',
        inset: '6px',
        border: '1px solid rgba(245,158,11,0.18)',
        borderRadius: '4px',
        pointerEvents: 'none',
      }}
    />
    <div className="ccg-board-sheen" />
    <div
      style={{
        position: 'absolute',
        left: 0,
        right: 0,
        top: '50%',
        height: '1px',
        background:
          'linear-gradient(90deg, transparent, rgba(250,204,21,0.28), transparent)',
        pointerEvents: 'none',
      }}
    />
    <div style={{ position: 'relative', zIndex: 1 }}>
      <PlayerBoard side="two" data={data} />
    </div>
    <div
      style={{
        position: 'relative',
        zIndex: 1,
        height: '6px',
        margin: '4px 0',
        borderRadius: '999px',
        background:
          'linear-gradient(90deg, rgba(17,24,39,0.2), rgba(226,232,240,0.38), rgba(17,24,39,0.2))',
        boxShadow: '0 0 10px rgba(226,232,240,0.16)',
      }}
    />
    <div style={{ position: 'relative', zIndex: 1 }}>
      <PlayerBoard side="one" data={data} />
    </div>
  </div>
);

const DeckPile = ({
  title,
  count,
  accent,
}: {
  title: string;
  count: number;
  accent: string;
}) => (
  <div
    style={{
      position: 'relative',
      minHeight: '62px',
      padding: '8px 8px 8px 48px',
      border: '1px solid rgba(148,163,184,0.24)',
      borderRadius: '5px',
      background:
        'linear-gradient(145deg, rgba(18,22,31,0.96), rgba(4,6,11,0.98))',
      boxShadow:
        'inset 0 1px 0 rgba(255,255,255,0.08), inset 0 -12px 20px rgba(0,0,0,0.28)',
      overflow: 'hidden',
    }}
  >
    <div
      style={{
        position: 'absolute',
        left: '11px',
        top: '12px',
        width: '25px',
        height: '36px',
        border: '1px solid rgba(226,232,240,0.82)',
        borderRadius: '2px',
        background:
          'linear-gradient(145deg, rgba(52,57,67,0.96), rgba(8,10,15,0.98))',
        boxShadow:
          '4px 4px 0 rgba(226,232,240,0.16), 8px 8px 0 rgba(226,232,240,0.07)',
      }}
    />
    <div
      style={{
        position: 'absolute',
        left: '14px',
        top: '15px',
        width: '19px',
        height: '3px',
        background: accent,
        opacity: 0.75,
      }}
    />
    <div
      style={{
        color: '#cbd5e1',
        fontSize: '10px',
        fontWeight: 900,
        textTransform: 'uppercase',
      }}
    >
      {CARD_DISPLAY[title] || title}
    </div>
    <div style={{ color: '#f8fafc', fontSize: '22px', fontWeight: 900 }}>
      {count}
    </div>
  </div>
);

const MatchInfoPanel = ({
  data,
  phase,
  weather,
}: {
  data: Data;
  phase: string;
  weather: string;
}) => {
  const mySide = data.mySide || 'one';
  const accent = sideAccent[mySide];
  return (
    <div
      style={{
        padding: '8px',
        border: '1px solid rgba(148,163,184,0.22)',
        borderRadius: '5px',
        background:
          'linear-gradient(180deg, rgba(15,18,27,0.9), rgba(5,7,12,0.72))',
        boxShadow: 'inset 0 0 18px rgba(0,0,0,0.36)',
        marginBottom: '8px',
      }}
    >
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: '6px',
          marginBottom: '8px',
        }}
      >
        <div
          style={{
            padding: '7px 8px',
            border: '1px solid rgba(148,163,184,0.22)',
            background: 'rgba(2,6,12,0.55)',
          }}
        >
          <div
            style={{
              color: '#94a3b8',
              fontSize: '10px',
              fontWeight: 900,
              textTransform: 'uppercase',
            }}
          >
            小局
          </div>
          <div style={{ color: '#f8fafc', fontSize: '22px', fontWeight: 900 }}>
            {data.round || 1}
          </div>
        </div>
        <div
          style={{
            padding: '7px 8px',
            border: '1px solid rgba(148,163,184,0.22)',
            background: 'rgba(2,6,12,0.55)',
          }}
        >
          <div
            style={{
              color: '#94a3b8',
              fontSize: '10px',
              fontWeight: 900,
              textTransform: 'uppercase',
            }}
          >
            对手手牌
          </div>
          <div style={{ color: '#f8fafc', fontSize: '22px', fontWeight: 900 }}>
            {data.opponentHandCount ?? 0}
          </div>
        </div>
      </div>
      <div
        style={{
          padding: '7px 8px',
          border: `1px solid ${accent}55`,
          background:
            'linear-gradient(90deg, rgba(2,6,12,0.74), rgba(15,23,42,0.62))',
          color: '#e5e7eb',
          fontSize: '12px',
          fontWeight: 800,
          marginBottom: '8px',
        }}
      >
        <div
          style={{
            color: accent,
            fontSize: '10px',
            textTransform: 'uppercase',
          }}
        >
          阶段
        </div>
        {phase}
      </div>
      <div
        style={{
          color: data.result ? '#fbbf24' : '#d9f99d',
          fontSize: '12px',
          lineHeight: 1.35,
          marginBottom: '8px',
        }}
      >
        {data.result || data.message || '等待下一步行动。'}
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: '8px',
          marginBottom: '8px',
        }}
      >
        <DeckPile title="Draw" count={data.deckCount ?? 0} accent={accent} />
        <DeckPile
          title="Discard"
          count={data.discardCount ?? 0}
          accent="#94a3b8"
        />
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: '6px',
          padding: '7px 8px',
          border: '1px solid rgba(148,163,184,0.22)',
          background: 'rgba(2,6,12,0.55)',
          color: '#cbd5e1',
          fontSize: '11px',
          fontWeight: 800,
        }}
      >
        <span>手牌：{data.hand?.length ?? 0}</span>
        <span>天气：{weather}</span>
        <span style={{ color: accent }}>
          回合：{data.turn === data.mySide ? '你' : '对手'}
        </span>
        <span>{data.passed?.[mySide] ? '已放弃本小局' : '仍在出牌'}</span>
      </div>
    </div>
  );
};

const LeaderPanel = ({
  data,
  canUseLeader,
  onUse,
}: {
  data: Data;
  canUseLeader: boolean;
  onUse: () => void;
}) => {
  if (!data.leader) {
    return null;
  }
  return (
    <div
      style={{
        marginBottom: '8px',
        padding: '8px',
        border: `1px solid ${
          canUseLeader ? 'rgba(251,191,36,0.55)' : 'rgba(148,163,184,0.22)'
        }`,
        borderRadius: '5px',
        background: canUseLeader
          ? 'linear-gradient(180deg, rgba(46,32,12,0.78), rgba(6,8,13,0.74))'
          : 'linear-gradient(180deg, rgba(15,18,27,0.82), rgba(5,7,12,0.72))',
        boxShadow: canUseLeader ? '0 0 14px rgba(251,191,36,0.12)' : undefined,
      }}
    >
      {data.faction && (
        <div
          style={{
            color: '#fbbf24',
            fontSize: '11px',
            fontWeight: 900,
            textTransform: 'uppercase',
            marginBottom: '4px',
          }}
        >
          {data.faction.name}
        </div>
      )}
      <div style={{ color: '#f8fafc', fontSize: '14px', fontWeight: 900 }}>
        {data.leader.name}
        {data.leader.used ? ' | 已使用' : ''}
      </div>
      <div
        style={{
          color: '#cbd5e1',
          fontSize: '12px',
          lineHeight: 1.35,
          margin: '6px 0 8px',
        }}
      >
        {data.leader.desc}
      </div>
      <Button
        fluid
        bold
        color={canUseLeader ? 'good' : undefined}
        disabled={!canUseLeader}
        onClick={onUse}
      >
        使用领袖能力
      </Button>
    </div>
  );
};

export const GwyntTable = () => {
  const { act, data } = useBackend<Data>();
  const [selectedCard, setSelectedCard] = useState<Card | null>(null);

  if (data.waiting) {
    return (
      <Window title="Card Battle" display_title={CARD_DISPLAY['Card Battle']} width={420} height={180}>
        <Window.Content>
          <Section title={CARD_DISPLAY.Invitation}>
            {data.offeredName || '某人'}正在等待对手。用自己的牌组
            点击这副牌组即可开始。
          </Section>
        </Window.Content>
      </Window>
    );
  }

  const hand = data.hand || [];
  const isSpectator = !!data.isSpectator;
  const weatherCards = data.weatherCards || [];
  const myTurn =
    data.mySide &&
    data.turn === data.mySide &&
    !data.result &&
    !data.inMulligan;
  const canUseLeader = !!data.leader && !data.leader.used && !!myTurn;
  const weather = data.weather?.length ? data.weather.map((row) => rowLabels[row as CardRow] || row).join('、') : '晴朗';
  let phase = '等待中';
  if (isSpectator) {
    phase = '观战中';
  } else if (data.result) {
    phase = '游戏结束';
  } else if (data.inMulligan) {
    phase = `换牌 | 剩余${data.mulligansLeft ?? 0}次`;
  } else if (data.turn) {
    phase = `${data.players?.[data.turn] || sideLabels[data.turn]}的回合`;
  }
  const rowChoices: CardRow[] = ['infantry', 'archers', 'siege'];
  const requiresRowChoice = (card: Card) =>
    card.effect === 'agile' ||
    ((card.effect === 'horn' || card.effect === 'mardroeme') &&
      !card.targetRow);
  const requiresTargetChoice = (card: Card) =>
    card.effect === 'decoy' ||
    (card.effect === 'medic' && !!data.targets?.revive?.length);
  const playCard = (card: Card) => {
    if (data.inMulligan) {
      act('mulligan', { card: card.id });
      return;
    }
    if (!myTurn) {
      return;
    }
    if (requiresRowChoice(card) || requiresTargetChoice(card)) {
      setSelectedCard(card);
      return;
    }
    act('play', { card: card.id });
  };
  const playWithRow = (row: CardRow) => {
    if (!selectedCard) {
      return;
    }
    act('play', { card: selectedCard.id, row });
    setSelectedCard(null);
  };
  const playWithRevive = (card: Card) => {
    if (!selectedCard) {
      return;
    }
    act('play', { card: selectedCard.id, revive: card.id });
    setSelectedCard(null);
  };
  const playWithDecoy = (card: Card) => {
    if (
      !selectedCard ||
      !card.playId ||
      !card.row ||
      card.row === 'weather' ||
      card.row === 'special'
    ) {
      return;
    }
    act('play', { card: selectedCard.id, row: card.row, target: card.playId });
    setSelectedCard(null);
  };

  return (
    <Window title="Card Battle" display_title={CARD_DISPLAY['Card Battle']} width={1280} height={840}>
      <Window.Content scrollable>
        <GwyntVisualEffects />
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '280px minmax(560px, 1fr) 300px',
            gap: '12px',
            alignItems: 'start',
          }}
        >
          <div>
            {!isSpectator && (
              <>
                <LeaderPanel
                  data={data}
                  canUseLeader={canUseLeader}
                  onUse={() => act('leader')}
                />
                <Section title={`${CARD_DISPLAY.Hand} | ${hand.length}${CARD_DISPLAY.cards}`}>
                  <div
                    style={{
                      display: 'grid',
                      gridTemplateColumns: 'repeat(3, 86px)',
                      gap: '8px',
                    }}
                  >
                    {hand.map((card, index) => (
                      <CardView
                        key={`${card.id}-${index}`}
                        card={card}
                        onClick={
                          (data.inMulligan && !data.mulliganReady) || myTurn
                            ? () => playCard(card)
                            : undefined
                        }
                      />
                    ))}
                  </div>
                </Section>
              </>
            )}
          </div>

          <div>
            <BattleBoard data={data} />
          </div>

          <div>
            <Section title={CARD_DISPLAY.Match}>
              <BoardEffectsPanel data={data} weatherCards={weatherCards} />
              <Button
                fluid
                selected={!!data.soundtrackEnabled}
                onClick={() => act('toggle_soundtrack')}
                mb="8px"
              >
                配乐：{' '}
                {data.soundtrackEnabled
                  ? data.soundtrackTitle || '开启'
                  : '关闭'}
              </Button>
              <MatchInfoPanel data={data} phase={phase} weather={weather} />
              {isSpectator && (
                <div
                  style={{
                    marginBottom: '8px',
                    color: '#cbd5e1',
                    fontSize: '12px',
                  }}
                >
                  观战者：{data.spectatorCount || 0}
                </div>
              )}
              {selectedCard && (
                <div
                  style={{
                    marginBottom: '8px',
                    padding: '6px',
                    border: '1px solid rgba(251,191,36,0.45)',
                    background: 'rgba(30,20,8,0.55)',
                  }}
                >
                  <div
                    style={{
                      color: '#fbbf24',
                      fontWeight: 800,
                      marginBottom: '5px',
                    }}
                  >
                    为{selectedCard.name}选择目标
                  </div>
                  {requiresRowChoice(selectedCard) && (
                    <div
                      style={{
                        display: 'flex',
                        gap: '5px',
                        marginBottom: '6px',
                      }}
                    >
                      {rowChoices.map((row) => (
                        <Button key={row} onClick={() => playWithRow(row)}>
                          {rowLabels[row]}
                        </Button>
                      ))}
                    </div>
                  )}
                  {selectedCard.effect === 'medic' && (
                    <div
                      style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}
                    >
                      {(data.targets?.revive || []).map((card, index) => (
                        <Button
                          key={`${card.id}-${index}`}
                          onClick={() => playWithRevive(card)}
                        >
                          {card.name}
                        </Button>
                      ))}
                    </div>
                  )}
                  {selectedCard.effect === 'decoy' && (
                    <div
                      style={{ display: 'flex', gap: '5px', flexWrap: 'wrap' }}
                    >
                      {(data.targets?.decoy || []).map((card) => (
                        <Button
                          key={card.playId}
                          onClick={() => playWithDecoy(card)}
                        >
                          {card.name}
                        </Button>
                      ))}
                    </div>
                  )}
                  <Button onClick={() => setSelectedCard(null)}>取消</Button>
                </div>
              )}
              {!!data.inMulligan && (
                <Button
                  disabled={isSpectator || !!data.mulliganReady}
                  onClick={() => act('ready_mulligan')}
                >
                  准备
                </Button>
              )}
              <Button disabled={isSpectator || !myTurn} onClick={() => act('pass')}>
                放弃本小局
              </Button>
              <Button
                disabled={isSpectator}
                onClick={() => act('collect')}
              >
                结束对局
              </Button>
              {isSpectator ? (
                <Button color="bad" onClick={() => act('leave_spectator')}>
                  离开
                </Button>
              ) : null}
            </Section>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

import { cls } from './helpers';
import type { Spell, Variant } from './types';

export const GrimoireVariantSection = ({
  variants,
  fixedSpells,
  choiceSpells,
  userTier,
  variantOverride,
}: {
  variants: Variant[];
  fixedSpells: Spell[];
  choiceSpells: Spell[];
  userTier: number;
  variantOverride?: string;
}) => (
  <div>
    <div className="AspectPicker__divider" />
    <div className="AspectPicker__section-label">变体</div>
    {variants.map((variant) => (
      <div key={variant.name} className="AspectPicker__variant-block">
        <div
          className={cls(
            'AspectPicker__variant-name',
            ((variant.name === 'mastery' && userTier >= 4) ||
              variant.name === variantOverride) &&
              'AspectPicker__variant-name--active',
          )}
        >
          {variant.name === 'mastery' ? '精通' : variant.name === 'gefechtsgelehrter' ? '战阵学者' : variant.name}
          {variant.name === 'mastery' &&
            userTier >= 4 &&
            ' \u2014 由你的位阶授予'}
          {variant.name === variantOverride &&
            ' \u2014 由你的传统授予'}
        </div>
        {variant.swaps.map((swap) => {
          const isAdditive = !swap.from;
          const fromSpell = isAdditive
            ? null
            : fixedSpells.find((s) => s.path === swap.from) ||
              choiceSpells.find((s) => s.path === swap.from);
          return (
            <div
              key={swap.from || swap.to.name}
              className="AspectPicker__spell-entry"
            >
              {isAdditive ? (
                <span className="AspectPicker__spell-desc">
                  {'额外：'}
                </span>
              ) : (
                <>
                  <span className="AspectPicker__spell-desc">
                    {fromSpell?.name || '?'}
                  </span>
                  {' \u2192 '}
                </>
              )}
              <span className="AspectPicker__spell-name">{swap.to.name}</span>
              {swap.to.desc && (
                <div
                  className="AspectPicker__spell-desc"
                  dangerouslySetInnerHTML={{ __html: swap.to.desc }}
                />
              )}
            </div>
          );
        })}
      </div>
    ))}
  </div>
);

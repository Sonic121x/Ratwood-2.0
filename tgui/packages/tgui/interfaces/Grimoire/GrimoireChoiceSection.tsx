import { cls, stripHtml } from './helpers';
import type { Aspect, Spell } from './types';

export const GrimoireChoiceSection = ({
  aspect,
  stagedChoices,
  liveChosen,
  isPendingUnbind = false,
  initialSetup = true,
  resetBudget = 0,
  swapCost = 2,
  allSelectedSpells,
  claimedGroups,
  act,
  readOnly = false,
  variantOverride,
  userTier = 0,
}: {
  aspect: Aspect;
  stagedChoices: Record<string, string>;
  liveChosen?: string;
  isPendingUnbind?: boolean;
  initialSetup?: boolean;
  resetBudget?: number;
  swapCost?: number;
  allSelectedSpells: string[];
  claimedGroups: Record<string, string>;
  act: (action: string, params: Record<string, unknown>) => void;
  readOnly?: boolean;
  variantOverride?: string;
  userTier?: number;
}) => {
  const currentChoice = stagedChoices[aspect.path] || null;
  const hasChosen = currentChoice !== null;
  const swapMode =
    !readOnly && !initialSetup && !!liveChosen && !isPendingUnbind;
  const stagedSwap = swapMode && currentChoice !== liveChosen;
  const swapAvailable = resetBudget + (stagedSwap ? swapCost : 0);

  const activeVariant = variantOverride
    ? aspect.variants?.find((v) => v.name === variantOverride)
    : undefined;
  const swapMap: Record<string, Spell> = {};
  if (activeVariant) {
    for (const swap of activeVariant.swaps) {
      if (swap.from) {
        swapMap[swap.from] = swap.to;
      }
    }
  }

  return (
    <div>
      <div className="AspectPicker__divider" />
      {!hasChosen && (
        <div
          className="AspectPicker__section-label"
          style={{ color: 'rgba(255,200,120,0.9)' }}
        >
          选择其一
          <span style={{ fontSize: '10px', marginLeft: '6px', opacity: 0.7 }}>
            - 点击选择
          </span>
        </div>
      )}
      {hasChosen && swapMode && (
        <div className="AspectPicker__section-label">
          选择
          <span style={{ fontSize: '10px', marginLeft: '6px', opacity: 0.7 }}>
            - 消耗 {swapCost} 点重塑额度替换已铭刻法术
          </span>
        </div>
      )}
      {aspect.choice_spells.map((spell) => {
        if (spell.mastery_only && userTier < 4) {
          return null;
        }
        const display = swapMap[spell.path] || spell;
        const isSwapped = display !== spell;
        const isSelected = currentChoice === spell.path;
        const isLiveChosen = swapMode && spell.path === liveChosen;
        const selectedElsewhere =
          !isSelected &&
          !isLiveChosen &&
          allSelectedSpells.includes(spell.path);
        const claimedBy = spell.exclusive_group
          ? claimedGroups[spell.exclusive_group]
          : undefined;
        const conflictsElsewhere =
          !isSelected &&
          !selectedElsewhere &&
          claimedBy !== undefined &&
          claimedBy !== aspect.path;
        const wouldCostSwap = swapMode && !isSelected && !isLiveChosen;
        const cantAffordSwap = wouldCostSwap && swapAvailable < swapCost;
        const disabled =
          selectedElsewhere || conflictsElsewhere || cantAffordSwap;
        return (
          <div
            key={spell.path}
            className={cls(
              'AspectPicker__pointbuy-entry',
              isSelected && 'AspectPicker__pointbuy-entry--selected',
              disabled && 'AspectPicker__pointbuy-entry--disabled',
            )}
            title={
              display.fluff_desc ? stripHtml(display.fluff_desc) : undefined
            }
            style={{
              cursor: disabled ? 'default' : 'pointer',
            }}
            onClick={() =>
              !disabled &&
              act('choice_toggle', {
                aspect_path: aspect.path,
                spell_path: spell.path,
              })
            }
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
              <span
                style={{
                  display: 'inline-block',
                  width: '12px',
                  flexShrink: 0,
                  fontSize: '12px',
                  color: isSelected
                    ? 'rgba(120,255,120,0.9)'
                    : 'rgba(150,150,150,0.3)',
                }}
              >
                {isSelected ? '✓' : '–'}
              </span>
              <span className="AspectPicker__spell-name">{display.name}</span>
              {isSwapped && (
                <span
                  style={{
                    fontSize: '10px',
                    opacity: 0.6,
                    fontStyle: 'italic',
                  }}
                >
                  - 传统
                </span>
              )}
              {spell.mastery_only && (
                <span
                  style={{
                    fontSize: '10px',
                    opacity: 0.7,
                    fontStyle: 'italic',
                    color: 'rgba(220,180,120,0.9)',
                  }}
                >
                  - 精通
                </span>
              )}
              {isLiveChosen && (
                <span
                  style={{
                    fontSize: '10px',
                    opacity: 0.7,
                    fontStyle: 'italic',
                  }}
                >
                  {stagedSwap ? '- 已铭刻，点击保留' : '- 已铭刻'}
                </span>
              )}
              {isSelected && stagedSwap && (
                <span
                  style={{
                    fontSize: '10px',
                    fontStyle: 'italic',
                    color: 'rgba(255,200,120,0.9)',
                  }}
                >
                  - 待替换：消耗 {swapCost} 点重塑额度
                </span>
              )}
              {wouldCostSwap && !cantAffordSwap && (
                <span
                  style={{
                    fontSize: '10px',
                    opacity: 0.6,
                    fontStyle: 'italic',
                  }}
                >
                  - 替换：消耗 {swapCost} 点重塑额度
                </span>
              )}
            </div>
            {selectedElsewhere && (
              <span
                className="AspectPicker__spell-desc"
                style={{ marginLeft: '18px' }}
              >
                已经铭刻
              </span>
            )}
            {conflictsElsewhere && (
              <span
                className="AspectPicker__spell-desc"
                style={{ marginLeft: '18px' }}
              >
                与已选法术冲突
              </span>
            )}
            {cantAffordSwap && (
              <span
                className="AspectPicker__spell-desc"
                style={{ marginLeft: '18px' }}
              >
                需要 {swapCost} 点重塑额度
              </span>
            )}
            {display.desc && (
              <div
                className="AspectPicker__spell-desc"
                style={{ marginLeft: '18px' }}
                dangerouslySetInnerHTML={{ __html: display.desc }}
              />
            )}
            {readOnly && display.fluff_desc && (
              <div
                className="AspectPicker__spell-fluff"
                style={{ marginLeft: '18px' }}
                dangerouslySetInnerHTML={{ __html: display.fluff_desc }}
              />
            )}
          </div>
        );
      })}
    </div>
  );
};

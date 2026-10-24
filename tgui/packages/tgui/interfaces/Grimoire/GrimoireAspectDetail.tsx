import { GrimoireChoiceSection } from './GrimoireChoiceSection';
import { GrimoirePointBuySection } from './GrimoirePointBuySection';
import { GrimoireSpellEntry } from './GrimoireSpellEntry';
import { GrimoireVariantSection } from './GrimoireVariantSection';
import type { Aspect, ResetCosts, Tab } from './types';

export const GrimoireAspectDetail = ({
  aspect,
  isAttuned,
  isLocked,
  isPendingUnbind,
  slotsFull,
  tab,
  userTier,
  initialSetup,
  resetBudget,
  resetCosts,
  stagedChoices,
  liveChoices,
  pointbuySelections,
  allSelectedSpells,
  claimedGroups,
  getPointbuyUsed,
  act,
  readOnly = false,
  variantOverride,
}: {
  aspect: Aspect;
  isAttuned: boolean;
  isLocked: boolean;
  isPendingUnbind: boolean;
  slotsFull: boolean;
  tab: Tab;
  userTier: number;
  initialSetup: boolean;
  resetBudget: number;
  resetCosts: ResetCosts;
  stagedChoices: Record<string, string>;
  liveChoices: Record<string, string>;
  pointbuySelections: Record<string, string[]>;
  allSelectedSpells: string[];
  claimedGroups: Record<string, string>;
  getPointbuyUsed: (a: Aspect) => number;
  act: (action: string, params: Record<string, unknown>) => void;
  readOnly?: boolean;
  variantOverride?: string;
}) => {
  const isMajor = aspect.aspect_type === 'major';
  const unbindCost = isMajor ? resetCosts.major : resetCosts.minor;
  const canUnbind = !isLocked && resetBudget >= unbindCost;

  return (
    <>
      <div style={{ flex: 1, overflowY: 'auto' }}>
        <div className="AspectPicker__heading">
          <span
            style={
              aspect.school_color ? { color: aspect.school_color } : undefined
            }
          >
            {aspect.name}
          </span>
          {isPendingUnbind && (
            <span
              style={{
                fontSize: '11px',
                marginLeft: '10px',
                color: 'rgba(200,100,100,0.8)',
              }}
            >
              - 即将解除绑定
            </span>
          )}
        </div>

        {aspect.latin_name && (
          <div
            style={{
              fontStyle: 'italic',
              fontSize: '11px',
              opacity: 0.5,
              marginTop: '-2px',
              marginBottom: '4px',
            }}
          >
            {aspect.latin_name}
          </div>
        )}

        {aspect.desc && aspect.desc !== 'TODO' && (
          <div
            className="AspectPicker__desc"
            dangerouslySetInnerHTML={{ __html: aspect.desc }}
          />
        )}

        {aspect.attuned_name && (
          <div className="AspectPicker__attunement">
            法器协调：&ldquo;{aspect.attuned_name}&rdquo;
          </div>
        )}

        <div className="AspectPicker__divider" />

        {aspect.choice_spells && aspect.choice_spells.length > 0 && (
          <GrimoireChoiceSection
            aspect={aspect}
            stagedChoices={stagedChoices}
            liveChosen={liveChoices[aspect.path]}
            isPendingUnbind={isPendingUnbind}
            initialSetup={initialSetup}
            resetBudget={resetBudget}
            swapCost={resetCosts.choice}
            allSelectedSpells={allSelectedSpells}
            claimedGroups={claimedGroups}
            act={act}
            readOnly={readOnly}
            variantOverride={variantOverride}
            userTier={userTier}
          />
        )}

        {aspect.fixed_spells.length > 0 && (
          <div>
            <div className="AspectPicker__section-label">法术</div>
            {aspect.fixed_spells.map((spell) => (
              <GrimoireSpellEntry key={spell.path} spell={spell} />
            ))}
          </div>
        )}

        {aspect.variants && aspect.variants.length > 0 && (
          <GrimoireVariantSection
            variants={aspect.variants}
            fixedSpells={aspect.fixed_spells}
            choiceSpells={aspect.choice_spells}
            userTier={userTier}
            variantOverride={variantOverride}
          />
        )}

        {aspect.pointbuy_spells.length > 0 && (
          <GrimoirePointBuySection
            aspect={aspect}
            pointbuySelections={pointbuySelections}
            allSelectedSpells={allSelectedSpells}
            claimedGroups={claimedGroups}
            getPointbuyUsed={getPointbuyUsed}
            act={act}
            readOnly={readOnly}
          />
        )}
      </div>

      {!readOnly && (
        <div style={{ marginTop: '8px', flexShrink: 0 }}>
          {isPendingUnbind ? (
            <div
              className="AspectPicker__action-btn AspectPicker__action-btn--caution"
              onClick={() => act('undo_unbind', { path: aspect.path })}
            >
              取消解除绑定
            </div>
          ) : isAttuned ? (
            isLocked ? (
              <div
                className="AspectPicker__attunement"
                style={{ textAlign: 'center', padding: '8px' }}
              >
                天生绑定。
              </div>
            ) : initialSetup ? (
              <div
                className="AspectPicker__action-btn AspectPicker__action-btn--remove"
                onClick={() => act('remove', { path: aspect.path })}
              >
                解除绑定：{aspect.name}
              </div>
            ) : canUnbind ? (
              <div
                className="AspectPicker__action-btn AspectPicker__action-btn--remove"
                onClick={() => act('remove', { path: aspect.path })}
              >
                解除绑定：{aspect.name}（消耗：{unbindCost}）
              </div>
            ) : (
              <div
                className="AspectPicker__attunement"
                style={{ textAlign: 'center', padding: '8px' }}
              >
                {resetBudget < unbindCost
                  ? '重塑额度不足。'
                  : '当前已协调。'}
              </div>
            )
          ) : slotsFull ? (
            <div
              className="AspectPicker__attunement"
              style={{ textAlign: 'center', padding: '8px' }}
            >
              没有剩余{tab === 'major' ? '主' : '次'}法相栏位。
            </div>
          ) : (
            <div
              className="AspectPicker__action-btn AspectPicker__action-btn--confirm"
              onClick={() => act('attune', { path: aspect.path })}
            >
              绑定：{aspect.name}
            </div>
          )}
        </div>
      )}
    </>
  );
};

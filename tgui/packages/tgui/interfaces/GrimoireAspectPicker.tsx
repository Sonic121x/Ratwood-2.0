import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { GrimoireAspectDetail } from './Grimoire/GrimoireAspectDetail';
import { GrimoireChapterList } from './Grimoire/GrimoireChapterList';
import { GrimoireTabBar } from './Grimoire/GrimoireTabBar';
import { GrimoireUtilitiesDetail } from './Grimoire/GrimoireUtilitiesDetail';
import { GrimoireUtilityList } from './Grimoire/GrimoireUtilityList';
import { cls } from './Grimoire/helpers';
import type { Aspect, Data, Tab } from './Grimoire/types';

export const GrimoireAspectPicker = () => {
  const { data, act } = useBackend<Data>();
  const {
    read_only = false,
    major_aspects = [],
    minor_aspects = [],
    utility_spells = [],
    user_tier = 0,
    max_majors = 1,
    max_minors = 2,
    max_utilities = 0,
    initial_setup = true,
    attuned_majors = [],
    attuned_minors = [],
    selected_utilities = [],
    locked_aspects = [],
    staged_choices = {},
    live_choices = {},
    pointbuy_selections = {},
    spent_budgets = {},
    all_selected_spells = [],
    claimed_groups = {},
    utility_points_spent = 0,
    reset_budget = 4,
    reset_budget_max = 4,
    reset_costs = { major: 4, minor: 2, utility: 1, choice: 2 },
    staged_unbind_aspects = [],
    staged_unbind_utilities = [],
    known_utilities = [],
    given_utilities = [],
    variant_overrides = {},
  } = data;

  const [selectedPath, setSelectedPath] = useState<string | null>(null);
  const getDefaultTab = (): Tab => {
    if (max_majors > 0) return 'major';
    if (max_minors > 0) return 'minor';
    return 'utilities';
  };
  const [tab, setTab] = useState<Tab>(getDefaultTab);
  const [partialConfirmed, setPartialConfirmed] = useState(false);

  const aspects = tab === 'major' ? major_aspects : minor_aspects;
  const attuned = tab === 'major' ? attuned_majors : attuned_minors;
  const maxSlots = tab === 'major' ? max_majors : max_minors;
  const unbindCount = attuned.filter((p) =>
    staged_unbind_aspects.includes(p),
  ).length;
  const slotsUsed = attuned.length - unbindCount;
  const slotsFull = slotsUsed >= maxSlots;

  const selected = aspects.find((a) => a.path === selectedPath) || null;
  const isAttuned = selected ? attuned.includes(selected.path) : false;
  const isLocked = selected ? locked_aspects.includes(selected.path) : false;
  const isPendingUnbind = selected
    ? staged_unbind_aspects.includes(selected.path)
    : false;

  const hasAccess = (t: Tab): boolean => {
    if (read_only) return true;
    if (t === 'major') return max_majors > 0;
    if (t === 'minor') return max_minors > 0;
    if (t === 'utilities') return max_utilities > 0;
    return false;
  };

  const getPointbuyUsed = (aspect: Aspect): number => {
    // Prefer the server-computed spent total: it also counts points already spent
    // on pointbuy spells the player owns from a prior binding, which the local
    // calculation can't see. Fall back to local math for freshly-added aspects
    // where the server has nothing to report yet.
    if (aspect.path in spent_budgets) {
      return spent_budgets[aspect.path];
    }
    const selections = pointbuy_selections[aspect.path] || [];
    let total = 0;
    for (const spellPath of selections) {
      const spell = aspect.pointbuy_spells.find((s) => s.path === spellPath);
      if (spell) total += spell.cost;
    }
    return total;
  };

  const utilitiesFull = utility_points_spent >= max_utilities;

  const allFilled =
    attuned_majors.length >= max_majors && attuned_minors.length >= max_minors;
  const hasAny = attuned_majors.length > 0 || attuned_minors.length > 0;
  const hasUnbinds =
    staged_unbind_aspects.length > 0 || staged_unbind_utilities.length > 0;

  const utilityOnly = max_majors === 0 && max_minors === 0;
  const hasUnspentUtilities =
    max_utilities > 0 && utility_points_spent < max_utilities;
  const canSeal = utilityOnly
    ? utility_points_spent > 0 || hasUnbinds
    : hasAny || hasUnbinds;
  const sealReady = utilityOnly
    ? utility_points_spent >= max_utilities
    : allFilled && !hasUnspentUtilities;

  const noAct = (_action?: string, _params?: Record<string, unknown>) => {};
  const wrappedAct = read_only
    ? noAct
    : (action: string, params?: Record<string, unknown>) => {
        if (action !== 'confirm') {
          setPartialConfirmed(false);
        }
        act(action, params);
      };

  const switchTab = (t: Tab) => {
    setTab(t);
    setSelectedPath(null);
  };

  const tabAccessible = hasAccess(tab);

  const getSealLabel = (): string => {
    if (!initial_setup && hasUnbinds) {
      return sealReady ? '封印回路' : '确认变更';
    }
    if (utilityOnly) {
      return sealReady
        ? '封印回路'
        : `封印（${utility_points_spent}/${max_utilities} 点）`;
    }
    return sealReady
      ? '封印回路'
      : `封印（主法相 ${attuned_majors.length}/${max_majors}，次法相 ${attuned_minors.length}/${max_minors}）`;
  };

  return (
    <Window width={860} height={580} title="魔法书" theme="grimoire">
      <Window.Content fitted>
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            height: '100%',
          }}
        >
          <div style={{ flex: 1, display: 'flex', minHeight: 0 }}>
            {/* Left page */}
            <div
              className="AspectPicker__page"
              style={{ width: '280px', flexShrink: 0, padding: '8px' }}
            >
              <GrimoireTabBar
                tab={tab}
                hasAccess={hasAccess}
                switchTab={switchTab}
              />

              {tab !== 'utilities' && (
                <div className="AspectPicker__slot-display">
                  {read_only
                    ? '奥术全书'
                    : tabAccessible
                      ? `已绑定 ${slotsUsed} / ${maxSlots}`
                      : '仅供浏览'}
                </div>
              )}
              {tab === 'utilities' && (
                <div className="AspectPicker__slot-display">
                  {read_only
                    ? '奥术全书'
                    : tabAccessible
                      ? `${utility_points_spent} / ${max_utilities} 点`
                      : '仅供浏览'}
                </div>
              )}

              {tab !== 'utilities' && (
                <GrimoireChapterList
                  aspects={aspects}
                  attuned={tabAccessible ? attuned : []}
                  locked={tabAccessible ? locked_aspects : []}
                  pendingUnbinds={tabAccessible ? staged_unbind_aspects : []}
                  selectedPath={selectedPath}
                  onSelect={setSelectedPath}
                />
              )}

              {tab === 'utilities' && tabAccessible && (
                <GrimoireUtilityList
                  spells={utility_spells}
                  selected={selected_utilities}
                  known={known_utilities}
                  givenUtilities={given_utilities}
                  pendingUnbinds={staged_unbind_utilities}
                  isFull={utilitiesFull}
                  pointsSpent={utility_points_spent}
                  pointsBudget={max_utilities}
                  initialSetup={initial_setup}
                  resetBudget={reset_budget}
                  utilityUnbindCost={reset_costs.utility}
                  allSelectedSpells={all_selected_spells}
                  act={wrappedAct}
                  readOnly={read_only}
                />
              )}
            </div>

            {/* Spine */}
            <div className="AspectPicker__spine" />

            {/* Right page */}
            <div
              className="AspectPicker__page"
              style={{
                flex: 1,
                padding: '12px 16px',
                display: 'flex',
                flexDirection: 'column',
              }}
            >
              {tab === 'utilities' ? (
                tabAccessible ? (
                  <GrimoireUtilitiesDetail
                    spells={utility_spells}
                    selected={selected_utilities}
                    known={known_utilities}
                    pendingUnbinds={staged_unbind_utilities}
                    pointsSpent={utility_points_spent}
                    pointsBudget={max_utilities}
                    initialSetup={initial_setup}
                    resetBudget={reset_budget}
                    resetBudgetMax={reset_budget_max}
                    readOnly={read_only}
                  />
                ) : (
                  <div className="AspectPicker__empty">
                    你无法使用实用法术。
                  </div>
                )
              ) : !tabAccessible ? (
                selected ? (
                  <GrimoireAspectDetail
                    aspect={selected}
                    isAttuned={false}
                    isLocked={true}
                    isPendingUnbind={false}
                    slotsFull={true}
                    tab={tab}
                    userTier={user_tier}
                    initialSetup={initial_setup}
                    resetBudget={0}
                    resetCosts={reset_costs}
                    stagedChoices={{}}
                    liveChoices={{}}
                    pointbuySelections={{}}
                    allSelectedSpells={all_selected_spells}
                    claimedGroups={claimed_groups}
                    getPointbuyUsed={getPointbuyUsed}
                    act={() => {}}
                    readOnly
                    variantOverride={variant_overrides[selected.path]}
                  />
                ) : (
                  <div className="AspectPicker__empty">
                    你无法使用{tab === 'major' ? '主' : '次'}法相。
                    <br />
                    选择修习之道以浏览其法术。
                  </div>
                )
              ) : selected ? (
                <GrimoireAspectDetail
                  aspect={selected}
                  isAttuned={isAttuned}
                  isLocked={isLocked}
                  isPendingUnbind={isPendingUnbind}
                  slotsFull={slotsFull}
                  tab={tab}
                  userTier={user_tier}
                  initialSetup={initial_setup}
                  resetBudget={reset_budget}
                  resetCosts={reset_costs}
                  stagedChoices={staged_choices}
                  liveChoices={live_choices}
                  pointbuySelections={pointbuy_selections}
                  allSelectedSpells={all_selected_spells}
                  claimedGroups={claimed_groups}
                  getPointbuyUsed={getPointbuyUsed}
                  act={wrappedAct}
                  readOnly={read_only}
                  variantOverride={variant_overrides[selected.path]}
                />
              ) : (
                <div className="AspectPicker__empty">
                  选择修习之道以阅读对应章节。
                </div>
              )}
            </div>
          </div>

          {/* Footer bar - hidden in read-only mode */}
          {!read_only && (
            <div
              style={{
                padding: '4px 0 0 0',
                display: 'flex',
                gap: '8px',
                alignItems: 'center',
              }}
            >
              {!initial_setup && (
                <div className="AspectPicker__reset-budget">
                  重塑额度：{reset_budget} / {reset_budget_max}
                </div>
              )}
              <div
                className={cls(
                  'AspectPicker__action-btn',
                  sealReady && 'AspectPicker__action-btn--confirm',
                  canSeal && !sealReady && 'AspectPicker__action-btn--caution',
                  !canSeal && 'AspectPicker__action-btn--disabled',
                )}
                style={{ flex: 1 }}
                onClick={
                  canSeal
                    ? () => {
                        if (!sealReady && initial_setup && !partialConfirmed) {
                          setPartialConfirmed(true);
                          return;
                        }
                        wrappedAct('confirm');
                      }
                    : undefined
                }
              >
                {!sealReady && partialConfirmed
                  ? allFilled && hasUnspentUtilities
                    ? '确定跳过剩余实用法术？'
                    : '仅绑定当前选择——重新绑定需要魔法书！'
                  : getSealLabel()}
              </div>
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

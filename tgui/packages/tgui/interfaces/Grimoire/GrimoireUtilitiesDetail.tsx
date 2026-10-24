import type { Spell } from './types';

export const GrimoireUtilitiesDetail = ({
  spells,
  selected,
  known,
  pendingUnbinds,
  pointsSpent,
  pointsBudget,
  initialSetup,
  resetBudget,
  resetBudgetMax = 4,
  readOnly = false,
}: {
  spells: Spell[];
  selected: string[];
  known: string[];
  pendingUnbinds: string[];
  pointsSpent: number;
  pointsBudget: number;
  initialSetup: boolean;
  resetBudget: number;
  resetBudgetMax?: number;
  readOnly?: boolean;
}) => (
  <div style={{ flex: 1, overflowY: 'auto' }}>
    <div className="AspectPicker__heading">戏法与实用法术</div>
    <div className="AspectPicker__fluff">
      奥术中的小技艺：简单附魔、实用
      戏法与便于学者研究的手段，无需特定
      法相协调。
    </div>
    <div className="AspectPicker__divider" />
    <div className="AspectPicker__section-label">
      已用点数 {pointsSpent} / {pointsBudget}
      {!readOnly && !initialSetup && (
        <span style={{ marginLeft: '12px' }}>
          （重塑额度：{resetBudget} / {resetBudgetMax}）
        </span>
      )}
    </div>
    {spells.map((spell) => {
      const isSelected = selected.includes(spell.path);
      const isKnown = known.includes(spell.path);
      const isPendingUnbind = pendingUnbinds.includes(spell.path);
      return (
        <div key={spell.path} className="AspectPicker__spell-entry">
          <span
            className="AspectPicker__spell-name"
            style={
              isPendingUnbind
                ? { textDecoration: 'line-through', opacity: 0.6 }
                : undefined
            }
          >
            {spell.name}
          </span>
          <span
            className="AspectPicker__spell-desc"
            style={{ marginLeft: '6px' }}
          >
            {spell.cost > 0 ? `（${spell.cost} 点）` : '（免费）'}
          </span>
          {isSelected && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px' }}
            >
              已铭刻
            </span>
          )}
          {isKnown && !isPendingUnbind && !isSelected && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px' }}
            >
              已学会
            </span>
          )}
          {isPendingUnbind && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px', color: 'rgba(200,100,100,0.8)' }}
            >
              待解除
            </span>
          )}
          {spell.desc && (
            <div
              className="AspectPicker__spell-desc"
              dangerouslySetInnerHTML={{ __html: spell.desc }}
            />
          )}
        </div>
      );
    })}
  </div>
);

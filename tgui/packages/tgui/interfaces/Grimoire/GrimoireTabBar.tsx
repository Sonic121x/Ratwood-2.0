import { cls } from './helpers';
import type { Tab } from './types';

export const GrimoireTabBar = ({
  tab,
  hasAccess,
  switchTab,
}: {
  tab: Tab;
  hasAccess: (t: Tab) => boolean;
  switchTab: (t: Tab) => void;
}) => (
  <div className="AspectPicker__tab-bar">
    {(['major', 'minor', 'utilities'] as Tab[]).map((t) => {
      const accessible = hasAccess(t);
      const label =
        t === 'major' ? '主法相' : t === 'minor' ? '次法相' : '实用法术';
      return (
        <span
          key={t}
          className={cls(
            'AspectPicker__tab',
            tab === t && 'AspectPicker__tab--active',
            !accessible && 'AspectPicker__tab--locked',
          )}
          onClick={() => switchTab(t)}
        >
          {label}
        </span>
      );
    })}
  </div>
);

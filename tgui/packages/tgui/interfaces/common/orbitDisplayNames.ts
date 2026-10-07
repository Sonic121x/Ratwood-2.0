const GROUP_LABELS: Record<string, string> = {
  Noblemen: '贵族',
  Courtiers: '廷臣',
  Garrison: '驻军',
  Church: '教会',
  Inquisition: '宗教审判所',
  Yeomen: '自耕民',
  Guildsmen: '行会成员',
  Peasants: '农民',
  Sidefolk: '边缘居民',
  Wanderers: '漫游者',
  Tribe: '部族',
  Major: '主要反派',
  Minor: '次要反派',
  Necromancer: '死灵法师',
  Vampires: '吸血鬼',
  Werewolves: '狼人',
  Lich: '巫妖',
  Unassigned: '未分配职业',
};

export const displayOrbitGroup = (label: string, displayRole?: string, originalRole?: string) =>
  label.split(' - ').map((part) => part === originalRole && displayRole ? displayRole : GROUP_LABELS[part] ?? part).join(' - ');

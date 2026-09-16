const deductionsLabel = (
  showLevy: boolean,
  showGuildCut: boolean,
): string | null => {
  if (showLevy && showGuildCut) return "王室关税与行会抽成";
  if (showLevy) return "王室关税";
  if (showGuildCut) return "行会抽成";
  return null;
};

export const RewardClause = (props: {
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
}) => {
  const { reward, levyRate, levyExempt, guildCutRate } = props;
  const showLevy = !levyExempt && levyRate > 0;
  const showGuildCut = guildCutRate > 0;
  const effectiveLevy = showLevy ? levyRate : 0;
  const net = Math.round(reward * (1 - effectiveLevy - guildCutRate));
  const deductions = deductionsLabel(showLevy, showGuildCut);
  return (
    <>
      <b>{reward} 玛门</b>
      {deductions ? (
        <>
          , 扣除{deductions}后为 <b>{net} 玛门</b>
        </>
      ) : null}
    </>
  );
};

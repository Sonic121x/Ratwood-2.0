import { SEAL_AMBER, SEAL_GREEN, SEAL_RED } from '../common/parchment';
import {
  Breakdown,
  compactCardStyle,
  dividedTwoColumnLayout,
  dividerStyle,
  Row,
  SectionTitle,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type { ContractsSnapshot, RoyalFavorsSnapshot } from './types';

type Props = {
  c: ContractsSnapshot;
  rf: RoyalFavorsSnapshot;
};

const ContractsColumn = (props: { c: ContractsSnapshot }) => {
  const { c } = props;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="已发布契约" value={c.generated_total} />
        </tbody>
      </table>
      <Breakdown>
        公会 {c.generated_pool} &bull; 酒馆 {c.generated_rumor} &bull; 王室{' '}
        {c.generated_defense}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="已接取契约" value={c.taken_total} />
        </tbody>
      </table>
      <Breakdown>
        公会 {c.taken_pool} &bull; 酒馆 {c.taken_rumor} &bull; 王室{' '}
        {c.taken_defense}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row
            label="已完成契约"
            value={c.completed_total}
            color={SEAL_GREEN}
          />
        </tbody>
      </table>
      <Breakdown>
        公会 {c.completed_pool} &bull; 酒馆 {c.completed_rumor} &bull; 王室{' '}
        {c.completed_defense}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="已放弃" value={c.abandoned} />
          <Row label="已重置" value={c.rerolled} />
        </tbody>
      </table>
    </div>
  );
};

const FavorsColumn = (props: { c: ContractsSnapshot; rf: RoyalFavorsSnapshot }) => {
  const { c, rf } = props;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="已支付玛门" value={c.mammons_paid} />
          <Row label="已征税玛门" value={c.mammons_taxed} />
          <Row
            label="已没收玛门"
            value={c.mammons_forfeited}
            color={SEAL_RED}
          />
        </tbody>
      </table>
      <div style={dividerStyle} />
      <table style={twoColTable}>
        <tbody>
          <Row label="获得认捐" value={rf.pledge_generated} />
          <Row label="消耗认捐" value={rf.pledge_consumed} />
          <Row
            label="剩余认捐"
            value={rf.pledge_unused}
            color={SEAL_AMBER}
          />
          <Row label="获得传闻点数" value={rf.rumor_generated} />
          <Row label="消耗传闻点数" value={rf.rumor_consumed} />
          <Row
            label="剩余传闻点数"
            value={rf.rumor_unused}
            color={SEAL_AMBER}
          />
        </tbody>
      </table>
    </div>
  );
};

export const ContractsSection = (props: Props) => {
  return (
    <div style={compactCardStyle}>
      <SectionTitle>公会契约 &amp; 王室恩惠</SectionTitle>
      <div style={dividedTwoColumnLayout}>
        <ContractsColumn c={props.c} />
        <div style={verticalDividerStyle} />
        <FavorsColumn c={props.c} rf={props.rf} />
      </div>
    </div>
  );
};

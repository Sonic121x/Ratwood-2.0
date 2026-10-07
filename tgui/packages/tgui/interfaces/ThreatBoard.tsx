import { Box, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { DANGER_LEVEL_LABELS } from './common/displayNames';

type Data = {
  threat_regions: {
    region_name: string;
    danger_level: string;
    danger_color: string;
  }[];
}

export const ThreatBoard = (props) => {
  const { data } = useBackend<Data>();

  return (
    <Box>
      威胁概况
      {data.threat_regions.map((region) => (
        <Section key={region.region_name}>
          <h3>{region.region_name}</h3>
          <p>危险等级：{DANGER_LEVEL_LABELS[region.danger_level] ?? region.danger_level}</p>
        </Section>
      ))}
    </Box>
  );
};

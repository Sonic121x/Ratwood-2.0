import { useState } from 'react';

import {
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK_FAINT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
} from '../../common/parchment';
import { type TabProps } from '../types';

const formatCooldown = (seconds: number) => {
  const minutes = Math.ceil(seconds / 60);
  return `${minutes} 分钟`;
};

export const BathhouseOrdinanceSection = ({
  data,
  act,
}: {
  data: TabProps['data'];
  act: TabProps['act'];
}) => {
  const active = !!data.bathhouse_ordinance_active;
  const tithed = data.bathhouse_tithe_round_total ?? 0;
  const cooldownSeconds = data.bathhouse_ordinance_cooldown_seconds ?? 0;
  const onCooldown = cooldownSeconds > 0;
  const [confirming, setConfirming] = useState(false);
  const [expanded, setExpanded] = useState(false);

  const primaryLabel = active ? '废止敕令' : '恢复敕令';
  const confirmLabel = active
    ? '确认：废止敕令'
    : '确认：恢复敕令';

  return (
    <>
      <div style={sectionHeaderStyle}>浴场敕令</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>状态</div>
        <div style={fieldValueStyle}>
          {active ? (
            <span style={{ color: SEAL_GREEN, fontWeight: 'bold' }}>
              施行中
            </span>
          ) : (
            <span style={{ color: SEAL_RED, fontWeight: 'bold' }}>
              已废止
            </span>
          )}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>本周什一税</div>
        <div style={fieldValueStyle}>
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {tithed}m
          </span>{' '}
          已献予教会。
        </div>
      </div>
      <div style={{ marginBottom: 8 }}>
        <button
          type="button"
          style={{
            ...inkButtonStyle({}),
            fontSize: FONT_BODY,
            padding: '2px 6px',
          }}
          onClick={() => setExpanded((v) => !v)}
        >
          {expanded ? '收起敕令 ▴' : '阅读敕令 ▾'}
        </button>
        {expanded && (
          <div
            style={{
              color: SEAL_AMBER,
              marginTop: 6,
              fontSize: FONT_BODY,
              lineHeight: 1.4,
            }}
          >
            <p style={{ margin: '0 0 6px 0' }}>
              {
                '承王权所授的古老特权，全境浴场皆立于主教辖下的自由之地。浴场主不向王权库银缴纳任何租赋或规费；反之，凡草药与膏药之售卖，浴场主应献十分之一，凡因提供服务而得的常规收入，应献五分之一，皆献予教会。浴场当如伊欧拉圣火的炉台，为入内的孤苦与疲惫者施以慰藉与安宁，为那些自由相爱并将其施予他人者提供安全劳作之所，使其得以谋生，并将浴场之劳作计入女神自身的功业，蒙其青睐。故此教会以刀剑与律法将浴场纳入庇护。只要敕令犹存，王权便对浴场无任何主张，其至圣之功业唯归教会专属管辖。'
              }
            </p>
            <p style={{ margin: '0 0 4px 0' }}>
              {
                '浴场主则应有序地为孤苦与疲惫者提供慰藉；并须遵守以下条令：'
              }
            </p>
            <ul style={{ margin: '0 0 6px 16px', padding: 0 }}>
              <li style={{ marginBottom: 4 }}>
                {
                  '禁止售卖或贩运强于至纯月尘与奥兹姆的任何药剂或烟品，以免任何宾客神智昏乱而忘却十神的教诲。违者罚没一枚兹利夸。'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  '不得为盗贼或逃犯提供庇护，无论在浴池之内还是其下。违者罚没一枚泽尼，不义之财没入教会以作补偿。'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  '浴场内不得容留任何假信之名下的公然丑闻。若有侍者或宾客沉溺于放荡纵欲或邪祀之败行，浴场主应以最隐秘的方式告知教会，并将此等灵魂交付教会照管 - 使其得再见伊欧拉慈爱之光。只要无人受害，闭门之后所为之事，敕令不予干涉；因伊欧拉已赐予其信众私下相爱与亲密之礼，此亦蒙其青睐。'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  '对于身负战伤或朝圣印记却无钱可付者，不得将其拒之门外，而应每周一次免费为其提供公共浴池。若未尽此慈悲，浴场主应罚没一枚泽尼，没入教会的施舍之资。'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  '不得给予任何醉客超出其承受量的酒液；不得在单次坐席间为任何宾客提供超过五次的膏药嗅吸；不得容许任何人服用超出身体所能承受的药剂，以免其在寿数未到之前便陷入抽搐、谵妄，或投入内克拉的怀抱。若有宾客以此等状态被抬出，浴场主须为其负责，亦应向亡者亲族，或须为其施救的教会，献上教会认为合宜的赔偿。'
                }
              </li>
            </ul>
            <p style={{ margin: '0 0 6px 0' }}>
              {
                '若条令遭到违反，教会可撤销其认可，或按其认为合宜的方式索取赔偿；黄铜面将重归王权关税之下，而浴场常规收入之事，此后仅由浴场主与王权之间处置。'
              }
            </p>
            <p style={{ margin: 0, color: INK_FAINT }}>
              {
                '主教与浴场主各自持有印记。二者皆可废止或恢复敕令；但皆不得在短时间内连续为之两次。'
              }
            </p>
          </div>
        )}
      </div>
      {onCooldown && (
        <div
          style={{
            color: INK_FAINT,
            marginBottom: 8,
            fontSize: FONT_BODY,
          }}
        >
          蜡上的印记余温未消。浴场敕令需再过{' '}
          {formatCooldown(cooldownSeconds)}方可重新审议。
        </div>
      )}
      <div
        style={{
          marginTop: 6,
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'flex-end',
          gap: 6,
        }}
      >
        {confirming && (
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() => setConfirming(false)}
          >
            取消
          </button>
        )}
        <button
          type="button"
          style={inkButtonStyle({ disabled: onCooldown })}
          disabled={onCooldown}
          onClick={() => {
            if (!confirming) {
              setConfirming(true);
              return;
            }
            act('toggle_bathhouse_ordinance');
            setConfirming(false);
          }}
        >
          {confirming ? confirmLabel : primaryLabel}
        </button>
      </div>
    </>
  );
};

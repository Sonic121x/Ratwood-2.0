import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BeastWrit } from './QuestScroll/BeastWrit';
import { CarriageWrit } from './QuestScroll/CarriageWrit';
import { DrowWrit } from './QuestScroll/DrowWrit';
import { GoblinoidWrit } from './QuestScroll/GoblinoidWrit';
import { GronnWrit } from './QuestScroll/GronnWrit';
import { HumanoidWrit } from './QuestScroll/HumanoidWrit';
import {
  BlockadeTimer,
  Marginalia,
  ProgressLine,
  RetrievalProgressLine,
  WhisperLine,
} from './QuestScroll/Marginalia';
import { RecoveryWrit } from './QuestScroll/RecoveryWrit';
import {
  COMMISSION_SEAL,
  EXEMPT_SEAL,
  SealBannerView,
} from './QuestScroll/Seals';
import type { QuestScrollData } from './QuestScroll/shared';
import {
  completionStamp,
  divider,
  FACTION_CAT_BEAST,
  FACTION_CAT_DROW,
  FACTION_CAT_GOBLINOID,
  FACTION_CAT_GRONN,
  FACTION_CAT_UNDEAD,
  failedStamp,
  marginaliaLine,
  parchment,
  titleHint,
  WRIT_TYPE_CARRIAGE,
  WRIT_TYPE_RECOVERY,
  WRIT_TYPE_TOWNER,
  writBody,
} from './QuestScroll/shared';
import { TownerWrit } from './QuestScroll/TownerWrit';
import { UndeadWrit } from './QuestScroll/UndeadWrit';

type MarginaliaSectionProps = {
  data: QuestScrollData;
  showProgress: boolean;
  hasWhisper: boolean;
  hasBlockadeTimer: boolean;
  hasHuntTimer: boolean;
};

const MarginaliaSection = (props: MarginaliaSectionProps) => {
  const { data, showProgress, hasWhisper, hasBlockadeTimer, hasHuntTimer } =
    props;
  return (
    <Marginalia>
      {hasWhisper && (
        <WhisperLine
          compass={data.compass_direction || ''}
          zHint={data.z_hint}
        />
      )}
      {showProgress &&
        (data.writ_type === WRIT_TYPE_RECOVERY ? (
          <RetrievalProgressLine
            done={data.progress_current ?? 0}
            total={data.progress_required ?? 1}
            noun={
              data.fetch_item ? `${data.fetch_item}s` : '国度之货物'
            }
          />
        ) : (
          <ProgressLine
            done={data.progress_current ?? 0}
            total={data.progress_required ?? 1}
            noun={data.faction_progress_noun || '敌寇'}
          />
        ))}
      {hasBlockadeTimer && (
        <BlockadeTimer
          label={data.blockade_timer_label || ''}
          seconds={data.blockade_timer_seconds ?? 0}
        />
      )}
      {hasHuntTimer && (
        <BlockadeTimer
          label={data.hunt_timer_label || ''}
          seconds={data.hunt_timer_seconds ?? 0}
        />
      )}
      {!!data.blockade_armed && !data.blockade_timer_label && (
        <div style={marginaliaLine}>
          <i>前往封锁线, 抵达之时敌潮即至.</i>
        </div>
      )}
      {!!data.is_towner && !data.complete && (
        <div style={marginaliaLine}>
          <i>
            唯有 {data.issued_by || '悬赏人'} 能开启你寻回之物 -
            将其带回交予他.
          </i>
        </div>
      )}
    </Marginalia>
  );
};

type WritBodyProps = {
  data: QuestScrollData;
  realm: string;
  rulerTitle: string;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  bearer?: string;
  issuedBy?: string;
  crimes: string[];
  hasRecoveryAddendum: boolean;
};

const WritBody = (props: WritBodyProps) => {
  const {
    data,
    realm,
    rulerTitle,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    bearer,
    issuedBy,
    crimes,
    hasRecoveryAddendum,
  } = props;
  const sealProps = {
    rulerTitle,
    issuedBy,
    issuedOn: data.issued_on,
    bearer,
  };
  const factionGroupProps = {
    groupWord: data.faction_group_word,
    namePlural: data.faction_name_plural,
  };
  const namedProps = {
    named: data.named_target,
    ringleader: data.band_leader,
  };
  const rewardProps = { reward, levyRate, levyExempt, guildCutRate };
  const recoveryProps = {
    hasRecoveryAddendum,
    recoveryShipment: data.recovery_shipment,
    recoveryDestination: data.delivery_destination,
    recoveryCircumstance: data.circumstance,
  };

  if (data.writ_type === WRIT_TYPE_RECOVERY) {
    return (
      <RecoveryWrit
        realm={realm}
        circumstance={data.circumstance}
        pickupRegion={data.pickup_region}
        fetchItem={data.fetch_item}
        fetchCount={data.fetch_count}
        {...rewardProps}
        {...sealProps}
      />
    );
  }
  if (data.writ_type === WRIT_TYPE_CARRIAGE) {
    return (
      <CarriageWrit
        realm={realm}
        circumstance={data.circumstance}
        pickupRegion={data.pickup_region}
        destination={data.delivery_destination}
        deliveryItem={data.delivery_item}
        {...rewardProps}
        {...sealProps}
      />
    );
  }
  if (data.writ_type === WRIT_TYPE_TOWNER) {
    return (
      <TownerWrit
        intro={data.towner_intro}
        sealNote={data.towner_seal_note}
        {...rewardProps}
        {...sealProps}
      />
    );
  }
  switch (data.faction_category) {
    case FACTION_CAT_BEAST:
      return (
        <BeastWrit
          nameSingular={data.faction_name_singular}
          realm={realm}
          crimes={crimes}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_UNDEAD:
      return (
        <UndeadWrit
          realm={realm}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_GOBLINOID:
      return (
        <GoblinoidWrit
          realm={realm}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_GRONN:
      return (
        <GronnWrit
          realm={realm}
          crimes={crimes}
          {...namedProps}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_DROW:
      return (
        <DrowWrit
          realm={realm}
          crimes={crimes}
          {...namedProps}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    default:
      return (
        <HumanoidWrit
          realm={realm}
          {...namedProps}
          {...factionGroupProps}
          crimes={crimes}
          sacralInvoked={!!data.sacral_invoked}
          oathBreach={!!data.oath_breach}
          condemnation={data.condemnation || undefined}
          {...recoveryProps}
          {...rewardProps}
          {...sealProps}
        />
      );
  }
};

export const QuestScroll = () => {
  const { data } = useBackend<QuestScrollData>();

  if (data.empty) {
    return (
      <Window title="契约卷轴" width={520} height={620} theme="parchment">
        <Window.Content scrollable>
          <div style={parchment}>
            <div style={{ textAlign: 'center', fontStyle: 'italic' }}>
              此卷轴未载有任何生效中的契约.
            </div>
          </div>
        </Window.Content>
      </Window>
    );
  }

  const realm = data.realm_name || '国度';
  const levyRate = data.levy_rate ?? 0;
  const levyExempt = !!data.levy_exempt;
  const guildCutRate = data.guild_cut_rate ?? 0;
  const rulerTitle = data.ruler_title || '公爵';
  const reward = data.reward ?? 0;
  const bearer = data.issued_to || undefined;
  const issuedBy = data.issued_by || undefined;
  const crimes = data.crimes || [];
  const showProgress =
    !!data.progress_required &&
    data.progress_required > 1 &&
    typeof data.progress_current === 'number' &&
    !data.complete;
  const hasWhisper = !!data.compass_direction;
  const hasBlockadeTimer =
    !!data.blockade_timer_label && (data.blockade_timer_seconds ?? 0) > 0;
  const hasHuntTimer =
    !!data.hunt_timer_label && (data.hunt_timer_seconds ?? 0) > 0;
  const hasTownerSeal = !!data.is_towner && !data.complete;
  const hasMarginalia =
    hasWhisper ||
    showProgress ||
    hasBlockadeTimer ||
    hasHuntTimer ||
    !!data.blockade_armed ||
    hasTownerSeal;
  const hasSealBanners = !!(data.is_defense || data.levy_exempt);

  const isOutlawry =
    data.writ_type !== WRIT_TYPE_RECOVERY &&
    data.writ_type !== WRIT_TYPE_CARRIAGE &&
    data.writ_type !== WRIT_TYPE_TOWNER;
  const hasRecoveryAddendum = isOutlawry && !!data.recovery_shipment;

  return (
    <Window title="契约卷轴" width={520} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={parchment}>
          {data.title && <div style={titleHint}>{data.title}</div>}

          <div style={writBody}>
            <WritBody
              data={data}
              realm={realm}
              rulerTitle={rulerTitle}
              reward={reward}
              levyRate={levyRate}
              levyExempt={levyExempt}
              guildCutRate={guildCutRate}
              bearer={bearer}
              issuedBy={issuedBy}
              crimes={crimes}
              hasRecoveryAddendum={hasRecoveryAddendum}
            />
          </div>

          {hasMarginalia && (
            <MarginaliaSection
              data={data}
              showProgress={showProgress}
              hasWhisper={hasWhisper}
              hasBlockadeTimer={hasBlockadeTimer}
              hasHuntTimer={hasHuntTimer}
            />
          )}

          {data.complete ? (
            <>
              <hr style={divider} />
              <div style={completionStamp}>此事已毕</div>
              <div style={{ textAlign: 'center', marginTop: '6px' }}>
                将此令状交回契约台账以领取赏金.
              </div>
              <div
                style={{
                  textAlign: 'center',
                  fontStyle: 'italic',
                  fontSize: '0.9em',
                  marginTop: '4px',
                  color: 'hsl(30, 35%, 40%)',
                }}
              >
                将其置于标记之处, 或放上契约台账.
              </div>
            </>
          ) : data.blockade_failed ? (
            <>
              <hr style={divider} />
              <div style={failedStamp}>
                封锁得守, 此令状已然失效
              </div>
            </>
          ) : null}

          {!!data.levy_exempt && (
            <>
              <hr style={divider} />
              <div
                style={{
                  textAlign: 'center',
                  fontStyle: 'italic',
                  color: 'hsl(130, 45%, 28%)',
                  fontSize: '0.92em',
                }}
              >
                依王室之印与公爵之特权, 此令状之持有者
                豁免其赏金所应纳之王室关税.
              </div>
            </>
          )}

          {hasSealBanners && (
            <div
              style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'flex-start',
                gap: '4px',
                marginTop: '18px',
              }}
            >
              {!!data.is_defense && <SealBannerView seal={COMMISSION_SEAL} />}
              {!!data.levy_exempt && <SealBannerView seal={EXEMPT_SEAL} />}
            </div>
          )}

          {!!data.target_region && (
            <div
              style={{
                textAlign: 'center',
                fontStyle: 'italic',
                fontSize: '0.88em',
                color: 'hsl(30, 35%, 40%)',
                marginTop: '14px',
              }}
            >
              此事位于 {data.target_region} 之内.
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

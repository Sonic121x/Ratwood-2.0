import { useState } from 'react';
import { Box, Button, Icon, Section } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { DragSlider } from '../../../components';
import { HEADSHOT_PANEL_SIZE } from '../../common/HeadshotFrame';
import { pictureSizeLimitText } from '../../common/pictureSize';
import { useGalleryBackend } from '../galleryBackend';
import { LinkControls, MediaStatus } from '../LinkRow';
import { HEADSHOT_SLOT } from '../slots';
import type { ImageForm } from '../types';
import { useMediaStatus } from '../useMediaStatus';
import { ChatAppearance } from './ChatAppearance';
import { overflowsAxis, zoomCeiling, zoomLimits } from './framing';
import { FramingCanvas } from './FramingCanvas';
import { useFramingDraft } from './useFramingDraft';

/** The zoom limit in percent of even the smallest picture, however blurry that gets. */
const ZOOM_LIMIT_MIN = 300;
const BLUR_WARNING_ENLARGEMENT = 1.5;

const arrowKeys = (
  <>
    <kbd>←</kbd> <kbd>↑</kbd> <kbd>↓</kbd> <kbd>→</kbd>
  </>
);

/** The position sliders in the order they show */
const POSITION_AXES = [
  {
    axis: 0,
    field: 'x',
    label: '水平位置',
    hint: '0 对应图片左端，100 对应右端。',
    direction: '水平',
  },
  {
    axis: 1,
    field: 'y',
    label: '垂直位置',
    hint: '0 对应图片顶端，100 对应底端。',
    direction: '垂直',
  },
] as const;

export const HeadshotSection = (props: { form: ImageForm }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form } = props;
  const busy = isBusy(form.id);
  const media = useMediaStatus(form.headshot);
  const { retry } = media;
  const size = media.tooLarge ? null : media.size;
  const unloaded =
    media.tooLarge && media.size ? pictureSizeLimitText(...media.size) : null;
  const [showSliders, setShowSliders] = useState(false);
  const draft = useFramingDraft(form);
  const { framing, committed, follow, commit, abandon, discard } = draft;

  const { sharpZoom, zoomLimit } = zoomLimits(
    size,
    HEADSHOT_PANEL_SIZE,
    ZOOM_LIMIT_MIN,
    data.zoom_max,
  );
  const blurry =
    media.ready && framing.zoom > sharpZoom * BLUR_WARNING_ENLARGEMENT;
  const sharpNote =
    sharpZoom >= data.zoom_min
      ? ` 放大至 ${Math.min(sharpZoom, data.zoom_max)}% 以内仍可保持清晰。`
      : '';
  // Given to FramingSlider as busy, which keeps each slider in place but inert and dimmed, never folded into enabled,
  // whose false swaps the slider for its unavailable note. Folded in, the sliders flip to the note and back while a
  // new picture loads
  const slidersLocked = busy || (!!size && !media.ready);

  const urlButton = (
    <Box mt={0.5}>
      <Button
        fluid
        textAlign="center"
        icon={form.headshot ? 'pen' : 'plus'}
        disabled={busy}
        onClick={() => act('set_headshot', { form: form.id })}
      >
        {form.headshot ? '更改头像链接' : '添加头像链接'}
      </Button>
    </Box>
  );

  if (!form.headshot) {
    return (
      <Section title="头像">
        <div className="CharacterGallery__headshot">
          <div className="CharacterGallery__headshotColumn">
            <div className="CharacterGallery__headshotEmpty">暂无头像</div>
            {urlButton}
            {form.undo.includes(HEADSHOT_SLOT) && (
              <Box mt={0.5}>
                <Button
                  fluid
                  textAlign="center"
                  icon="undo"
                  disabled={busy}
                  onClick={() =>
                    act('undo_image', { form: form.id, image: HEADSHOT_SLOT })
                  }
                >
                  撤销
                </Button>
              </Box>
            )}
          </div>
        </div>
      </Section>
    );
  }

  return (
    <>
      <Section title="头像取景">
        <div className="CharacterGallery__headshot">
          <div
            inert={busy}
            className={classes([
              'CharacterGallery__headshotColumn',
              busy && 'CharacterGallery__busy',
            ])}
          >
            <FramingCanvas
              form={form}
              media={media}
              draft={draft}
              zoomLimit={zoomLimit}
            />
            {urlButton}
            {!!media.size && (
              <Box color="label" mt={0.5} textAlign="center">
                {media.ready
                  ? `${media.size[0]} × ${media.size[1]}`
                  : '正在加载……'}
              </Box>
            )}
            {blurry && (
              <Box color="average" mt={0.5} textAlign="center">
                <Icon name="exclamation-triangle" mr={0.5} />
                在详细检视面板中可能模糊
              </Box>
            )}
            <Box color="label" mt={1} textAlign="center">
              详细检视面板始终使用此方形头像。
            </Box>
          </div>
          <div className="CharacterGallery__framing">
            <MediaStatus
              media={media}
              statusMt={0.5}
              loading="正在加载头像……"
              retrying="正在重新加载头像……"
              error="图片加载失败，请检查链接。"
              retryText="重新加载头像"
            />
            <Box mt={1}>
              <FramingSlider
                key={draft.discards}
                label="缩放"
                busy={slidersLocked}
                hint={`以当前取景位置为中心放大图片。${sharpNote}`}
                value={framing.zoom}
                minValue={data.zoom_min}
                maxValue={zoomCeiling(committed.zoom, zoomLimit)}
                enabled={!!size}
                unavailable={unloaded ?? '加载图片后即可缩放。'}
                onDrag={(zoom) => follow({ zoom })}
                onChange={(zoom) => commit({ zoom })}
                onAbandon={abandon}
              />
            </Box>
            <div className="CharacterGallery__headshotControlRow">
              <Box color="label">取景</Box>
              <div className="CharacterGallery__framingActions">
                <Button
                  icon={showSliders ? 'chevron-up' : 'chevron-down'}
                  selected={showSliders}
                  aria-expanded={showSliders}
                  tooltip="使用滑块调整图片位置，无需拖动图片。"
                  onClick={() => setShowSliders(!showSliders)}
                >
                  位置调节
                </Button>
                <Button
                  icon="undo"
                  disabled={busy}
                  tooltip="恢复默认方形取景框，从图片顶部取景。"
                  onClick={() => {
                    discard();
                    act('reset_framing', { form: form.id });
                  }}
                >
                  重置取景
                </Button>
              </div>
            </div>
            {showSliders && (
              <Box mt={0.5}>
                {POSITION_AXES.map((slider) => (
                  <FramingSlider
                    key={`${slider.field}:${draft.discards}`}
                    label={slider.label}
                    busy={slidersLocked}
                    hint={slider.hint}
                    value={framing[slider.field]}
                    enabled={overflowsAxis(size, framing.zoom, slider.axis)}
                    unavailable={
                      !size
                        ? (unloaded ?? '加载图片后即可调整位置。')
                        : `放大后可${slider.direction}移动。`
                    }
                    onDrag={(value) => follow({ [slider.field]: value })}
                    onChange={(value) => commit({ [slider.field]: value })}
                    onAbandon={abandon}
                  />
                ))}
              </Box>
            )}
            <div className="CharacterGallery__headshotControlRow">
              <Box color="label">图片</Box>
              <LinkControls
                label="头像"
                disabled={busy}
                url={form.headshot}
                onClear={() => act('clear_headshot', { form: form.id })}
                form={form}
                image={HEADSHOT_SLOT}
                keepSwapMargin
              />
            </div>
            <details className="CharacterGallery__details">
              <summary>键盘微调</summary>
              <div className="CharacterGallery__keyboardHelp">
                <dl>
                  <dt>移动</dt>
                  <dd>{arrowKeys}</dd>
                  <dt>加大步幅</dt>
                  <dd>
                    <kbd>Shift</kbd> + {arrowKeys}
                  </dd>
                  <dt>缩放</dt>
                  <dd>
                    <kbd>−</kbd> <kbd>+</kbd>
                  </dd>
                </dl>
                选中头像即可开始微调，点击头像外部结束。
              </div>
            </details>
          </div>
        </div>
      </Section>
      {form.id === 'character' && (
        <ChatAppearance
          key={retry}
          form={form}
          framing={framing}
          retry={retry}
          busy={busy}
        />
      )}
    </>
  );
};

type FramingSliderProps = {
  busy?: boolean;
  label: string;
  hint: string;
  value: number;
  minValue?: number;
  maxValue?: number;
  enabled: boolean;
  unavailable: string;
  onDrag: (value: number) => void;
  onChange: (value: number) => void;
  onAbandon: () => void;
};

const FramingSlider = (props: FramingSliderProps) => {
  const { enabled, unavailable, onAbandon, busy, ...slider } = props;
  if (!enabled) {
    return (
      <Box
        className="CharacterGallery__inactivePosition"
        color="label"
        mb={0.75}
      >
        <div>
          <b>{slider.label}</b> {slider.value}%
        </div>
        <div>{unavailable}</div>
      </Box>
    );
  }
  return (
    <div
      className={classes([
        'CharacterGallery__framingSlider',
        busy && 'CharacterGallery__busy',
      ])}
      inert={busy}
      onLostPointerCapture={onAbandon}
    >
      <DragSlider {...slider} />
    </div>
  );
};

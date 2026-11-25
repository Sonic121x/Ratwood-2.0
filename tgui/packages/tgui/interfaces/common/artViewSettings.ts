import { clamp } from 'tgui-core/math';

import { opensOnlyInScrolling } from './pictureSize';

/** A part of a picture, each value a share of its width or height from 0 to 1. Players see it as the framing box */
export type ArtCrop = {
  x: number;
  y: number;
  w: number;
  h: number;
};

export type ArtViewSettings = {
  opening_view: 'whole' | 'fitted' | 'scroll';
  lock: 'none' | 'view' | 'zoom' | 'both';
  crop?: ArtCrop;
};

export const ART_VIEW_LABELS = {
  whole: '卡片',
  fitted: '适应窗口',
  scroll: '滚动',
} satisfies Record<ArtViewSettings['opening_view'], string>;

export const ART_LOCK_LABELS = {
  none: '不锁定',
  view: '锁定视图',
  zoom: '锁定缩放',
  both: '锁定视图和缩放',
} satisfies Record<ArtViewSettings['lock'], string>;

export const ART_VIEW_HELP = {
  whole:
    '以卡片展示作品。设置取景框后，卡片只显示框内的部分。',
  fitted:
    '让取景框内的画面适应窗口大小。未设置取景框时显示整张图片。',
  scroll:
    '按取景框的宽度铺满窗口，从框的顶部开始浏览。未设置取景框时从原图顶部开始。',
} satisfies Record<ArtViewSettings['opening_view'], string>;

export const ART_LOCK_HELP = {
  none: '查看者可以切换视图并缩放图片。',
  view: '固定使用初始视图，查看者仍可缩放。',
  zoom: '查看者可以切换视图，缩放已禁用。',
  both: '固定使用初始视图，缩放已禁用。',
} satisfies Record<ArtViewSettings['lock'], string>;

/** Whether a lock keeps viewers in the opening view, as Lock View and Lock Both do */
export const locksView = (lock: ArtViewSettings['lock']) =>
  lock === 'view' || lock === 'both';

/** Whether a lock turns the viewer's zoom off, as Lock Zoom and Lock Both do */
export const locksZoom = (lock: ArtViewSettings['lock']) =>
  lock === 'zoom' || lock === 'both';

/** locksView for the owner's view settings */
export const viewLocked = (owner: ArtViewSettings) => locksView(owner.lock);

/** locksZoom for the owner's view settings */
export const zoomLocked = (owner: ArtViewSettings) => locksZoom(owner.lock);

export const DEFAULT_ART_VIEW = Object.freeze({
  opening_view: 'whole',
  lock: 'zoom',
} satisfies ArtViewSettings);

/**
 * The settings viewers get for a picture once its size is read. One that opens only in Scrolling gets
 * Scrolling with the view locked, and keeps the saved zoom lock and framing box. The server stores only
 * the link, so the viewer decides this from the picture itself
 */
export const shownArtView = (
  saved: ArtViewSettings,
  size: readonly [number, number] | null | undefined,
): ArtViewSettings =>
  size && opensOnlyInScrolling(size[0], size[1])
    ? {
        ...saved,
        opening_view: 'scroll',
        lock: locksZoom(saved.lock) ? 'both' : 'view',
      }
    : saved;

/**
 * The Viewer Controls choice a lock shows as on a picture that opens only in Scrolling. Its view is always
 * locked, so Unlocked stands for none or view and Lock Zoom for zoom or both
 */
export const tallLockChoice = (
  lock: ArtViewSettings['lock'],
): 'none' | 'zoom' => (locksZoom(lock) ? 'zoom' : 'none');

/** What each tallLockChoice leaves viewers able to do */
export const TALL_LOCK_HELP = {
  none: '查看者可以缩小以查看全图，也可以随时滚动。',
  zoom: '查看者可以随时滚动，缩放已禁用。',
} satisfies Record<ReturnType<typeof tallLockChoice>, string>;

/** A crop's smallest side as a share of the picture, which must match GALLERY_ART_CROP_MIN in code/__DEFINES/character_gallery.dm */
export const ART_CROP_MIN = 0.02;

/** The examine gallery's art area at its default window size */
export const ART_AREA = Object.freeze({ width: 988, height: 458 });

const ART_AREA_ASPECT = ART_AREA.width / ART_AREA.height;

export const FULL_CROP: ArtCrop = Object.freeze({ x: 0, y: 0, w: 1, h: 1 });

const roundShare = (value: number) => Math.round(value * 10_000) / 10_000;

/** Fits a crop inside the picture as sanitize_art_crop() does on the server */
export const clampCrop = (crop: ArtCrop): ArtCrop => {
  const x = clamp(roundShare(crop.x), 0, 1 - ART_CROP_MIN);
  const y = clamp(roundShare(crop.y), 0, 1 - ART_CROP_MIN);
  return {
    x,
    y,
    w: clamp(roundShare(crop.w), ART_CROP_MIN, roundShare(1 - x)),
    h: clamp(roundShare(crop.h), ART_CROP_MIN, roundShare(1 - y)),
  };
};

/**
 * A starting box for editing or previewing Scrolling without a saved crop.
 *
 * The box is clamped as the server stores a crop, so a thin picture's box is ART_CROP_MIN tall at least and
 * keeps its size when it is moved and saved.
 */
export const defaultScrollCrop = (
  aspect: number,
  areaAspect = ART_AREA_ASPECT,
): ArtCrop => clampCrop({ x: 0, y: 0, w: 1, h: aspect / areaAspect });

/** The artwork's opening view as represented in a thumbnail */
export const viewCrop = (
  view: ArtViewSettings['opening_view'],
  settings: ArtViewSettings | undefined,
  aspect: number,
): ArtCrop => {
  return (
    settings?.crop ??
    (view === 'scroll' ? defaultScrollCrop(aspect) : FULL_CROP)
  );
};

/** Places a picture inside a box of its crop's shape so the crop fills the box, in percent of the box */
export const cropImageStyle = (crop: ArtCrop) => ({
  left: `${(-crop.x / crop.w) * 100}%`,
  top: `${(-crop.y / crop.h) * 100}%`,
  width: `${100 / crop.w}%`,
  height: `${100 / crop.h}%`,
});

/** The shape of a crop in pixels, width over height */
export const cropAspect = (aspect: number, crop: ArtCrop | undefined) =>
  crop ? (aspect * crop.w) / crop.h : aspect;

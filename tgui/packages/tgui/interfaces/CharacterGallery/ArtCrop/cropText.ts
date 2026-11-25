import {
  ART_AREA,
  ART_LOCK_LABELS,
  ART_VIEW_LABELS,
  type ArtCrop,
  type ArtViewSettings,
  cropAspect,
  locksView,
  TALL_LOCK_HELP,
  tallLockChoice,
} from '../../common/artViewSettings';
import {
  PICTURE_TOO_NARROW_TEXT,
  pictureTooThin,
  TILTED_CARD_MARGIN,
} from '../../common/cardLayout';
import type { usePictureSize } from '../../common/pictureSize';

export const framingStatus = (
  view: ArtViewSettings['opening_view'],
  framed: boolean,
) => {
  switch (view) {
    case 'whole':
      return framed
        ? '卡片显示取景框内的画面。'
        : '卡片显示整张图片。';
    case 'fitted':
      return framed
        ? '框内画面将适应窗口大小。'
        : '整张图片将适应窗口大小。';
    case 'scroll':
      return framed
        ? '滚动视图从取景框顶部开始，框内画面与窗口等宽。'
        : '滚动视图从图片顶部开始，图片与窗口等宽。';
  }
};

export const pictureStatus = (picture: ReturnType<typeof usePictureSize>) => {
  if (picture.limitText) {
    return picture.limitText;
  }
  if (picture.failed) {
    return '图片加载失败，请检查链接。';
  }
  return '正在加载图片……';
};

const TOO_THIN_TEXT = `取景区域过窄，无法显示为卡片。查看者会看到“${PICTURE_TOO_NARROW_TEXT}”。请拉高或拉宽取景框，或使用“${ART_VIEW_LABELS.scroll}”。`;

const SWITCH_TOO_THIN_TEXT = `查看者切换到“${ART_VIEW_LABELS.whole}”时会看到“${PICTURE_TOO_NARROW_TEXT}”。请拉高或拉宽取景框，或锁定视图。`;

const UNFRAMED_TOO_THIN_TEXT = `原图过窄，无法显示为卡片。查看者会看到“${PICTURE_TOO_NARROW_TEXT}”。请框选比例合适的区域，或使用“${ART_VIEW_LABELS.scroll}”。`;

const UNFRAMED_SWITCH_TOO_THIN_TEXT = `没有取景框时，“${ART_VIEW_LABELS.whole}”会显示整张图片。切换到该视图会看到“${PICTURE_TOO_NARROW_TEXT}”。请框选比例合适的区域，或锁定视图。`;

/** The warning for a framing Card cannot show, or null when viewers never reach Card with it */
export const tooThinText = (
  size: [number, number] | null,
  crop: ArtCrop | undefined,
  view: ArtViewSettings['opening_view'],
  lock: ArtViewSettings['lock'],
) => {
  // Card shows the owner's box, or the whole picture without one, never the default box shown here
  const thinForCard =
    !!size &&
    pictureTooThin(
      cropAspect(size[0] / size[1], crop),
      ART_AREA,
      TILTED_CARD_MARGIN,
    );
  if (thinForCard && view === 'whole') {
    return crop ? TOO_THIN_TEXT : UNFRAMED_TOO_THIN_TEXT;
  }
  if (thinForCard && !locksView(lock)) {
    return crop ? SWITCH_TOO_THIN_TEXT : UNFRAMED_SWITCH_TOO_THIN_TEXT;
  }
  return null;
};

/**
 * What each lock leaves viewers able to do. Scrolling can zoom out to the whole picture and scroll
 * past the box where the picture overflows the window.
 *
 * A picture that opens only in Scrolling gets the note for the choice its Viewer Controls show
 */
export const framingNote = (
  view: 'whole' | 'scroll',
  lock: ArtViewSettings['lock'],
  framed: boolean,
  scrollingOnly = false,
) => {
  if (scrollingOnly) {
    return TALL_LOCK_HELP[tallLockChoice(lock)];
  }
  const card = view === 'whole';
  const fit = `选择“${ART_VIEW_LABELS.fitted}”，让${framed ? '框内画面' : '整张图片'}适应窗口大小`;
  switch (lock) {
    case 'none':
      return card
        ? `查看者可以放大并平移图片，也可以${fit}。`
        : '查看者可以缩小以查看全图。';
    case 'view':
      return card
        ? '查看者可以放大并平移至取景框以外。'
        : '查看者可以缩小以查看全图。';
    case 'zoom':
      return `仅启用“${ART_LOCK_LABELS.zoom}”时，查看者仍可${fit}。`;
    case 'both':
      return card
        ? `启用“${ART_LOCK_LABELS.both}”时，查看者只能看到当前取景范围。`
        : `启用“${ART_LOCK_LABELS.both}”时，仍可滚动查看超出窗口的部分。`;
  }
};

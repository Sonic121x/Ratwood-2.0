import { type ReactNode, useId } from 'react';
import { Tooltip } from 'tgui-core/components';

import {
  ART_LOCK_HELP,
  ART_LOCK_LABELS,
  ART_VIEW_HELP,
  ART_VIEW_LABELS,
  type ArtViewSettings,
  DEFAULT_ART_VIEW,
  shownArtView,
  TALL_LOCK_HELP,
  tallLockChoice,
} from '../common/artViewSettings';
import { opensOnlyInScrolling } from '../common/pictureSize';
import { GallerySelect } from './GallerySelect';

const FRAMING_HELP =
  '查看者打开图片时会先看到取景框内的画面。';

const VIEW_OPTIONS = Object.entries(ART_VIEW_LABELS).map(([value, label]) => ({
  value,
  label,
}));

const LOCK_OPTIONS = Object.entries(ART_LOCK_LABELS).map(([value, label]) => ({
  value,
  label,
}));

const TALL_LOCK_OPTIONS = (['none', 'zoom'] as const).map((value) => ({
  value,
  label: ART_LOCK_LABELS[value],
}));

/** The opening view, any saved framing, and the lock, each with a help tooltip. */
export const ArtViewSummary = (props: {
  value?: ArtViewSettings;
  /** The picture's size once read, so a picture that opens only in Scrolling shows what viewers get */
  size?: readonly [number, number] | null;
}) => {
  const value: ArtViewSettings = props.value ?? DEFAULT_ART_VIEW;
  const { opening_view, lock, crop } = shownArtView(value, props.size);
  const tallLock =
    props.size && opensOnlyInScrolling(...props.size)
      ? tallLockChoice(lock)
      : null;
  return (
    <>
      <Tooltip content={ART_VIEW_HELP[opening_view]}>
        <span>{ART_VIEW_LABELS[opening_view]}</span>
      </Tooltip>
      {' | '}
      {!!crop && (
        <>
          <Tooltip content={FRAMING_HELP}>
            <span>自定义取景</span>
          </Tooltip>
          {' | '}
        </>
      )}
      <Tooltip
        content={tallLock ? TALL_LOCK_HELP[tallLock] : ART_LOCK_HELP[lock]}
      >
        <span>{ART_LOCK_LABELS[tallLock ?? lock]}</span>
      </Tooltip>
    </>
  );
};

/** The Opening view and Viewer controls selects, with an Unchanged choice that keeps each image's own setting when allowUnchanged is set */
export const ArtViewControls = (props: {
  children?: ReactNode;
  value: Partial<ArtViewSettings>;
  disabled?: boolean;
  /** The picture opens only in Scrolling, so Opening View is fixed and Viewer Controls offers only Unlocked and Lock Zoom */
  scrollingOnly?: boolean;
  allowUnchanged?: boolean;
  label: string;
  onChange: (value: Partial<ArtViewSettings>) => void;
}) => {
  const helpId = useId();
  const { opening_view, lock } = props.value;
  const viewHelp = opening_view
    ? `设置作品打开时的视图。${ART_VIEW_HELP[opening_view]}`
    : '保留每张图片已保存的初始视图。';
  // A stored lock stays as it is until the owner picks one of the two choices
  const tallLock = lock && props.scrollingOnly ? tallLockChoice(lock) : null;
  const lockHelp = lock
    ? `设置查看者可用的操作。${tallLock ? TALL_LOCK_HELP[tallLock] : ART_LOCK_HELP[lock]}`
    : '保留每张图片已保存的查看权限。';
  return (
    <div className="CharacterGallery__viewFields">
      <Tooltip content={viewHelp}>
        <label>
          初始视图
          <GallerySelect
            aria-label={`${props.label}初始视图`}
            aria-describedby={`${helpId}-view`}
            value={opening_view ?? ''}
            disabled={props.disabled || props.scrollingOnly}
            allowUnchanged={props.allowUnchanged}
            options={VIEW_OPTIONS}
            onChange={(value) =>
              props.onChange({
                ...props.value,
                opening_view:
                  (value as ArtViewSettings['opening_view']) || undefined,
              })
            }
          />
        </label>
      </Tooltip>
      <Tooltip content={lockHelp}>
        <label>
          查看权限
          <GallerySelect
            aria-label={`${props.label}查看权限`}
            aria-describedby={`${helpId}-lock`}
            value={tallLock ?? lock ?? ''}
            disabled={props.disabled}
            allowUnchanged={props.allowUnchanged}
            options={props.scrollingOnly ? TALL_LOCK_OPTIONS : LOCK_OPTIONS}
            onChange={(value) =>
              props.onChange({
                ...props.value,
                lock: (value as ArtViewSettings['lock']) || undefined,
              })
            }
          />
        </label>
      </Tooltip>
      {props.children}
      <span id={`${helpId}-view`} className="CharacterGallery__viewHelpText">
        {viewHelp}
      </span>
      <span id={`${helpId}-lock`} className="CharacterGallery__viewHelpText">
        {lockHelp}
      </span>
    </div>
  );
};

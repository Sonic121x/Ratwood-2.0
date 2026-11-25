import type { ReactNode, RefObject } from 'react';
import { Icon } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { ART_VIEW_HELP, ART_VIEW_LABELS } from '../../common/artViewSettings';
import { zoomPercent } from '../Reader/readingGeometry';
import type { ReaderState } from '../Reader/readingState';
import { GalleryMouseIcon } from './MouseHints';

/** The tray panel that is open, the view menu or the help, or null for neither */
export type ControlsPanel = 'view' | 'help' | null;

export const BUTTON = 'Button Button--color--default';

/** The zoom factor of the Zoom in button, whose reciprocal the Zoom out button takes */
const ZOOM_BUTTON_STEP = 1.25;

const VIEW_HELP = {
  whole: '以带框卡片展示作品。',
  fitted: ART_VIEW_HELP.fitted,
  scroll: `${ART_VIEW_HELP.scroll}可平移或滚动查看框外的画面。`,
} satisfies Record<ReaderState['view'], string>;

const SCROLLING_ONLY_TEXT = `长图始终以“${ART_VIEW_LABELS.scroll}”视图打开`;

/** The tray's view button and the menu it opens */
export const ViewMenu = (props: {
  viewRef: RefObject<HTMLButtonElement | null>;
  viewId: string;
  panel: ControlsPanel;
  onPanel: (panel: ControlsPanel) => void;
  lockedView: boolean;
  /** The picture opens only in Scrolling, so its shape locks the view and not the owner */
  scrollingOnly: boolean;
  viewLabel: string;
  view: ReaderState['view'];
  onView: (view: ReaderState['view']) => void;
  onReset: () => void;
}) => {
  const { viewRef, viewId, panel, onPanel, lockedView, viewLabel } = props;
  const closeView = () => {
    onPanel(null);
    viewRef.current?.focus({ preventScroll: true });
  };
  return (
    <div className="ExamineGallery__viewControl">
      <button
        ref={viewRef}
        type="button"
        className={`ExamineGallery__viewToggle ${BUTTON}`}
        title={
          lockedView
            ? props.scrollingOnly
              ? SCROLLING_ONLY_TEXT
              : '作者已锁定视图'
            : undefined
        }
        aria-expanded={panel === 'view'}
        aria-controls={viewId}
        aria-haspopup="dialog"
        onClick={() => onPanel(panel === 'view' ? null : 'view')}
      >
        {viewLabel}
        <Icon name={lockedView ? 'lock' : 'caret-down'} aria-hidden />
      </button>
      {panel === 'view' && (
        <div
          id={viewId}
          className="ExamineGallery__viewMenu"
          role="dialog"
          aria-label="图片视图"
        >
          {lockedView ? (
            <span className="ExamineGallery__viewHelp">
              {props.scrollingOnly
                ? `${SCROLLING_ONLY_TEXT}.`
                : '作者已锁定视图。'}
            </span>
          ) : (
            Object.entries(ART_VIEW_LABELS).map(([view, label]) => (
              <button
                key={view}
                type="button"
                className={classes([
                  BUTTON,
                  props.view === view && 'Button--selected',
                ])}
                aria-pressed={props.view === view}
                onClick={() => {
                  props.onView(view as ReaderState['view']);
                  closeView();
                }}
              >
                {label}
              </button>
            ))
          )}
          <button
            type="button"
            className={BUTTON}
            onClick={() => {
              props.onReset();
              closeView();
            }}
          >
            重置视图
          </button>
        </div>
      )}
    </div>
  );
};

export const ZoomButtons = (props: {
  lockedZoom: boolean;
  zoom: number;
  zoomMin: number;
  zoomMax: number;
  onZoom: (factor: number) => void;
}) => (
  <div
    className="ExamineGallery__zoomControls"
    role="group"
    aria-label="图片缩放"
    title={props.lockedZoom ? '作者已锁定缩放' : undefined}
  >
    <button
      type="button"
      className={BUTTON}
      aria-label="缩小"
      disabled={props.lockedZoom || props.zoom <= props.zoomMin}
      onClick={() => props.onZoom(1 / ZOOM_BUTTON_STEP)}
    >
      −
    </button>
    <output aria-live="polite">{zoomPercent(props.zoom)}</output>
    <button
      type="button"
      className={BUTTON}
      aria-label="放大"
      disabled={props.lockedZoom || props.zoom >= props.zoomMax}
      onClick={() => props.onZoom(ZOOM_BUTTON_STEP)}
    >
      +
    </button>
  </div>
);

/** The contextual help panel, which lists the controls the current view allows */
export const HelpPanel = (props: {
  helpId: string;
  helpTitleId: string;
  viewLabel: string;
  view: ReaderState['view'];
  reading: boolean;
  canAdvance: boolean;
  canPan: boolean;
  canZoom: boolean;
  lockedZoom: boolean;
  zoomShortcut: ReactNode;
  showMouseControls: boolean;
  onShowMouseControls: (show: boolean) => void;
}) => {
  const {
    helpId,
    helpTitleId,
    viewLabel,
    reading,
    canAdvance,
    canPan,
    canZoom,
    lockedZoom,
    zoomShortcut,
  } = props;
  return (
    <div
      id={helpId}
      className="ExamineGallery__helpPanel"
      role="dialog"
      aria-labelledby={helpTitleId}
    >
      <strong id={helpTitleId}>当前视图帮助</strong>
      <div>此处显示当前视图可用的操作。</div>
      <div className="ExamineGallery__helpContext">
        {viewLabel}
        {props.view === 'whole' && reading && '（已放大）'}
      </div>
      <div>{VIEW_HELP[props.view]}</div>
      <dl className="ExamineGallery__helpActions">
        {canAdvance && (
          <>
            <dt>下一张</dt>
            <dd>
              <GalleryMouseIcon action="next" />
            </dd>
          </>
        )}
        {canPan && (
          <>
            <dt>平移</dt>
            <dd>
              <GalleryMouseIcon action="pan" /> 按住并拖动
            </dd>
            <dt>滚动</dt>
            <dd>
              <GalleryMouseIcon action="scroll" />
            </dd>
          </>
        )}
        {(canZoom || lockedZoom) && (
          <>
            <dt>缩放</dt>
            <dd>
              {canZoom ? (
                <>
                  {zoomShortcut} 或 <kbd>−</kbd> <kbd>+</kbd>
                </>
              ) : (
                '作者已锁定'
              )}
            </dd>
          </>
        )}
        {canAdvance && (
          <>
            <dt>切换图片</dt>
            <dd>
              <GalleryMouseIcon action="thumbnails" /> 在缩略图上滚动
              {!reading && (
                <>
                  {' '}
                  或 <kbd>←</kbd> <kbd>→</kbd>
                </>
              )}
            </dd>
          </>
        )}
      </dl>
      <label className="ExamineGallery__mousePreference">
        <input
          type="checkbox"
          checked={props.showMouseControls}
          onChange={(event) =>
            props.onShowMouseControls(event.currentTarget.checked)
          }
        />
        显示鼠标操作提示
      </label>
    </div>
  );
};

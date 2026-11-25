import type { RefObject } from 'react';
import { classes } from 'tgui-core/react';

import { DragSlider } from '../../../components';
import type { ArtCrop } from '../../common/artViewSettings';
import { gallerySelectEvents } from '../nativeSelect';
import {
  clampCropZoom,
  cropZoom,
  cropZoomLimit,
  cropZoomPoint,
  sameCrop,
  zoomCrop,
} from './cropGeometry';

/** The Zoom slider's top in percent, so 100 to 200 takes a third of it, which the wheel and a box zoomed past it extend */
const SLIDER_ZOOM_TOP = 400;

export type CropSliderStart = { box: ArtCrop; crop?: ArtCrop };

export const CropZoomSlider = (props: {
  ready: boolean;
  shown: ArtCrop;
  crop: ArtCrop | undefined;
  scrolling: boolean;
  sliderBase: RefObject<CropSliderStart | null>;
  sliderReleased: RefObject<boolean>;
  sliderKey: number;
  onChange: (crop: ArtCrop | undefined) => void;
}) => {
  const {
    ready,
    shown,
    crop,
    scrolling,
    sliderBase,
    sliderReleased,
    sliderKey,
    onChange,
  } = props;

  const zoomFromSlider = (zoom: number) => {
    const base = sliderBase.current ?? { box: shown, crop };
    const clamped = clampCropZoom(base.box, zoom, scrolling);
    const next = zoomCrop(
      base.box,
      clamped,
      cropZoomPoint(base.box, scrolling),
      scrolling,
    );
    const unchanged =
      zoom === Math.round(cropZoom(base.box, scrolling)) ||
      sameCrop(next, base.box, scrolling);
    onChange(scrolling && unchanged ? base.crop : next);
  };
  const sliderBox = sliderBase.current?.box ?? shown;
  const sliderTop = Math.max(
    Math.min(SLIDER_ZOOM_TOP, Math.floor(cropZoomLimit(sliderBox, scrolling))),
    Math.round(cropZoom(sliderBox, scrolling)),
  );

  return (
    <div
      className={classes([
        'CharacterGallery__cropSlider',
        !ready && 'CharacterGallery__busy',
      ])}
      inert={!ready}
      {...gallerySelectEvents}
      onKeyDown={(event) => {
        // The number box reverts on Escape but lets it through to the dialog, which would cancel
        if (
          event.key === 'Escape' &&
          event.target instanceof HTMLInputElement
        ) {
          event.stopPropagation();
          return;
        }
        gallerySelectEvents.onKeyDown(event);
      }}
      onLostPointerCapture={() => {
        sliderBase.current = null;
      }}
    >
      <DragSlider
        key={sliderKey}
        label="取景缩放"
        hint={
          scrolling
            ? '调整初始缩放比例，取景框顶部保持原位。'
            : '以中心为基准调整取景框大小。'
        }
        value={Math.round(cropZoom(shown, scrolling))}
        minValue={100}
        maxValue={sliderTop}
        onDrag={(zoom) => {
          if (!sliderBase.current) {
            sliderBase.current = { box: shown, crop };
          }
          zoomFromSlider(zoom);
        }}
        onChange={(zoom) => {
          zoomFromSlider(zoom);
          sliderBase.current = null;
          sliderReleased.current = true;
        }}
      />
    </div>
  );
};

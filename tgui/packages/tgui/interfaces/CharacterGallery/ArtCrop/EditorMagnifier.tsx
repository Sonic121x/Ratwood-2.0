import { Box, Button } from 'tgui-core/components';

import type { ArtCrop, ArtViewSettings } from '../../common/artViewSettings';

/** The magnifier for the framing editor's view, with the box's size in pixels and Reset */
export const EditorMagnifier = (props: {
  ready: boolean;
  zoom: number;
  zoomMax: number;
  onZoom: (direction: 1 | -1) => void;
  size: [number, number] | null;
  box: ArtCrop;
  crop: ArtCrop | undefined;
  view: ArtViewSettings['opening_view'];
  onReset: () => void;
}) => {
  const { ready, zoom, zoomMax, onZoom, size, box, crop, view, onReset } =
    props;
  return (
    <div className="CharacterGallery__cropControls">
      <div className="CharacterGallery__cropControlGroup">
        <Box color="label">编辑器放大倍率</Box>
        <Button
          compact
          aria-label="缩小编辑画面"
          tooltip="缩小编辑画面以看到更多区域。此调整仅对编辑者可见。"
          disabled={!ready || zoom <= 1}
          onClick={() => onZoom(-1)}
        >
          −
        </Button>
        <span className="CharacterGallery__cropZoom">{zoom.toFixed(1)}×</span>
        <Button
          compact
          aria-label="放大编辑画面"
          tooltip="放大编辑画面以精确放置取景框。此调整仅对编辑者可见。"
          disabled={!ready || zoom >= zoomMax}
          onClick={() => onZoom(1)}
        >
          +
        </Button>
      </div>
      <div className="CharacterGallery__cropControlGroup">
        <Box color="label" className="CharacterGallery__cropSize">
          {!!size &&
            `${Math.round(box.w * size[0])} × ${Math.round(box.h * size[1])} px`}
        </Box>
        <Button
          compact
          icon="undo"
          disabled={!crop}
          tooltip={
            view === 'scroll'
              ? '回到图片顶部并恢复完整宽度。'
              : '恢复显示整张图片。'
          }
          onClick={() => onReset()}
        >
          重置
        </Button>
      </div>
    </div>
  );
};

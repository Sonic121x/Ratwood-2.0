import { useId, useState } from 'react';
import { Floating, Icon } from 'tgui-core/components';

import type { ArtViewSettings } from '../../common/artViewSettings';
import { MouseControlIcon } from '../../common/MouseControlIcon';

const FRAMING_HELP = {
  whole: '卡片将显示取景框内的画面。',
  fitted:
    '“适应窗口”会让框内画面适应窗口大小。重置取景框即可显示全图。',
  scroll:
    '取景框与查看窗口的宽高比一致。重置后将从图片顶部开始浏览。',
} satisfies Record<ArtViewSettings['opening_view'], string>;

export const FramingHelp = (props: {
  view: ArtViewSettings['opening_view'];
}) => {
  const [open, setOpen] = useState(false);
  const id = useId();

  return (
    <Floating
      placement="bottom-start"
      handleOpen={open}
      contentClasses="Tooltip CharacterGallery__framingTooltip"
      content={
        <div id={id} role="tooltip">
          <p>{FRAMING_HELP[props.view]}</p>
          <ul>
            <li>
              按住鼠标左键可拖动取景框。
              拖动边缘或角点可调整大小。
            </li>
            {props.view !== 'scroll' && (
              <li>
                <MouseControlIcon control="left" label="鼠标左键" />{' '}
                按住 <kbd>Shift</kbd> 拖动角点，
                可保持宽高比。
              </li>
            )}
            <li>
              <MouseControlIcon control="wheel" label="鼠标滚轮" /> 点击图片后，
              滚动滚轮可缩放取景框。
            </li>
            <li>
              <MouseControlIcon control="wheel" label="鼠标滚轮" /> 按住{' '}
              <kbd>Ctrl</kbd> 并滚动滚轮可缩放编辑画面。
            </li>
            <li>
              <MouseControlIcon control="right" label="鼠标右键" />{' '}
              按住右键拖动可平移画面。
            </li>
          </ul>
        </div>
      }
    >
      <button
        type="button"
        className="CharacterGallery__framingHelp"
        aria-label="取景帮助"
        aria-describedby={open ? id : undefined}
        onMouseEnter={() => setOpen(true)}
        onMouseLeave={() => setOpen(false)}
        onFocus={() => setOpen(true)}
        onBlur={() => setOpen(false)}
        onClick={() => setOpen(true)}
        onKeyDown={(event) => {
          if (open && event.key === 'Escape') {
            event.preventDefault();
            event.stopPropagation();
            setOpen(false);
          }
        }}
      >
        <Icon name="circle-question" />
      </button>
    </Floating>
  );
};

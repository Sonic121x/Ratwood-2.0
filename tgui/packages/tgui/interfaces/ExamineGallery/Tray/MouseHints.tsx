import type { ReactNode } from 'react';

import { MouseControlIcon } from '../../common/MouseControlIcon';

const MOUSE_CONTROLS = {
  next: ['left', '左键点击作品可查看下一张'],
  pan: ['right', '按住右键拖动可平移超出窗口的作品'],
  scroll: ['wheel', '滚动滚轮可上下浏览'],
  zoom: ['wheel', '按住 Ctrl 并滚动滚轮可缩放'],
  thumbnails: ['wheel', '在缩略图上滚动可切换图片'],
} as const;

export const GalleryMouseIcon = (props: {
  action: keyof typeof MOUSE_CONTROLS;
}) => {
  const [control, label] = MOUSE_CONTROLS[props.action];
  return (
    <MouseControlIcon
      className="ExamineGallery__mouseIcon"
      control={control}
      label={label}
    />
  );
};

type MouseHint = {
  shown: boolean;
  icon: ReactNode;
  label: string;
};

/** Two mouse hints under the artwork, with a separator when both show */
export const HintGroup = (props: {
  className: string;
  first: MouseHint;
  second: MouseHint;
}) => {
  const { first, second } = props;
  return (
    <div className={props.className}>
      {first.shown && (
        <span className="ExamineGallery__mouseAction">
          {first.icon}
          <span className="ExamineGallery__hintLabel">{first.label}</span>
        </span>
      )}
      {first.shown && second.shown && (
        <span className="ExamineGallery__hintSeparator" aria-hidden>
          |
        </span>
      )}
      {second.shown && (
        <span className="ExamineGallery__mouseAction">
          {second.icon}
          <span className="ExamineGallery__hintLabel">{second.label}</span>
        </span>
      )}
    </div>
  );
};

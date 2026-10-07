import type { ComponentProps } from 'react';
import { Collapsible as CoreCollapsible, Section as CoreSection } from 'tgui-core/components';

export const Section = ({ display_title, ...props }: ComponentProps<typeof CoreSection> & { display_title?: string }) => (
  <CoreSection {...props} title={display_title ?? props.title} />
);

export const Collapsible = ({ display_title, ...props }: ComponentProps<typeof CoreCollapsible> & { display_title?: string }) => (
  <CoreCollapsible {...props} title={display_title ?? props.title} />
);

export const NativeButton = ({ display_title, ...props }: ComponentProps<'button'> & { display_title?: string }) => (
  <button {...props} title={display_title ?? props.title} />
);

export const NativeSpan = ({ display_title, ...props }: ComponentProps<'span'> & { display_title?: string }) => (
  <span {...props} title={display_title ?? props.title} />
);

export const NativeDiv = ({ display_title, ...props }: ComponentProps<'div'> & { display_title?: string }) => (
  <div {...props} title={display_title ?? props.title} />
);

export const NativeInput = ({ display_title, ...props }: ComponentProps<'input'> & { display_title?: string }) => (
  <input {...props} title={display_title ?? props.title} />
);

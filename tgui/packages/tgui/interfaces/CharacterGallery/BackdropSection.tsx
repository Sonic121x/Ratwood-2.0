import { Box, Button, Section } from 'tgui-core/components';

import { useGalleryBackend } from './galleryBackend';
import type { ImageForm } from './types';

export const BackdropSection = (props: { form: ImageForm }) => {
  const { act, data, isBusy } = useGalleryBackend();
  const { form } = props;
  const busy = isBusy(form.id);
  return (
    <Section title="画廊布景">
      <Box color="label" mb={1}>
        选择其他玩家浏览你的作品时看到的布景。
      </Box>
      <div
        className="CharacterGallery__actions"
        role="group"
        aria-label="画廊布景"
      >
        {data.backdrop_options.map((option) => {
          const chosen = option.value === form.image_backdrop;
          return (
            <Button
              key={option.value}
              icon={chosen ? 'check' : undefined}
              selected={chosen}
              bold={chosen}
              disabled={busy}
              aria-pressed={chosen}
              onClick={() => {
                if (!chosen) {
                  act('set_backdrop', {
                    form: form.id,
                    backdrop: option.value,
                  });
                }
              }}
            >
              {option.label}
            </Button>
          );
        })}
      </div>
    </Section>
  );
};

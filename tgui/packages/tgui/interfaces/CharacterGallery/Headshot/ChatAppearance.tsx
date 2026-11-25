import { Box, Button, Icon, Section } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../../../assets';
import { HeadshotFrame, PictureTooLarge } from '../../common/HeadshotFrame';
import { usePictureSize } from '../../common/pictureSize';
import { buttonRole } from '../buttonSemantics';
import { useGalleryBackend } from '../galleryBackend';
import type { ImageForm } from '../types';
import type { Framing } from './framing';

export const ChatAppearance = (props: {
  form: ImageForm;
  framing: Framing;
  retry: number;
  busy: boolean;
}) => {
  const { act, data } = useGalleryBackend();
  const { form, framing, retry, busy } = props;
  const original = usePictureSize(form.headshot);
  return (
    <Section title="聊天栏头像">
      <Box color="label" mb={1}>
        选择在聊天栏检视角色时显示的头像样式。
        详细检视面板始终使用方形头像。
      </Box>
      <div className="CharacterGallery__chatOptions">
        {[false, true].map((useFraming) => {
          const chosen = !!data.headshot_frame_chat === useFraming;
          const title = useFraming ? '方形头像' : '原图比例';
          return (
            <Button
              key={String(useFraming)}
              disabled={busy}
              className={classes([
                'CharacterGallery__chatOption',
                chosen && 'CharacterGallery__chatOption--selected',
              ])}
              {...buttonRole}
              aria-label={title}
              aria-pressed={chosen}
              onClick={() => act('set_frame_chat', { enabled: useFraming })}
            >
              <div className="CharacterGallery__chatPreview">
                {useFraming ? (
                  <div className="CharacterGallery__chatSquare">
                    <HeadshotFrame
                      key={retry}
                      src={form.headshot!}
                      zoom={framing.zoom}
                      x={framing.x}
                      y={framing.y}
                    />
                  </div>
                ) : original.tooLarge ? (
                  <PictureTooLarge size={original.size} />
                ) : (
                  original.drawable && (
                    <img
                      key={retry}
                      className="CharacterGallery__chatOriginal"
                      src={resolveAsset(form.headshot!)}
                      alt="保留原图比例的聊天栏头像"
                    />
                  )
                )}
              </div>
              <Box bold className="CharacterGallery__chatLabel">
                {chosen && <Icon name="check" mr={0.5} />}
                {title}
              </Box>
              <Box color="label" mt={0.5}>
                {useFraming
                  ? '与上方的头像取景一致。'
                  : '保留图片原有的宽高比。'}
              </Box>
            </Button>
          );
        })}
      </div>
    </Section>
  );
};

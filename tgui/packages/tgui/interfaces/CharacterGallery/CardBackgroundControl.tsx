import { Dropdown, Tooltip } from 'tgui-core/components';

import { CardBackground, cardMaterial } from '../common/CardBackground';
import { useGalleryBackend } from './galleryBackend';
import { GallerySelect } from './GallerySelect';
import type { Data } from './types';

/** The name the server's options give a card background, none for a value they do not list */
export const cardBackgroundLabel = (
  options: Data['card_background_options'],
  value: string,
) => options.find((option) => option.value === value)?.label;

/** Artwork Settings' card backdrop for all artwork, a native select whose empty value leaves each card unchanged */
export const BulkCardBackgroundSelect = (props: {
  value: string;
  disabled?: boolean;
  onSelected: (background: string) => void;
}) => {
  const { data } = useGalleryBackend();
  return (
    <label>
      <span className="CharacterGallery__bulkBackdropLabel">
        卡片底色
        {!!props.value && (
          <span className="CharacterGallery__materialSwatch">
            <CardBackground value={cardMaterial(props.value)} />
          </span>
        )}
      </span>
      <GallerySelect
        aria-label="所有作品的卡片底色"
        value={props.value}
        disabled={props.disabled}
        allowUnchanged
        options={data.card_background_options}
        onChange={props.onSelected}
      />
    </label>
  );
};

/** One card's backdrop in the Edit dialog, a dropdown showing each material's swatch */
export const CardBackgroundDropdown = (props: {
  value: string;
  disabled?: boolean;
  onSelected: (background: string) => void;
}) => {
  const { data } = useGalleryBackend();
  const value = cardMaterial(props.value);
  const label = cardBackgroundLabel(data.card_background_options, value);
  const options = data.card_background_options.map((option) => ({
    value: option.value,
    displayText: (
      <span className="CharacterGallery__materialOption">
        <span className="CharacterGallery__materialSwatch">
          <CardBackground value={option.value} />
        </span>
        {option.label}
      </span>
    ),
  }));
  return (
    <Tooltip
      content={`${label ?? '透明'}。此底色会透过图片的透明区域显示。`}
    >
      {/* Dropdown drops the ref and hover handlers Tooltip gives its child */}
      <span style={{ display: 'inline-block' }}>
        <Dropdown
          width="auto"
          menuWidth={11}
          selected={value}
          displayText={
            <span className="CharacterGallery__materialOption">
              卡片底色
              <span className="CharacterGallery__materialSwatch">
                <CardBackground value={value} />
              </span>
            </span>
          }
          options={options}
          disabled={props.disabled}
          onSelected={props.onSelected}
        />
      </span>
    </Tooltip>
  );
};

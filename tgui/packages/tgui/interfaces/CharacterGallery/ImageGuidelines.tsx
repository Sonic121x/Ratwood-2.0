import { Box } from 'tgui-core/components';

import { HEADSHOT_SLOT } from './slots';

type GuidelineScope = 'all' | 'general' | 'headshot' | 'sfw';

export const guidelineScope = (image: string): GuidelineScope => {
  if (image === HEADSHOT_SLOT) {
    return 'headshot';
  }
  return image.startsWith('nsfw_') ? 'general' : 'sfw';
};

export const ImageGuidelines = (props: { scope: GuidelineScope }) => (
  <details className="CharacterGallery__guidelines">
    <summary>查看图片使用规范</summary>
    <Box mt={1}>
      <Box bold>通用要求</Box>
      <ul>
        <li>
          角色的实际年龄和外貌都必须明确为成年人。
        </li>
        <li>
          角色形象应符合游戏设定的风格，
          在合理范围内可以自由发挥。
        </li>
        <li>
          如果画师或画中角色的所有者要求撤下图片，
          请尊重对方的意愿。
        </li>
      </ul>
      {(props.scope === 'all' || props.scope === 'headshot') && (
        <>
          <Box bold>头像</Box>
          <p>
            头像应避免露骨内容或过度性化。
            可以露出乳沟，也可以采用大腿以上的构图。
            不可露点，也不可让性部位成为画面的焦点。
            带有暗示意味的头像请把握分寸。
          </p>
        </>
      )}
      {(props.scope === 'all' || props.scope === 'sfw') && (
        <>
          <Box bold>全年龄画廊与 OOC 附件</Box>
          <ul>
            <li>
              可酌情使用略带挑逗意味的作品或姿势、轻微血腥场面，
              以及表达克制的裸体画作。
            </li>
            <li>
              不可清楚露出生殖器、性兴奋状态、勾勒出生殖器细节的凸起，
              或乳房上的乳头。请避免大量展现内脏、
              肢解场面或明显带有性意味的姿势。
            </li>
            <li>
              拿不准时，请使用成人向画廊，或通过 ahelp 询问管理员。{' '}
              <b>我们会按实际情况合理判断。</b>
            </li>
          </ul>
        </>
      )}
      <a
        href="https://wiki.ratwood.rip/index.php/Server_Rules"
        target="_blank"
        rel="noopener noreferrer"
      >
        出处：服务器规则
      </a>
    </Box>
  </details>
);

import { useBackend } from '../../tgui/packages/tgui/backend';
import {
  Button,
  Collapsible,
  NoticeBox,
  Section,
  Stack,
} from '../../tgui/packages/tgui/components';
import { Window } from '../../tgui/packages/tgui/layouts';

type GuidePageNode = {
  kind: 'page';
  id: string;
  label: string;
};

type GuideCategoryNode = {
  kind: 'category';
  id: string;
  label: string;
  children: GuideNode[];
};

type GuideNode = GuidePageNode | GuideCategoryNode;

type GuideBrowserData = {
  guide_tree: GuideNode[] | null;
  selected_id: string | null;
  selected_title: string | null;
  page_url: string | null;
  wiki_available: boolean;
  supports_iframe: boolean;
};

type GuideTreeProps = {
  nodes: GuideNode[];
  selectedId: string | null;
  onSelect: (id: string) => void;
};

const GuideTree = ({ nodes, selectedId, onSelect }: GuideTreeProps) => (
  <>
    {nodes.map((node) => {
      if (node.kind === 'category') {
        return (
          <Collapsible
            key={node.id}
            title={node.label}
            child_mt={0}
            childStyles={{ padding: '0.25em 0 0.25em 0.5em' }}
          >
            <GuideTree
              nodes={node.children}
              selectedId={selectedId}
              onSelect={onSelect}
            />
          </Collapsible>
        );
      }

      return (
        <Button
          key={node.id}
          fluid
          selected={node.id === selectedId}
          textAlign="left"
          onClick={() => onSelect(node.id)}
        >
          {node.label}
        </Button>
      );
    })}
  </>
);

export const GuideBrowser = () => {
  const { act, data } = useBackend<GuideBrowserData>();
  const {
    guide_tree,
    selected_id,
    selected_title,
    page_url,
    wiki_available,
    supports_iframe,
  } = data;

  return (
    <Window width={1100} height={760} title="指南浏览器">
      <Window.Content>
        <Stack fill>
          <Stack.Item width="220px">
            <Section fill scrollable title="指南目录">
              <GuideTree
                nodes={guide_tree ?? []}
                selectedId={selected_id}
                onSelect={(id) => act('select_page', { id })}
              />
            </Section>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item grow minWidth="0">
            <Section
              fill
              title={selected_title ?? undefined}
              buttons={
                <Button
                  icon="external-link-alt"
                  disabled={!wiki_available}
                  onClick={() => act('open_external')}
                >
                  在外部浏览器打开
                </Button>
              }
            >
              {!wiki_available && (
                <NoticeBox danger>
                  当前服务器未配置有效的 HTTPS Wiki 地址。
                </NoticeBox>
              )}
              {wiki_available && !supports_iframe && (
                <NoticeBox>
                  此客户端不支持内嵌 Wiki，请使用右上角按钮在外部浏览器打开。
                </NoticeBox>
              )}
              {wiki_available && supports_iframe && page_url && (
                <iframe
                  key={page_url}
                  src={page_url}
                  title={selected_title}
                  style={{ border: 0, height: '100%', width: '100%' }}
                />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

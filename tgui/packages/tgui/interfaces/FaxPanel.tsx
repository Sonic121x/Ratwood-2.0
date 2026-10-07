import React, { useEffect, useMemo, useState } from 'react';
import {
  Box,
  Button,
  Divider,
  LabeledList,

  Stack,
  Tabs,
  TextArea,
} from 'tgui-core/components'; import { Section } from '../components/Localized';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type HermesEntry = {
  num: number;
  tag: string;
};

type LetterEntry = {
  sender: string;
  recipient: string;
  sender_ckey: string;
  recipient_ckey: string;
  body: string;
};

type Data = {
  hermes_list: HermesEntry[];
  player_list: string[];
  master_exists: boolean;
  letter_history: LetterEntry[];
};

const STAMPS = [
  { key: 'none', label: '无' },
  { key: 'royal', label: '✦ 王室印章' },
  { key: 'inquisitor', label: '✠ 奥塔万宗教审判所' },
  { key: 'merchant', label: '⚖ 行会商人' },
  { key: 'steward', label: '❧ 岩丘宫廷总管' },
  { key: 'kingsfield', label: '⚜ 王田' },
  { key: 'kf_academy', label: '✦ 王田学院' },
  { key: 'kf_army', label: '⚔ 王田军队' },
  { key: 'kf_tax', label: '⚖ 税务署' },
  { key: 'kf_council', label: '★ 最高议会' },
];

const RIMS = [
  { key: 'none', label: '无' },
  { key: 'simple', label: '简朴' },
  { key: 'ornate', label: '华丽（金色）' },
  { key: 'royal', label: '王室（紫色）' },
  { key: 'inquisition', label: '宗教审判所（绯红色）' },
];

const STAMP_PREVIEW_STYLE: Record<string, React.CSSProperties> = {
  royal: {
    display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
    border: '3px solid #4a1a6e', background: '#f9f3e3', lineHeight: '58px',
    fontSize: '8px', fontWeight: 'bold', color: '#4a1a6e', textAlign: 'center', letterSpacing: '1px',
  },
  inquisitor: {
    display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
    border: '3px solid #6b0000', background: '#fff8f5', lineHeight: '58px',
    fontSize: '8px', fontWeight: 'bold', color: '#6b0000', textAlign: 'center',
  },
  merchant: {
    display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
    border: '3px solid #8b6914', background: '#fdfbe8', lineHeight: '58px',
    fontSize: '8px', fontWeight: 'bold', color: '#8b6914', textAlign: 'center',
  },
  steward: {
    display: 'inline-block', width: '64px', height: '64px', borderRadius: '50%',
    border: '3px solid #1a3a1a', background: '#f5fdf5', lineHeight: '58px',
    fontSize: '8px', fontWeight: 'bold', color: '#1a3a1a', textAlign: 'center',
  },
  kingsfield: {
    display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
    width: '64px', height: '64px', borderRadius: '50%',
    border: '3px solid #1a2e4a', background: '#eef4ff',
    fontSize: '8px', fontWeight: 'bold', color: '#1a2e4a', textAlign: 'center',
  },
  kf_academy: {
    display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
    width: '64px', height: '64px', borderRadius: '50%',
    border: '3px double #2a0a6e', background: '#f4f0ff',
    fontSize: '7px', fontWeight: 'bold', color: '#2a0a6e', textAlign: 'center',
    boxShadow: 'inset 0 0 8px #8060d0',
  },
  kf_army: {
    display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
    width: '64px', height: '64px', borderRadius: '50%',
    border: '3px solid #1c1c1c', background: '#e8e8ec',
    fontSize: '7px', fontWeight: 'bold', color: '#1c1c1c', textAlign: 'center', letterSpacing: '1px',
  },
  kf_tax: {
    display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
    width: '64px', height: '64px', borderRadius: '50%',
    border: '2px solid #6b4400', background: '#fffae8',
    fontSize: '6px', fontWeight: 'bold', color: '#6b4400', textAlign: 'center', lineHeight: '1.5',
  },
  kf_council: {
    display: 'inline-flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
    width: '78px', height: '78px', borderRadius: '50%',
    border: '4px double #8b6914', background: '#fffdf0',
    fontSize: '9px', fontWeight: 'bold', color: '#7a5500', textAlign: 'center',
    boxShadow: 'inset 0 0 12px #e0b840, 0 0 6px #c9a84c',
  },
};

const STAMP_LABELS: Record<string, React.ReactNode> = {
  royal: '✦ 王室 ✦',
  inquisitor: '✠ 奥塔万 ✠',
  merchant: '⚖ 行会 ⚖',
  steward: '❧ 宫廷总管 ❧',
  kingsfield: <><span>王田</span><span>城</span></>,
  kf_academy: <><span>王田</span><span>学院</span></>,
  kf_army: <><span>王田</span><span>军队</span></>,
  kf_tax: <><span>王田</span><span>税务</span><span>署</span></>,
  kf_council: <><span>最高</span><span>议会</span></>,
};

const RIM_PREVIEW_STYLE: Record<string, React.CSSProperties> = {
  simple: { border: '8px solid #2c1a0e' },
  ornate: { border: '12px double #8b6914', boxShadow: 'inset 0 0 14px #c9a84c' },
  royal: { border: '10px solid #4a1a6e', boxShadow: 'inset 0 0 16px #7a3db5' },
  inquisition: { border: '10px solid #6b0000', boxShadow: 'inset 0 0 14px #8b0000' },
};

export const FaxPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { hermes_list, player_list, master_exists, letter_history } = data;

  const [activePage, setActivePage] = useState<'send' | 'archive'>('send');
  const [previewIndex, setPreviewIndex] = useState<number | null>(null);
  const [sendMode, setSendMode] = useState<'player' | 'hermes'>('player');
  const [sender, setSender] = useState('');
  const [body, setBody] = useState('');
  const [previewBody, setPreviewBody] = useState('');
  const [previewDirty, setPreviewDirty] = useState(false);
  const [stamp, setStamp] = useState('none');
  const [rim, setRim] = useState('none');
  const [itemPath, setItemPath] = useState('');
  const [itemName, setItemName] = useState('');
  const [itemDesc, setItemDesc] = useState('');
  const [packageSize, setPackageSize] = useState(0); // 0 = auto
  const [playerRecipient, setPlayerRecipient] = useState(
    player_list?.[0] || '',
  );
  const [hermesNum, setHermesNum] = useState<number>(
    hermes_list?.[0]?.num ?? 1,
  );

  const trimmedSender = sender.trim();
  const trimmedBody = body.trim();
  const trimmedItemPath = itemPath.trim();
  const trimmedItemName = itemName.trim();
  const trimmedItemDesc = itemDesc.trim();

  const canSend = useMemo(
    () => (trimmedBody.length > 0 || stamp !== 'none' || trimmedItemPath.length > 0)
      && trimmedSender.length > 0
      && (sendMode === 'hermes'
        ? hermes_list?.length > 0
        : master_exists && !!playerRecipient),
    [trimmedBody, stamp, trimmedItemPath, trimmedSender, sendMode, hermes_list, master_exists, playerRecipient],
  );

  useEffect(() => {
    setPreviewDirty(true);
  }, [body]);

  useEffect(() => {
    if (!previewDirty) {
      return;
    }
    const handle = setTimeout(() => {
      setPreviewBody(body);
      setPreviewDirty(false);
    }, 450);
    return () => clearTimeout(handle);
  }, [previewDirty, body]);

  const updatePreview = () => {
    setPreviewBody(body);
    setPreviewDirty(false);
  };

  const previewHtml = useMemo(() => previewBody.replace(/\n/g, '<br>'), [previewBody]);

  return (
    <Window width={900} height={760} title="Admin Fax Panel" display_title="管理员信件面板">
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                selected={activePage === 'send'}
                onClick={() => setActivePage('send')}
              >
                发送信件
              </Tabs.Tab>
              <Tabs.Tab
                selected={activePage === 'archive'}
                onClick={() => setActivePage('archive')}
              >
                信件档案
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>

          {activePage === 'archive' ? (
            <Stack.Item>
              <Section title="Player Letter Archive" display_title="玩家信件档案">
                <Button icon="sync" onClick={() => act('refresh')}>
                  刷新
                </Button>
                <Box mt={1}>
                  {!letter_history || letter_history.length === 0 ? (
                    <Box color="label" italic>
                      尚无已发送的玩家信件。
                    </Box>
                  ) : (
                    letter_history.map((entry, index) => (
                      <Box
                        key={`${entry.sender}-${entry.recipient}-${entry.sender_ckey}-${entry.recipient_ckey}-${index}`}
                        className="candystripe"
                        p={1}
                        mb={1}
                        style={{
                          border: '1px solid rgba(255, 255, 255, 0.08)',
                          borderRadius: '4px',
                          whiteSpace: 'pre-wrap',
                          wordBreak: 'break-word',
                        }}
                      >
                        <Box bold>
                          寄件人：{entry.sender || '匿名'}
                        </Box>
                        <Box color="label" fontSize="0.85em">
                          寄件人 ckey：{entry.sender_ckey || '未知'}
                        </Box>
                        <Box bold>
                          收件人：{entry.recipient || '未知'}
                        </Box>
                        <Box color="label" fontSize="0.85em">
                          收件人 ckey：{entry.recipient_ckey || '未知'}
                        </Box>
                        <Box mt={1}>
                          <Button
                            compact
                            icon="file-alt"
                            onClick={() => setPreviewIndex(previewIndex === index ? null : index)}
                          >
                            {previewIndex === index ? '隐藏预览' : '预览信件'}
                          </Button>
                        </Box>
                        {previewIndex === index && (
                          <Box mt={1} style={{ border: '1px solid #8f7142', borderRadius: '4px', overflow: 'hidden' }}>
                            <Box
                              style={{
                                background: '#fdf6e3',
                                color: '#2c1a0e',
                                padding: '12px',
                                fontFamily: 'serif',
                                minHeight: '80px',
                                lineHeight: 1.5,
                              }}
                            >
                              <Box
                                style={{
                                  fontStyle: 'italic',
                                  color: '#5a3e1b',
                                  borderBottom: '1px solid #c8aa7a',
                                  paddingBottom: '4px',
                                  marginBottom: '6px',
                                }}
                              >
                                寄件人：{entry.sender || '匿名'}
                              </Box>
                              <Box
                                dangerouslySetInnerHTML={{
                                  __html: (entry.body || '（空信件）').replace(/\r?\n/g, '<br>'),
                                }}
                              />
                            </Box>
                          </Box>
                        )}
                      </Box>
                    ))
                  )}
                </Box>
              </Section>
            </Stack.Item>
          ) : (
            <>
              <Stack.Item>
                <Section title="Sender" display_title="寄件人">
                  <LabeledList>
                    <LabeledList.Item label="寄件人">
                      <input
                        style={{ width: '100%', padding: '2px 4px' }}
                        placeholder="例如：大公、匿名……"
                        value={sender}
                        onChange={(e) => setSender((e.target as HTMLInputElement).value)}
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="Recipient" display_title="收件人">
                  <Stack>
                    <Stack.Item>
                      <Button
                        selected={sendMode === 'player'}
                        onClick={() => setSendMode('player')}
                      >
                        按角色姓名
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        selected={sendMode === 'hermes'}
                        onClick={() => setSendMode('hermes')}
                      >
                        按赫尔墨斯编号
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button icon="sync" onClick={() => act('refresh')}>
                        刷新
                      </Button>
                    </Stack.Item>
                  </Stack>
                  <Box mt={1}>
                    {sendMode === 'player' ? (
                      master_exists ? (
                        player_list?.length > 0 ? (
                          <select
                            style={{ width: '100%', padding: '2px' }}
                            value={playerRecipient}
                            onChange={(e) =>
                              setPlayerRecipient(
                                (e.target as HTMLSelectElement).value,
                              )
                            }
                          >
                            {player_list.map((name) => (
                              <option key={name} value={name}>
                                {name}
                              </option>
                            ))}
                          </select>
                        ) : (
                          <Box color="average">没有在线玩家。</Box>
                        )
                      ) : (
                        <Box color="bad">邮件总机离线，无法按姓名寄送。</Box>
                      )
                    ) : hermes_list?.length > 0 ? (
                      <select
                        style={{ width: '100%', padding: '2px' }}
                        value={hermesNum}
                        onChange={(e) =>
                          setHermesNum(
                            Number((e.target as HTMLSelectElement).value),
                          )
                        }
                      >
                        {hermes_list.map((h) => (
                          <option key={h.num} value={h.num}>
                            #{h.num}
                            {h.tag ? ` — ${h.tag}` : ''}
                          </option>
                        ))}
                      </select>
                    ) : (
                      <Box color="bad">此地图没有赫尔墨斯邮件机。</Box>
                    )}
                  </Box>
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="Letter Body" display_title="信件正文">
                  <Box mb={1}>
                    <Button
                      icon="sync"
                      color={previewDirty ? 'average' : undefined}
                      onClick={updatePreview}>
                      更新预览
                    </Button>
                  </Box>
                  <TextArea
                    height="200px"
                    width="100%"
                    style={{ display: 'block', boxSizing: 'border-box' }}
                    value={body}
                    onChange={(value: string) => setBody(value)}
                    placeholder="在此撰写信件。支持 HTML：&lt;b&gt;粗体&lt;/b&gt;、&lt;i&gt;斜体&lt;/i&gt;、&lt;br&gt;。按 Shift+Enter 换行。"
                  />
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Stack>
                  <Stack.Item grow>
                    <Section title="Wax Stamp" display_title="蜡封印章">
                      <Stack vertical>
                        {STAMPS.map((s) => (
                          <Stack.Item key={s.key}>
                            <Button
                              fluid
                              selected={stamp === s.key}
                              onClick={() => setStamp(s.key)}
                            >
                              {s.label}
                            </Button>
                          </Stack.Item>
                        ))}
                      </Stack>
                    </Section>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Section title="Letter Rim" display_title="信纸边框">
                      <Stack vertical>
                        {RIMS.map((r) => (
                          <Stack.Item key={r.key}>
                            <Button
                              fluid
                              selected={rim === r.key}
                              onClick={() => setRim(r.key)}
                            >
                              {r.label}
                            </Button>
                          </Stack.Item>
                        ))}
                      </Stack>
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item>
                <Section title="Preview" display_title="预览">
                  <Box style={rim !== 'none' ? RIM_PREVIEW_STYLE[rim] : {}}>
                    <Box
                      style={{
                        background: '#fdf6e3',
                        padding: '12px',
                        fontFamily: 'serif',
                        minHeight: '80px',
                      }}
                    >
                      {sender && (
                        <Box
                          style={{
                            fontStyle: 'italic',
                            color: '#5a3e1b',
                            borderBottom: '1px solid #c8aa7a',
                            paddingBottom: '4px',
                            marginBottom: '6px',
                          }}
                        >
                          寄件人：{sender}
                        </Box>
                      )}
                      {body && (
                        <Box
                          color="black"
                          style={{ fontFamily: 'serif' }}
                          dangerouslySetInnerHTML={{ __html: previewHtml }}
                        />
                      )}
                      {stamp !== 'none' && (
                        <Box textAlign="center" mt={1}>
                          <span style={STAMP_PREVIEW_STYLE[stamp]}>
                            {STAMP_LABELS[stamp]}
                          </span>
                        </Box>
                      )}
                      {!sender && !body && stamp === 'none' && (
                        <Box color="grey" italic>
                          暂无可预览内容。
                        </Box>
                      )}
                    </Box>
                  </Box>
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="Parcel Item (Optional)" display_title="包裹物品（可选）">
                  <LabeledList>
                    <LabeledList.Item label="物品路径">
                      <input
                        style={{ width: '100%', padding: '2px 4px', fontFamily: 'monospace' }}
                        placeholder="例如：/obj/item/coin/gold"
                        value={itemPath}
                        onChange={(e) => setItemPath((e.target as HTMLInputElement).value)}
                      />
                    </LabeledList.Item>
                    {trimmedItemPath && (
                      <>
                        <LabeledList.Item label="物品名称">
                          <input
                            style={{ width: '100%', padding: '2px 4px' }}
                            placeholder="覆盖物品名称（留空保留默认值）"
                            value={itemName}
                            onChange={(e) => setItemName((e.target as HTMLInputElement).value)}
                          />
                        </LabeledList.Item>
                        <LabeledList.Item label="物品描述">
                          <input
                            style={{ width: '100%', padding: '2px 4px' }}
                            placeholder="覆盖物品描述（留空保留默认值）"
                            value={itemDesc}
                            onChange={(e) => setItemDesc((e.target as HTMLInputElement).value)}
                          />
                        </LabeledList.Item>
                        <LabeledList.Item label="包裹尺寸">
                          <select
                            style={{ padding: '2px' }}
                            value={packageSize}
                            onChange={(e) => setPackageSize(Number((e.target as HTMLSelectElement).value))}
                          >
                            <option value={0}>自动（根据物品）</option>
                            <option value={1}>1 — 微小</option>
                            <option value={2}>2 — 小型</option>
                            <option value={3}>3 — 普通</option>
                            <option value={4}>4 — 大型</option>
                            <option value={5}>5 — 巨大</option>
                            <option value={6}>6 — 庞大</option>
                          </select>
                        </LabeledList.Item>
                        <LabeledList.Item label="">
                          <Box color="average">
                            若填写了信件，将作为可阅读的纸条随包裹附送。
                          </Box>
                        </LabeledList.Item>
                      </>
                    )}
                  </LabeledList>
                </Section>
              </Stack.Item>

              <Divider />

              <Stack.Item textAlign="right">
                <Button
                  color="good"
                  disabled={!canSend}
                  onClick={() =>
                    act('send', {
                      sender,
                      body,
                      stamp,
                      rim,
                      send_mode: sendMode,
                      recipient: playerRecipient,
                      hermes_num: hermesNum,
                      item_path: trimmedItemPath,
                      item_name: trimmedItemName,
                      item_desc: trimmedItemDesc,
                      package_size: packageSize,
                    })
                  }
                >
                  {trimmedItemPath ? '发送包裹' : '发送信件'}
                </Button>
              </Stack.Item>
            </>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

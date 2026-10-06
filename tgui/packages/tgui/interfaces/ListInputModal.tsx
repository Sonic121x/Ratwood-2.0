import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Autofocus, Button, Divider, Input, Section, Stack } from 'tgui-core/components';
import { isAlphabetic, isNumeric, KEY } from 'tgui-core/keys';

import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

type ListInputData = {
  enable_preview: boolean;
  init_value: string;
  items: string[];
  large_buttons: boolean;
  message: string;
  previewing: boolean;
  timeout: number;
  title: string;
};

export const ListInputModal = (props) => {
  const { act, data } = useBackend<ListInputData>();
  const {
    items = [],
    message = '',
    init_value,
    large_buttons,
    timeout,
    title,
    enable_preview,
    previewing,
  } = data;
  const [selected, setSelected] = useState(items.indexOf(init_value));
  const [searchBarVisible, setSearchBarVisible] = useState(items.length > 9);
  const [searchQuery, setSearchQuery] = useState('');
  // User presses up or down on keyboard
  // Simulates clicking an item

  const onArrowKey = (key: KEY) => {
    const len = filteredItems.length - 1;
    if (key === KEY.Down) {
      if (selected === null || selected === len) {
        setSelected(0);
        document!.getElementById('0')?.scrollIntoView();
      } else {
        setSelected(selected + 1);
        document!.getElementById((selected + 1).toString())?.scrollIntoView();
      }
    } else if (key === KEY.Up) {
      if (selected === null || selected === 0) {
        setSelected(len);
        document!.getElementById(len.toString())?.scrollIntoView();
      } else {
        setSelected(selected - 1);
        document!.getElementById((selected - 1).toString())?.scrollIntoView();
      }
    }
  };
  // User selects an item with mouse
  const onClick = (index: number) => {
    if (index === selected) {
      return;
    }
    setSelected(index);
  };
  // User presses a letter key and searchbar is visible
  const onFocusSearch = () => {
    setSearchBarVisible(false);
    setTimeout(() => {
      setSearchBarVisible(true);
    }, 1);
  };
  // User presses a letter key with no searchbar visible
  const onLetterSearch = (key: string) => {
    const foundItem = items.find((item) => {
      return item?.toLowerCase().startsWith(key?.toLowerCase());
    });
    if (foundItem) {
      const foundIndex = items.indexOf(foundItem);
      setSelected(foundIndex);
      document!.getElementById(foundIndex.toString())?.scrollIntoView();
    }
  };
  // User types into search bar
  const onSearch = (query: string) => {
    if (query === searchQuery) {
      return;
    }
    setSearchQuery(query);
    setSelected(0);
    document!.getElementById('0')?.scrollIntoView();
  };
  // User presses the search button
  const onSearchBarToggle = () => {
    setSearchBarVisible(!searchBarVisible);
    setSearchQuery('');
  };
  const filteredItems = items.filter((item) =>
    item?.toLowerCase().includes(searchQuery.toLowerCase()),
  );
  // Dynamically changes the window height based on the message.
  const windowHeight =
    325 + Math.ceil(message.length / 3) + (large_buttons ? 5 : 0);
  // Grabs the cursor when no search bar is visible.
  if (!searchBarVisible) {
    setTimeout(() => document!.getElementById(selected.toString())?.focus(), 1);
  }

  function handleKeyDown<T>(event: React.KeyboardEvent<T>) {
    const key = event.key;
    if (key === KEY.Down || key === KEY.Up) {
      event.preventDefault();
      onArrowKey(key);
    }
    if (key === KEY.Enter) {
      event.preventDefault();
      act('submit', { entry: filteredItems[selected] });
    }
    if (!searchBarVisible && (isAlphabetic(key) || isNumeric(key))) {
      event.preventDefault();
      onLetterSearch(key);
    }
    if (key === KEY.Escape) {
      event.preventDefault();
      act('cancel');
    }
  }

  return (
    <Window title={title} display_title={({ XYLIX: '赛利克斯', PESTRA: '佩斯特拉', Graggar: '格拉加尔', 'Combat Music': '战斗音乐', 'Prayer of Foolish Repentance': '愚者悔罪祷文' } as Record<string, string>)[title] ?? title} width={325} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content
        onKeyDown={(event) => {
          handleKeyDown(event);
        }}
      >
        <Section
          buttons={
            <Button
              compact
              icon={searchBarVisible ? 'search' : 'font'}
              selected
              tooltip={
                searchBarVisible
                  ? '搜索模式：输入文本搜索，或使用方向键选择。'
                  : '快捷键模式：输入字母跳到首个匹配项，按回车选择。'
              }
              tooltipPosition="left"
              onClick={() => onSearchBarToggle()}
            />
          }
          className="ListInput__Section"
          fill
          title={message}
        >
          <Stack fill vertical>
            <Stack.Item grow>
              <ListDisplay
                filteredItems={filteredItems}
                onClick={onClick}
                onFocusSearch={onFocusSearch}
                searchBarVisible={searchBarVisible}
                selected={selected}
              />
            </Stack.Item>
            {searchBarVisible && (
              <Input
                autoFocus
                autoSelect
                fluid
                expensive
                onEnter={() => {
                  act('submit', { entry: filteredItems[selected] });
                }}
                onChange={onSearch}
                placeholder="搜索……"
                value={searchQuery}
              />
            )}
            {!searchBarVisible && <Divider />}
            <Stack.Item>
              <Stack align="center" fill justify="space-around">
                {!!enable_preview && (
                  <Stack.Item>
                    <Button
                      color="transparent"
                      className={previewing ? 'input-button__cancel' : 'input-button__submit'}
                      disabled={!filteredItems.length || selected === null || selected < 0}
                      m={0.5}
                      onClick={() =>
                        act('preview_toggle', { entry: filteredItems[selected] })
                      }
                      textAlign="center"
                    >
                      {previewing ? '停止' : '试听'}
                    </Button>
                  </Stack.Item>
                )}
                <Stack.Item>
                  <InputButtons input={filteredItems[selected]} />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

/**
 * Displays the list of selectable items.
 * If a search query is provided, filters the items.
 */
const ListDisplay = (props) => {
  const { act } = useBackend<ListInputData>();
  const { filteredItems, onClick, onFocusSearch, searchBarVisible, selected } =
    props;

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    const key = event.key;
    if (searchBarVisible && (isAlphabetic(key) || isNumeric(key))) {
      event.preventDefault();
      onFocusSearch();
    }
  }

  return (
    <Section fill scrollable>
      <Autofocus />
      {filteredItems.map((item, index) => {
        return (
          <Button
            className="candystripe"
            color="transparent"
            fluid
            id={index}
            key={index}
            onClick={() => onClick(index)}
            onDoubleClick={(event) => {
              event.preventDefault();
              act('submit', { entry: filteredItems[selected] });
            }}
            onKeyDown={(event) => {
              handleKeyDown(event);
            }}
            selected={index === selected}
            style={{
              animation: 'none',
              transition: 'none',
            }}
          >
            {(({ 'Astrata 之光': '阿斯特拉塔之光', 'Astrata 狂热': '阿斯特拉塔狂热', 'Dendor 教士（守林者）': '登多尔教士（守林者）', 'Eora 教士': '伊欧拉教士', Psydonite: '普赛顿信徒', 'Dendorite Construct': '登多尔构装体', 'Pestran Construct': '佩斯特拉构装体', 'astratan crown Crest': '阿斯特拉塔王冠饰纹', 'Eora Doth Watches': '伊欧拉注视着', "Abyssor's Bane": '阿比索尔之灾', 'Necra 的摇篮曲（女声）': '内克拉的摇篮曲（女声）', 'Rune of ZIZO': '齐佐符文', 'Black Oak 的守卫': '黑橡的守卫', 'Condottiero 公会成员': '佣兵首领公会成员', 'Combat Old 2': '经典战斗曲 2', '审判官 - Ordinator': '审判官 - 律令官', 'Maniac (Old)': '疯子（旧版）', 'Vampire (Old)': '吸血鬼（旧版）', 'Werewolf (Old)': '狼人（旧版）', 'Thespian-Errant': '巡游演员', 'Herald of Progress': '进步先驱', "Crocs de l'araignée": '蜘蛛之牙', 'Drow Classic': '卓尔经典曲', Freifechter: '自由剑士', 'Freifechter, Fencer': '自由剑士，击剑手', 'Freifechter, Lancer': '自由剑士，长枪手', 'Freifechter, Sabrist': '自由剑士，军刀手', 'Aavnic Shepherd': '阿夫尼克牧羊人', 'Rune of Violence': '暴力之符文', 'Rune of Transaction': '交易之符文', 'Rune of Hedonism': '享乐之符文', 'Rune of Sun': '太阳之符文', 'Rune of Moon': '月亮之符文', 'Rune of Beasts': '野兽之符文', 'Rune of Forge': '锻炉之符文', 'Rune of Trickery': '诡计之符文', 'Rune of Death': '死亡之符文', 'Rune of Plague': '瘟疫之符文', 'Rune of Love': '爱之符文', 'Rune of Justice': '正义之符文', 'Rune of Storm': '风暴之符文', 'Rune of Stirring': '翻涌之符文', 'Rune of Enduring': '坚忍之符文', 'Her Healing Tears': '她治愈的泪水', "Peddler's Tale": '小贩的故事', 'We Toil Together': '我们一同劳作', 'Just One More, Tavern Wench': '酒馆姑娘，再来一杯', 'Moonlight Carnival': '月光狂欢', "'Ye Best Be Goin'": '你最好走吧', 'Beloved Blue': '心爱的蓝色', "Barbarian's Moot": '野蛮人的集会', 'Muster the Wardens': '集结守林人', 'The Earth That Quakes': '震颤的大地', 'The Power': '力量', 'Bard Dance': '吟游诗人之舞', 'Old Time Battles': '往日之战', "Half-Dragon's Ten Mammon": '半龙人的十枚玛门', "'The Local Favorite'": '本地最爱', 'Rous in the Cellar': '酒窖里的巨鼠', 'Her Boots, So Incandescent': '她的靴子如此耀眼', 'Moondust Minx': '月尘妖女', 'Quest to the Ends': '远至尽头的旅程', 'Spit Shine': '擦得锃亮', 'Fire-Cast Shadows': '火光投下的影子', 'The Forced Hand': '被迫出手', 'Regrets Unpaid': '未偿的悔恨', "'Took the Mammon and Ran'": '拿了玛门就跑', "Poor Man's Tithe": '穷人的什一税', "In His Arms Ye'll Find Me": '在祂怀中寻我', 'El Odio': '憎恨', 'Danza De Las Lanzas': '长矛之舞', 'The Feline, Forever Returning': '永远归来的猫', 'El Beso Carmesí': '绯红之吻', "The Queen's High Seas": '女王的公海', 'Harsh Testimony': '严酷的证词', 'Someone Fair': '美丽的人', 'Daisies in Bloom': '盛放的雏菊', 'Through Thine Window, He Glanced': '他透过你的窗户望来', 'The Lady of Red Silks': '红绸女士', 'On the Breeze': '随风而行', 'Never Enough': '永不满足', 'Sundered Heart': '破碎的心', 'Corridors of Time': '时间回廊', Determination: '决心', "Ruler's One Ring": '统治者的唯一戒指', 'Tangled Trod': '纠缠的小路', Motus: '运动', Becalmed: '风平浪静', 'The Bloody Throne': '血腥王座', 'We Shall Sail Together': '我们将一同起航', 'Laid To Rest': '安息', Fulmen: '雷霆', Painkiller: '止痛药', "A Knight's Return": '骑士归来', 'Amongst Fare Friends': '旅伴之间', 'The Road Traveled by Few': '少有人行的路', 'Tip Thine Tankard': '举起你的酒杯', 'A Reed On the Wind': '风中芦苇', 'Jests On Steel Ears': '铁耳听笑话', 'Merchant in the Mire': '泥沼中的商人', 'Disciples Tower': '门徒之塔', 'Green Sleeves': '绿袖子', 'Midyear Melancholy': '年中忧郁', 'Santa Psydonia': '神圣普赛多尼亚', 'Le Venardine': '维纳丁', 'Vespermill Fair': '暮磨集市', Amoroso: '爱之曲', "Lupian's Lullaby": '卢皮安的摇篮曲', 'White Wine Before Breakfast': '早餐前的白葡萄酒', 'Chevalier de Naledi': '纳莱迪骑士', 'A Rambling Tongue': '漫谈之舌', Ashitaka: '阿席达卡', 'Daimyo Dreamwalker': '梦行大名', 'Emperor of Flame': '烈焰帝王', 'Fire Phoenix': '火凤凰', 'Kaiju Islands': '怪兽群岛', 'Lavender Village': '薰衣草村', 'Morning Is Coming': '清晨将至', 'Pouncing Shadow': '扑击之影', 'Rising Sun': '旭日', 'Those Who Fight': '战斗之人', 'Village in the Mountains': '山中村庄', 'Winning the Soul': '赢得灵魂', 'Cursed Apple': '诅咒苹果', 'Fire Dance': '火之舞', Lute: '鲁特琴', 'Tsugaru Ripple': '津轻涟漪', Tsugaru: '津轻', Season: '季节', Parade: '游行', Koshiro: '小次郎', 'Royal Entrance': '王室入场', 'Royal Exit': '王室退场', 'Royal News': '王室消息', 'Royal Fanfare': '王室号角', 'Royal Fanfare 2': '王室号角2', 'Royal Wedding': '王室婚礼', 'Honoring the Fallen': '致敬逝者', 'Dainty Man': '文雅的男子', 'Harpy in the Morning': '晨间鹰身女妖', 'Heartfelt Forever': '永恒真心', 'Homeward Jig': '归乡吉格舞', 'On the Sea Shore': '在海岸上', "Soldier's Rest": '士兵的安息', 'Otavan Madame': '奥塔万女士', "Bog Man's Jig": '沼泽人的吉格舞', "Pockets Full o' Mammon": '满口袋玛门', "Kickin' the Muck Off": '踢掉泥污', "Soggy Shoes n' Bilgewater Boots": '湿鞋与舱底水靴', "Nothin' but Fog": '只有浓雾', 'The Tipsy Toad': '微醺蟾蜍', "Tangled in th' Reeds": '困在芦苇中', 'Deep in the Peat': '泥炭深处', "Militia Man's Woes": '民兵的烦恼', 'My Chilly Bones': '冰冷的骨头', 'Lonesome by the Campfire': '篝火旁的孤独', 'Herding in the Heat': '烈日下放牧', 'Soaked to the Bone': '湿透骨髓', 'To Our Friends Felled': '致倒下的朋友', 'Fly Away': '飞走', "Nomad's Call": '游牧者的呼唤', 'Spirit of the Steppes': '草原之魂', 'The Mountain of Wisdom': '智慧之山', 'Who Told You': '谁告诉你的', 'Far Flung Tale': '远方的故事', 'G Major Cello Suite No. 1': 'G大调第一大提琴组曲', "Ursine's Home": '熊的家', 'Mead, Gold and Blood': '蜂蜜酒、黄金与鲜血', "Gasgow's Reel": '加斯戈里尔舞曲', "Harpy's Call (Feminine)": '鹰身女妖的呼唤（女声）', 'Death Touched Aasimar (Feminine)': '死亡触及的亚斯玛尔（女声）', 'Our Mother, Our Divine (Feminine)': '我们的母亲，我们的神（女声）', 'Wed, Forever More (Feminine)': '成婚，直到永远（女声）', 'Paper Boats (Feminine + Vocals)': '纸船（女声与歌唱）', "The Dragon's Blood Surges (Masculine)": '龙血涌动（男声）', 'Timeless Temple (Masculine)': '永恒神殿（男声）', "Angel's Earnt Halo (Masculine)": '天使挣得的光环（男声）', 'A Fabled Choir (Masculine)': '传说中的合唱（男声）', 'A Pained Farewell (Masculine + Feminine)': '痛苦的告别（男女合唱）', 'The Power (Whistling)': '力量（口哨）', 'Bard Dance (Whistling)': '吟游诗人之舞（口哨）', 'Old Time Battles (Whistling)': '往日之战（口哨）' } as Record<string, string>)[item] ?? item).replace(/^\w/, (c) => c.toUpperCase())}
          </Button>
        );
      })}
    </Section>
  );
};

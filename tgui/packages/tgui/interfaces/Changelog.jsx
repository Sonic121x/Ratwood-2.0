import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { Component, Fragment } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Stack,
  Table,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Section } from '../components/Localized';
import { Window } from '../layouts';

const icons = {
  add: { icon: 'check-circle', color: 'green' },
  admin: { icon: 'user-shield', color: 'purple' },
  balance: { icon: 'balance-scale-right', color: 'yellow' },
  bugfix: { icon: 'bug', color: 'green' },
  code_imp: { icon: 'code', color: 'green' },
  config: { icon: 'cogs', color: 'purple' },
  expansion: { icon: 'check-circle', color: 'green' },
  experiment: { icon: 'radiation', color: 'yellow' },
  image: { icon: 'image', color: 'green' },
  imageadd: { icon: 'tg-image-plus', color: 'green' },
  imagedel: { icon: 'tg-image-minus', color: 'red' },
  qol: { icon: 'hand-holding-heart', color: 'green' },
  refactor: { icon: 'tools', color: 'green' },
  rscadd: { icon: 'check-circle', color: 'green' },
  rscdel: { icon: 'times-circle', color: 'red' },
  server: { icon: 'server', color: 'purple' },
  sound: { icon: 'volume-high', color: 'green' },
  soundadd: { icon: 'tg-sound-plus', color: 'green' },
  sounddel: { icon: 'tg-sound-minus', color: 'red' },
  spellcheck: { icon: 'spell-check', color: 'green' },
  map: { icon: 'map', color: 'green' },
  tgs: { icon: 'toolbox', color: 'purple' },
  tweak: { icon: 'wrench', color: 'green' },
  unknown: { icon: 'info-circle', color: 'label' },
  wip: { icon: 'hammer', color: 'orange' },
};

export class Changelog extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: '正在加载更新日志……',
      selectedDate: '',
      selectedIndex: 0,
    };
    this.dateChoices = [];
  }

  setData(data) {
    this.setState({ data });
  }

  setSelectedDate(selectedDate) {
    this.setState({ selectedDate });
  }

  setSelectedIndex(selectedIndex) {
    this.setState({ selectedIndex });
  }

  getData = (date, attemptNumber = 1) => {
    const { act } = useBackend();
    const self = this;
    const maxAttempts = 6;

    if (attemptNumber > maxAttempts) {
      return this.setData(`尝试 ${maxAttempts} 次后仍无法加载数据`);
    }

    act('get_month', { date });

    fetch(resolveAsset(`${date}.yml`)).then(async (changelogData) => {
      const result = await changelogData.text();
      const errorRegex = /^Cannot find/;

      if (errorRegex.test(result)) {
        const timeout = 50 + attemptNumber * 50;

        self.setData(`正在加载更新日志${'.'.repeat(attemptNumber + 3)}`);
        setTimeout(() => {
          self.getData(date, attemptNumber + 1);
        }, timeout);
      } else {
        self.setData(yaml.load(result, { schema: yaml.CORE_SCHEMA }));
      }
    });
  };

  componentDidMount() {
    const {
      data: { dates = [] },
    } = useBackend();

    if (dates) {
      dates.forEach((date) =>
        this.dateChoices.push(dateformat(date, 'yyyy年m月', true)),
      );
      this.setSelectedDate(this.dateChoices[0]);
      this.getData(dates[0]);
    }
  }

  render() {
    const { data, selectedDate, selectedIndex } = this.state;
    const {
      data: { dates },
    } = useBackend();
    const { dateChoices } = this;

    const dateDropdown = dateChoices.length > 0 && (
      <Stack>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === 0}
            icon={'chevron-left'}
            onClick={() => {
              const index = selectedIndex - 1;

              this.setData('正在加载更新日志……');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            autoScroll={false}
            options={dateChoices}
            onSelected={(value) => {
              const index = dateChoices.indexOf(value);

              this.setData('正在加载更新日志……');
              this.setSelectedIndex(index);
              this.setSelectedDate(value);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
            selected={selectedDate}
            width="150px"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === dateChoices.length - 1}
            icon={'chevron-right'}
            onClick={() => {
              const index = selectedIndex + 1;

              this.setData('正在加载更新日志……');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
      </Stack>
    );

    const header = (
      <Section>
        <h1>Ratwood Keep</h1>
        <p>
          <b>鸣谢：</b>
          Baystation 12、/vg/station、NTstation、CDK Station 的开发者，
          FacepunchStation、GoonStation 的开发者，原版太空站13的
          开发者，绘制标题图片的 Invisty，以及无数多年来为
          游戏、问题追踪和维基作出贡献的人。
        </p>
        <p>
          {'当前组织成员可在'}
          <a href="https://github.com/orgs/Rotwood-Vale/people">此处</a>
          {'查看，近期 GitHub 贡献者可在'}
          <a href="https://github.com/Rotwood-Vale/Ratwood-Keep/pulse/monthly">
            此处查看
          </a>
          。
        </p>
        <p>
          {'你也可以通过'}
          <a href="https://discord.com/invite/MfG4bvN8ns">此处加入我们的 Discord</a>。
        </p>
        {dateDropdown}
      </Section>
    );

    const footer = (
      <Section>
        {dateDropdown}
        <h3>GoonStation 13 开发团队</h3>
        <p>
          <b>程序开发：</b>
          Stuntwaffle, Showtime, Pantaloons, Nannek, Keelin, Exadv1, hobnob,
          Justicefries, 0staf, sniperchance, AngriestIBM, BrianOBlivion
        </p>
        <p>
          <b>像素美术：</b>
          Supernorn, Haruhi, Stuntwaffle, Pantaloons, Rho, SynthOrange, I Said
          No
        </p>
        <p>
          Traditional Games 太空站13感谢 GoonStation 13
          开发团队在游戏发展至
          {' r4407 版本期间作出的贡献。r4407 及此前的更新日志可在'}
          <a href="https://wiki.ss13.co/Pre-2016_Changelog#April_2010">此处查看</a>。
        </p>
        <p>
          {'除另有说明外，Goon Station 13 采用'}
          <a href="https://creativecommons.org/licenses/by-nc-sa/3.0/">
            知识共享署名—非商业性使用—相同方式共享 3.0 许可协议
          </a>
          {'。目前仅向'}
          <a href="http://forums.somethingawful.com/">SomethingAwful Goons</a>
          {'授予相关权利。'}
        </p>
        <h3>Traditional Games 太空站13许可协议</h3>
        <p>
          {'在'}
          <a
            href={
              'https://github.com/tgstation/tgstation/commit/' +
              '333c566b88108de218d882840e61928a9b759d8f'
            }
          >
            2014年12月31日太平洋标准时间
            下午4:38的提交 333c566b88108de218d882840e61928a9b759d8f
          </a>
          {'之后的所有代码均采用'}
          <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>
          {'。该提交之前的所有代码均采用'}
          <a href="https://www.gnu.org/licenses/gpl-3.0.html">GNU GPL v3</a>
          {'，工具亦包含在内，除非其说明文档另有规定。详情请参阅'}
          <a href="https://github.com/tgstation/tgstation/blob/master/LICENSE">
            LICENSE
          </a>
          {'与'}
          <a href="https://github.com/tgstation/tgstation/blob/master/GPLv3.txt">
            GPLv3.txt
          </a>
          {'。'}
        </p>
        <p>
          TGS DMAPI API 作为子项目采用 MIT 许可协议。
          {'许可内容请参阅'}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/__DEFINES/tgs.dm'
            }
          >
            code/__DEFINES/tgs.dm
          </a>
          {'的页尾及'}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/modules/tgs/LICENSE'
            }
          >
            code/modules/tgs/LICENSE
          </a>
          {'。'}
        </p>
        <p>
          {'除另有说明外，包括图标和音效在内的所有资源均采用'}
          <a href="https://creativecommons.org/licenses/by-sa/3.0/">
            知识共享署名—相同方式共享 3.0 许可协议
          </a>
          {'。'}
        </p>
      </Section>
    );

    const changes =
      typeof data === 'object' &&
      Object.keys(data).length > 0 &&
      Object.entries(data)
        .reverse()
        .map(([date, authors]) => (
          <Section key={date} title={dateformat(date, 'd mmmm yyyy', true)} display_title={dateformat(date, 'yyyy年m月d日', true)}>
            <Box ml={3}>
              {Object.entries(authors).map(([name, changes]) => (
                <Fragment key={name}>
                  <h4>{name} changed:</h4>
                  <Box ml={3}>
                    <Table>
                      {changes.map((change) => {
                        const changeType = Object.keys(change)[0];
                        return (
                          <Table.Row key={changeType + change[changeType]}>
                            <Table.Cell
                              className={classes([
                                'Changelog__Cell',
                                'Changelog__Cell--Icon',
                              ])}
                            >
                              <Icon
                                color={
                                  icons[changeType]
                                    ? icons[changeType].color
                                    : icons.unknown.color
                                }
                                name={
                                  icons[changeType]
                                    ? icons[changeType].icon
                                    : icons.unknown.icon
                                }
                              />
                            </Table.Cell>
                            <Table.Cell className="Changelog__Cell">
                              {change[changeType]}
                            </Table.Cell>
                          </Table.Row>
                        );
                      })}
                    </Table>
                  </Box>
                </Fragment>
              ))}
            </Box>
          </Section>
        ));

    return (
      <Window title="Changelog" display_title="更新日志" width={675} height={650}>
        <Window.Content scrollable>
          {header}
          {changes}
          {typeof data === 'string' && <p>{data}</p>}
          {footer}
        </Window.Content>
      </Window>
    );
  }
}

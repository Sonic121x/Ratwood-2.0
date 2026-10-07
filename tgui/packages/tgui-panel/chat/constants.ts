/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const MAX_VISIBLE_MESSAGES = 2500;
export const MAX_PERSISTED_MESSAGES = 1000;
export const MESSAGE_SAVE_INTERVAL = 10000;
export const MESSAGE_PRUNE_INTERVAL = 60000;
export const COMBINE_MAX_MESSAGES = 5;
export const COMBINE_MAX_TIME_WINDOW = 5000;
export const IMAGE_RETRY_DELAY = 250;
export const IMAGE_RETRY_LIMIT = 10;
export const IMAGE_RETRY_MESSAGE_AGE = 60000;

// Default message type
export const MESSAGE_TYPE_UNKNOWN = 'unknown';

// Internal message type
export const MESSAGE_TYPE_INTERNAL = 'internal';

// Must match the set of defines in code/__DEFINES/chat.dm
export const MESSAGE_TYPE_SYSTEM = 'system';
export const MESSAGE_TYPE_LOCALCHAT = 'localchat';
export const MESSAGE_TYPE_RADIO = 'radio';
export const MESSAGE_TYPE_ENTERTAINMENT = 'entertainment';
export const MESSAGE_TYPE_INFO = 'info';
export const MESSAGE_TYPE_WARNING = 'warning';
export const MESSAGE_TYPE_DEADCHAT = 'deadchat';
export const MESSAGE_TYPE_OOC = 'ooc';
export const MESSAGE_TYPE_ADMINPM = 'adminpm';
export const MESSAGE_TYPE_COMBAT = 'combat';
export const MESSAGE_TYPE_ADMINCHAT = 'adminchat';
export const MESSAGE_TYPE_MODCHAT = 'modchat';
export const MESSAGE_TYPE_PRAYER = 'prayer';
export const MESSAGE_TYPE_EVENTCHAT = 'eventchat';
export const MESSAGE_TYPE_ADMINLOG = 'adminlog';
export const MESSAGE_TYPE_ATTACKLOG = 'attacklog';
export const MESSAGE_TYPE_DEBUG = 'debug';

// Metadata for each message type
export const MESSAGE_TYPES = [
  // Always-on types
  {
    type: MESSAGE_TYPE_SYSTEM,
    name: '系统消息',
    description: '来自客户端的消息，始终启用',
    selector: '.boldannounce',
    important: true,
  },
  // Basic types
  {
    type: MESSAGE_TYPE_LOCALCHAT,
    name: '附近聊天',
    description: '附近的角色内消息（说话、动作等）',
    selector: '.say, .emote',
  },
  {
    type: MESSAGE_TYPE_RADIO,
    name: '通讯',
    description: '所有部门的通讯消息',
    selector:
      '.alert, .minorannounce, .syndradio, .centcomradio, .aiprivradio, .comradio, .secradio, .gangradio, .engradio, .medradio, .sciradio, .suppradio, .servradio, .radio, .deptradio, .binarysay, .resonate, .abductor, .alien, .changeling',
  },
  {
    type: MESSAGE_TYPE_ENTERTAINMENT,
    name: '娱乐',
    description: '娱乐与新闻广播',
    selector: '.enteradio, .newscaster',
  },
  {
    type: MESSAGE_TYPE_INFO,
    name: '提示',
    description: '游戏与物品发出的非紧急提示',
    selector:
      '.notice:not(.pm), .adminnotice, .info, .sinister, .cult, .infoplain, .announce, .hear, .smallnotice, .holoparasite, .boldnotice',
  },
  {
    type: MESSAGE_TYPE_WARNING,
    name: '警告',
    description: '游戏与物品发出的紧急消息',
    selector:
      '.warning:not(.pm), .critical, .userdanger, .italics, .alertsyndie, .warningplain',
  },
  {
    type: MESSAGE_TYPE_DEADCHAT,
    name: '亡者聊天',
    description: '全部亡者聊天消息',
    selector: '.deadsay, .ghostalert',
  },
  {
    type: MESSAGE_TYPE_OOC,
    name: '场外聊天',
    description: '全服场外聊天的蓝色消息',
    selector: '.ooc, .adminooc, .adminobserverooc, .oocplain',
  },
  {
    type: MESSAGE_TYPE_ADMINPM,
    name: '管理员私信',
    description: '与管理员之间的求助消息',
    selector: '.pm, .adminhelp',
  },
  {
    type: MESSAGE_TYPE_COMBAT,
    name: '战斗记录',
    description: '例如：某人用刀刺中了你！',
    selector: '.danger',
  },
  {
    type: MESSAGE_TYPE_UNKNOWN,
    name: '未分类',
    description: '无法分类的消息，始终启用',
  },
  // Admin stuff
  {
    type: MESSAGE_TYPE_ADMINCHAT,
    name: 'Admin Chat',
    description: 'ASAY messages',
    selector: '.admin_channel, .adminsay',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_MODCHAT,
    name: 'Mod Chat',
    description: 'MSAY messages',
    selector: '.mod_channel',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_PRAYER,
    name: 'Prayers',
    description: 'Prayers from players',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ADMINLOG,
    name: 'Admin Log',
    description: 'ADMIN LOG: Urist McAdmin has jumped to coordinates X, Y, Z',
    selector: '.log_message',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ATTACKLOG,
    name: 'Attack Log',
    description: 'Urist McTraitor has shot John Doe',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_DEBUG,
    name: 'Debug Log',
    description: 'DEBUG: SSPlanets subsystem Recover().',
    admin: true,
  },
];

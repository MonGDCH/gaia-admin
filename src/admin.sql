/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80012
 Source Host           : localhost:3306
 Source Schema         : gaia-plugins

 Target Server Type    : MySQL
 Target Server Version : 80012
 File Encoding         : 65001

 Date: 05/02/2024 10:47:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '加密盐',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '头像',
  `login_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后登录时间',
  `login_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '最后登录的IP',
  `login_token` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '单点登录用token',
  `deadline` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '有效期，0则不过期',
  `sender` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否允许发送私信',
  `receiver` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否接收私信',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1:正常,0:禁用',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', 'fb0fd02ecb06769a0e397960f231e855', 'JSbBvf', '/upload/202312/1575929252gaia6584f914dd54d.jpg', 1707101185, '127.0.0.1', '65c38eff1119cddfd3063b1d6f50fca7', 0, 1, 1, 1, 1707101185, 1658390052);

-- ----------------------------
-- Table structure for admin_log
-- ----------------------------
DROP TABLE IF EXISTS `admin_log`;
CREATE TABLE `admin_log`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(11) UNSIGNED NOT NULL COMMENT '用户ID',
  `sid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联记录ID',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '所属模块',
  `method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求方式',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求路径',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作内容',
  `ua` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '浏览器请求头user-agent',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作IP',
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `module`(`module`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1588 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员操作日志表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for admin_login_log
-- ----------------------------
DROP TABLE IF EXISTS `admin_login_log`;
CREATE TABLE `admin_login_log`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `sid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理记录ID',
  `type` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '日志类型，0退出登录，1登录成功，2密码错误...更多类型',
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '描述信息',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'IP地址',
  `ua` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '浏览器请求头user-agent',
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 360 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员登录表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of admin_login_log
-- ----------------------------
INSERT INTO `admin_login_log` VALUES (361, 1, 0, 1, '管理员登录', '', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0', 1707101185);

-- ----------------------------
-- Table structure for admin_message
-- ----------------------------
DROP TABLE IF EXISTS `admin_message`;
CREATE TABLE `admin_message`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `message_id` int(10) UNSIGNED NOT NULL COMMENT '站内信ID',
  `send_time` int(10) UNSIGNED NOT NULL COMMENT '站内信发送时间',
  `read_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '站内信读取时间',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态: 0-未读 1-已读',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `message`(`uid`, `message_id`) USING BTREE,
  INDEX `user`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户收取系统站内信表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of admin_message
-- ----------------------------

-- ----------------------------
-- Table structure for auth_access
-- ----------------------------
DROP TABLE IF EXISTS `auth_access`;
CREATE TABLE `auth_access`  (
  `group_id` int(10) UNSIGNED NOT NULL COMMENT '组别ID',
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`group_id`, `uid`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '组别用户关联表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of auth_access
-- ----------------------------
INSERT INTO `auth_access` VALUES (1, 1, 1685504920, 1685504920);
INSERT INTO `auth_access` VALUES (35, 11, 1707100163, 1707100163);

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL COMMENT '父级ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则ID',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1:有效,2:无效',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '规则组表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
INSERT INTO `auth_group` VALUES (1, 0, '超级管理员', '*', 1, 1490883540, 1490883540);
INSERT INTO `auth_group` VALUES (35, 0, '222', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,160,161,162,163,164,165,166,167,168,212,215,216,217,218,219,220,221', 1, 1707100159, 1707100145);

-- ----------------------------
-- Table structure for auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `auth_rule`;
CREATE TABLE `auth_rule`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则名称',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规则路径',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1:有效,0:无效',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 223 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限规则表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of auth_rule
-- ----------------------------
INSERT INTO `auth_rule` VALUES (1, 0, '系统管理', 'sys', '管理系统相关核心功能', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (2, 1, '权限管理', 'auth', '系统角色权限控制', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (3, 2, '角色组别管理', 'authGroup', '角色组可以有多个,角色有上下级层级关系,如果子角色有角色组和管理员的权限则可以派生属于自己组别下级的角色组或管理员', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (4, 3, '新增角色组别', '/sys/auth/group/add', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (5, 3, '编辑角色组别', '/sys/auth/group/edit', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (6, 3, '角色组别路由规则树', '/sys/auth/group/role', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (7, 3, '查看角色组别关联用户', '/sys/auth/group/user', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (8, 3, '角色组别绑定用户', '/sys/auth/group/bind', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (9, 3, '角色组别用户解绑', '/sys/auth/group/unbind', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (10, 3, '查看角色组别', '/sys/auth/group', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (11, 2, '路由规则管理', 'authRule', '注意：路由管理属于超高度敏感操作，非必要情况下请联系开发人员进行操作及测试确认后再行修改发布。', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (12, 11, '新增路由规则', '/sys/auth/rule/add', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (13, 11, '编辑路由规则', '/sys/auth/rule/edit', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (14, 11, '查看路由规则', '/sys/auth/rule', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (15, 1, '管理员管理', 'admin', '一个管理员可以有多个权限规则，通过角色组绑定权限规则，左侧的菜单根据管理员所拥有的权限进行生成', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (16, 15, '新增管理员', '/sys/admin/add', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (17, 15, '编辑管理员', '/sys/admin/edit', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (18, 15, '封解冻管理员', '/sys/admin/toggle', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (19, 15, '查看管理员', '/sys/admin', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (20, 15, '重置密码', '/sys/admin/password', '重置管理员账户密码', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (21, 160, '配置字典', 'options', '系统相关应用配置字典', 1, 1700884669, 1697093437);
INSERT INTO `auth_rule` VALUES (22, 21, '新增配置', '/sys/dictionary/options/add', '', 1, 1700884699, 1697093437);
INSERT INTO `auth_rule` VALUES (23, 21, '编辑配置', '/sys/dictionary/options/edit', '', 1, 1700884707, 1697093437);
INSERT INTO `auth_rule` VALUES (24, 21, '查看配置字典', '/sys/dictionary/options', '', 1, 1700884712, 1697093437);
INSERT INTO `auth_rule` VALUES (25, 21, '删除字典', '/sys/dictionary/options/delete', '', 1, 1700884718, 1697093437);
INSERT INTO `auth_rule` VALUES (26, 21, '修改状态', '/sys/dictionary/options/toggle', '', 1, 1700884724, 1697093437);
INSERT INTO `auth_rule` VALUES (27, 1, '菜单管理', 'menu', '系统导航菜单', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (28, 27, '新增菜单', '/sys/menu/add', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (29, 27, '编辑菜单', '/sys/menu/edit', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (30, 27, '查看菜单', '/sys/menu', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (31, 1, '系统日志', 'log', '敏感操作日志', 1, 1700890480, 1697093437);
INSERT INTO `auth_rule` VALUES (32, 31, '查看管理员操作日志', '/sys/log/admin', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (33, 31, '查看管理员登录日志', '/sys/log/adminLogin', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (34, 1, '站内信', 'notice', '站内信', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (35, 34, '消息类型', 'noticeType', '站内信类型', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (36, 35, '查看消息类型', '/sys/notice/type', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (37, 35, '新增消息类型', '/sys/notice/type/add', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (38, 35, '编辑消息类型', '/sys/notice/type/edit', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (39, 34, '系统通知', 'noticeMessage', '系统通知', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (40, 39, '查看通知', '/sys/notice/message', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (41, 39, '新增通知', '/sys/notice/message/add', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (42, 39, '编辑通知', '/sys/notice/message/edit', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (43, 39, '发送通知', '/sys/notice/message/send', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (44, 39, '删除恢复通知', '/sys/notice/message/toggle', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (45, 1, '系统运维', 'ops', '', 1, 1700878750, 1697093437);
INSERT INTO `auth_rule` VALUES (46, 45, '数据备份', 'migrate', 'Mysql数据备份及库表优化', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (47, 46, '查看', '/sys/ops/migrate', '查看备份的数据记录', 1, 1700878759, 1697093438);
INSERT INTO `auth_rule` VALUES (48, 46, '下载备份数据', '/sys/ops/migrate/download', '', 1, 1700878764, 1697093438);
INSERT INTO `auth_rule` VALUES (49, 46, '备份库表数据', '/sys/ops/migrate/backup', '', 1, 1700878769, 1697093438);
INSERT INTO `auth_rule` VALUES (50, 46, '优化表', '/sys/ops/migrate/optimize', '', 1, 1700878774, 1697093438);
INSERT INTO `auth_rule` VALUES (51, 46, '修复表', '/sys/ops/migrate/repair', '', 1, 1700878778, 1697093438);
INSERT INTO `auth_rule` VALUES (52, 45, '缓存管理', 'cache', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (53, 52, '查看页面', '/sys/ops/cache', '', 1, 1700878787, 1697093438);
INSERT INTO `auth_rule` VALUES (54, 52, '清除缓存', '/sys/ops/cache/clear', '', 1, 1700878792, 1697093438);
INSERT INTO `auth_rule` VALUES (55, 59, '计数器', 'counter', '', 1, 1702366773, 1697093438);
INSERT INTO `auth_rule` VALUES (56, 55, '查看', '/sys/dev/counter', '', 1, 1702366780, 1697093438);
INSERT INTO `auth_rule` VALUES (57, 55, '编辑', '/sys/dev/counter/edit', '', 1, 1702366786, 1697093438);
INSERT INTO `auth_rule` VALUES (58, 55, '删除', '/sys/dev/counter/remove', '', 1, 1702366791, 1697093438);
INSERT INTO `auth_rule` VALUES (59, 1, '开发辅助', 'dev', '', 1, 1697093437, 1697093437);
INSERT INTO `auth_rule` VALUES (60, 59, '表单模型', 'form', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (61, 60, '查看', '/sys/dev/form', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (62, 60, '预览', '/sys/dev/form/preview', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (63, 60, '新增', '/sys/dev/form/add', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (64, 60, '编辑', '/sys/dev/form/edit', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (65, 60, '修改状态', '/sys/dev/form/toggle', '', 1, 1697093438, 1697093438);
INSERT INTO `auth_rule` VALUES (160, 1, '数据字典', 'dictionary', '', 1, 1700884653, 1700884653);
INSERT INTO `auth_rule` VALUES (161, 160, '省份城市', 'region', '省份城市数据', 1, 1700884813, 1700884813);
INSERT INTO `auth_rule` VALUES (162, 161, '查看', '/sys/dictionary/region', '', 1, 1700884856, 1700884856);
INSERT INTO `auth_rule` VALUES (163, 161, '新增', '/sys/dictionary/region/add', '', 1, 1700890370, 1700890370);
INSERT INTO `auth_rule` VALUES (164, 161, '编辑', '/sys/dictionary/region/edit', '', 1, 1700890385, 1700890385);
INSERT INTO `auth_rule` VALUES (165, 160, '物流公司', 'express', '', 1, 1700890408, 1700890408);
INSERT INTO `auth_rule` VALUES (166, 165, '查看', '/sys/dictionary/express', '', 1, 1700890429, 1700890429);
INSERT INTO `auth_rule` VALUES (167, 165, '新增', '/sys/dictionary/express/add', '', 1, 1700890440, 1700890440);
INSERT INTO `auth_rule` VALUES (168, 165, '编辑', '/sys/dictionary/express/edit', '', 1, 1700890448, 1700890448);
INSERT INTO `auth_rule` VALUES (212, 59, '定时任务', 'crontab', '', 1, 1702706380, 1702706380);
INSERT INTO `auth_rule` VALUES (214, 213, '查看', '/sys/dev/queue', '', 1, 1702706418, 1702706418);
INSERT INTO `auth_rule` VALUES (215, 212, '查看', '/sys/dev/crontab', '', 1, 1702706449, 1702706449);
INSERT INTO `auth_rule` VALUES (216, 212, '新增', '/sys/dev/crontab/add', '', 1, 1702706465, 1702706465);
INSERT INTO `auth_rule` VALUES (217, 212, '编辑', '/sys/dev/crontab/edit', '', 1, 1702706473, 1702706473);
INSERT INTO `auth_rule` VALUES (218, 212, '运行状态', '/sys/dev/crontab/ping', '', 1, 1702706486, 1702706486);
INSERT INTO `auth_rule` VALUES (219, 212, '运行任务池', '/sys/dev/crontab/pool', '', 1, 1702706510, 1702706510);
INSERT INTO `auth_rule` VALUES (220, 212, '重载任务', '/sys/dev/crontab/reload', '', 1, 1702706523, 1702706523);
INSERT INTO `auth_rule` VALUES (221, 212, '任务运行日志', '/sys/dev/crontab/log', '', 1, 1702706544, 1702706544);

-- ----------------------------
-- Table structure for counter
-- ----------------------------
DROP TABLE IF EXISTS `counter`;
CREATE TABLE `counter`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `app` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用计数器索引',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模块计数器索引',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户计数器索引',
  `count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '计数',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `update_time` int(10) UNSIGNED NOT NULL COMMENT '更新时间',
  `create_time` int(10) UNSIGNED NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `item`(`app`, `module`, `uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '计数器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of counter
-- ----------------------------

-- ----------------------------
-- Table structure for crontab
-- ----------------------------
DROP TABLE IF EXISTS `crontab`;
CREATE TABLE `crontab`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务标题',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务类型 0 class, 1 url, 2 shell',
  `rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务执行表达式',
  `target` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '调用任务字符串',
  `params` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务调用参数',
  `running_times` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '已运行次数',
  `last_running_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上次运行时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `sort` tinyint(3) UNSIGNED NOT NULL DEFAULT 50 COMMENT '排序权重',
  `singleton` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否单次执行: 0 是 1 不是',
  `savelog` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否记录日志: 0 否 1 是',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '任务状态状态: 0禁用 1启用',
  `update_time` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '更新时间',
  `create_time` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时器任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of crontab
-- ----------------------------

-- ----------------------------
-- Table structure for crontab_log
-- ----------------------------
DROP TABLE IF EXISTS `crontab_log`;
CREATE TABLE `crontab_log`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `crontab_id` int(11) UNSIGNED NOT NULL COMMENT '任务id',
  `target` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务调用目标字符串',
  `params` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务调用参数',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '任务执行或者异常信息输出',
  `return_code` tinyint(1) UNSIGNED NOT NULL COMMENT '执行返回状态: 0失败 1成功',
  `running_time` float UNSIGNED NOT NULL COMMENT '执行所用时间',
  `create_time` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `crontab_id`(`crontab_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2788 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时器任务执行日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of crontab_log
-- ----------------------------

-- ----------------------------
-- Table structure for dictionary
-- ----------------------------
DROP TABLE IF EXISTS `dictionary`;
CREATE TABLE `dictionary`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '组别',
  `index` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '索引',
  `value` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '配置值',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态，1有效,0无效',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `item`(`group`, `index`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '配置字典表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of dictionary
-- ----------------------------
INSERT INTO `dictionary` VALUES (14, 'dictionary', 'sms', '短信', '', 1, 1686727839, 1685518916);
INSERT INTO `dictionary` VALUES (15, 'dictionary', 'web', '站点信息', '系统站点相关信息', 1, 1693461093, 1693461093);
INSERT INTO `dictionary` VALUES (16, 'dictionary', 'email', '邮箱', '', 1, 1700643560, 1685522200);
INSERT INTO `dictionary` VALUES (22, 'email', 'host', 'smtp.qq.com', 'SMTP服务器', 1, 1685526132, 1685526132);
INSERT INTO `dictionary` VALUES (23, 'email', 'port', '465', 'SMTP服务器的远程服务器端口号', 1, 1685526157, 1685526157);
INSERT INTO `dictionary` VALUES (24, 'email', 'ssl', '1', '是否开启ssl，1开启，0不开启', 1, 1685526191, 1685526191);
INSERT INTO `dictionary` VALUES (25, 'email', 'name', 'monlam', 'SMTP发件人名称', 1, 1685526213, 1685526213);
INSERT INTO `dictionary` VALUES (26, 'email', 'user', '', 'SMTP登录账号', 1, 1685526463, 1685526463);
INSERT INTO `dictionary` VALUES (27, 'email', 'password', '', 'SMTP登录密码', 1, 1685526487, 1685526487);
INSERT INTO `dictionary` VALUES (28, 'email', 'from', '', '发件人邮箱地址', 1, 1685526633, 1685526633);
INSERT INTO `dictionary` VALUES (30, 'web', 'title', 'Gaia Admin', '系统名称', 1, 1702870210, 1693461126);
INSERT INTO `dictionary` VALUES (31, 'web', 'logo', '/static/img/logo.png', '系统站点Logo', 1, 1700638577, 1693461181);
INSERT INTO `dictionary` VALUES (32, 'web', 'desc', '简 洁 而 不 简 单', '系统小标题', 1, 1693461480, 1693461480);
INSERT INTO `dictionary` VALUES (33, 'web', 'copr', '版权信息', '系统版权信息', 1, 1693461389, 1693461389);
INSERT INTO `dictionary` VALUES (34, 'web', 'gov', '备案号', '系统备案号', 1, 1693461241, 1693461241);

-- ----------------------------
-- Table structure for express
-- ----------------------------
DROP TABLE IF EXISTS `express`;
CREATE TABLE `express`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `sort` tinyint(1) UNSIGNED NOT NULL DEFAULT 50 COMMENT '排序权重',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0:待确认, 1:待发货, 1:已发货, 2:已收货, 3:已关闭',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `key`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '物流公司表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of express
-- ----------------------------
INSERT INTO `express` VALUES (1, 'zhongtong', '中通快递', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (2, 'yunda', '韵达快递', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (3, 'yuantong', '圆通速递', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (4, 'baishiwuliu', '百世物流', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (5, 'shentong', '申通快递', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (6, 'shunfeng', '顺丰速运', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (7, 'jtexpress', '极兔速递', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (8, 'jd', '京东物流', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (9, 'youzhengguonei', '邮政快递包裹', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (10, 'youzhengbk', '邮政标准快递', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (11, 'guangdongyouzhengwuliu', '广东邮政物流', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (12, 'debangwuliu', '德邦物流', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (13, 'debangkuaidi', '德邦快递', '', 50, 1, 1700818200, 1700818200);
INSERT INTO `express` VALUES (14, 'ems', 'EMS', '', 50, 1, 1700818200, 1700818200);

-- ----------------------------
-- Table structure for fast_menu
-- ----------------------------
DROP TABLE IF EXISTS `fast_menu`;
CREATE TABLE `fast_menu`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `menu_id` int(10) UNSIGNED NOT NULL COMMENT '菜单ID',
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `item`(`uid`, `menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '快捷菜单表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of fast_menu
-- ----------------------------

-- ----------------------------
-- Table structure for files
-- ----------------------------
DROP TABLE IF EXISTS `files`;
CREATE TABLE `files`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `md5` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件md5',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '所属模块名',
  `filename` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件名',
  `savename` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '保存文件名',
  `path` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '保存文件路径',
  `mine_type` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '文件mime-type',
  `ext` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `size` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文件大小',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1-有效,0-无效',
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `item`(`md5`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '上传文件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of files
-- ----------------------------

-- ----------------------------
-- Table structure for form_design
-- ----------------------------
DROP TABLE IF EXISTS `form_design`;
CREATE TABLE `form_design`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(10) UNSIGNED NOT NULL COMMENT '所属用户ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '表单名称',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '表单备注',
  `align` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '表单对齐方式:1上对象0左对齐',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置信息',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态:0禁用,1正常',
  `sort` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序权重',
  `update_time` int(10) UNSIGNED NOT NULL COMMENT '更新时间',
  `create_time` int(10) UNSIGNED NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '表单设计表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of form_design
-- ----------------------------

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级ID',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题名称',
  `name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '跳转链接',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图标',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '描述信息',
  `sort` int(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序权重',
  `type` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '菜单类型 0: 目录 1: 菜单',
  `openType` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0:正常打开; 1:新建浏览器标签页',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1有效2无效',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, 0, '控制台', '/console', 'layui-icon layui-icon-console', '基本页面', 999, 1, 0, 0, 1697093981, 1697093981);
INSERT INTO `menu` VALUES (2, 0, '系统管理', 'sys', 'layui-icon layui-icon-set-fill', '系统管理', 5, 0, 0, 1, 1702706617, 1697093981);
INSERT INTO `menu` VALUES (3, 2, '权限管理', 'auth', 'layui-icon layui-icon-password', '', 50, 0, 0, 1, 1697093981, 1697093981);
INSERT INTO `menu` VALUES (4, 3, '角色管理', '/sys/auth/group', 'layui-icon layui-icon-group', '角色组可以有多个,角色有上下级层级关系,如果子角色有角色组和管理员的权限则可以派生属于自己组别下级的角色组或管理员', 10, 1, 0, 1, 1697093982, 1697093982);
INSERT INTO `menu` VALUES (5, 3, '规则管理', '/sys/auth/rule', 'layui-icon layui-icon-note', '注意：权限规则管理属于超高度敏感操作，非必要情况下请联系开发人员进行操作及测试确认后再行修改发布。', 10, 1, 0, 1, 1697093982, 1697093982);
INSERT INTO `menu` VALUES (6, 2, '管理员管理', '/sys/admin', 'layui-icon layui-icon-user', '', 25, 1, 0, 1, 1700892892, 1697093981);
INSERT INTO `menu` VALUES (7, 2, '数据字典', 'dictionary', 'layui-icon layui-icon-tabs', '系统相关固定数据配置栏', 45, 0, 0, 1, 1702698865, 1700884020);
INSERT INTO `menu` VALUES (8, 2, '菜单管理', '/sys/menu', 'layui-icon layui-icon-align-left', '左侧菜单列表管理，注意菜单节点若存在子级节点，则自身链接会无效。可通过链接地址对应权限规则节点进行权限控制。', 30, 1, 0, 1, 1707098998, 1697093981);
INSERT INTO `menu` VALUES (9, 2, '系统运维', 'ops', 'layui-icon layui-icon-website', '', 35, 0, 0, 1, 1707099158, 1697093981);
INSERT INTO `menu` VALUES (10, 9, '数据备份', '/sys/ops/migrate', 'layui-icon layui-icon-file-b', 'Mysql数据库数据备份及表修复优化', 10, 1, 0, 1, 1700878716, 1697093982);
INSERT INTO `menu` VALUES (11, 9, '缓存管理', '/sys/ops/cache', 'layui-icon layui-icon-delete', '注意：清除数据请谨慎，清除后无法恢复！', 10, 1, 0, 1, 1700878720, 1697093982);
INSERT INTO `menu` VALUES (12, 19, '计数器', '/sys/dev/counter', 'layui-icon layui-icon-template-1', '', 10, 1, 0, 1, 1702366455, 1697093982);
INSERT INTO `menu` VALUES (13, 2, '系统日志', 'log', 'layui-icon layui-icon-list', '日志记录', 48, 0, 0, 1, 1702698811, 1697093981);
INSERT INTO `menu` VALUES (14, 13, '管理员操作日志', '/sys/log/admin', 'layui-icon layui-icon-file-b', '管理员操作日志流水，用于查看一些管理员的敏感操作。', 5, 1, 0, 1, 1697093982, 1697093982);
INSERT INTO `menu` VALUES (15, 13, '管理员登录日志', '/sys/log/adminLogin', 'layui-icon layui-icon-file-b', '管理员用户登录日志', 5, 1, 0, 1, 1697093982, 1697093982);
INSERT INTO `menu` VALUES (16, 2, '系统站内信', 'notice', 'layui-icon layui-icon-notice', '系统站内信', 60, 0, 0, 1, 1697093981, 1697093981);
INSERT INTO `menu` VALUES (17, 16, '系统通知', '/sys/notice/message', 'layui-icon layui-icon-notice', '系统站内信', 5, 1, 0, 1, 1697093982, 1697093982);
INSERT INTO `menu` VALUES (18, 16, '消息类型', '/sys/notice/type', 'layui-icon layui-icon-template-1', '通知消息类型', 5, 1, 0, 1, 1697093982, 1697093982);
INSERT INTO `menu` VALUES (19, 2, '开发辅助', 'dev', 'layui-icon layui-icon-template-1', '', 35, 0, 0, 1, 1697093981, 1697093981);
INSERT INTO `menu` VALUES (20, 19, '表单模型', '/sys/dev/form', 'layui-icon layui-icon-form', '', 10, 1, 0, 1, 1697093982, 1697093982);
INSERT INTO `menu` VALUES (21, 19, '消息队列', '/sys/dev/queue', 'layui-icon layui-icon-template-1', '', 5, 1, 0, 1, 1702366497, 1702093022);
INSERT INTO `menu` VALUES (22, 19, '定时任务', '/sys/dev/crontab', 'layui-icon layui-icon-template-1', '', 6, 1, 0, 1, 1702366484, 1702280803);
INSERT INTO `menu` VALUES (23, 7, '配置信息', '/sys/dictionary/options', 'layui-icon layui-icon-component', '', 10, 1, 0, 1, 1700884194, 1697093981);
INSERT INTO `menu` VALUES (24, 7, '物流公司', '/sys/dictionary/express', 'layui-icon layui-icon-template-1', '', 10, 1, 0, 1, 1700890565, 1700890565);
INSERT INTO `menu` VALUES (25, 7, '省份城市', '/sys/dictionary/region', 'layui-icon layui-icon-template-1', '省份城市数据管理', 5, 1, 0, 1, 1700884433, 1700286539);

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(10) UNSIGNED NOT NULL COMMENT '创建人ID',
  `type` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '消息ID，0则为私信',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息标题',
  `send_uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送人ID',
  `send_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送时间',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0-已删除, 1-草稿, 2-发布',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统站内信表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of message
-- ----------------------------

-- ----------------------------
-- Table structure for message_content
-- ----------------------------
DROP TABLE IF EXISTS `message_content`;
CREATE TABLE `message_content`  (
  `message_id` int(10) UNSIGNED NOT NULL COMMENT '站内信ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`message_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统站内信内容表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of message_content
-- ----------------------------

-- ----------------------------
-- Table structure for message_receiver
-- ----------------------------
DROP TABLE IF EXISTS `message_receiver`;
CREATE TABLE `message_receiver`  (
  `message_id` int(10) UNSIGNED NOT NULL COMMENT '站内信ID',
  `receive_id` int(10) UNSIGNED NOT NULL COMMENT '收信人ID, 0则所有人',
  `send_time` int(10) UNSIGNED NOT NULL COMMENT '发送时间',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`message_id`, `receive_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统站内信收信人表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of message_receiver
-- ----------------------------

-- ----------------------------
-- Table structure for message_type
-- ----------------------------
DROP TABLE IF EXISTS `message_type`;
CREATE TABLE `message_type`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `img` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片',
  `remark` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0-禁用, 1-正常',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `title`(`title`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统站内信类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of message_type
-- ----------------------------

-- ----------------------------
-- Table structure for region
-- ----------------------------
DROP TABLE IF EXISTS `region`;
CREATE TABLE `region`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级id',
  `type` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0省份 1城市 2区县',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '编码',
  `sort` int(3) UNSIGNED NOT NULL DEFAULT 10 COMMENT '排序权重',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态',
  `update_time` int(10) UNSIGNED NOT NULL,
  `create_time` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6549 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '行政区域表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of region
-- ----------------------------
INSERT INTO `region` VALUES (1, 0, 0, '北京市', '110000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (2, 0, 0, '天津市', '120000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3, 0, 0, '河北省', '130000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4, 0, 0, '山西省', '140000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5, 0, 0, '内蒙古自治区', '150000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6, 0, 0, '辽宁省', '210000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (7, 0, 0, '吉林省', '220000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (8, 0, 0, '黑龙江省', '230000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (9, 0, 0, '上海市', '310000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (10, 0, 0, '江苏省', '320000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (11, 0, 0, '浙江省', '330000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (12, 0, 0, '安徽省', '340000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (13, 0, 0, '福建省', '350000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (14, 0, 0, '江西省', '360000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (15, 0, 0, '山东省', '370000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (16, 0, 0, '河南省', '410000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (17, 0, 0, '湖北省', '420000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (18, 0, 0, '湖南省', '430000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (19, 0, 0, '广东省', '440000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (20, 0, 0, '广西壮族自治区', '450000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (21, 0, 0, '海南省', '460000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (22, 0, 0, '重庆市', '500000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (23, 0, 0, '四川省', '510000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (24, 0, 0, '贵州省', '520000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (25, 0, 0, '云南省', '530000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (26, 0, 0, '西藏自治区', '540000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (27, 0, 0, '陕西省', '610000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (28, 0, 0, '甘肃省', '620000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (29, 0, 0, '青海省', '630000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (30, 0, 0, '宁夏回族自治区', '640000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (31, 0, 0, '新疆维吾尔自治区', '650000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (32, 0, 0, '台湾省', '710000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (33, 0, 0, '香港特别行政区', '810000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (34, 0, 0, '澳门特别行政区', '820000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (69, 1, 1, '市辖区', '110100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (70, 2, 1, '市辖区', '120100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (71, 3, 1, '石家庄市', '130100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (72, 3, 1, '唐山市', '130200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (73, 3, 1, '秦皇岛市', '130300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (74, 3, 1, '邯郸市', '130400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (75, 3, 1, '邢台市', '130500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (76, 3, 1, '保定市', '130600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (77, 3, 1, '张家口市', '130700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (78, 3, 1, '承德市', '130800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (79, 3, 1, '沧州市', '130900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (80, 3, 1, '廊坊市', '131000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (81, 3, 1, '衡水市', '131100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (82, 4, 1, '太原市', '140100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (83, 4, 1, '大同市', '140200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (84, 4, 1, '阳泉市', '140300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (85, 4, 1, '长治市', '140400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (86, 4, 1, '晋城市', '140500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (87, 4, 1, '朔州市', '140600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (88, 4, 1, '晋中市', '140700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (89, 4, 1, '运城市', '140800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (90, 4, 1, '忻州市', '140900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (91, 4, 1, '临汾市', '141000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (92, 4, 1, '吕梁市', '141100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (93, 5, 1, '呼和浩特市', '150100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (94, 5, 1, '包头市', '150200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (95, 5, 1, '乌海市', '150300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (96, 5, 1, '赤峰市', '150400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (97, 5, 1, '通辽市', '150500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (98, 5, 1, '鄂尔多斯市', '150600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (99, 5, 1, '呼伦贝尔市', '150700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (100, 5, 1, '巴彦淖尔市', '150800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (101, 5, 1, '乌兰察布市', '150900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (102, 5, 1, '兴安盟', '152200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (103, 5, 1, '锡林郭勒盟', '152500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (104, 5, 1, '阿拉善盟', '152900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (105, 6, 1, '沈阳市', '210100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (106, 6, 1, '大连市', '210200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (107, 6, 1, '鞍山市', '210300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (108, 6, 1, '抚顺市', '210400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (109, 6, 1, '本溪市', '210500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (110, 6, 1, '丹东市', '210600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (111, 6, 1, '锦州市', '210700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (112, 6, 1, '营口市', '210800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (113, 6, 1, '阜新市', '210900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (114, 6, 1, '辽阳市', '211000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (115, 6, 1, '盘锦市', '211100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (116, 6, 1, '铁岭市', '211200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (117, 6, 1, '朝阳市', '211300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (118, 6, 1, '葫芦岛市', '211400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (119, 7, 1, '长春市', '220100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (120, 7, 1, '吉林市', '220200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (121, 7, 1, '四平市', '220300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (122, 7, 1, '辽源市', '220400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (123, 7, 1, '通化市', '220500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (124, 7, 1, '白山市', '220600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (125, 7, 1, '松原市', '220700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (126, 7, 1, '白城市', '220800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (127, 7, 1, '延边朝鲜族自治州', '222400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (128, 8, 1, '哈尔滨市', '230100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (129, 8, 1, '齐齐哈尔市', '230200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (130, 8, 1, '鸡西市', '230300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (131, 8, 1, '鹤岗市', '230400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (132, 8, 1, '双鸭山市', '230500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (133, 8, 1, '大庆市', '230600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (134, 8, 1, '伊春市', '230700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (135, 8, 1, '佳木斯市', '230800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (136, 8, 1, '七台河市', '230900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (137, 8, 1, '牡丹江市', '231000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (138, 8, 1, '黑河市', '231100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (139, 8, 1, '绥化市', '231200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (140, 8, 1, '大兴安岭地区', '232700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (141, 9, 1, '市辖区', '310100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (142, 10, 1, '南京市', '320100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (143, 10, 1, '无锡市', '320200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (144, 10, 1, '徐州市', '320300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (145, 10, 1, '常州市', '320400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (146, 10, 1, '苏州市', '320500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (147, 10, 1, '南通市', '320600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (148, 10, 1, '连云港市', '320700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (149, 10, 1, '淮安市', '320800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (150, 10, 1, '盐城市', '320900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (151, 10, 1, '扬州市', '321000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (152, 10, 1, '镇江市', '321100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (153, 10, 1, '泰州市', '321200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (154, 10, 1, '宿迁市', '321300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (155, 11, 1, '杭州市', '330100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (156, 11, 1, '宁波市', '330200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (157, 11, 1, '温州市', '330300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (158, 11, 1, '嘉兴市', '330400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (159, 11, 1, '湖州市', '330500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (160, 11, 1, '绍兴市', '330600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (161, 11, 1, '金华市', '330700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (162, 11, 1, '衢州市', '330800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (163, 11, 1, '舟山市', '330900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (164, 11, 1, '台州市', '331000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (165, 11, 1, '丽水市', '331100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (166, 12, 1, '合肥市', '340100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (167, 12, 1, '芜湖市', '340200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (168, 12, 1, '蚌埠市', '340300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (169, 12, 1, '淮南市', '340400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (170, 12, 1, '马鞍山市', '340500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (171, 12, 1, '淮北市', '340600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (172, 12, 1, '铜陵市', '340700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (173, 12, 1, '安庆市', '340800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (174, 12, 1, '黄山市', '341000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (175, 12, 1, '滁州市', '341100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (176, 12, 1, '阜阳市', '341200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (177, 12, 1, '宿州市', '341300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (178, 12, 1, '六安市', '341500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (179, 12, 1, '亳州市', '341600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (180, 12, 1, '池州市', '341700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (181, 12, 1, '宣城市', '341800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (182, 13, 1, '福州市', '350100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (183, 13, 1, '厦门市', '350200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (184, 13, 1, '莆田市', '350300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (185, 13, 1, '三明市', '350400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (186, 13, 1, '泉州市', '350500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (187, 13, 1, '漳州市', '350600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (188, 13, 1, '南平市', '350700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (189, 13, 1, '龙岩市', '350800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (190, 13, 1, '宁德市', '350900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (191, 14, 1, '南昌市', '360100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (192, 14, 1, '景德镇市', '360200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (193, 14, 1, '萍乡市', '360300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (194, 14, 1, '九江市', '360400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (195, 14, 1, '新余市', '360500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (196, 14, 1, '鹰潭市', '360600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (197, 14, 1, '赣州市', '360700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (198, 14, 1, '吉安市', '360800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (199, 14, 1, '宜春市', '360900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (200, 14, 1, '抚州市', '361000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (201, 14, 1, '上饶市', '361100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (202, 15, 1, '济南市', '370100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (203, 15, 1, '青岛市', '370200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (204, 15, 1, '淄博市', '370300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (205, 15, 1, '枣庄市', '370400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (206, 15, 1, '东营市', '370500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (207, 15, 1, '烟台市', '370600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (208, 15, 1, '潍坊市', '370700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (209, 15, 1, '济宁市', '370800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (210, 15, 1, '泰安市', '370900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (211, 15, 1, '威海市', '371000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (212, 15, 1, '日照市', '371100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (213, 15, 1, '临沂市', '371300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (214, 15, 1, '德州市', '371400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (215, 15, 1, '聊城市', '371500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (216, 15, 1, '滨州市', '371600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (217, 15, 1, '菏泽市', '371700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (218, 16, 1, '郑州市', '410100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (219, 16, 1, '开封市', '410200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (220, 16, 1, '洛阳市', '410300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (221, 16, 1, '平顶山市', '410400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (222, 16, 1, '安阳市', '410500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (223, 16, 1, '鹤壁市', '410600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (224, 16, 1, '新乡市', '410700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (225, 16, 1, '焦作市', '410800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (226, 16, 1, '濮阳市', '410900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (227, 16, 1, '许昌市', '411000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (228, 16, 1, '漯河市', '411100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (229, 16, 1, '三门峡市', '411200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (230, 16, 1, '南阳市', '411300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (231, 16, 1, '商丘市', '411400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (232, 16, 1, '信阳市', '411500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (233, 16, 1, '周口市', '411600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (234, 16, 1, '驻马店市', '411700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (235, 16, 1, '省直辖县级行政区划', '419000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (236, 17, 1, '武汉市', '420100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (237, 17, 1, '黄石市', '420200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (238, 17, 1, '十堰市', '420300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (239, 17, 1, '宜昌市', '420500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (240, 17, 1, '襄阳市', '420600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (241, 17, 1, '鄂州市', '420700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (242, 17, 1, '荆门市', '420800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (243, 17, 1, '孝感市', '420900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (244, 17, 1, '荆州市', '421000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (245, 17, 1, '黄冈市', '421100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (246, 17, 1, '咸宁市', '421200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (247, 17, 1, '随州市', '421300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (248, 17, 1, '恩施土家族苗族自治州', '422800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (249, 17, 1, '省直辖县级行政区划', '429000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (250, 18, 1, '长沙市', '430100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (251, 18, 1, '株洲市', '430200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (252, 18, 1, '湘潭市', '430300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (253, 18, 1, '衡阳市', '430400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (254, 18, 1, '邵阳市', '430500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (255, 18, 1, '岳阳市', '430600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (256, 18, 1, '常德市', '430700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (257, 18, 1, '张家界市', '430800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (258, 18, 1, '益阳市', '430900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (259, 18, 1, '郴州市', '431000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (260, 18, 1, '永州市', '431100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (261, 18, 1, '怀化市', '431200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (262, 18, 1, '娄底市', '431300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (263, 18, 1, '湘西土家族苗族自治州', '433100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (264, 19, 1, '广州市', '440100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (265, 19, 1, '韶关市', '440200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (266, 19, 1, '深圳市', '440300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (267, 19, 1, '珠海市', '440400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (268, 19, 1, '汕头市', '440500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (269, 19, 1, '佛山市', '440600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (270, 19, 1, '江门市', '440700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (271, 19, 1, '湛江市', '440800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (272, 19, 1, '茂名市', '440900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (273, 19, 1, '肇庆市', '441200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (274, 19, 1, '惠州市', '441300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (275, 19, 1, '梅州市', '441400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (276, 19, 1, '汕尾市', '441500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (277, 19, 1, '河源市', '441600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (278, 19, 1, '阳江市', '441700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (279, 19, 1, '清远市', '441800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (280, 19, 1, '东莞市', '441900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (281, 19, 1, '中山市', '442000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (282, 19, 1, '潮州市', '445100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (283, 19, 1, '揭阳市', '445200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (284, 19, 1, '云浮市', '445300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (285, 20, 1, '南宁市', '450100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (286, 20, 1, '柳州市', '450200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (287, 20, 1, '桂林市', '450300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (288, 20, 1, '梧州市', '450400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (289, 20, 1, '北海市', '450500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (290, 20, 1, '防城港市', '450600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (291, 20, 1, '钦州市', '450700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (292, 20, 1, '贵港市', '450800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (293, 20, 1, '玉林市', '450900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (294, 20, 1, '百色市', '451000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (295, 20, 1, '贺州市', '451100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (296, 20, 1, '河池市', '451200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (297, 20, 1, '来宾市', '451300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (298, 20, 1, '崇左市', '451400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (299, 21, 1, '海口市', '460100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (300, 21, 1, '三亚市', '460200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (301, 21, 1, '三沙市', '460300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (302, 21, 1, '儋州市', '460400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (303, 21, 1, '省直辖县级行政区划', '469000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (304, 22, 1, '市辖区', '500100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (305, 22, 1, '县', '500200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (306, 23, 1, '成都市', '510100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (307, 23, 1, '自贡市', '510300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (308, 23, 1, '攀枝花市', '510400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (309, 23, 1, '泸州市', '510500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (310, 23, 1, '德阳市', '510600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (311, 23, 1, '绵阳市', '510700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (312, 23, 1, '广元市', '510800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (313, 23, 1, '遂宁市', '510900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (314, 23, 1, '内江市', '511000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (315, 23, 1, '乐山市', '511100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (316, 23, 1, '南充市', '511300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (317, 23, 1, '眉山市', '511400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (318, 23, 1, '宜宾市', '511500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (319, 23, 1, '广安市', '511600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (320, 23, 1, '达州市', '511700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (321, 23, 1, '雅安市', '511800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (322, 23, 1, '巴中市', '511900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (323, 23, 1, '资阳市', '512000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (324, 23, 1, '阿坝藏族羌族自治州', '513200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (325, 23, 1, '甘孜藏族自治州', '513300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (326, 23, 1, '凉山彝族自治州', '513400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (327, 24, 1, '贵阳市', '520100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (328, 24, 1, '六盘水市', '520200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (329, 24, 1, '遵义市', '520300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (330, 24, 1, '安顺市', '520400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (331, 24, 1, '毕节市', '520500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (332, 24, 1, '铜仁市', '520600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (333, 24, 1, '黔西南布依族苗族自治州', '522300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (334, 24, 1, '黔东南苗族侗族自治州', '522600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (335, 24, 1, '黔南布依族苗族自治州', '522700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (336, 25, 1, '昆明市', '530100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (337, 25, 1, '曲靖市', '530300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (338, 25, 1, '玉溪市', '530400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (339, 25, 1, '保山市', '530500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (340, 25, 1, '昭通市', '530600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (341, 25, 1, '丽江市', '530700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (342, 25, 1, '普洱市', '530800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (343, 25, 1, '临沧市', '530900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (344, 25, 1, '楚雄彝族自治州', '532300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (345, 25, 1, '红河哈尼族彝族自治州', '532500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (346, 25, 1, '文山壮族苗族自治州', '532600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (347, 25, 1, '西双版纳傣族自治州', '532800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (348, 25, 1, '大理白族自治州', '532900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (349, 25, 1, '德宏傣族景颇族自治州', '533100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (350, 25, 1, '怒江傈僳族自治州', '533300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (351, 25, 1, '迪庆藏族自治州', '533400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (352, 26, 1, '拉萨市', '540100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (353, 26, 1, '日喀则市', '540200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (354, 26, 1, '昌都市', '540300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (355, 26, 1, '林芝市', '540400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (356, 26, 1, '山南市', '540500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (357, 26, 1, '那曲市', '540600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (358, 26, 1, '阿里地区', '542500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (359, 27, 1, '西安市', '610100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (360, 27, 1, '铜川市', '610200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (361, 27, 1, '宝鸡市', '610300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (362, 27, 1, '咸阳市', '610400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (363, 27, 1, '渭南市', '610500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (364, 27, 1, '延安市', '610600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (365, 27, 1, '汉中市', '610700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (366, 27, 1, '榆林市', '610800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (367, 27, 1, '安康市', '610900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (368, 27, 1, '商洛市', '611000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (369, 28, 1, '兰州市', '620100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (370, 28, 1, '嘉峪关市', '620200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (371, 28, 1, '金昌市', '620300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (372, 28, 1, '白银市', '620400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (373, 28, 1, '天水市', '620500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (374, 28, 1, '武威市', '620600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (375, 28, 1, '张掖市', '620700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (376, 28, 1, '平凉市', '620800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (377, 28, 1, '酒泉市', '620900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (378, 28, 1, '庆阳市', '621000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (379, 28, 1, '定西市', '621100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (380, 28, 1, '陇南市', '621200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (381, 28, 1, '临夏回族自治州', '622900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (382, 28, 1, '甘南藏族自治州', '623000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (383, 29, 1, '西宁市', '630100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (384, 29, 1, '海东市', '630200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (385, 29, 1, '海北藏族自治州', '632200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (386, 29, 1, '黄南藏族自治州', '632300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (387, 29, 1, '海南藏族自治州', '632500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (388, 29, 1, '果洛藏族自治州', '632600', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (389, 29, 1, '玉树藏族自治州', '632700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (390, 29, 1, '海西蒙古族藏族自治州', '632800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (391, 30, 1, '银川市', '640100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (392, 30, 1, '石嘴山市', '640200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (393, 30, 1, '吴忠市', '640300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (394, 30, 1, '固原市', '640400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (395, 30, 1, '中卫市', '640500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (396, 31, 1, '乌鲁木齐市', '650100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (397, 31, 1, '克拉玛依市', '650200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (398, 31, 1, '吐鲁番市', '650400', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (399, 31, 1, '哈密市', '650500', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (400, 31, 1, '昌吉回族自治州', '652300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (401, 31, 1, '博尔塔拉蒙古自治州', '652700', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (402, 31, 1, '巴音郭楞蒙古自治州', '652800', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (403, 31, 1, '阿克苏地区', '652900', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (404, 31, 1, '克孜勒苏柯尔克孜自治州', '653000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (405, 31, 1, '喀什地区', '653100', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (406, 31, 1, '和田地区', '653200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (407, 31, 1, '伊犁哈萨克自治州', '654000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (408, 31, 1, '塔城地区', '654200', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (409, 31, 1, '阿勒泰地区', '654300', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (410, 31, 1, '自治区直辖县级行政区划', '659000', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3479, 69, 2, '东城区', '110101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3480, 69, 2, '西城区', '110102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3481, 69, 2, '朝阳区', '110105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3482, 69, 2, '丰台区', '110106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3483, 69, 2, '石景山区', '110107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3484, 69, 2, '海淀区', '110108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3485, 69, 2, '门头沟区', '110109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3486, 69, 2, '房山区', '110111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3487, 69, 2, '通州区', '110112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3488, 69, 2, '顺义区', '110113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3489, 69, 2, '昌平区', '110114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3490, 69, 2, '大兴区', '110115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3491, 69, 2, '怀柔区', '110116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3492, 69, 2, '平谷区', '110117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3493, 69, 2, '密云区', '110118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3494, 69, 2, '延庆区', '110119', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3495, 70, 2, '和平区', '120101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3496, 70, 2, '河东区', '120102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3497, 70, 2, '河西区', '120103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3498, 70, 2, '南开区', '120104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3499, 70, 2, '河北区', '120105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3500, 70, 2, '红桥区', '120106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3501, 70, 2, '东丽区', '120110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3502, 70, 2, '西青区', '120111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3503, 70, 2, '津南区', '120112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3504, 70, 2, '北辰区', '120113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3505, 70, 2, '武清区', '120114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3506, 70, 2, '宝坻区', '120115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3507, 70, 2, '滨海新区', '120116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3508, 70, 2, '宁河区', '120117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3509, 70, 2, '静海区', '120118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3510, 70, 2, '蓟州区', '120119', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3511, 71, 2, '长安区', '130102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3512, 71, 2, '桥西区', '130104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3513, 71, 2, '新华区', '130105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3514, 71, 2, '井陉矿区', '130107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3515, 71, 2, '裕华区', '130108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3516, 71, 2, '藁城区', '130109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3517, 71, 2, '鹿泉区', '130110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3518, 71, 2, '栾城区', '130111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3519, 71, 2, '井陉县', '130121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3520, 71, 2, '正定县', '130123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3521, 71, 2, '行唐县', '130125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3522, 71, 2, '灵寿县', '130126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3523, 71, 2, '高邑县', '130127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3524, 71, 2, '深泽县', '130128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3525, 71, 2, '赞皇县', '130129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3526, 71, 2, '无极县', '130130', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3527, 71, 2, '平山县', '130131', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3528, 71, 2, '元氏县', '130132', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3529, 71, 2, '赵县', '130133', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3530, 71, 2, '石家庄高新技术产业开发区', '130171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3531, 71, 2, '石家庄循环化工园区', '130172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3532, 71, 2, '辛集市', '130181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3533, 71, 2, '晋州市', '130183', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3534, 71, 2, '新乐市', '130184', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3535, 72, 2, '路南区', '130202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3536, 72, 2, '路北区', '130203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3537, 72, 2, '古冶区', '130204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3538, 72, 2, '开平区', '130205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3539, 72, 2, '丰南区', '130207', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3540, 72, 2, '丰润区', '130208', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3541, 72, 2, '曹妃甸区', '130209', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3542, 72, 2, '滦南县', '130224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3543, 72, 2, '乐亭县', '130225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3544, 72, 2, '迁西县', '130227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3545, 72, 2, '玉田县', '130229', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3546, 72, 2, '河北唐山芦台经济开发区', '130271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3547, 72, 2, '唐山市汉沽管理区', '130272', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3548, 72, 2, '唐山高新技术产业开发区', '130273', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3549, 72, 2, '河北唐山海港经济开发区', '130274', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3550, 72, 2, '遵化市', '130281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3551, 72, 2, '迁安市', '130283', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3552, 72, 2, '滦州市', '130284', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3553, 73, 2, '海港区', '130302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3554, 73, 2, '山海关区', '130303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3555, 73, 2, '北戴河区', '130304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3556, 73, 2, '抚宁区', '130306', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3557, 73, 2, '青龙满族自治县', '130321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3558, 73, 2, '昌黎县', '130322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3559, 73, 2, '卢龙县', '130324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3560, 73, 2, '秦皇岛市经济技术开发区', '130371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3561, 73, 2, '北戴河新区', '130372', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3562, 74, 2, '邯山区', '130402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3563, 74, 2, '丛台区', '130403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3564, 74, 2, '复兴区', '130404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3565, 74, 2, '峰峰矿区', '130406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3566, 74, 2, '肥乡区', '130407', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3567, 74, 2, '永年区', '130408', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3568, 74, 2, '临漳县', '130423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3569, 74, 2, '成安县', '130424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3570, 74, 2, '大名县', '130425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3571, 74, 2, '涉县', '130426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3572, 74, 2, '磁县', '130427', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3573, 74, 2, '邱县', '130430', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3574, 74, 2, '鸡泽县', '130431', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3575, 74, 2, '广平县', '130432', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3576, 74, 2, '馆陶县', '130433', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3577, 74, 2, '魏县', '130434', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3578, 74, 2, '曲周县', '130435', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3579, 74, 2, '邯郸经济技术开发区', '130471', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3580, 74, 2, '邯郸冀南新区', '130473', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3581, 74, 2, '武安市', '130481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3582, 75, 2, '桥东区', '130502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3583, 75, 2, '桥西区', '130503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3584, 75, 2, '邢台县', '130521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3585, 75, 2, '临城县', '130522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3586, 75, 2, '内丘县', '130523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3587, 75, 2, '柏乡县', '130524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3588, 75, 2, '隆尧县', '130525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3589, 75, 2, '任县', '130526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3590, 75, 2, '南和县', '130527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3591, 75, 2, '宁晋县', '130528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3592, 75, 2, '巨鹿县', '130529', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3593, 75, 2, '新河县', '130530', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3594, 75, 2, '广宗县', '130531', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3595, 75, 2, '平乡县', '130532', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3596, 75, 2, '威县', '130533', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3597, 75, 2, '清河县', '130534', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3598, 75, 2, '临西县', '130535', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3599, 75, 2, '河北邢台经济开发区', '130571', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3600, 75, 2, '南宫市', '130581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3601, 75, 2, '沙河市', '130582', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3602, 76, 2, '竞秀区', '130602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3603, 76, 2, '莲池区', '130606', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3604, 76, 2, '满城区', '130607', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3605, 76, 2, '清苑区', '130608', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3606, 76, 2, '徐水区', '130609', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3607, 76, 2, '涞水县', '130623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3608, 76, 2, '阜平县', '130624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3609, 76, 2, '定兴县', '130626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3610, 76, 2, '唐县', '130627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3611, 76, 2, '高阳县', '130628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3612, 76, 2, '容城县', '130629', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3613, 76, 2, '涞源县', '130630', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3614, 76, 2, '望都县', '130631', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3615, 76, 2, '安新县', '130632', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3616, 76, 2, '易县', '130633', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3617, 76, 2, '曲阳县', '130634', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3618, 76, 2, '蠡县', '130635', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3619, 76, 2, '顺平县', '130636', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3620, 76, 2, '博野县', '130637', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3621, 76, 2, '雄县', '130638', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3622, 76, 2, '保定高新技术产业开发区', '130671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3623, 76, 2, '保定白沟新城', '130672', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3624, 76, 2, '涿州市', '130681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3625, 76, 2, '定州市', '130682', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3626, 76, 2, '安国市', '130683', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3627, 76, 2, '高碑店市', '130684', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3628, 77, 2, '桥东区', '130702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3629, 77, 2, '桥西区', '130703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3630, 77, 2, '宣化区', '130705', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3631, 77, 2, '下花园区', '130706', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3632, 77, 2, '万全区', '130708', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3633, 77, 2, '崇礼区', '130709', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3634, 77, 2, '张北县', '130722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3635, 77, 2, '康保县', '130723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3636, 77, 2, '沽源县', '130724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3637, 77, 2, '尚义县', '130725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3638, 77, 2, '蔚县', '130726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3639, 77, 2, '阳原县', '130727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3640, 77, 2, '怀安县', '130728', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3641, 77, 2, '怀来县', '130730', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3642, 77, 2, '涿鹿县', '130731', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3643, 77, 2, '赤城县', '130732', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3644, 77, 2, '张家口经济开发区', '130771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3645, 77, 2, '张家口市察北管理区', '130772', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3646, 77, 2, '张家口市塞北管理区', '130773', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3647, 78, 2, '双桥区', '130802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3648, 78, 2, '双滦区', '130803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3649, 78, 2, '鹰手营子矿区', '130804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3650, 78, 2, '承德县', '130821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3651, 78, 2, '兴隆县', '130822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3652, 78, 2, '滦平县', '130824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3653, 78, 2, '隆化县', '130825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3654, 78, 2, '丰宁满族自治县', '130826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3655, 78, 2, '宽城满族自治县', '130827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3656, 78, 2, '围场满族蒙古族自治县', '130828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3657, 78, 2, '承德高新技术产业开发区', '130871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3658, 78, 2, '平泉市', '130881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3659, 79, 2, '新华区', '130902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3660, 79, 2, '运河区', '130903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3661, 79, 2, '沧县', '130921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3662, 79, 2, '青县', '130922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3663, 79, 2, '东光县', '130923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3664, 79, 2, '海兴县', '130924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3665, 79, 2, '盐山县', '130925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3666, 79, 2, '肃宁县', '130926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3667, 79, 2, '南皮县', '130927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3668, 79, 2, '吴桥县', '130928', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3669, 79, 2, '献县', '130929', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3670, 79, 2, '孟村回族自治县', '130930', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3671, 79, 2, '河北沧州经济开发区', '130971', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3672, 79, 2, '沧州高新技术产业开发区', '130972', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3673, 79, 2, '沧州渤海新区', '130973', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3674, 79, 2, '泊头市', '130981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3675, 79, 2, '任丘市', '130982', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3676, 79, 2, '黄骅市', '130983', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3677, 79, 2, '河间市', '130984', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3678, 80, 2, '安次区', '131002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3679, 80, 2, '广阳区', '131003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3680, 80, 2, '固安县', '131022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3681, 80, 2, '永清县', '131023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3682, 80, 2, '香河县', '131024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3683, 80, 2, '大城县', '131025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3684, 80, 2, '文安县', '131026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3685, 80, 2, '大厂回族自治县', '131028', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3686, 80, 2, '廊坊经济技术开发区', '131071', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3687, 80, 2, '霸州市', '131081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3688, 80, 2, '三河市', '131082', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3689, 81, 2, '桃城区', '131102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3690, 81, 2, '冀州区', '131103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3691, 81, 2, '枣强县', '131121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3692, 81, 2, '武邑县', '131122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3693, 81, 2, '武强县', '131123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3694, 81, 2, '饶阳县', '131124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3695, 81, 2, '安平县', '131125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3696, 81, 2, '故城县', '131126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3697, 81, 2, '景县', '131127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3698, 81, 2, '阜城县', '131128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3699, 81, 2, '河北衡水高新技术产业开发区', '131171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3700, 81, 2, '衡水滨湖新区', '131172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3701, 81, 2, '深州市', '131182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3702, 82, 2, '小店区', '140105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3703, 82, 2, '迎泽区', '140106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3704, 82, 2, '杏花岭区', '140107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3705, 82, 2, '尖草坪区', '140108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3706, 82, 2, '万柏林区', '140109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3707, 82, 2, '晋源区', '140110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3708, 82, 2, '清徐县', '140121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3709, 82, 2, '阳曲县', '140122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3710, 82, 2, '娄烦县', '140123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3711, 82, 2, '山西转型综合改革示范区', '140171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3712, 82, 2, '古交市', '140181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3713, 83, 2, '新荣区', '140212', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3714, 83, 2, '平城区', '140213', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3715, 83, 2, '云冈区', '140214', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3716, 83, 2, '云州区', '140215', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3717, 83, 2, '阳高县', '140221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3718, 83, 2, '天镇县', '140222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3719, 83, 2, '广灵县', '140223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3720, 83, 2, '灵丘县', '140224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3721, 83, 2, '浑源县', '140225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3722, 83, 2, '左云县', '140226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3723, 83, 2, '山西大同经济开发区', '140271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3724, 84, 2, '城区', '140302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3725, 84, 2, '矿区', '140303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3726, 84, 2, '郊区', '140311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3727, 84, 2, '平定县', '140321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3728, 84, 2, '盂县', '140322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3729, 85, 2, '潞州区', '140403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3730, 85, 2, '上党区', '140404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3731, 85, 2, '屯留区', '140405', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3732, 85, 2, '潞城区', '140406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3733, 85, 2, '襄垣县', '140423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3734, 85, 2, '平顺县', '140425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3735, 85, 2, '黎城县', '140426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3736, 85, 2, '壶关县', '140427', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3737, 85, 2, '长子县', '140428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3738, 85, 2, '武乡县', '140429', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3739, 85, 2, '沁县', '140430', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3740, 85, 2, '沁源县', '140431', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3741, 85, 2, '山西长治高新技术产业园区', '140471', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3742, 86, 2, '城区', '140502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3743, 86, 2, '沁水县', '140521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3744, 86, 2, '阳城县', '140522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3745, 86, 2, '陵川县', '140524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3746, 86, 2, '泽州县', '140525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3747, 86, 2, '高平市', '140581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3748, 87, 2, '朔城区', '140602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3749, 87, 2, '平鲁区', '140603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3750, 87, 2, '山阴县', '140621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3751, 87, 2, '应县', '140622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3752, 87, 2, '右玉县', '140623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3753, 87, 2, '山西朔州经济开发区', '140671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3754, 87, 2, '怀仁市', '140681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3755, 88, 2, '榆次区', '140702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3756, 88, 2, '榆社县', '140721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3757, 88, 2, '左权县', '140722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3758, 88, 2, '和顺县', '140723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3759, 88, 2, '昔阳县', '140724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3760, 88, 2, '寿阳县', '140725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3761, 88, 2, '太谷县', '140726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3762, 88, 2, '祁县', '140727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3763, 88, 2, '平遥县', '140728', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3764, 88, 2, '灵石县', '140729', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3765, 88, 2, '介休市', '140781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3766, 89, 2, '盐湖区', '140802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3767, 89, 2, '临猗县', '140821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3768, 89, 2, '万荣县', '140822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3769, 89, 2, '闻喜县', '140823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3770, 89, 2, '稷山县', '140824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3771, 89, 2, '新绛县', '140825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3772, 89, 2, '绛县', '140826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3773, 89, 2, '垣曲县', '140827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3774, 89, 2, '夏县', '140828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3775, 89, 2, '平陆县', '140829', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3776, 89, 2, '芮城县', '140830', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3777, 89, 2, '永济市', '140881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3778, 89, 2, '河津市', '140882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3779, 90, 2, '忻府区', '140902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3780, 90, 2, '定襄县', '140921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3781, 90, 2, '五台县', '140922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3782, 90, 2, '代县', '140923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3783, 90, 2, '繁峙县', '140924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3784, 90, 2, '宁武县', '140925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3785, 90, 2, '静乐县', '140926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3786, 90, 2, '神池县', '140927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3787, 90, 2, '五寨县', '140928', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3788, 90, 2, '岢岚县', '140929', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3789, 90, 2, '河曲县', '140930', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3790, 90, 2, '保德县', '140931', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3791, 90, 2, '偏关县', '140932', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3792, 90, 2, '五台山风景名胜区', '140971', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3793, 90, 2, '原平市', '140981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3794, 91, 2, '尧都区', '141002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3795, 91, 2, '曲沃县', '141021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3796, 91, 2, '翼城县', '141022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3797, 91, 2, '襄汾县', '141023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3798, 91, 2, '洪洞县', '141024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3799, 91, 2, '古县', '141025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3800, 91, 2, '安泽县', '141026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3801, 91, 2, '浮山县', '141027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3802, 91, 2, '吉县', '141028', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3803, 91, 2, '乡宁县', '141029', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3804, 91, 2, '大宁县', '141030', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3805, 91, 2, '隰县', '141031', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3806, 91, 2, '永和县', '141032', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3807, 91, 2, '蒲县', '141033', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3808, 91, 2, '汾西县', '141034', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3809, 91, 2, '侯马市', '141081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3810, 91, 2, '霍州市', '141082', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3811, 92, 2, '离石区', '141102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3812, 92, 2, '文水县', '141121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3813, 92, 2, '交城县', '141122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3814, 92, 2, '兴县', '141123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3815, 92, 2, '临县', '141124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3816, 92, 2, '柳林县', '141125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3817, 92, 2, '石楼县', '141126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3818, 92, 2, '岚县', '141127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3819, 92, 2, '方山县', '141128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3820, 92, 2, '中阳县', '141129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3821, 92, 2, '交口县', '141130', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3822, 92, 2, '孝义市', '141181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3823, 92, 2, '汾阳市', '141182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3824, 93, 2, '新城区', '150102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3825, 93, 2, '回民区', '150103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3826, 93, 2, '玉泉区', '150104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3827, 93, 2, '赛罕区', '150105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3828, 93, 2, '土默特左旗', '150121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3829, 93, 2, '托克托县', '150122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3830, 93, 2, '和林格尔县', '150123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3831, 93, 2, '清水河县', '150124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3832, 93, 2, '武川县', '150125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3833, 93, 2, '呼和浩特金海工业园区', '150171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3834, 93, 2, '呼和浩特经济技术开发区', '150172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3835, 94, 2, '东河区', '150202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3836, 94, 2, '昆都仑区', '150203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3837, 94, 2, '青山区', '150204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3838, 94, 2, '石拐区', '150205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3839, 94, 2, '白云鄂博矿区', '150206', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3840, 94, 2, '九原区', '150207', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3841, 94, 2, '土默特右旗', '150221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3842, 94, 2, '固阳县', '150222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3843, 94, 2, '达尔罕茂明安联合旗', '150223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3844, 94, 2, '包头稀土高新技术产业开发区', '150271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3845, 95, 2, '海勃湾区', '150302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3846, 95, 2, '海南区', '150303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3847, 95, 2, '乌达区', '150304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3848, 96, 2, '红山区', '150402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3849, 96, 2, '元宝山区', '150403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3850, 96, 2, '松山区', '150404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3851, 96, 2, '阿鲁科尔沁旗', '150421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3852, 96, 2, '巴林左旗', '150422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3853, 96, 2, '巴林右旗', '150423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3854, 96, 2, '林西县', '150424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3855, 96, 2, '克什克腾旗', '150425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3856, 96, 2, '翁牛特旗', '150426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3857, 96, 2, '喀喇沁旗', '150428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3858, 96, 2, '宁城县', '150429', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3859, 96, 2, '敖汉旗', '150430', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3860, 97, 2, '科尔沁区', '150502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3861, 97, 2, '科尔沁左翼中旗', '150521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3862, 97, 2, '科尔沁左翼后旗', '150522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3863, 97, 2, '开鲁县', '150523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3864, 97, 2, '库伦旗', '150524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3865, 97, 2, '奈曼旗', '150525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3866, 97, 2, '扎鲁特旗', '150526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3867, 97, 2, '通辽经济技术开发区', '150571', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3868, 97, 2, '霍林郭勒市', '150581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3869, 98, 2, '东胜区', '150602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3870, 98, 2, '康巴什区', '150603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3871, 98, 2, '达拉特旗', '150621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3872, 98, 2, '准格尔旗', '150622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3873, 98, 2, '鄂托克前旗', '150623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3874, 98, 2, '鄂托克旗', '150624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3875, 98, 2, '杭锦旗', '150625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3876, 98, 2, '乌审旗', '150626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3877, 98, 2, '伊金霍洛旗', '150627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3878, 99, 2, '海拉尔区', '150702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3879, 99, 2, '扎赉诺尔区', '150703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3880, 99, 2, '阿荣旗', '150721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3881, 99, 2, '莫力达瓦达斡尔族自治旗', '150722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3882, 99, 2, '鄂伦春自治旗', '150723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3883, 99, 2, '鄂温克族自治旗', '150724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3884, 99, 2, '陈巴尔虎旗', '150725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3885, 99, 2, '新巴尔虎左旗', '150726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3886, 99, 2, '新巴尔虎右旗', '150727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3887, 99, 2, '满洲里市', '150781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3888, 99, 2, '牙克石市', '150782', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3889, 99, 2, '扎兰屯市', '150783', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3890, 99, 2, '额尔古纳市', '150784', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3891, 99, 2, '根河市', '150785', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3892, 100, 2, '临河区', '150802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3893, 100, 2, '五原县', '150821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3894, 100, 2, '磴口县', '150822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3895, 100, 2, '乌拉特前旗', '150823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3896, 100, 2, '乌拉特中旗', '150824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3897, 100, 2, '乌拉特后旗', '150825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3898, 100, 2, '杭锦后旗', '150826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3899, 101, 2, '集宁区', '150902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3900, 101, 2, '卓资县', '150921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3901, 101, 2, '化德县', '150922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3902, 101, 2, '商都县', '150923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3903, 101, 2, '兴和县', '150924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3904, 101, 2, '凉城县', '150925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3905, 101, 2, '察哈尔右翼前旗', '150926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3906, 101, 2, '察哈尔右翼中旗', '150927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3907, 101, 2, '察哈尔右翼后旗', '150928', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3908, 101, 2, '四子王旗', '150929', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3909, 101, 2, '丰镇市', '150981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3910, 102, 2, '乌兰浩特市', '152201', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3911, 102, 2, '阿尔山市', '152202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3912, 102, 2, '科尔沁右翼前旗', '152221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3913, 102, 2, '科尔沁右翼中旗', '152222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3914, 102, 2, '扎赉特旗', '152223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3915, 102, 2, '突泉县', '152224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3916, 103, 2, '二连浩特市', '152501', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3917, 103, 2, '锡林浩特市', '152502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3918, 103, 2, '阿巴嘎旗', '152522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3919, 103, 2, '苏尼特左旗', '152523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3920, 103, 2, '苏尼特右旗', '152524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3921, 103, 2, '东乌珠穆沁旗', '152525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3922, 103, 2, '西乌珠穆沁旗', '152526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3923, 103, 2, '太仆寺旗', '152527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3924, 103, 2, '镶黄旗', '152528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3925, 103, 2, '正镶白旗', '152529', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3926, 103, 2, '正蓝旗', '152530', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3927, 103, 2, '多伦县', '152531', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3928, 103, 2, '乌拉盖管委会', '152571', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3929, 104, 2, '阿拉善左旗', '152921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3930, 104, 2, '阿拉善右旗', '152922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3931, 104, 2, '额济纳旗', '152923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3932, 104, 2, '内蒙古阿拉善经济开发区', '152971', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3933, 105, 2, '和平区', '210102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3934, 105, 2, '沈河区', '210103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3935, 105, 2, '大东区', '210104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3936, 105, 2, '皇姑区', '210105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3937, 105, 2, '铁西区', '210106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3938, 105, 2, '苏家屯区', '210111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3939, 105, 2, '浑南区', '210112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3940, 105, 2, '沈北新区', '210113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3941, 105, 2, '于洪区', '210114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3942, 105, 2, '辽中区', '210115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3943, 105, 2, '康平县', '210123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3944, 105, 2, '法库县', '210124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3945, 105, 2, '新民市', '210181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3946, 106, 2, '中山区', '210202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3947, 106, 2, '西岗区', '210203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3948, 106, 2, '沙河口区', '210204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3949, 106, 2, '甘井子区', '210211', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3950, 106, 2, '旅顺口区', '210212', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3951, 106, 2, '金州区', '210213', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3952, 106, 2, '普兰店区', '210214', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3953, 106, 2, '长海县', '210224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3954, 106, 2, '瓦房店市', '210281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3955, 106, 2, '庄河市', '210283', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3956, 107, 2, '铁东区', '210302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3957, 107, 2, '铁西区', '210303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3958, 107, 2, '立山区', '210304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3959, 107, 2, '千山区', '210311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3960, 107, 2, '台安县', '210321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3961, 107, 2, '岫岩满族自治县', '210323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3962, 107, 2, '海城市', '210381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3963, 108, 2, '新抚区', '210402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3964, 108, 2, '东洲区', '210403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3965, 108, 2, '望花区', '210404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3966, 108, 2, '顺城区', '210411', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3967, 108, 2, '抚顺县', '210421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3968, 108, 2, '新宾满族自治县', '210422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3969, 108, 2, '清原满族自治县', '210423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3970, 109, 2, '平山区', '210502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3971, 109, 2, '溪湖区', '210503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3972, 109, 2, '明山区', '210504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3973, 109, 2, '南芬区', '210505', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3974, 109, 2, '本溪满族自治县', '210521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3975, 109, 2, '桓仁满族自治县', '210522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3976, 110, 2, '元宝区', '210602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3977, 110, 2, '振兴区', '210603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3978, 110, 2, '振安区', '210604', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3979, 110, 2, '宽甸满族自治县', '210624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3980, 110, 2, '东港市', '210681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3981, 110, 2, '凤城市', '210682', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3982, 111, 2, '古塔区', '210702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3983, 111, 2, '凌河区', '210703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3984, 111, 2, '太和区', '210711', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3985, 111, 2, '黑山县', '210726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3986, 111, 2, '义县', '210727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3987, 111, 2, '凌海市', '210781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3988, 111, 2, '北镇市', '210782', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3989, 112, 2, '站前区', '210802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3990, 112, 2, '西市区', '210803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3991, 112, 2, '鲅鱼圈区', '210804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3992, 112, 2, '老边区', '210811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3993, 112, 2, '盖州市', '210881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3994, 112, 2, '大石桥市', '210882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3995, 113, 2, '海州区', '210902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3996, 113, 2, '新邱区', '210903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3997, 113, 2, '太平区', '210904', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3998, 113, 2, '清河门区', '210905', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (3999, 113, 2, '细河区', '210911', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4000, 113, 2, '阜新蒙古族自治县', '210921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4001, 113, 2, '彰武县', '210922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4002, 114, 2, '白塔区', '211002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4003, 114, 2, '文圣区', '211003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4004, 114, 2, '宏伟区', '211004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4005, 114, 2, '弓长岭区', '211005', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4006, 114, 2, '太子河区', '211011', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4007, 114, 2, '辽阳县', '211021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4008, 114, 2, '灯塔市', '211081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4009, 115, 2, '双台子区', '211102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4010, 115, 2, '兴隆台区', '211103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4011, 115, 2, '大洼区', '211104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4012, 115, 2, '盘山县', '211122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4013, 116, 2, '银州区', '211202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4014, 116, 2, '清河区', '211204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4015, 116, 2, '铁岭县', '211221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4016, 116, 2, '西丰县', '211223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4017, 116, 2, '昌图县', '211224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4018, 116, 2, '调兵山市', '211281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4019, 116, 2, '开原市', '211282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4020, 117, 2, '双塔区', '211302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4021, 117, 2, '龙城区', '211303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4022, 117, 2, '朝阳县', '211321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4023, 117, 2, '建平县', '211322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4024, 117, 2, '喀喇沁左翼蒙古族自治县', '211324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4025, 117, 2, '北票市', '211381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4026, 117, 2, '凌源市', '211382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4027, 118, 2, '连山区', '211402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4028, 118, 2, '龙港区', '211403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4029, 118, 2, '南票区', '211404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4030, 118, 2, '绥中县', '211421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4031, 118, 2, '建昌县', '211422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4032, 118, 2, '兴城市', '211481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4033, 119, 2, '南关区', '220102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4034, 119, 2, '宽城区', '220103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4035, 119, 2, '朝阳区', '220104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4036, 119, 2, '二道区', '220105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4037, 119, 2, '绿园区', '220106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4038, 119, 2, '双阳区', '220112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4039, 119, 2, '九台区', '220113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4040, 119, 2, '农安县', '220122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4041, 119, 2, '长春经济技术开发区', '220171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4042, 119, 2, '长春净月高新技术产业开发区', '220172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4043, 119, 2, '长春高新技术产业开发区', '220173', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4044, 119, 2, '长春汽车经济技术开发区', '220174', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4045, 119, 2, '榆树市', '220182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4046, 119, 2, '德惠市', '220183', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4047, 120, 2, '昌邑区', '220202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4048, 120, 2, '龙潭区', '220203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4049, 120, 2, '船营区', '220204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4050, 120, 2, '丰满区', '220211', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4051, 120, 2, '永吉县', '220221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4052, 120, 2, '吉林经济开发区', '220271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4053, 120, 2, '吉林高新技术产业开发区', '220272', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4054, 120, 2, '吉林中国新加坡食品区', '220273', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4055, 120, 2, '蛟河市', '220281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4056, 120, 2, '桦甸市', '220282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4057, 120, 2, '舒兰市', '220283', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4058, 120, 2, '磐石市', '220284', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4059, 121, 2, '铁西区', '220302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4060, 121, 2, '铁东区', '220303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4061, 121, 2, '梨树县', '220322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4062, 121, 2, '伊通满族自治县', '220323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4063, 121, 2, '公主岭市', '220381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4064, 121, 2, '双辽市', '220382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4065, 122, 2, '龙山区', '220402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4066, 122, 2, '西安区', '220403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4067, 122, 2, '东丰县', '220421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4068, 122, 2, '东辽县', '220422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4069, 123, 2, '东昌区', '220502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4070, 123, 2, '二道江区', '220503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4071, 123, 2, '通化县', '220521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4072, 123, 2, '辉南县', '220523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4073, 123, 2, '柳河县', '220524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4074, 123, 2, '梅河口市', '220581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4075, 123, 2, '集安市', '220582', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4076, 124, 2, '浑江区', '220602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4077, 124, 2, '江源区', '220605', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4078, 124, 2, '抚松县', '220621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4079, 124, 2, '靖宇县', '220622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4080, 124, 2, '长白朝鲜族自治县', '220623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4081, 124, 2, '临江市', '220681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4082, 125, 2, '宁江区', '220702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4083, 125, 2, '前郭尔罗斯蒙古族自治县', '220721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4084, 125, 2, '长岭县', '220722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4085, 125, 2, '乾安县', '220723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4086, 125, 2, '吉林松原经济开发区', '220771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4087, 125, 2, '扶余市', '220781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4088, 126, 2, '洮北区', '220802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4089, 126, 2, '镇赉县', '220821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4090, 126, 2, '通榆县', '220822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4091, 126, 2, '吉林白城经济开发区', '220871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4092, 126, 2, '洮南市', '220881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4093, 126, 2, '大安市', '220882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4094, 127, 2, '延吉市', '222401', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4095, 127, 2, '图们市', '222402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4096, 127, 2, '敦化市', '222403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4097, 127, 2, '珲春市', '222404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4098, 127, 2, '龙井市', '222405', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4099, 127, 2, '和龙市', '222406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4100, 127, 2, '汪清县', '222424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4101, 127, 2, '安图县', '222426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4102, 128, 2, '道里区', '230102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4103, 128, 2, '南岗区', '230103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4104, 128, 2, '道外区', '230104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4105, 128, 2, '平房区', '230108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4106, 128, 2, '松北区', '230109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4107, 128, 2, '香坊区', '230110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4108, 128, 2, '呼兰区', '230111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4109, 128, 2, '阿城区', '230112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4110, 128, 2, '双城区', '230113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4111, 128, 2, '依兰县', '230123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4112, 128, 2, '方正县', '230124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4113, 128, 2, '宾县', '230125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4114, 128, 2, '巴彦县', '230126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4115, 128, 2, '木兰县', '230127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4116, 128, 2, '通河县', '230128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4117, 128, 2, '延寿县', '230129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4118, 128, 2, '尚志市', '230183', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4119, 128, 2, '五常市', '230184', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4120, 129, 2, '龙沙区', '230202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4121, 129, 2, '建华区', '230203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4122, 129, 2, '铁锋区', '230204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4123, 129, 2, '昂昂溪区', '230205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4124, 129, 2, '富拉尔基区', '230206', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4125, 129, 2, '碾子山区', '230207', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4126, 129, 2, '梅里斯达斡尔族区', '230208', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4127, 129, 2, '龙江县', '230221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4128, 129, 2, '依安县', '230223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4129, 129, 2, '泰来县', '230224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4130, 129, 2, '甘南县', '230225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4131, 129, 2, '富裕县', '230227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4132, 129, 2, '克山县', '230229', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4133, 129, 2, '克东县', '230230', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4134, 129, 2, '拜泉县', '230231', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4135, 129, 2, '讷河市', '230281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4136, 130, 2, '鸡冠区', '230302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4137, 130, 2, '恒山区', '230303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4138, 130, 2, '滴道区', '230304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4139, 130, 2, '梨树区', '230305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4140, 130, 2, '城子河区', '230306', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4141, 130, 2, '麻山区', '230307', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4142, 130, 2, '鸡东县', '230321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4143, 130, 2, '虎林市', '230381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4144, 130, 2, '密山市', '230382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4145, 131, 2, '向阳区', '230402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4146, 131, 2, '工农区', '230403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4147, 131, 2, '南山区', '230404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4148, 131, 2, '兴安区', '230405', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4149, 131, 2, '东山区', '230406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4150, 131, 2, '兴山区', '230407', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4151, 131, 2, '萝北县', '230421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4152, 131, 2, '绥滨县', '230422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4153, 132, 2, '尖山区', '230502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4154, 132, 2, '岭东区', '230503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4155, 132, 2, '四方台区', '230505', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4156, 132, 2, '宝山区', '230506', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4157, 132, 2, '集贤县', '230521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4158, 132, 2, '友谊县', '230522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4159, 132, 2, '宝清县', '230523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4160, 132, 2, '饶河县', '230524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4161, 133, 2, '萨尔图区', '230602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4162, 133, 2, '龙凤区', '230603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4163, 133, 2, '让胡路区', '230604', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4164, 133, 2, '红岗区', '230605', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4165, 133, 2, '大同区', '230606', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4166, 133, 2, '肇州县', '230621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4167, 133, 2, '肇源县', '230622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4168, 133, 2, '林甸县', '230623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4169, 133, 2, '杜尔伯特蒙古族自治县', '230624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4170, 133, 2, '大庆高新技术产业开发区', '230671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4171, 134, 2, '伊美区', '230717', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4172, 134, 2, '乌翠区', '230718', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4173, 134, 2, '友好区', '230719', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4174, 134, 2, '嘉荫县', '230722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4175, 134, 2, '汤旺县', '230723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4176, 134, 2, '丰林县', '230724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4177, 134, 2, '大箐山县', '230725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4178, 134, 2, '南岔县', '230726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4179, 134, 2, '金林区', '230751', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4180, 134, 2, '铁力市', '230781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4181, 135, 2, '向阳区', '230803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4182, 135, 2, '前进区', '230804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4183, 135, 2, '东风区', '230805', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4184, 135, 2, '郊区', '230811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4185, 135, 2, '桦南县', '230822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4186, 135, 2, '桦川县', '230826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4187, 135, 2, '汤原县', '230828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4188, 135, 2, '同江市', '230881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4189, 135, 2, '富锦市', '230882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4190, 135, 2, '抚远市', '230883', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4191, 136, 2, '新兴区', '230902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4192, 136, 2, '桃山区', '230903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4193, 136, 2, '茄子河区', '230904', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4194, 136, 2, '勃利县', '230921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4195, 137, 2, '东安区', '231002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4196, 137, 2, '阳明区', '231003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4197, 137, 2, '爱民区', '231004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4198, 137, 2, '西安区', '231005', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4199, 137, 2, '林口县', '231025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4200, 137, 2, '牡丹江经济技术开发区', '231071', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4201, 137, 2, '绥芬河市', '231081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4202, 137, 2, '海林市', '231083', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4203, 137, 2, '宁安市', '231084', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4204, 137, 2, '穆棱市', '231085', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4205, 137, 2, '东宁市', '231086', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4206, 138, 2, '爱辉区', '231102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4207, 138, 2, '逊克县', '231123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4208, 138, 2, '孙吴县', '231124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4209, 138, 2, '北安市', '231181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4210, 138, 2, '五大连池市', '231182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4211, 138, 2, '嫩江市', '231183', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4212, 139, 2, '北林区', '231202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4213, 139, 2, '望奎县', '231221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4214, 139, 2, '兰西县', '231222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4215, 139, 2, '青冈县', '231223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4216, 139, 2, '庆安县', '231224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4217, 139, 2, '明水县', '231225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4218, 139, 2, '绥棱县', '231226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4219, 139, 2, '安达市', '231281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4220, 139, 2, '肇东市', '231282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4221, 139, 2, '海伦市', '231283', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4222, 140, 2, '漠河市', '232701', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4223, 140, 2, '呼玛县', '232721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4224, 140, 2, '塔河县', '232722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4225, 140, 2, '加格达奇区', '232761', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4226, 140, 2, '松岭区', '232762', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4227, 140, 2, '新林区', '232763', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4228, 140, 2, '呼中区', '232764', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4229, 141, 2, '黄浦区', '310101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4230, 141, 2, '徐汇区', '310104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4231, 141, 2, '长宁区', '310105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4232, 141, 2, '静安区', '310106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4233, 141, 2, '普陀区', '310107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4234, 141, 2, '虹口区', '310109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4235, 141, 2, '杨浦区', '310110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4236, 141, 2, '闵行区', '310112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4237, 141, 2, '宝山区', '310113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4238, 141, 2, '嘉定区', '310114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4239, 141, 2, '浦东新区', '310115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4240, 141, 2, '金山区', '310116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4241, 141, 2, '松江区', '310117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4242, 141, 2, '青浦区', '310118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4243, 141, 2, '奉贤区', '310120', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4244, 141, 2, '崇明区', '310151', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4245, 142, 2, '玄武区', '320102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4246, 142, 2, '秦淮区', '320104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4247, 142, 2, '建邺区', '320105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4248, 142, 2, '鼓楼区', '320106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4249, 142, 2, '浦口区', '320111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4250, 142, 2, '栖霞区', '320113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4251, 142, 2, '雨花台区', '320114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4252, 142, 2, '江宁区', '320115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4253, 142, 2, '六合区', '320116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4254, 142, 2, '溧水区', '320117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4255, 142, 2, '高淳区', '320118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4256, 143, 2, '锡山区', '320205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4257, 143, 2, '惠山区', '320206', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4258, 143, 2, '滨湖区', '320211', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4259, 143, 2, '梁溪区', '320213', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4260, 143, 2, '新吴区', '320214', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4261, 143, 2, '江阴市', '320281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4262, 143, 2, '宜兴市', '320282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4263, 144, 2, '鼓楼区', '320302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4264, 144, 2, '云龙区', '320303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4265, 144, 2, '贾汪区', '320305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4266, 144, 2, '泉山区', '320311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4267, 144, 2, '铜山区', '320312', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4268, 144, 2, '丰县', '320321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4269, 144, 2, '沛县', '320322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4270, 144, 2, '睢宁县', '320324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4271, 144, 2, '徐州经济技术开发区', '320371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4272, 144, 2, '新沂市', '320381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4273, 144, 2, '邳州市', '320382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4274, 145, 2, '天宁区', '320402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4275, 145, 2, '钟楼区', '320404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4276, 145, 2, '新北区', '320411', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4277, 145, 2, '武进区', '320412', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4278, 145, 2, '金坛区', '320413', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4279, 145, 2, '溧阳市', '320481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4280, 146, 2, '虎丘区', '320505', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4281, 146, 2, '吴中区', '320506', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4282, 146, 2, '相城区', '320507', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4283, 146, 2, '姑苏区', '320508', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4284, 146, 2, '吴江区', '320509', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4285, 146, 2, '苏州工业园区', '320571', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4286, 146, 2, '常熟市', '320581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4287, 146, 2, '张家港市', '320582', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4288, 146, 2, '昆山市', '320583', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4289, 146, 2, '太仓市', '320585', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4290, 147, 2, '崇川区', '320602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4291, 147, 2, '港闸区', '320611', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4292, 147, 2, '通州区', '320612', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4293, 147, 2, '如东县', '320623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4294, 147, 2, '南通经济技术开发区', '320671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4295, 147, 2, '启东市', '320681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4296, 147, 2, '如皋市', '320682', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4297, 147, 2, '海门市', '320684', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4298, 147, 2, '海安市', '320685', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4299, 148, 2, '连云区', '320703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4300, 148, 2, '海州区', '320706', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4301, 148, 2, '赣榆区', '320707', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4302, 148, 2, '东海县', '320722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4303, 148, 2, '灌云县', '320723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4304, 148, 2, '灌南县', '320724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4305, 148, 2, '连云港经济技术开发区', '320771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4306, 148, 2, '连云港高新技术产业开发区', '320772', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4307, 149, 2, '淮安区', '320803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4308, 149, 2, '淮阴区', '320804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4309, 149, 2, '清江浦区', '320812', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4310, 149, 2, '洪泽区', '320813', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4311, 149, 2, '涟水县', '320826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4312, 149, 2, '盱眙县', '320830', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4313, 149, 2, '金湖县', '320831', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4314, 149, 2, '淮安经济技术开发区', '320871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4315, 150, 2, '亭湖区', '320902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4316, 150, 2, '盐都区', '320903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4317, 150, 2, '大丰区', '320904', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4318, 150, 2, '响水县', '320921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4319, 150, 2, '滨海县', '320922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4320, 150, 2, '阜宁县', '320923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4321, 150, 2, '射阳县', '320924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4322, 150, 2, '建湖县', '320925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4323, 150, 2, '盐城经济技术开发区', '320971', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4324, 150, 2, '东台市', '320981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4325, 151, 2, '广陵区', '321002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4326, 151, 2, '邗江区', '321003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4327, 151, 2, '江都区', '321012', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4328, 151, 2, '宝应县', '321023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4329, 151, 2, '扬州经济技术开发区', '321071', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4330, 151, 2, '仪征市', '321081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4331, 151, 2, '高邮市', '321084', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4332, 152, 2, '京口区', '321102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4333, 152, 2, '润州区', '321111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4334, 152, 2, '丹徒区', '321112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4335, 152, 2, '镇江新区', '321171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4336, 152, 2, '丹阳市', '321181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4337, 152, 2, '扬中市', '321182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4338, 152, 2, '句容市', '321183', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4339, 153, 2, '海陵区', '321202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4340, 153, 2, '高港区', '321203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4341, 153, 2, '姜堰区', '321204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4342, 153, 2, '泰州医药高新技术产业开发区', '321271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4343, 153, 2, '兴化市', '321281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4344, 153, 2, '靖江市', '321282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4345, 153, 2, '泰兴市', '321283', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4346, 154, 2, '宿城区', '321302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4347, 154, 2, '宿豫区', '321311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4348, 154, 2, '沭阳县', '321322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4349, 154, 2, '泗阳县', '321323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4350, 154, 2, '泗洪县', '321324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4351, 154, 2, '宿迁经济技术开发区', '321371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4352, 155, 2, '上城区', '330102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4353, 155, 2, '下城区', '330103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4354, 155, 2, '江干区', '330104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4355, 155, 2, '拱墅区', '330105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4356, 155, 2, '西湖区', '330106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4357, 155, 2, '滨江区', '330108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4358, 155, 2, '萧山区', '330109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4359, 155, 2, '余杭区', '330110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4360, 155, 2, '富阳区', '330111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4361, 155, 2, '临安区', '330112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4362, 155, 2, '桐庐县', '330122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4363, 155, 2, '淳安县', '330127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4364, 155, 2, '建德市', '330182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4365, 156, 2, '海曙区', '330203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4366, 156, 2, '江北区', '330205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4367, 156, 2, '北仑区', '330206', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4368, 156, 2, '镇海区', '330211', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4369, 156, 2, '鄞州区', '330212', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4370, 156, 2, '奉化区', '330213', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4371, 156, 2, '象山县', '330225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4372, 156, 2, '宁海县', '330226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4373, 156, 2, '余姚市', '330281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4374, 156, 2, '慈溪市', '330282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4375, 157, 2, '鹿城区', '330302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4376, 157, 2, '龙湾区', '330303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4377, 157, 2, '瓯海区', '330304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4378, 157, 2, '洞头区', '330305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4379, 157, 2, '永嘉县', '330324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4380, 157, 2, '平阳县', '330326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4381, 157, 2, '苍南县', '330327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4382, 157, 2, '文成县', '330328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4383, 157, 2, '泰顺县', '330329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4384, 157, 2, '温州经济技术开发区', '330371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4385, 157, 2, '瑞安市', '330381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4386, 157, 2, '乐清市', '330382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4387, 157, 2, '龙港市', '330383', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4388, 158, 2, '南湖区', '330402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4389, 158, 2, '秀洲区', '330411', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4390, 158, 2, '嘉善县', '330421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4391, 158, 2, '海盐县', '330424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4392, 158, 2, '海宁市', '330481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4393, 158, 2, '平湖市', '330482', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4394, 158, 2, '桐乡市', '330483', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4395, 159, 2, '吴兴区', '330502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4396, 159, 2, '南浔区', '330503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4397, 159, 2, '德清县', '330521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4398, 159, 2, '长兴县', '330522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4399, 159, 2, '安吉县', '330523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4400, 160, 2, '越城区', '330602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4401, 160, 2, '柯桥区', '330603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4402, 160, 2, '上虞区', '330604', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4403, 160, 2, '新昌县', '330624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4404, 160, 2, '诸暨市', '330681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4405, 160, 2, '嵊州市', '330683', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4406, 161, 2, '婺城区', '330702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4407, 161, 2, '金东区', '330703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4408, 161, 2, '武义县', '330723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4409, 161, 2, '浦江县', '330726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4410, 161, 2, '磐安县', '330727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4411, 161, 2, '兰溪市', '330781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4412, 161, 2, '义乌市', '330782', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4413, 161, 2, '东阳市', '330783', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4414, 161, 2, '永康市', '330784', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4415, 162, 2, '柯城区', '330802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4416, 162, 2, '衢江区', '330803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4417, 162, 2, '常山县', '330822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4418, 162, 2, '开化县', '330824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4419, 162, 2, '龙游县', '330825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4420, 162, 2, '江山市', '330881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4421, 163, 2, '定海区', '330902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4422, 163, 2, '普陀区', '330903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4423, 163, 2, '岱山县', '330921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4424, 163, 2, '嵊泗县', '330922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4425, 164, 2, '椒江区', '331002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4426, 164, 2, '黄岩区', '331003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4427, 164, 2, '路桥区', '331004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4428, 164, 2, '三门县', '331022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4429, 164, 2, '天台县', '331023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4430, 164, 2, '仙居县', '331024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4431, 164, 2, '温岭市', '331081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4432, 164, 2, '临海市', '331082', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4433, 164, 2, '玉环市', '331083', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4434, 165, 2, '莲都区', '331102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4435, 165, 2, '青田县', '331121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4436, 165, 2, '缙云县', '331122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4437, 165, 2, '遂昌县', '331123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4438, 165, 2, '松阳县', '331124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4439, 165, 2, '云和县', '331125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4440, 165, 2, '庆元县', '331126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4441, 165, 2, '景宁畲族自治县', '331127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4442, 165, 2, '龙泉市', '331181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4443, 166, 2, '瑶海区', '340102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4444, 166, 2, '庐阳区', '340103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4445, 166, 2, '蜀山区', '340104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4446, 166, 2, '包河区', '340111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4447, 166, 2, '长丰县', '340121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4448, 166, 2, '肥东县', '340122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4449, 166, 2, '肥西县', '340123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4450, 166, 2, '庐江县', '340124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4451, 166, 2, '合肥高新技术产业开发区', '340171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4452, 166, 2, '合肥经济技术开发区', '340172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4453, 166, 2, '合肥新站高新技术产业开发区', '340173', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4454, 166, 2, '巢湖市', '340181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4455, 167, 2, '镜湖区', '340202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4456, 167, 2, '弋江区', '340203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4457, 167, 2, '鸠江区', '340207', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4458, 167, 2, '三山区', '340208', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4459, 167, 2, '芜湖县', '340221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4460, 167, 2, '繁昌县', '340222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4461, 167, 2, '南陵县', '340223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4462, 167, 2, '无为县', '340225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4463, 167, 2, '芜湖经济技术开发区', '340271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4464, 167, 2, '安徽芜湖长江大桥经济开发区', '340272', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4465, 168, 2, '龙子湖区', '340302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4466, 168, 2, '蚌山区', '340303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4467, 168, 2, '禹会区', '340304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4468, 168, 2, '淮上区', '340311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4469, 168, 2, '怀远县', '340321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4470, 168, 2, '五河县', '340322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4471, 168, 2, '固镇县', '340323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4472, 168, 2, '蚌埠市高新技术开发区', '340371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4473, 168, 2, '蚌埠市经济开发区', '340372', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4474, 169, 2, '大通区', '340402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4475, 169, 2, '田家庵区', '340403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4476, 169, 2, '谢家集区', '340404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4477, 169, 2, '八公山区', '340405', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4478, 169, 2, '潘集区', '340406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4479, 169, 2, '凤台县', '340421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4480, 169, 2, '寿县', '340422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4481, 170, 2, '花山区', '340503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4482, 170, 2, '雨山区', '340504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4483, 170, 2, '博望区', '340506', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4484, 170, 2, '当涂县', '340521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4485, 170, 2, '含山县', '340522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4486, 170, 2, '和县', '340523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4487, 171, 2, '杜集区', '340602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4488, 171, 2, '相山区', '340603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4489, 171, 2, '烈山区', '340604', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4490, 171, 2, '濉溪县', '340621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4491, 172, 2, '铜官区', '340705', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4492, 172, 2, '义安区', '340706', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4493, 172, 2, '郊区', '340711', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4494, 172, 2, '枞阳县', '340722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4495, 173, 2, '迎江区', '340802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4496, 173, 2, '大观区', '340803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4497, 173, 2, '宜秀区', '340811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4498, 173, 2, '怀宁县', '340822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4499, 173, 2, '太湖县', '340825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4500, 173, 2, '宿松县', '340826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4501, 173, 2, '望江县', '340827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4502, 173, 2, '岳西县', '340828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4503, 173, 2, '安徽安庆经济开发区', '340871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4504, 173, 2, '桐城市', '340881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4505, 173, 2, '潜山市', '340882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4506, 174, 2, '屯溪区', '341002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4507, 174, 2, '黄山区', '341003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4508, 174, 2, '徽州区', '341004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4509, 174, 2, '歙县', '341021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4510, 174, 2, '休宁县', '341022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4511, 174, 2, '黟县', '341023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4512, 174, 2, '祁门县', '341024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4513, 175, 2, '琅琊区', '341102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4514, 175, 2, '南谯区', '341103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4515, 175, 2, '来安县', '341122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4516, 175, 2, '全椒县', '341124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4517, 175, 2, '定远县', '341125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4518, 175, 2, '凤阳县', '341126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4519, 175, 2, '苏滁现代产业园', '341171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4520, 175, 2, '滁州经济技术开发区', '341172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4521, 175, 2, '天长市', '341181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4522, 175, 2, '明光市', '341182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4523, 176, 2, '颍州区', '341202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4524, 176, 2, '颍东区', '341203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4525, 176, 2, '颍泉区', '341204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4526, 176, 2, '临泉县', '341221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4527, 176, 2, '太和县', '341222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4528, 176, 2, '阜南县', '341225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4529, 176, 2, '颍上县', '341226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4530, 176, 2, '阜阳合肥现代产业园区', '341271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4531, 176, 2, '阜阳经济技术开发区', '341272', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4532, 176, 2, '界首市', '341282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4533, 177, 2, '埇桥区', '341302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4534, 177, 2, '砀山县', '341321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4535, 177, 2, '萧县', '341322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4536, 177, 2, '灵璧县', '341323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4537, 177, 2, '泗县', '341324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4538, 177, 2, '宿州马鞍山现代产业园区', '341371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4539, 177, 2, '宿州经济技术开发区', '341372', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4540, 178, 2, '金安区', '341502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4541, 178, 2, '裕安区', '341503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4542, 178, 2, '叶集区', '341504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4543, 178, 2, '霍邱县', '341522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4544, 178, 2, '舒城县', '341523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4545, 178, 2, '金寨县', '341524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4546, 178, 2, '霍山县', '341525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4547, 179, 2, '谯城区', '341602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4548, 179, 2, '涡阳县', '341621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4549, 179, 2, '蒙城县', '341622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4550, 179, 2, '利辛县', '341623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4551, 180, 2, '贵池区', '341702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4552, 180, 2, '东至县', '341721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4553, 180, 2, '石台县', '341722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4554, 180, 2, '青阳县', '341723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4555, 181, 2, '宣州区', '341802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4556, 181, 2, '郎溪县', '341821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4557, 181, 2, '泾县', '341823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4558, 181, 2, '绩溪县', '341824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4559, 181, 2, '旌德县', '341825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4560, 181, 2, '宣城市经济开发区', '341871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4561, 181, 2, '宁国市', '341881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4562, 181, 2, '广德市', '341882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4563, 182, 2, '鼓楼区', '350102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4564, 182, 2, '台江区', '350103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4565, 182, 2, '仓山区', '350104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4566, 182, 2, '马尾区', '350105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4567, 182, 2, '晋安区', '350111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4568, 182, 2, '长乐区', '350112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4569, 182, 2, '闽侯县', '350121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4570, 182, 2, '连江县', '350122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4571, 182, 2, '罗源县', '350123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4572, 182, 2, '闽清县', '350124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4573, 182, 2, '永泰县', '350125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4574, 182, 2, '平潭县', '350128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4575, 182, 2, '福清市', '350181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4576, 183, 2, '思明区', '350203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4577, 183, 2, '海沧区', '350205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4578, 183, 2, '湖里区', '350206', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4579, 183, 2, '集美区', '350211', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4580, 183, 2, '同安区', '350212', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4581, 183, 2, '翔安区', '350213', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4582, 184, 2, '城厢区', '350302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4583, 184, 2, '涵江区', '350303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4584, 184, 2, '荔城区', '350304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4585, 184, 2, '秀屿区', '350305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4586, 184, 2, '仙游县', '350322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4587, 185, 2, '梅列区', '350402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4588, 185, 2, '三元区', '350403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4589, 185, 2, '明溪县', '350421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4590, 185, 2, '清流县', '350423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4591, 185, 2, '宁化县', '350424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4592, 185, 2, '大田县', '350425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4593, 185, 2, '尤溪县', '350426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4594, 185, 2, '沙县', '350427', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4595, 185, 2, '将乐县', '350428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4596, 185, 2, '泰宁县', '350429', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4597, 185, 2, '建宁县', '350430', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4598, 185, 2, '永安市', '350481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4599, 186, 2, '鲤城区', '350502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4600, 186, 2, '丰泽区', '350503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4601, 186, 2, '洛江区', '350504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4602, 186, 2, '泉港区', '350505', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4603, 186, 2, '惠安县', '350521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4604, 186, 2, '安溪县', '350524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4605, 186, 2, '永春县', '350525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4606, 186, 2, '德化县', '350526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4607, 186, 2, '石狮市', '350581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4608, 186, 2, '晋江市', '350582', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4609, 186, 2, '南安市', '350583', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4610, 187, 2, '芗城区', '350602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4611, 187, 2, '龙文区', '350603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4612, 187, 2, '云霄县', '350622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4613, 187, 2, '漳浦县', '350623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4614, 187, 2, '诏安县', '350624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4615, 187, 2, '长泰县', '350625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4616, 187, 2, '东山县', '350626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4617, 187, 2, '南靖县', '350627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4618, 187, 2, '平和县', '350628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4619, 187, 2, '华安县', '350629', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4620, 187, 2, '龙海市', '350681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4621, 188, 2, '延平区', '350702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4622, 188, 2, '建阳区', '350703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4623, 188, 2, '顺昌县', '350721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4624, 188, 2, '浦城县', '350722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4625, 188, 2, '光泽县', '350723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4626, 188, 2, '松溪县', '350724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4627, 188, 2, '政和县', '350725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4628, 188, 2, '邵武市', '350781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4629, 188, 2, '武夷山市', '350782', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4630, 188, 2, '建瓯市', '350783', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4631, 189, 2, '新罗区', '350802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4632, 189, 2, '永定区', '350803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4633, 189, 2, '长汀县', '350821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4634, 189, 2, '上杭县', '350823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4635, 189, 2, '武平县', '350824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4636, 189, 2, '连城县', '350825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4637, 189, 2, '漳平市', '350881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4638, 190, 2, '蕉城区', '350902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4639, 190, 2, '霞浦县', '350921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4640, 190, 2, '古田县', '350922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4641, 190, 2, '屏南县', '350923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4642, 190, 2, '寿宁县', '350924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4643, 190, 2, '周宁县', '350925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4644, 190, 2, '柘荣县', '350926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4645, 190, 2, '福安市', '350981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4646, 190, 2, '福鼎市', '350982', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4647, 191, 2, '东湖区', '360102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4648, 191, 2, '西湖区', '360103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4649, 191, 2, '青云谱区', '360104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4650, 191, 2, '湾里区', '360105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4651, 191, 2, '青山湖区', '360111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4652, 191, 2, '新建区', '360112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4653, 191, 2, '南昌县', '360121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4654, 191, 2, '安义县', '360123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4655, 191, 2, '进贤县', '360124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4656, 192, 2, '昌江区', '360202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4657, 192, 2, '珠山区', '360203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4658, 192, 2, '浮梁县', '360222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4659, 192, 2, '乐平市', '360281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4660, 193, 2, '安源区', '360302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4661, 193, 2, '湘东区', '360313', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4662, 193, 2, '莲花县', '360321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4663, 193, 2, '上栗县', '360322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4664, 193, 2, '芦溪县', '360323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4665, 194, 2, '濂溪区', '360402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4666, 194, 2, '浔阳区', '360403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4667, 194, 2, '柴桑区', '360404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4668, 194, 2, '武宁县', '360423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4669, 194, 2, '修水县', '360424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4670, 194, 2, '永修县', '360425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4671, 194, 2, '德安县', '360426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4672, 194, 2, '都昌县', '360428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4673, 194, 2, '湖口县', '360429', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4674, 194, 2, '彭泽县', '360430', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4675, 194, 2, '瑞昌市', '360481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4676, 194, 2, '共青城市', '360482', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4677, 194, 2, '庐山市', '360483', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4678, 195, 2, '渝水区', '360502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4679, 195, 2, '分宜县', '360521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4680, 196, 2, '月湖区', '360602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4681, 196, 2, '余江区', '360603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4682, 196, 2, '贵溪市', '360681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4683, 197, 2, '章贡区', '360702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4684, 197, 2, '南康区', '360703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4685, 197, 2, '赣县区', '360704', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4686, 197, 2, '信丰县', '360722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4687, 197, 2, '大余县', '360723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4688, 197, 2, '上犹县', '360724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4689, 197, 2, '崇义县', '360725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4690, 197, 2, '安远县', '360726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4691, 197, 2, '龙南县', '360727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4692, 197, 2, '定南县', '360728', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4693, 197, 2, '全南县', '360729', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4694, 197, 2, '宁都县', '360730', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4695, 197, 2, '于都县', '360731', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4696, 197, 2, '兴国县', '360732', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4697, 197, 2, '会昌县', '360733', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4698, 197, 2, '寻乌县', '360734', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4699, 197, 2, '石城县', '360735', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4700, 197, 2, '瑞金市', '360781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4701, 198, 2, '吉州区', '360802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4702, 198, 2, '青原区', '360803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4703, 198, 2, '吉安县', '360821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4704, 198, 2, '吉水县', '360822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4705, 198, 2, '峡江县', '360823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4706, 198, 2, '新干县', '360824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4707, 198, 2, '永丰县', '360825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4708, 198, 2, '泰和县', '360826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4709, 198, 2, '遂川县', '360827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4710, 198, 2, '万安县', '360828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4711, 198, 2, '安福县', '360829', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4712, 198, 2, '永新县', '360830', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4713, 198, 2, '井冈山市', '360881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4714, 199, 2, '袁州区', '360902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4715, 199, 2, '奉新县', '360921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4716, 199, 2, '万载县', '360922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4717, 199, 2, '上高县', '360923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4718, 199, 2, '宜丰县', '360924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4719, 199, 2, '靖安县', '360925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4720, 199, 2, '铜鼓县', '360926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4721, 199, 2, '丰城市', '360981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4722, 199, 2, '樟树市', '360982', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4723, 199, 2, '高安市', '360983', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4724, 200, 2, '临川区', '361002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4725, 200, 2, '东乡区', '361003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4726, 200, 2, '南城县', '361021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4727, 200, 2, '黎川县', '361022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4728, 200, 2, '南丰县', '361023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4729, 200, 2, '崇仁县', '361024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4730, 200, 2, '乐安县', '361025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4731, 200, 2, '宜黄县', '361026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4732, 200, 2, '金溪县', '361027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4733, 200, 2, '资溪县', '361028', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4734, 200, 2, '广昌县', '361030', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4735, 201, 2, '信州区', '361102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4736, 201, 2, '广丰区', '361103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4737, 201, 2, '广信区', '361104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4738, 201, 2, '玉山县', '361123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4739, 201, 2, '铅山县', '361124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4740, 201, 2, '横峰县', '361125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4741, 201, 2, '弋阳县', '361126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4742, 201, 2, '余干县', '361127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4743, 201, 2, '鄱阳县', '361128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4744, 201, 2, '万年县', '361129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4745, 201, 2, '婺源县', '361130', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4746, 201, 2, '德兴市', '361181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4747, 202, 2, '历下区', '370102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4748, 202, 2, '市中区', '370103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4749, 202, 2, '槐荫区', '370104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4750, 202, 2, '天桥区', '370105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4751, 202, 2, '历城区', '370112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4752, 202, 2, '长清区', '370113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4753, 202, 2, '章丘区', '370114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4754, 202, 2, '济阳区', '370115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4755, 202, 2, '莱芜区', '370116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4756, 202, 2, '钢城区', '370117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4757, 202, 2, '平阴县', '370124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4758, 202, 2, '商河县', '370126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4759, 202, 2, '济南高新技术产业开发区', '370171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4760, 203, 2, '市南区', '370202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4761, 203, 2, '市北区', '370203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4762, 203, 2, '黄岛区', '370211', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4763, 203, 2, '崂山区', '370212', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4764, 203, 2, '李沧区', '370213', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4765, 203, 2, '城阳区', '370214', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4766, 203, 2, '即墨区', '370215', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4767, 203, 2, '青岛高新技术产业开发区', '370271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4768, 203, 2, '胶州市', '370281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4769, 203, 2, '平度市', '370283', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4770, 203, 2, '莱西市', '370285', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4771, 204, 2, '淄川区', '370302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4772, 204, 2, '张店区', '370303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4773, 204, 2, '博山区', '370304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4774, 204, 2, '临淄区', '370305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4775, 204, 2, '周村区', '370306', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4776, 204, 2, '桓台县', '370321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4777, 204, 2, '高青县', '370322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4778, 204, 2, '沂源县', '370323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4779, 205, 2, '市中区', '370402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4780, 205, 2, '薛城区', '370403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4781, 205, 2, '峄城区', '370404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4782, 205, 2, '台儿庄区', '370405', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4783, 205, 2, '山亭区', '370406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4784, 205, 2, '滕州市', '370481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4785, 206, 2, '东营区', '370502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4786, 206, 2, '河口区', '370503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4787, 206, 2, '垦利区', '370505', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4788, 206, 2, '利津县', '370522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4789, 206, 2, '广饶县', '370523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4790, 206, 2, '东营经济技术开发区', '370571', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4791, 206, 2, '东营港经济开发区', '370572', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4792, 207, 2, '芝罘区', '370602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4793, 207, 2, '福山区', '370611', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4794, 207, 2, '牟平区', '370612', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4795, 207, 2, '莱山区', '370613', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4796, 207, 2, '长岛县', '370634', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4797, 207, 2, '烟台高新技术产业开发区', '370671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4798, 207, 2, '烟台经济技术开发区', '370672', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4799, 207, 2, '龙口市', '370681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4800, 207, 2, '莱阳市', '370682', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4801, 207, 2, '莱州市', '370683', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4802, 207, 2, '蓬莱市', '370684', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4803, 207, 2, '招远市', '370685', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4804, 207, 2, '栖霞市', '370686', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4805, 207, 2, '海阳市', '370687', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4806, 208, 2, '潍城区', '370702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4807, 208, 2, '寒亭区', '370703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4808, 208, 2, '坊子区', '370704', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4809, 208, 2, '奎文区', '370705', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4810, 208, 2, '临朐县', '370724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4811, 208, 2, '昌乐县', '370725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4812, 208, 2, '潍坊滨海经济技术开发区', '370772', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4813, 208, 2, '青州市', '370781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4814, 208, 2, '诸城市', '370782', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4815, 208, 2, '寿光市', '370783', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4816, 208, 2, '安丘市', '370784', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4817, 208, 2, '高密市', '370785', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4818, 208, 2, '昌邑市', '370786', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4819, 209, 2, '任城区', '370811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4820, 209, 2, '兖州区', '370812', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4821, 209, 2, '微山县', '370826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4822, 209, 2, '鱼台县', '370827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4823, 209, 2, '金乡县', '370828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4824, 209, 2, '嘉祥县', '370829', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4825, 209, 2, '汶上县', '370830', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4826, 209, 2, '泗水县', '370831', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4827, 209, 2, '梁山县', '370832', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4828, 209, 2, '济宁高新技术产业开发区', '370871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4829, 209, 2, '曲阜市', '370881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4830, 209, 2, '邹城市', '370883', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4831, 210, 2, '泰山区', '370902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4832, 210, 2, '岱岳区', '370911', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4833, 210, 2, '宁阳县', '370921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4834, 210, 2, '东平县', '370923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4835, 210, 2, '新泰市', '370982', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4836, 210, 2, '肥城市', '370983', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4837, 211, 2, '环翠区', '371002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4838, 211, 2, '文登区', '371003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4839, 211, 2, '威海火炬高技术产业开发区', '371071', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4840, 211, 2, '威海经济技术开发区', '371072', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4841, 211, 2, '威海临港经济技术开发区', '371073', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4842, 211, 2, '荣成市', '371082', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4843, 211, 2, '乳山市', '371083', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4844, 212, 2, '东港区', '371102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4845, 212, 2, '岚山区', '371103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4846, 212, 2, '五莲县', '371121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4847, 212, 2, '莒县', '371122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4848, 212, 2, '日照经济技术开发区', '371171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4849, 213, 2, '兰山区', '371302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4850, 213, 2, '罗庄区', '371311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4851, 213, 2, '河东区', '371312', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4852, 213, 2, '沂南县', '371321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4853, 213, 2, '郯城县', '371322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4854, 213, 2, '沂水县', '371323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4855, 213, 2, '兰陵县', '371324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4856, 213, 2, '费县', '371325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4857, 213, 2, '平邑县', '371326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4858, 213, 2, '莒南县', '371327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4859, 213, 2, '蒙阴县', '371328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4860, 213, 2, '临沭县', '371329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4861, 213, 2, '临沂高新技术产业开发区', '371371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4862, 213, 2, '临沂经济技术开发区', '371372', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4863, 213, 2, '临沂临港经济开发区', '371373', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4864, 214, 2, '德城区', '371402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4865, 214, 2, '陵城区', '371403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4866, 214, 2, '宁津县', '371422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4867, 214, 2, '庆云县', '371423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4868, 214, 2, '临邑县', '371424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4869, 214, 2, '齐河县', '371425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4870, 214, 2, '平原县', '371426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4871, 214, 2, '夏津县', '371427', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4872, 214, 2, '武城县', '371428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4873, 214, 2, '德州经济技术开发区', '371471', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4874, 214, 2, '德州运河经济开发区', '371472', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4875, 214, 2, '乐陵市', '371481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4876, 214, 2, '禹城市', '371482', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4877, 215, 2, '东昌府区', '371502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4878, 215, 2, '茌平区', '371503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4879, 215, 2, '阳谷县', '371521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4880, 215, 2, '莘县', '371522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4881, 215, 2, '东阿县', '371524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4882, 215, 2, '冠县', '371525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4883, 215, 2, '高唐县', '371526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4884, 215, 2, '临清市', '371581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4885, 216, 2, '滨城区', '371602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4886, 216, 2, '沾化区', '371603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4887, 216, 2, '惠民县', '371621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4888, 216, 2, '阳信县', '371622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4889, 216, 2, '无棣县', '371623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4890, 216, 2, '博兴县', '371625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4891, 216, 2, '邹平市', '371681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4892, 217, 2, '牡丹区', '371702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4893, 217, 2, '定陶区', '371703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4894, 217, 2, '曹县', '371721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4895, 217, 2, '单县', '371722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4896, 217, 2, '成武县', '371723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4897, 217, 2, '巨野县', '371724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4898, 217, 2, '郓城县', '371725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4899, 217, 2, '鄄城县', '371726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4900, 217, 2, '东明县', '371728', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4901, 217, 2, '菏泽经济技术开发区', '371771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4902, 217, 2, '菏泽高新技术开发区', '371772', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4903, 218, 2, '中原区', '410102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4904, 218, 2, '二七区', '410103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4905, 218, 2, '管城回族区', '410104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4906, 218, 2, '金水区', '410105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4907, 218, 2, '上街区', '410106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4908, 218, 2, '惠济区', '410108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4909, 218, 2, '中牟县', '410122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4910, 218, 2, '郑州经济技术开发区', '410171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4911, 218, 2, '郑州高新技术产业开发区', '410172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4912, 218, 2, '郑州航空港经济综合实验区', '410173', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4913, 218, 2, '巩义市', '410181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4914, 218, 2, '荥阳市', '410182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4915, 218, 2, '新密市', '410183', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4916, 218, 2, '新郑市', '410184', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4917, 218, 2, '登封市', '410185', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4918, 219, 2, '龙亭区', '410202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4919, 219, 2, '顺河回族区', '410203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4920, 219, 2, '鼓楼区', '410204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4921, 219, 2, '禹王台区', '410205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4922, 219, 2, '祥符区', '410212', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4923, 219, 2, '杞县', '410221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4924, 219, 2, '通许县', '410222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4925, 219, 2, '尉氏县', '410223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4926, 219, 2, '兰考县', '410225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4927, 220, 2, '老城区', '410302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4928, 220, 2, '西工区', '410303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4929, 220, 2, '瀍河回族区', '410304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4930, 220, 2, '涧西区', '410305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4931, 220, 2, '吉利区', '410306', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4932, 220, 2, '洛龙区', '410311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4933, 220, 2, '孟津县', '410322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4934, 220, 2, '新安县', '410323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4935, 220, 2, '栾川县', '410324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4936, 220, 2, '嵩县', '410325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4937, 220, 2, '汝阳县', '410326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4938, 220, 2, '宜阳县', '410327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4939, 220, 2, '洛宁县', '410328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4940, 220, 2, '伊川县', '410329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4941, 220, 2, '洛阳高新技术产业开发区', '410371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4942, 220, 2, '偃师市', '410381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4943, 221, 2, '新华区', '410402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4944, 221, 2, '卫东区', '410403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4945, 221, 2, '石龙区', '410404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4946, 221, 2, '湛河区', '410411', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4947, 221, 2, '宝丰县', '410421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4948, 221, 2, '叶县', '410422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4949, 221, 2, '鲁山县', '410423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4950, 221, 2, '郏县', '410425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4951, 221, 2, '平顶山高新技术产业开发区', '410471', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4952, 221, 2, '平顶山市城乡一体化示范区', '410472', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4953, 221, 2, '舞钢市', '410481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4954, 221, 2, '汝州市', '410482', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4955, 222, 2, '文峰区', '410502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4956, 222, 2, '北关区', '410503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4957, 222, 2, '殷都区', '410505', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4958, 222, 2, '龙安区', '410506', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4959, 222, 2, '安阳县', '410522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4960, 222, 2, '汤阴县', '410523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4961, 222, 2, '滑县', '410526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4962, 222, 2, '内黄县', '410527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4963, 222, 2, '安阳高新技术产业开发区', '410571', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4964, 222, 2, '林州市', '410581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4965, 223, 2, '鹤山区', '410602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4966, 223, 2, '山城区', '410603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4967, 223, 2, '淇滨区', '410611', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4968, 223, 2, '浚县', '410621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4969, 223, 2, '淇县', '410622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4970, 223, 2, '鹤壁经济技术开发区', '410671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4971, 224, 2, '红旗区', '410702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4972, 224, 2, '卫滨区', '410703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4973, 224, 2, '凤泉区', '410704', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4974, 224, 2, '牧野区', '410711', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4975, 224, 2, '新乡县', '410721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4976, 224, 2, '获嘉县', '410724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4977, 224, 2, '原阳县', '410725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4978, 224, 2, '延津县', '410726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4979, 224, 2, '封丘县', '410727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4980, 224, 2, '新乡高新技术产业开发区', '410771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4981, 224, 2, '新乡经济技术开发区', '410772', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4982, 224, 2, '新乡市平原城乡一体化示范区', '410773', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4983, 224, 2, '卫辉市', '410781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4984, 224, 2, '辉县市', '410782', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4985, 224, 2, '长垣市', '410783', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4986, 225, 2, '解放区', '410802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4987, 225, 2, '中站区', '410803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4988, 225, 2, '马村区', '410804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4989, 225, 2, '山阳区', '410811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4990, 225, 2, '修武县', '410821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4991, 225, 2, '博爱县', '410822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4992, 225, 2, '武陟县', '410823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4993, 225, 2, '温县', '410825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4994, 225, 2, '焦作城乡一体化示范区', '410871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4995, 225, 2, '沁阳市', '410882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4996, 225, 2, '孟州市', '410883', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4997, 226, 2, '华龙区', '410902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4998, 226, 2, '清丰县', '410922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (4999, 226, 2, '南乐县', '410923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5000, 226, 2, '范县', '410926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5001, 226, 2, '台前县', '410927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5002, 226, 2, '濮阳县', '410928', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5003, 226, 2, '河南濮阳工业园区', '410971', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5004, 226, 2, '濮阳经济技术开发区', '410972', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5005, 227, 2, '魏都区', '411002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5006, 227, 2, '建安区', '411003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5007, 227, 2, '鄢陵县', '411024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5008, 227, 2, '襄城县', '411025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5009, 227, 2, '许昌经济技术开发区', '411071', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5010, 227, 2, '禹州市', '411081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5011, 227, 2, '长葛市', '411082', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5012, 228, 2, '源汇区', '411102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5013, 228, 2, '郾城区', '411103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5014, 228, 2, '召陵区', '411104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5015, 228, 2, '舞阳县', '411121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5016, 228, 2, '临颍县', '411122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5017, 228, 2, '漯河经济技术开发区', '411171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5018, 229, 2, '湖滨区', '411202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5019, 229, 2, '陕州区', '411203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5020, 229, 2, '渑池县', '411221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5021, 229, 2, '卢氏县', '411224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5022, 229, 2, '河南三门峡经济开发区', '411271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5023, 229, 2, '义马市', '411281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5024, 229, 2, '灵宝市', '411282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5025, 230, 2, '宛城区', '411302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5026, 230, 2, '卧龙区', '411303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5027, 230, 2, '南召县', '411321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5028, 230, 2, '方城县', '411322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5029, 230, 2, '西峡县', '411323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5030, 230, 2, '镇平县', '411324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5031, 230, 2, '内乡县', '411325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5032, 230, 2, '淅川县', '411326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5033, 230, 2, '社旗县', '411327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5034, 230, 2, '唐河县', '411328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5035, 230, 2, '新野县', '411329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5036, 230, 2, '桐柏县', '411330', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5037, 230, 2, '南阳高新技术产业开发区', '411371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5038, 230, 2, '南阳市城乡一体化示范区', '411372', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5039, 230, 2, '邓州市', '411381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5040, 231, 2, '梁园区', '411402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5041, 231, 2, '睢阳区', '411403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5042, 231, 2, '民权县', '411421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5043, 231, 2, '睢县', '411422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5044, 231, 2, '宁陵县', '411423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5045, 231, 2, '柘城县', '411424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5046, 231, 2, '虞城县', '411425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5047, 231, 2, '夏邑县', '411426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5048, 231, 2, '豫东综合物流产业聚集区', '411471', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5049, 231, 2, '河南商丘经济开发区', '411472', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5050, 231, 2, '永城市', '411481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5051, 232, 2, '浉河区', '411502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5052, 232, 2, '平桥区', '411503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5053, 232, 2, '罗山县', '411521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5054, 232, 2, '光山县', '411522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5055, 232, 2, '新县', '411523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5056, 232, 2, '商城县', '411524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5057, 232, 2, '固始县', '411525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5058, 232, 2, '潢川县', '411526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5059, 232, 2, '淮滨县', '411527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5060, 232, 2, '息县', '411528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5061, 232, 2, '信阳高新技术产业开发区', '411571', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5062, 233, 2, '川汇区', '411602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5063, 233, 2, '淮阳区', '411603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5064, 233, 2, '扶沟县', '411621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5065, 233, 2, '西华县', '411622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5066, 233, 2, '商水县', '411623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5067, 233, 2, '沈丘县', '411624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5068, 233, 2, '郸城县', '411625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5069, 233, 2, '太康县', '411627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5070, 233, 2, '鹿邑县', '411628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5071, 233, 2, '河南周口经济开发区', '411671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5072, 233, 2, '项城市', '411681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5073, 234, 2, '驿城区', '411702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5074, 234, 2, '西平县', '411721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5075, 234, 2, '上蔡县', '411722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5076, 234, 2, '平舆县', '411723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5077, 234, 2, '正阳县', '411724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5078, 234, 2, '确山县', '411725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5079, 234, 2, '泌阳县', '411726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5080, 234, 2, '汝南县', '411727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5081, 234, 2, '遂平县', '411728', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5082, 234, 2, '新蔡县', '411729', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5083, 234, 2, '河南驻马店经济开发区', '411771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5084, 235, 2, '济源市', '419001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5085, 236, 2, '江岸区', '420102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5086, 236, 2, '江汉区', '420103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5087, 236, 2, '硚口区', '420104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5088, 236, 2, '汉阳区', '420105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5089, 236, 2, '武昌区', '420106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5090, 236, 2, '青山区', '420107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5091, 236, 2, '洪山区', '420111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5092, 236, 2, '东西湖区', '420112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5093, 236, 2, '汉南区', '420113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5094, 236, 2, '蔡甸区', '420114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5095, 236, 2, '江夏区', '420115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5096, 236, 2, '黄陂区', '420116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5097, 236, 2, '新洲区', '420117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5098, 237, 2, '黄石港区', '420202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5099, 237, 2, '西塞山区', '420203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5100, 237, 2, '下陆区', '420204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5101, 237, 2, '铁山区', '420205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5102, 237, 2, '阳新县', '420222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5103, 237, 2, '大冶市', '420281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5104, 238, 2, '茅箭区', '420302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5105, 238, 2, '张湾区', '420303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5106, 238, 2, '郧阳区', '420304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5107, 238, 2, '郧西县', '420322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5108, 238, 2, '竹山县', '420323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5109, 238, 2, '竹溪县', '420324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5110, 238, 2, '房县', '420325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5111, 238, 2, '丹江口市', '420381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5112, 239, 2, '西陵区', '420502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5113, 239, 2, '伍家岗区', '420503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5114, 239, 2, '点军区', '420504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5115, 239, 2, '猇亭区', '420505', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5116, 239, 2, '夷陵区', '420506', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5117, 239, 2, '远安县', '420525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5118, 239, 2, '兴山县', '420526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5119, 239, 2, '秭归县', '420527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5120, 239, 2, '长阳土家族自治县', '420528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5121, 239, 2, '五峰土家族自治县', '420529', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5122, 239, 2, '宜都市', '420581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5123, 239, 2, '当阳市', '420582', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5124, 239, 2, '枝江市', '420583', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5125, 240, 2, '襄城区', '420602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5126, 240, 2, '樊城区', '420606', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5127, 240, 2, '襄州区', '420607', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5128, 240, 2, '南漳县', '420624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5129, 240, 2, '谷城县', '420625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5130, 240, 2, '保康县', '420626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5131, 240, 2, '老河口市', '420682', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5132, 240, 2, '枣阳市', '420683', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5133, 240, 2, '宜城市', '420684', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5134, 241, 2, '梁子湖区', '420702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5135, 241, 2, '华容区', '420703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5136, 241, 2, '鄂城区', '420704', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5137, 242, 2, '东宝区', '420802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5138, 242, 2, '掇刀区', '420804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5139, 242, 2, '沙洋县', '420822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5140, 242, 2, '钟祥市', '420881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5141, 242, 2, '京山市', '420882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5142, 243, 2, '孝南区', '420902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5143, 243, 2, '孝昌县', '420921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5144, 243, 2, '大悟县', '420922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5145, 243, 2, '云梦县', '420923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5146, 243, 2, '应城市', '420981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5147, 243, 2, '安陆市', '420982', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5148, 243, 2, '汉川市', '420984', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5149, 244, 2, '沙市区', '421002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5150, 244, 2, '荆州区', '421003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5151, 244, 2, '公安县', '421022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5152, 244, 2, '监利县', '421023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5153, 244, 2, '江陵县', '421024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5154, 244, 2, '荆州经济技术开发区', '421071', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5155, 244, 2, '石首市', '421081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5156, 244, 2, '洪湖市', '421083', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5157, 244, 2, '松滋市', '421087', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5158, 245, 2, '黄州区', '421102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5159, 245, 2, '团风县', '421121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5160, 245, 2, '红安县', '421122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5161, 245, 2, '罗田县', '421123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5162, 245, 2, '英山县', '421124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5163, 245, 2, '浠水县', '421125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5164, 245, 2, '蕲春县', '421126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5165, 245, 2, '黄梅县', '421127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5166, 245, 2, '龙感湖管理区', '421171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5167, 245, 2, '麻城市', '421181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5168, 245, 2, '武穴市', '421182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5169, 246, 2, '咸安区', '421202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5170, 246, 2, '嘉鱼县', '421221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5171, 246, 2, '通城县', '421222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5172, 246, 2, '崇阳县', '421223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5173, 246, 2, '通山县', '421224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5174, 246, 2, '赤壁市', '421281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5175, 247, 2, '曾都区', '421303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5176, 247, 2, '随县', '421321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5177, 247, 2, '广水市', '421381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5178, 248, 2, '恩施市', '422801', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5179, 248, 2, '利川市', '422802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5180, 248, 2, '建始县', '422822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5181, 248, 2, '巴东县', '422823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5182, 248, 2, '宣恩县', '422825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5183, 248, 2, '咸丰县', '422826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5184, 248, 2, '来凤县', '422827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5185, 248, 2, '鹤峰县', '422828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5186, 249, 2, '仙桃市', '429004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5187, 249, 2, '潜江市', '429005', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5188, 249, 2, '天门市', '429006', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5189, 249, 2, '神农架林区', '429021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5190, 250, 2, '芙蓉区', '430102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5191, 250, 2, '天心区', '430103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5192, 250, 2, '岳麓区', '430104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5193, 250, 2, '开福区', '430105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5194, 250, 2, '雨花区', '430111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5195, 250, 2, '望城区', '430112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5196, 250, 2, '长沙县', '430121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5197, 250, 2, '浏阳市', '430181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5198, 250, 2, '宁乡市', '430182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5199, 251, 2, '荷塘区', '430202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5200, 251, 2, '芦淞区', '430203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5201, 251, 2, '石峰区', '430204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5202, 251, 2, '天元区', '430211', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5203, 251, 2, '渌口区', '430212', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5204, 251, 2, '攸县', '430223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5205, 251, 2, '茶陵县', '430224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5206, 251, 2, '炎陵县', '430225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5207, 251, 2, '云龙示范区', '430271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5208, 251, 2, '醴陵市', '430281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5209, 252, 2, '雨湖区', '430302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5210, 252, 2, '岳塘区', '430304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5211, 252, 2, '湘潭县', '430321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5212, 252, 2, '湖南湘潭高新技术产业园区', '430371', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5213, 252, 2, '湘潭昭山示范区', '430372', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5214, 252, 2, '湘潭九华示范区', '430373', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5215, 252, 2, '湘乡市', '430381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5216, 252, 2, '韶山市', '430382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5217, 253, 2, '珠晖区', '430405', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5218, 253, 2, '雁峰区', '430406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5219, 253, 2, '石鼓区', '430407', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5220, 253, 2, '蒸湘区', '430408', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5221, 253, 2, '南岳区', '430412', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5222, 253, 2, '衡阳县', '430421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5223, 253, 2, '衡南县', '430422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5224, 253, 2, '衡山县', '430423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5225, 253, 2, '衡东县', '430424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5226, 253, 2, '祁东县', '430426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5227, 253, 2, '衡阳综合保税区', '430471', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5228, 253, 2, '湖南衡阳高新技术产业园区', '430472', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5229, 253, 2, '湖南衡阳松木经济开发区', '430473', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5230, 253, 2, '耒阳市', '430481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5231, 253, 2, '常宁市', '430482', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5232, 254, 2, '双清区', '430502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5233, 254, 2, '大祥区', '430503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5234, 254, 2, '北塔区', '430511', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5235, 254, 2, '新邵县', '430522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5236, 254, 2, '邵阳县', '430523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5237, 254, 2, '隆回县', '430524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5238, 254, 2, '洞口县', '430525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5239, 254, 2, '绥宁县', '430527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5240, 254, 2, '新宁县', '430528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5241, 254, 2, '城步苗族自治县', '430529', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5242, 254, 2, '武冈市', '430581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5243, 254, 2, '邵东市', '430582', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5244, 255, 2, '岳阳楼区', '430602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5245, 255, 2, '云溪区', '430603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5246, 255, 2, '君山区', '430611', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5247, 255, 2, '岳阳县', '430621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5248, 255, 2, '华容县', '430623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5249, 255, 2, '湘阴县', '430624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5250, 255, 2, '平江县', '430626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5251, 255, 2, '岳阳市屈原管理区', '430671', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5252, 255, 2, '汨罗市', '430681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5253, 255, 2, '临湘市', '430682', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5254, 256, 2, '武陵区', '430702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5255, 256, 2, '鼎城区', '430703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5256, 256, 2, '安乡县', '430721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5257, 256, 2, '汉寿县', '430722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5258, 256, 2, '澧县', '430723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5259, 256, 2, '临澧县', '430724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5260, 256, 2, '桃源县', '430725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5261, 256, 2, '石门县', '430726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5262, 256, 2, '常德市西洞庭管理区', '430771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5263, 256, 2, '津市市', '430781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5264, 257, 2, '永定区', '430802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5265, 257, 2, '武陵源区', '430811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5266, 257, 2, '慈利县', '430821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5267, 257, 2, '桑植县', '430822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5268, 258, 2, '资阳区', '430902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5269, 258, 2, '赫山区', '430903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5270, 258, 2, '南县', '430921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5271, 258, 2, '桃江县', '430922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5272, 258, 2, '安化县', '430923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5273, 258, 2, '益阳市大通湖管理区', '430971', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5274, 258, 2, '湖南益阳高新技术产业园区', '430972', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5275, 258, 2, '沅江市', '430981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5276, 259, 2, '北湖区', '431002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5277, 259, 2, '苏仙区', '431003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5278, 259, 2, '桂阳县', '431021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5279, 259, 2, '宜章县', '431022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5280, 259, 2, '永兴县', '431023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5281, 259, 2, '嘉禾县', '431024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5282, 259, 2, '临武县', '431025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5283, 259, 2, '汝城县', '431026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5284, 259, 2, '桂东县', '431027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5285, 259, 2, '安仁县', '431028', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5286, 259, 2, '资兴市', '431081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5287, 260, 2, '零陵区', '431102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5288, 260, 2, '冷水滩区', '431103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5289, 260, 2, '祁阳县', '431121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5290, 260, 2, '东安县', '431122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5291, 260, 2, '双牌县', '431123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5292, 260, 2, '道县', '431124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5293, 260, 2, '江永县', '431125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5294, 260, 2, '宁远县', '431126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5295, 260, 2, '蓝山县', '431127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5296, 260, 2, '新田县', '431128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5297, 260, 2, '江华瑶族自治县', '431129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5298, 260, 2, '永州经济技术开发区', '431171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5299, 260, 2, '永州市金洞管理区', '431172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5300, 260, 2, '永州市回龙圩管理区', '431173', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5301, 261, 2, '鹤城区', '431202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5302, 261, 2, '中方县', '431221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5303, 261, 2, '沅陵县', '431222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5304, 261, 2, '辰溪县', '431223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5305, 261, 2, '溆浦县', '431224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5306, 261, 2, '会同县', '431225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5307, 261, 2, '麻阳苗族自治县', '431226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5308, 261, 2, '新晃侗族自治县', '431227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5309, 261, 2, '芷江侗族自治县', '431228', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5310, 261, 2, '靖州苗族侗族自治县', '431229', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5311, 261, 2, '通道侗族自治县', '431230', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5312, 261, 2, '怀化市洪江管理区', '431271', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5313, 261, 2, '洪江市', '431281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5314, 262, 2, '娄星区', '431302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5315, 262, 2, '双峰县', '431321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5316, 262, 2, '新化县', '431322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5317, 262, 2, '冷水江市', '431381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5318, 262, 2, '涟源市', '431382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5319, 263, 2, '吉首市', '433101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5320, 263, 2, '泸溪县', '433122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5321, 263, 2, '凤凰县', '433123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5322, 263, 2, '花垣县', '433124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5323, 263, 2, '保靖县', '433125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5324, 263, 2, '古丈县', '433126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5325, 263, 2, '永顺县', '433127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5326, 263, 2, '龙山县', '433130', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5327, 263, 2, '湖南永顺经济开发区', '433173', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5328, 264, 2, '荔湾区', '440103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5329, 264, 2, '越秀区', '440104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5330, 264, 2, '海珠区', '440105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5331, 264, 2, '天河区', '440106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5332, 264, 2, '白云区', '440111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5333, 264, 2, '黄埔区', '440112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5334, 264, 2, '番禺区', '440113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5335, 264, 2, '花都区', '440114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5336, 264, 2, '南沙区', '440115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5337, 264, 2, '从化区', '440117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5338, 264, 2, '增城区', '440118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5339, 265, 2, '武江区', '440203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5340, 265, 2, '浈江区', '440204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5341, 265, 2, '曲江区', '440205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5342, 265, 2, '始兴县', '440222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5343, 265, 2, '仁化县', '440224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5344, 265, 2, '翁源县', '440229', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5345, 265, 2, '乳源瑶族自治县', '440232', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5346, 265, 2, '新丰县', '440233', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5347, 265, 2, '乐昌市', '440281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5348, 265, 2, '南雄市', '440282', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5349, 266, 2, '罗湖区', '440303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5350, 266, 2, '福田区', '440304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5351, 266, 2, '南山区', '440305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5352, 266, 2, '宝安区', '440306', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5353, 266, 2, '龙岗区', '440307', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5354, 266, 2, '盐田区', '440308', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5355, 266, 2, '龙华区', '440309', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5356, 266, 2, '坪山区', '440310', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5357, 266, 2, '光明区', '440311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5358, 267, 2, '香洲区', '440402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5359, 267, 2, '斗门区', '440403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5360, 267, 2, '金湾区', '440404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5361, 268, 2, '龙湖区', '440507', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5362, 268, 2, '金平区', '440511', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5363, 268, 2, '濠江区', '440512', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5364, 268, 2, '潮阳区', '440513', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5365, 268, 2, '潮南区', '440514', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5366, 268, 2, '澄海区', '440515', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5367, 268, 2, '南澳县', '440523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5368, 269, 2, '禅城区', '440604', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5369, 269, 2, '南海区', '440605', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5370, 269, 2, '顺德区', '440606', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5371, 269, 2, '三水区', '440607', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5372, 269, 2, '高明区', '440608', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5373, 270, 2, '蓬江区', '440703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5374, 270, 2, '江海区', '440704', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5375, 270, 2, '新会区', '440705', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5376, 270, 2, '台山市', '440781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5377, 270, 2, '开平市', '440783', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5378, 270, 2, '鹤山市', '440784', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5379, 270, 2, '恩平市', '440785', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5380, 271, 2, '赤坎区', '440802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5381, 271, 2, '霞山区', '440803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5382, 271, 2, '坡头区', '440804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5383, 271, 2, '麻章区', '440811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5384, 271, 2, '遂溪县', '440823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5385, 271, 2, '徐闻县', '440825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5386, 271, 2, '廉江市', '440881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5387, 271, 2, '雷州市', '440882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5388, 271, 2, '吴川市', '440883', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5389, 272, 2, '茂南区', '440902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5390, 272, 2, '电白区', '440904', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5391, 272, 2, '高州市', '440981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5392, 272, 2, '化州市', '440982', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5393, 272, 2, '信宜市', '440983', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5394, 273, 2, '端州区', '441202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5395, 273, 2, '鼎湖区', '441203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5396, 273, 2, '高要区', '441204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5397, 273, 2, '广宁县', '441223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5398, 273, 2, '怀集县', '441224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5399, 273, 2, '封开县', '441225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5400, 273, 2, '德庆县', '441226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5401, 273, 2, '四会市', '441284', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5402, 274, 2, '惠城区', '441302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5403, 274, 2, '惠阳区', '441303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5404, 274, 2, '博罗县', '441322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5405, 274, 2, '惠东县', '441323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5406, 274, 2, '龙门县', '441324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5407, 275, 2, '梅江区', '441402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5408, 275, 2, '梅县区', '441403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5409, 275, 2, '大埔县', '441422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5410, 275, 2, '丰顺县', '441423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5411, 275, 2, '五华县', '441424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5412, 275, 2, '平远县', '441426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5413, 275, 2, '蕉岭县', '441427', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5414, 275, 2, '兴宁市', '441481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5415, 276, 2, '城区', '441502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5416, 276, 2, '海丰县', '441521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5417, 276, 2, '陆河县', '441523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5418, 276, 2, '陆丰市', '441581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5419, 277, 2, '源城区', '441602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5420, 277, 2, '紫金县', '441621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5421, 277, 2, '龙川县', '441622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5422, 277, 2, '连平县', '441623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5423, 277, 2, '和平县', '441624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5424, 277, 2, '东源县', '441625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5425, 278, 2, '江城区', '441702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5426, 278, 2, '阳东区', '441704', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5427, 278, 2, '阳西县', '441721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5428, 278, 2, '阳春市', '441781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5429, 279, 2, '清城区', '441802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5430, 279, 2, '清新区', '441803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5431, 279, 2, '佛冈县', '441821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5432, 279, 2, '阳山县', '441823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5433, 279, 2, '连山壮族瑶族自治县', '441825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5434, 279, 2, '连南瑶族自治县', '441826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5435, 279, 2, '英德市', '441881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5436, 279, 2, '连州市', '441882', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5437, 280, 2, '东城街道', '441900003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5438, 280, 2, '南城街道', '441900004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5439, 280, 2, '万江街道', '441900005', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5440, 280, 2, '莞城街道', '441900006', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5441, 280, 2, '石碣镇', '441900101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5442, 280, 2, '石龙镇', '441900102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5443, 280, 2, '茶山镇', '441900103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5444, 280, 2, '石排镇', '441900104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5445, 280, 2, '企石镇', '441900105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5446, 280, 2, '横沥镇', '441900106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5447, 280, 2, '桥头镇', '441900107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5448, 280, 2, '谢岗镇', '441900108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5449, 280, 2, '东坑镇', '441900109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5450, 280, 2, '常平镇', '44190011', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5451, 280, 2, '寮步镇', '441900111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5452, 280, 2, '樟木头镇', '441900112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5453, 280, 2, '大朗镇', '441900113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5454, 280, 2, '黄江镇', '441900114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5455, 280, 2, '清溪镇', '441900115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5456, 280, 2, '塘厦镇', '441900116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5457, 280, 2, '凤岗镇', '441900117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5458, 280, 2, '大岭山镇', '441900118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5459, 280, 2, '长安镇', '441900119', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5460, 280, 2, '虎门镇', '441900121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5461, 280, 2, '厚街镇', '441900122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5462, 280, 2, '沙田镇', '441900123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5463, 280, 2, '道滘镇', '441900124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5464, 280, 2, '洪梅镇', '441900125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5465, 280, 2, '麻涌镇', '441900126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5466, 280, 2, '望牛墩镇', '441900127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5467, 280, 2, '中堂镇', '441900128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5468, 280, 2, '高埗镇', '441900129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5469, 280, 2, '松山湖', '441900401', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5470, 280, 2, '东莞港', '441900402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5471, 280, 2, '东莞生态园', '441900403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5472, 281, 2, '石岐街道', '442000001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5473, 281, 2, '东区街道', '442000002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5474, 281, 2, '中山港街道', '442000003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5475, 281, 2, '西区街道', '442000004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5476, 281, 2, '南区街道', '442000005', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5477, 281, 2, '五桂山街道', '442000006', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5478, 281, 2, '小榄镇', '4420001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5479, 281, 2, '黄圃镇', '442000101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5480, 281, 2, '民众镇', '442000102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5481, 281, 2, '东凤镇', '442000103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5482, 281, 2, '东升镇', '442000104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5483, 281, 2, '古镇镇', '442000105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5484, 281, 2, '沙溪镇', '442000106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5485, 281, 2, '坦洲镇', '442000107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5486, 281, 2, '港口镇', '442000108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5487, 281, 2, '三角镇', '442000109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5488, 281, 2, '横栏镇', '44200011', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5489, 281, 2, '南头镇', '442000111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5490, 281, 2, '阜沙镇', '442000112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5491, 281, 2, '南朗镇', '442000113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5492, 281, 2, '三乡镇', '442000114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5493, 281, 2, '板芙镇', '442000115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5494, 281, 2, '大涌镇', '442000116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5495, 281, 2, '神湾镇', '442000117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5496, 282, 2, '湘桥区', '445102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5497, 282, 2, '潮安区', '445103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5498, 282, 2, '饶平县', '445122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5499, 283, 2, '榕城区', '445202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5500, 283, 2, '揭东区', '445203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5501, 283, 2, '揭西县', '445222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5502, 283, 2, '惠来县', '445224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5503, 283, 2, '普宁市', '445281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5504, 284, 2, '云城区', '445302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5505, 284, 2, '云安区', '445303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5506, 284, 2, '新兴县', '445321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5507, 284, 2, '郁南县', '445322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5508, 284, 2, '罗定市', '445381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5509, 285, 2, '兴宁区', '450102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5510, 285, 2, '青秀区', '450103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5511, 285, 2, '江南区', '450105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5512, 285, 2, '西乡塘区', '450107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5513, 285, 2, '良庆区', '450108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5514, 285, 2, '邕宁区', '450109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5515, 285, 2, '武鸣区', '450110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5516, 285, 2, '隆安县', '450123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5517, 285, 2, '马山县', '450124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5518, 285, 2, '上林县', '450125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5519, 285, 2, '宾阳县', '450126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5520, 285, 2, '横县', '450127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5521, 286, 2, '城中区', '450202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5522, 286, 2, '鱼峰区', '450203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5523, 286, 2, '柳南区', '450204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5524, 286, 2, '柳北区', '450205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5525, 286, 2, '柳江区', '450206', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5526, 286, 2, '柳城县', '450222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5527, 286, 2, '鹿寨县', '450223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5528, 286, 2, '融安县', '450224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5529, 286, 2, '融水苗族自治县', '450225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5530, 286, 2, '三江侗族自治县', '450226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5531, 287, 2, '秀峰区', '450302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5532, 287, 2, '叠彩区', '450303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5533, 287, 2, '象山区', '450304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5534, 287, 2, '七星区', '450305', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5535, 287, 2, '雁山区', '450311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5536, 287, 2, '临桂区', '450312', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5537, 287, 2, '阳朔县', '450321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5538, 287, 2, '灵川县', '450323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5539, 287, 2, '全州县', '450324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5540, 287, 2, '兴安县', '450325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5541, 287, 2, '永福县', '450326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5542, 287, 2, '灌阳县', '450327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5543, 287, 2, '龙胜各族自治县', '450328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5544, 287, 2, '资源县', '450329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5545, 287, 2, '平乐县', '450330', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5546, 287, 2, '恭城瑶族自治县', '450332', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5547, 287, 2, '荔浦市', '450381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5548, 288, 2, '万秀区', '450403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5549, 288, 2, '长洲区', '450405', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5550, 288, 2, '龙圩区', '450406', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5551, 288, 2, '苍梧县', '450421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5552, 288, 2, '藤县', '450422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5553, 288, 2, '蒙山县', '450423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5554, 288, 2, '岑溪市', '450481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5555, 289, 2, '海城区', '450502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5556, 289, 2, '银海区', '450503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5557, 289, 2, '铁山港区', '450512', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5558, 289, 2, '合浦县', '450521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5559, 290, 2, '港口区', '450602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5560, 290, 2, '防城区', '450603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5561, 290, 2, '上思县', '450621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5562, 290, 2, '东兴市', '450681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5563, 291, 2, '钦南区', '450702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5564, 291, 2, '钦北区', '450703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5565, 291, 2, '灵山县', '450721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5566, 291, 2, '浦北县', '450722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5567, 292, 2, '港北区', '450802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5568, 292, 2, '港南区', '450803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5569, 292, 2, '覃塘区', '450804', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5570, 292, 2, '平南县', '450821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5571, 292, 2, '桂平市', '450881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5572, 293, 2, '玉州区', '450902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5573, 293, 2, '福绵区', '450903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5574, 293, 2, '容县', '450921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5575, 293, 2, '陆川县', '450922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5576, 293, 2, '博白县', '450923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5577, 293, 2, '兴业县', '450924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5578, 293, 2, '北流市', '450981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5579, 294, 2, '右江区', '451002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5580, 294, 2, '田阳区', '451003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5581, 294, 2, '田东县', '451022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5582, 294, 2, '平果县', '451023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5583, 294, 2, '德保县', '451024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5584, 294, 2, '那坡县', '451026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5585, 294, 2, '凌云县', '451027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5586, 294, 2, '乐业县', '451028', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5587, 294, 2, '田林县', '451029', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5588, 294, 2, '西林县', '451030', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5589, 294, 2, '隆林各族自治县', '451031', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5590, 294, 2, '靖西市', '451081', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5591, 295, 2, '八步区', '451102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5592, 295, 2, '平桂区', '451103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5593, 295, 2, '昭平县', '451121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5594, 295, 2, '钟山县', '451122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5595, 295, 2, '富川瑶族自治县', '451123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5596, 296, 2, '金城江区', '451202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5597, 296, 2, '宜州区', '451203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5598, 296, 2, '南丹县', '451221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5599, 296, 2, '天峨县', '451222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5600, 296, 2, '凤山县', '451223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5601, 296, 2, '东兰县', '451224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5602, 296, 2, '罗城仫佬族自治县', '451225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5603, 296, 2, '环江毛南族自治县', '451226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5604, 296, 2, '巴马瑶族自治县', '451227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5605, 296, 2, '都安瑶族自治县', '451228', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5606, 296, 2, '大化瑶族自治县', '451229', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5607, 297, 2, '兴宾区', '451302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5608, 297, 2, '忻城县', '451321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5609, 297, 2, '象州县', '451322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5610, 297, 2, '武宣县', '451323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5611, 297, 2, '金秀瑶族自治县', '451324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5612, 297, 2, '合山市', '451381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5613, 298, 2, '江州区', '451402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5614, 298, 2, '扶绥县', '451421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5615, 298, 2, '宁明县', '451422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5616, 298, 2, '龙州县', '451423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5617, 298, 2, '大新县', '451424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5618, 298, 2, '天等县', '451425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5619, 298, 2, '凭祥市', '451481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5620, 299, 2, '秀英区', '460105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5621, 299, 2, '龙华区', '460106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5622, 299, 2, '琼山区', '460107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5623, 299, 2, '美兰区', '460108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5624, 300, 2, '海棠区', '460202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5625, 300, 2, '吉阳区', '460203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5626, 300, 2, '天涯区', '460204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5627, 300, 2, '崖州区', '460205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5628, 301, 2, '西沙群岛', '460321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5629, 301, 2, '南沙群岛', '460322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5630, 301, 2, '中沙群岛的岛礁及其海域', '460323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5631, 302, 2, '那大镇', '4604001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5632, 302, 2, '和庆镇', '460400101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5633, 302, 2, '南丰镇', '460400102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5634, 302, 2, '大成镇', '460400103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5635, 302, 2, '雅星镇', '460400104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5636, 302, 2, '兰洋镇', '460400105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5637, 302, 2, '光村镇', '460400106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5638, 302, 2, '木棠镇', '460400107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5639, 302, 2, '海头镇', '460400108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5640, 302, 2, '峨蔓镇', '460400109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5641, 302, 2, '王五镇', '460400111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5642, 302, 2, '白马井镇', '460400112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5643, 302, 2, '中和镇', '460400113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5644, 302, 2, '排浦镇', '460400114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5645, 302, 2, '东成镇', '460400115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5646, 302, 2, '新州镇', '460400116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5647, 302, 2, '洋浦经济开发区', '460400499', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5648, 302, 2, '华南热作学院', '4604005', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5649, 303, 2, '五指山市', '469001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5650, 303, 2, '琼海市', '469002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5651, 303, 2, '文昌市', '469005', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5652, 303, 2, '万宁市', '469006', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5653, 303, 2, '东方市', '469007', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5654, 303, 2, '定安县', '469021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5655, 303, 2, '屯昌县', '469022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5656, 303, 2, '澄迈县', '469023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5657, 303, 2, '临高县', '469024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5658, 303, 2, '白沙黎族自治县', '469025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5659, 303, 2, '昌江黎族自治县', '469026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5660, 303, 2, '乐东黎族自治县', '469027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5661, 303, 2, '陵水黎族自治县', '469028', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5662, 303, 2, '保亭黎族苗族自治县', '469029', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5663, 303, 2, '琼中黎族苗族自治县', '469030', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5664, 304, 2, '万州区', '500101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5665, 304, 2, '涪陵区', '500102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5666, 304, 2, '渝中区', '500103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5667, 304, 2, '大渡口区', '500104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5668, 304, 2, '江北区', '500105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5669, 304, 2, '沙坪坝区', '500106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5670, 304, 2, '九龙坡区', '500107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5671, 304, 2, '南岸区', '500108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5672, 304, 2, '北碚区', '500109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5673, 304, 2, '綦江区', '500110', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5674, 304, 2, '大足区', '500111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5675, 304, 2, '渝北区', '500112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5676, 304, 2, '巴南区', '500113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5677, 304, 2, '黔江区', '500114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5678, 304, 2, '长寿区', '500115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5679, 304, 2, '江津区', '500116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5680, 304, 2, '合川区', '500117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5681, 304, 2, '永川区', '500118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5682, 304, 2, '南川区', '500119', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5683, 304, 2, '璧山区', '500120', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5684, 304, 2, '铜梁区', '500151', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5685, 304, 2, '潼南区', '500152', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5686, 304, 2, '荣昌区', '500153', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5687, 304, 2, '开州区', '500154', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5688, 304, 2, '梁平区', '500155', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5689, 304, 2, '武隆区', '500156', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5690, 305, 2, '城口县', '500229', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5691, 305, 2, '丰都县', '500230', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5692, 305, 2, '垫江县', '500231', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5693, 305, 2, '忠县', '500233', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5694, 305, 2, '云阳县', '500235', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5695, 305, 2, '奉节县', '500236', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5696, 305, 2, '巫山县', '500237', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5697, 305, 2, '巫溪县', '500238', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5698, 305, 2, '石柱土家族自治县', '500240', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5699, 305, 2, '秀山土家族苗族自治县', '500241', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5700, 305, 2, '酉阳土家族苗族自治县', '500242', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5701, 305, 2, '彭水苗族土家族自治县', '500243', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5702, 306, 2, '锦江区', '510104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5703, 306, 2, '青羊区', '510105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5704, 306, 2, '金牛区', '510106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5705, 306, 2, '武侯区', '510107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5706, 306, 2, '成华区', '510108', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5707, 306, 2, '龙泉驿区', '510112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5708, 306, 2, '青白江区', '510113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5709, 306, 2, '新都区', '510114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5710, 306, 2, '温江区', '510115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5711, 306, 2, '双流区', '510116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5712, 306, 2, '郫都区', '510117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5713, 306, 2, '金堂县', '510121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5714, 306, 2, '大邑县', '510129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5715, 306, 2, '蒲江县', '510131', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5716, 306, 2, '新津县', '510132', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5717, 306, 2, '都江堰市', '510181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5718, 306, 2, '彭州市', '510182', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5719, 306, 2, '邛崃市', '510183', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5720, 306, 2, '崇州市', '510184', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5721, 306, 2, '简阳市', '510185', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5722, 307, 2, '自流井区', '510302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5723, 307, 2, '贡井区', '510303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5724, 307, 2, '大安区', '510304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5725, 307, 2, '沿滩区', '510311', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5726, 307, 2, '荣县', '510321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5727, 307, 2, '富顺县', '510322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5728, 308, 2, '东区', '510402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5729, 308, 2, '西区', '510403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5730, 308, 2, '仁和区', '510411', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5731, 308, 2, '米易县', '510421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5732, 308, 2, '盐边县', '510422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5733, 309, 2, '江阳区', '510502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5734, 309, 2, '纳溪区', '510503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5735, 309, 2, '龙马潭区', '510504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5736, 309, 2, '泸县', '510521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5737, 309, 2, '合江县', '510522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5738, 309, 2, '叙永县', '510524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5739, 309, 2, '古蔺县', '510525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5740, 310, 2, '旌阳区', '510603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5741, 310, 2, '罗江区', '510604', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5742, 310, 2, '中江县', '510623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5743, 310, 2, '广汉市', '510681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5744, 310, 2, '什邡市', '510682', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5745, 310, 2, '绵竹市', '510683', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5746, 311, 2, '涪城区', '510703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5747, 311, 2, '游仙区', '510704', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5748, 311, 2, '安州区', '510705', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5749, 311, 2, '三台县', '510722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5750, 311, 2, '盐亭县', '510723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5751, 311, 2, '梓潼县', '510725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5752, 311, 2, '北川羌族自治县', '510726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5753, 311, 2, '平武县', '510727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5754, 311, 2, '江油市', '510781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5755, 312, 2, '利州区', '510802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5756, 312, 2, '昭化区', '510811', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5757, 312, 2, '朝天区', '510812', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5758, 312, 2, '旺苍县', '510821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5759, 312, 2, '青川县', '510822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5760, 312, 2, '剑阁县', '510823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5761, 312, 2, '苍溪县', '510824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5762, 313, 2, '船山区', '510903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5763, 313, 2, '安居区', '510904', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5764, 313, 2, '蓬溪县', '510921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5765, 313, 2, '大英县', '510923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5766, 313, 2, '射洪市', '510981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5767, 314, 2, '市中区', '511002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5768, 314, 2, '东兴区', '511011', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5769, 314, 2, '威远县', '511024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5770, 314, 2, '资中县', '511025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5771, 314, 2, '内江经济开发区', '511071', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5772, 314, 2, '隆昌市', '511083', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5773, 315, 2, '市中区', '511102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5774, 315, 2, '沙湾区', '511111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5775, 315, 2, '五通桥区', '511112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5776, 315, 2, '金口河区', '511113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5777, 315, 2, '犍为县', '511123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5778, 315, 2, '井研县', '511124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5779, 315, 2, '夹江县', '511126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5780, 315, 2, '沐川县', '511129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5781, 315, 2, '峨边彝族自治县', '511132', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5782, 315, 2, '马边彝族自治县', '511133', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5783, 315, 2, '峨眉山市', '511181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5784, 316, 2, '顺庆区', '511302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5785, 316, 2, '高坪区', '511303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5786, 316, 2, '嘉陵区', '511304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5787, 316, 2, '南部县', '511321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5788, 316, 2, '营山县', '511322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5789, 316, 2, '蓬安县', '511323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5790, 316, 2, '仪陇县', '511324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5791, 316, 2, '西充县', '511325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5792, 316, 2, '阆中市', '511381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5793, 317, 2, '东坡区', '511402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5794, 317, 2, '彭山区', '511403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5795, 317, 2, '仁寿县', '511421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5796, 317, 2, '洪雅县', '511423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5797, 317, 2, '丹棱县', '511424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5798, 317, 2, '青神县', '511425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5799, 318, 2, '翠屏区', '511502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5800, 318, 2, '南溪区', '511503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5801, 318, 2, '叙州区', '511504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5802, 318, 2, '江安县', '511523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5803, 318, 2, '长宁县', '511524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5804, 318, 2, '高县', '511525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5805, 318, 2, '珙县', '511526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5806, 318, 2, '筠连县', '511527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5807, 318, 2, '兴文县', '511528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5808, 318, 2, '屏山县', '511529', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5809, 319, 2, '广安区', '511602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5810, 319, 2, '前锋区', '511603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5811, 319, 2, '岳池县', '511621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5812, 319, 2, '武胜县', '511622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5813, 319, 2, '邻水县', '511623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5814, 319, 2, '华蓥市', '511681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5815, 320, 2, '通川区', '511702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5816, 320, 2, '达川区', '511703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5817, 320, 2, '宣汉县', '511722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5818, 320, 2, '开江县', '511723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5819, 320, 2, '大竹县', '511724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5820, 320, 2, '渠县', '511725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5821, 320, 2, '达州经济开发区', '511771', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5822, 320, 2, '万源市', '511781', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5823, 321, 2, '雨城区', '511802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5824, 321, 2, '名山区', '511803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5825, 321, 2, '荥经县', '511822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5826, 321, 2, '汉源县', '511823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5827, 321, 2, '石棉县', '511824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5828, 321, 2, '天全县', '511825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5829, 321, 2, '芦山县', '511826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5830, 321, 2, '宝兴县', '511827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5831, 322, 2, '巴州区', '511902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5832, 322, 2, '恩阳区', '511903', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5833, 322, 2, '通江县', '511921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5834, 322, 2, '南江县', '511922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5835, 322, 2, '平昌县', '511923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5836, 322, 2, '巴中经济开发区', '511971', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5837, 323, 2, '雁江区', '512002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5838, 323, 2, '安岳县', '512021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5839, 323, 2, '乐至县', '512022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5840, 324, 2, '马尔康市', '513201', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5841, 324, 2, '汶川县', '513221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5842, 324, 2, '理县', '513222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5843, 324, 2, '茂县', '513223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5844, 324, 2, '松潘县', '513224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5845, 324, 2, '九寨沟县', '513225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5846, 324, 2, '金川县', '513226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5847, 324, 2, '小金县', '513227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5848, 324, 2, '黑水县', '513228', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5849, 324, 2, '壤塘县', '513230', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5850, 324, 2, '阿坝县', '513231', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5851, 324, 2, '若尔盖县', '513232', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5852, 324, 2, '红原县', '513233', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5853, 325, 2, '康定市', '513301', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5854, 325, 2, '泸定县', '513322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5855, 325, 2, '丹巴县', '513323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5856, 325, 2, '九龙县', '513324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5857, 325, 2, '雅江县', '513325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5858, 325, 2, '道孚县', '513326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5859, 325, 2, '炉霍县', '513327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5860, 325, 2, '甘孜县', '513328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5861, 325, 2, '新龙县', '513329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5862, 325, 2, '德格县', '513330', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5863, 325, 2, '白玉县', '513331', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5864, 325, 2, '石渠县', '513332', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5865, 325, 2, '色达县', '513333', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5866, 325, 2, '理塘县', '513334', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5867, 325, 2, '巴塘县', '513335', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5868, 325, 2, '乡城县', '513336', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5869, 325, 2, '稻城县', '513337', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5870, 325, 2, '得荣县', '513338', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5871, 326, 2, '西昌市', '513401', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5872, 326, 2, '木里藏族自治县', '513422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5873, 326, 2, '盐源县', '513423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5874, 326, 2, '德昌县', '513424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5875, 326, 2, '会理县', '513425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5876, 326, 2, '会东县', '513426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5877, 326, 2, '宁南县', '513427', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5878, 326, 2, '普格县', '513428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5879, 326, 2, '布拖县', '513429', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5880, 326, 2, '金阳县', '513430', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5881, 326, 2, '昭觉县', '513431', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5882, 326, 2, '喜德县', '513432', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5883, 326, 2, '冕宁县', '513433', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5884, 326, 2, '越西县', '513434', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5885, 326, 2, '甘洛县', '513435', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5886, 326, 2, '美姑县', '513436', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5887, 326, 2, '雷波县', '513437', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5888, 327, 2, '南明区', '520102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5889, 327, 2, '云岩区', '520103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5890, 327, 2, '花溪区', '520111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5891, 327, 2, '乌当区', '520112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5892, 327, 2, '白云区', '520113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5893, 327, 2, '观山湖区', '520115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5894, 327, 2, '开阳县', '520121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5895, 327, 2, '息烽县', '520122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5896, 327, 2, '修文县', '520123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5897, 327, 2, '清镇市', '520181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5898, 328, 2, '钟山区', '520201', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5899, 328, 2, '六枝特区', '520203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5900, 328, 2, '水城县', '520221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5901, 328, 2, '盘州市', '520281', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5902, 329, 2, '红花岗区', '520302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5903, 329, 2, '汇川区', '520303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5904, 329, 2, '播州区', '520304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5905, 329, 2, '桐梓县', '520322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5906, 329, 2, '绥阳县', '520323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5907, 329, 2, '正安县', '520324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5908, 329, 2, '道真仡佬族苗族自治县', '520325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5909, 329, 2, '务川仡佬族苗族自治县', '520326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5910, 329, 2, '凤冈县', '520327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5911, 329, 2, '湄潭县', '520328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5912, 329, 2, '余庆县', '520329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5913, 329, 2, '习水县', '520330', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5914, 329, 2, '赤水市', '520381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5915, 329, 2, '仁怀市', '520382', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5916, 330, 2, '西秀区', '520402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5917, 330, 2, '平坝区', '520403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5918, 330, 2, '普定县', '520422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5919, 330, 2, '镇宁布依族苗族自治县', '520423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5920, 330, 2, '关岭布依族苗族自治县', '520424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5921, 330, 2, '紫云苗族布依族自治县', '520425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5922, 331, 2, '七星关区', '520502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5923, 331, 2, '大方县', '520521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5924, 331, 2, '黔西县', '520522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5925, 331, 2, '金沙县', '520523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5926, 331, 2, '织金县', '520524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5927, 331, 2, '纳雍县', '520525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5928, 331, 2, '威宁彝族回族苗族自治县', '520526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5929, 331, 2, '赫章县', '520527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5930, 332, 2, '碧江区', '520602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5931, 332, 2, '万山区', '520603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5932, 332, 2, '江口县', '520621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5933, 332, 2, '玉屏侗族自治县', '520622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5934, 332, 2, '石阡县', '520623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5935, 332, 2, '思南县', '520624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5936, 332, 2, '印江土家族苗族自治县', '520625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5937, 332, 2, '德江县', '520626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5938, 332, 2, '沿河土家族自治县', '520627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5939, 332, 2, '松桃苗族自治县', '520628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5940, 333, 2, '兴义市', '522301', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5941, 333, 2, '兴仁市', '522302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5942, 333, 2, '普安县', '522323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5943, 333, 2, '晴隆县', '522324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5944, 333, 2, '贞丰县', '522325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5945, 333, 2, '望谟县', '522326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5946, 333, 2, '册亨县', '522327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5947, 333, 2, '安龙县', '522328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5948, 334, 2, '凯里市', '522601', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5949, 334, 2, '黄平县', '522622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5950, 334, 2, '施秉县', '522623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5951, 334, 2, '三穗县', '522624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5952, 334, 2, '镇远县', '522625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5953, 334, 2, '岑巩县', '522626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5954, 334, 2, '天柱县', '522627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5955, 334, 2, '锦屏县', '522628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5956, 334, 2, '剑河县', '522629', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5957, 334, 2, '台江县', '522630', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5958, 334, 2, '黎平县', '522631', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5959, 334, 2, '榕江县', '522632', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5960, 334, 2, '从江县', '522633', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5961, 334, 2, '雷山县', '522634', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5962, 334, 2, '麻江县', '522635', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5963, 334, 2, '丹寨县', '522636', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5964, 335, 2, '都匀市', '522701', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5965, 335, 2, '福泉市', '522702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5966, 335, 2, '荔波县', '522722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5967, 335, 2, '贵定县', '522723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5968, 335, 2, '瓮安县', '522725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5969, 335, 2, '独山县', '522726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5970, 335, 2, '平塘县', '522727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5971, 335, 2, '罗甸县', '522728', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5972, 335, 2, '长顺县', '522729', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5973, 335, 2, '龙里县', '522730', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5974, 335, 2, '惠水县', '522731', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5975, 335, 2, '三都水族自治县', '522732', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5976, 336, 2, '五华区', '530102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5977, 336, 2, '盘龙区', '530103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5978, 336, 2, '官渡区', '530111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5979, 336, 2, '西山区', '530112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5980, 336, 2, '东川区', '530113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5981, 336, 2, '呈贡区', '530114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5982, 336, 2, '晋宁区', '530115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5983, 336, 2, '富民县', '530124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5984, 336, 2, '宜良县', '530125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5985, 336, 2, '石林彝族自治县', '530126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5986, 336, 2, '嵩明县', '530127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5987, 336, 2, '禄劝彝族苗族自治县', '530128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5988, 336, 2, '寻甸回族彝族自治县', '530129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5989, 336, 2, '安宁市', '530181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5990, 337, 2, '麒麟区', '530302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5991, 337, 2, '沾益区', '530303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5992, 337, 2, '马龙区', '530304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5993, 337, 2, '陆良县', '530322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5994, 337, 2, '师宗县', '530323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5995, 337, 2, '罗平县', '530324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5996, 337, 2, '富源县', '530325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5997, 337, 2, '会泽县', '530326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5998, 337, 2, '宣威市', '530381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (5999, 338, 2, '红塔区', '530402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6000, 338, 2, '江川区', '530403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6001, 338, 2, '澄江县', '530422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6002, 338, 2, '通海县', '530423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6003, 338, 2, '华宁县', '530424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6004, 338, 2, '易门县', '530425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6005, 338, 2, '峨山彝族自治县', '530426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6006, 338, 2, '新平彝族傣族自治县', '530427', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6007, 338, 2, '元江哈尼族彝族傣族自治县', '530428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6008, 339, 2, '隆阳区', '530502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6009, 339, 2, '施甸县', '530521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6010, 339, 2, '龙陵县', '530523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6011, 339, 2, '昌宁县', '530524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6012, 339, 2, '腾冲市', '530581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6013, 340, 2, '昭阳区', '530602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6014, 340, 2, '鲁甸县', '530621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6015, 340, 2, '巧家县', '530622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6016, 340, 2, '盐津县', '530623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6017, 340, 2, '大关县', '530624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6018, 340, 2, '永善县', '530625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6019, 340, 2, '绥江县', '530626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6020, 340, 2, '镇雄县', '530627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6021, 340, 2, '彝良县', '530628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6022, 340, 2, '威信县', '530629', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6023, 340, 2, '水富市', '530681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6024, 341, 2, '古城区', '530702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6025, 341, 2, '玉龙纳西族自治县', '530721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6026, 341, 2, '永胜县', '530722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6027, 341, 2, '华坪县', '530723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6028, 341, 2, '宁蒗彝族自治县', '530724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6029, 342, 2, '思茅区', '530802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6030, 342, 2, '宁洱哈尼族彝族自治县', '530821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6031, 342, 2, '墨江哈尼族自治县', '530822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6032, 342, 2, '景东彝族自治县', '530823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6033, 342, 2, '景谷傣族彝族自治县', '530824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6034, 342, 2, '镇沅彝族哈尼族拉祜族自治县', '530825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6035, 342, 2, '江城哈尼族彝族自治县', '530826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6036, 342, 2, '孟连傣族拉祜族佤族自治县', '530827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6037, 342, 2, '澜沧拉祜族自治县', '530828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6038, 342, 2, '西盟佤族自治县', '530829', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6039, 343, 2, '临翔区', '530902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6040, 343, 2, '凤庆县', '530921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6041, 343, 2, '云县', '530922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6042, 343, 2, '永德县', '530923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6043, 343, 2, '镇康县', '530924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6044, 343, 2, '双江拉祜族佤族布朗族傣族自治县', '530925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6045, 343, 2, '耿马傣族佤族自治县', '530926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6046, 343, 2, '沧源佤族自治县', '530927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6047, 344, 2, '楚雄市', '532301', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6048, 344, 2, '双柏县', '532322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6049, 344, 2, '牟定县', '532323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6050, 344, 2, '南华县', '532324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6051, 344, 2, '姚安县', '532325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6052, 344, 2, '大姚县', '532326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6053, 344, 2, '永仁县', '532327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6054, 344, 2, '元谋县', '532328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6055, 344, 2, '武定县', '532329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6056, 344, 2, '禄丰县', '532331', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6057, 345, 2, '个旧市', '532501', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6058, 345, 2, '开远市', '532502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6059, 345, 2, '蒙自市', '532503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6060, 345, 2, '弥勒市', '532504', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6061, 345, 2, '屏边苗族自治县', '532523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6062, 345, 2, '建水县', '532524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6063, 345, 2, '石屏县', '532525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6064, 345, 2, '泸西县', '532527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6065, 345, 2, '元阳县', '532528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6066, 345, 2, '红河县', '532529', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6067, 345, 2, '金平苗族瑶族傣族自治县', '532530', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6068, 345, 2, '绿春县', '532531', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6069, 345, 2, '河口瑶族自治县', '532532', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6070, 346, 2, '文山市', '532601', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6071, 346, 2, '砚山县', '532622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6072, 346, 2, '西畴县', '532623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6073, 346, 2, '麻栗坡县', '532624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6074, 346, 2, '马关县', '532625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6075, 346, 2, '丘北县', '532626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6076, 346, 2, '广南县', '532627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6077, 346, 2, '富宁县', '532628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6078, 347, 2, '景洪市', '532801', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6079, 347, 2, '勐海县', '532822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6080, 347, 2, '勐腊县', '532823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6081, 348, 2, '大理市', '532901', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6082, 348, 2, '漾濞彝族自治县', '532922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6083, 348, 2, '祥云县', '532923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6084, 348, 2, '宾川县', '532924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6085, 348, 2, '弥渡县', '532925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6086, 348, 2, '南涧彝族自治县', '532926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6087, 348, 2, '巍山彝族回族自治县', '532927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6088, 348, 2, '永平县', '532928', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6089, 348, 2, '云龙县', '532929', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6090, 348, 2, '洱源县', '532930', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6091, 348, 2, '剑川县', '532931', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6092, 348, 2, '鹤庆县', '532932', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6093, 349, 2, '瑞丽市', '533102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6094, 349, 2, '芒市', '533103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6095, 349, 2, '梁河县', '533122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6096, 349, 2, '盈江县', '533123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6097, 349, 2, '陇川县', '533124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6098, 350, 2, '泸水市', '533301', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6099, 350, 2, '福贡县', '533323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6100, 350, 2, '贡山独龙族怒族自治县', '533324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6101, 350, 2, '兰坪白族普米族自治县', '533325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6102, 351, 2, '香格里拉市', '533401', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6103, 351, 2, '德钦县', '533422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6104, 351, 2, '维西傈僳族自治县', '533423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6105, 352, 2, '城关区', '540102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6106, 352, 2, '堆龙德庆区', '540103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6107, 352, 2, '达孜区', '540104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6108, 352, 2, '林周县', '540121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6109, 352, 2, '当雄县', '540122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6110, 352, 2, '尼木县', '540123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6111, 352, 2, '曲水县', '540124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6112, 352, 2, '墨竹工卡县', '540127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6113, 352, 2, '格尔木藏青工业园区', '540171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6114, 352, 2, '拉萨经济技术开发区', '540172', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6115, 352, 2, '西藏文化旅游创意园区', '540173', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6116, 352, 2, '达孜工业园区', '540174', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6117, 353, 2, '桑珠孜区', '540202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6118, 353, 2, '南木林县', '540221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6119, 353, 2, '江孜县', '540222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6120, 353, 2, '定日县', '540223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6121, 353, 2, '萨迦县', '540224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6122, 353, 2, '拉孜县', '540225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6123, 353, 2, '昂仁县', '540226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6124, 353, 2, '谢通门县', '540227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6125, 353, 2, '白朗县', '540228', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6126, 353, 2, '仁布县', '540229', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6127, 353, 2, '康马县', '540230', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6128, 353, 2, '定结县', '540231', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6129, 353, 2, '仲巴县', '540232', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6130, 353, 2, '亚东县', '540233', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6131, 353, 2, '吉隆县', '540234', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6132, 353, 2, '聂拉木县', '540235', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6133, 353, 2, '萨嘎县', '540236', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6134, 353, 2, '岗巴县', '540237', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6135, 354, 2, '卡若区', '540302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6136, 354, 2, '江达县', '540321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6137, 354, 2, '贡觉县', '540322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6138, 354, 2, '类乌齐县', '540323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6139, 354, 2, '丁青县', '540324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6140, 354, 2, '察雅县', '540325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6141, 354, 2, '八宿县', '540326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6142, 354, 2, '左贡县', '540327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6143, 354, 2, '芒康县', '540328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6144, 354, 2, '洛隆县', '540329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6145, 354, 2, '边坝县', '540330', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6146, 355, 2, '巴宜区', '540402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6147, 355, 2, '工布江达县', '540421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6148, 355, 2, '米林县', '540422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6149, 355, 2, '墨脱县', '540423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6150, 355, 2, '波密县', '540424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6151, 355, 2, '察隅县', '540425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6152, 355, 2, '朗县', '540426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6153, 356, 2, '乃东区', '540502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6154, 356, 2, '扎囊县', '540521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6155, 356, 2, '贡嘎县', '540522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6156, 356, 2, '桑日县', '540523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6157, 356, 2, '琼结县', '540524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6158, 356, 2, '曲松县', '540525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6159, 356, 2, '措美县', '540526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6160, 356, 2, '洛扎县', '540527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6161, 356, 2, '加查县', '540528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6162, 356, 2, '隆子县', '540529', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6163, 356, 2, '错那县', '540530', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6164, 356, 2, '浪卡子县', '540531', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6165, 357, 2, '色尼区', '540602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6166, 357, 2, '嘉黎县', '540621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6167, 357, 2, '比如县', '540622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6168, 357, 2, '聂荣县', '540623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6169, 357, 2, '安多县', '540624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6170, 357, 2, '申扎县', '540625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6171, 357, 2, '索县', '540626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6172, 357, 2, '班戈县', '540627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6173, 357, 2, '巴青县', '540628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6174, 357, 2, '尼玛县', '540629', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6175, 357, 2, '双湖县', '540630', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6176, 358, 2, '普兰县', '542521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6177, 358, 2, '札达县', '542522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6178, 358, 2, '噶尔县', '542523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6179, 358, 2, '日土县', '542524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6180, 358, 2, '革吉县', '542525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6181, 358, 2, '改则县', '542526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6182, 358, 2, '措勤县', '542527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6183, 359, 2, '新城区', '610102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6184, 359, 2, '碑林区', '610103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6185, 359, 2, '莲湖区', '610104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6186, 359, 2, '灞桥区', '610111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6187, 359, 2, '未央区', '610112', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6188, 359, 2, '雁塔区', '610113', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6189, 359, 2, '阎良区', '610114', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6190, 359, 2, '临潼区', '610115', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6191, 359, 2, '长安区', '610116', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6192, 359, 2, '高陵区', '610117', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6193, 359, 2, '鄠邑区', '610118', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6194, 359, 2, '蓝田县', '610122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6195, 359, 2, '周至县', '610124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6196, 360, 2, '王益区', '610202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6197, 360, 2, '印台区', '610203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6198, 360, 2, '耀州区', '610204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6199, 360, 2, '宜君县', '610222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6200, 361, 2, '渭滨区', '610302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6201, 361, 2, '金台区', '610303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6202, 361, 2, '陈仓区', '610304', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6203, 361, 2, '凤翔县', '610322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6204, 361, 2, '岐山县', '610323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6205, 361, 2, '扶风县', '610324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6206, 361, 2, '眉县', '610326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6207, 361, 2, '陇县', '610327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6208, 361, 2, '千阳县', '610328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6209, 361, 2, '麟游县', '610329', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6210, 361, 2, '凤县', '610330', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6211, 361, 2, '太白县', '610331', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6212, 362, 2, '秦都区', '610402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6213, 362, 2, '杨陵区', '610403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6214, 362, 2, '渭城区', '610404', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6215, 362, 2, '三原县', '610422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6216, 362, 2, '泾阳县', '610423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6217, 362, 2, '乾县', '610424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6218, 362, 2, '礼泉县', '610425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6219, 362, 2, '永寿县', '610426', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6220, 362, 2, '长武县', '610428', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6221, 362, 2, '旬邑县', '610429', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6222, 362, 2, '淳化县', '610430', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6223, 362, 2, '武功县', '610431', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6224, 362, 2, '兴平市', '610481', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6225, 362, 2, '彬州市', '610482', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6226, 363, 2, '临渭区', '610502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6227, 363, 2, '华州区', '610503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6228, 363, 2, '潼关县', '610522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6229, 363, 2, '大荔县', '610523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6230, 363, 2, '合阳县', '610524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6231, 363, 2, '澄城县', '610525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6232, 363, 2, '蒲城县', '610526', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6233, 363, 2, '白水县', '610527', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6234, 363, 2, '富平县', '610528', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6235, 363, 2, '韩城市', '610581', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6236, 363, 2, '华阴市', '610582', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6237, 364, 2, '宝塔区', '610602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6238, 364, 2, '安塞区', '610603', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6239, 364, 2, '延长县', '610621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6240, 364, 2, '延川县', '610622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6241, 364, 2, '志丹县', '610625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6242, 364, 2, '吴起县', '610626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6243, 364, 2, '甘泉县', '610627', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6244, 364, 2, '富县', '610628', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6245, 364, 2, '洛川县', '610629', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6246, 364, 2, '宜川县', '610630', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6247, 364, 2, '黄龙县', '610631', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6248, 364, 2, '黄陵县', '610632', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6249, 364, 2, '子长市', '610681', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6250, 365, 2, '汉台区', '610702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6251, 365, 2, '南郑区', '610703', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6252, 365, 2, '城固县', '610722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6253, 365, 2, '洋县', '610723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6254, 365, 2, '西乡县', '610724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6255, 365, 2, '勉县', '610725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6256, 365, 2, '宁强县', '610726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6257, 365, 2, '略阳县', '610727', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6258, 365, 2, '镇巴县', '610728', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6259, 365, 2, '留坝县', '610729', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6260, 365, 2, '佛坪县', '610730', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6261, 366, 2, '榆阳区', '610802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6262, 366, 2, '横山区', '610803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6263, 366, 2, '府谷县', '610822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6264, 366, 2, '靖边县', '610824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6265, 366, 2, '定边县', '610825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6266, 366, 2, '绥德县', '610826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6267, 366, 2, '米脂县', '610827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6268, 366, 2, '佳县', '610828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6269, 366, 2, '吴堡县', '610829', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6270, 366, 2, '清涧县', '610830', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6271, 366, 2, '子洲县', '610831', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6272, 366, 2, '神木市', '610881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6273, 367, 2, '汉滨区', '610902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6274, 367, 2, '汉阴县', '610921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6275, 367, 2, '石泉县', '610922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6276, 367, 2, '宁陕县', '610923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6277, 367, 2, '紫阳县', '610924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6278, 367, 2, '岚皋县', '610925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6279, 367, 2, '平利县', '610926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6280, 367, 2, '镇坪县', '610927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6281, 367, 2, '旬阳县', '610928', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6282, 367, 2, '白河县', '610929', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6283, 368, 2, '商州区', '611002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6284, 368, 2, '洛南县', '611021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6285, 368, 2, '丹凤县', '611022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6286, 368, 2, '商南县', '611023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6287, 368, 2, '山阳县', '611024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6288, 368, 2, '镇安县', '611025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6289, 368, 2, '柞水县', '611026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6290, 369, 2, '城关区', '620102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6291, 369, 2, '七里河区', '620103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6292, 369, 2, '西固区', '620104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6293, 369, 2, '安宁区', '620105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6294, 369, 2, '红古区', '620111', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6295, 369, 2, '永登县', '620121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6296, 369, 2, '皋兰县', '620122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6297, 369, 2, '榆中县', '620123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6298, 369, 2, '兰州新区', '620171', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6299, 370, 2, '市辖区', '620201', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6300, 371, 2, '金川区', '620302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6301, 371, 2, '永昌县', '620321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6302, 372, 2, '白银区', '620402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6303, 372, 2, '平川区', '620403', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6304, 372, 2, '靖远县', '620421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6305, 372, 2, '会宁县', '620422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6306, 372, 2, '景泰县', '620423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6307, 373, 2, '秦州区', '620502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6308, 373, 2, '麦积区', '620503', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6309, 373, 2, '清水县', '620521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6310, 373, 2, '秦安县', '620522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6311, 373, 2, '甘谷县', '620523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6312, 373, 2, '武山县', '620524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6313, 373, 2, '张家川回族自治县', '620525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6314, 374, 2, '凉州区', '620602', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6315, 374, 2, '民勤县', '620621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6316, 374, 2, '古浪县', '620622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6317, 374, 2, '天祝藏族自治县', '620623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6318, 375, 2, '甘州区', '620702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6319, 375, 2, '肃南裕固族自治县', '620721', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6320, 375, 2, '民乐县', '620722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6321, 375, 2, '临泽县', '620723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6322, 375, 2, '高台县', '620724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6323, 375, 2, '山丹县', '620725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6324, 376, 2, '崆峒区', '620802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6325, 376, 2, '泾川县', '620821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6326, 376, 2, '灵台县', '620822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6327, 376, 2, '崇信县', '620823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6328, 376, 2, '庄浪县', '620825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6329, 376, 2, '静宁县', '620826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6330, 376, 2, '华亭市', '620881', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6331, 377, 2, '肃州区', '620902', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6332, 377, 2, '金塔县', '620921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6333, 377, 2, '瓜州县', '620922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6334, 377, 2, '肃北蒙古族自治县', '620923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6335, 377, 2, '阿克塞哈萨克族自治县', '620924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6336, 377, 2, '玉门市', '620981', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6337, 377, 2, '敦煌市', '620982', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6338, 378, 2, '西峰区', '621002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6339, 378, 2, '庆城县', '621021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6340, 378, 2, '环县', '621022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6341, 378, 2, '华池县', '621023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6342, 378, 2, '合水县', '621024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6343, 378, 2, '正宁县', '621025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6344, 378, 2, '宁县', '621026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6345, 378, 2, '镇原县', '621027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6346, 379, 2, '安定区', '621102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6347, 379, 2, '通渭县', '621121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6348, 379, 2, '陇西县', '621122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6349, 379, 2, '渭源县', '621123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6350, 379, 2, '临洮县', '621124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6351, 379, 2, '漳县', '621125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6352, 379, 2, '岷县', '621126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6353, 380, 2, '武都区', '621202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6354, 380, 2, '成县', '621221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6355, 380, 2, '文县', '621222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6356, 380, 2, '宕昌县', '621223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6357, 380, 2, '康县', '621224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6358, 380, 2, '西和县', '621225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6359, 380, 2, '礼县', '621226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6360, 380, 2, '徽县', '621227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6361, 380, 2, '两当县', '621228', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6362, 381, 2, '临夏市', '622901', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6363, 381, 2, '临夏县', '622921', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6364, 381, 2, '康乐县', '622922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6365, 381, 2, '永靖县', '622923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6366, 381, 2, '广河县', '622924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6367, 381, 2, '和政县', '622925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6368, 381, 2, '东乡族自治县', '622926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6369, 381, 2, '积石山保安族东乡族撒拉族自治县', '622927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6370, 382, 2, '合作市', '623001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6371, 382, 2, '临潭县', '623021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6372, 382, 2, '卓尼县', '623022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6373, 382, 2, '舟曲县', '623023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6374, 382, 2, '迭部县', '623024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6375, 382, 2, '玛曲县', '623025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6376, 382, 2, '碌曲县', '623026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6377, 382, 2, '夏河县', '623027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6378, 383, 2, '城东区', '630102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6379, 383, 2, '城中区', '630103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6380, 383, 2, '城西区', '630104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6381, 383, 2, '城北区', '630105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6382, 383, 2, '大通回族土族自治县', '630121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6383, 383, 2, '湟中县', '630122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6384, 383, 2, '湟源县', '630123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6385, 384, 2, '乐都区', '630202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6386, 384, 2, '平安区', '630203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6387, 384, 2, '民和回族土族自治县', '630222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6388, 384, 2, '互助土族自治县', '630223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6389, 384, 2, '化隆回族自治县', '630224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6390, 384, 2, '循化撒拉族自治县', '630225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6391, 385, 2, '门源回族自治县', '632221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6392, 385, 2, '祁连县', '632222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6393, 385, 2, '海晏县', '632223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6394, 385, 2, '刚察县', '632224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6395, 386, 2, '同仁县', '632321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6396, 386, 2, '尖扎县', '632322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6397, 386, 2, '泽库县', '632323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6398, 386, 2, '河南蒙古族自治县', '632324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6399, 387, 2, '共和县', '632521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6400, 387, 2, '同德县', '632522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6401, 387, 2, '贵德县', '632523', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6402, 387, 2, '兴海县', '632524', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6403, 387, 2, '贵南县', '632525', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6404, 388, 2, '玛沁县', '632621', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6405, 388, 2, '班玛县', '632622', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6406, 388, 2, '甘德县', '632623', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6407, 388, 2, '达日县', '632624', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6408, 388, 2, '久治县', '632625', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6409, 388, 2, '玛多县', '632626', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6410, 389, 2, '玉树市', '632701', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6411, 389, 2, '杂多县', '632722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6412, 389, 2, '称多县', '632723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6413, 389, 2, '治多县', '632724', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6414, 389, 2, '囊谦县', '632725', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6415, 389, 2, '曲麻莱县', '632726', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6416, 390, 2, '格尔木市', '632801', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6417, 390, 2, '德令哈市', '632802', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6418, 390, 2, '茫崖市', '632803', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6419, 390, 2, '乌兰县', '632821', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6420, 390, 2, '都兰县', '632822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6421, 390, 2, '天峻县', '632823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6422, 390, 2, '大柴旦行政委员会', '632857', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6423, 391, 2, '兴庆区', '640104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6424, 391, 2, '西夏区', '640105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6425, 391, 2, '金凤区', '640106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6426, 391, 2, '永宁县', '640121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6427, 391, 2, '贺兰县', '640122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6428, 391, 2, '灵武市', '640181', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6429, 392, 2, '大武口区', '640202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6430, 392, 2, '惠农区', '640205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6431, 392, 2, '平罗县', '640221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6432, 393, 2, '利通区', '640302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6433, 393, 2, '红寺堡区', '640303', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6434, 393, 2, '盐池县', '640323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6435, 393, 2, '同心县', '640324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6436, 393, 2, '青铜峡市', '640381', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6437, 394, 2, '原州区', '640402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6438, 394, 2, '西吉县', '640422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6439, 394, 2, '隆德县', '640423', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6440, 394, 2, '泾源县', '640424', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6441, 394, 2, '彭阳县', '640425', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6442, 395, 2, '沙坡头区', '640502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6443, 395, 2, '中宁县', '640521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6444, 395, 2, '海原县', '640522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6445, 396, 2, '天山区', '650102', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6446, 396, 2, '沙依巴克区', '650103', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6447, 396, 2, '新市区', '650104', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6448, 396, 2, '水磨沟区', '650105', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6449, 396, 2, '头屯河区', '650106', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6450, 396, 2, '达坂城区', '650107', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6451, 396, 2, '米东区', '650109', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6452, 396, 2, '乌鲁木齐县', '650121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6453, 397, 2, '独山子区', '650202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6454, 397, 2, '克拉玛依区', '650203', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6455, 397, 2, '白碱滩区', '650204', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6456, 397, 2, '乌尔禾区', '650205', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6457, 398, 2, '高昌区', '650402', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6458, 398, 2, '鄯善县', '650421', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6459, 398, 2, '托克逊县', '650422', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6460, 399, 2, '伊州区', '650502', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6461, 399, 2, '巴里坤哈萨克自治县', '650521', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6462, 399, 2, '伊吾县', '650522', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6463, 400, 2, '昌吉市', '652301', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6464, 400, 2, '阜康市', '652302', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6465, 400, 2, '呼图壁县', '652323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6466, 400, 2, '玛纳斯县', '652324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6467, 400, 2, '奇台县', '652325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6468, 400, 2, '吉木萨尔县', '652327', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6469, 400, 2, '木垒哈萨克自治县', '652328', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6470, 401, 2, '博乐市', '652701', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6471, 401, 2, '阿拉山口市', '652702', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6472, 401, 2, '精河县', '652722', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6473, 401, 2, '温泉县', '652723', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6474, 402, 2, '库尔勒市', '652801', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6475, 402, 2, '轮台县', '652822', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6476, 402, 2, '尉犁县', '652823', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6477, 402, 2, '若羌县', '652824', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6478, 402, 2, '且末县', '652825', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6479, 402, 2, '焉耆回族自治县', '652826', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6480, 402, 2, '和静县', '652827', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6481, 402, 2, '和硕县', '652828', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6482, 402, 2, '博湖县', '652829', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6483, 402, 2, '库尔勒经济技术开发区', '652871', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6484, 403, 2, '阿克苏市', '652901', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6485, 403, 2, '温宿县', '652922', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6486, 403, 2, '库车县', '652923', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6487, 403, 2, '沙雅县', '652924', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6488, 403, 2, '新和县', '652925', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6489, 403, 2, '拜城县', '652926', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6490, 403, 2, '乌什县', '652927', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6491, 403, 2, '阿瓦提县', '652928', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6492, 403, 2, '柯坪县', '652929', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6493, 404, 2, '阿图什市', '653001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6494, 404, 2, '阿克陶县', '653022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6495, 404, 2, '阿合奇县', '653023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6496, 404, 2, '乌恰县', '653024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6497, 405, 2, '喀什市', '653101', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6498, 405, 2, '疏附县', '653121', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6499, 405, 2, '疏勒县', '653122', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6500, 405, 2, '英吉沙县', '653123', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6501, 405, 2, '泽普县', '653124', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6502, 405, 2, '莎车县', '653125', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6503, 405, 2, '叶城县', '653126', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6504, 405, 2, '麦盖提县', '653127', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6505, 405, 2, '岳普湖县', '653128', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6506, 405, 2, '伽师县', '653129', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6507, 405, 2, '巴楚县', '653130', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6508, 405, 2, '塔什库尔干塔吉克自治县', '653131', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6509, 406, 2, '和田市', '653201', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6510, 406, 2, '和田县', '653221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6511, 406, 2, '墨玉县', '653222', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6512, 406, 2, '皮山县', '653223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6513, 406, 2, '洛浦县', '653224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6514, 406, 2, '策勒县', '653225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6515, 406, 2, '于田县', '653226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6516, 406, 2, '民丰县', '653227', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6517, 407, 2, '伊宁市', '654002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6518, 407, 2, '奎屯市', '654003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6519, 407, 2, '霍尔果斯市', '654004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6520, 407, 2, '伊宁县', '654021', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6521, 407, 2, '察布查尔锡伯自治县', '654022', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6522, 407, 2, '霍城县', '654023', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6523, 407, 2, '巩留县', '654024', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6524, 407, 2, '新源县', '654025', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6525, 407, 2, '昭苏县', '654026', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6526, 407, 2, '特克斯县', '654027', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6527, 407, 2, '尼勒克县', '654028', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6528, 408, 2, '塔城市', '654201', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6529, 408, 2, '乌苏市', '654202', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6530, 408, 2, '额敏县', '654221', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6531, 408, 2, '沙湾县', '654223', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6532, 408, 2, '托里县', '654224', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6533, 408, 2, '裕民县', '654225', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6534, 408, 2, '和布克赛尔蒙古自治县', '654226', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6535, 409, 2, '阿勒泰市', '654301', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6536, 409, 2, '布尔津县', '654321', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6537, 409, 2, '富蕴县', '654322', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6538, 409, 2, '福海县', '654323', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6539, 409, 2, '哈巴河县', '654324', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6540, 409, 2, '青河县', '654325', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6541, 409, 2, '吉木乃县', '654326', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6542, 410, 2, '石河子市', '659001', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6543, 410, 2, '阿拉尔市', '659002', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6544, 410, 2, '图木舒克市', '659003', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6545, 410, 2, '五家渠市', '659004', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6546, 410, 2, '铁门关市', '659006', 10, 1, 1700286983, 1700286983);
INSERT INTO `region` VALUES (6548, 0, 0, 'aaa222', 'sss', 0, 1, 1703315323, 1703315219);

SET FOREIGN_KEY_CHECKS = 1;

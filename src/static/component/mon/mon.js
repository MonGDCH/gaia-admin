'use strict';
const rootPath = (function (src) {
    let root = document.currentScript ? document.currentScript.src : document.scripts[document.scripts.length - 1].src;
    src = root.substring(0, root.lastIndexOf('/'));
    return src.substring(0, src.lastIndexOf('/') + 1);
})();

// 版本控制，true则不缓存
const version = (function (src) {
    let root = document.currentScript ? document.currentScript.src : document.scripts[document.scripts.length - 1].src;
    let param = root.split("?");
    if ("string" != typeof (param[1])) {
        return true;
    }
    let pair = param[1].split("&");
    for (let item in pair) {
        let val = pair[item].split("=");
        if (val[0] == "v" && val[1] != '') {
            return val[1];
        }
    }

    return true
})();

layui.config({
    base: rootPath,
    version: version
}).extend({
    // 表单业务封装
    mForm: 'mon/module/form',
    // 表格业务封装
    mTable: 'mon/module/table',
    // 工具集
    common: 'mon/module/common',
    // 操作交互
    action: 'mon/module/action',
    // xm-select多选下拉框
    xmSelect: 'mon/module/xm-select',
    // 侧边导航
    nav: 'mon/module/nav',
    // 右键菜单
    contextMenu: 'mon/module/contextMenu',
    // 文件上传
    mUpload: 'mon/module/upload',
    // 进度加载条
    loadingBar: 'mon/module/loadingBar',
    // 打印
    print: 'mon/module/print',
    // 缓存
    storage: 'mon/module/storage',
    // cookie
    cookie: 'mon/module/cookie',
    // 通知
    toast: 'mon/module/toast',
    // jwt_decode
    jwt_decode: 'mon/module/jwtDecode',
    // token
    token: 'mon/module/token',
    // axios
    axios: 'mon/module/axios/axios.min',
    // 基于axios的支持jwt的HTTP请求封装
    http: 'mon/module/http',
    // 联级选择
    cascader: 'mon/module/cascader/cascader',
    // tinymce
    tinymce: 'mon/module/tinymce/tinymce.min',
    // tinymce富文本编辑器封装
    editor: 'mon/module/editor',
    // cherry-markdown 编辑器
    markdown: 'mon/module/markdown',
    // 评论编辑器
    comment: 'mon/module/comment/comment',
    // input tags
    inputTag: 'mon/module/inputTag/inputTag',
    // 固定滑块
    affix: 'mon/module/affix',
    // js安全应用
    jsCtrl: 'mon/module/jsCtrl',
    // 表单设计工具
    formDesign: 'mon/module/form-simple/form-design',
    // 表单渲染工具
    formRender: 'mon/module/form-simple/form-render',
    // 图片选择器
    imgSelect: 'mon/module/imgSelect/imgSelect',
    // 表格记录选择
    tableSelect: 'mon/module/tableSelect',
    // 用户选择
    userSelect: 'mon/module/userSelect',
    // input 自动完成
    autoComplete: 'mon/module/autoComplete/autoComplete',
    // crontab 表达式
    cron: 'mon/module/cron/cron',

    // 产品属性表格
    attrTable: 'mon/module/goods/attrTable',
    // 产品规格表格
    specTable: 'mon/module/goods/specTable',
    // sku表格
    skuTable: 'mon/module/goods/skuTable',
    // 产品管理
    goods: 'mon/module/goods/goods',

    // soul=table
    soulTable: 'mon/module/soul-table/soulTable.slim',
    // soul=table 子表格
    tableChild: 'mon/module/soul-table/tableChild',
    // soul-table 行列合并
    tableMerge: 'mon/module/soul-table/tableMerge',

    // 框架布局组件
    admin: 'pear/module/admin',
    // 数据菜单组件
    menu: 'pear/module/menu',
    // 内容页面组件
    frame: 'pear/module/frame',
    // 多选项卡组件
    tab: 'pear/module/tab',
    // 主题转换
    theme: 'pear/module/theme',
    // 全屏组件
    fullscreen: 'pear/module/fullscreen',
    // 加载按钮
    button: 'pear/module/button',
    // 加载组件
    loading: 'pear/module/loading',
    // 分步组件
    step: 'pear/module/step',
    // 卡片组件
    card: 'pear/module/card',
    // 图标选择
    iconPicker: "pear/module/iconPicker",
    // 图片裁剪
    cropper: "pear/module/cropper",
    // 页面加水印
    watermark: 'pear/module/watermark'
}).use(['jquery', 'layer', 'util', 'token'], function () {
    const $ = layui.jquery
    const layer = layui.layer
    const util = layui.util
    const token = layui.token

    // 系统配置
    const adminConfig = JSON.parse(sessionStorage.getItem('adminConfig')) || {};
    const jwtConfig = adminConfig.jwt || {}
    // 缓存中token键名
    const token_name = jwtConfig.tokenName || 'Mon-Auth-Token'
    // jquery全局支持token
    $.ajaxSetup({
        headers: { token_name: token.getToken() }
    })
    // 暴露layer
    window.layer = layer
    // 绑定全局事件
    util.on('lay-on', {
        // 图片预览
        'img-preview': function () {
            let url = this.src
            let alt = this.alt || ''
            if (url) {
                top.layer.photos({
                    photos: {
                        title: "图片预览",
                        data: [{ alt: alt, src: url }]
                    },
                    // 是否显示底部栏
                    footer: true,
                    shade: 0.75
                });
            }
        }
    });
});
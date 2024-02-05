/**
 * layui表单设计器
 */
layui.define(['form', 'jquery', 'layer', 'carousel', 'cascader', 'mUpload', 'xmSelect'], function (exports) {
    "use strict";

    // 模块名
    const MOD_NAME = 'formDesign'
    // 加载模块资源
    const modFile = layui.cache.modules[MOD_NAME];
    const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
    layui.link(modPath + '/form-design.css?v=' + (typeof window.version == 'string' ? window.version : Math.random()))

    const $ = layui.$,
        form = layui.form,
        layer = layui.layer,
        cascader = layui.cascader,
        mUpload = layui.mUpload,
        xmSelect = layui.xmSelect,
        carousel = layui.carousel,

        // 字符常量
        STR_HIDE = 'layui-hide', STR_EMPTY = '', STR_FORMDESIGN = 'form-simple', LAY_FORM_ITEM = 'layui-form-item',
        LAY_FORM_DIV = '</div>', LAY_INLINE_CLASS = 'layui-input-inline', LAY_BLOCK_CLASS = 'layui-input-block',
        LAY_INPUT_INLINE = '<div class="layui-input-inline">', LAY_COMPONENT_TOOLS = 'layui-component-tools',
        // 主模板
        TPL_MAIN = `<div id="tpl_main" class="tpl_main">从左侧拖入组件进行表单设计</div>`,
        TPL_RIGHT_MAIN = `<div id="tpl_right_main">请点击组件修改属性</div>`,
        // 缓存名
        FORMDESIGN_CACHE = 'form-design-mon', FORMCONFIG_CACHE = 'form-config-mon'

    // 外部接口
    const MODULE_FORMDESIGN_NAME = {
        config: {},
        index: layui[MOD_NAME] ? (layui[MOD_NAME].index + 10000) : 0,

        // 设置全局项
        set: function (options) {
            let that = this;
            that.config = $.extend({}, that.config, options);
            return that;
        },

        // 事件
        on: function (events, callback) {
            return layui.onevent.call(this, MOD_NAME, events, callback);
        }
    }

    // 操作当前实例
    const thisTags = function () {
        let that = this, options = that.config, id = options.id || that.index;
        // 记录当前实例对象
        thisTags.that[id] = that;
        return {
            config: options,
            // 重置实例
            reload: function (options) {
                that.reload.call(that, options);
            },
            // 获取实例
            instance: function () {
                return that
            },
            // 导入配置
            importConfig: function (data) {
                that.config.data = data;
                that.config.state = data[0];
                that.reloadComponent();
            }
        }
    }

    /**
     * 是否隐藏标签
     * @param {*} labelhide 
     * @param {*} data 
     * @returns 
     */
    const getBeforeLabel = function (labelhide = false, data) {
        let labelHtml = '<label class="layui-form-label';
        if (labelhide) {
            labelHtml += ' ' + 'layui-hide';
        }

        labelHtml += '"';
        if (data.labelwidth && data.labelwidth != 110) {
            labelHtml += 'style="width:' + data.labelwidth + 'px;"';
        }

        labelHtml += '>';
        if (data.required) {
            labelHtml += '<font color="red">* </font>';
        }
        labelHtml += data.label + '</label>';
        labelHtml += '<div class="' + LAY_BLOCK_CLASS + '"';
        let styleCSS = [];
        if (labelhide) {
            styleCSS.push('margin-left:0');
        }

        // 检查标签
        if (data.labelwidth && data.labelwidth != 110) {
            let labelwidth = Number(data.labelwidth) + 30;
            styleCSS.push('margin-left:' + labelwidth + 'px');
        }

        styleCSS = styleCSS.join(';');
        if (styleCSS) {
            labelHtml += 'style="' + styleCSS + '"';
        }

        labelHtml += '>';

        return labelHtml;
    }

    /**
     * ITEM前置模板
     * @param {IETM} data 
     * @returns 
     */
    const getBeforeItem = function (data) {
        let _BeforeItem = '<div id="' + data.name + '" class="layui-form-item" data-index="' + data.index + '" data-tag="' + data.tag + '"';
        if (data.width && data.width != 100) {
            _BeforeItem += 'style="width:' + data.width + '%"';
        }

        _BeforeItem += '>';
        return _BeforeItem;
    }

    /**
     * 获取表单配置信息
     */
    const getFormConfig = function () {
        const vals = form.val()
        const keys = []
        document.querySelectorAll('#formConfig .form-config-item').forEach(e => {
            keys.push(e.getAttribute('name'))
        })
        const result = {}
        for (let k in vals) {
            if (keys.includes(k)) {
                result[k] = vals[k]
            }
        }

        return result
    }

    // 构造器
    const Class = function (options) {
        let that = this;
        that.index = ++MODULE_FORMDESIGN_NAME.index;
        that.config = $.extend({}, that.config, MODULE_FORMDESIGN_NAME.config, options);
        that.render();
    };

    // 默认配置
    Class.prototype.config = {
        id: null,
        data: [],           // 当前元素集合
        eval: '',           // 当前HTML数据 
        count: 0,           // 当前组件总数
        state: null,        // 当前活动实例
        index: [],          // 组件分类索引
        itemIndex: {},      // 子组件元素索引
        master: undefined,  // 主界面拖拽实例
        upload: '',         // 文件上传URL
        preview: '/preview',// 预览地址
        region: []          // 省市区信息
    };

    // 重载实例
    Class.prototype.reload = function (options) {
        var that = this;

        // 防止数组深度合并
        layui.each(options, function (key, item) {
            if (layui._typeof(item) === 'array') delete that.config[key];
        });

        that.config = $.extend(true, {}, that.config, options);
        that.render();
    };

    // 语言标签
    Class.prototype.lang = {
        index: "序号",
        tag: "组件类型",
        label: "标签名",
        name: "<font color=\"red\">* </font>字段名",
        type: '表单类型',
        placeholder: '占位提示',
        default: '默认值',
        min: '最小',          // 当类型为number的时候
        max: '最大',
        data_min: '最小',     // 自动渲染组件
        data_max: '最大',
        maxlength: '文本长度', // text
        verify: '验证规则',
        width: '组件宽度',
        height: '组件高度',
        lay_skin: '样式',
        labelhide: '隐藏标签',
        labelwidth: '文本宽度',
        readonly: "只读属性",
        disabled: "禁用表单",
        required: "必填项",
        lay_search: '搜索模式',
        data_datetype: "日期类型",
        options: "选项",
        data_maxvalue: "最大值",
        data_minvalue: "最小值",
        data_dateformat: "显示格式",
        data_half: "显示半星",
        theme: "皮肤",
        data_theme: "主题",
        data_color: "颜色",
        data_length: "星星个数",
        interval: "间隔毫秒",
        data_range: '范围选择',
        data_step: '步长',
        data_input: '输入框',
        data_showstep: '显示断点',
        data_default: '默认值',
        data_parents: '关联父类',
        tips: '文字提示',
        size: '文件大小',
        data_size: '文件大小',
        data_accept: '上传类型',
        msg: '消息提示',
        offset: '提示位置',
        btnsize: '按钮大小',
        text: '文本',
        textarea: '多行文本',
        border: '分割线',
        column: '栅格列数',
        upload_url: '上传地址',
        url: '资源地址',
        method: '请求方式',
        anim: '动画',
        autoplay: '自动播放',
        arrow: '切换箭头',
        indicator: '指示器',
        imgs: '图片列表',
        defaultValues: '默认值',
        upload_value: '资源地址',
        source_type: '资源类型',
        controls: '控制器'
    }

    // 组件属性
    Class.prototype.fields = {
        input: {
            index: '-1',
            tag: 'input',
            label: "单行文本",
            name: '-1',
            type: 'text',
            placeholder: "请输入",
            data_default: '',
            labelwidth: '110',
            width: 100,
            maxlength: '',
            min: 0,
            max: 0,
            required: false,
            readonly: false,
            disabled: false,
            labelhide: false,
            verify: ''
        },
        textarea: {
            index: '-1',
            tag: 'textarea',
            name: '-1',
            label: "多行文本",
            placeholder: "请输入",
            data_default: '',
            maxlength: '',
            labelwidth: 110,
            width: 100,
            required: false,
            readonly: false,
            disabled: false,
            labelhide: false
        },
        radio: {
            index: '-1',
            tag: "radio",
            name: '-1',
            label: "单选框",
            data_default: '1',
            labelwidth: 110,
            width: 100,
            disabled: false,
            labelhide: false,
            options: [
                {
                    title: '男',
                    value: '1',
                },
                {
                    title: '女',
                    value: '2',
                }
            ]
        },
        checkbox: {
            index: '-1',
            tag: "checkbox",
            name: '-1',
            label: "多选框",
            defaultValues: ['write', 'read'],
            lay_skin: 'primary',
            labelwidth: 110,
            width: 100,
            disabled: false,
            labelhide: false,
            options: [
                {
                    title: '写作',
                    value: 'write',
                },
                {
                    title: '阅读',
                    value: 'read',
                },
                {
                    title: '游戏',
                    value: 'game',
                }
            ]
        },
        select: {
            index: '-1',
            tag: "select",
            name: '-1',
            data_default: '0',
            label: "下拉框",
            labelwidth: 110,
            width: 100,
            lay_search: false,
            disabled: false,
            required: false,
            labelhide: false,
            options: [
                {
                    title: '选项0',
                    value: '0',
                },
                {
                    title: '选项1',
                    value: '1',
                },
                {
                    title: '选项2',
                    value: '2',
                }
            ]
        },
        xmSelect: {
            index: '-1',
            tag: "xmSelect",
            name: '-1',
            defaultValues: ['0', '1'],
            label: "下拉多选框",
            labelwidth: 110,
            width: 100,
            lay_search: true,
            disabled: false,
            required: false,
            labelhide: false,
            options: [
                {
                    title: '选项0',
                    value: '0',
                },
                {
                    title: '选项1',
                    value: '1',
                },
                {
                    title: '选项2',
                    value: '2',
                }
            ]
        },
        date: {
            index: '-1',
            tag: "date",
            name: '-1',
            label: "日期组件",
            labelwidth: 110,
            width: 100,
            data_default: "",
            data_datetype: "date", // year month date time datetime = select
            data_dateformat: "yyyy-MM-dd",
            placeholder: 'yyyy-MM-dd',
            data_maxvalue: "9999-12-31",
            data_minvalue: "1900-01-01",
            data_range: false,        // switch
            readonly: false,
            disabled: false,
            required: false,
            labelhide: false,
        },
        colorpicker: {
            index: '-1',
            tag: "colorpicker",
            name: '-1',
            label: "颜色选择器",
            labelwidth: 110,
            width: 100,
            data_default: '#999999',
            // disabled: false,
            // required: false,
            labelhide: false,
        },
        slider: {
            index: '-1',
            tag: "slider",
            name: '-1',
            label: "滑块",
            labelwidth: 110,
            width: 100,
            data_max: 100,
            data_min: 0,
            data_step: 1,
            data_default: 10,
            data_theme: '#009688',
            data_input: false,
            data_showstep: false,
            // disabled: false,
            labelhide: false,
        },
        rate: {
            index: '-1',
            tag: "rate",
            name: '-1',
            label: "评分",
            labelwidth: 110,
            width: 100,
            data_default: 1,
            data_length: 5,
            data_theme: '#009688',
            data_half: false,
            readonly: false,
            labelhide: false,
        },
        switch: {
            index: '-1',
            tag: "switch",
            name: '-1',
            data_default: 0,
            label: "开关",
            labelwidth: 110,
            width: 100,
            disabled: false,
            labelhide: false,
        },
        address: {
            index: '-1',
            tag: "address",
            name: '-1',
            label: "详细地址",
            labelwidth: 110,
            width: 100,
            disabled: false,
            required: false,
            labelhide: false
        },
        upload: {
            index: '-1',
            tag: "upload",
            name: '-1',
            label: "文件上传",
            data_accept: 'file',
            upload_url: '/upload',
            data_size: 102400,
            labelwidth: 110,
            width: 100,
            disabled: false,
            required: false,
            labelhide: false
        },
        uploadInput: {
            index: '-1',
            tag: 'uploadInput',
            label: "上传输入框",
            name: '-1',
            data_default: '',
            data_accept: 'file',
            upload_url: '/upload',
            data_size: 102400,
            placeholder: "请上传",
            labelwidth: '110',
            width: 100,
            required: false,
            readonly: false,
            disabled: false,
            labelhide: false,
        },
        note: {
            index: '-1',
            tag: "note",
            name: '-1',
            textarea: '便签信息',
            width: 100,
        },
        subtraction: {
            index: '-1',
            tag: "subtraction",
            name: '-1',
            border: '',
            width: 100,
        },
        carousel: {
            index: '-1',
            tag: "carousel",
            name: '-1',
            height: 320,
            width: 100,
            anim: 'default',    // 轮播切换方式: default 左右切换 updown 上下切换 fade 渐隐渐显切换
            interval: 3000,     // 切换间隔，单位毫秒秒
            autoplay: true,     // 是否自动播放
            arrow: true,        // 切换箭头，hover 鼠标悬停显示 always 始终显示 none 始终不显示
            indicator: false,   // 指示器, inside 显示在容器内部 outside 显示在容器外部 none 不显示
            imgs: [
                'https://unpkg.com/outeres/demo/carousel/720x360-1.jpg',
                'https://unpkg.com/outeres/demo/carousel/720x360-2.jpg',
                'https://unpkg.com/outeres/demo/carousel/720x360-3.jpg'
            ],
        },
        button: {
            index: '-1',
            tag: "button",
            name: '-1',
            text: '按钮',
            theme: '',
            btnsize: '',
        },
        space: {
            index: '-1',
            tag: "space",
            name: '-1',
            height: 10, // 像素
        },
        grid: {
            index: '-1',
            tag: "grid",
            name: '-1',
            column: 2,
            children: [
                {
                    children: []
                },
                {
                    children: [],
                },
            ]
        },
        link: {
            index: '-1',
            tag: "link",
            name: '-1',
            data_default: '跳转链接',
            url: ''
        },
        img: {
            index: '-1',
            tag: "img",
            name: '-1',
            width: 100,
            upload_value: 'https://unpkg.com/outeres/demo/carousel/720x360-2.jpg',
        },
        video: {
            index: '-1',
            tag: "video",
            name: '-1',
            upload_value: 'https://www.runoob.com/try/demo_source/movie.mp4',
            controls: true,
            source_type: 'mp4',
            width: 100,
            height: 320,
        },
        audio: {
            index: '-1',
            tag: "audio",
            name: '-1',
            upload_value: 'https://chuangshicdn.data.mvbox.cn/music/yc/23/09/23/23092315212628657483.mp3',
            controls: true,
            source_type: 'mpeg',
            width: 100,
        },
    };

    // 获取组件JSON数据
    Class.prototype.getComponentJson = function (name) {
        let type = this.fields[name];
        try {
            return JSON.parse(JSON.stringify(type));
        } catch (error) {
            console.warn(name + ' is not existing');
        }
        return type;
    }

    // 初始化渲染
    Class.prototype.render = function () {
        let that = this, options = that.config;
        options.id = options.elem.replace('#', '');

        // 获取当前元素
        let othis = options.elem = $(options.elem);
        if (!othis[0]) return;

        $('#Propertie').html(TPL_RIGHT_MAIN);
        let arrs = ['sort_1', 'sort_2', 'sort_3'];
        for (let index = 0; index < arrs.length; index++) {
            const element = arrs[index];
            const getById = document.getElementById(element);
            that.config.index[element] = new Sortable(getById, {
                group: {
                    name: STR_FORMDESIGN,
                    pull: 'clone',
                    put: false,
                },
                sort: false,
                animation: 150,
                onChoose: function (evt) { },  // 拖动前显示
                onAdd: function (evt) { },     // 添加到这里
                onEnd: function (evt) { },     // 拖动结束
            });
        }

        // 主要接口
        options.master = new Sortable(document.getElementById(options.id), {
            group: {
                name: STR_FORMDESIGN,
            },
            animation: 150,
            ghostClass: "sortableghost",
            chosenClass: "sortablechosen",
            swapClass: 'highlight',
            filter: function (evt, item) {
                if ($(item).hasClass('tpl_main')) {
                    return true;
                }

                if ($(item).data('type') == 'space') {
                    return true;
                }

                return false;
            },
            onAdd: function (evt) {
                // FIX-BUG
                if (!options.count) {
                    evt.newIndex = options.count;
                }
                let item = evt.item, id = $(item).attr('id');
                let data = that.getComponentJson($(item).data('tag'));
                if (typeof id != 'undefined') {
                    data = JSON.parse(JSON.stringify(that.recursiveFindElem(options.data, id)));
                    that.recursiveDelete(options.data, id);
                }

                data.index = options.count++;
                data.name = data.tag + '_' + data.index;
                options.data.splice(evt.newIndex, 0, data);
                options.state = data;
                that.renderComponent(options.data, $('#' + options.id));
            },
            onUpdate: function (evt) {
                if (evt.to.id == options.id) {
                    [options.data[evt.newIndex], options.data[evt.oldIndex]] = [options.data[evt.oldIndex], options.data[evt.newIndex]];
                }
            },
            onEnd: function (evt) { }
        });

        // 查询下当前data的数据信息，是否为字符串
        if (typeof options.eval == 'string') {
            try {
                let data = JSON.parse($(options.eval).val().trim());
                options.data = data;
                options.state = data[0];
                options.count = data.length;
                that.reloadComponent();
            } catch (error) {
                // console.log(error)
                othis.append(TPL_MAIN);
                // layer.msg('初始化','info');
            }
        }
        else if (typeof options.eval == 'object') {
            try {
                let data = options.eval
                options.data = data;
                options.state = data[0];
                options.count = data.length;
                that.reloadComponent();
            } catch (error) {
                othis.append(TPL_MAIN);
            }
        }
        else {
            othis.append(TPL_MAIN);
        }

        // 对齐方式
        const alignType = form.val().align
        if (alignType == '1') {
            document.querySelector('#formBuilder').classList.add('vertical')
        } else {
            document.querySelector('#formBuilder').classList.remove('vertical')
        }

        that.events();
    };

    // 事件
    Class.prototype.events = function () {
        let that = this, options = that.config;

        // 公共的文件上传组件
        mUpload.render({
            elem: '#common-upload',
            url: options.upload,
            done: function (ret, index, upload, obj) {
                if (ret.code != '1') {
                    layer.msg(ret.msg, { icon: 2 });
                    return;
                }
                let element = that.recursiveFindElem(options.data, options.state.name);
                // 地址回填
                let item = obj.item
                // 上传配置
                let dataConfig = item.data()
                // 修正配置
                switch (dataConfig.type) {
                    case 'img':
                        element.imgs[dataConfig.index] = ret.data[0].url
                        break;
                    case 'upload_value':
                        element.upload_value = ret.data[0].url
                        break;
                }

                that.reloadComponent();
            },
        })

        // 上传
        $('body').on('click', '*[data-upload]', function (e) {
            const type = $(this).data('upload')
            const tag = $(this).data('tag')
            const index = $(this).parent('.' + LAY_INLINE_CLASS).index()

            $('#common-upload').attr('data-type', type).attr('data-tag', tag).attr('data-index', index).click()
        })

        // 解析组件属性
        $('body').on('click', '#' + options.id + ' .layui-form-item', function (e) {
            // 禁止冒泡 
            // 过滤元素中按钮
            if ($(e.toElement).hasClass('layui-btn') == false && $(e.toElement).hasClass('layui-upload-file') == false) {
                e.preventDefault();
                e.stopPropagation();
            }

            let othis = $(this), name = othis.attr('id');
            if (typeof name == 'undefined') {
                return true;
            }
            $('div.active').each(function (k, n) {
                $(n).removeClass('active');
            })
            $(othis).addClass('active');
            options.state = that.recursiveFindElem(options.data, name);
            that.getPropertieValues(options.state);
        })

        // 复制节点
        $('body').on('click', '#' + options.id + ' .layui-icon-picture-fine', function (e) {
            let othis = this;
            let copyElem = [];
            let name = $(othis).parents('.' + LAY_FORM_ITEM).attr('id');

            let cycleElem = function (array, name) {
                for (let index = 0; index < array.length; index++) {
                    const element = array[index];
                    if (element.name == name) {
                        copyElem = JSON.parse(JSON.stringify(element));
                        copyElem.index = options.count++;;
                        copyElem.name = copyElem.tag + '_' + copyElem.index;

                        // 节点插入
                        array.splice(index + 1, 0, copyElem);
                        break;
                    }

                    if (typeof element.children != 'undefined' && element.children.length) {
                        let subElem = element.children;
                        for (let i = 0; i < subElem.length; i++) {
                            if (subElem[i].children.length) {
                                let item = cycleElem(subElem[i].children, name);
                                if (item != [] && typeof item != 'undefined') {
                                    return item;
                                }
                            }
                        }
                    }
                }
            }

            cycleElem(options.data, name);
            options.state = copyElem;

            // 复制BUG 需要去重
            let nodes = [];
            let randRepeat = function (array) {
                for (let index = 0; index < array.length; index++) {
                    let element = array[index];
                    if (nodes.indexOf(element.name) != -1) {
                        element.name = element.name + 't';
                    }
                    nodes.push(element.name);
                    if (typeof element.children != 'undefined' && element.children.length) {
                        let subElem = element.children;
                        for (let i = 0; i < subElem.length; i++) {
                            if (subElem[i].children.length) {
                                randRepeat(subElem[i].children);
                            }
                        }
                    }
                }
            }

            randRepeat(options.data);
            that.reloadComponent();
        })

        // 删除节点
        $('body').on('click', '#' + options.id + ' .layui-icon-delete', function (e) {
            let othis = this;
            layer.confirm('确定要删除元素吗？', { title: 'Tips', icon: 3 }, function (index, layero) {
                let name = $(othis).parents('.' + LAY_FORM_ITEM).attr('id');
                // 点击删除后，返回为未定义
                options.state = that.recursiveDelete(options.data, name) || [];
                that.reloadComponent();
                layer.close(index);
            })
        })

        // 当前EVAL存在则进行数据赋值
        $('body').on('click', function (e) {
            try {
                if ($(options.eval).length) {
                    $(options.eval).val(JSON.stringify(options.data));
                }
            } catch (error) {
                console.warn(error);
            }
        })

        // 编辑标签
        $('body').on('keyup', '#Propertie #label', function (e) {
            $('#' + options.state.name).find('label:eq(0)').text($(this).val());
            let element = that.recursiveFindElem(options.data, options.state.name);
            element.label = $(this).val();
        })

        // 占位提示
        $('body').on('keyup', '#Propertie #placeholder', function (e) {
            $('#' + options.state.name).find(options.state.tag + ':eq(0)').prop('placeholder', $(this).val());
            let element = that.recursiveFindElem(options.data, options.state.name);
            element.placeholder = $(this).val();
        })

        // layui-change 更新后操作
        // layui-keyup 键入后操作
        $('body').on('change', '#Propertie .layui-change', function (e) {
            let othis = this;
            let oid = $(othis).attr('id');
            let oval = $(othis).val();
            if (oid == 'name') {
                let existing = that.recursiveFindElem(options.data, oval);
                if (oval.length <= 1 || existing) {
                    layer.msg('Logo is shorter or already exist', 'error');
                    return false;
                }
            }

            let element = that.recursiveFindElem(options.data, options.state.name);
            try {
                if (typeof element[oid] != 'undefined') {
                    element[oid] = oval;
                }
            } catch (error) {
                console.log('undefined element');
            }

            that.reloadComponent();
        })

        // 全局SELECT属性
        form.on('select(componentSelected)', function (data) {
            let field = $(data.elem).data('field'), element = that.recursiveFindElem(options.data, options.state.name);
            try {
                if (element.tag == 'grid') {
                    let children = element.children;
                    let length = children.length;
                    if (data.value > length) {
                        // 修复栅格的BUG
                        for (let i = 0, l = data.value - length; i < l; i++) {
                            //  添加元素
                            children.push({ children: [] });
                        }
                    } else if (data.value < length) {
                        let d = length - data.value;
                        for (let i = 0; i < children.length; i++) {
                            if (d <= 0) {
                                break;
                            }
                            // 当前无子类
                            if (!children[i].children.length) {
                                d--;
                                children.splice(i, 1);
                            }
                        }

                        // 如果过滤完还有的话
                        // 则还需要循环下
                        if (d >= 1) {
                            while (d) {
                                d--;
                                children.splice(d, 1);
                            }
                        }
                    }
                }
                element[field] = data.value;
            } catch (error) {
                console.warn('undefined element');
            }

            that.reloadComponent();
        })

        // 全局组件状态
        form.on('switch(componentChecked)', function (data) {
            let field = $(this).data('field'), element = that.recursiveFindElem(options.data, options.state.name);
            try {
                // 过滤主题
                if (field == 'lay_skin') {
                    element.lay_skin = data.elem.checked ? 'primary' : STR_EMPTY;
                } else {
                    element[field] = data.elem.checked ? true : false;
                }
            } catch (error) { }
            that.reloadComponent();
        })

        // 其他验证规则
        form.on('checkbox(verify)', function (data) {
            that.setInputVerify(data.elem.checked, $(this).val());
            let element = that.recursiveFindElem(options.data, options.state.name);
            let verify = element.verify == '' ? [] : element.verify.split('|');
            if (data.elem.checked) {
                verify.push(data.value);
            } else {
                verify.splice(data.value, 1);
            }

            element.verify = verify.join('|');
        })

        // 添加选项
        $('body').on('click', 'button.layui-add-option', function (click) {
            that.checkSelectRadio(options.state.tag, $('#Propertie #name').val(), null);
        })
        $('body').on('click', 'button.layui-add-img', function (click) {
            that.checkSelectRadio(options.state.tag, $('#Propertie #name').val(), null, true, 'imgs');
        })

        // 编辑radio checkbox 组件信息
        $('body').on('change', '#form-options .layui-input', function (click) {
            let othis = $(this), parentIndex = $(othis).parent('.' + LAY_INLINE_CLASS).index(),
                selfIndex = $(othis).index() - 1, val = $(othis).val(), field = $('#field').val();
            let element = that.recursiveFindElem(options.data, options.state.name);
            for (let key in element.options) {
                if (key == parentIndex) {
                    let item = element.options[key];
                    if (selfIndex) {
                        item.value = val;
                    } else {
                        item.title = val;
                    }
                }
            }

            that.reloadComponent();
        })
        $('body').on('change', '#form-imgs .layui-input', function (click) {
            let othis = $(this), parentIndex = $(othis).parent('.' + LAY_INLINE_CLASS).index(), val = $(othis).val()
            let element = that.recursiveFindElem(options.data, options.state.name);

            for (let key in element.imgs) {
                if (key == parentIndex) {
                    element.imgs[key] = val
                }
            }

            that.reloadComponent();
        })

        // 删除选项
        $('body').on('click', '#form-options .layui-icon-subtraction', function (click) {
            that.checkSelectRadio(options.state.tag, $('#Propertie #name').val(), $(this).prev().val(), false);
        })
        $('body').on('click', '#form-imgs .layui-icon-subtraction', function (click) {
            that.checkSelectRadio(options.state.tag, $('#Propertie #name').val(), this.previousSibling.previousSibling.value, false, 'imgs');
        })

        // 预览表单
        $('body').on('click', '.layui-btn-component', function (e) {
            const jsonData = JSON.stringify(options.data)
            if (jsonData == '' || jsonData == '[]' || jsonData == '{}') {
                layer.msg('无预览内容');
                return false;
            }
            localStorage.setItem(FORMDESIGN_CACHE, jsonData)
            const formConfig = getFormConfig()
            localStorage.setItem(FORMCONFIG_CACHE, JSON.stringify(formConfig))

            setTimeout(() => {
                layer.open({
                    type: 2,
                    title: '预览',
                    shadeClose: true,
                    area: ['860px', '640px'],
                    content: that.config.preview,
                    btn: ['复制HTML', '关闭'],
                    btn1: function (index, layero, that) {
                        // 获取 iframe 中元素的 jQuery 对象
                        let formContainer = layer.getChildFrame('#form-design-container', index);
                        let content = formContainer.html()
                        const dom = document.createElement("input");
                        dom.value = content;
                        document.body.appendChild(dom);
                        dom.select();
                        if (document.execCommand("copy")) {
                            layer.msg('复制成功');

                        }
                        document.body.removeChild(dom);
                        return false;
                    }
                });
            }, 100)
        })

        // 清空表单设计
        $('body').on('click', '.layui-form-clear', function (e) {
            layer.confirm('确定要清空表单设计吗？', { title: 'Tips', icon: 3 }, function (index, layero) {
                options.data = [];
                $('#' + options.id).html(TPL_MAIN);
                $('#Propertie').html(TPL_RIGHT_MAIN);
                layer.close(index);
            })
        })

        // 导出表单
        $('body').on('click', '.layui-btn-export', function (e) {
            $('#json-code').val(JSON.stringify(options.data, null, 4));
            $('#import-code').addClass(STR_HIDE);
            $('#copy-code').removeClass(STR_HIDE);
            layer.open({
                type: 1,
                title: '导出',
                offset: '130px',
                content: $('.layui-htmlview'),
                area: ['800px', '660px'],
                shade: false,
                resize: false,
                success: function (layero, index) { }
            });
        })

        // 复制代码
        $('body').on('click', '#copy-code', function (e) {
            let data = document.getElementById("json-code");
            data.select();
            if (document.execCommand('copy')) {
                layer.closeAll();
                layer.msg('复制成功');
            }

        })

        // 导入表单
        $('body').on('click', '.layui-btn-import', function (e) {
            $('#copy-code').addClass(STR_HIDE);
            $('#import-code').removeClass(STR_HIDE);
            layer.open({
                type: 1,
                title: '导入',
                offset: '130px',
                content: $('.layui-htmlview'),
                area: ['800px', '660px'],
                shade: false,
                resize: false,
                success: function (layero, index) {
                    $('body').on('click', '#import-code', function (e) {
                        try {
                            let data = $('#json-code').val();
                            options.data = JSON.parse(data);
                            options.state = options.data[0];
                            that.reloadComponent();
                            layer.close(index);
                        } catch (error) {
                            layer.msg('缺少参数', { icon: 2 });
                        }
                    })
                }
            });
        })

        // 切换表单对齐
        form.on('select(align-type-filter)', function (data) {
            console.log(data)
            if (data.value == '1') {
                document.querySelector('#formBuilder').classList.add('vertical')
            } else {
                document.querySelector('#formBuilder').classList.remove('vertical')
            }
        });
    };

    /**
     * 增删组件选项
     * @param {*} tag 
     * @param {*} name 
     * @param {*} value 
     * @param {*} action 
     */
    Class.prototype.checkSelectRadio = function (tag, name, value, action = true, keyName = 'options') {
        let options = this.config;
        let element = this.recursiveFindElem(options.data, name);
        if (action) {
            // 新增
            if (keyName == 'options') {
                element.options.splice(element.options.length, 0, {
                    title: '选项' + element.options.length,
                    value: 'value',
                    checked: false
                });
            } else if (keyName == 'imgs') {
                element.imgs.splice(element.imgs.length, 0, '');
            } else {
                console.error('组件选项类型不支持')
            }
        } else {
            // 删除
            for (const key in element[keyName]) {
                let item = element[keyName][key];
                let v = keyName == 'imgs' ? item : item.value
                if (v == value) {
                    element[keyName].splice(key, 1);
                    break;
                }
            }
        }

        this.reloadComponent();
    }

    /**
     * 设置表单验证规则
     * @param {*} checked 
     * @param {*} field 
     */
    Class.prototype.setInputVerify = function (checked = false, field = '') {
        let elem = this.config.state.name;
        let rules = $('#' + elem).find('input:eq(0)').attr('lay-verify') || [];
        if (typeof rules != 'object') {
            rules = rules.split('|');
        }
        if (checked) {
            rules[rules.length] = field;
            $('#' + elem).find('input:eq(0)').attr('lay-verify', rules.join('|'));
        } else {
            for (let index = 0; index < rules.length; index++) {
                const el = rules[index];
                if (el == field) {
                    rules.splice(index, 1);
                }
            }
            if (rules.length) {
                $('#' + elem).find('input:eq(0)').attr('lay-verify', rules.join('|'));
            }
            else {
                $('#' + elem).find('input:eq(0)').removeAttr('lay-verify');
            }
        }
    }

    /**
     * 获取HTML代码
     * @param {*} lable 
     * @param {*} id 
     * @param {*} value 
     * @param {*} classed 
     */
    Class.prototype.getPropertieHtml = function (lable, id, value, classed = '', attr = '') {
        let proHtml = '<div class="' + LAY_FORM_ITEM + '">';

        if (lable) {
            proHtml += '<label class="layui-form-label">' + lable + '</label>';
        }

        proHtml += LAY_INPUT_INLINE;
        proHtml += '<input type="text"';
        if (id) {
            proHtml += 'id="' + id + '"';
        }
        proHtml += 'class="layui-input ' + classed + '"';
        proHtml += 'value="' + value + '" ' + attr + '>';

        proHtml += LAY_FORM_DIV + LAY_FORM_DIV;
        return proHtml;
    }

    /**
     * 模板碎片
     * @param {*} lable 
     * @returns 
     */
    Class.prototype.getPropertieDebris = function (lable, hide = '') {
        let proHtml = '<div class="' + LAY_FORM_ITEM + ' ' + hide + '">';
        if (lable) {
            proHtml += '<label class="layui-form-label">' + lable + '</label>';
        }
        proHtml += LAY_INPUT_INLINE;
        return proHtml;
    }

    /**
     * 获取标签文字
     * @param {*} field 
     */
    Class.prototype.getLang = function (field) {
        if (typeof this.lang[field] != 'undefined') {
            return this.lang[field];
        }
        else {
            return field + ' undefined';
        }
    }

    /**
     * 获取表单属性
     * @param {*} elem 
     * @param {*} type 
     */
    Class.prototype.getPropertieValues = function (data, type) {
        let that = this, options = that.config, optionsHtml = STR_EMPTY;
        for (let key in data) {
            // 过滤index
            if (key == 'index') {
                continue;
            }

            let value = data[key];
            // 过滤信息
            if (key == 'options' || key == 'children' || key == 'imgs') { }
            else {
                optionsHtml += that.getPropertieDebris(that.getLang(key));
            }
            switch (key) {
                case 'tag':
                    optionsHtml += '<input class="layui-input layui-disabled" disabled value="' + value + '" data-type="' + key + '">';
                    break;
                case 'label':
                case 'placeholder': // 标签和描述占位符
                    optionsHtml += '<input class="layui-input layui-keyup" value="' + value + '" id="' + key + '">';
                    break;
                case 'name':
                case 'msg':
                case 'text':
                case 'color':
                case 'default':
                case 'data_default':
                case 'data_theme':
                case 'upload_url':
                case 'url':
                case 'interval':
                case 'source_type':
                    optionsHtml += '<input class="layui-input layui-change" value="' + value + '" id="' + key + '">';
                    break;
                case 'upload_value':
                    optionsHtml += '<input class="layui-input layui-change" value="' + value + '" id="' + key + '">';
                    optionsHtml += '<button type="button" class="layui-btn layui-btn-sm layui-bg-blue" data-upload="upload_value" data-tag="' + data.tag + '">上传资源</button>'
                    break;
                case 'type':
                    optionsHtml += '<select lay-filter="componentSelected" data-field="type">';
                    const inputType = [
                        {
                            title: '文本',
                            value: 'text',
                        },
                        {
                            title: '密码',
                            value: 'password',
                        },
                        {
                            title: '数字',
                            value: 'number',
                        },
                    ];
                    for (let index = 0; index < inputType.length; index++) {
                        const element = inputType[index];
                        optionsHtml += '<option value="' + element.value + '"';
                        if (element.value == data.type) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + element.title + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'method':
                    optionsHtml += '<select lay-filter="componentSelected" data-field="method">';
                    const mehtodType = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];
                    mehtodType.forEach(item => {
                        let selected = (item == data.method) ? 'selected' : ''
                        optionsHtml += `<option value="${item}" ${selected}>${item}</option>`;
                    })
                    optionsHtml += '</select>';
                    break;
                case 'anim':
                    optionsHtml += '<select lay-filter="componentSelected" data-field="anim">';
                    const animType = [
                        { title: '左右切换', value: 'default' },
                        { title: '上下切换', value: 'updown' },
                        { title: '渐隐渐显', value: 'fade' }
                    ];
                    animType.forEach(item => {
                        let selected = (item.value == data.anim) ? 'selected' : ''
                        optionsHtml += `<option value="${item.value}" ${selected}>${item.title}</option>`;
                    })
                    optionsHtml += '</select>';
                    break;
                case 'data_datetype':
                    optionsHtml += '<select lay-filter="componentSelected" data-field="data_datetype" >';
                    const date_types = [
                        {
                            title: '默认',
                            value: 'date',
                        },
                        {
                            title: '年选择器',
                            value: 'year',
                        },
                        {
                            title: '年月选择器',
                            value: 'month',
                        },
                        {
                            title: '时间选择器',
                            value: 'time',
                        },
                        {
                            title: '日期时间选择器',
                            value: 'datetime',
                        },
                    ];
                    for (let index in date_types) {
                        const element = date_types[index];
                        optionsHtml += '<option value="' + element.value + '"';
                        if (element.value == data.data_datetype) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + element.title + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'data_dateformat':
                    optionsHtml += '<select lay-filter="componentSelected" data-field="data_dateformat" >';
                    const dateformat = ['yyyy-MM-dd HH:mm:ss', 'yyyy-MM-dd', 'yyyy年MM月dd日', 'dd/MM/yyyy', 'yyyyMM', 'H点M分', 'yyyy-MM', 'yyyy年M月d日H时m分s秒'];
                    for (let index in dateformat) {
                        const element = dateformat[index];
                        optionsHtml += '<option value="' + element + '"';
                        if (element == data.data_dateformat) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + element + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'offset':
                    const offsetAttrs = { 1: '上', 2: '左', 3: '下', 4: '右' };
                    optionsHtml += '<select lay-filter="componentSelected" data-field="offset" >';
                    for (let key in offsetAttrs) {
                        optionsHtml += '<option value="' + key + '" ';
                        if (key == data.offset) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + offsetAttrs[key] + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'theme':
                    const themeAttrs = {
                        '': '默认',
                        'layui-btn-normal': '百搭',
                        'layui-btn-warm': '暖色',
                        'layui-btn-danger': '警告',
                        'layui-btn-disabled': '禁用'
                    };
                    optionsHtml += '<select lay-filter="componentSelected" data-field="theme">';
                    for (let key in themeAttrs) {
                        optionsHtml += '<option value="' + key + '" ';
                        if (key == data.theme) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + themeAttrs[key] + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'btnsize':
                    const btnsizeAttrs = {
                        '': '默认按钮',
                        'layui-btn-lg': '大型按钮',
                        'layui-btn-sm': '小型按钮',
                        'layui-btn-xs': '迷你按钮',
                        'layui-btn-fluid': '流体按钮'
                    };
                    optionsHtml += '<select lay-filter="componentSelected" data-field="btnsize">';
                    for (let key in btnsizeAttrs) {
                        optionsHtml += '<option value="' + key + '" ';
                        if (key == data.btnsize) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + btnsizeAttrs[key] + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'data_accept':
                    optionsHtml += '<select lay-filter="componentSelected" data-field="data_accept">';
                    const acceptArr = [
                        {
                            title: '文件',
                            value: 'file',
                        },
                        {
                            title: '视频',
                            value: 'video',
                        },
                        {
                            title: '音频',
                            value: 'audio',
                        },
                        {
                            title: '图片',
                            value: 'images',
                        }
                    ];
                    for (let index in acceptArr) {
                        const element = acceptArr[index];
                        optionsHtml += '<option value="' + element.value + '"';
                        if (element.value == data.data_accept) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + element.title + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'max':
                case 'min':
                case 'size':
                case 'height':
                case 'data_max':
                case 'data_min':
                case 'data_step':
                case 'data_size':
                    optionsHtml += '<input type="number" min="0" class="layui-input layui-change" value="' + value + '" id="' + key + '" >';
                    break;
                case 'data_maxvalue':
                case 'data_minvalue':
                    optionsHtml += '<input class="layui-input layui-change" value="' + value + '" id="' + key + '" >';
                    break;
                case 'width': // 滑块操作
                    optionsHtml += '<div data-min="20" data-max="100" id="' + key + '" class="layui-sliders" data-value="' + value + '"></div>';
                    break;
                case 'labelwidth':
                    optionsHtml += '<div data-min="60" data-max="250" id="' + key + '" class="layui-sliders" data-value="' + value + '"></div>';
                    break;
                case 'maxlength':
                    optionsHtml += '<input type="number" min="1" id="maxlength" class="layui-input layui-change" value="' + (value ? value : 250) + '">';
                    break;
                case 'minmax':
                    for (let key in data.minmax) {
                        let num = data.minmax[key];
                        optionsHtml += '<input id="' + num.title + '" type="number" class="layui-input layui-minmax" value="' + num.value + '">';
                        if (key == 0) {
                            optionsHtml += '<em>-</em>';
                        }
                    }
                    break;
                case 'lay_skin':
                case 'required':
                case 'readonly':
                case 'disabled':
                case 'labelhide':
                case 'lay_search':
                case 'data_range':
                case 'data_showstep':
                case 'data_half':
                case 'data_input':
                case 'data_parents':
                case 'autoplay':
                case 'arrow':
                case 'indicator':
                case 'controls':
                    optionsHtml += '<input type="checkbox" lay-skin="switch" lay-filter="componentChecked" ';
                    if (data[key]) {
                        optionsHtml += 'checked=""';
                    }
                    optionsHtml += 'data-field="' + key + '">';
                    break;
                case 'verify':
                    const verify = [
                        {
                            title: '手机',
                            value: 'phone'
                        },
                        {
                            title: '邮箱',
                            value: 'email'
                        },
                        {
                            title: '网址',
                            value: 'url'
                        },
                        {
                            title: '数字',
                            value: 'number'
                        },
                        {
                            title: '日期',
                            value: 'date'
                        },
                        {
                            title: '身份证',
                            value: 'identity'
                        },
                    ];

                    for (let key in verify) {
                        let check = verify[key];
                        optionsHtml += '<input type="checkbox" lay-skin="primary" lay-filter="verify" value="' + check.value + '"';
                        optionsHtml += 'title="' + check.title + '"';
                        if (data.verify.indexOf(check.value) != -1) {
                            optionsHtml += 'checked=""';
                        }
                        optionsHtml += '>';
                    }
                    break;
                case 'maxlength':
                case 'data_length':
                    optionsHtml += '<input type="number" min="1" id="' + key + '"  class="layui-input layui-change" value="' + value + '">';
                    break;
                case 'textarea':
                    optionsHtml += '<textarea class="layui-textarea layui-change" id="' + key + '" >' + value + '</textarea>';;
                    break;
                case 'border':
                    const borderAttrs = {
                        '': '默认',
                        'layui-border-red': '赤色',
                        'layui-border-orange': '橙色',
                        'layui-border-green ': '墨绿色',
                        'layui-border-cyan': '青色',
                        'layui-border-blue': '蓝色',
                        'layui-border-black': '黑色',
                    };
                    optionsHtml += '<select lay-filter="componentSelected" data-field="border">';
                    for (let key in borderAttrs) {
                        optionsHtml += '<option value="' + key + '" ';
                        if (key == data.border) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + borderAttrs[key] + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'options':
                    optionsHtml += this.formOptionHeader();
                    for (let key in data.options) {
                        let option = data.options[key];
                        optionsHtml += LAY_INPUT_INLINE;
                        optionsHtml += '<i class="layui-icon layui-icon-slider"></i>';
                        optionsHtml += '<input class="layui-input" value="' + option.title + '" >';
                        optionsHtml += '<input class="layui-input" value="' + option.value + '" >';
                        optionsHtml += '<i class="layui-icon layui-icon-subtraction"></i>';
                        // optionsHtml += '<input type="checkbox" name="c[]">';
                        optionsHtml += LAY_FORM_DIV;
                    }
                    optionsHtml += '<div class="layui-input-inline layui-inlioc">';
                    optionsHtml += '<button type="button" class="layui-btn layui-btn-xs layui-add-option">添加</button>';
                    optionsHtml += LAY_FORM_DIV
                    optionsHtml += LAY_FORM_DIV + LAY_FORM_DIV;
                    break;
                case 'imgs':
                    optionsHtml += this.formImgsHeader()
                    data.imgs.forEach(item => {
                        optionsHtml += LAY_INPUT_INLINE;
                        optionsHtml += '<i class="layui-icon layui-icon-slider"></i>';
                        optionsHtml += '<input class="layui-input" value="' + item + '" >';
                        optionsHtml += '<i class="layui-icon layui-icon-upload-drag" data-upload="img" data-tag="' + data.tag + '"></i>';
                        optionsHtml += '<i class="layui-icon layui-icon-subtraction"></i>';
                        optionsHtml += LAY_FORM_DIV;
                    })

                    optionsHtml += '<div class="layui-input-inline layui-inlioc">';
                    optionsHtml += '<button type="button" class="layui-btn layui-btn-xs layui-add-img">添加</button>';
                    optionsHtml += LAY_FORM_DIV
                    optionsHtml += LAY_FORM_DIV + LAY_FORM_DIV;
                    break;
                case 'column':
                    const columnAttrs = [2, 3, 4];
                    optionsHtml += '<select lay-filter="componentSelected" data-field="column">';
                    for (let i in columnAttrs) {
                        let val = columnAttrs[i];
                        optionsHtml += '<option value="' + val + '" ';
                        if (val == data.column) {
                            optionsHtml += 'selected';
                        }
                        optionsHtml += '>' + val + '</option>';
                    }
                    optionsHtml += '</select>';
                    break;
                case 'defaultValues':
                    const optionsData = data.options.map(item => {
                        return {
                            name: item.title,
                            value: item.value,
                            selected: data.defaultValues.includes(item.value)
                        }
                    })
                    const optionsJSON = JSON.stringify(optionsData)
                    optionsHtml += `<div class="defaultValues_select hidden">${optionsJSON}</div>`
                    break;
                default:
                    break;
            }

            optionsHtml += '</div></div>';
        }
        $('#Propertie').html(optionsHtml);
        form.render(null, 'Propertie');

        // 最大化时间回调操作
        var datetime = $('#data_maxvalue, #data_minvalue');
        datetime.each(function (index, obj) {
            layui.laydate.render({
                elem: this,
                type: 'date',
                format: 'yyyy-MM-dd',
                done: function (value, date, endDate) {
                    let element = that.recursiveFindElem(options.data, options.state.name);
                    try {
                        element[$(obj).attr('id')] = value;
                    } catch (error) {
                        console.log(error);
                    }
                    that.reloadComponent();
                }
            });
        })

        // 选项拖动接口
        if ($('#Propertie #form-options').length) {
            createSortable('form-options', '.layui-icon-slider')
        }
        // 图片列表拖到接口
        if ($('#Propertie #form-imgs').length) {
            createSortable('form-imgs', '.layui-icon-slider')
        }

        // 创建拖动对象
        function createSortable(id, handle) {
            return new Sortable(document.getElementById(id), {
                handle: handle,
                animation: 150,
                onAdd: function (evt) { },
                onUpdate: function (evt) {
                    let element = that.recursiveFindElem(options.data, options.state.name);
                    try {
                        let op = element.options;
                        [op[evt.newIndex], op[evt.oldIndex]] = [op[evt.oldIndex], op[evt.newIndex]];
                        that.reloadComponent();
                    } catch (error) { }
                },
                onEnd: function (evt) { }
            });
        }

        layui.each($('.defaultValues_select'), function (key, elem) {
            const dataJSON = elem.innerHTML || '[]'
            const data = JSON.parse(dataJSON)
            elem.innerHTML = ''
            elem.classList.remove('hidden')
            xmSelect.render({
                el: elem,
                data: data,
                autoRow: true,
                paging: true,
                pageSize: 5,
                toolbar: {
                    show: true,
                },
                on: (obj) => {
                    const value = obj.arr
                    let element = that.recursiveFindElem(options.data, options.state.name);
                    try {
                        element.defaultValues = value.map(item => item.value)
                    } catch (error) {
                        console.warn(error);
                    }
                    that.reloadComponent();
                }
            })
        })

        layui.each($(".layui-sliders"), function (key, elem) {
            let othat = $(this), obj = othat.attr('id'), val = othat.data('value'), min = othat.data('min') || 10, max = othat.data('max') || 100, theme = othat.data('theme') || '#009688';
            layui.slider.render({
                elem: elem,
                min: min,
                max: max,
                input: true,
                theme: theme,
                value: val,
                step: 2,
                change: function (value) {
                    if (value <= min || isNaN(value)) {
                        value = min;
                    }

                    let element = that.recursiveFindElem(options.data, options.state.name);
                    try {
                        element[obj] = value
                    } catch (error) {
                        console.warn(error);
                    }
                    that.reloadComponent();
                }
            })
        })
    }

    /**
     * 获取选项表头
     * @param {*} options 
     * @returns 
     */
    Class.prototype.formOptionHeader = function (options = 'form-options') {
        let _options = '<fieldset class="layui-elem-field layui-elem-field-user layui-field-title">';
        _options += '<legend>选项</legend>';
        _options += ' </fieldset>';
        _options += '<div id="' + options + '" class="' + LAY_FORM_ITEM + '">';
        return _options;
    }

    /**
     * 获取图片列表头
     * @param {*} options 
     * @returns 
     */
    Class.prototype.formImgsHeader = function (options = 'form-imgs') {
        let _options = '<fieldset class="layui-elem-field layui-elem-field-user layui-field-title">';
        _options += '<legend>图片列表</legend>';
        _options += ' </fieldset>';
        _options += '<div id="' + options + '" class="' + LAY_FORM_ITEM + '">';
        return _options;
    }

    /**
     * 获取工具栏HTML
     * @returns 
     */
    Class.prototype.getToolsHtml = function () {
        let tools = '<div class="' + LAY_COMPONENT_TOOLS + '">';
        tools += ' <i class="layui-icon layui-icon-picture-fine" title="复制" ></i>';
        tools += ' <i class="layui-icon layui-icon-delete" title="删除"></i>';
        tools += LAY_FORM_DIV;
        return tools;
    }

    /**
     * 获取组件代码
     * @param {*} data 
     * @param {*} elem 
     */
    Class.prototype.renderComponent = function (data, elem) {
        let that = this, outerHTML = STR_EMPTY, options = that.config;

        elem.empty(STR_EMPTY);
        for (let index = 0; index < data.length; index++) {
            let element = data[index];
            outerHTML = that.renderComponentItem[element.tag].render(element);
            elem.append($(outerHTML).append(that.getToolsHtml()).prop("outerHTML"));
            switch (element.tag) {
                case 'input':
                    break;
                case 'upload':
                    break;
                case 'date':
                    const datetime = $('*[lay-datetime]');
                    datetime.each(function (key, obj) {
                        let t = $(obj).data('datetype') || 'datetime',
                            f = $(obj).data('dateformat') || 'yyyy-MM-dd HH:mm:ss',
                            r = $(obj).data('range') || false,
                            max = $(obj).data('maxvalue') || '2222-12-31',
                            min = $(obj).data('minvalue') || '1930-01-01',
                            default_value = $(obj).data('default') || ''

                        layui.laydate.render({
                            elem: this,
                            type: t,
                            range: r,
                            rangeLinked: true,
                            fullPanel: true,
                            max: max,
                            min: min,
                            format: f,
                            value: default_value,
                            done: function (value, date, end_date) {
                                console.log(value, date, end_date);
                            }
                        });
                    })
                    break;
                case 'colorpicker':
                    const picker = $('*[lay-colorpicker]');
                    picker.each(function (index, elem) {
                        let name = $(elem).attr("lay-colorpicker");
                        layui.colorpicker.render({
                            elem: this,
                            color: $('input[name=' + name + ']').val(),
                            predefine: true,
                            alpha: true,
                            done: function (color) {
                                $('input[name=' + name + ']').val(color);
                            }
                        });
                    })
                    break;
                case 'slider':
                    const slider = $('*[lay-slider]');
                    slider.each(function (index, elem) {
                        let that = $(this),
                            type = that.data('type') || 'default',
                            min = that.data('min') || 0,
                            max = that.data('max') || 100,
                            theme = that.data('theme') || '#1890ff',
                            step = that.data('step') || 1,
                            input = that.data('input') || false,
                            showstep = that.data('showstep') || false;

                        // 获取滑块默认值
                        let name = $(elem).attr("lay-slider");
                        let value = $('input[name=' + name + ']').val() || element.data_default;

                        layui.slider.render({
                            elem: elem,
                            type: type,
                            min: min,
                            max: max,
                            step: step,
                            showstep: showstep,
                            theme: theme,
                            input: input,
                            value: value,
                            change: function (value) {
                                if (value <= min || isNaN(value)) {
                                    value = min;
                                }

                                $('input[name=' + name + ']').val(value);
                            }
                        })
                    })
                    break;
                case 'rate':
                    let rate = $('*[lay-rate]');
                    rate.each(function (index, elem) {
                        let that = $(this),
                            theme = that.data('theme') || '#1890ff',
                            length = that.data('length') || 5,
                            half = that.data('half') || false,
                            readonly = that.data('readonly') || false;
                        let name = $(elem).attr("lay-rate");
                        let el = $('input[name=' + name + ']');
                        let value = el.val() || that.data('default');
                        layui.rate.render({
                            elem: elem,
                            half: half,
                            length: length,
                            theme: theme,
                            readonly: readonly,
                            value: value,
                            choose: function (value) {
                                el.val(value);
                            }
                        })
                    })
                    break;
                case 'address':
                    let elObj = [];
                    let caItem = 'input#' + element.name;
                    elObj[index] = cascader({
                        elem: caItem,
                        options: options.region,
                        clearable: true,
                        filterable: true,
                        showAllLevels: true,
                        disabled: element.disabled,
                        placeholder: '请选择省市区',
                        props: {
                            value: 'code',
                            label: 'name',
                            children: 'children',
                            strictMode: true,
                        }
                    })

                    break;
                case 'grid':
                    let children = $('#' + element.name + ' .children');
                    let childItem = []
                    $.each(children, function (index, item) {
                        that.gridtabSortable(item);
                        childItem[index] = item;
                    })

                    $.each(element.children, function (index, item) {
                        if (item.children.length) {
                            that.renderComponent(item.children, $(childItem[index]));
                        }
                    })
                    break;
                case 'xmSelect':
                    let data = element.options.map(item => {
                        return {
                            name: item.title,
                            value: item.value,
                            selected: element.defaultValues.includes(item.value),
                        }
                    })
                    xmSelect.render({
                        el: `#${element.name}_box`,
                        name: element.name,
                        data: data,
                        layVerify: element.required ? 'required' : '',
                        layVerType: 'tips',
                        filterable: element.lay_search,
                        disabled: element.disabled,
                        autoRow: true,
                        paging: true,
                        pageSize: 5,
                        toolbar: {
                            show: true,
                        }
                    })
                    break;
                case 'carousel':
                    carousel.render({
                        elem: `#${element.name}_box`,
                        anim: element.anim,
                        autoplay: element.autoplay,
                        interval: parseInt(element.interval, 10) > 1000 ? element.interval : 1000,
                        arrow: element.arrow ? 'hover' : 'none',
                        indicator: element.indicator ? 'inside' : 'none',
                        width: 'auto',
                        height: element.height + 'px',
                    });
                    break;
                default:
                    break;
            }

            if (typeof options.state != 'undefined') {
                that.getPropertieValues(options.state);
            } else if (options.data.length) {
                options.state = options.data[options.data.length - 1];
                that.getPropertieValues(options.state);
            }
        }

        // 取消其他活动选项
        $('#' + options.id + ' div.active').each(function (k, n) {
            $(n).removeClass('active');
        })

        if (typeof options.state != undefined) {
            $('div#' + options.state.name).addClass('active');
        }

        // 渲染表单
        form.render();
    }

    /**
     * 重新渲染组件
     */
    Class.prototype.reloadComponent = function () {
        this.renderComponent(this.config.data, $('#' + this.config.id));
    }

    /**
     * 渲染组件HTML
     */
    Class.prototype.renderComponentItem = {
        input: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += '<input lay-vertype="tips" type="' + data.type + '" name="' + data.name + '" class="layui-input"';
                html += 'value="' + data.data_default + '" placeholder="' + data.placeholder + '"';

                // 限定数字格式
                if (data.type == 'number') {
                    if (data.min) {
                        html += 'min="' + data.min + '"';
                    }
                    if (data.max) {
                        html += 'max="' + data.max + '"';
                    }

                } else {
                    if (data.maxlength) {
                        html += 'maxlength="' + data.maxlength + '"';
                    }
                }

                // 禁用只读表单
                if (data.readonly) {
                    html += 'readonly=""';
                }

                if (data.disabled) {
                    html += 'disabled=""';
                }

                if (data.verify) {
                    html += 'lay-verify="' + data.verify + '"';
                }

                html += '>';
                html += '</div></div>';
                return html;
            },
        },
        textarea: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += '<textarea name="' + data.name + '" class="layui-textarea" lay-vertype="tips" placeholder="' + data.placeholder + '"';

                if (data.required) {
                    html += 'lay-verify="required"';
                }
                if (data.readonly) {
                    html += 'readonly=""';
                }
                if (data.disabled) {
                    html += 'disabled=""';
                }

                if (data.maxlength) {
                    html += 'maxlength="' + data.maxlength + '"';
                }

                html += '>' + data.data_default + '</textarea>';
                html += '</div></div>';
                return html;
            }
        },
        radio: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                if (data.options.length) {
                    for (let index = 0; index < data.options.length; index++) {
                        let elem = data.options[index];
                        html += '<input type="radio" name="' + data.name + '" value="' + elem.value + '" title="' + elem.title + '"';
                        if (elem.value == data.data_default) {
                            html += 'checked=""';
                        }
                        if (data.disabled) {
                            html += 'disabled=""';
                        }

                        html += '>';
                    }
                }

                html += '</div></div>';
                return html;
            }
        },
        checkbox: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                if (data.options.length) {
                    for (let index = 0; index < data.options.length; index++) {
                        let elem = data.options[index];
                        let name = data.name;
                        if (data.name) {
                            name += '[' + elem.value + ']';
                        }
                        html += '<input type="checkbox" name="' + name + '" lay-skin="' + data.lay_skin + '" value="' + elem.value + '" title="' + elem.title + '"';
                        if (data.defaultValues.includes(elem.value)) {
                            html += 'checked=""';
                        }
                        if (data.disabled) {
                            html += 'disabled=""';

                        }
                        html += '>';
                    }
                }
                html += '</div></div>';
                return html;
            }
        },
        select: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += '<select name="' + data.name + '"';

                if (data.searchMode) {
                    html += 'lay-search=""';
                }

                if (data.required) {
                    html += 'lay-verify="required"';
                }

                if (data.disabled) {
                    html += 'disabled=""';
                }

                html += '>';
                // html += '<option value="">请选择</option>';
                if (data.options.length) {
                    for (let index = 0; index < data.options.length; index++) {
                        let elem = data.options[index];
                        let selected = elem.value == data.data_default ? 'selected' : ''
                        html += `<option value="${elem.value}" ${selected}>${elem.title}</option>`;
                    }
                }
                html += '</select>';
                html += '</div></div>';
                return html;
            }
        },
        xmSelect: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += `<div id="${data.name}_box"></div>`
                html += '</div></div>';
                return html
            }
        },
        date: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += '<input type="text" name="' + data.name + '" class="layui-input" placeholder="' + data.placeholder + '" lay-datetime="' + data.name + '" data-default="' + data.data_default + '" ';
                if (data.data_range) {
                    html += 'data-range="true"';
                }

                if (data.data_datetype) {
                    html += 'data-datetype="' + data.data_datetype + '"';
                }

                if (data.data_dateformat) {
                    html += 'data-dateformat="' + data.data_dateformat + '"';
                }

                if (data.data_maxvalue) {
                    html += 'data-maxvalue="' + data.data_maxvalue + '"';
                }
                if (data.data_minvalue) {
                    html += 'data-minvalue="' + data.data_minvalue + '"';
                }

                if (data.required) {
                    html += 'lay-verify="required"';
                }

                if (data.disabled) {
                    html += 'disabled=""';
                }
                if (data.readonly) {
                    html += 'readonly=""';
                }

                html += '>';
                html += '</div></div>';
                return html;
            }
        },
        colorpicker: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += `<input class="layui-input layui-hide ${data.name}" name="${data.name}" value="${data.data_default}" />`;
                html += '<div lay-colorpicker="' + data.name + '" data-value="' + data.data_default + '"></div>';
                html += '</div></div>';
                return html;
            }
        },
        slider: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += '<input class="layui-input layui-hide ' + data.name + '" name="' + data.name + '"/>';
                html += '<div class="lay-slider" lay-slider="slider" data_default="' + data.data_default + '" data-theme="' + data.data_theme + '"';

                if (data.data_showstep) {
                    html += 'data-showstep="' + data.data_showstep + '"';
                }

                if (data.data_step) {
                    html += 'data-step="' + data.data_step + '"';
                }

                if (data.data_max) {
                    html += 'data-max="' + data.data_max + '"';
                }
                if (data.data_min) {
                    html += 'data-min="' + data.data_min + '"';
                }

                if (data.data_input) {
                    html += 'data-input="' + data.data_input + '"';
                }

                if (data.disabled) {
                    html += 'disabled=""';
                }
                if (data.readonly) {
                    html += 'readonly=""';
                }

                html += '></div>';
                html += '</div></div>';
                return html;
            }
        },
        rate: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                html += '<input class="layui-input layui-hide ' + data.name + '" name="' + data.name + '"/>';
                html += '<div lay-rate="' + data.name + '" data-default="' + data.data_default + '" data-class="' + data.name + '" data-theme="' + data.data_theme + '"';

                if (data.data_half) {
                    html += 'data-half="true"';
                }

                if (data.data_length) {
                    html += 'data-length="' + data.data_length + '"';
                }

                if (data.readonly) {
                    html += 'data-readonly="true"';
                }

                html += '></div>';
                html += '</div></div>';
                return html;
            }
        },
        switch: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);
                const checked = data.data_default == '1' ? 'checked' : ''
                const disabled = data.disabled ? 'disabled' : ''
                html += `<input type="checkbox" name="${data.name}" value="1" title="ON|OFF" lay-skin="switch" ${checked} ${disabled} />`;
                html += '</div></div>';
                return html;
            }
        },
        address: {
            render: function (data) {
                let html = getBeforeItem(data);
                let disabled = data.disabled == true ? 'disabled' : ''
                html += getBeforeLabel(data.labelhide, data);
                html += `<input id="${data.name}" class="layui-input" />`;
                html += `<textarea id="${data.name}_detail" placeholder="详情地址" class="layui-textarea" ${disabled} style="margin-top: 8px"></textarea>`;
                html += '</div></div>';
                return html;
            }
        },
        upload: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);

                html += `<div class="layui-imagesbox">
                            <div class="layui-input-inline">
                                <div class="layui-upload-drag">
                                    <i class="layui-icon layui-icon-upload"></i>
                                    <p>点击上传，或将文件拖拽到此处</p>
                                </div>
                            </div>
                        </div>`

                return html
            }
        },
        uploadInput: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += getBeforeLabel(data.labelhide, data);

                const required = data.required ? 'lay-verify="required"' : ''
                const readonly = data.readonly ? 'readonly="readonly"' : ''
                const disabled = data.disabled ? 'disabled="disabled"' : ''
                const inputHTML = `<input class="layui-input" type="text" name="${data.name}" placeholder="${data.placeholder}" value="${data.data_default}" ${disabled} ${required} ${readonly} lay-verType="tips" />`;
                const disabledClass = data.disabled ? 'layui-btn-disabled' : ''
                html += `<div class="layui-input-group">
                            ${inputHTML}
                            <div class="layui-input-suffix">
                                <button type="button" class="layui-btn layui-btn-primary layui-bg-white ${disabledClass}" ${disabled} id="${data.name}">上传</button>
                                <button type="button" class="layui-btn layui-btn-primary layui-bg-white">预览</button>
                            </div>
                        </div>`

                return html
            }
        },
        button: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += '<div class="' + LAY_INLINE_CLASS + '" >';
                html += '<button type="button" class="layui-btn ' + data.theme + ' ' + data.btnsize + '" >' + data.text + '</button> ';
                html += LAY_FORM_DIV;
                html += LAY_FORM_DIV;
                return html;
            }
        },
        note: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += '<blockquote class="layui-elem-quote">' + data.textarea + '</blockquote>';
                html += LAY_FORM_DIV;
                return html;
            }
        },
        subtraction: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += '<hr class="' + data.border + '">';
                html += LAY_FORM_DIV;
                return html;
            }
        },
        space: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += '<div style="height:' + data.height + 'px;"></div>';
                html += LAY_FORM_DIV;
                return html;
            }
        },
        carousel: {
            render: function (data) {
                let html = getBeforeItem(data);
                let imgs = data.imgs.map(item => `<div><img src="${item}" class="carousel-img" /></div>`).join('')
                html += `<div id="${data.name}_box" class="layui-carousel" style="height: ${data.height}px;"><div carousel-item>${imgs}</div></div>`
                html += LAY_FORM_DIV;
                return html;
            }
        },
        grid: {
            render: function (data) {
                let html = '<div id="' + data.name + '" class="layui-form-item layui-row" data-index="' + data.index + '" data-tag="' + data.tag + '">';
                // 计算每一个区块大小
                if (data.children.length) {
                    let col = 12 / data.column;
                    for (let index = 0; index < data.column; index++) {
                        let elem = data.children[index];
                        html += '<div class="layui-col-md' + col + ' layui-grid-' + index + ' children" data-index="' + index + '"></div>';
                    }
                }

                html += '</div>';

                return html;
            }
        },
        link: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += `<div class="mon-link-box"><a class="mon-link" href="${data.url}" target="_blank">${data.data_default}</a></div>`;
                html += LAY_FORM_DIV;
                return html;
            }
        },
        img: {
            render: function (data) {
                let html = getBeforeItem(data);
                html += `<div class="mon-img-box"><img src="${data.upload_value}" alt="${data.upload_value}" /></div>`;
                html += LAY_FORM_DIV;
                return html;
            }
        },
        video: {
            render: function (data) {
                let html = getBeforeItem(data);
                let videoControls = data.controls ? 'controls="controls"' : ''
                let videoStyle = `height: ${data.height}px;`
                let videoType = `video/${data.source_type}`
                html += `<div class="mon-video-box">
                            <video ${videoControls} style="${videoStyle}">
                                <source src="${data.upload_value}" :type="${videoType}" />
                                抱歉！你的浏览器不支持H5视频播放
                            </video>
                        </div>`;
                html += LAY_FORM_DIV;
                return html;
            }
        },
        audio: {
            render: function (data) {
                let html = getBeforeItem(data);
                let audioControls = data.controls ? 'controls="controls"' : ''
                let audioType = `audio/${data.source_type}`
                html += `<div class="mon-audio-box">
                            <audio ${audioControls}>
                                <source src="${data.upload_value}" :type="${audioType}" />
                                抱歉！你的浏览器不支持H5音频播放
                            </audio>
                        </div>`;
                html += LAY_FORM_DIV;
                return html;
            }
        }
    }

    /**
     * 渲染form表单ITEM可以拖放
     * @param {*} params 
     */
    Class.prototype.gridtabSortable = function (itemId) {
        let that = this, options = that.config;
        let item = new Sortable.create(itemId, {
            group: {
                name: STR_FORMDESIGN
            },
            direction: 'vertical',
            ghostClass: "sortableghost",
            animation: 150,
            swapClass: 'highlight',
            filter: function (evt, item) {
                // 限定OL标签
                // if ($(item)[0].tagName != 'OL'
                //   || $(item).data('type') == 'space') {
                //   return true;
                // }
                // console.log($(item).data('tag')); 

                return false;
            },
            onChoose: function (evt) { },
            onAdd: function (evt) {
                let item = evt.item, id = $(item).attr('id'),
                    parentId = $(evt.item.parentElement.parentElement).attr('id'),
                    parentIndex = $(evt.item.parentElement).index();

                // 查找栅格的ID
                let gridElem = that.recursiveFindElem(options.data, parentId);
                let data = {}
                if (typeof id != 'undefined') {
                    data = JSON.parse(JSON.stringify(that.recursiveFindElem(options.data, id)));
                    data.index = options.count++;
                    data.name = data.tag + '_' + data.index;
                    gridElem.children[parentIndex].children.splice(evt.newIndex, 0, data);
                    that.recursiveDelete(options.data, id);

                } else {
                    data = that.getComponentJson($(item).data('tag'));
                    data.index = options.count++;
                    data.name = data.tag + '_' + data.index;
                    gridElem.children[parentIndex].children.splice(evt.newIndex, 0, data);
                }

                options.state = data;
                that.renderComponent(options.data, $('#' + options.id));
            },
            onUpdate: function (evt) {
                let parentId = $(evt.item.parentElement.parentElement).attr('id'), parentIndex = evt.item.parentElement.dataset.index;
                let gridElem = that.recursiveFindElem(options.data, parentId);
                let children = gridElem.children[parentIndex].children;
                [children[evt.newIndex], children[evt.oldIndex]] = [children[evt.oldIndex], children[evt.newIndex]];
            },
            onEnd: function (evt) { }
        });

        this.config.itemIndex[itemId] = item;
    }

    // 查找原始元素
    Class.prototype.recursiveFindElem = function (array, name) {
        const that = this;
        for (let index = 0; index < array.length; index++) {
            const element = array[index];
            if (element.name == name) {
                return element;
            }
            if (typeof element.children != 'undefined' && element.children.length) {
                let subElem = element.children;
                for (let i = 0; i < subElem.length; i++) {
                    if (subElem[i].children.length) {
                        let item = that.recursiveFindElem(subElem[i].children, name);
                        if (item && typeof item != 'undefined') {
                            return item;
                        }
                    }
                }
            }
        }
    }

    // 删除原始元素
    Class.prototype.recursiveDelete = function (array, name) {
        const that = this;
        for (let index = 0; index < array.length; index++) {
            const element = array[index];
            if (element.name == name) {
                array.splice(index, 1);
                break;
            }

            if (typeof element.children != 'undefined' && element.children.length) {
                let subElem = element.children;
                for (let i = 0; i < subElem.length; i++) {
                    if (subElem[i].children.length) {
                        that.recursiveDelete(subElem[i].children, name);
                    }
                }
            }
        }
    }

    // 生成随机数
    Class.prototype.Math = function () {
        return Math.round(Math.random() * 1000);
    }

    // 记录所有实例
    thisTags.that = {};

    // 获取当前实例对象
    thisTags.getThis = function (id) {
        let that = thisTags.that[id];
        if (!that) hint.error(id ? (MOD_NAME + ' instance with ID \'' + id + '\' not found') : 'ID argument required');
        return that
    };

    // 重载实例
    MODULE_FORMDESIGN_NAME.reload = function (id, options) {
        let that = thisTags.that[id];
        that.reload(options);

        return thisTags.call(that);
    };

    // 核心入口
    MODULE_FORMDESIGN_NAME.render = function (options) {
        let inst = new Class(options);
        return thisTags.call(inst);
    };

    // 获取表单配置
    MODULE_FORMDESIGN_NAME.getFormConfig = function () {
        return getFormConfig()
    }

    exports(MOD_NAME, MODULE_FORMDESIGN_NAME);
})
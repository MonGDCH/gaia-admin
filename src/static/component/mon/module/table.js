layui.define(['util', 'table', 'form', 'dropdown', 'action', 'soulTable', 'tableMerge', 'http'], function (exports) {
    "use strict";

    const util = layui.util
    const table = layui.table
    const form = layui.form
    const dropdown = layui.dropdown
    const action = layui.action
    const soulTable = layui.soulTable
    const tableMerge = layui.tableMerge
    const http = layui.http

    // 加载模块资源
    const MODULE_NAME = 'mTable'
    const modFile = layui.cache.modules[MODULE_NAME];
    const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
    layui.link(modPath + '/soul-table/soulTable.css?v=' + (typeof window.version == 'string' ? window.version : Math.random()))

    const mTable = {
        // 默认配置
        defaultConfig: {
            // 默认ID
            id: 'table',
            // 不显示loading
            loading: true,
            // 顶部工具栏
            toolbar: '#toolbar',
            // 顶部工具栏右侧图标
            defaultToolbar: [{
                title: '刷新',
                layEvent: 'refresh',
                icon: 'layui-icon-refresh'
            }, 'filter'],
            // 开启分页
            page: true,
            // 每页显示数
            limit: 10,
            // 分页栏目选择列表
            limits: [10, 20, 50],
            // 禁用自动排序
            autoSort: false,
            // 表格外观， grid（默认） line（行边框风格）row （列边框风格）nob （无边框风格）
            skin: 'grid',
            // 单元格编辑的事件触发方式, click、dblclick
            editTrigger: 'dblclick',
            // 空数据显示
            text: { none: '暂无数据' },
            // 表格尺寸 sm|md|lg
            size: 'md',
            // 开启隔行背景
            even: false,
            // 异步获取数据的URL
            url: '',
            // 请求方式
            method: 'get',
            // 请求参数
            where: {},
            // 请求头参数
            headers: {},
            // 重新定义请求参数名
            request: {
                pageName: 'page',
                limitName: 'limit'
            },
            // 转换数据
            // parseData: function (res) {
            //     return {
            //         "code": res.code == '1' ? 0 : 1,
            //         "msg": res.msg,
            //         "count": res.count,
            //         "data": res.data
            //     };
            // },
            // 定义接收数据格式
            response: {
                statusName: 'code',
                statusCode: 1,
                msgName: 'msg',
                countName: 'count',
                dataName: 'data'
            },
            // soul-table 默认关闭拖拽列功能
            drag: false,
        },
        // 当前配置
        config: {},
        // 搜索表单filter值
        searchFilter: 'search',
        // 获取实例, 执行回调
        callback: function (callback) {
            return callback.call(this, table)
        },
        // 重载on
        on: function (event, callback) {
            table.on(event, callback);
        },
        // 渲染表格
        render: function (option) {
            mTable.config = Object.assign({}, mTable.defaultConfig, option || {})
            mTable.config.done = function (res, curr, count, origin) {
                // soulTable支持
                soulTable.render(this)
                // 表格合并参数支持(表头参数 merge: true)
                tableMerge.render(this)
                if (option.done && typeof option.done === 'function') {
                    option.done(res, curr, count, origin)
                }
            }
            table.render(mTable.config);
        },
        // html渲染表格
        init: function (element, option) {
            mTable.config = Object.assign({}, mTable.defaultConfig, option || {})
            table.init(element, mTable.config);
        },
        // 刷新表格
        reload: function (filter, option) {
            table.reload(filter, option || {})
        },
        // 重置刷新表格数据
        reloadData: function (filter, options, deep) {
            table.reloadData(filter, options || {}, deep);
        },
        // 搜索
        search: function (filter, where) {
            mTable.reloadData(filter, {
                page: {
                    // 重新返回第一页
                    curr: 1,
                },
                where: where || {}
            })
        },
        // 获取数据
        getData: function (filter) {
            return table.getData(filter);
        },
        // 获取选中行相关数据
        checkStatus: function (filter) {
            return table.checkStatus(filter);
        },
        // 绑定事件
        bindEvent: function (filter, options) {
            options = options || {}
            // 排序
            mTable.event.bindSort(filter, options)
            // 绑定toolbar事件
            mTable.event.bindToolbar(filter, options)
            // 绑定tool事件
            mTable.event.bindTool(filter, options)
        },
        // 事件
        event: {
            // 顶部工具栏
            bindToolbar: function (filter, opt) {
                table.on('toolbar(' + filter + ')', function (obj) {
                    const options = opt.toolbar || {}
                    let searchFilter = 'search'
                    switch (obj.event) {
                        case 'refresh':
                            // 刷新表格
                            table.reload(filter)
                            break;
                        case 'search':
                            // 搜索
                            searchFilter = opt.searchFilter || mTable.searchFilter
                            layer.open({
                                id: 'search-form-box',
                                type: 1,
                                title: '搜索',
                                content: layui.jquery('#search-form'),
                                area: ['480px', '520px'],
                                shadeClose: true,
                                hideOnClose: true,
                                btn: ['搜索', '重置'],
                                btn1: function (index, layero, that) {
                                    let searchData = form.val(searchFilter) || {}
                                    // 解析搜索数据
                                    if (options.search && typeof options.search == 'function') {
                                        searchData = options.search(searchData, false)
                                    }
                                    mTable.search(filter, searchData)
                                    layer.close(index)
                                    return false;
                                },
                                btn2: function (index, layero, that) {
                                    if (options.search && typeof options.search == 'function') {
                                        let searchData = form.val(searchFilter) || {}
                                        options.search(searchData, true)
                                    }
                                    form.getFormElem(searchFilter)[0].reset()
                                    return false
                                },
                                success: function (layero, index, that) {
                                    layero.find('.layui-layer-content').css('overflow', 'visible')
                                }
                            })
                            break;
                        case 'searchBar':
                            // 搜索栏
                            let searchBarInputName = this.previousElementSibling.name
                            let searchBarInputValue = this.previousElementSibling.value
                            let searchBarData = {}
                            searchBarData[searchBarInputName] = searchBarInputValue
                            // 解析搜索数据
                            if (options.searchBar && typeof options.searchBar == 'function') {
                                searchBarData = options.searchBar(searchBarData)
                            }
                            mTable.search(filter, searchBarData)
                            break;
                        case 'reset':
                            // 重置表单
                            searchFilter = opt.searchFilter || mTable.searchFilter
                            let formEl = document.querySelector(`form[lay-filter="${searchFilter}"]`)
                            formEl && formEl.reset()
                            // 重新获取表单数据
                            let resetSearchData = form.val(searchFilter) || {}
                            // 解析搜索数据
                            if (options.search && typeof options.search == 'function') {
                                resetSearchData = options.search(resetSearchData, true)
                            }
                            mTable.search(filter, resetSearchData);
                            break;
                        case 'add':
                            // 新增
                            if (options.add) {
                                if (options.add instanceof Function) {
                                    // 函数参数，执行对应函数
                                    return options.add.call(this, obj, table)
                                }

                                let url = options.add.url ? options.add.url : options.add
                                let title = options.add.title ? options.add.title : '新增'
                                let full = options.add.full ? options.add.full : false
                                options.add.dialog === true ? action.dialog(url, title, {}, full) : action.drawer(url, title, {}, full)
                            }
                            break;
                        case 'edit':
                            // 编辑
                            if (options.edit) {
                                if (options.edit instanceof Function) {
                                    // 函数参数，执行对应函数
                                    return options.edit.call(this, obj, table)
                                }

                                let url = options.edit.url ? options.edit.url : options.edit
                                let title = options.edit.title ? options.edit.title : '编辑'
                                let full = options.edit.full ? options.edit.full : false
                                // 获取列表数据
                                let ids = table.checkStatus(obj.config.id).data.map((item) => {
                                    return item.id
                                })

                                url = mTable.format.idx(url, ids.join(','))
                                options.edit.dialog === true ? action.dialog(url, title, {}, full) : action.drawer(url, title, {}, full)
                            }

                            break;
                        case 'delete':
                            // 删除
                            if (options.delete) {
                                // 获取列表数据
                                let ids = table.checkStatus(obj.config.id).data.map((item) => {
                                    return item.id
                                })
                                if (ids.length > 0) {
                                    layer.confirm('确定执行该删除操作么？', { icon: 3, title: '注意' }, async function (index) {
                                        const res = await http.ajax({
                                            url: options.delete,
                                            method: 'POST',
                                            data: { idx: ids }
                                        })
                                        if (res.code && res.code == 1) {
                                            layer.close(index)
                                            mTable.reload(filter)
                                            // 提示
                                            // parent.toast.success(res.msg || '操作成功');
                                            parent.layer.msg(res.msg || '操作成功', { icon: 1 })

                                            return;
                                        }

                                        // parent.toast.error(res.msg || '操作失败');
                                        parent.layer.msg(res.msg || '操作失败', { icon: 2 })
                                    })
                                }
                            }
                            break;
                        default:
                            // 判断是否存在自定义扩展事件配置，存在则调用对应的回调方法
                            if (options[obj.event] && typeof options[obj.event] == 'function') {
                                let callback = options[obj.event]
                                callback.call(this, obj.data, table)
                            }
                            break;
                    }
                })
            },
            // 表格操作栏
            bindTool: function (filter, opt) {
                table.on('tool(' + filter + ')', function (obj) {
                    const that = this
                    const options = opt.tool || {}
                    let data = obj.data;
                    let event = obj.event;
                    switch (event) {
                        case 'add':
                            // 新增
                            if (options.add) {
                                if (options.add instanceof Function) {
                                    // 函数参数，执行对应函数
                                    return options.add.call(this, obj, table)
                                }

                                let url = options.add.url ? options.add.url : options.add
                                let title = options.add.title ? options.add.title : '新增'
                                let full = options.add.full ? options.add.full : false
                                url = mTable.format.idx(url, data.id)
                                options.add.dialog === true ? action.dialog(url, title, {}, full) : action.drawer(url, title, {}, full)
                            }
                            break;
                        case 'edit':
                            // 编辑
                            if (options.edit) {
                                if (options.edit instanceof Function) {
                                    // 函数参数，执行对应函数
                                    return options.edit.call(this, obj, table)
                                }

                                let url = options.edit.url ? options.edit.url : options.edit
                                let title = options.edit.title ? options.edit.title : '编辑'
                                let full = options.edit.full ? options.edit.full : false
                                url = mTable.format.idx(url, data.id)
                                options.edit.dialog === true ? action.dialog(url, title, {}, full) : action.drawer(url, title, {}, full)
                            }
                            break;
                        case 'delete':
                            // 删除
                            if (options.delete) {
                                layer.confirm('确定执行该删除操作么？', { icon: 3 }, async function (index) {
                                    const res = await http.ajax({
                                        url: options.delete,
                                        method: 'POST',
                                        data: { idx: data.id }
                                    })
                                    if (res.code && res.code == 1) {
                                        layer.close(index)
                                        mTable.reload(filter)
                                        // 提示
                                        // parent.toast.success(res.msg || '操作成功');
                                        parent.layer.msg(res.msg || '操作成功', { icon: 1 })
                                        return;
                                    }

                                    // parent.toast.error(res.msg || '操作失败');
                                    parent.layer.msg(res.msg || '操作失败', { icon: 2 })
                                })
                            }
                            break;
                        case 'confirm':
                            // 确认操作
                            let queryData = this.dataset;
                            layer.confirm(queryData.title || '确定执行该操作么？', { icon: 3, title: '提示' }, async function (index) {
                                let url = queryData.url || ''
                                let method = queryData.method || 'post'
                                const res = await http.ajax({
                                    url: url,
                                    method: method,
                                    data: queryData
                                })
                                if (res.code && res.code == 1) {
                                    layer.close(index)
                                    mTable.reload(filter)
                                    // 提示
                                    // parent.toast.success(res.msg || '操作成功');
                                    parent.layer.msg(res.msg || '操作成功', { icon: 1 })
                                    return;
                                }
                                // parent.toast.error(res.msg || '操作失败');
                                parent.layer.msg(res.msg || '操作失败', { icon: 2 })

                            })
                            break;
                        case 'drawer':
                            // 打开抽屉
                            let drawerData = this.dataset;
                            let drawerURL = drawerData.url || ''
                            let drawerTitle = drawerData.title || '操作'
                            let drawerFull = drawerData.full && drawerData.full == 'true'
                            action.drawer(mTable.format.idx(drawerURL, data.id), drawerTitle, {}, drawerFull)
                            break;
                        case 'dialog':
                            // 打开弹窗
                            let dialogData = this.dataset;
                            let dialogURL = dialogData.url || ''
                            let dialogTitle = dialogData.title || '操作'
                            let dialogFull = dialogData.full && dialogData.full == 'true'
                            action.dialog(mTable.format.idx(dialogURL, data.id), dialogTitle, {}, dialogFull)
                            break;
                        case 'more':
                            // 更多菜单
                            let moreMenu = []
                            if (options.more && typeof options.more === 'function') {
                                moreMenu = options.more(obj, this)
                            } else if (options.more && typeof options.more === 'object' && options.more.length > 0) {
                                moreMenu = options.more
                            }
                            if (typeof moreMenu === 'object' && moreMenu.length > 0) {
                                let dropdownData = moreMenu.map((v, i) => {
                                    return { title: v.title, id: i }
                                })

                                dropdown.render({
                                    elem: that,
                                    // 外部事件触发即显示
                                    show: true,
                                    data: dropdownData,
                                    click: function (oData, oThis) {
                                        // 存在回调方法，执行回调方法
                                        if (moreMenu[oData.id]['callback'] && typeof moreMenu[oData.id]['callback'] == 'function') {
                                            let moreCallback = moreMenu[oData.id]['callback']
                                            moreCallback.call(this, data, table)
                                        }
                                    },
                                })
                            }
                            break;
                        default:
                            // 判断是否存在自定义扩展事件配置，存在则调用对应的回调方法
                            if (options[event] && typeof options[event] == 'function') {
                                let callback = options[event]
                                callback.call(this, data, table)
                            }
                            break;
                    }
                })
            },
            // 排序
            bindSort: function (filter, options) {
                table.on('sort(' + filter + ')', function (obj) {
                    // 解析搜索数据
                    let searchFilter = options.searchFilter || mTable.searchFilter
                    let searchData = form.val(searchFilter) || {}
                    if (options.sort && typeof options.sort == 'function') {
                        searchData = options.sort(searchData)
                    }
                    table.reloadData(filter, {
                        initSort: obj,
                        page: {
                            curr: 1
                        },
                        where: {
                            ...searchData,
                            order: obj.field,
                            sort: obj.type
                        }
                    });
                })
            },
            // 行点击
            bindClick: function (filter, callback) {
                table.on('row(' + filter + ')', function (obj) {
                    // console.log(obj.tr) //得到当前行元素对象
                    // console.log(obj.data) //得到当前行数据
                    // obj.del(); //删除当前行
                    // obj.update(fields) //修改当前行数据
                    callback.call(this, table, obj)
                });
            },
            // 行双击
            bindDBClick: function (filter, callback) {
                table.on('rowDouble(' + filter + ')', function (obj) {
                    // console.log(obj.tr) //得到当前行元素对象
                    // console.log(obj.data) //得到当前行数据
                    // obj.del(); //删除当前行
                    // obj.update(fields) //修改当前行数据
                    callback.call(this, table, obj)
                });
            },
        },
        // 格式化表格数据
        format: {
            // 自动添加idx参数
            idx: function (url, idx) {
                return !url.match(/\{idx\}/i) ? url + (url.match(/(\?|&)+/) ? "&idx=" : "?idx=") + idx : url;
            },
            // 图标
            icon: function (value) {
                value = typeof value != 'object' ? value : value.icon
                return '<i class="' + value + '"></i>';
            },
            // 状态
            status: function (value, title = ['禁用', '正常']) {
                value = typeof value != 'object' ? value : value.status
                let index = parseInt(value, 10);
                let display = title[index] || '未知';
                return value == '1' ? '<i class="layui-icon layui-icon-ok layui-font-green"> ' + display + '</i>' : '<i class="layui-icon layui-icon-close layui-font-red"> ' + display + '</i>'
            },
            // 状态图标
            statusIcon: function (value) {
                return value == '1' ? '<i class="layui-icon layui-icon-ok layui-font-green"></i>' : '<i class="layui-icon layui-icon-close layui-font-red"></i>'
            },
            // 审核状态图标
            checkStatusIcon: function (value, showTitle = true) {
                const icons = ['layui-icon-help layui-font-orange', 'layui-icon-ok layui-font-green', 'layui-icon-close layui-font-red']
                const title = ['待审核', '已通过', '未通过'];

                return `<i class="layui-icon ${icons[value]}"></i> ` + (showTitle ? title[value] : '')
            },
            // 日期时间
            dateTime: function (value) {
                value = typeof value != 'object' ? value : value.timestamp
                return value ? util.toDateString(new Date(parseInt(value * 1000, 10)), 'yyyy-MM-dd HH:mm:ss') : '';
            },
            // 日期
            date: function (value) {
                value = typeof value != 'object' ? value : value.timestamp
                return value ? util.toDateString(new Date(parseInt(value * 1000, 10)), 'yyyy-MM-dd') : '';
            },
            // URL
            url: function (value) {
                // 过滤空链接
                if (value == '' || value == undefined) {
                    return ''
                }
                value = typeof value != 'object' ? value : value.url
                return '<a class="mon-link" href="' + value + '" target="_blank">' + value + '</a>'
            },
            // 头像
            avatar: function (value, className) {
                value = typeof value != 'object' ? value : value.img
                let classAttr = className ? className : 'img-sm img-center';
                return '<a href="javascript:void(0)"><img class="img-circle layui-border-cyan ' + classAttr + '" src="' + value + '" /></a>';
            },
            // 图片
            image: function (value, className) {
                value = typeof value != 'object' ? value : value.img
                if (!value) {
                    return ''
                }
                let classAttr = className ? className : 'img-sm img-center';
                return `<img class="${classAttr}" src="${value}" alt="image" lay-on="img-preview" />`
            },
            // 多张图片
            images: function (value, className) {
                value = typeof value != 'object' ? value : value.img
                value = value === null ? '' : value.toString();
                let classAttr = className ? className : 'img-sm img-center';
                let arr = value.split(',');
                let html = [];
                arr.forEach((value, i) => {
                    html.push('<a href="' + value + '" target="_blank"><img class="' + classAttr + '" src="' + value + '" /></a>');
                });
                return html.join(' ');
            },
            // 性别
            sex: function (value) {
                let sexList = ['保密', '男', '女']
                return `<div>${this.sexIcon(value)} ${sexList[value] || '未知'}</div>`
            },
            sexIcon: function (value) {
                let sexList = [
                    `<i class="layui-icon layui-icon-help"></i>`,
                    `<i class="layui-icon layui-icon-male"></i>`,
                    `<i class="layui-icon layui-icon-female"></i>`
                ];
                return sexList[value] || ''
            },
            auditIcon: function (value) {
                let icons = [
                    `<i class="layui-icon layui-icon-help"></i>`,
                    `<i class="layui-icon layui-icon-ok"></i>`,
                    `<i class="layui-icon layui-icon-close"></i>`
                ];

                return icons[value] || ''
            }
        }
    }

    exports(MODULE_NAME, mTable)
})
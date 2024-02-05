
layui.define(['http', 'xmSelect'], function (exports) {
    'use strict';

    const http = layui.http
    const xmSelect = layui.xmSelect
    const MODULE_NAME = 'userSelect'

    exports(MODULE_NAME, {
        /**
         * 渲染用户选择Select
         *
         * @param {string} el 渲染的dom
         * @param {string} url 获取数据的API
         * @param {string} options 额外配置信息
         * @returns 
         */
        render: function (el, url, options) {
            if (!el || !url) {
                throw new Error('userSelect render error: el or url is required!')
            }

            // 内置获取数据方法
            const remoteMethod = async (val, cb, show) => {
                // 这里如果val为空, 则不触发搜索
                if (!val) { return cb([]); }
                try {
                    const { code, data, msg } = await http.ajax({
                        url: url,
                        method: 'GET',
                        params: {
                            page: 1,
                            limit: 999,
                            key: val
                        }
                    })
                    if (code != '1') {
                        cb([])
                        return layer.msg(msg, { icon: 2 })
                    }
                    cb(data)
                } catch (err) {
                    console.error(err)
                    cb([]);
                }
            }

            // 默认配置信息
            const defaultConifg = {
                tips: '请搜索选择用户',
                searchTips: '输入用户昵称、邮箱、手机号搜索',
                name: 'uid',
                layVerify: 'required',
                layVerType: 'tips',
                layReqText: '请选择用户',
                height: '420px',
                filterable: true,
                paging: true,
                pageSize: 10,
                radio: true,
                clickClose: true,
                model: {
                    // 是否展示复选框或者单选框图标 show, hidden:变换背景色
                    icon: 'hidden',
                    label: {
                        // 使用方式
                        type: 'count',
                        // 自定义渲染
                        count: {
                            // 函数处理
                            template(data, sels) {
                                // data: 所有的数据
                                // sels: 选中的数据
                                return `${sels[0].nickname}  #${sels[0].id}`
                            }
                        }
                    }
                },
                prop: { name: 'nickname', value: 'id', },
                template({ item, sels, name, value }) {
                    return item.nickname + '<span style="position: absolute; right: 0px; color: #8799a3">' + item.id + '</span>'
                },
                remoteSearch: true,
                remoteMethod: remoteMethod
            }

            // 生成配置
            const config = Object.assign({ el: el }, defaultConifg, options || {})
            // 渲染
            return xmSelect.render(config)
        }
    })

})
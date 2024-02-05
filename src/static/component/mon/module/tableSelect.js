layui.define(['layer', 'mTable'], function (exports) {
    'use strict';

    // 插件名
    const MODULE_NAME = 'tableSelect'
    const layer = layui.layer
    const mTable = layui.mTable

    // 表格ID
    const tableID = 'table-select'
    // 表格模板
    const tpl = `<div class="table-select-box" style="padding: 10px">
                    <div class="table-select-oper" style="margin-bottom: 14px; display: flex; align-items: center; justify-content: space-between;">
                        <div class="layui-input-group">
                            <input type="text" id="table-select-search-input" placeholder="搜索" class="layui-input" lay-affix="clear">
                            <div class="layui-input-suffix">
                                <button class="layui-btn layui-btn-primary" id="table-select-search-btn">搜索</button>
                            </div>
                        </div>
                        <button class="layui-btn layui-bg-blue" id="table-select-success">确认</button>
                    </div>
                    <table id="${tableID}"></table>
                </div>`

    class TableSelect {
        // 初始化
        constructor(options) {
            if (!options.url) {
                layer.msg('[TableSelect]请设置数据源url', { icon: 2 })
                return false;
            }
            if (!options.cols) {
                layer.msg('[TableSelect]请设置表格列', { icon: 2 })
                return false;
            }

            this.options = Object.assign({
                // 数据API接口
                url: '',
                // 搜索附加参数
                searchData: {},
                // 搜索的key名
                searchKey: 'name',
                // 表格列
                cols: [],
                // 表格选中列值
                checked: [],
                // 表格选中列列名
                checkedKey: 'id',
                // 限制选中记录数
                limit: 10,
                // 选择类型，支持 checkbox、radio
                selectType: 'checkbox',
                // 标题
                title: '表格选择',
                // 确认回调函数
                callback: (data, index) => { }
            }, options)
            this.table = null
            this.render()
        }

        render() {
            let checkedRow = this.options.checked
            let checkedKey = this.options.checkedKey
            layer.open({
                type: 1,
                title: this.options.title,
                area: ['860px', '580px'],
                scrollbar: false,
                shadeClose: true,
                content: tpl,
                success: (layero, index) => {
                    mTable.render({
                        id: tableID,
                        elem: layero.find(`#${tableID}`),
                        url: this.options.url,
                        toolbar: false,
                        height: 440,
                        cols: [[
                            { type: this.options.selectType, fixed: 'left' },
                            ...this.options.cols
                        ]],
                        parseData: (res) => {
                            // 渲染选中数据
                            let data = res.data.map(item => {
                                if (checkedRow.includes(item[checkedKey])) {
                                    item.LAY_CHECKED = true
                                }
                                return item
                            })
                            return {
                                "code": res.code,
                                "msg": res.msg,
                                "count": res.count,
                                "data": data
                            };
                        }
                    })

                    // 搜索
                    layero.find('#table-select-search-btn').on('click', () => {
                        let searchVal = layero.find('#table-select-search-input').val()
                        let searchQueryData = this.options.searchData
                        searchQueryData[this.options.searchKey] = searchVal
                        mTable.search(tableID, searchQueryData)
                    })

                    // 选中
                    layero.find('#table-select-success').on('click', () => {
                        mTable.callback((table) => {
                            // 选中的数据
                            let selected = table.checkStatus(tableID).data
                            if (!selected) {
                                return false;
                            }
                            if (selected.length > this.options.limit) {
                                layer.msg('最多只能选择' + this.options.limit + '项', { icon: 2 })
                                return false;
                            }

                            // 回调
                            let ret = this.options.callback.call(this, selected, index)
                            if (ret === false) {
                                return;
                            }


                            layer.close(index)
                        })
                    })
                }
            })
        }
    }

    exports(MODULE_NAME, {
        render(options) {
            options = options || {}
            return new TableSelect(options)
        }
    })
})
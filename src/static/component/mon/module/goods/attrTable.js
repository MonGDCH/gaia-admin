/**
 * 产品规格表
 */
layui.define(['mTable', 'xmSelect'], function (exports) {
    'use strict';

    // 插件名
    const MODULE_NAME = 'attrTable'
    const mTable = layui.mTable
    const xmSelect = layui.xmSelect

    /**
     * 渲染
     *
     * @param {*} el 表格 elem 参数
     * @param {Array} data  表格数据集 [{ type: 0,title: '产地',value: '中国'，selected:''}], type：0input.1radio,2checkbox
     */
    function render(el, data) {
        // 产品属性表格
        mTable.render({
            elem: el,
            id: MODULE_NAME,
            maxHeight: 320,
            width: 580,
            size: 'sm',
            page: false,
            editTrigger: 'click',
            toolbar: '<div class="layui-btn-container">产品属性</div>',
            defaultToolbar: [{
                title: '新增属性',
                layEvent: 'add-attr',
                icon: 'layui-icon-add-1'
            }],
            // 行拖动
            rowDrag: { trigger: 'row' },
            cols: [[
                { type: 'numbers', title: '序', align: 'center', width: 50 },
                { field: 'title', title: '属性名称', width: 160, align: 'center', edit: 'text' },
                {
                    field: 'value', title: '属性值', minWidth: 200, align: 'center', edit: (d) => d.type == 0 ? 'text' : false,
                    templet: d => d.type == 0 ? d.value : `<div id="attr-value-select-${d.LAY_INDEX}"></div>`
                },
                {
                    title: '操作', width: 80, align: 'center', templet: (d) => {
                        return `<div class="layui-btn-container">
                                    <button type="button" class="layui-btn layui-btn-xs layui-btn-primary layui-border-red" lay-event="remove" title="删除">
                                        <i class="layui-icon layui-icon-close"></i>
                                    </button>
                                </div>`
                    }
                }
            ]],
            data: data,
            done: (res) => {
                res.data.forEach(item => {
                    let el = `#attr-value-select-${item.LAY_INDEX}`
                    let data = item.value.split(',').map((v) => {
                        return { name: v, value: v }
                    })
                    let initValue = item.selected ? item.selected.split(',') : []
                    if (item.type == 1) {
                        // 单选
                        xmSelect.render({
                            el: el,
                            size: 'mini',
                            radio: true,
                            clickClose: true,
                            model: {
                                type: 'fixed',
                                icon: 'hidden',
                                label: {
                                    type: 'text'
                                }
                            },
                            data: data,
                            initValue: initValue,
                            on: (data) => {
                                item.selected = data.arr.map(v => v.value).join(',')
                            }
                        })
                    } else if (item.type == 2) {
                        // 多选
                        xmSelect.render({
                            el: el,
                            size: 'mini',
                            model: { type: 'fixed' },
                            data: data,
                            initValue: initValue,
                            on: (data) => {
                                item.selected = data.arr.map(v => v.value).join(',')
                            }
                        })
                    }
                })
            }
        });

        // 表格事件
        mTable.on(`toolbar(${MODULE_NAME})`, function (obj) {
            switch (obj.event) {
                case 'add-attr':
                    // 添加属性行
                    let data = mTable.getData(MODULE_NAME)
                    data.push({ type: 0, title: '', value: '' })
                    mTable.reloadData(MODULE_NAME, { data: data });
                    break;
            }
        })
        mTable.on(`tool(${MODULE_NAME})`, function (obj) {
            let data = mTable.getData(MODULE_NAME)
            switch (obj.event) {
                case 'remove':
                    // 删除行
                    layer.confirm(`确认删除该属性类型么？`, { icon: 3, title: '注意' }, (layIndex) => {
                        data.splice(obj.index, 1)
                        mTable.reloadData(MODULE_NAME, { data: data });
                        layer.close(layIndex)
                    })
                    break;
            }
        })
    }

    exports(MODULE_NAME, {
        // 渲染
        render: render,
        // 获取数据
        getData: function () {
            let data = mTable.getData(MODULE_NAME)
            return data;
        },
        // 重置数据
        reloadData: function (data) {
            mTable.reloadData(MODULE_NAME, { data: data });
        }
    })
})
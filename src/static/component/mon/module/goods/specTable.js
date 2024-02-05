layui.define(['mTable', 'util', 'skuTable'], function (exports) {
    'use strict';

    // 插件名
    const MODULE_NAME = 'specTable'
    const mTable = layui.mTable
    const util = layui.util
    const skuTable = layui.skuTable

    /**
     * 笛卡尔积生成规格
     *
     * @params arr1 [要进行笛卡尔积的二维数组]
     * @params arr2 [最终实现的笛卡尔积组合,可不写]
     */
    function cartesian(arr1, arr2) {
        // 去除第一个元素
        let result = [];
        let temp_arr = arr1;
        let first = temp_arr.splice(0, 1);
        if ((arr2 || null) == null) {
            arr2 = [];
        }
        // 判断是否是第一次进行拼接
        let eachVal = (first[0] && first[0].value) ? first[0].value : [];
        if (typeof eachVal == 'string') {
            eachVal = eachVal.split(',');
        }
        if (arr2.length > 0) {
            arr2.forEach(v => {
                eachVal.forEach(v2 => {
                    result.push(v + ',' + v2);
                })
            })
        } else {
            eachVal.forEach(v => {
                result.push(v);
            })
        }
        // 递归进行拼接
        if (arr1.length > 0) {
            result = cartesian(arr1, result);
        }

        // 返回最终笛卡尔积
        return result;
    }

    /**
     * 获取sku表格数据
     *
     * @param {Array} cartesian 笛卡尔积数组
     */
    function skuTableData(cartesian) {
        let data = [];
        cartesian.forEach(v => {
            let item = {
                img: '',
                price: 0,
                cost_price: 0,
                market_price: 0,
                stock: 0,
                weight: 0,
                volume: 0,
                code: '',
            }
            v.split(',').forEach((v2, i) => {
                item['col-' + i] = v2
            })
            data.push(item)
        })

        return data
    }

    // 渲染规格表
    function render(el, data, skuOptions) {
        // 渲染规格表格
        mTable.render({
            elem: el,
            id: MODULE_NAME,
            maxHeight: 300,
            width: 900,
            page: false,
            rowDrag: {
                trigger: 'row', done: function (obj) {
                    let skuOpt = Object.assign({}, skuOptions, {
                        specData: obj.cache,
                        data: []
                    })
                    // 渲染sku表格
                    skuTable.render(skuOpt)
                }
            },
            editTrigger: 'click',
            toolbar: '<div class="layui-btn-container">产品规格</div>',
            defaultToolbar: [
                { title: '生成规格', layEvent: 'build-spec', icon: 'layui-icon-app' },
                { title: '新增规格', layEvent: 'add-spec', icon: 'layui-icon-add-1' }
            ],
            cols: [[
                { type: 'numbers', title: '序', align: 'center', width: 50 },
                { field: 'title', title: '规则名称', width: 120, align: 'center', edit: 'text' },
                {
                    field: 'value', title: '规则值', minWidth: 200, align: 'left', edit: (d) => d.type == 0 ? 'text' : false,
                    templet: (d) => {
                        return d.value.trim().split(',').filter(v => v != '').map((v, i) => {
                            return `<div class="layui-unselect layui-form-checkbox layui-form-checked spec-tag" lay-skin="tag">
                                        <div>${v}</div>
                                        <i class="layui-icon layui-icon-close" lay-on-spec="remove-tag" data-value="${v}" data-iv="${i}" data-index="${d.LAY_INDEX}"></i>
                                    </div>`
                        }).join('')
                    }
                },
                {
                    title: '操作', width: 100, align: 'center', templet: (d) => {
                        return `<div class="layui-btn-container">
                                    <button type="button" class="layui-btn layui-btn-xs layui-btn-primary layui-border-blue" lay-event="add" title="添加">
                                        <i class="layui-icon layui-icon-add-1"></i>
                                    </button>
                                    <button type="button" class="layui-btn layui-btn-xs layui-btn-primary layui-border-red" lay-event="remove" title="删除">
                                        <i class="layui-icon layui-icon-close"></i>
                                    </button>
                                </div>`
                    }
                }
            ]],
            data: data,
            done: (res) => {
                util.on('lay-on-spec', {
                    // 删除规格项
                    'remove-tag': function () {
                        let value = this.dataset.value || ''
                        let index = this.dataset.index
                        let iv = this.dataset.iv
                        layer.confirm(`确认删除该记录[${value}]么？`, { icon: 3, title: '注意' }, (layIndex) => {
                            let data = mTable.getData(MODULE_NAME)
                            let activeData = data[index]
                            let dataArr = activeData.value.trim().split(',').filter(v => v != '')
                            dataArr.splice(iv, 1)
                            data[index].value = dataArr.join(',')
                            mTable.reloadData(MODULE_NAME, { data: data });
                            // 渲染sku表格
                            skuTable.render(Object.assign({}, skuOptions, {
                                specData: data,
                                data: []
                            }))
                            layer.close(layIndex)
                        })
                    }
                })
            }
        });

        // 表格事件
        mTable.on(`toolbar(${MODULE_NAME})`, function (obj) {
            let data = mTable.getData(MODULE_NAME)
            switch (obj.event) {
                case 'add-spec':
                    // 添加规格行
                    data.push({ title: '', value: '' })
                    mTable.reloadData(MODULE_NAME, { data: data });
                    // 渲染sku表格
                    skuTable.render(Object.assign({}, skuOptions, {
                        specData: data,
                        data: []
                    }))
                    break;
                case 'build-spec':
                    // 生成规格
                    layer.confirm(`确认生成该规格明细么？`, { icon: 3, title: '注意' }, (layIndex) => {
                        let cartesianData = [...data]
                        // 验证规格
                        cartesianData.forEach(item => {
                            if (!item) {
                                layer.msg('规格不能为空', { icon: 2 });
                                return false;
                            }
                            if (!item.title) {
                                layer.msg('规格名称不能为空', { icon: 2 });
                                return false;
                            }
                            if (!item.value) {
                                layer.msg('请添加规格值', { icon: 2 });
                                return false;
                            }
                        })
                        let skuData = skuTableData(cartesian(cartesianData))
                        let skuOpt = Object.assign({}, skuOptions, {
                            specData: data,
                            data: skuData
                        })
                        // 渲染sku表格
                        skuTable.render(skuOpt)

                        layer.close(layIndex)
                    })
                    break;
            }
        })
        mTable.on(`tool(${MODULE_NAME})`, function (obj) {
            let data = mTable.getData(MODULE_NAME)
            switch (obj.event) {
                case 'add':
                    // 添加规格值
                    layer.prompt({ title: '请输入规格值' }, function (value, index, elem) {
                        if (value === '') {
                            return elem.focus()
                        }
                        let dataArr = data[obj.index].value.trim().split(',').filter(v => v != '')
                        dataArr.push(value)
                        data[obj.index].value = dataArr.join(',')
                        mTable.reloadData(MODULE_NAME, { data: data });
                        // 渲染sku表格
                        skuTable.render(Object.assign({}, skuOptions, {
                            specData: data,
                            data: []
                        }))
                        // 关闭 prompt
                        layer.close(index);
                    });
                    break;
                case 'remove':
                    // 删除行
                    layer.confirm(`确认删除该规格类型么？`, { icon: 3, title: '注意' }, (layIndex) => {
                        data.splice(obj.index, 1)
                        mTable.reloadData(MODULE_NAME, { data: data });
                        // 渲染sku表格
                        skuTable.render(Object.assign({}, skuOptions, {
                            specData: data,
                            data: []
                        }))
                        layer.close(layIndex)
                    })

                    break;
            }
        })
    }

    exports(MODULE_NAME, {
        // 渲染
        render: function (el, data, skuOptions) {
            skuOptions = skuOptions || {}
            render(el, data, skuOptions)
        },
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
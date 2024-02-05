layui.define(['mTable', 'mForm', 'imgSelect'], function (exports) {
    'use strict';

    // 插件名
    const MODULE_NAME = 'skuTable'
    const mTable = layui.mTable
    const mForm = layui.mForm
    const imgSelect = layui.imgSelect

    const skuTableID = 'sku-table'
    const skuSetTableID = 'sku-set-table'

    /**
     * 批量设置表格
     * 
     * @param {Object} imgSelectOptions imgSelect组件参数
     */
    function renderSetTable(el, imgSelectOptions) {
        // 表格列表
        const cols = [
            {
                field: 'price', title: '价格', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-set-input" step="0.1" lay-precision="2" data-field="price" class="layui-input sku-set-input" min="0" value="${d.price}">`
                }
            },
            {
                field: 'stock', title: '库存', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-set-input" step="1" data-field="stock" class="layui-input sku-set-input" min="0" value="${d.stock}">`
                }
            },
            {
                field: 'cost_price', title: '成本价', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-set-input" step="0.1" lay-precision="2" data-field="cost_price" class="layui-input sku-set-input" min="0" value="${d.cost_price}">`
                }
            },
            {
                field: 'market_price', title: '市场价', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-set-input" step="0.1" lay-precision="2" data-field="market_price" class="layui-input sku-set-input" min="0" value="${d.market_price}">`
                }
            },
            {
                field: 'weight', title: '重量', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-set-input" step="0.1" lay-precision="2" data-field="weight" class="layui-input sku-set-input" min="0" value="${d.weight}">`
                }
            },
            {
                field: 'volume', title: '体积', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-set-input" step="0.1" lay-precision="2" data-field="volume" class="layui-input sku-set-input" min="0" value="${d.volume}">`
                }
            },
            {
                field: 'code', title: '产品编码', align: 'center', minWidth: 140, templet: (d) => {
                    return `<input type="text" data-field="code" class="layui-input sku-set-input" value="${d.code}">`
                }
            }
        ];

        // 支持图片选择，开启图片列
        if (imgSelectOptions.api) {
            cols.unshift({
                field: 'img', title: '图片', align: 'center', width: 72,
                templet: (d) => {
                    if (d.img) {
                        return `<img src="${d.img}" alt="sku-img" class="sku-set-img"/>`
                    }

                    return `<div class="layui-upload-drag sku-set-img"><i class="layui-icon layui-icon-upload"></i></div>`
                },
            })
        }

        mTable.render({
            id: 'sku-set-table',
            elem: el,
            id: skuSetTableID,
            page: false,
            toolbar: '<div class="layui-btn-container">批量设置产品规格SKU</div>',
            defaultToolbar: [
                { title: '批量设置', layEvent: 'sku-set-build', icon: 'layui-icon-file' },
                { title: '设置单列', layEvent: 'sku-set-cols', icon: 'layui-icon-cols' },
                { title: '清空', layEvent: 'sku-set-clear', icon: 'layui-icon-refresh-1' }
            ],
            lineStyle: 'height: 56px;',
            cols: [cols],
            data: [{ img: '', price: '0', cost_price: '0', market_price: '0', stock: '0', weight: '0', volume: '0', code: '' }],
            done: function (res, curr, count, origin) {
                mTable.callback((table) => {
                    // 修改图片
                    if (imgSelectOptions.api) {
                        document.querySelector('.sku-set-img').addEventListener('click', (e) => {
                            imgSelect.show({
                                api: imgSelectOptions.api,
                                uploadURL: imgSelectOptions.uploadURL,
                                callback: (data) => {
                                    table.cache[skuSetTableID][0].img = data[0].url
                                    // 修改图片才重绘表格
                                    table.renderData(skuSetTableID);
                                }
                            })
                        })
                    }

                    // 修改input
                    document.querySelectorAll('.sku-set-input').forEach(el => {
                        el.addEventListener('change', (e) => {
                            let field = e.target.dataset.field
                            let value = e.target.value
                            // 修改input不需要重绘表格
                            table.cache[skuSetTableID][0][field] = ['code'].includes(field) ? value : parseFloat(value)
                        })
                    })
                    // 数字按钮
                    mForm.on('input-affix(sku-set-input)', function (obj) {
                        let el = obj.elem
                        let value = parseFloat(el.value)
                        let field = el.dataset.field
                        // 修改input不需要重绘表格
                        table.cache[skuSetTableID][0][field] = value
                    })
                })
            }
        })
        // 表格事件
        mTable.on(`toolbar(${skuSetTableID})`, function (obj) {
            switch (obj.event) {
                case 'sku-set-cols':
                    let setItems = [
                        { title: '价格', value: 'price' },
                        { title: '库存', value: 'stock' },
                        { title: '成本价', value: 'cost_price' },
                        { title: '市场价', value: 'market_price' },
                        { title: '库存', value: 'weight' },
                        { title: '体积', value: 'volume' },
                        { title: '产品编码', value: 'code' },
                    ];
                    if (imgSelectOptions.api) {
                        setItems.unshift({ title: '图片', value: 'img' })
                    }
                    let setItemsHTML = setItems.map(item => `<option value="${item.value}">${item.title}</option>`).join('')
                    layer.open({
                        type: 1,
                        id: 'sku-set-cols-dialog',
                        title: '选择设置列',
                        shade: 0.6, // 遮罩透明度
                        shadeClose: true,
                        content: `<form class="layui-form" lay-filter="sku-set-cols" style="padding: 12px">
                                    <select name="col"><option value="">请选择</option>${setItemsHTML}</select>
                                </form>`,
                        btn: ['确定', '取消'],
                        btn1: function (layIndex, layero, that) {
                            let val = mForm.val('sku-set-cols')
                            let col = val.col
                            if (col == '') {
                                return false
                            }

                            let setData = mTable.getData(skuSetTableID)
                            let newVal = {}
                            let setValue = setData[0][col]
                            newVal[col] = setValue

                            let data = mTable.getData(skuTableID)
                            let newData = data.map(item => {
                                return Object.assign({}, item, newVal)
                            })
                            mTable.reloadData(skuTableID, { data: newData });
                            layer.close(layIndex)
                        },
                        success: function (layero, index, that) {
                            layero.find('.layui-layer-content').css('overflow', 'visible')
                            mForm.render('select', 'sku-set-cols')
                        }
                    })
                    break;
                case 'sku-set-build':
                    // 批量设置规格
                    layer.confirm(`确认批量设置所有规格明细值么？`, { icon: 3, title: '注意' }, (layIndex) => {
                        let setData = mTable.getData(skuSetTableID)
                        let data = mTable.getData(skuTableID)
                        let newData = data.map(item => {
                            return Object.assign({}, item, setData[0])
                        })
                        mTable.reloadData(skuTableID, { data: newData });
                        layer.close(layIndex)
                    })
                    break;
                case 'sku-set-clear':
                    // 重置批量设置
                    mTable.reloadData(skuSetTableID, { data: [{ img: '', price: '0', cost_price: '0', market_price: '0', stock: '0', weight: '0', volume: '0', code: '' }] });
                    break;
            }
        })
    }

    /**
     * 渲染sku表格
     *
     * @param {*} el 
     * @param {*} imgSelectOptions 
     * @param {*} specData 规格数据
     * @param {*} data 表格数据
     */
    function renderTable(el, specData, data, imgSelectOptions, saveCallback) {
        // 规格明细
        // specData = [
        //     { "title": "颜色", "value": "红,黄,蓝,绿,青,紫" },
        //     { "title": "尺码", "value": "S,M,L,XL,XXL" }
        // ];
        // data = [
        //     { 'col-0': '红', 'col-1': 'S' },
        // ]

        // 表格列
        let colList = [{ type: 'numbers', title: '序', align: 'center', width: 50 }]
        // 规格列
        specData.forEach((item, i) => {
            let field = 'col-' + i;
            colList.push({ field: field, title: item.title, width: 86, align: 'center', merge: true })
        })
        // 支持图片选择，开启图片列
        if (imgSelectOptions.api) {
            colList.push({
                field: 'img', title: '图片', align: 'center', width: 72,
                templet: (d) => {
                    if (d.img) {
                        return `<img src="${d.img}" alt="sku-img" class="sku-img" data-index="${d.LAY_INDEX}"/>`
                    }

                    return `<div class="layui-upload-drag sku-img" data-index="${d.LAY_INDEX}"><i class="layui-icon layui-icon-upload"></i></div>`
                },
            })
        }
        // 数据列
        colList.push(
            {
                field: 'price', title: '价格', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-input" data-index="${d.LAY_INDEX}" step="0.1" lay-precision="2" data-field="price" class="layui-input sku-input" min="0" value="${d.price}">`
                }
            },
            {
                field: 'stock', title: '库存', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-input" data-index="${d.LAY_INDEX}" step="1" data-field="stock" class="layui-input sku-input" min="0" value="${d.stock}">`
                }
            },
            {
                field: 'cost_price', title: '成本价', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-input" data-index="${d.LAY_INDEX}" step="0.1" lay-precision="2" data-field="cost_price" class="layui-input sku-input" min="0" value="${d.cost_price}">`
                }
            },
            {
                field: 'market_price', title: '市场价', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-input" data-index="${d.LAY_INDEX}" step="0.1" lay-precision="2" data-field="market_price" class="layui-input sku-input" min="0" value="${d.market_price}">`
                }
            },
            {
                field: 'weight', title: '重量', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-input" data-index="${d.LAY_INDEX}" step="0.1" lay-precision="2" data-field="weight" class="layui-input sku-input" min="0" value="${d.weight}">`
                }
            },
            {
                field: 'volume', title: '体积', align: 'center', width: 120, templet: (d) => {
                    return `<input type="number" lay-affix="number" lay-filter="sku-input" data-index="${d.LAY_INDEX}" step="0.1" lay-precision="2" data-field="volume" class="layui-input sku-input" min="0" value="${d.volume}">`
                }
            },
            {
                field: 'code', title: '产品编码', align: 'center', minWidth: 140, templet: (d) => {
                    return `<input type="text" data-field="code" class="layui-input sku-input" data-index="${d.LAY_INDEX}" value="${d.code || ''}">`
                }
            }
        )

        // 存在保存回调
        if (typeof saveCallback === 'function') {
            colList.push({
                title: '操作', align: 'center', width: 100, fixed: 'right', templet: (d) => {
                    return `<div class="oper-btns" style="height: 48px; display: flex; align-items: center;"><button type="button" class="layui-btn" lay-event="save">保存</button></div>`
                }
            })
        }

        mTable.render({
            id: 'sku-table',
            elem: el,
            id: skuTableID,
            page: false,
            toolbar: '<div class="layui-btn-container">产品规格明细</div>',
            defaultToolbar: [],
            maxHeight: 540,
            lineStyle: 'height: 56px;',
            cols: [colList],
            data: data,
            done: function (res, curr, count) {
                mTable.callback((table) => {
                    // 修改图片
                    if (imgSelectOptions.api) {
                        document.querySelectorAll('.sku-img').forEach(el => {
                            let index = el.dataset.index;
                            el.addEventListener('click', (e) => {
                                imgSelect.show({
                                    api: imgSelectOptions.api,
                                    uploadURL: imgSelectOptions.uploadURL,
                                    callback: (data) => {
                                        table.cache[skuTableID][index].img = data[0].url
                                        // 修改图片才重绘表格
                                        table.renderData(skuTableID);
                                    }
                                })
                            })
                        })
                    }

                    // 修改input
                    document.querySelectorAll('.sku-input').forEach(el => {
                        el.addEventListener('change', (e) => {
                            let field = e.target.dataset.field
                            let index = el.dataset.index;
                            let value = e.target.value
                            // 修改input不需要重绘表格
                            table.cache[skuTableID][index][field] = ['code'].includes(field) ? value : parseFloat(value)
                        })
                    })
                    // 数字按钮
                    mForm.on('input-affix(sku-input)', function (obj) {
                        let el = obj.elem
                        let value = parseFloat(el.value)
                        let field = el.dataset.field
                        let index = el.dataset.index;
                        // 修改input不需要重绘表格
                        table.cache[skuTableID][index][field] = value
                    })

                    // 表格保存事件
                    table.on('tool(sku-table)', function (obj) {
                        saveCallback(obj, table)
                    })
                })
            }
        })
    }

    exports(MODULE_NAME, {
        // 格式化处理产品数据格式
        formatProductData: function (productData) {
            return productData.map(item => {
                let sku = item.sku
                sku.forEach(val => {
                    item[`col-${val.i}`] = val.v
                })

                return item
            })
        },
        // 渲染sku
        render: function (options) {
            const defaultValue = {
                setTable: '',
                skuTable: '',
                imgSelectOptions: {},
                specData: [],
                data: [],
            }
            const config = Object.assign({}, defaultValue, options)
            if (!config.setTable) {
                layer.msg('未定义sku设置表格元素(setTable属性)', { icon: 2 })
                return false;
            }
            if (!config.skuTable) {
                layer.msg('未定义sku产品表格元素(skuTable属性)', { icon: 2 })
                return false;
            }

            this.renderSetTable(config.setTable, config.imgSelectOptions)
            this.renderSkuTable(config.skuTable, config.specData, config.data, config.imgSelectOptions)
        },
        // 渲染规格设置表
        renderSetTable: function (el, imgSelectOptions) {
            imgSelectOptions = imgSelectOptions || {}
            renderSetTable(el, imgSelectOptions)
        },
        // 渲染sku表格
        renderSkuTable(el, specData, data, imgSelectOptions, saveCallback = null) {
            imgSelectOptions = imgSelectOptions || {}
            specData = specData || []
            data = data || []
            renderTable(el, specData, data, imgSelectOptions, saveCallback)
        },
        // 获取数据
        getData: function () {
            let data = mTable.getData(skuTableID)
            return data;
        },
        // 获取sku数据
        getSkuData: function () {
            let keys = ['img', 'price', 'cost_price', 'market_price', 'stock', 'weight', 'volume', 'code'];
            let data = mTable.getData(skuTableID)
            let options = mTable.callback((table) => {
                return table.getOptions(skuTableID)
            })
            if (!options || options.cols.length == 0 || options.cols[0].length == 0) {
                return []
            }
            let cols = []
            options.cols[0].forEach(item => {
                if (!keys.includes(item.field) && item.field) {
                    let i = item.field.split('-')[1]
                    cols.push({ field: item.field, title: item.title, sort: parseInt(i, 10) })
                }
            })
            // 排序
            let colData = cols.sort((v1, v2) => {
                if (v1.sort < v2.sort) {
                    return -1
                }
                if (v1.sort > v2.sort) {
                    return 1
                }
                return 0
            })
            let skuData = data.map(item => {
                // sku数据
                let obj = []
                colData.forEach(col => {
                    obj.push({
                        t: col.title,
                        v: item[col.field],
                        i: col.sort
                    })
                })
                return {
                    sku: JSON.stringify(obj),
                    img: item.img,
                    price: item.price,
                    cost_price: item.cost_price,
                    market_price: item.market_price,
                    stock: item.stock,
                    weight: item.weight,
                    volume: item.volume,
                    code: item.code,
                }
            })

            return skuData
        }
    })
})
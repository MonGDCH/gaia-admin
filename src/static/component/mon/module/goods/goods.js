layui.define(['util', 'laydate', 'element', 'cascader', 'http', 'mForm', 'mTable', 'markdown', 'imgSelect', 'tableSelect', 'xmSelect', 'attrTable', 'specTable', 'skuTable'], function (exports) {
    'use strict';

    const util = layui.util
    const laydate = layui.laydate
    const element = layui.element
    const cascader = layui.cascader
    const http = layui.http
    const mForm = layui.mForm
    const mTable = layui.mTable
    const imgSelect = layui.imgSelect
    const tableSelect = layui.tableSelect
    const xmSelect = layui.xmSelect
    const attrTable = layui.attrTable
    const specTable = layui.specTable
    const skuTable = layui.skuTable
    const markdown = layui.markdown

    const MODULE_NAME = 'goods'
    // 加载模块资源，不动态加载css, 会导致表格宽度异常
    // const modFile = layui.cache.modules[MODULE_NAME];
    // const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
    // layui.link(modPath + '/' + MODULE_NAME + '.css?v=' + (typeof window.version == 'string' ? window.version : Math.random()))

    class Goods {
        // 配置参数
        options = {}
        // sku参数
        skuOptions = {}
        // 编辑器
        editor = null
        // 模型选择器
        models_select = null

        // 构造方法
        constructor(options) {
            this.options = options
            // sku表格配置
            this.skuOptions = {
                setTable: '#sku-set-table',
                skuTable: '#sku-table',
                imgSelectOptions: {
                    api: this.options.imgSelectOptions.api,
                    uploadURL: this.options.imgSelectOptions.uploadURL
                },
            }
            this.init()
            this.bindEvent()
        }

        // 渲染
        init() {
            const options = this.options
            // 渲染上下架时间
            laydate.render({
                elem: '#sale_time',
                type: 'datetime',
                range: ['#start_time', '#end_time'],
                rangeLinked: true,
                format: 'yyyy-MM-dd HH:mm:ss',
                calendar: true,
                mark: {
                    '0-12-31': '跨年',
                    '0-11-11': '双十一',
                    '0-12-12': '双十二',
                    '0-06-18': '六一八',
                    '0-08-18': '八一八',
                }
            })

            // 渲染分类选择
            cascader({
                elem: '#cate-cat',
                value: options.cate_cat || [],
                clearable: true,
                options: options.cateList || [],
                placeholder: "请选择产品分类，必选",
                props: {
                    multiple: true,
                    checkStrictly: true,
                    value: 'id',
                    label: 'name',
                    children: 'children',
                    disabled: 'disabled'
                }
            })

            // 图片选择
            document.querySelector('#upload-thumb-btn').addEventListener('click', () => {
                imgSelect.show({
                    api: options.imgSelectOptions.api,
                    uploadURL: options.imgSelectOptions.uploadURL,
                    callback: (data, index) => {
                        document.querySelector('#goods-thumb-box').classList.remove('hidden')
                        document.querySelector('#thumb').value = data[0].url
                        document.querySelector('#upload-thumb-img').src = data[0].url
                    }
                })
            })

            // 轮播图选择
            document.querySelector('#upload-covers-img-btn').addEventListener('click', () => {
                imgSelect.show({
                    api: options.imgSelectOptions.api,
                    uploadURL: options.imgSelectOptions.uploadURL,
                    limit: 6, // 单次最多选择6张图片
                    callback: (data, index) => {
                        let html = data.map(item => {
                            return `<div class="upload-covers-img">
                                <img class="covers-img" lay-on="img-preview" src="${item.url}" alt="${item.name}">
                                <div class="clear-img" title="删除图片" lay-on="clear-img">
                                    <i class="layui-icon layui-icon-clear"></i>
                                </div>
                            </div>`
                        })
                        document.querySelector('#upload-covers-img-btn').insertAdjacentHTML('beforebegin', html.join(''))
                    }
                })
            })
            const coversImgListTemp = []
            const coversImgList = options.covers || []
            coversImgList.forEach(v => {
                if (v) {
                    coversImgListTemp.push(`<div class="upload-covers-img">
                                                <img class="covers-img" lay-on="img-preview" src="${v}" alt="covers img">
                                                <div class="clear-img" title="删除图片" lay-on="clear-img">
                                                    <i class="layui-icon layui-icon-clear"></i>
                                                </div>
                                            </div>`)
                }
            })
            if (coversImgListTemp.length > 0) {
                document.querySelector('#upload-covers-img-btn').insertAdjacentHTML('beforebegin', coversImgListTemp.join(''))
            }

            // 关联推广商品
            document.querySelector('#select-recommends-goods-btn').addEventListener('click', function (e) {
                tableSelect.render({
                    url: options.productRecommendsApi || '',
                    title: '关联推荐产品',
                    cols: [
                        { field: 'id', title: 'ID', width: 80, align: 'center' },
                        { field: 'thumb', title: '图片', width: 80, align: 'center', templet: (d) => mTable.format.image(d.thumb) },
                        { field: 'name', title: '名称' }
                    ],
                    checked: getRecommends(),
                    callback: (data, index) => {
                        // 过滤已选择的产品
                        let recommends = getRecommends()
                        let newData = data.filter(item => {
                            return !recommends.includes(item.id)
                        })
                        let html = newData.map(item => {
                            return `<div class="recommends-goods-img">
                                        <img class="recommends-goods" src="${item.thumb}" alt="${item.name}" lay-on="goods-preview"
                                        data-id="${item.id}" data-name="${item.name}" data-cate="${item.cate_txt}" data-valuation="${item.valuation}">
                                        <div class="clear-img" title="删除" lay-on="clear-img">
                                            <i class="layui-icon layui-icon-clear"></i>
                                        </div>
                                    </div>`
                        })
                        document.querySelector('#select-recommends-goods-btn').insertAdjacentHTML('beforebegin', html.join(''))
                    }
                })
            })
            const recommendsListTemp = []
            const recommendsList = options.recommends || []
            recommendsList.forEach(item => {
                recommendsListTemp.push(`<div class="recommends-goods-img">
                                            <img class="recommends-goods" src="${item.thumb}" alt="${item.name}" lay-on="goods-preview"
                                            data-id="${item.id}" data-name="${item.name}" data-cate="${item.cate_txt}" data-valuation="${item.valuation}">
                                            <div class="clear-img" title="删除" lay-on="clear-img">
                                                <i class="layui-icon layui-icon-clear"></i>
                                            </div>
                                        </div>`)
            })
            if (recommendsListTemp.length > 0) {
                document.querySelector('#select-recommends-goods-btn').insertAdjacentHTML('beforebegin', recommendsListTemp.join(''))
            }

            // 内容详情
            markdown.render('content', options.imgSelectOptions.uploadURL, options.markdown || '')

            // 选择产品模型
            this.models_select = xmSelect.render({
                el: '#models_select',
                tips: '选择模型快速生成产品规格属性',
                radio: true,
                clickClose: true,
                filterable: true,
                paging: true,
                pageSize: 5,
                model: {
                    icon: 'hidden',
                    label: {
                        type: 'text'
                    }
                },
                theme: { color: '#5FB878' },
                toolbar: { show: true, list: ['', '', '', '', '', '', '', '', '', '', '', '', '', 'CLEAR'] },
                template({ item, sels, name, value }) {
                    return `${item.name}<div class="models-select-tmp">${item.remark}</div>`
                },
                data: options.moduleList || [],
            })
            // 渲染属性表格
            attrTable.render('#attr-table', options.attrs || [])
            // 渲染规格表格
            specTable.render('#spec-table', options.specs || [], this.skuOptions)
            // 渲染sku表格
            skuTable.render(Object.assign({}, this.skuOptions, {
                specData: options.specs || [],
                data: skuTable.formatProductData(options.product || []),
            }))

            // 渲染表单
            mForm.render()
            // 回顶
            util.fixbar()
        }

        // 绑定事件
        bindEvent() {
            const options = this.options
            // 是否限购
            mForm.on('switch(buy_limit)', (data) => {
                if (data.elem.checked) {
                    document.querySelector('#limit-box').classList.remove('hidden')
                } else {
                    document.querySelector('#limit-box').classList.add('hidden')
                }
                mForm.val('goods', {
                    buy_limit_max: "0",
                    buy_limit_min: "1",
                    buy_limit_round: "1",
                    buy_limit_type: "0"
                })
            })
            // 是否需要配送
            mForm.on('radio(shipping)', (data) => {
                if (data.value == '1') {
                    document.querySelector('#shipping-tmp').classList.remove('hidden')
                } else {
                    document.querySelector('#shipping-tmp').classList.add('hidden')
                }
                mForm.val('goods', { shipping_id: 0 })
            })
            // lay-on事件监听
            util.on('lay-on', {
                // 流程跳转
                'jump-tab': function () {
                    let id = this.dataset.id
                    element.tabChange('goods-tab', id)
                },
                // 流程跳转验证
                'check-jump-tab': function () {
                    let id = this.dataset.id
                    let check = this.dataset.check
                    switch (check) {
                        case 'basic':
                            mForm.callback((form) => {
                                if (!form.validate('#cate-cat')) {
                                    return false;
                                }
                                if (!form.validate('#name')) {
                                    return false;
                                }
                                if (!form.validate('#thumb')) {
                                    return false
                                }
                                if (!form.validate('#start_time')) {
                                    return false
                                }
                                if (!form.validate('#end_time')) {
                                    return false
                                }
                                if (!form.validate('#valuation')) {
                                    return false;
                                }
                                element.tabChange('goods-tab', id)
                            })
                            break;
                        case 'info':
                            mForm.callback((form) => {
                                if (!form.validate('#unit')) {
                                    return false
                                }
                                element.tabChange('goods-tab', id)
                            })
                            break;
                        case 'sku':
                            // 校验规格属性
                            if (!checkSpecAttr()) {
                                return false;
                            }

                            element.tabChange('goods-tab', id)
                            break;
                    }
                },
                // 删除轮播图节点
                'clear-img': function (attr, obj, type) {
                    const el = this.parentNode
                    layer.confirm('确认删除该记录么？', { icon: 3, title: '注意' }, (index) => {
                        el.remove()
                        layer.close(index)
                    })
                },
                // 生成规格属性
                'select-models': () => {
                    let vals = this.models_select.getValue('value')
                    if (vals.length > 0) {
                        layer.confirm('选择商品模型将清空现有规格属性数据重新生成，是否继续？', { title: '温馨提示', icon: 3 }, async (index) => {
                            const res = await http.get(options.getModelsURL, { idx: vals[0] })
                            // 属性表格
                            attrTable.reloadData(res.data.attr_info)
                            // 规格表格
                            specTable.reloadData(res.data.spec_info)
                            // sku表格
                            skuTable.render(Object.assign({}, this.skuOptions, { specData: res.data.spec_info, data: [] }))
                            layer.close(index)
                        })
                    }
                },
                // 查看关联推广产品
                'goods-preview': function () {
                    let id = this.dataset.id
                    let name = this.dataset.name
                    // let cate = this.dataset.cate
                    let valuation = this.dataset.valuation
                    const tmp = `<div style="padding: 0 10px 20px 10px">
                                    <table class="layui-table" lay-even>
                                        <colgroup><col width="100"><col></colgroup>
                                        <tbody>
                                            <tr> <td>ID</td> <td>${id}</td> </tr>
                                            <tr> <td>名称</td> <td>${name}</td> </tr>
                                            <tr> <td>参考价</td> <td>${valuation}</td> </tr>
                                        </tbody>
                                    </table>
                                </div>`
                    layer.open({
                        type: 1,
                        title: '产品信息',
                        area: ['520px', 'auto'],
                        scrollbar: false,
                        shadeClose: true,
                        content: tmp
                    })
                },
                'submit-form': function () {
                    mForm.callback((form) => {
                        form.submit('goods', function (data) {
                            mForm.util.submitData(data, () => {
                                // 操作成功
                                window.location.href = options.homeURL
                            }, null, (form) => {
                                // 补充提交数据
                                return getSubmitData(form)
                            }, () => {
                                // 提交前操作
                                return checkSpecAttr()
                            })
                        })
                    })
                }
            })

            // 表单提交
            mForm.submit('submit', (data, ret) => {
                // 成功返回列表
                window.location.href = options.homeURL
            }, null, (form) => {
                return getSubmitData(form)
            }, (data, form) => {
                return checkSpecAttr()
            })
        }
    }

    // 获取关联推广产品
    function getRecommends() {
        let recommends = []
        document.querySelectorAll('.recommends-goods').forEach(e => {
            recommends.push(parseInt(e.dataset.id, 10))
        })

        return recommends
    }

    // 辅助方法，验证规格与属性
    function checkSpecAttr() {
        // 校验属性
        let attrData = attrTable.getData()
        if (attrData.length == 0) {
            layer.msg('请添加产品属性', { icon: 5 })
            return false
        }
        for (let i = 0; i < attrData.length; i++) {
            let line = attrData[i]
            if (line.title == '' || line.value == '') {
                layer.msg('请添加产品属性名称、值不能为空', { icon: 5 })
                return false
            }
            if (line.type > 0 && (!line.selected || line.selected == '')) {
                layer.msg('请添加产品属性值不能为空', { icon: 5 })
                return false
            }
        }
        // 校验规格
        let specData = specTable.getData()
        if (specData.length == 0) {
            layer.msg('请添加产品规格', { icon: 5 })
            return false
        }
        for (let i = 0; i < specData.length; i++) {
            let line = specData[i]
            if (line.title == '' || line.value == '') {
                layer.msg('请添加产品规格名称、值不能为空', { icon: 5 })
                return false
            }
        }
        // 校验sku
        let skuData = skuTable.getSkuData()
        if (skuData.length == 0) {
            document.querySelector('[lay-event="build-spec"]').style.borderColor = '#ff0000'
            layer.msg('请先生成产品规格明细', { icon: 5 })
            return false
        }
        const checkList = { price: '价格', cost_price: '成本价', market_price: '市场价', stock: '库存', weight: '重量', volume: '体积' }
        for (let i = 0; i < skuData.length; i++) {
            let line = skuData[i]
            for (let key in checkList) {
                if (line[key] === '' || line[key] == null || line[key] == undefined || isNaN(line[key])) {
                    layer.msg(`产品规格明细第${i + 1}行[${checkList[key]}]必须为数字`, { icon: 5 })
                    return false
                }
            }
        }

        return true;
    }

    // 辅助方法，获取提交表单的数据
    function getSubmitData(form) {
        // 轮播图库
        let covers = []
        document.querySelectorAll('.covers-img').forEach(e => {
            covers.push(e.src)
        })
        // 关联推广产品
        let recommends = getRecommends()
        // 产品属性
        let attrs = attrTable.getData()
        // 产品规格
        let specs = specTable.getData()
        // 产品sku
        let sku = skuTable.getSkuData()
        // 是否限购
        let buy_limit = form.field.buy_limit || 0
        // 是否扣减库存
        let stock_reduce = form.field.stock_reduce || 0
        // 是否热门
        let is_hot = form.field.is_hot || 0
        // 是否推荐
        let is_recommend = form.field.is_recommend || 0
        // 是否新品
        let is_new = form.field.is_new || 0
        // 是否显示库存
        let stock_visible = form.field.stock_visible || 0
        // 是否显示销量
        let sales_visible = form.field.sales_visible || 0
        // 上架时间
        let sale_start_time = Math.ceil((new Date(form.field.start_time)).getTime() / 1000)
        // 下架时间
        let sale_end_time = Math.ceil((new Date(form.field.end_time)).getTime() / 1000)
        // 产品分类
        let cate_cat = JSON.parse(form.field.cate_cat) || []
        return {
            is_hot: is_hot,
            is_new: is_new,
            buy_limit: buy_limit,
            stock_reduce: stock_reduce,
            is_recommend: is_recommend,
            stock_visible: stock_visible,
            sales_visible: sales_visible,
            imgs: covers.join(','),
            recommends: recommends.join(','),
            cate_cat: cate_cat.join(','),
            attrs: JSON.stringify(attrs),
            specs: JSON.stringify(specs),
            sku: JSON.stringify(sku),
            sale_start_time: sale_start_time,
            sale_end_time: sale_end_time
        }
    }

    // 导出
    exports(MODULE_NAME, {
        // 渲染
        render(option) {
            return new Goods(option);
        }
    });
})
/**
 *  图片选择器
 * 
 *  document.querySelector('#imgSelectBtn').addEventListener('click', () => {
        imgSelect.show("<?=$this->url('/files')?>", "<?=$this->url('/upload')?>", (data, index) => {
            console.log(data)
            console.log(index)

            // 返回false，则不自动关闭弹窗
            return false
        });
    })
 */
layui.define(['laypage', 'http', 'mUpload'], function (exports) {
    'use strict';

    // 插件名
    const MODULE_NAME = 'imgSelect'
    const laypage = layui.laypage
    const http = layui.http
    const mUpload = layui.mUpload
    // 加载模块资源
    const modFile = layui.cache.modules[MODULE_NAME];
    const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
    layui.link(modPath + '/imgSelect.css?v=' + (typeof window.version == 'string' ? window.version : Math.random()))

    // 基础模板
    const tpl = `<div id="chooseimg">
                    <div class="img-select-oper">
                        <div class="layui-input-group">
                            <input type="text" id="img-select-search-filename" placeholder="图片名称" class="layui-input" lay-affix="clear">
                            <div class="layui-input-suffix">
                                <button class="layui-btn layui-btn-primary" id="img-select-search-btn">搜索</button>
                                <button type="button" class="layui-btn layui-btn-primary" id="img-select-upload">上传图片</button>
                            </div>
                        </div>
                        <button class="layui-btn layui-bg-blue" id="img-select-success">使用选中图片</button>
                    </div>
                    <div class="img-select-container">
                        <ul id="img-select-list" class="img-select-list"></ul>
                    </div>
                    <div class="img-select-page">
                        <div id="img-select-page"></div>
                    </div>
                </div>`

    const imgSelect = {
        // leyer弹窗ID
        LayerID: null,
        // 当前页
        page: 1,
        // 每页显示数据
        limit: 18,

        /**
         * 打开选择器
         *
         * @param api   文件列表的API
         * @param uploadURL 上传文件API，空则不显示上传图片按钮
         * @param limit 限制选择数
         * @param callback  选择图片、上传图片回调方法
         */
        show: function (options) {
            let { api, uploadURL, limit, callback } = options;
            if (!api) {
                layer.msg('文件列表 api 参数必须', { icon: 2 })
                return false;
            }
            // 默认单选
            if (typeof limit != 'number') {
                limit = 1;
            }

            imgSelect.LayerID = layer.open({
                type: 1,
                title: '图片选择',
                area: ['680px', '510px'],
                scrollbar: false,
                shadeClose: true,
                content: tpl,
                success: function (layero, index) {
                    // 获取数据，进行渲染
                    imgSelect.getDataRender(api, 1);
                    // 搜索
                    document.querySelector('#img-select-search-btn').addEventListener('click', () => {
                        imgSelect.getDataRender(api, 1);
                    })
                    // 使用选中的图片
                    document.querySelector('#img-select-success').addEventListener('click', () => {
                        if (document.querySelectorAll('#chooseimg .img-select-item.active').length < 1) {
                            return false;
                        }

                        if (typeof callback == 'function') {
                            let data = [];
                            document.querySelectorAll('#chooseimg .img-select-item.active').forEach(el => {
                                let url = el.dataset.url
                                let name = el.dataset.name
                                data.push({ url: url, name: name })
                            })
                            let ret = callback.call(this, data, index)
                            if (ret === false) {
                                return;
                            }
                        }

                        layer.close(index)
                    })

                    // 选择图片
                    layero.find('#chooseimg').on('click', '.img-select-item', function () {
                        if (this.classList.contains('active')) {
                            this.classList.remove('active')
                        } else {
                            if (document.querySelectorAll('#chooseimg .img-select-item.active').length >= limit) {
                                if (limit == 1) {
                                    // 单张图片特殊处理
                                    document.querySelector('#chooseimg .img-select-item.active').classList.remove('active')
                                } else {
                                    layer.msg(`最多选择${limit}张图片`, { icon: 2 })
                                    return false;
                                }
                            }
                            this.classList.add('active')
                        }
                    })

                    // 图像上传
                    if (uploadURL) {
                        mUpload.render({
                            elem: '#img-select-upload',
                            url: uploadURL,
                            accept: 'images',
                            done: function (ret) {
                                if (ret.code != '1') {
                                    layer.msg(ret.msg, { icon: 2 });
                                    return;
                                }

                                imgSelect.getDataRender(api, 1)
                            }
                        })
                    } else {
                        document.querySelector('#img-select-upload').remove()
                    }
                }
            })
        },
        // 获取数据，进行渲染
        async getDataRender(api, page) {
            imgSelect.page = page
            let filename = document.querySelector('#img-select-search-filename').value
            const result = await http.get(api, { type: 'img', page: page, filename: filename, limit: imgSelect.limit })
            if (result.code == '1') {
                imgSelect.render(api, result.data, result.count)
            } else {
                layer.msg('获取图片资源失败', { icon: 2 });
            }
        },
        // 渲染
        render: function (api, data, count) {
            // <li class="img-select-item" data-url="https://s3.ax1x.com/2020/11/20/DQ1Tns.jpg" title="logo">
            //     <img src="https://s3.ax1x.com/2020/11/20/DQ1Tns.jpg" alt="logo">
            // </li>
            if (data.length > 0) {
                let html = data.map(item => {
                    return `<li class="img-select-item" data-url="${item.url}" data-name="${item.filename}" title="${item.filename}">
                                <img src="${item.url}" alt="${item.filename}">
                                <div class="img-select-item-badge">&#10003</div>
                            </li>`
                })

                document.querySelector('#img-select-list').innerHTML = html.join('')
            } else {
                document.querySelector('#img-select-list').innerHTML = '<p class="text-center">暂无数据</p>'
            }

            if (count > 0) {
                laypage.render({
                    elem: 'img-select-page',
                    count: count,
                    limit: imgSelect.limit,
                    curr: imgSelect.page,
                    jump: function (obj, first) {
                        if (!first) {
                            let curr = obj.curr
                            imgSelect.getDataRender(api, curr)
                        }
                    }
                });
            }
        }
    }

    exports(MODULE_NAME, imgSelect)
})
layui.define(['layer', 'form', 'http', 'carousel', 'cascader', 'mUpload', 'xmSelect'], function (exports) {
    "use strict";

    // 模块名
    const MOD_NAME = 'formRender'
    const layer = layui.layer
    const form = layui.form
    const http = layui.http
    const carousel = layui.carousel
    const cascader = layui.cascader
    const mUpload = layui.mUpload
    const xmSelect = layui.xmSelect

    // 加载模块资源
    const modFile = layui.cache.modules[MOD_NAME];
    const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
    layui.link(modPath + '/form-render.css?v=' + (typeof window.version == 'string' ? window.version : Math.random()))

    // 渲染设计表单
    function renderForm(el, config, formConfig, extendConfig) {
        if (typeof Vue == 'undefined') {
            console.error('表单渲染依赖Vue3，请先引入Vue3')
            return false;
        }

        const { createApp, ref, computed, onMounted } = Vue
        const formContainer = createApp({
            props: ['config', 'formConfig', 'extendConfig'],
            setup(props) {
                // 组件列表
                const list = computed(() => props.config)
                const showSubmit = computed(() => props.formConfig.submit && props.formConfig.submit.enable)

                // 表单配置
                const formClass = computed(() => {
                    let list = ['layui-form']
                    if (props.formConfig.align == '1') {
                        list.push('vertical-form')
                    }

                    return list;
                })

                // 初始化
                onMounted(() => {
                    form.render()
                    form.on('submit(submit)', (data) => {
                        http.post(props.formConfig.submit.url, Object.assign({}, data.field, props.formConfig.data || {})).then(ret => {
                            if (props.formConfig.submit.handler && typeof props.formConfig.submit.handler == 'function') {
                                props.formConfig.submit.handler.call(this, ret)
                                return;
                            }

                            if (ret.code != '1') {
                                layer.msg(ret.msg)
                                return false;
                            }
                            layer.msg(ret.msg)
                        })
                        return false;
                    });
                })

                return { list, formClass, showSubmit };
            },
            template: `<form :class="formClass" method="post">
                            <div class="layui-form-item" :style="{width: (item.width || 100) + '%'}" v-for="item in list">
                                <mon-form-item-view :item="item" :extend="extendConfig"></mon-form-item-view>
                            </div>
                            <div class="layui-form-item" v-if="showSubmit">
                                <div class="layui-input-block text-center layui-padding-3">
                                    <div class="layui-font-14 layui-padding-2">感谢您的参与</div>
                                    <button type="submit" class="layui-btn layui-btn-success" lay-submit lay-filter="submit"> 提 交 </button>
                                </div>
                            </div>
                        </form>`
        }, { config: config, formConfig: formConfig, extendConfig: extendConfig })

        // 组件注入
        formContainer.component('mon-input', {
            props: ['item'],
            setup(props, context) {
                // 格式化处理验证规则
                const formatVerify = computed(() => {
                    const result = props.item.verify.split('|').filter(item => item != '')
                    if (props.item.required) {
                        result.push('required')
                    }

                    return result.join('|')
                })
                let reqtext = `请填写${props.item.label}`

                return { formatVerify, reqtext };
            },
            template: `<input :type="item.type" :name="item.name" :lay-verify="formatVerify" :lay-reqtext="reqtext"
                            :placeholder="item.placeholder" :max="item.max" :min="item.min" :lay-affix="item.type"
                            :readonly="item.readonly" :disabled="item.disabled" :value="item.data_default"
                            :maxlength="item.maxlength" lay-verType="tips" class="layui-input" />
                        </div>`
        }).component('mon-textarea', {
            props: ['item'],
            setup(props) {
                // 格式化处理验证规则
                const formatVerify = computed(() => {
                    return (props.item.required) ? 'required' : ''
                })
                let reqtext = `请填写${props.item.label}`

                return { formatVerify, reqtext }
            },
            template: `<textarea :name="item.name" :maxlength="item.maxlength" :lay-verify="formatVerify" :lay-reqtext="reqtext" :placeholder="item.placeholder" :readonly="item.readonly" :disabled="item.disabled" lay-verType="tips" class="layui-textarea">{{item.data_default}}</textarea>`
        }).component('mon-radio', {
            props: ['item'],
            setup(props) { },
            template: `<input v-for="line in item.options" type="radio" :name="item.name" :value="line.value" :title="line.title" :checked="line.value == item.data_default" :disabled="item.disabled">`
        }).component('mon-checkbox', {
            props: ['item'],
            setup(props) { },
            template: `<input v-for="line in item.options" type="checkbox" :name="item.name + '[]'" :value="line.value" :title="line.title" :checked="item.defaultValues.includes(line.value)" :disabled="item.disabled"`
        }).component('mon-select', {
            props: ['item'],
            setup(props) {
                // 格式化处理验证规则
                const formatVerify = computed(() => {
                    return (props.item.required) ? 'required' : ''
                })
                // 搜索模式
                const search = computed(() => {
                    return props.item.lay_search ? 'lay-search' : ''
                })
                let reqtext = `请填写${props.item.label}`
                return { formatVerify, search, reqtext }
            },
            template: `<select :name="item.name" :disabled="item.disabled" :lay-verify="formatVerify" :lay-reqtext="reqtext" lay-verType="tips" :[search]="">
                        <option v-for="line in item.options" :value="line.value" :selected="line.value == item.data_default">{{line.title}}</option>
                    </select>`
        }).component('mon-xmSelect', {
            props: ['item'],
            setup(props) {
                const xmEl = ref(null)
                const data = props.item.options.map(item => {
                    return {
                        name: item.title,
                        value: item.value,
                        selected: props.item.defaultValues.includes(item.value),
                    }
                })

                onMounted(() => {
                    xmSelect.render({
                        el: xmEl.value,
                        name: props.item.name,
                        data: data,
                        layVerify: props.item.required ? 'required' : '',
                        layVerType: 'tips',
                        filterable: props.item.lay_search,
                        disabled: props.item.disabled,
                        autoRow: true,
                        paging: true,
                        pageSize: 5,
                        toolbar: {
                            show: true,
                        }
                    })
                })

                return { xmEl }
            },
            template: `<div ref="xmEl"></div>`
        }).component('mon-date', {
            props: ['item'],
            setup(props) {
                const dateEl = ref(null)

                onMounted(() => {
                    layui.laydate.render({
                        elem: dateEl.value,
                        type: props.item.data_datetype,
                        range: props.item.data_range,
                        rangeLinked: true,
                        fullPanel: true,
                        max: props.item.data_maxvalue,
                        min: props.item.data_minvalue,
                        format: props.item.data_dateformat,
                        value: props.item.data_default
                    });
                })
                // 格式化处理验证规则
                const formatVerify = computed(() => {
                    return (props.item.required) ? 'required' : ''
                })
                let reqtext = `请填写${props.item.label}`
                return { dateEl, formatVerify, reqtext }
            },
            template: ` <input ref="dateEl" :lay-verify="formatVerify" lay-verType="tips" :lay-reqtext="reqtext" type="text" class="layui-input" :name="item.name" :placeholder="item.placeholder" :readonly="item.readonly" :disabled="item.disabled">`
        }).component('mon-colorpicker', {
            props: ['item'],
            setup(props) {
                const colorInput = ref(null)
                const colorSelect = ref(null)

                onMounted(() => {
                    layui.colorpicker.render({
                        elem: colorSelect.value,
                        predefine: true,
                        alpha: true,
                        color: colorInput.value.value,
                        done: function (color) {
                            colorInput.value.value = color
                        }
                    });
                })

                return { colorInput, colorSelect }
            },
            template: `<input type="hidden" :name="item.name" :value="item.data_default" ref="colorInput" /><div ref="colorSelect"></div>`
        }).component('mon-slider', {
            props: ['item'],
            setup(props) {
                const sliderInput = ref(null)
                const sliderSelect = ref(null)

                onMounted(() => {
                    layui.slider.render({
                        elem: sliderSelect.value,
                        type: 'default',
                        min: props.item.data_min,
                        max: props.item.data_max,
                        step: props.item.data_step,
                        showstep: props.item.data_showstep,
                        theme: props.item.data_theme,
                        input: props.item.data_input,
                        value: props.item.data_default,
                        change: function (value) {
                            sliderInput.value.value = value
                        }
                    })
                })

                return { sliderInput, sliderSelect }
            },
            template: `<div style="padding-top: 16px"><input type="hidden" :name="item.name" ref="sliderInput" /><div ref="sliderSelect"></div><div>`
        }).component('mon-rate', {
            props: ['item'],
            setup(props) {
                const rateInput = ref(null)
                const rateBox = ref(null)
                onMounted(() => {
                    layui.rate.render({
                        elem: rateBox.value,
                        half: props.item.data_half,
                        length: props.item.data_length,
                        theme: props.item.data_theme,
                        readonly: props.item.readonly,
                        value: props.item.data_default,
                        choose: function (value) {
                            rateInput.value.value = value
                        }
                    })
                })

                return { rateInput, rateBox }
            },
            template: `<input type="hidden" :name="item.name" ref="rateInput" /><div ref="rateBox"></div>`
        }).component('mon-switch', {
            props: ['item'],
            setup(props) {
                return {}
            },
            template: `<input type="checkbox" :name="item.name" value="1" title="ON|OFF" lay-skin="switch" :checked="item.data_default == '1'" :disabled="item.disabled" />`
        }).component('mon-address', {
            props: ['item', 'extend'],
            setup(props) {
                const cascaderBox = ref(null)
                const pca = ref('')
                const detail = ref('')
                const address = computed(() => {
                    return pca.value + ' ' + detail.value
                })
                // 格式化处理验证规则
                const formatVerify = computed(() => {
                    return (props.item.required) ? 'required' : ''
                })
                let reqtext = `请填写${props.item.label}`
                onMounted(() => {
                    const ca = cascader({
                        elem: cascaderBox.value,
                        options: props.extend.region,
                        clearable: true,
                        filterable: true,
                        showAllLevels: true,
                        disabled: props.item.disabled,
                        placeholder: '请选择省市区',
                        props: {
                            value: 'name',
                            label: 'name',
                            children: 'children',
                            strictMode: true,
                        }
                    });
                    ca.changeEvent((value, node) => {
                        pca.value = ca.getCheckedValues().join(' ')
                    })
                })


                return { detail, cascaderBox, address, formatVerify, reqtext }
            },
            template: `<input type="hidden" :name="item.name" :value="address" :lay-verify="formatVerify" :lay-reqtext="reqtext" />
                        <div ref="cascaderBox"></div>
                        <textarea :disabled="item.disabled" v-model="detail" placeholder="详情地址" class="layui-textarea" style="margin-top: 8px"></textarea>`
        }).component('mon-upload', {
            props: ['item'],
            setup(props) {
                const uploadInput = ref(null)
                const uploadBox = ref(null)
                onMounted(() => {
                    mUpload.render({
                        elem: uploadBox.value,
                        url: props.item.upload_url,
                        accept: props.item.data_accept || file,
                        size: props.item.data_size || 0,
                        done: function (ret, index, upload) {
                            if (ret.code != '1') {
                                layer.msg(ret.msg, { icon: 2 });
                                return;
                            }
                            let url = ret.data[0].url
                            uploadInput.value.value = url
                        },
                    })
                })

                return { uploadInput, uploadBox }
            },
            template: `<input type="hidden" :name="item.name" ref="uploadInput" />
                        <div class="layui-upload-drag" id="upload-demo" ref="uploadBox">
                            <i class="layui-icon layui-icon-upload"></i>
                            <p>点击上传，或将文件拖拽到此处</p>
                        </div>`
        }).component('mon-note', {
            props: ['item'],
            setup(props) {
                return {}
            },
            template: `<blockquote class="layui-elem-quote">{{item.textarea}}</blockquote>`
        }).component('mon-subtraction', {
            props: ['item'],
            setup(props) {
                return {}
            },
            template: `<hr :class="item.border">`
        }).component('mon-carousel', {
            props: ['item'],
            setup(props) {
                const carouselBox = ref(null)
                const styleList = computed(() => {
                    return {
                        height: 'auto',
                        width: props.item.width + '%'
                    }
                })
                onMounted(() => {
                    carousel.render({
                        elem: carouselBox.value,
                        anim: props.item.anim,
                        autoplay: props.item.autoplay,
                        interval: parseInt(props.item.interval, 10) > 1000 ? props.item.interval : 1000,
                        arrow: props.item.arrow ? 'hover' : 'none',
                        indicator: props.item.indicator ? 'inside' : 'none',
                        width: 'auto',
                        height: props.item.height + 'px',
                    });

                    carouselBox.value.querySelectorAll('.layui-carousel-arrow').forEach(el => {
                        el.type = 'button'
                    })
                })
                return { carouselBox, styleList }
            },
            template: `<div class="layui-carousel" ref="carouselBox" :style="styleList">
                            <div carousel-item>
                                <div v-for="img in item.imgs"><img class="carousel-img" :src="img"></div>
                            </div>
                        </div>`
        }).component('mon-button', {
            props: ['item'],
            setup(props) {
                return {}
            },
            template: `<button type="button" :class="['layui-btn', item.theme, item.btnsize]">{{item.text}}</button>`
        }).component('mon-space', {
            props: ['item'],
            setup(props) {
                const styleList = computed(() => {
                    return {
                        height: props.item.height + 'px'
                    }
                })
                return { styleList }
            },
            template: `<div :style="styleList"></div>`
        }).component('mon-form-item', {
            props: ['item', 'extend'],
            setup(props) {
                const labelStyle = computed(() => {
                    return {
                        width: props.item.labelhide ? '0px' : (props.item.labelwidth + 'px')
                    }
                })
                const divStyle = computed(() => {
                    return {
                        marginLeft: props.item.labelhide ? '0px' : ((props.item.labelwidth - 0) + 30) + 'px'
                    }
                })
                // 动态组件名
                const componentName = computed(() => `mon-${props.item.tag}`)

                return { labelStyle, divStyle, componentName }
            },
            template: `<label class="layui-form-label" v-show="!item.labelhide" :style="labelStyle">{{item.label}}</label>
                        <div class="layui-input-block" :style="divStyle">
                            <component :item="item" :extend="extend" :is="componentName"></component>
                        </div>`
        }).component('mon-form-item-view', {
            props: ['item', 'extend'],
            setup(props) {
                // 动态组件名
                const componentName = computed(() => `mon-${props.item.tag}`)
                // 非表单组件
                const notFormTag = ['note', 'subtraction', 'button', 'carousel', 'space', 'grid', 'link', 'img', 'video', 'audio'];
                // 是否渲染表单组件
                const showFormComponent = computed(() => !notFormTag.includes(props.item.tag))

                return { componentName, showFormComponent }
            },
            template: `<mon-form-item :item="item" :extend="extend" v-if="showFormComponent"></mon-form-item>
                        <component :item="item" :is="componentName" v-else></component>`
        }).component('mon-grid', {
            props: ['item'],
            setup(props) {
                const col = 12 / props.item.column
                const classList = computed(() => {
                    return [`layui-col-sm${col}`]
                })
                return { classList }
            },
            template: `<div class="layui-row">
                        <div :class="classList" v-for="i in item.children">
                            <template v-for="v in i.children">
                                <mon-form-item-view :item="v"></mon-form-item-view>
                            </template>
                        </div>
                    </div>`
        }).component('mon-link', {
            props: ['item'],
            setup(props) {
                return {}
            },
            template: `<div class="mon-link-box"><a class="mon-link" :href="item.url" target="_blank" v-text="item.data_default"></a></div>`
        }).component('mon-img', {
            props: ['item'],
            setup(props) {
                return {}
            },
            template: `<div class="mon-img-box"><img :src="item.upload_value" :alt="item.upload_value" /></div>`
        }).component('mon-video', {
            props: ['item'],
            setup(props) {
                const videoStyle = computed(() => {
                    return {
                        height: `${props.item.height}px`
                    }
                })
                const videoType = computed(() => `video/${props.item.source_type}`)
                return { videoStyle, videoType }
            },
            template: `<div class="mon-video-box">
                            <video :controls="item.controls" :style="videoStyle">
                                <source :src="item.upload_value" :type="videoType" />
                                抱歉！你的浏览器不支持H5视频播放
                            </video>
                        </div>`
        }).component('mon-audio', {
            props: ['item'],
            setup(props) {
                const audioType = computed(() => `audio/${props.item.source_type}`)

                return { audioType }
            },
            template: `<div class="mon-audio-box">
                            <audio :controls="item.controls">
                                <source :src="item.upload_value" :type="audioType" />
                                抱歉！你的浏览器不支持H5音频播放
                            </audio>
                        </div>`
        }).component('mon-uploadInput', {
            props: ['item'],
            setup(props) {
                const uploadURL = ref(props.item.data_default || '')
                const uploadInput = ref(null)
                const uploadBtn = ref(null)
                const verify = computed(() => props.item.required ? 'required' : '')
                const uploadClass = computed(() => {
                    const defaultClass = ['layui-btn', 'layui-btn-primary', 'layui-bg-white'];
                    if (props.item.disabled) {
                        defaultClass.push('layui-btn-disabled')
                    }
                    return defaultClass
                })

                // 预览
                function preview() {
                    if (uploadURL.value) {
                        window.open(uploadURL.value, '_blank')
                    }
                }

                onMounted(() => {
                    mUpload.render({
                        elem: uploadBtn.value,
                        url: props.item.upload_url,
                        accept: props.item.data_accept || file,
                        size: props.item.data_size || 0,
                        done: function (ret, index, upload) {
                            if (ret.code != '1') {
                                layer.msg(ret.msg, { icon: 2 });
                                return;
                            }
                            let url = ret.data[0].url
                            uploadURL.value = url
                        },
                    })
                })

                return { uploadURL, uploadInput, uploadBtn, verify, uploadClass, preview }
            },
            template: `<div class="layui-input-group">
                            <input class="layui-input" type="text" :name="item.name" :placeholder="item.placeholder" v-model="uploadURL" :readonly="item.readonly" 
                                :disabled="item.disabled" :lay-verify="verify" lay-vertype="tips" ref="uploadInput">
                            <div class="layui-input-suffix">
                                <button type="button" :class="uploadClass" ref="uploadBtn" style="margin-right: 14px">上传</button>
                                <button type="button" class="layui-btn layui-btn-primary layui-bg-white" @click="preview">预览</button>
                            </div>
                        </div>`
        })

        // 挂载
        formContainer.mount(el)
    }

    exports(MOD_NAME, renderForm)
})
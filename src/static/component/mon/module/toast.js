layui.define(['common'], function (exports) {
    'use strict';

    const MODULE_NAME = 'toast'
    const common = layui.common

    const toastr = {
        // 元素根
        root: 'mon-message',
        // 动画时间
        animationTime: 300,
        // 提示位置，支持 top, top-left, top-right, bottom, bottom-left, bottom-right 6种
        position: 'top-right',
        // 皮肤, 支持 dark, normol 两种
        theme: 'normol',
        // 显示时间
        duration: 3200,
        // 图标
        icons: {
            info: `<svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" width="20" height="20">
                        <path d="M512 512m-448 0a448 448 0 1 0 896 0 448 448 0 1 0-896 0Z" fill="#FFFFFF"></path>
                        <path d="M872.329623 147.671158C776.348369 52.389768 649.773091 0.09998 515.399336 0.09998H511.90002c-138.472955 0.999805-267.647725 54.589338-363.82894 150.970514C51.889865 247.351689-0.599883 375.626635 0.09998 512.199961c1.599688 282.144894 231.254833 511.800039 511.90002 511.800039 282.244874 0 511.90002-229.655145 511.90002-511.90002 0-137.873072-53.889475-267.347784-151.570397-364.428822z m-360.329623 661.870728c-28.294474 0-51.190002-22.895528-51.190002-51.190002 0-28.294474 22.895528-51.190002 51.190002-51.190002 28.294474 0 51.190002 22.895528 51.190002 51.190002 0 28.194493-22.895528 51.190002-51.190002 51.190002z m40.991994-181.664518c0 22.595587-18.296426 40.991994-40.991994 40.991993-22.595587 0-40.991994-18.296426-40.991994-40.991993l-40.991994-331.435267c0-45.191174 36.692833-81.884007 81.884008-81.884007s81.884007 36.692833 81.884007 81.884007L552.991994 627.877368z" fill="#2868F0"></path>
                    </svg>`,
            success: `<svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" width="20" height="20">
                        <path d="M512 512m-448 0a448 448 0 1 0 896 0 448 448 0 1 0-896 0Z" fill="#07C160"></path>
                        <path d="M466.7 679.8c-8.5 0-16.6-3.4-22.6-9.4l-181-181.1c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0l158.4 158.5 249-249c12.5-12.5 32.8-12.5 45.3 0s12.5 32.8 0 45.3L489.3 670.4c-6 6-14.1 9.4-22.6 9.4z" fill="#FFFFFF"></path>
                    </svg>`,
            error: `<svg viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" width="20" height="20">
                        <path d="M512 512m-448 0a448 448 0 1 0 896 0 448 448 0 1 0-896 0Z" fill="#FFFFFF"></path>
                        <path d="M512 0C229.376 0 0 229.376 0 512s229.376 512 512 512 512-229.376 512-512S794.624 0 512 0z m218.624 672.256c15.872 15.872 15.872 41.984 0 57.856-8.192 8.192-18.432 11.776-29.184 11.776s-20.992-4.096-29.184-11.776L512 569.856l-160.256 160.256c-8.192 8.192-18.432 11.776-29.184 11.776s-20.992-4.096-29.184-11.776c-15.872-15.872-15.872-41.984 0-57.856L454.144 512 293.376 351.744c-15.872-15.872-15.872-41.984 0-57.856 15.872-15.872 41.984-15.872 57.856 0L512 454.144l160.256-160.256c15.872-15.872 41.984-15.872 57.856 0 15.872 15.872 15.872 41.984 0 57.856L569.856 512l160.768 160.256z" fill="#CF3736"></path>
                    </svg>`
        },

        // 成功消息
        success(msg, option = {}) {
            option.msg = msg
            option.icon = 'success'
            toastr.send(option)
        },

        // 失败消息
        error(msg, option = {}) {
            option.msg = msg
            option.icon = 'error'
            toastr.send(option)
        },

        // 通知消息
        info(msg, option = {}) {
            option.msg = msg
            option.icon = 'info'
            toastr.send(option)
        },

        // 发送
        send(option) {
            if (!option.msg || typeof option.msg != 'string') {
                console.error('mon-toastr hint: msg 参数必须')
                return;
            }
            // 初始化html、css
            if (!document.getElementById(toastr._buildName('style'))) {
                toastr._buildCSS()
            }
            if (!document.getElementById(toastr.root)) {
                toastr._buildHTML()
            }

            // 获取发送配置
            let opt = {
                icon: null,
                duration: toastr.duration,
                theme: toastr.theme,
                onClose: null
            }
            Object.assign(opt, option)

            // 获取根元素
            let rootElement = document.getElementById(toastr.root)
            // 生成内容，渲染message内容
            let content = []
            if (typeof opt.icon == 'string' && opt.icon != '') {
                // info, success, error 等内置图标则使用内置，否则直接渲染
                const iconContent = toastr.icons[opt.icon] || opt.icon
                content.push(`<div class="mon-message-icon">${iconContent}</div>`)
            }
            // content.push(`<div class="mon-message-text">${opt.msg}</div>`)
            content.push(`<div class="mon-message-text">${toastr._formatContent(opt)}</div>`)
            // 创建内容根元素
            const el = document.createElement('div')
            el.classList.add('mon-message-container')
            el.classList.add('in')
            const mainTheme = toastr._buildName('main-' + opt.theme)
            el.innerHTML = `<div class="mon-message-main ${mainTheme}">${content.join('')}</div></div>`
            // 插入元素
            rootElement.appendChild(el)

            // 绑定事件
            let hideEvent = setTimeout(() => {
                el.classList.replace('in', 'out')
                clearTimeout(hideEvent)
            }, (opt.duration - 0))
            let removeEvent = setTimeout(() => {
                el.remove()
                clearTimeout(removeEvent)
                // 判断是否存在回调方法
                if (typeof opt.onClose == 'function') {
                    opt.onClose()
                }

                // 判断如果所有message都已清空，则将根元素也移除
                if (!rootElement.querySelector('.mon-message-container')) {
                    rootElement.remove()
                }
            }, ((opt.duration - 0) + this.animationTime))
        },

        // 重新定义配置
        setting(options) {
            const oriElement = document.getElementById(toastr.root)
            for (let key in options) {
                if (['root', 'animationTime', 'position', 'theme', 'duration', 'icons'].includes(key)) {
                    toastr[key] = options[key]
                }
            }
            // 已存在元素，重新生成元素
            if (oriElement) {
                oriElement.remove()
                toastr._buildHTML()
            }
        },

        // 生成通知内容
        _formatContent(opt) {
            let content = []
            if (opt.title && typeof opt.title == 'string') {
                content.push(`<div class="mon-message-text-title">${opt.title}</div>`)
                content.push(`<div class="mon-message-text-msg has-title">${opt.msg}</div>`)
            } else {
                content.push(`<div class="mon-message-text-msg">${opt.msg}</div>`)
            }

            return content.join('')
        },

        // 生成带跟节点名字
        _buildName(name) {
            return toastr.root + '-' + name
        },

        // 插入HTML
        _buildHTML() {
            const className = toastr._buildName(toastr.position)
            const html = `<div id="${toastr.root}" class="${className}"></div>`
            document.querySelector('body').insertAdjacentHTML('beforeend', html)
        },

        // 插入style样式
        _buildCSS() {
            const css = `
            @-webkit-keyframes mon-message-out{0%{max-height:300px;opacity:1}to{padding:0;margin-bottom:0;max-height:0;opacity:0}}
            @keyframes mon-message-out{0%{max-height:150px;opacity:1}to{padding:0;margin-bottom:0;max-height:0;opacity:0}}
            @-webkit-keyframes mon-message-out-bottom{0%{opacity:1}50%{-webkit-transform:scale3d(.3,.3,.3);transform:scale3d(.3,.3,.3)}50%,to{padding:0;margin-bottom:0;opacity:0}}
            @keyframes mon-message-out-bottom{0%{opacity:1}50%{-webkit-transform:scale3d(.3,.3,.3);transform:scale3d(.3,.3,.3)}50%,to{padding:0;margin-bottom:0;opacity:0}}
            @-webkit-keyframes mon-message-in{0%{opacity:0;-webkit-transform:scale3d(.3,.3,.3);transform:scale3d(.3,.3,.3)}50%{opacity:1}}
            @keyframes mon-message-in{0%{opacity:0;-webkit-transform:scale3d(.3,.3,.3);transform:scale3d(.3,.3,.3)}50%{opacity:1}}
            #${toastr.root}{position:fixed;right:0;left:0;z-index:999999999;display:flex;overflow:visible;height:0;flex-direction:column;align-items:center;flex-shrink:0}
            #${toastr.root}.mon-message-top{top:10%}
            #${toastr.root}.mon-message-top-left{top:10%;left:24px;align-items:flex-start}
            #${toastr.root}.mon-message-top-right{top:56px;right:32px;align-items:flex-end}
            #${toastr.root}.mon-message-bottom{bottom:10%;justify-content:flex-end}
            #${toastr.root}.mon-message-bottom-left{bottom:10%;left:24px;justify-content:flex-end;align-items:flex-start}
            #${toastr.root}.mon-message-bottom-right{right:24px;bottom:10%;justify-content:flex-end;align-items:flex-end}
            #${toastr.root} .mon-message-container{margin-bottom:14px;box-sizing:border-box;max-width:90%;transform-origin:top center;animation-duration:${toastr.animationTime}ms;-webkit-animation-duration:${toastr.animationTime}ms;animation-iteration-count:1;-webkit-animation-iteration-count:1;animation-fill-mode:both;-webkit-animation-fill-mode:both;}
            #${toastr.root} .mon-message-container.in{-webkit-animation-name:mon-message-in;animation-name:mon-message-in}
            #${toastr.root} .mon-message-container.out{-webkit-animation-name:mon-message-out;animation-name:mon-message-out}
            #${toastr.root}.mon-message-bottom .mon-message-container.out,#${toastr.root}.mon-message-bottom-left .mon-message-container.out,#${toastr.root}.mon-message-bottom-right .mon-message-container.out{-webkit-animation-name:mon-message-out-bottom;animation-name:mon-message-out-bottom}
            #${toastr.root} .mon-message-container .mon-message-main{min-width:220px; display:flex;padding:14px 18px;border-radius:4px;background:#fff;box-shadow:0 4px 12px rgba(0,0,0,.3);color:#0e0e0e;font-size:14px;line-height:20px;align-items:center;overflow-wrap:anywhere;}
            #${toastr.root} .mon-message-container .mon-message-main.mon-message-main-normol{background:#fff;color:#0e0e0e}
            #${toastr.root} .mon-message-container .mon-message-main.mon-message-main-dark{background:rgba(0,0,0,.7);color:#fff}
            #${toastr.root} .mon-message-container .mon-message-main .mon-message-icon{display:flex;margin-right:6px;align-items:flex-start}
            #${toastr.root} .mon-message-container .mon-message-main .mon-message-text{max-width: 420px; max-height: 100px; overflow: hidden}
            #${toastr.root} .mon-message-container .mon-message-main .mon-message-text-title{font-weight: 600; white-space: nowrap;text-overflow: ellipsis; overflow: hidden}
            #${toastr.root} .mon-message-container .mon-message-main .mon-message-text-msg.has-title{ font-size: 12px}`

            common.addStyle(css, toastr.root + '-style');
        }
    }

    exports(MODULE_NAME, toastr)
})



layui.define(['jquery', 'common'], function (exports) {
    'use strict';

    const MODULE_NAME = 'contextMenu'
    const $ = layui.jquery
    const common = layui.common

    let operEl = null;
    let html = "";
    let that = null;

    let contextMenu = {
        init: function (option) {
            if (typeof (option) != "object" || !option.hasOwnProperty('id') || !option.hasOwnProperty('el') || !option.hasOwnProperty('items') || !option.hasOwnProperty('callback')) {
                throw "json format faild!";
            }
            that = this

            this.initStyle()
            this.showMenu(option);

            let rmMain = $('#' + option.id + ' .rm-main')
            let rmcontainer = $('#' + option.id + ' .rm-container')
            let areaHeight = $('body').height();
            let areaWidth = $('body').width();
            let menuHeight = rmMain.height();
            let menuWidth = rmMain.width();
            $(document).on('contextmenu', option.el, function (event) {
                // 先隐藏所有再显示，防止多个右键事件有冲突
                $('.rm-main').hide()

                operEl = $(this)
                let xPos = parseInt(event.pageX + 2);
                let yPos = event.pageY;
                if (areaWidth - xPos < menuWidth) {
                    xPos = (xPos - menuWidth - 20);
                    rmcontainer.css({
                        left: (xPos - menuWidth - 20) + "px",
                        // top: yPos + "px"
                    }).show();
                    $('#' + option.id + ' .rm-child').hide();
                }
                if (areaHeight - yPos < (menuHeight + 10)) {
                    yPos = (yPos - menuHeight - 10);
                }

                if (areaWidth - xPos < ((menuWidth * 2) + 10)) {
                    rmMain.attr('data-direction', 'left')
                } else {
                    rmMain.attr('data-direction', 'right')
                }

                rmMain.css({
                    left: xPos + "px",
                    top: yPos + "px"
                }).show();
                return false;
            })
            $('body').on('click', function () {
                rmcontainer.hide();
            });
            $('#' + option.id + ' .rm-container li').on('click', function (event) {
                event.stopPropagation();
                let content = $(this).data('content');
                rmcontainer.hide();
                option.callback({
                    type: content,
                    elem: operEl
                });
            });
            $('#' + option.id + ' .rm-container ul li,' + '#' + option.id + ' .rm-child li').mouseover(function (e) {
                if ($(this).find('i').hasClass('icon-align-right')) {
                    let width = $(this).find('i').next('.rm-child').width();
                    if (rmMain.attr('data-direction') == 'left') {
                        $(this).find('i').next('.rm-child').css('right', width).css('left', 'auto').show();
                    } else {
                        $(this).find('i').next('.rm-child').css('left', width).css('right', 'auto').show();
                    }
                }
            });
            $('#' + option.id + ' .rm-container ul li,' + '#' + option.id + ' .rm-child li').mouseout(function () {
                $('#' + option.id + ' .rm-child').hide();
            });
        },
        contextMenu: function (option, key) {
            key = key ? key : "main";
            html += '<div class="rm-container rm-' + key + '"><ul>';
            $.each(option.items, function (item, val) {
                let icon = val.icon ? '<i class="' + val.icon + '">&nbsp;' : '&nbsp;&nbsp;&nbsp;&nbsp;'
                let iconAfter = val.items ? '<i class="layui-icon layui-icon-right icon-align-right">&nbsp;' : '';
                html += '<li data-content=' + item + '>' + icon + '</i>' + val.name + iconAfter + '</i>';
                if (val.hasOwnProperty('items')) {
                    that.contextMenu(val, 'child');
                }
                html += '</li>';
            });
            html += "</ul></div>";
            return html;
        },
        showMenu: function (option) {
            let html = this.contextMenu(option);
            let id = option.id;
            $('body').append('<div id="' + id + '">' + html + '</div>');
            $('#' + id + ' .rm-container').hide();
        },
        initStyle: function(){
            const style = `
            .rm-main{position:absolute;}
            .rm-container{z-index:10000;display:block;padding:5px 0;border:1px solid #ccc;border-radius:3px;background:#fff;box-shadow:0 0 2px #ccc;color:#000;font-size:14px;}
            .rm-container ul{margin:0;padding:0;list-style:none;}
            .rm-container ul li{position:relative;padding:0 18px 0 15px;height:30px;line-height:30px;cursor:pointer;}
            .rm-container ul li:hover{background-color:#343a40;color:#fff;}
            .icon-align-right{position:absolute;top:1px;right:0;}
            .rm-child{position:absolute;top:0;display:none;width:100%;}`

            common.addStyle(style, 'mon-context-menu-style')
        }
    };
    exports(MODULE_NAME, contextMenu)
})
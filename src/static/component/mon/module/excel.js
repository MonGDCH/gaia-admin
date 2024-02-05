/**
 * html表格导出Excel
 * 
 * @see 该库为非标准Excel导出库，主要处理大量图片的导出(支持图片URL)导致的Excel文件内存溢出问题，如需使用标准Excel导出请使用一下的Excel库
 * @link https://gitee.com/gamflife/layui-excel
 * @demo
 * let tHeader = ['鲜花', '颜色', '照片', '测试']
 * let tbody = [
 *    { name: '玫瑰花', color: '红色', pic: 'http://bj.jingblocks.com/brick/imgs/S059/3464.jpg', test: 1 },
 *    { name: '菊花', color: '黄色', pic: 'http://bj.jingblocks.com/brick/imgs/S059/3084.jpg', test: 2 },
 * ]
 * let sdk = new Excel()
 * sdk.exportExcel(tHeader, tbody, 'Excel表格')
 */
layui.define([], function (exports) {
    'use strict';
    const MODULE_NAME = 'excel'

    class Excel {
        // 构造方法
        constructor() {
            this.download_uri = 'data:application/vnd.ms-excel;base64,'
            this.template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><meta charset="UTF-8"><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table border="1">{table}</table></body></html>'
        }

        // 数据转base64
        base64 = function (s) {
            return window.btoa(unescape(encodeURIComponent(s)));
        }

        // 替换数据
        format = (s, c) => {
            return s.replace(/{(\w+)}/g, (m, p) => {
                return c[p];
            })
        }

        // 导出
        exportExcel(theadData, tbodyData, filename) {
            let table = this.formatData(theadData, tbodyData)
            return this.download(table, filename)
        }

        // 格式化数据
        formatData(theadData, tbodyData) {
            // 字符串中包含http,则默认为图片地址
            let re = /http/
            // 表头的长度
            let th_len = theadData.length
            // 记录条数
            let tb_len = tbodyData.length
            // 设置图片大小
            let width = 60
            let height = 60
            // 添加表头信息
            let thead = '<thead><tr>'
            for (let i = 0; i < th_len; i++) {
                thead += `<th style="height: 36px;">${theadData[i]}</th>`
            }
            thead += '</tr></thead>'
            // 添加每一行数据
            let tbody = '<tbody>'
            for (let i = 0; i < tb_len; i++) {
                tbody += '<tr>'
                // 获取每一行数据
                let row = tbodyData[i]
                for (let key in row) {
                    if (re.test(row[key])) {
                        // 如果为图片，则需要加div包住图片
                        tbody += `<td style="width: ${width + 10}px; height: ${height + 10}px; text-align: center; vertical-align: middle;"><img src="${row[key]}" width="${width}" height="${height}"></td>`
                    } else {
                        tbody += `<td style="text-align: center">${row[key]}</td>`
                    }
                }
                tbody += '</tr>'
            }
            tbody += '</tbody>'
            return thead + tbody
        }

        // 下载
        download(table, name) {
            let ctx = { worksheet: name, table }
            // 创建下载
            let link = document.createElement('a');
            link.setAttribute('href', this.download_uri + this.base64(this.format(this.template, ctx)));
            link.setAttribute('download', name);
            link.click();
        }
    }

    exports(MODULE_NAME, Excel)
})
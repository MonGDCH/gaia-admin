# InputTag 组件

## 简介

InputTag 组件。按回车键(Enter)生成标签！按回退键(Backspace)删除标签！


## 示例


```html
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Layui标签输入框</title>
    <!-- 引入css -->
    <link rel="stylesheet" href="./inputTag.css">
</head>
<body>
<div>
    <div id="tag"></div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/layui/2.6.8/layui.js" integrity="sha512-lH7rGfsFWwehkeyJYllBq73IsiR7RH2+wuOVjr06q8NKwHp5xVnkdSvUm8RNt31QCROqtPrjAAd1VuNH0ISxqQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- 引入js -->
<script>
    layui.config({
        base: './'
    }).use(['inputTag', 'jquery'], function () {
        var $ = layui.jquery, inputTag = layui.inputTag;

        inputTag.render({
            elem: '#tag',
            data: ['hello', 'world', 'tom', 'jerry'],//初始值
            permanentData: ['hello'],//不允许删除的值
            removeKeyNum: 8,//删除按键编号 默认，BackSpace 键
            createKeyNum: 13,//创建按键编号 默认，Enter 键
            beforeCreate: function (data, value) {//添加前操作，必须返回字符串才有效
            	if (data.length >= 5) {
                    layer.msg('最多支持5个标签', { icon: 2 });
                    return false;
                }

                return value
        	},
            onChange: function (data, value, type) {
                console.log(data, value, type)
            }
        });

    })
</script>
</body>
</html>
```


layui.define([], function (exports) {
    'use strict'

    const MODULE_NAME = 'storage'

    const storage = {
        // 缓存过期时间，7天，单位s
        expire: 604800,
        // 前缀
        prefix: '',

        // 配置
        setting: function (options) {
            if (options.expire && typeof options.expire == 'number' && options.expire >= 0) {
                storage.expire = options.expire
            }
            storage.prefix = options.prefix || '';
        },

        // 获取
        get(key, defaultValue = null) {
            const item = localStorage.getItem(storage.getKey(key))
            if (item) {
                const data = JSON.parse(item)
                const { value, expire } = data;
                // 在有效期内直接返回
                if (expire === null || expire === 0 || expire >= Date.now()) {
                    return value;
                }
            }
            return defaultValue
        },

        // 设置
        set(key, value, expire = null) {
            if (!(expire !== null && typeof expire == 'number' && expire >= 0)) {
                expire = storage.expire
            }
            const data = JSON.stringify({
                value,
                expire: expire !== 0 ? new Date().getTime() + expire * 1000 : 0,
            })
            localStorage.setItem(storage.getKey(key), data)
        },

        // 删除
        remove(key) {
            localStorage.removeItem(storage.getKey(key))
        },

        // 清空
        clear() {
            localStorage.clear()
        },

        // 获取存储键名
        getKey(key) {
            return `${storage.prefix}${key}`.toUpperCase();
        }
    }


    exports(MODULE_NAME, storage)
})

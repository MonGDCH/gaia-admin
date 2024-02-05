layui.define(['storage', 'jwt_decode'], function (exports) {
    'use strict';

    const MODULE_NAME = 'token'

    // 缓存
    const storage = layui.storage
    const jwt_decode = layui.jwt_decode
    // 缓存中token键名
    const storage_token_name = 'x-mon-token'

    /**
     * token统一管理
     */
    class Token {
        // 构造方法
        constructor() {
            // token数据
            this.token = storage.get(storage_token_name, '')
            this.data = this.parseToken(this.token);
        }

        // 设置token
        setToken(token) {
            storage.set(storage_token_name, token)
            this.token = token
            this.data = this.parseToken(token)
        }

        // 获取token
        getToken() {
            return this.token
        }

        // 清除Token
        clearToken() {
            this.data = {}
            this.token = ''
            storage.remove(storage_token_name)
        }

        // 获取token数据
        getData() {
            return this.data
        }

        // 解析token
        parseToken(token) {
            let data = null
            try {
                data = token ? (jwt_decode(token) || {}) : {}
            } catch (e) {
                console.error(e)
            }

            return data
        }

        // token是否有效
        isValid() {
            if (!this.data) {
                return false
            }
            // 当前时间
            const now = Math.floor((new Date).getTime() / 1000)
            // 开始生效时间
            const nbf = this.data.nbf || 0
            if (nbf > now) {
                console.warn('jwt nbf not effect.')
                return false;
            }
            // 过期时间
            const exp = this.data.exp || 0
            if (exp < now) {
                console.warn('jwt exp not effect')
                return false;
            }

            return true;
        }

        // 是否需要刷新token
        isRefresh() {
            // 当前时间
            const now = Math.floor((new Date).getTime() / 1000)
            // 过期时间
            const exp = this.data.exp || 0
            // 创建时间
            const iat = this.data.iat || 0
            // 有效时间
            const expTime = Math.floor((exp - iat) / 2)
            // 刷新时间
            const refreshTime = iat + expTime
            return now > refreshTime
        }

    }

    exports(MODULE_NAME, new Token)
});
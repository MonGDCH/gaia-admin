layui.define(['layer', 'token', 'axios'], function (exports) {
    "use strict";

    // 模块名
    const MODULE_NAME = 'http'

    // 依赖库
    const Layer = layui.layer;
    const Token = layui.token
    const Axios = layui.axios

    // 系统配置
    const adminConfig = JSON.parse(sessionStorage.getItem('adminConfig')) || {};
    const jwtConfig = adminConfig.jwt || {}
    // 是否开启Token
    const TOKEN_ENABLE = jwtConfig.enable || false
    // 不需要token的API
    const NOT_NEED_TOKEN = jwtConfig.notNeedToken || []
    // 刷新Token的URL
    const REFRESH_API = jwtConfig.refreshURL || '/user/refresh'
    // 刷新Token请求方式
    const REFRESH_METHOD = jwtConfig.refreshMethod || 'GET'
    // 请求携带token名
    const AUTH_TOKEN_NAME = jwtConfig.tokenName || 'Mon-Auth-Token'
    // 登录页URL
    const LOGIN_PAGE = jwtConfig.loginURL || ''
    // 请求超时时间
    const REQUEST_TIMEOUT = 10000


    // 是否正在刷新token标志位
    let isRefreshing = false
    // 缓存的请求队列
    let requests = []
    // http服务
    let http = null;
    // 加载框索引
    let loadingIndex = null


    // 打开或者关闭加载框
    function loading(show = true) {
        // 打开
        if (show) {
            loadingIndex = Layer.load(2)
            return loadingIndex
        }

        // 关闭
        loadingIndex && Layer.close(loadingIndex)
        loadingIndex = null
        return null
    }

    // 获取HTTP实例
    function getHTTP() {
        if (!http) {
            http = new Http
        }

        return http;
    }

    // 刷新token
    async function refreshToken() {
        const header = {}
        header[AUTH_TOKEN_NAME] = Token.getToken()
        const { data } = await getHTTP().query({
            url: REFRESH_API,
            method: REFRESH_METHOD,
            headers: header
        })
        // 刷新token
        Token.setToken(data.token)
        return data
    }

    // 自定义Token错误异常
    class TokenError extends Error {
        // 构造方法
        constructor(messgae) {
            super(messgae)
            this.name = 'TokenError'
        }
    }

    /**
     * HTTP请求工具类
     */
    class Http {
        /**
         * 请求根路径
         */
        baseURL = '';

        /**
         * 请求头
         */
        headers = {
            'X-Requested-With': 'XMLHttpRequest',
            'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        }

        /**
         * 设置请求根路径
         *
         * @param {String} baseURL 
         * @returns {Http}
         */
        setBaseURL(baseURL) {
            this.baseURL = baseURL
            return this
        }

        /**
         * 设置请求头
         *
         * @param {String} key 
         * @param {String} value 
         * @returns {Http}
         */
        setHeaders(key, value) {
            this.headers[key] = value
            return this
        }

        /**
         * 创建实例
         */
        create(showLoad = true) {
            return Axios.create({
                baseURL: this.baseURL,
                headers: this.headers,
                timeout: REQUEST_TIMEOUT,
                responseType: 'json',
                transformRequest: (data) => {
                    // 打开loading框
                    if (showLoad) {
                        loading(true)
                    }
                    return data;
                },
                // after请求
                transformResponse: (data) => {
                    // 关闭loading框
                    if (showLoad) {
                        loading(false)
                    }

                    return data;
                }
            })
        }

        /**
        * 拦截请求
        *
        * @param {axios} instance 	axios实例
        * @param {Boolean} parseData 自动处理响应结果
        */
        interceptors(instance, parseData) {
            let _conf = {}
            // 添加请求拦截器
            instance.interceptors.request.use((config) => {
                // 优化请求配置信息
                _conf = config

                // 设置请求头
                if (config.headers && typeof (config.headers) == 'object') {
                    for (let key in config.headers) {
                        if (typeof (config.headers[key]) == 'string') {
                            _conf.headers[key] = config.headers[key]
                        }
                    }
                }

                // 判断post请求，绑定请求参数
                if (config.method == 'post' && config.data != undefined && JSON.stringify(config.data) != '{}') {
                    // 请求参数
                    const params = new URLSearchParams();
                    Object.keys(config.data).forEach(key => {
                        params.append(key, config.data[key]);
                    })
                    _conf.data = params
                }
                // GET请求，处理参数
                if (config.method == 'get' && config.data != undefined && JSON.stringify(config.data) != '{}') {
                    const queryData = this.buildUri(config.data)
                    _conf.url = _conf.url + (_conf.url.indexOf('?') == '-1' ? '?' + queryData : queryData)
                }

                // 不需要token直接返回
                if (!_conf.jwt || NOT_NEED_TOKEN.includes(_conf.url)) {
                    return _conf
                }

                // 判断token是否无效
                if (!Token.isValid()) {
                    console.error('Request Token invalid!')
                    throw new TokenError('Request Token invalid. Token Not Authenticated')
                }

                // 携带token
                _conf.headers[AUTH_TOKEN_NAME] = Token.getToken()

                // 判断是否刷新Token请求，非刷新Token请求，且Token超过一定使用期，刷新Token
                if (REFRESH_API != _conf.url && Token.isRefresh()) {
                    if (!isRefreshing) {
                        // 标志刷新Token
                        isRefreshing = true
                        // 发起刷新Token请求
                        refreshToken().then(tokenData => {
                            // 执行请求队列
                            requests.forEach(callback => callback(tokenData))
                            // 执行完成后，清空队列
                            requests = []
                        }).catch(err => {
                            console.error('Refresh token faild', err)
                        }).finally(() => {
                            isRefreshing = false
                        });
                    }

                    // 存储请求，刷新token后重新发起请求
                    return new Promise((resolve) => {
                        requests.push((tokenData) => {
                            // 因为config中的token是旧的，所以刷新token后要将新token传进来
                            _conf.headers[AUTH_TOKEN_NAME] = tokenData.token || ''
                            resolve(_conf)
                        })
                    })
                }

                return _conf
            }, (error) => {
                // 请求错误，目前没发现什么场景会进入到该流程
                console.err('Request use exception')
                return Promise.reject(error)
            })

            // 添加响应拦截器
            instance.interceptors.response.use((response) => {
                // 文件流请求，直接放回文件流
                if (_conf.responseType && _conf.responseType == 'blob') {
                    return response;
                }

                if (Boolean(parseData)) {
                    let { data } = response
                    if (_conf.responseType && _conf.responseType == 'json' && typeof data == 'string') {
                        data = JSON.parse(data)
                    }

                    // 返回结果集
                    return data
                }

                // 返回响应结果
                return response
            }, (error) => {
                // 关闭loading框
                loading(false)
                console.error(error)
                return Promise.reject(error)
            })
        }

        /**
        * 设置url参数
        *
        * @param  {Object} obj 请求参数
        * @return {String}
        */
        buildUri(obj) {
            let _rs = [];
            for (let p in obj) {
                if (obj[p] != null) {
                    _rs.push(p + '=' + obj[p])
                }
            }
            return _rs.join('&');
        }

        // 发起请求
        query(options) {
            options = Object.assign({}, options)
            // loading
            const loading = typeof options.loading == 'undefined' ? true : options.loading
            // 创建请求实例
            const instance = this.create(loading)
            // 是否解析成功结果集
            const parseData = typeof options.parseData == 'undefined' ? true : options.parseData
            // 设置拦截器
            this.interceptors(instance, parseData)
            // 是否启用jwt权限控制
            options.jwt = typeof options.jwt == 'undefined' ? TOKEN_ENABLE : options.jwt

            return instance(options)
        }

        // 快速的GET请求
        async get(url, data, options) {
            options = Object.assign({}, options, {
                url: url,
                method: 'GET',
                data: data
            })
            return await this.ajax(options)
        }

        // 快速的post请求
        async post(url, data, options) {
            options = Object.assign({}, options, {
                url: url,
                method: 'POST',
                data: data
            })
            return await this.ajax(options)
        }

        // 封装的发起请求操作
        async ajax(options) {
            try {
                const response = await this.query(options)
                return response
            } catch (e) {
                // 错误响应
                const { name, message, response } = e
                switch (name) {
                    case 'TokenError':
                        // Token无效，需要重新获取
                        Layer.alert(message, {
                            title: 'Token Error',
                            icon: 2,
                            closeBtn: 0,
                            yes: function (index, layero, that) {
                                Token.clearToken()
                                // 关闭弹层
                                Layer.close(index);
                                // 跳转登录页
                                if (LOGIN_PAGE) {
                                    window.location.href = LOGIN_PAGE
                                }
                            }
                        })
                        break;
                    case 'AxiosError':
                        // case 'SyntaxError':
                        // Axios错误
                        let title = 'Request Error'
                        let msg = 'Error detail not sent by server'
                        if (response) {
                            // 存在响应结果，判断status
                            switch (response.status) {
                                case 400:
                                    title = 'Bad Request'
                                    msg = 'Client Request faild'
                                    break;
                                case 401:
                                    title = 'Not Authenticated'
                                    msg = 'You are not authenticated. Please login'
                                    break;
                                case 403:
                                    title = 'Not Authorized'
                                    msg = 'Not allowed to perform this operation'
                                    break;
                                case 404:
                                    title = 'Not found'
                                    msg = 'The resource requested could not found'
                                    break;
                                case 500:
                                    title = 'Server Error'
                                    msg = 'Service error, contact your administrator'
                                    break;
                                default:
                                    title = 'Server Exception'
                                    msg = 'Service exception, contact your administrator'
                                    break;
                            }
                        }
                        Layer.alert(msg, {
                            title: title,
                            icon: 2,
                            closeBtn: 0
                        })
                        break;
                    default:
                        Layer.alert(e.message, {
                            title: 'Request Exception',
                            icon: 2,
                            closeBtn: 0
                        })
                        console.error(e)
                        break
                }

                // 继续上抛错误
                return Promise.reject(e)
            }
        }
    }

    exports(MODULE_NAME, getHTTP());
});
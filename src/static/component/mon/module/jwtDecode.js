(function (factory) {
    typeof define === 'function' && define.amd ? define(factory) : factory();
})((function () {
    'use strict';

    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    function InvalidCharacterError(message) {
        this.message = message;
    }

    InvalidCharacterError.prototype = new Error();
    InvalidCharacterError.prototype.name = "InvalidCharacterError";

    function polyfill(input) {
        let str = String(input).replace(/=+$/, "");
        if (str.length % 4 == 1) {
            throw new InvalidCharacterError("'atob' failed: The string to be decoded is not correctly encoded.");
        }
        for (
            // initialize result and counters
            let bc = 0, bs, buffer, idx = 0, output = "";
            // get next character
            (buffer = str.charAt(idx++));
            // character found in table? initialize bit storage and add its ascii value;
            ~buffer &&
                ((bs = bc % 4 ? bs * 64 + buffer : buffer),
                    // and if not first of each 4 characters,
                    // convert the first 8 bits to one ascii character
                    bc++ % 4) ?
                (output += String.fromCharCode(255 & (bs >> ((-2 * bc) & 6)))) :
                0
        ) {
            // try to find character in table (0-63, not found => -1)
            buffer = chars.indexOf(buffer);
        }
        return output;
    }

    const atob = (typeof window !== "undefined" && window.atob && window.atob.bind(window)) || polyfill;

    function b64DecodeUnicode(str) {
        return decodeURIComponent(
            atob(str).replace(/(.)/g, function (m, p) {
                let code = p.charCodeAt(0).toString(16).toUpperCase();
                if (code.length < 2) {
                    code = "0" + code;
                }
                return "%" + code;
            })
        );
    }

    function base64_url_decode(str) {
        let output = str.replace(/-/g, "+").replace(/_/g, "/");
        switch (output.length % 4) {
            case 0:
                break;
            case 2:
                output += "==";
                break;
            case 3:
                output += "=";
                break;
            default:
                throw new Error("base64 string is not of the correct length");
        }

        try {
            return b64DecodeUnicode(output);
        } catch (err) {
            return atob(output);
        }
    }

    function InvalidTokenError(message) {
        this.message = message;
    }

    InvalidTokenError.prototype = new Error();
    InvalidTokenError.prototype.name = "InvalidTokenError";

    // decode方法
    function jwtDecode(token, options) {
        if (typeof token !== "string") {
            throw new InvalidTokenError("Invalid token specified: must be a string");
        }

        options = options || {};
        let pos = options.header === true ? 0 : 1;

        let part = token.split(".")[pos];
        if (typeof part !== "string") {
            throw new InvalidTokenError("Invalid token specified: missing part #" + (pos + 1));
        }

        let decoded = ''
        try {
            decoded = base64_url_decode(part);
        } catch (e) {
            throw new InvalidTokenError("Invalid token specified: invalid base64 for part #" + (pos + 1) + ' (' + e.message + ')');
        }

        try {
            return JSON.parse(decoded);
        } catch (e) {
            throw new InvalidTokenError("Invalid token specified: invalid json for part #" + (pos + 1) + ' (' + e.message + ')');
        }
    }

    if (window) {
        if (typeof window.define == "function" && window.define.amd) {
            window.define("jwt_decode", function () {
                return jwtDecode;
            });
        } else if (window.layui && typeof layui.define === 'function') {
            layui.define([], function (exports) {
                exports('jwt_decode', jwtDecode)
            })
        } else if (window) {
            window.jwt_decode = jwtDecode;
        }
    }
}));

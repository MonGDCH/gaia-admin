/**
 * crontab表达式组件，基于 candy-boy/laycron 包调整重构
 * 
 * @see: https://gitee.com/candy-boy/laycron
 * @author: mon
 * @version: 1.0.0
 * @license: mit
 */
layui.define(['lay', 'element', 'form'], function (exports) { //假如该组件依赖 layui.form
	'use strict';

	const lay = layui.lay
	const element = layui.element
	const form = layui.form

	// 字符常量
	const MODULE_NAME = 'cron',
		ELEM = '.layui-cron',
		THIS = 'layui-this',
		SHOW = 'layui-show',
		HIDE = 'layui-hide',
		ELEM_STATIC = 'layui-cron-static',
		ELEM_FOOTER = 'layui-cron-footer',
		ELEM_CONFIRM = '.cron-btns-confirm',
		ELEM_HINT = 'layui-cron-hint'

	// 外部接口
	const cron = {
		// corn 实例标识
		index: layui.cron ? (layui.cron.index + 10000) : 0,

		// 设置全局项
		set: function (options) {
			const that = this;
			that.config = Object.assign({}, that.config, options);
			return that;
		},

		// 事件监听
		on: function (events, callback) {
			return layui.onevent.call(this, MODULE_NAME, events, callback);
		},

		// 主体CSS等待事件
		ready: function (fn) {
			// 加载模块资源
			const modFile = layui.cache.modules[MODULE_NAME];
			const modPath = modFile.substr(0, modFile.lastIndexOf('/'))
			const cssPath = modPath + '/' + MODULE_NAME + '.css?v=' + (typeof window.version == 'string' ? window.version : Math.random())
			layui.link(cssPath, fn, 'cron')
			return this;
		},

		// 核心入口
		render: function (options) {
			const ins = new Class(options);
			return thisIns.call(ins);
		}
	}

	// 操作当前实例
	const thisIns = function () {
		const that = this, options = that.config, id = options.id || options.index;
		return {
			// 提示框
			hint: function (content) {
				that.hint.call(that, content);
			},
			config: options
		}
	}

	// 构造器，创建实例
	const Class = function (options) {
		const that = this;
		that.index = ++cron.index;
		that.config = Object.assign({}, that.config, cron.config, options);
		cron.ready(function () {
			that.init();
		});
	};

	// 默认配置
	Class.prototype.config = {
		// 当前表达式值，每秒执行一次
		value: null,
		// 用于控制是否自动向元素填充初始值（需配合 value 参数使用）
		isInitValue: true,
		// 语言，只支持cn/en，即中文和英文
		lang: "cn",
		tabs: [
			{ key: 'seconds', range: '0-59' },
			{ key: 'minutes', range: '0-59' },
			{ key: 'hours', range: '0-23' },
			{ key: 'days', range: '1-31' },
			{ key: 'months', range: '1-12' },
			{ key: 'weeks', range: '0-6' },
			// { key: 'years' }
		],
		defaultCron: {
			seconds: "*",
			minutes: "*",
			hours: "*",
			days: "*",
			months: "*",
			weeks: "*",
			// years: ""
		},
		// 呼出控件的事件
		trigger: "click",
		// 右下角显示的按钮，会按照数组顺序排列
		btns: ['confirm'],
		// 控件定位方式定位, 默认absolute，支持：fixed/absolute/static
		position: null,
		// 控件层叠顺序
		zIndex: null,
		// 是否直接显示，如果设置 true，则默认直接显示控件
		show: false,
		// 是否显示底部栏
		showBottom: true,
		// 控件选择完毕后的回调，点击运行/确定也均会触发
		done: null,
	};

	// 多语言
	Class.prototype.lang = function () {
		const that = this, options = that.config, text = {
			cn: {
				tabs: [
					{ title: "秒" },
					{ title: "分" },
					{ title: "时" },
					{ title: "日" },
					{ title: "月" },
					{ title: "周", rateBegin: "第", rateMid: "周的星期", rateEnd: "" },
					// { title: "年" }
				],
				every: "每",
				period: "周期",
				periodFrom: "从",
				rate: "按照",
				rateBegin: "从",
				rateMid: "开始，每",
				rateEnd: "执行一次",
				weekday: "工作日",
				weekdayPrefix: "每月",
				weekdaySuffix: "号最近的那个工作日",
				lastday: "本月最后一日",
				lastweek: "本月最后一个星期",
				custom: "指定",
				tools: { confirm: '确定' },
				formatError: ['Cron格式不合法', '<br>已为你重置']
			}
		};
		return text[options.lang] || text['cn'];
	};

	// 初始准备
	Class.prototype.init = function () {
		const that = this, options = that.config, isStatic = options.position === 'static';

		options.elem = lay(options.elem);
		options.eventElem = lay(options.eventElem);

		if (!options.elem[0]) return;

		// 如果不是input|textarea元素，则默认采用click事件
		if (!that.isInput(options.elem[0])) {
			if (options.trigger === 'focus') {
				options.trigger = 'click';
			}
		}

		// 设置渲染所绑定元素的唯一KEY
		if (!options.elem.attr('lay-key')) {
			options.elem.attr('lay-key', that.index);
			options.eventElem.attr('lay-key', that.index);
		}

		// 当前实例主面板ID
		that.elemID = 'layui-icon' + options.elem.attr('lay-key');

		//默认赋值
		if (options.value && options.isInitValue) {
			that.setValue(options.value);
		}
		if (!options.value) {
			options.value = options.elem[0].value || '';
		}
		let cronArr = options.value.split(' ');
		if (cronArr.length >= 6) {
			options.cron = {
				seconds: cronArr[0],
				minutes: cronArr[1],
				hours: cronArr[2],
				days: cronArr[3],
				months: cronArr[4],
				weeks: cronArr[5],
				// years: "",
			};
		} else {
			options.cron = lay.extend({}, options.defaultCron);
		}

		if (options.show || isStatic) that.render();
		isStatic || that.events();
	};


	// 控件主体渲染
	Class.prototype.render = function () {
		const that = this, options = that.config, lang = that.lang(), isStatic = options.position === 'static', tabFilter = 'cron-tab' + options.elem.attr('lay-key')
		//主面板
		const elem = that.elem = lay.elem('div', {
			id: that.elemID,
			'class': ['layui-cron', isStatic ? (' ' + ELEM_STATIC) : ''].join('')
		})

		// tab 内容区域
		const elemTab = that.elemTab = lay.elem('div', {
			'class': 'layui-tab layui-tab-card',
			'lay-filter': tabFilter
		})
		const tabHead = lay.elem('ul', {
			'class': 'layui-tab-title'
		})
		const tabContent = lay.elem('div', {
			'class': 'layui-tab-content'
		})

		// 底部区域
		const divFooter = that.footer = lay.elem('div', {
			'class': ELEM_FOOTER
		});

		if (options.zIndex) {
			elem.style.zIndex = options.zIndex;
		}

		// 生成tab 内容区域
		elemTab.appendChild(tabHead);
		elemTab.appendChild(tabContent);
		lay.each(lang.tabs, function (i, item) {
			// 表头
			let li = lay.elem('li', {
				'class': i === 0 ? THIS : "",
				'lay-id': i
			});
			li.innerHTML = item.title;
			tabHead.appendChild(li);

			// 表体
			tabContent.appendChild(that.getTabContentChildElem(i));
		});

		// 主区域
		const elemMain = that.elemMain = lay.elem('div', {
			'class': 'layui-cron-main'
		});
		elemMain.appendChild(elemTab);

		// 生成底部栏
		lay(divFooter).html(function () {
			let html = [], btns = [];
			lay.each(options.btns, function (i, item) {
				let title = lang.tools[item] || 'btn';
				btns.push('<span lay-type="' + item + '" class="cron-btns-' + item + '">' + title + '</span>');
			});
			html.push('<div class="cron-footer-btns">' + btns.join('') + '</div>');
			return html.join('');
		}());

		// 插入到主区域
		elem.appendChild(elemMain);

		options.showBottom && elem.appendChild(divFooter);

		// 移除上一个控件
		that.remove(Class.thisElemCron);

		// 如果是静态定位，则插入到指定的容器中，否则，插入到body
		isStatic ? options.elem.append(elem) : (
			document.body.appendChild(elem),
			that.position()
		);

		that.checkCron();
		// 主面板事件
		that.elemEvent();
		Class.thisElemCron = that.elemID;
		form.render();
	}

	// 渲染 tab 子控件
	Class.prototype.getTabContentChildElem = function (index) {
		const that = this, options = that.config, tabItem = options.tabs[index], tabItemKey = tabItem.key, lang = that.lang(), tabItemLang = lang.tabs[index],
			cron = options.cron, formFilter = 'cronForm' + tabItemKey + options.elem.attr('lay-key')
		const data = function () {
			if (cron[tabItemKey].indexOf('-') != -1) {
				// 周期数据
				let arr = cron[tabItemKey].split('-');
				return {
					type: 'range',
					start: arr[0],
					end: arr[1]
				};
			}
			if (cron[tabItemKey].indexOf('/') != -1) {
				// 频率数据
				let arr = cron[tabItemKey].split('/');
				return {
					type: 'rate',
					begin: arr[0],
					rate: arr[1]
				};
			}
			if (cron[tabItemKey].indexOf(',') != -1 || /^\+?[0-9][0-9]*$/.test(cron[tabItemKey])) {
				// 按照指定执行
				let arr = cron[tabItemKey].split(',').map(Number);
				return {
					type: 'custom',
					values: arr
				};
			}
			if (cron[tabItemKey].indexOf('W') != -1) {
				// 最近的工作日
				let value = cron[tabItemKey].replace('W', '');
				return {
					type: 'weekday',
					value: value
				};
			}
			if (index === 3 && cron[tabItemKey] === 'L') {
				// 本月最后一日
				return {
					type: 'lastday',
					value: 'L'
				};
			}
			if (index === 5 && cron[tabItemKey].indexOf('L') != -1) {
				// 本月最后一个周 value
				let value = cron[tabItemKey].replace('L', '');
				return {
					type: 'lastweek',
					value: value
				};
			}
			if (cron[tabItemKey] === '*') {
				// 每次
				return {
					type: 'every',
					value: '*'
				};
			}
		}()
		const rangeData = function () {
			if (tabItem.range) {
				let arr = tabItem.range.split('-');
				return {
					min: parseInt(arr[0]),
					max: parseInt(arr[1])
				};
			}
		}();
		const elem = lay.elem('div', {
			'class': 'layui-tab-item layui-form ' + (index === 0 ? SHOW : ""),
			'lay-filter': formFilter
		});

		// 每次
		elem.appendChild(function () {
			let everyRadio = lay.elem('input', {
				'name': tabItemKey + '[type]',
				'type': 'radio',
				'value': 'every',
				'title': lang.every + tabItemLang.title
			});
			if (data.type === 'every') {
				lay(everyRadio).attr('checked', true);
			}
			let everyDiv = lay.elem('div', {
				'class': 'cron-row'
			});
			everyDiv.appendChild(everyRadio);
			return everyDiv;
		}());

		// 周期
		const rangeChild = [function () {
			let rangeRadio = lay.elem('input', {
				'name': tabItemKey + '[type]',
				'type': 'radio',
				'value': 'range',
				'title': lang.period
			});
			if (data.type === 'range') {
				lay(rangeRadio).attr('checked', true);
			}
			return rangeRadio;
		}(), function () {
			let elem = lay.elem('div', {
				'class': 'cron-input-mid'
			});
			elem.innerHTML = lang.periodFrom;
			return elem;
		}(), function () {
			let elem = lay.elem('input', {
				'class': 'cron-input',
				'type': 'number',
				'name': 'rangeStart',
				'value': data.start || ''
			});
			return elem;
		}(), function () {
			let elem = lay.elem('div', {
				'class': 'cron-input-mid'
			});
			elem.innerHTML = '-';
			return elem;
		}(), function () {
			let elem = lay.elem('input', {
				'class': 'cron-input',
				'type': 'number',
				'name': 'rangeEnd',
				'value': data.end || ''
			});
			return elem;
		}(), function () {
			let elem = lay.elem('div', {
				'class': 'cron-input-mid'
			});
			elem.innerHTML = tabItemLang.title;
			return elem;
		}()]

		const rangeDiv = lay.elem('div', {
			'class': 'cron-row'
		});
		lay.each(rangeChild, function (i, item) {
			rangeDiv.appendChild(item);
		});
		if (tabItem.range) {
			const rangeTip = lay.elem('div', {
				'class': 'cron-tips'
			});
			rangeTip.innerHTML = ['(', tabItem.range, ')'].join('');
			rangeDiv.appendChild(rangeTip);
		}
		elem.appendChild(rangeDiv);

		// 频率,年没有
		if (index < 6) {
			const rateChild = [function () {
				let rateRadio = lay.elem('input', {
					'name': tabItemKey + '[type]',
					'type': 'radio',
					'value': 'rate',
					'title': lang.rate
				});
				if (data.type === 'rate') {
					lay(rateRadio).attr('checked', true);
				}
				return rateRadio;
			}(), function () {
				let elem = lay.elem('div', {
					'class': 'cron-input-mid'
				});
				elem.innerHTML = tabItemLang.rateBegin || lang.rateBegin;
				return elem;
			}(), function () {
				let elem = lay.elem('input', {
					'class': 'cron-input',
					'type': 'number',
					'name': 'begin',
					'value': data.begin || ''
				});
				return elem;
			}(), function () {
				let elem = lay.elem('div', {
					'class': 'cron-input-mid'
				});
				elem.innerHTML = tabItemLang.rateMid || (tabItemLang.title + lang.rateMid);
				return elem;
			}(), function () {
				let elem = lay.elem('input', {
					'class': 'cron-input',
					'type': 'number',
					'name': 'rate',
					'value': data.rate || ''
				});
				return elem;
			}(), function () {
				let elem = lay.elem('div', {
					'class': 'cron-input-mid'
				});
				elem.innerHTML = undefined != tabItemLang.rateEnd ? tabItemLang.rateEnd : (tabItemLang.title + lang.rateEnd);
				if (undefined != tabItemLang.rateEnd && tabItemLang.rateEnd === '') {
					lay(elem).addClass(HIDE);
				}
				return elem;
			}()]

			const rateDiv = lay.elem('div', {
				'class': 'cron-row'
			});
			lay.each(rateChild, function (i, item) {
				rateDiv.appendChild(item);
			});
			if (tabItem.range) {
				const rateTip = lay.elem('div', {
					'class': 'cron-tips'
				});
				if (index === 5) {
					// 周
					rateTip.innerHTML = '(0-3/0-6)';
				} else {
					rateTip.innerHTML = ['(', rangeData.min, '/', (rangeData.max + (index <= 2 ? 1 : 0)), ')'].join('');
				}
				rateDiv.appendChild(rateTip);
			}
			elem.appendChild(rateDiv);
		}

		// 特殊：日（最近的工作日、最后一日），周（最后一周）
		if (index === 3) {
			// 日
			// 最近的工作日
			const weekChild = [function () {
				let weekRadio = lay.elem('input', {
					'name': tabItemKey + '[type]',
					'type': 'radio',
					'value': 'weekday',
					'title': lang.weekday
				});
				if (data.type === 'weekday') {
					lay(weekRadio).attr('checked', true);
				}
				return weekRadio;
			}(), function () {
				let elem = lay.elem('div', {
					'class': 'cron-input-mid'
				});
				elem.innerHTML = lang.weekdayPrefix;
				return elem;
			}(), function () {
				let elem = lay.elem('input', {
					'class': 'cron-input',
					'type': 'number',
					'name': 'weekday',
					'value': data.value || ''
				});
				return elem;
			}(), function () {
				let elem = lay.elem('div', {
					'class': 'cron-input-mid'
				});
				elem.innerHTML = lang.weekdaySuffix;
				return elem;
			}(), function () {
				let elem = lay.elem('div', {
					'class': 'cron-tips'
				});
				elem.innerHTML = ['(', tabItem.range, ')'].join('');
				return elem;
			}()]

			const weekDiv = lay.elem('div', {
				'class': 'cron-row'
			});
			lay.each(weekChild, function (i, item) {
				weekDiv.appendChild(item);
			});
			elem.appendChild(weekDiv);

			// 本月最后一日
			elem.appendChild(function () {
				let lastRadio = lay.elem('input', {
					'name': tabItemKey + '[type]',
					'type': 'radio',
					'value': 'lastday',
					'title': lang.lastday
				});
				if (data.type === 'lastday') {
					lay(lastRadio).attr('checked', true);
				}
				let lastDiv = lay.elem('div', {
					'class': 'cron-row'
				});
				lastDiv.appendChild(lastRadio);
				return lastDiv;
			}());

		}

		if (index === 5) {
			// 本月最后一个周几
			const lastWeekChild = [function () {
				let lastWeekRadio = lay.elem('input', {
					'name': tabItemKey + '[type]',
					'type': 'radio',
					'value': 'lastweek',
					'title': lang.lastweek
				});
				if (data.type === 'lastweek') {
					lay(lastWeekRadio).attr('checked', true);
				}
				return lastWeekRadio;
			}(), function () {
				let elem = lay.elem('input', {
					'class': 'cron-input',
					'type': 'number',
					'name': 'lastweek',
					'value': data.value || ''
				});
				return elem;
			}(), function () {
				let elem = lay.elem('div', {
					'class': 'cron-tips'
				});
				elem.innerHTML = ['(', tabItem.range, ')'].join('');
				return elem;
			}()]

			const lastWeekDiv = lay.elem('div', {
				'class': 'cron-row'
			});
			lay.each(lastWeekChild, function (i, item) {
				lastWeekDiv.appendChild(item);
			});
			elem.appendChild(lastWeekDiv);
		}

		// 指定
		if (index <= 5) {
			elem.appendChild(function () {
				let customRadio = lay.elem('input', {
					'name': tabItemKey + '[type]',
					'type': 'radio',
					'value': 'custom',
					'title': lang.custom
				});
				if (data.type === 'custom') {
					lay(customRadio).attr('checked', true);
				}
				let customDiv = lay.elem('div', {
					'class': 'cron-row'
				});
				customDiv.appendChild(customRadio);
				return customDiv;
			}());

			// 指定数值，时分秒显示两位数，自动补零
			elem.appendChild(function () {
				let customGrid = lay.elem('div', {
					'class': 'cron-grid'
				});
				let i = rangeData.min;
				while (i <= rangeData.max) {
					// 时分秒显示两位数，自动补零
					let gridItemValue = index <= 2 ? lay.digit(i, 2) : i;
					let gridItem = lay.elem('input', {
						'type': 'checkbox',
						'title': gridItemValue,
						'lay-skin': 'primary',
						'name': tabItemKey + '[custom]',
						'value': i
					});
					if (data.values && data.values.includes(i)) {
						lay(gridItem).attr('checked', true);
					}
					customGrid.appendChild(gridItem);
					i++;
				}
				return customGrid;
			}());
		}

		return elem;
	}

	//是否输入框
	Class.prototype.isInput = function (elem) {
		return /input|textarea/.test(elem.tagName.toLocaleLowerCase());
	};

	// 绑定的元素事件处理
	Class.prototype.events = function () {
		const that = this, options = that.config

		//绑定呼出控件事件
		const showEvent = function (elem, bind) {
			elem.on(options.trigger, function () {
				bind && (that.bindElem = this);
				that.render();
			});
		};

		if (!options.elem[0] || options.elem[0].eventHandler) return;

		showEvent(options.elem, 'bind');
		showEvent(options.eventElem);

		//绑定关闭控件事件
		lay(document).on('click', function (e) {
			if (e.target === options.elem[0]
				|| e.target === options.eventElem[0]
				|| e.target === lay(options.closeStop)[0]) {
				return;
			}
			that.remove();
		}).on('keydown', function (e) {
			if (e.keyCode === 13) {
				if (lay('#' + that.elemID)[0] && that.elemID === Class.thisElemDate) {
					e.preventDefault();
					lay(that.footer).find(ELEM_CONFIRM)[0].click();
				}
			}
		});

		//自适应定位
		lay(window).on('resize', function () {
			if (!that.elem || !lay(ELEM)[0]) {
				return false;
			}
			that.position();
		});

		options.elem[0].eventHandler = true;
	};

	// 主面板事件
	Class.prototype.elemEvent = function () {
		const that = this, options = that.config, tabFilter = 'cron-tab' + options.elem.attr('lay-key');

		// 阻止主面板点击冒泡，避免因触发文档事件而关闭主面
		lay(that.elem).on('click', function (e) {
			lay.stope(e);
		});

		// tab选项卡切换
		const lis = lay(that.elemTab).find('li');
		lis.on('click', function () {
			let layid = lay(this).attr('lay-id');
			if (undefined === layid) {
				return;
			}
			element.tabChange(tabFilter, layid);
		});

		// cron选项点击
		form.on('radio', function (data) {
			let $parent = data.othis.parent();
			let formFilter = $parent.parent().attr('lay-filter');
			let formData = form.val(formFilter);
			let radioType = data.value;
			if ('range' === radioType) {
				// 范围
				form.val(formFilter, {
					rangeStart: formData.rangeStart || 0,
					rangeEnd: formData.rangeEnd || 2
				});
			}
			if ('rate' === radioType) {
				// 频率
				form.val(formFilter, {
					begin: formData.begin || 0,
					rate: formData.rate || 2
				});
			}
			if ('custom' === radioType) {
				// custom
				let $grid = $parent.next();
				if ($grid.find(':checkbox:checked').length <= 0) {
					$grid.children(':checkbox:first').next().click()
				}
			}
			if ('weekday' === radioType) {
				// weekday
				form.val(formFilter, {
					weekday: formData.weekday || 1
				});
			}
			if ('lastweek' === radioType) {
				// lastweek
				form.val(formFilter, {
					lastweek: formData.lastweek || 1
				});
			}

		});

		//点击底部按钮
		lay(that.footer).find('span').on('click', function () {
			let type = lay(this).attr('lay-type');
			that.tool(this, type);
		});
	};

	// 底部按钮点击事件
	Class.prototype.tool = function (btn, type) {
		const that = this, options = that.config, lang = that.lang(), isStatic = options.position === 'static'
		const active = {
			// 确定
			confirm: function () {
				let value = that.parse();
				that.done([value]);
				that.setValue(value).remove()
			}
		};
		active[type] && active[type]();
	};

	// 执行 done/change 回调
	Class.prototype.done = function (param, type) {
		const that = this, options = that.config;

		param = param || [that.parse()];
		typeof options[type || 'done'] === 'function' && options[type || 'done'].apply(options, param);

		return that;
	};

	// 解析cron表达式
	Class.prototype.parse = function () {
		const that = this, options = that.config, valueArr = [];

		lay.each(options.tabs, function (index, item) {
			let key = item.key;
			let formFilter = 'cronForm' + key + options.elem.attr('lay-key');
			let formData = form.val(formFilter);
			let radioType = (key + '[type]');
			let current = "";
			if (formData[radioType] === 'every') {
				// 每次
				current = "*";
			}
			if (formData[radioType] === 'range') {
				// 范围
				current = formData.rangeStart + "-" + formData.rangeEnd;
			}
			if (formData[radioType] === 'rate') {
				// 频率
				current = formData.begin + "/" + formData.rate;
			}
			if (formData[radioType] === 'custom') {
				// 指定
				let checkboxName = (item.key + '[custom]');
				let customArr = [];
				document.querySelectorAll('input[name="' + checkboxName + '"]:checked').forEach(el => {
					customArr.push(el.value);
				})
				current = customArr.join(',');
			}
			if (formData[radioType] === 'weekday') {
				// 每月 formData.weekday 号最近的那个工作日
				current = formData.weekday + "W";
			}
			if (formData[radioType] === 'lastday') {
				// 本月最后一日
				current = "L";
			}
			if (formData[radioType] === 'lastweek') {
				// 本月最后星期 
				current = formData.lastweek + "L";
			}

			if (current !== "") {
				valueArr.push(current);
				options.cron[key] = current;
			}
		});
		return valueArr.join(' ');
	};

	// 控件移除
	Class.prototype.remove = function (prev) {
		const that = this, options = that.config, elem = lay('#' + (prev || that.elemID));
		if (!elem[0]) return that;

		if (!elem.hasClass(ELEM_STATIC)) {
			that.checkCron(function () {
				elem.remove();
			});
		}
		return that;
	};

	// 定位算法
	Class.prototype.position = function () {
		const that = this, options = that.config;
		lay.position(that.bindElem || options.elem[0], that.elem, {
			position: options.position
		});
		return that;
	};

	// 提示
	Class.prototype.hint = function (content) {
		const that = this, options = that.config, div = lay.elem('div', {
			'class': ELEM_HINT
		});

		if (!that.elem) return;

		div.innerHTML = content || '';
		lay(that.elem).find('.' + ELEM_HINT).remove();
		that.elem.appendChild(div);

		clearTimeout(that.hinTimer);
		that.hinTimer = setTimeout(function () {
			lay(that.elem).find('.' + ELEM_HINT).remove();
		}, 3000);
	};

	// 赋值
	Class.prototype.setValue = function (value = '') {
		const that = this, options = that.config, elem = that.bindElem || options.elem[0], valType = that.isInput(elem) ? 'val' : 'html'

		options.position === 'static' || lay(elem)[valType](value || '');
		return this;
	};

	// cron校验
	Class.prototype.checkCron = function (fn) {
		const that = this, options = that.config, lang = that.lang(), elem = that.bindElem || options.elem[0]
		const checkValid = function (value = "") {

		};
		let value = that.isInput(elem) ? elem.value : (options.position === 'static' ? '' : elem.innerHTML)


		// cron 值，多个空格替换为一个空格，去掉首尾空格
		value = value || options.value;
		if (typeof value === 'string') {
			value = value.replace(/\s+/g, ' ').replace(/^\s|\s$/g, '');
		}

		if (fn === 'init') return checkValid(value), that;
		value = that.parse();
		if (value) {
			that.setValue(value);
		}
		fn && fn();
		return that;
	};

	// //核心入口
	// cron.render = function (options) {
	// 	const ins = new Class(options);
	// 	return thisIns.call(ins);
	// };

	exports(MODULE_NAME, cron);
});
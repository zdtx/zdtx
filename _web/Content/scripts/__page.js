
// 为页面提供基于 Ext.NET 的应用对象
// 名字为 window.ISEx

(function (win, undefined) {

    var obj = {

        // check the browser type
        getBrowserInfo: function () {
            var agt = navigator.userAgent.toLowerCase();
            if (agt.indexOf("opera") != -1) return 'Opera';
            if (agt.indexOf("staroffice") != -1) return 'Star Office';
            if (agt.indexOf("webtv") != -1) return 'WebTV';
            if (agt.indexOf("beonex") != -1) return 'Beonex';
            if (agt.indexOf("chimera") != -1) return 'Chimera';
            if (agt.indexOf("netpositive") != -1) return 'NetPositive';
            if (agt.indexOf("phoenix") != -1) return 'Phoenix';
            if (agt.indexOf("firefox") != -1) return 'Firefox';
            if (agt.indexOf("safari") != -1) return 'Safari';
            if (agt.indexOf("skipstone") != -1) return 'SkipStone';
            if (agt.indexOf("msie") != -1) return 'Internet Explorer';
            if (agt.indexOf("netscape") != -1) return 'Netscape';
            if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla';
            if (agt.indexOf('\/') != -1) {
                if (agt.substr(0, agt.indexOf('\/')) != 'mozilla') {
                    return navigator.userAgent.substr(0, agt.indexOf('\/'));
                } else
                    return 'Netscape';
            } else if (agt.indexOf(' ') != -1)
                return navigator.userAgent.substr(0, agt.indexOf(' '));
            else
                return navigator.userAgent;
        },

        disableBS: function (e) {
            var key;
            if (e) {
                key = e.which ? e.which : e.keyCode;
                if (key == null || (key != 8 && key != 13)) { // return when the key is not backspace key.
                    return false;
                }
            } else {
                return false;
            }
            if (e.srcElement) { // in IE
                tag = e.srcElement.tagName.toUpperCase();
                type = e.srcElement.type;
                readOnly = e.srcElement.readOnly;
                if (type == null) { // Type is null means the mouse focus on a non-form field. disable backspace button
                    return true;
                } else {
                    type = e.srcElement.type.toUpperCase();
                }
            } else { // in FF
                tag = e.target.nodeName.toUpperCase();
                type = (e.target.type) ? e.target.type.toUpperCase() : "";
            }

            // we don't want to cancel the keypress (ever) if we are in an input/text area
            if (tag == 'INPUT' || type == 'TEXT' || type == 'TEXTAREA') {
                if (readOnly == true) // if the field has been dsabled, disbale the back space button
                    return true;
                if (((tag == 'INPUT' && type == 'RADIO') || (tag == 'INPUT' && type == 'CHECKBOX'))
                && (key == 8 || key == 13)) {
                    return true; // the mouse is on the radio button/checkbox, disbale the backspace button
                }
                return false;
            }

            // if we are not in one of the above things, then we want to cancel (true) if backspace
            return (key == 8 || key == 13);
        },

        ns: function () {
            var root = win, parts, part, i, j, ln, subLn;
            for (i = 0, ln = arguments.length; i < ln; i++) {
                parts = [];
                parts = parts.concat(arguments[i].split('.'));
                for (j = 0, subLn = parts.length; j < subLn; j++) {
                    part = parts[j];
                    if (typeof part != 'string') {
                        root = part;
                    } else {
                        if (!root[part]) {
                            root[part] = {};
                        }
                        root = root[part];
                    }
                }
            }
            return root;
        },

        apply: function (object, config) {
            if (object && config && typeof config === 'object') {
                var i;
                for (i in config) {
                    object[i] = config[i];
                }
            }
            return object;
        },

        resolve: function (ns, data) {
            var x = this;
            var xx = x.ns(ns);
            x.apply(xx, data);
            return xx;
        },

        extend: function (config) { return ISEx.apply(ISEx, config); },

        openMaxWin: function (url) {
            var x = this;
            var win = x.openWin(url, screen.availWidth, screen.availHeight);
            win.moveTo(0, 0);
        },

        openWin: function (url, width, height, target) {
            var w = width || 450;
            var h = height || 400;
            var t = target || "_blank";
            //var feature = "height=" + h + ",width=" + w; // + ",location=1,resizable=1,scrollbars=1";
            return win.open(url, t); //, feature);
        },

        sleep: function (interval, afterFn) {
            setTimeout(afterFn, interval);
        },

        // grid 的“全选”操作

        toggleCBs: function (masterCB, prefix) {
            var all = masterCB.children;
            var b = (masterCB.type === "checkbox") ? masterCB : masterCB.children.item[0];
            var state = b.checked;
            var es = b.form.elements;
            for (i = 0; i < es.length; i++) {
                if (es[i].type === "checkbox" && es[i].id != b.id && es[i].id.indexOf(prefix) !== -1) {
                    if (es[i].checked !== state) es[i].click();
                }
            }
            return b.checked;
        },

        // grid 的点击操作
        toggleCB: function (cb) {
            if (cb.parentElement) {
                var x = cb.parentElement.parentElement
                if (x) x.className = cb.checked ? "gridRow-selected" : "gridRow";
            }
        },

        // 以 excel 另存页面元素
        saveEl: function (elementId, fileName) {
            var e = document.getElementById(elementId);
            var h = e.outerHTML;
            var w = window.open();
            var d = new Date();
            w.document.write(h);
            w.document.close();

            var c = w.document.queryCommandSupported('saveas');
            try {
                if (c) w.document.execCommand('saveas', true, fileName);
            } catch (ex) { c = false; }
            if (c) {
                w.window.close();
            }
            else {
                w.alert('请将页面保存为：' + fileName + '，或者拷贝内容再粘贴到 excel');
            }

        },

        // 打印页面元素
        printEl: function (elementId, title) {
            var e = document.getElementById(elementId);
            var w = window.open();
            w.document.writeln(title);
            w.document.writeln(e.outerHTML);
            w.document.writeln('<script>window.print();<\/script>');
        },

        // 加载中

        loadingPanel: {
            control: undefined,
            delay: 1000,
            paused: false,
            defaultText: "",
            timerId: -1,
            show: function (text) {
                var x = this;
                if (x.control) {
                    if (text) x.control.SetText(text); else x.control.SetText(x.defaultText);
                    x.timerId = setTimeout(function () { x.control.Show(); }, x.delay);
                }
            },
            showNow: function (text) {
                var x = this;
                if (x.control) {
                    if (text) x.control.SetText(text); else x.control.SetText(x.defaultText);
                    x.control.Show();
                }
            },
            hide: function () {
                var x = this;
                clearTimeout(x.timerId);
                if (x.control && !x.paused) x.control.Hide();
            }
        },

        lastErrorMessage: "",
        handles: {},

        // 找到 opener 或者 parent 的句柄（iframe 优先）
        // handle: (bool: true - opener false - parent, ex) 
        callerEx: function (handle) {
            var x = undefined;
            var b = false;
            if (win.parent !== win) {
                if (win.parent.ISEx) x = win.parent.ISEx;
            }
            if (win.opener) {
                if (win.opener.ISEx) x = win.opener.ISEx;
                b = true;
            }
            if (x) handle(b, x);
        },

        // 返回：-1 0 1
        // -1: 独立页面，0: opener 1: parent
        getOpeningStatus: function () {
            if (win.opener) return 0;
            if (win.parent !== win) return 1;
            return -1;
        },

        splitter: {
            resizeCallback: function (s) {
            },
            onResize: function (s, e) {
                var x = ISEx.splitter;
                switch (e.pane.name) {
                    case "N":
                        x.n = e.pane.lastHeight;
                        break;
                    case "S":
                        x.s = e.pane.lastHeight;
                        break;
                    case "CW":
                        x.w = e.pane.lastHeight;
                        break;
                    case "CE":
                        x.e = e.pane.lastHeight;
                        break;
                    case "CX":
                        x.c = e.pane.lastHeight;
                        break;
                }
                if (x.resizeCallback) x.resizeCallback(this);
            },
            n: 0,
            s: 0,
            c: 0,
            t: 0,
            w: 0,
            e: 0
        },

        swf: function (id) {
            if (window.document[id]) {
                return window.document[id];
            } else if (navigator.appName.indexOf("Microsoft Internet") == -1) {
                if (document.embeds && document.embeds[id]) return document.embeds[id];
            } else {
                return document.getElementById(id);
            }
        }

    };

    // 去除控件对象的退格 返回上一页的操作

    var b = obj.getBrowserInfo();
    if (b === 'Internet Explorer' ||
        b === 'Mozilla') {
        win.document.onkeydown = function () { return !obj.disableBS(win.event); }
    } else if (b == 'Firefox') {
        win.document.onkeypress = function (e) { return !obj.disableBS(e); }
    }

    win.ISEx = obj; // 命名对象

})(window);
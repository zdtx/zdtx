
// 为页面提供基于 Ext.NET 的应用对象
// 名字为 window.ISEx

(function (window, undefined) {

    var obj = {

        wins: {

            worker1: undefined,
            initWorker1: function (win) {
                var x = this;
                x.worker1 = win;
            },
            show1: function (url) {
                var x = this;
                if (x.worker1) {
                    x.worker1.show();
                    x.worker1.load({ url: url });
                }
            }

        },

        resolve: function (ns, data) {
            var x = Ext.ns(ns);
            Ext.apply(x, data);
            return x;
        },

        extend: function (config) { return ISEx.apply(ISEx, config); },

        checkParent: function () {
            if (window === window.parent) return;
            if (window.parent.__begin) { // 判别是 ext 页面罩着
                window.parent.location.replace("default.aspx?ck=false");
            }
        },

        apply: function (data) {
            Ext.apply(obj, data);
            return obj;
        },

        begin: function () {

        }
    };

    window.ISEx = obj; // 命名对象

})(window);



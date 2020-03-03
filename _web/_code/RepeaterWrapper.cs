using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using D = eTaxi.Definitions;
namespace eTaxi.Web.Controls
{
    public partial class RepeaterWrapper : BaseControl
    {
        public RepeaterWrapper(Repeater rep) { _Repeater = rep; }
        protected Repeater _Repeater = null;
        public Repeater Rep { get { return _Repeater; } }

        /// <summary>
        /// 行创建辅助对象
        /// </summary>
        public class ItemCreator
        {
            private RepeaterItem _Item = null;
            public RepeaterItem Item { get { return _Item; } }
            public ItemCreator(RepeaterItem item) { _Item = item; }
            public void Get<TControl>(string id,
                Action<TControl> handle,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header ||
                    _Item.ItemType == ListItemType.Footer ||
                    _Item.ItemType == ListItemType.Pager ||
                    _Item.ItemType == ListItemType.Separator) return;
                var c = _Item.FindControl(id) as TControl;
                if (c == null && !exceptionIfNotFound) return;
                handle(c);
            }
            public ItemCreator Do<TControl>(
                string id,
                Action<TControl> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                return Do<TControl>(id, (c, i) => { if (handle != null) handle(c); }, exceptionIfNotFound);
            }
            public ItemCreator Do<TControl>(
                string id,
                Action<TControl, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header ||
                    _Item.ItemType == ListItemType.Footer ||
                    _Item.ItemType == ListItemType.Pager ||
                    _Item.ItemType == ListItemType.Separator) return this;
                return _Do(id, handle, exceptionIfNotFound);
            }
            public ItemCreator DoHeader<TControl>(
                string id,
                Action<TControl> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                return DoHeader<TControl>(id, (c, i) => { if (handle != null) handle(c); }, exceptionIfNotFound);
            }
            public ItemCreator DoHeader<TControl>(
                string id,
                Action<TControl, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header)
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }
            public ItemCreator DoFooter<TControl>(
                string id,
                Action<TControl> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                return DoFooter<TControl>(id, (c, i) => { if (handle != null) handle(c); }, exceptionIfNotFound);
            }
            public ItemCreator DoFooter<TControl>(
                string id,
                Action<TControl, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Footer)
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }
            private ItemCreator _Do<TControl>(
                string id,
                Action<TControl, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                var c = _Item.FindControl(id) as TControl;
                if (c == null && !exceptionIfNotFound) return this;
                if (handle != null) handle(c, _Item);
                return this;
            }
            public ItemCreator Do(Action<RepeaterItem> handle)
            {
                if (handle != null) handle(_Item);
                return this;
            }
        }

        /// <summary>
        /// 数据绑定辅助对象
        /// </summary>
        public class ItemBinder<T>
        {
            private T _Object = default(T);
            public T Object { get { return _Object; } }
            private RepeaterItem _Item = null;
            public RepeaterItem Item { get { return _Item; } }
            public ItemBinder(RepeaterItem item, T obj) { _Item = item; _Object = obj; }
            public void Get<TControl>(string id,
                Action<TControl> handle,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header ||
                    _Item.ItemType == ListItemType.Footer ||
                    _Item.ItemType == ListItemType.Pager ||
                    _Item.ItemType == ListItemType.Separator) return;
                var c = _Item.FindControl(id) as TControl;
                if (c == null && !exceptionIfNotFound) return;
                handle(c);
            }
            public ItemBinder<T> Do<TControl>(
                string id, Action<TControl, T, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header ||
                    _Item.ItemType == ListItemType.Footer ||
                    _Item.ItemType == ListItemType.Pager ||
                    _Item.ItemType == ListItemType.Separator) return this;
                return _Do(id, handle, exceptionIfNotFound);
            }
            public ItemBinder<T> DoHeader<TControl>(
                string id, Action<TControl, T, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header)
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }
            public ItemBinder<T> DoFooter<TControl>(
                string id, Action<TControl, T, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Footer)
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }
            private ItemBinder<T> _Do<TControl>(
                string id, Action<TControl, T, RepeaterItem> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                var c = _Item.FindControl(id) as TControl;
                if (c == null && !exceptionIfNotFound) return this;
                if (handle != null) handle(c, _Object, _Item);
                return this;
            }
        }

        /// <summary>
        /// 值获取辅助对象
        /// </summary>
        /// <typeparam name="T">数据规格定义</typeparam>
        public class ItemCollector<T> where T : class, new()
        {
            protected T _Object = default(T);
            protected RepeaterItem _Item = null;
            public RepeaterItem Item { get { return _Item; } }
            public ItemCollector<TOther> Transform<TOther>() where TOther : class,new() { return new ItemCollector<TOther>(_Item, new TOther()); }
            public ItemCollector(RepeaterItem item, T obj) { _Item = item; _Object = obj; }
            /// <summary>
            /// 收集行区域的空间值
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public ItemCollector<T> Do<TControl>(
                string id, Action<T, TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header ||
                    _Item.ItemType == ListItemType.Footer ||
                    _Item.ItemType == ListItemType.Pager ||
                    _Item.ItemType == ListItemType.Separator) return this;
                return _Do(id, handle, exceptionIfNotFound);
            }
            /// <summary>
            /// 收集表头区域的值
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public ItemCollector<T> DoHeader<TControl>(
                string id, Action<T, TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header) 
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }
            /// <summary>
            /// 收集页脚区域的值
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public ItemCollector<T> DoFooter<TControl>(
                string id, Action<T, TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Footer)
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }

            protected ItemCollector<T> _Do<TControl>(
                string id, Action<T, TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                _Item.FindControl(id).If<TControl>(c => { handle(_Object, c, _Item); }, exceptionIfNotFound);
                return this;
            }
        }

        /// <summary>
        /// 通用的 Item 数据收集器（依赖通用数据结构 Dictionary(string, object））
        /// </summary>
        public class ItemCollector : ItemCollector<Dictionary<string, object>>
        {
            public object GetValue(string id) { return _Object[id]; }
            public ItemCollector(RepeaterItem item, Dictionary<string, object> data) : base(item, data) { }
            public ItemCollector Do<T, TControl>(
                string id, Func<TControl, T> valueGet,
                bool exceptionIfNotFound = true) where TControl : Control
            {
                _Item.FindControl(id).If<TControl>(c =>
                {
                    if (_Object.ContainsKey(id)) _Object[id] = valueGet(c);
                    else _Object.Add(id, valueGet(c));
                }, exceptionIfNotFound);
                return this;
            }
        }

        /// <summary>
        /// 值获取辅助对象
        /// </summary>
        /// <typeparam name="T">数据规格定义</typeparam>
        public class ItemVisitor
        {
            protected RepeaterItem _Item = null;
            public RepeaterItem Item { get { return _Item; } }
            public ItemVisitor(RepeaterItem item) { _Item = item; }
            /// <summary>
            /// 收集行区域的空间值
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public ItemVisitor Do<TControl>(
                string id, Action<TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header ||
                    _Item.ItemType == ListItemType.Footer ||
                    _Item.ItemType == ListItemType.Pager ||
                    _Item.ItemType == ListItemType.Separator) return this;
                return _Do(id, handle, exceptionIfNotFound);
            }

            /// <summary>
            /// 连锁获取控件状态
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public ItemVisitor Get<TControl>(
                string id, Action<TControl> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header ||
                    _Item.ItemType == ListItemType.Footer ||
                    _Item.ItemType == ListItemType.Pager ||
                    _Item.ItemType == ListItemType.Separator) return this;
                return _Do<TControl>(id, (c, i) => handle(c), exceptionIfNotFound);
            }

            /// <summary>
            /// 收集表头区域的值
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public ItemVisitor DoHeader<TControl>(
                string id, Action<TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Header) 
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }
            /// <summary>
            /// 收集页脚区域的值
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public ItemVisitor DoFooter<TControl>(
                string id, Action<TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Item.ItemType == ListItemType.Footer)
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }

            protected ItemVisitor _Do<TControl>(
                string id, Action<TControl, RepeaterItem> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                _Item.FindControl(id).If<TControl>(c => { handle(c, _Item); }, exceptionIfNotFound);
                return this;
            }
        }

        /// <summary>
        /// 初始化配置
        /// </summary>
        /// <param name="rep"></param>
        public RepeaterWrapper Initialize(Action<ItemCreator> itemCreate = null)
        {
            if (itemCreate != null)
            {
                _Repeater.ItemCreated += (s, e) =>
                {
                    itemCreate(new ItemCreator(e.Item));
                };
            }
            return this;
        }

        /// <summary>
        /// 数据绑定方法
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        public Action<ItemBinder<T>> Execute<T>(
            List<T> data, Action<ItemBinder<T>> bind = null, bool hideIfEmpty = false)
        {
            _Repeater.ItemDataBound += (s, e) =>
            {
                switch (e.Item.ItemType)
                {
                    case ListItemType.AlternatingItem:
                    case ListItemType.EditItem:
                    case ListItemType.Footer:
                    case ListItemType.Header:
                    case ListItemType.Item:
                    case ListItemType.Pager:
                    case ListItemType.SelectedItem:
                    case ListItemType.Separator:
                        ItemBinder<T> binder = new ItemBinder<T>(e.Item, (T)e.Item.DataItem);
                        if (bind != null) bind(binder);
                        break;
                }
            };

            _Repeater.DataSource = data;
            _Repeater.DataBind();
            _Repeater.Visible = true;
            
            if (hideIfEmpty && data.Count == 0) _Repeater.Visible = false;
            return bind;
        }

        /// <summary>
        /// Repeater 取值（将控件数据放入具有类型为 T 的数据结构中）
        /// 通过 ItemIndex 匹配输入的 Data 的 Index
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        public void SynTo<T>(List<T> data, Action<ItemCollector<T>> collect) where T : class, new()
        {
            for (int i = 0; i < _Repeater.Items.Count; i++)
            {
                ItemCollector<T> collector = new ItemCollector<T>(_Repeater.Items[i], data[i]);
                if (collect != null) collect(collector);
            }
        }

        /// <summary>
        /// 获取列表类型为 T 的记录
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="collect"></param>
        /// <returns></returns>
        public List<T> Collect<T>(Func<int, ItemCollector<T>, bool> collect) where T : class, new()
        {
            List<T> data = new List<T>();
            for (int i = 0; i < _Repeater.Items.Count; i++)
            {
                T itemData = Activator.CreateInstance<T>();
                var c = new ItemCollector<T>(_Repeater.Items[i], itemData);
                if (collect(i, c)) data.Add(itemData);
            }
            return data;
        }

        /// <summary>
        /// Repeater 取值（将控件数据放入通用类型的数据结构中）
        /// 单行数据使用 Dictionary（string, object） 存储
        /// 例如：("Quantity", 1) ("Name", "ABC")
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="row"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public List<Dictionary<string, object>> Collect(Func<int, ItemCollector, bool> collect)
        {
            List<Dictionary<string, object>> data = new List<Dictionary<string, object>>();
            for (int i = 0; i < _Repeater.Items.Count; i++)
            {
                Dictionary<string, object> itemData = new Dictionary<string, object>();
                var c = new ItemCollector(_Repeater.Items[i], itemData);
                if (collect(i, c)) data.Add(itemData);
            }
            return data;
        }

        /// <summary>
        /// 获取其中一列的数据
        /// </summary>
        /// <typeparam name="TControl"></typeparam>
        /// <param name="id"></param>
        /// <param name="valueGet"></param>
        /// <returns></returns>
        public List<T> CollectFromControlId<T, TControl>(string id, Func<TControl, T> valueGet,
            bool exceptionIfNotFound = false) where TControl : Control
        {
            List<T> result = new List<T>();
            for (int i = 0; i < _Repeater.Items.Count; i++)
            {
                RepeaterItem r = _Repeater.Items[i];
                r.FindControl(id).If<TControl>(c =>
                    result.Add(valueGet(c)), exceptionIfNotFound);
            }
            return result;
        }

        /// <summary>
        /// 执行控件的巡回
        /// </summary>
        /// <typeparam name="TControl"></typeparam>
        /// <param name="collect"></param>
        public void Visit(Action<ItemVisitor> visit)
        {
            for (int i = 0; i < _Repeater.Items.Count; i++) visit(new ItemVisitor(_Repeater.Items[i]));
        }

    }
}
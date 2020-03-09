using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using D = eTaxi.Definitions;

namespace eTaxi.Web
{
    public class GridWrapper : BaseControl
    {
        /// <summary>
        /// 需要插入的 Footer 类型
        /// </summary>
        public enum FooterType
        {
            /// <summary>
            /// 无页脚
            /// </summary>
            None,
            /// <summary>
            /// 插入 Label 控件
            /// </summary>
            Label,
            /// <summary>
            /// 插入 Literal 控件
            /// </summary>
            Literal,
            /// <summary>
            /// 按钮
            /// </summary>
            Button,
            /// <summary>
            /// 链接
            /// </summary>
            LinkButton,
            /// <summary>
            /// 图片
            /// </summary>
            Image
        }

        /// <summary>
        /// 选择模式
        /// </summary>
        public enum SelectionMode
        {
            /// <summary>
            /// 无
            /// </summary>
            None,
            /// <summary>
            /// 多选
            /// </summary>
            Multiple,
            /// <summary>
            /// 单选
            /// </summary>
            Single
        }

        /// <summary>
        /// 设置列信息
        /// </summary>
        public class ColumnSetter
        {
            private GridView _Grid = null;
            public ColumnSetter(GridView gv) { _Grid = gv; }

            /// <summary>
            /// 为 GridView 插入一般的绑定列
            /// </summary>
            /// <param name="fieldName"></param>
            /// <param name="headerText"></param>
            /// <param name="fieldSet"></param>
            /// <returns></returns>
            public ColumnSetter BoundField(string fieldName, string headerText,
                Action<BoundField> fieldSet = null)
            {
                var c = new BoundField() { DataField = fieldName, HeaderText = headerText };
                c.ItemStyle.CssClass = "gridItem-bound";
                c.ItemStyle.VerticalAlign = VerticalAlign.Top;
                if (fieldSet != null) fieldSet(c);
                _Grid.Columns.Add(c);
                return this;
            }

            /// <summary>
            /// 为 GridView 插入模板列
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="id"></param>
            /// <param name="headerText"></param>
            /// <param name="templateItem"></param>
            /// <param name="fieldSet"></param>
            /// <param name="footer"></param>
            /// <returns></returns>
            public ColumnSetter TemplateField<T>(string id,
                string headerText, T templateItem, Action<TemplateField> fieldSet = null,
                FooterType footer = FooterType.None) where T : TemplateItem.BaseItem
            {
                if (!
                    string.IsNullOrEmpty(id)) templateItem.Id = id;
                var c = new TemplateField()
                {
                    HeaderTemplate = new TemplateItem.Label(l => { l.Text = headerText; }) { Id = id + "_Header" },
                    ItemTemplate = templateItem
                };

                c.HeaderStyle.CssClass = "gridHeader";
                c.ItemStyle.CssClass = "gridItem-template";

                if (templateItem is TemplateItem.DropDownField ||
                    templateItem is TemplateItem.DropDownList ||
                    templateItem is TemplateItem.DXButton ||
                    templateItem is TemplateItem.DXComboBox ||
                    templateItem is TemplateItem.DXDateEdit ||
                    templateItem is TemplateItem.DXSpinEdit ||
                    templateItem is TemplateItem.DXTextBox ||
                    templateItem is TemplateItem.DXTimeEdit ||
                    templateItem is TemplateItem.PopupField ||
                    templateItem is TemplateItem.TextBox ||
                    templateItem is TemplateItem.LinkButton
                )
                {
                    c.ItemStyle.CssClass = "gridItem-template-c";
                }

                if (fieldSet != null) fieldSet(c);
                switch (footer)
                {
                    case FooterType.Button:
                        c.FooterTemplate = new TemplateItem.CheckBox() { Id = id + "_ft" };
                        break;
                    case FooterType.Image:
                        c.FooterTemplate = new TemplateItem.Image() { Id = id + "_ft" };
                        break;
                    case FooterType.Label:
                        c.FooterTemplate = new TemplateItem.Label() { Id = id + "_ft" };
                        break;
                    case FooterType.Literal:
                        c.FooterTemplate = new TemplateItem.Literal() { Id = id + "_ft" };
                        break;
                    case FooterType.LinkButton:
                        c.FooterTemplate = new TemplateItem.LinkButton() { Id = id + "_ft" };
                        break;
                }
                _Grid.Columns.Add(c);
                return this;
            }

        }

        /// <summary>
        /// 行创建辅助对象
        /// </summary>
        public class RowCreator
        {
            private GridViewRow _Row = null;
            public GridViewRow Row { get { return _Row; } }
            public RowCreator(GridViewRow row) { _Row = row; }
            public RowCreator Do<TControl>(string id, Action<TControl> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                var c = Row.FindControl(id) as TControl;
                if (c == null && !exceptionIfNotFound) return this;
                if (handle != null) handle(c);
                return this;
            }
            public RowCreator Do(Action<GridViewRow> handle)
            {
                if (handle != null) handle(_Row);
                return this;
            }
        }

        /// <summary>
        /// 数据绑定辅助对象
        /// </summary>
        public class RowBinder<T>
        {
            private T _Object = default(T);
            public T Object { get { return _Object; } }
            private GridViewRow _Row = null;
            public GridViewRow Row { get { return _Row; } }
            public RowBinder(GridViewRow row, T obj) { _Row = row; _Object = obj; }

            /// <summary>
            /// 处理嵌套在 GridView 的第一列选择框
            /// </summary>
            /// <param name="handle"></param>
            /// <returns></returns>
            public RowBinder<T> DoCB(Action<CheckBox, T> handle = null)
            {
                Row.FindControl("__cb").If<CheckBox>(c =>
                {
                    if (handle != null) handle(c, _Object);
                });
                return this;
            }

            /// <summary>
            /// 处理嵌套在 GridView 的 button（用于响应 rowClick 事件的）
            /// </summary>
            /// <param name="handle"></param>
            /// <returns></returns>
            public RowBinder<T> DoB(Action<Button, T> handle = null)
            {
                Row.FindControl("__b").If<Button>(c =>
                {
                    if (handle != null) handle(c, _Object);
                });
                return this;
            }

            /// <summary>
            /// 处理嵌套在 GridView 的 行号 label
            /// </summary>
            /// <param name="handle"></param>
            /// <returns></returns>
            public RowBinder<T> DoLB(Action<Label, T> handle = null)
            {
                Row.FindControl("__lb").If<Label>(c =>
                {
                    if (handle != null) handle(c, _Object);
                });
                return this;
            }

            public RowBinder<T> Do<TControl>(
                string id, Action<TControl, T> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                var c = Row.FindControl(id) as TControl;
                if (c == null && !exceptionIfNotFound) return this;
                if (handle != null) handle(c, _Object);
                return this;
            }
            public RowBinder<T> Do<TControl>(
                string id, Action<TControl, T, GridViewRow> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                var c = Row.FindControl(id) as TControl;
                if (c == null && !exceptionIfNotFound) return this;
                if (handle != null) handle(c, _Object, Row);
                return this;
            }
        }

        /// <summary>
        /// 值获取辅助对象
        /// </summary>
        /// <typeparam name="T">数据规格定义</typeparam>
        public class RowCollector<T> where T : class, new()
        {
            protected T _Object = default(T);
            protected GridViewRow _Row = null;
            public GridViewRow Row { get { return _Row; } }
            public RowCollector<TOther> Transform<TOther>() where TOther : class,new() { return new RowCollector<TOther>(_Row, new TOther()); }
            public T GetData(Action<T> handle = null) { if (handle != null) handle(_Object); return _Object; }
            public RowCollector(GridViewRow row, T obj) { _Row = row; _Object = obj; }
            public virtual RowCollector<T> Do<TControl>(
                string id, Action<T, TControl> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                _Row.FindControl(id).If<TControl>(c => { handle(_Object, c); }, exceptionIfNotFound);
                return this;
            }
        }

        /// <summary>
        /// 通用的 Row 数据收集器（依赖通用数据结构 Dictionary(string, object））
        /// </summary>
        public class RowCollector : RowCollector<Dictionary<string, object>>
        {
            public object GetValue(string id) { return _Object[id]; }
            public RowCollector(GridViewRow row, Dictionary<string, object> data) : base(row, data) { }
            public RowCollector Do<T, TControl>(
                string id, Func<TControl, T> valueGet,
                bool exceptionIfNotFound = true) where TControl : Control
            {
                _Row.FindControl(id).If<TControl>(c =>
                {
                    if (_Object.ContainsKey(id)) _Object[id] = valueGet(c);
                    else _Object.Add(id, valueGet(c));
                }, exceptionIfNotFound);
                return this;
            }
            public RowCollector Visit<T>(
                string id, Action<T> handle,
                bool exceptionIfNotFound = true) where T : Control
            {
                _Row.FindControl(id).If<T>(c => handle(c), exceptionIfNotFound);
                return this;
            }
        }

        /// <summary>
        /// 值获取辅助对象
        /// </summary>
        /// <typeparam name="T">数据规格定义</typeparam>
        public class RowVisitor
        {
            protected GridViewRow _Row = null;
            public GridViewRow Row { get { return _Row; } }
            public RowVisitor(GridViewRow row) { _Row = row; }
            /// <summary>
            /// 收集行区域的空间值
            /// </summary>
            /// <typeparam name="TControl"></typeparam>
            /// <param name="id"></param>
            /// <param name="handle"></param>
            /// <param name="exceptionIfNotFound"></param>
            /// <returns></returns>
            public RowVisitor Do<TControl>(
                string id, Action<TControl, GridViewRow> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Row.RowType != DataControlRowType.DataRow) return this;
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
            public RowVisitor Get<TControl>(
                string id, Action<TControl> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Row.RowType != DataControlRowType.DataRow) return this;
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
            public RowVisitor DoHeader<TControl>(
                string id, Action<TControl, GridViewRow> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Row.RowType == DataControlRowType.Header)
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
            public RowVisitor DoFooter<TControl>(
                string id, Action<TControl, GridViewRow> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                if (_Row.RowType == DataControlRowType.Footer)
                    return _Do(id, handle, exceptionIfNotFound);
                return this;
            }

            protected RowVisitor _Do<TControl>(
                string id, Action<TControl, GridViewRow> handle, bool exceptionIfNotFound = true) where TControl : Control
            {
                _Row.FindControl(id).If<TControl>(c => { handle(c, _Row); }, exceptionIfNotFound);
                return this;
            }
        }

        /// <summary>
        /// 页脚绑定辅助对象
        /// </summary>
        public class FooterBinder
        {
            private GridViewRow _Row = null;
            public GridViewRow Row { get { return _Row; } }
            public FooterBinder(GridViewRow row) { _Row = row; }
            public FooterBinder RS(Action<GridViewRow> setter)
            {
                setter(Row);
                return this;
            }
            public FooterBinder Do<TControl>(
                string id, Action<TControl> handle = null,
                bool exceptionIfNotFound = false) where TControl : Control
            {
                var c = Row.FindControl(id + "_ft") as TControl;
                if (c == null && !exceptionIfNotFound) return this;
                if (handle != null) handle(c);
                return this;
            }
        }

        protected GridView _Grid = null;
        public GridView Grid { get { return _Grid; } }
    }
}
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using eTaxi.L2SQL;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 将 GridView 进行闭包，使得 GridView 能用于执行细表操作
    /// </summary>
    public partial class GridWrapperForDetail : GridWrapper
    {
        /// <summary>
        /// 获取当前行 被选 状态
        /// </summary>
        public Dictionary<int, bool> GetSelected()
        {
            Dictionary<int, bool> result = new Dictionary<int, bool>();
            for (int i = 0; i < _Grid.Rows.Count; i++)
            {
                var cb = _Grid.Rows[i].FindControl(string.Format("__cb_{0}", Grid.ID)) as CheckBox;
                result.Add(_Grid.Rows[i].RowIndex, cb.Enabled && cb.Checked);
            }
            return result;
        }

        /// <summary>
        /// 针对同 Index 序列的数据进行截取
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="data">原始数据序列</param>
        /// <param name="select"></param>
        /// <returns></returns>
        public List<TResult> GetSelected<T, TResult>(List<T> data, Func<T, TResult> select)
        {
            var result = new List<TResult>();
            for (int i = 0; i < data.Count; i++)
            {
                foreach (var kv in GetSelected())
                {
                    if (kv.Key == i && kv.Value)
                    {
                        result.Add(select(data[i]));
                        break;
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// 单列值收集
        /// </summary>
        /// <typeparam name="TControl"></typeparam>
        /// <typeparam name="T"></typeparam>
        /// <param name="id">列所在ID</param>
        /// <param name="valueGet"></param>
        /// <returns></returns>
        public List<T> GetSelected<TControl, T>(string id, Func<TControl, T> valueGet) where TControl : Control
        {
            List<T> result = new List<T>();
            foreach (var kv in GetSelected())
            {
                if (kv.Value)
                {
                    var dic = new Dictionary<string, object>();
                    var rc = new RowCollector(_Grid.Rows[kv.Key], dic);
                    rc.Do(id, valueGet);
                    result.Add((T)dic[id]);
                }
            }
            return result;
        }

        /// <summary>
        /// 初始化配置
        /// </summary>
        /// <param name="gv"></param>
        /// <param name="columnSet"></param>
        public void Initialize(GridView gv,
            Action<ColumnSetter> columnSet = null, 
            Action<RowCreator> rowCreate = null, bool checkBox = true, bool showFooter = true)
        {
            _Grid = gv;

            gv.CssClass = "grid";
            gv.ShowFooter = showFooter;
            gv.ShowHeaderWhenEmpty = true;
            gv.ShowHeader = true;
            gv.AutoGenerateColumns = false;
            gv.RowStyle.CssClass = "gridRow";

            // 序号字段
            var c = new TemplateField()
            {
                HeaderTemplate = new TemplateItem.Label(l => l.Text = "#") { Id = "__lb_Header" },
                ItemTemplate = new TemplateItem.Label() { Id = "__lb" }
            };

            c.HeaderStyle.HorizontalAlign = HorizontalAlign.Right;
            c.HeaderStyle.Width = 30;
            c.ItemStyle.CssClass = "gridItem-bound-n";
            c.ItemStyle.Width = 30;
            c.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            c.ItemStyle.VerticalAlign = VerticalAlign.Middle;

            gv.Columns.Add(c);

            // 行选择字段
            if (checkBox)
            {
                c = new TemplateField()
                {
                    HeaderTemplate = new TemplateItem.CheckBox(cc =>
                    {
                        cc.Attributes["onclick"] = string.Format("ISEx.toggleCBs(this,'__cb_{0}')", gv.ID);
                    })
                    {
                        Id = "__cb_Header"
                    },
                    ItemTemplate = new TemplateItem.CheckBox() { Id = string.Format("__cb_{0}", gv.ID) }
                };

                c.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                c.HeaderStyle.Width = 20;
                c.ItemStyle.CssClass = "gridItem-template";
                c.ItemStyle.Width = 20;
                c.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                c.ItemStyle.VerticalAlign = VerticalAlign.Top;

                gv.Columns.Add(c);
            }

            if (columnSet != null) columnSet(new ColumnSetter(gv));
            gv.RowDataBound += (s, e) =>
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    e.Row.FindControl("__lb").If<Label>(l => l.Text = (e.Row.RowIndex + 1).ToString());
                    if (checkBox)
                    {
                        e.Row
                            .FindControl(string.Format("__cb_{0}", Grid.ID))
                            .If<CheckBox>(cc => cc.Attributes["onclick"] = string.Format(
                                "{0}.selection[{1}]=this.checked;ISEx.toggleCB(this);", 
                                ClientID, e.Row.RowIndex.ToString()));
                    }
                }
            };

            if (rowCreate != null)
            {
                gv.RowCreated += (s, e) =>
                {
                    if (e.Row.RowType == DataControlRowType.DataRow)
                    {
                        e.Row.ID = "r" + e.Row.RowIndex.ToString();
                        rowCreate(new RowCreator(e.Row));
                    }
                };
            }
        }

        /// <summary>
        /// 数据绑定方法
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        public Action<RowBinder<T>> Execute<T>(List<T> data,
            Action<RowBinder<T>> bind = null, Action<FooterBinder> footerBind = null)
        {
            _Grid.RowDataBound += (s, e) =>
            {
                if (e.Row.RowType != DataControlRowType.DataRow) return;
                RowBinder<T> binder = new RowBinder<T>(Grid, e.Row, (T)e.Row.DataItem);
                if (bind != null) bind(binder);
            };
            _Grid.DataSource = data;
            _Grid.DataBind();

            // 页脚
            if (footerBind != null && _Grid.FooterRow != null)
                footerBind(new FooterBinder(_Grid.FooterRow));

            // 注入 js 对象
            string arrDef = string.Empty;
            for (int i = 0; i < data.Count; i++) arrDef += arrDef.Length > 0 ? ",false" : "false";
            ScriptManager.RegisterClientScriptBlock(this, GetType(), ClientID, string.Format(
                "ISEx.resolve('{0}',{{selection:[{1}],hasChecked:function(){{var r=false;var x=this.selection;for(i=0;i<x.length;i++)if(x[i])r=true;return r;}}}});", ClientID, arrDef), true);

            // 提供方法的返回，方便重用
            return bind;
        }

        /// <summary>
        /// Grid 取值（将控件数据放入具有类型为 T 的数据结构中）
        /// 通过 RowIndex 匹配输入的 Data 的 Index
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        public void Syn<T>(List<T> data, Action<RowCollector<T>> collect) where T : class, new()
        {
            for (int i = 0; i < _Grid.Rows.Count; i++)
            {
                RowCollector<T> collector = new RowCollector<T>(_Grid.Rows[i], data[i]);
                if (collect != null) collect(collector);
            }
        }

        /// <summary>
        /// Grid 取值（将控件数据放入具有类型为 T 的数据结构中）
        /// </summary>
        public List<T> Collect<T>(Func<int, RowCollector<T>, bool> collect) where T : class, new()
        {
            List<T> data = new List<T>();
            for (int i = 0; i < _Grid.Rows.Count; i++)
            {
                T rowData = Activator.CreateInstance<T>();
                var c = new RowCollector<T>(_Grid.Rows[i], rowData);
                if (collect(i, c)) data.Add(rowData);
            }
            return data;
        }

        /// <summary>
        /// Grid 取值（将控件数据放入通用类型的数据结构中）
        /// 单行数据使用 Dictionary（string, object） 存储
        /// 例如：("Quantity", 1) ("Name", "ABC")
        /// </summary>
        public List<Dictionary<string, object>> Collect(Func<int, RowCollector, bool> collect)
        {
            List<Dictionary<string, object>> data = new List<Dictionary<string, object>>();
            for (int i = 0; i < _Grid.Rows.Count; i++)
            {
                Dictionary<string, object> rowData = new Dictionary<string, object>();
                var c = new RowCollector(_Grid.Rows[i], rowData);
                if (collect(i, c)) data.Add(rowData);
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
            for (int i = 0; i < _Grid.Rows.Count; i++)
            {
                GridViewRow r = _Grid.Rows[i];
                r.FindControl(id).If<TControl>(c =>
                    result.Add(valueGet(c)), exceptionIfNotFound);
            }
            return result;
        }

    }
}
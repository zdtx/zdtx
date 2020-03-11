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

namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 将 GridView 进行闭包，使得 GridView 能用于执行选择操作
    /// </summary>
    public partial class GridWrapperForList : GridWrapper
    {
        private bool _RowButtonVisible = false;
        /// <summary>
        /// 控制页面单行选择的按钮是否显示
        /// </summary>
        public bool RowButtonVisible
        {
            get { return _RowButtonVisible; }
            set { _RowButtonVisible = value; }
        }

        public string RowButtonClientClick { get; set; }
        private bool _DblClickToSelect = false;
        /// <summary>
        /// 是否允许双击后选择单行
        /// </summary>
        public bool DlbClickToSelect
        {
            get { return _DblClickToSelect; }
            set { _DblClickToSelect = value; }
        }

        private GridWrapper.SelectionMode _Mode = SelectionMode.None;
        /// <summary>
        /// 选择模式
        /// </summary>
        public GridWrapper.SelectionMode Mode { get { return _Mode; } }

        /// <summary>
        /// 发生排序事件
        /// </summary>
        public event EventHandler Sort = null;

        /// <summary>
        /// 使用中的排序器
        /// </summary>
        public List<GridHeaderSorter> GetSorters()
        {
            List<GridHeaderSorter> result = new List<GridHeaderSorter>();
            if (_Grid.HeaderRow == null) return result;
            _Grid.HeaderRow.Controls.Visit(c =>
            {
                c.If<GridHeaderSorter>(s => { result.Add(s); });
            });
            return result;
        }

        /// <summary>
        /// 获取当前行 被选 状态
        /// </summary>
        public Dictionary<int, bool> Selection
        {
            get
            {
                Dictionary<int, bool> result = new Dictionary<int, bool>();
                for (int i = 0; i < _Grid.Rows.Count; i++)
                {
                    var cb = _Grid.Rows[i].FindControl("__cb") as CheckBox;
                    result.Add(_Grid.Rows[i].RowIndex, cb.Checked);
                }
                return result;
            }
        }

        /// <summary>
        /// 针对同 Index 序列的数据进行截取
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="data"></param>
        /// <param name="select"></param>
        /// <returns></returns>
        public List<TResult> GetSelected<T, TResult>(List<T> data, Func<T, TResult> select)
        {
            var result = new List<TResult>();
            for (int i = 0; i < data.Count; i++)
            {
                foreach (var kv in Selection)
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
            foreach (var kv in Selection)
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
        /// 初始化
        /// </summary>
        /// <param name="gv"></param>
        /// <param name="columnSet"></param>
        /// <param name="rowCreate"></param>
        /// <param name="rowDataCollect"></param>
        /// <param name="multiSelect">null: 不选择 true: 多选（checkbox）false: 单选</param>
        public void Initialize(GridView gv,
            Action<ColumnSetter> columnSet,
            Action<RowCreator> rowCreate = null,
            Action<RowCollector> rowDataCollect = null,
            GridWrapper.SelectionMode mode = SelectionMode.None, bool showRowNumber = true, bool showFooter = true)
        {
            _Grid = gv;
            _Mode = mode;

            gv.CssClass = "grid";
            gv.ShowFooter = showFooter;
            gv.ShowHeaderWhenEmpty = true;
            gv.ShowHeader = true;
            gv.AutoGenerateColumns = false;
            gv.RowStyle.CssClass = "gridRow";
            if (gv.RowStyle.Height == Unit.Empty) gv.RowStyle.Height = 20;
            List<DataControlField> columns = new List<DataControlField>();

            if (showRowNumber)
            {
                var c = new TemplateField()
                {
                    HeaderTemplate = new TemplateItem.Label(l => l.Text = " # ") { Id = "__lb_Header" },
                    ItemTemplate = new TemplateItem.Label() { Id = "__lb" }
                };
                c.HeaderStyle.HorizontalAlign = HorizontalAlign.Right;
                c.HeaderStyle.Width = 30;
                c.ItemStyle.CssClass = "gridItem-bound-n";
                c.ItemStyle.Width = 30;
                c.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                if (!_RowButtonVisible) c.ItemStyle.CssClass = "gridItem-bound-n-b";
                columns.Add(c);
            }

            switch (_Mode)
            {
                case SelectionMode.Multiple:

                    var c = new TemplateField()
                    {
                        HeaderTemplate = new TemplateItem.CheckBox(cc =>
                        {
                            cc.Attributes["onclick"] = "ISEx.toggleCBs(this,'__cb')";
                        })
                        {
                            Id = "__cb_Header"
                        },
                        ItemTemplate = new TemplateItem.CheckBox() { Id = "__cb" }
                    };
                    c.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                    c.HeaderStyle.Width = 20;
                    c.ItemStyle.CssClass = "gridItem-template";
                    c.ItemStyle.Width = 20;
                    c.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                    columns.Add(c);

                    break;
                case SelectionMode.Single:

                    c = new TemplateField()
                    {
                        ItemTemplate = new TemplateItem.Button(b =>
                        {
                            b.ID = "__b";
                            b.Text = "选";
                            b.Height = 20;
                            if (!_RowButtonVisible) b.Style.Add("display", "none");
                        })
                    };
                    c.ItemStyle.CssClass = "gridItem-hidden";
                    columns.Add(c);

                    break;
            }

            //if (gv.Columns.Count == 0)
            //{
            //    columns.ForEach(c => gv.Columns.Add(c));
            //}
            //else
            //{
            //    for (int i = 0; i < columns.Count; i++) gv.Columns.Insert(i, columns[i]);
            //}

            columns.ForEach(c => gv.Columns.Add(c));
            if (columnSet != null) columnSet(new ColumnSetter(gv));
            
            gv.RowCreated += (s, e) =>
            {
                if (rowCreate != null) rowCreate(new RowCreator(e.Row));
            };

            gv.RowDataBound += (s, e) =>
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    /// 处理具有特殊约定的控件
                    /// __lb：行序号
                    /// __cb：行选择控件
                    /// __b： 行按钮（用于单选一行）

                    e.Row.FindControl("__lb").If<Label>(l => l.Text = (e.Row.RowIndex + 1).ToString());
                    e.Row.FindControl("__cb").If<CheckBox>(cc =>
                    {
                        cc.Attributes["onclick"] =
                        string.Format("{0}.selection[{1}]=this.checked;ISEx.toggleCB(this);", ClientID, e.Row.RowIndex.ToString());
                    });
                    e.Row.FindControl("__b").If<Button>(b =>
                    {
                        b.CommandName = "S";
                        b.CommandArgument = e.Row.RowIndex.ToString();
                        b.OnClientClick = RowButtonClientClick;
                        if (!_RowButtonVisible)
                        {
                            if (_DblClickToSelect)
                            {
                                e.Row.Attributes["ondblclick"] =
                                    Page.ClientScript.GetPostBackEventReference(b, string.Empty);
                            }
                            else
                            {
                                e.Row.Attributes["onclick"] =
                                    Page.ClientScript.GetPostBackEventReference(b, string.Empty);
                            }
                        }
                    });
                }
            };

            gv.RowCommand += (s, e) =>
            {
                switch (e.CommandName)
                {
                    // 行选
                    case "S":

                        int index = _Util.Convert<int>(e.CommandArgument);
                        foreach (GridViewRow r in gv.Rows) r.CssClass = "gridRow";
                        gv.Rows[index].CssClass = "gridRow-selected";
                        if (rowDataCollect != null)
                        {
                            Dictionary<string, object> data = new Dictionary<string, object>();
                            RowCollector rc = new RowCollector(gv.Rows[index], data);
                            rowDataCollect(rc);
                        }

                        break;

                    // 排序表头
                    case "O":

                        // 备份排序信息
                        List<KeyValuePair<string, bool>> sorts = new List<KeyValuePair<string, bool>>();
                        List<GridHeaderSorter> sorters = GetSorters();

                        for (int i = 0; i < sorters.Count; i++)
                        {
                            if (sorters[i].FieldName == e.CommandArgument.ToStringEx())
                            {
                                if (sorters[i].Sort.HasValue) sorters[i].Sort = !sorters[i].Sort.Value;
                                else sorters[i].Sort = true;
                                sorts.Add(new KeyValuePair<string, bool>(sorters[i].FieldName, sorters[i].Sort.Value));
                            }
                        }

                        // 发出事件
                        if (Sort != null) Sort(this, EventArgs.Empty);

                        // 回写排序状态信息
                        sorters = GetSorters();
                        sorters.ForEach(ss => ss.Sort = null);
                        foreach (var ss in sorts)
                        {
                            sorters.ForEach(
                                sss =>
                                {
                                    if (sss.FieldName == ss.Key) sss.Sort = ss.Value; 
                                    sss.Caption = ss.Value.ToString();
                                });
                        }

                        break;
                }
            };
        }

        /// <summary>
        /// 简化版初始化（针对脚本直接写到 aspx 的情况）
        /// </summary>
        /// <param name="gv"></param>
        /// <param name="rowCreate"></param>
        public void Initialize(GridView gv,
            Action<RowCreator> rowCreate = null, bool showFooter = true)
        {
            Initialize(gv, s => { }, rowCreate, null, SelectionMode.None, false, showFooter);

            // 调换一些参数
            gv.CssClass = "gdList";
            gv.RowStyle.CssClass = null;
        }

        /// <summary>
        /// 数据绑定方法
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        public void Execute<T>(List<T> data,
            Action<RowBinder<T>> bind = null, Action<FooterBinder> footerBind = null)
        {
            _Grid.RowDataBound += (s, e) =>
            {
                if (e.Row.RowType != DataControlRowType.DataRow) return;
                RowBinder<T> binder = new RowBinder<T>(e.Row, (T)e.Row.DataItem);
                if (bind != null) bind(binder);
            };
            
            _Grid.DataSource = data;
            _Grid.DataBind();

            // 页脚
            if (footerBind != null && _Grid.FooterRow != null)
                footerBind(new FooterBinder(_Grid.FooterRow));

            // 注入 js 对象
            if (_Mode == SelectionMode.Multiple)
            {
                string arrDef = string.Empty;
                for (int i = 0; i < data.Count; i++) arrDef += arrDef.Length > 0 ? ",false" : "false";
                ScriptManager.RegisterClientScriptBlock(this, GetType(), ClientID, string.Format(
                    "ISEx.resolve('{0}',{{selection:[{1}],hasChecked:function(){{var r=false;var x=this.selection;for(i=0;i<x.length;i++)if(x[i])r=true;return r;}}}});", ClientID, arrDef), true);
            }
        }

        /// <summary>
        /// Grid 取值（将控件数据放入预定的数据类型中）
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="collect"></param>
        /// <returns></returns>
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
        /// <typeparam name="T"></typeparam>
        /// <param name="row"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        public List<Dictionary<string, object>> Collect(Action<RowCollector> collect)
        {
            List<Dictionary<string, object>> data = new List<Dictionary<string, object>>();
            foreach (GridViewRow r in _Grid.Rows)
            {
                Dictionary<string, object> rowData = new Dictionary<string, object>();
                var c = new RowCollector(r, rowData);
                collect(c);
                data.Add(rowData);
            }
            return data;
        }

    }
}
using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress;
using DevExpress.Web;
using DevExpress.XtraCharts;
using DevExpress.XtraCharts.Web;

using eTaxi.Web;
namespace eTaxi
{
    public static partial class Extension
    {
        #region GridView

        /// <summary>
        /// 对 DX GridView 的扩展：为传入的 Q 加载 OrderBy ThenBy OrderDescendingBy ...
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="gv"></param>
        /// <param name="q"></param>
        /// <returns></returns>
        public static IQueryable<T> ApplySorts<T>(this ASPxGridView gv, IQueryable<T> q,
            bool processGroup = false, bool groupAsc = true)
        {
            var columns = gv.GetSortedColumns();
            var gColumns = gv.GetGroupedColumns();
            List<KeyValuePair<string, bool>> sorts = new List<KeyValuePair<string, bool>>();
            foreach (var c in columns.OrderBy(cc => cc.SortIndex))
            {
                var asc = true;
                if (c.SortOrder == DevExpress.Data.ColumnSortOrder.Descending) asc = false;
                var gC = gColumns.SingleOrDefault(cc => cc.FieldName == c.FieldName);
                if (processGroup)
                {
                    if (gC != null) asc = groupAsc;
                }
                else
                {
                    if (gC != null) continue;
                }
                sorts.Add(new KeyValuePair<string, bool>(c.FieldName, asc));
            }

            return Exp.AppendSorts<T>(q, sorts.ToArray());
        }

        #endregion

        #region ComboBox

        /// <summary>
        /// 为 ComboBox 绑定列表数据
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tv"></param>
        /// <param name="data"></param>
        /// <param name="keyGet"></param>
        /// <param name="parentKeyGet"></param>
        /// <param name="nodeSet"></param>
        /// <param name="dept"></param>
        /// <param name="destroyData"></param>
        public static void FromList<T>(this ASPxComboBox cbx, List<T> data,
            Func<T, ListEditItem, bool> itemSet, bool canBeNull = false, Func<object> defaultItemSet = null)
        {
            FromListEx<T>(cbx, data, (d, i, item) => itemSet(d[i], item), canBeNull, defaultItemSet);
        }

        /// <summary>
        /// 为 ComboBox 绑定列表数据
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="cbx"></param>
        /// <param name="data"></param>
        /// <param name="itemSet"></param>
        /// <param name="canBeNull"></param>
        /// <param name="defaultItemSet"></param>
        public static void FromListEx<T>(this ASPxComboBox cbx, List<T> data,
            Func<List<T>, int, ListEditItem, bool> itemSet, bool canBeNull = false, Func<object> defaultItemSet = null)
        {
            cbx.Items.Clear();
            if (data.Count == 0) return;
            for (int i = 0; i < data.Count; i++)
            {
                ListEditItem item = new ListEditItem();
                if (itemSet(data, i, item)) cbx.Items.Add(item);
            }

            if (defaultItemSet != null)
            {
                for (int i = 0; i < cbx.Items.Count; i++)
                {
                    if (cbx.Items[i].Value.Equals(defaultItemSet())) cbx.Items[i].Selected = true;
                }
            }

            if (canBeNull)
            {
                if (cbx.Buttons.Count == 0)
                {
                    var b = cbx.Buttons.Add();
                    b.Index = 0;
                    b.Text = "X";
                    b.Width = 15;
                }
                if (string.IsNullOrEmpty(
                    cbx.ClientSideEvents.ButtonClick))
                    cbx.ClientSideEvents.ButtonClick = "function(s,e){{s.SelectIndex(-1);}}";
            }
        }

        /// <summary>
        /// 将 Enum 的值放入 dropdown
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="ddl"></param>
        /// <param name="valueAsInteger"></param>
        public static void FromEnum<T>(this ASPxComboBox cbx, 
            Nullable<T> defaultValue = null,
            Func<T, ListEditItem, bool> itemSet = null, bool valueAsInteger = false, bool canBeNull = false) where T : struct, IComparable, IConvertible, IFormattable
        {
            cbx.Items.Clear();
            DefinitionHelper.GenerateEnums<T>().ForEach(i =>
            {
                var item = new ListEditItem() { Text = i.Caption, Value = i.Name };
                var v = i.Value.ToIntOrNull().Value;
                if (valueAsInteger) item.Value = v;
                if (defaultValue.HasValue)
                {
                    if (valueAsInteger)
                    {
                        cbx.Value = (int)(defaultValue.Value as object);
                    }
                    else
                    {
                        cbx.Value = defaultValue.Value;
                    }
                }
                if (itemSet != null)
                {
                    if (itemSet((T)(v as object), item)) cbx.Items.Add(item);
                }
                else
                {
                    cbx.Items.Add(item);
                }
            });
            if (canBeNull)
            {
                if (cbx.Buttons.Count == 0)
                {
                    var b = cbx.Buttons.Add();
                    b.Index = 0;
                    b.Text = "X";
                    b.Width = 15;
                }
                if (string.IsNullOrEmpty(
                    cbx.ClientSideEvents.ButtonClick))
                    cbx.ClientSideEvents.ButtonClick = "function(s,e){{s.SelectIndex(-1);}}";
            }
        }

        #endregion

        #region Menu（Toolbar）

        public static ASPxMenu MenuItem(this ASPxMenu menu,
            string name, string text, string iconFile,
            Action<DevExpress.Web.MenuItem> itemSet = null, int index = -1)
        {
            DevExpress.Web.MenuItem item = new DevExpress.Web.MenuItem()
            {
                Name = name,
                Text = text
            };
            item.ItemStyle.BackgroundImage.ImageUrl = "~/images/" + iconFile;
            item.ItemStyle.BackgroundImage.Repeat = BackgroundImageRepeat.NoRepeat;
            item.ItemStyle.BackgroundImage.VerticalPosition = "center";
            item.ItemStyle.BackgroundImage.HorizontalPosition = "left";
            item.ItemStyle.CssClass = "item";
            item.ItemStyle.HoverStyle.CssClass = "itemHover";
            if (itemSet != null) itemSet(item);
            if (index >= 0) menu.Items.Insert(index, item);
            menu.Items.Add(item);
            return menu;
        }

        public static ASPxMenu MenuItem<T>(
            this ASPxMenu menu, T templateItem) where T : TemplateItem.BaseItem
        {
            DevExpress.Web.MenuItem item = new DevExpress.Web.MenuItem();
            item.Template = templateItem;
            menu.Items.Add(item);
            return menu;
        }

        /// <summary>
        /// 菜单客户端点击
        /// </summary>
        /// <param name="functionBody"></param>
        /// <returns></returns>
        public static ASPxMenu ItemClickJSFunc(this ASPxMenu menu, string functionDef)
        {
            menu.ClientSideEvents.ItemClick = functionDef;
            return menu;
        }

        #endregion

        /// <summary>
        /// 将列表变成树，并且绑定到树（先清空节点）
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="tv"></param>
        /// <param name="data"></param>
        /// <param name="keyGet"></param>
        /// <param name="parentKeyGet"></param>
        /// <param name="nodeSet"></param>
        /// <param name="dept"></param>
        /// <param name="destroyData"></param>
        public static void FromList<T>(this ASPxTreeView tv,
            List<T> data, Func<T, string> keyGet, Func<T, string> parentKeyGet,
            Action<TreeViewNode, T> nodeSet, string rootId = null, int dept = -1, bool destroyData = false,
            Func<List<T>, List<T>> orderBy = null)
        {
            tv.Nodes.Clear();
            if (data.Count == 0) return;
            List<T> lstCopy = data;
            if (!destroyData) lstCopy = data.ToList(); // 做多一个拷贝

            // 采用递归方式执行节点创建
            Action<List<T>, int, string, TreeViewNodeCollection> _do = (all, dpt, parentId, parentCollection) => { };
            _do = (all, dpt, parentId, parentCollection) =>
            {
                Func<T, bool> _where = t => parentKeyGet(t) == parentId;
                if (string.IsNullOrEmpty(parentId)) _where = t => string.IsNullOrEmpty(parentKeyGet(t));

                var children = all.Where(_where).ToList();
                if (orderBy != null) children = orderBy(children);
                children.ForEach(c => all.Remove(c));
                children.ForEach(c =>
                {
                    var node = new TreeViewNode() { Name = keyGet(c) };
                    nodeSet(node, c);
                    if (parentCollection != null) parentCollection.Add(node);
                    if (dpt < dept || dept == -1)
                        _do(all, (dpt == -1) ? dpt : dpt + 1, node.Name, node.Nodes);
                });
            };

            // 执行递归，并返回结果
            // 最高层的字段值为 null 或者 空字符串
            _do(lstCopy, 0, rootId, tv.Nodes);
            if (tv.Nodes.Count == 0) _do(lstCopy, 0, "-1", tv.Nodes); // 没获得树，则用 "-1" 试试
        }

        /// <summary>
        /// 执行页面的切换
        /// </summary>
        /// <param name="pageControl"></param>
        /// <param name="controls"></param>
        /// <param name="switchHandle"></param>
        public static void Switch<T>(
            this ASPxTabControlBase tabs, T[] controls,
            Action<int, T> switchHandle = null, Action<int, T> unloadHandle = null,
            int activeIndex = 0) where T : Control
        {
            // 加载中提示..
            tabs.ClientSideEvents.TabClick = "function(s,e){ISEx.loadingPanel.show();}";

            if (tabs is ASPxPageControl)
            {
                if (tabs.As<ASPxPageControl>().TabPages.Count != controls.Length)
                    throw new ArgumentException("Controls count not matched with tab count.", "controls");
            }

            if (tabs is ASPxTabControl)
            {
                if (tabs.As<ASPxTabControl>().Tabs.Count != controls.Length)
                    throw new ArgumentException("Controls count not matched with tab count.", "controls");
            }

            foreach (var c in controls) c.Visible = false;
            tabs.TabClick += (s, e) =>
            {
                for (int i = 0; i < controls.Length; i++)
                {
                    if (e.Tab.Index != i && unloadHandle != null) unloadHandle(i, controls[i]);
                    controls[i].Visible = false;
                }
                controls[e.Tab.Index].Visible = true;
                if (switchHandle != null) switchHandle(e.Tab.Index, controls[e.Tab.Index]);
            };

            if (activeIndex < 0 ||
                activeIndex >= controls.Length) return;
            tabs.ActiveTabIndex = activeIndex;
            controls[activeIndex].Visible = true;
        }

        /// <summary>
        /// 执行数据导航页面的切换
        /// </summary>
        public static void Switch(
            this ASPxNavBar bars, Control[] controls,
            Action<int, Control> switchHandle = null, Action<int, Control> unloadHandle = null,
            int activeIndex = 0)
        {
            // 加载中提示..
            bars.ClientSideEvents.ItemClick = "function(s,e){ISEx.loadingPanel.show();}";
            if (bars.Items.Count != controls.Length)
                throw new ArgumentException("Controls count not matched with bar count.", "controls");

            foreach (var c in controls)
            {
                c.If<BaseControl>(cc => cc.ViewStateEx.Clear());
                c.Visible = false;
            }
            bars.ItemClick += (s, e) =>
            {
                for (int i = 0; i < controls.Length; i++)
                {
                    if (e.Item.Index != i && unloadHandle != null) unloadHandle(i, controls[i]);
                    controls[i].Visible = false;
                }
                controls[e.Item.Index].Visible = true;
                if (switchHandle != null) switchHandle(e.Item.Index, controls[e.Item.Index]);
            };

            if (activeIndex < 0 ||
                activeIndex >= controls.Length) return;
            bars.SelectedItem = bars.Items[activeIndex];
            controls[activeIndex].Visible = true;
        }

    }

}
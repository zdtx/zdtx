using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.SessionState;

using DevExpress.Web;

using eTaxi.L2SQL;
using eTaxi.Web;
using eTaxi.Web.Controls;
namespace eTaxi
{
    public static partial class Extension
    {
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
        public static void FromList<T>(this TreeView tv, 
            List<T> data, Func<T, string> keyGet, Func<T, string> parentKeyGet, 
            Action<TreeNode, T> nodeSet, string rootId = null, int dept = -1, bool destroyData = false)
        {
            tv.Nodes.Clear();
            if (data.Count == 0) return;
            List<T> lstCopy = data;
            if (!destroyData) lstCopy = data.ToList(); // 做多一个拷贝

            // 采用递归方式执行节点创建
            Action<List<T>, int, string, TreeNodeCollection> _do = (all, dpt, parentId, parentCollection) => { };
            _do = (all, dpt, parentId, parentCollection) =>
            {
                Func<T, bool> _where = t => parentKeyGet(t) == parentId;
                if (string.IsNullOrEmpty(parentId)) _where = t => string.IsNullOrEmpty(parentKeyGet(t));
                List<T> children = all.Where(_where).ToList();
                children.ForEach(c => all.Remove(c));
                children.ForEach(c =>
                {
                    TreeNode node = new TreeNode() { Value = keyGet(c) };
                    nodeSet(node, c);
                    if (parentCollection != null) parentCollection.Add(node);
                    if (dpt < dept || dept == -1)
                        _do(all, (dpt == -1) ? dpt : dpt + 1, node.Value, node.ChildNodes);
                });
            };

            // 执行递归，并返回结果
            // 最高层的字段值为 null 或者 空字符串
            _do(lstCopy, 0, rootId, tv.Nodes);
            if (tv.Nodes.Count == 0) _do(lstCopy, 0, "-1", tv.Nodes); // 没获得树，则用 "-1" 试试
        }

        /// <summary>
        /// 将 Enum 的值放入 dropdown
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="ddl"></param>
        /// <param name="valueAsInteger"></param>
        public static void FromEnum<T>(this DropDownList ddl, Nullable<T> defaultValue = null,
            Func<T, ListItem, bool> itemSet = null, bool valueAsInteger = false) where T : struct, IComparable, IConvertible, IFormattable
        {
            ddl.Items.Clear();
            DefinitionHelper.GenerateEnums<T>().ForEach(i =>
            {
                var item = new ListItem() { Text = i.Caption, Value = i.Name };
                var v = i.Value.ToIntOrNull().Value;
                if (valueAsInteger) item.Value = v.ToString();
                item.Selected = (defaultValue.HasValue && defaultValue.Value.Equals(v));
                if (itemSet != null)
                {
                    if (itemSet((T)(v as object), item)) ddl.Items.Add(item);
                }
                else
                {
                    ddl.Items.Add(item);
                }
            });
        }

        /// <summary>
        /// 默认的进行控件和属性配对的算法
        /// </summary>
        public static Func<string, string, bool> DefaultNameMatchMethod = (propertyName, controlId) =>
        {
            if (string.IsNullOrEmpty(controlId)) return false;
            if (controlId.Length <= 3) return false;
            if (propertyName == controlId) return true;
            int position = controlId.IndexOf('_');
            if (position == controlId.Length - 1) return false;
            if (propertyName == controlId.Substring(position + 1)) return true;
            if (propertyName == controlId.Substring(3)) return true;
            return false;
        };

        /// <summary>
        /// 对一群控件组合进行值的展示
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="controls"></param>
        /// <param name="l2Object"></param>
        /// <param name="fill">
        /// data, name, value, control
        /// </param>
        /// <param name="nameMatch">
        /// propertyName, controlId
        /// </param>
        /// <param name="recursive"></param>
        public static void PresentedBy<T>(this ControlCollection controls,
            T l2Object, Action<T, string, Control> fill = null,
            Func<string, string, bool> nameMatch = null, bool recursive = true)
        {
            Func<string, string, bool> nm = nameMatch ?? DefaultNameMatchMethod;
            foreach (Control c in controls)
            {
                foreach (PropertyInfo p in typeof(T).GetProperties())
                {
                    // 配对成功则开始赋值
                    if (nm(p.Name, c.ID))
                    {
                        // 值和转户的字符处理
                        object v = p.GetValue(l2Object, null);
                        Util.SetControlValue(c, v);

                        // 个性化赋值
                        if (fill != null) fill(l2Object, p.Name, c);
                    }
                }

                // 递归扫描
                if (recursive) PresentedBy<T>(c.Controls, l2Object, fill, nameMatch, recursive);
            }
        }

        /// <summary>
        /// 遍历器
        /// </summary>
        /// <param name="controls"></param>
        /// <param name="found"></param>
        /// <param name="recursive"></param>
        public static void Visit(
            this ControlCollection controls, Action<Control> found = null, bool recursive = true)
        {
            foreach (Control c in controls)
            {
                if (found != null) found(c);
                if (recursive) Visit(c.Controls, found, recursive);
            }
        }

        /// <summary>
        /// 重置表单
        /// </summary>
        public static void Reset(
            this ControlCollection controls, Action<Control> afterSet = null, bool recursive = true)
        {
            Visit(controls, c =>
            {
                c.If<ASPxEditBase>(cc => cc.Value = null);
                c.If<TextBox>(cc => cc.Text = null);
                c.If<CheckBox>(cc => cc.Checked = false);
                c.If<RadioButton>(cc => cc.Checked = false);
                c.If<ListControl>(cc => cc.SelectedIndex = -1);
                if (afterSet != null) afterSet(c);

            }, recursive);
        }

        /// <summary>
        /// 红绿化前景色
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="control"></param>
        /// <param name="obj"></param>
        /// <param name="boolHandle"></param>
        public static void ColorizeNumber<T>(
            this WebControl control, T obj, Func<T, bool> changeHandle = null, Func<T, bool> unchangeHandle = null)
        {
            if (unchangeHandle != null && unchangeHandle(obj)) return;
            if (changeHandle == null) return;
            if (changeHandle(obj))
            {
                control.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                control.ForeColor = System.Drawing.Color.Red;
            }
        }

        public static T Red<T>(this T control)
            where T : WebControl { control.ForeColor = System.Drawing.Color.Red; return control; }
        public static T Green<T>(this T control)
            where T : WebControl { control.ForeColor = System.Drawing.Color.Green; return control; }

        #region GridView

        /// <summary>
        /// 对 Sorters 的提炼
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="sorters"></param>
        /// <param name="q"></param>
        /// <returns></returns>
        public static IQueryable<T> ApplySorts<T>(this List<eTaxi.Web.Controls.GridHeaderSorter> sorters, IQueryable<T> q)
        {
            List<KeyValuePair<string, bool>> sorts = new List<KeyValuePair<string, bool>>();
            for (int i = 0; i < sorters.Count; i++)
            {
                eTaxi.Web.Controls.GridHeaderSorter s = sorters[i];
                if (s.Sort.HasValue) sorts.Add(new KeyValuePair<string, bool>(s.FieldName, s.Sort.Value));
            }
            return Exp.AppendSorts<T>(q, sorts.ToArray());
        }

        #endregion

    }

}
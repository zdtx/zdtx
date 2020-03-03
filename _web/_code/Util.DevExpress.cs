using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Microsoft.Practices.Unity;

using DevExpress;
using DevExpress.Web;

using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 为 web 的处理提供方法集合
    /// </summary>
    public static partial class Util
    {
        /// <summary>
        /// 创建兼容 TreeViewNodeCollection 的对象（List作为参数）
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        /// <param name="keyGet"></param>
        /// <param name="parentKeyGet"></param>
        /// <param name="destroyData"></param>
        /// <returns></returns>
        public static TreeViewNodeCollection CreateTVNodeCollectionDX<T>(
            List<T> data, Func<T, string> keyGet, Func<T, string> parentKeyGet,
            Action<TreeViewNode, T> nodeSet, int dept = -1, bool destroyData = false)
        {
            TreeViewNodeCollection tc = new TreeViewNodeCollection();
            if (data.Count == 0) return tc;
            List<T> lstCopy = data;
            if (!destroyData) lstCopy = data.ToList(); // 做多一个拷贝

            // 采用递归方式执行节点创建
            Action<List<T>, int, string, TreeViewNodeCollection> _do = (all, dpt, parentId, parentCollection) => { };
            _do = (all, dpt, parentId, parentCollection) =>
            {
                Func<T, bool> _where = t => parentKeyGet(t) == parentId;
                if (string.IsNullOrEmpty(parentId)) _where = t => string.IsNullOrEmpty(parentKeyGet(t));
                List<T> children = all.Where(_where).ToList();
                children.ForEach(c => all.Remove(c));
                children.ForEach(c =>
                {
                    TreeViewNode node = new TreeViewNode() { Name = keyGet(c) };
                    nodeSet(node, c);
                    if (parentCollection != null) parentCollection.Add(node);
                    if (dpt < dept || dept == -1)
                        _do(all, (dpt == -1) ? dpt : dpt + 1, node.Name, node.Nodes);
                });
            };

            // 执行递归，并返回结果
            // 最高层的字段值为 null 或者 空字符串
            _do(lstCopy, 0, null, tc);
            if (tc.Count == 0) _do(lstCopy, 0, "-1", tc); // 没获得树，则用 "-1" 试试
            return tc;
        }

    }

}
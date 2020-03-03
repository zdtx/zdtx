using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Globalization;
using System.ComponentModel;
using LinqKit;

namespace eTaxi
{
    public static class TreeUtil
    {
        public static List<string> GetParentIds<T>(List<T> data, string nodeId,
            Func<T, string> keyGet, Func<T, string> parentKeyGet, bool includeCurrentNode = true) where T : class
        {
            Stack<string> ids = new Stack<string>();
            List<string> result = new List<string>();
            T node = data.SingleOrDefault(d => keyGet(d) == nodeId);
            if (node == null) return ids.ToList();
            if (includeCurrentNode) ids.Push(nodeId);
            while (node != null)
            {
                if (string.IsNullOrEmpty(parentKeyGet(node)))
                {
                    node = null;
                }
                else
                {
                    node = data.SingleOrDefault(d => keyGet(d) == parentKeyGet(node));
                    if (node != null)
                    {
                        if (ids.Contains(keyGet(node))) { node = null; break; }
                        ids.Push(keyGet(node));
                    }
                }
            }
            while (ids.Count > 0) result.Add(ids.Pop());
            return result;
        }
    }

    public static class TreeUtil<T> where T : class
    {
        /// <summary>
        /// 根据树节点的集合，进行完整路径的获取
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="parentKeyGet"></param>
        /// <returns></returns>
        public static List<string> GetParentIds(List<T> data, string nodeId,
            Func<T, string> keyGet, Func<T, string> parentKeyGet, bool includeCurrentNode = true)
        {
            Stack<string> ids = new Stack<string>();
            List<string> result = new List<string>();
            T node = data.SingleOrDefault(d => keyGet(d) == nodeId);
            if (node == null) return ids.ToList();
            if (includeCurrentNode) ids.Push(nodeId);
            while (node != null)
            {
                if (string.IsNullOrEmpty(parentKeyGet(node)))
                {
                    node = null;
                }
                else
                {
                    node = data.SingleOrDefault(d => keyGet(d) == parentKeyGet(node));
                    if (node != null)
                    {
                        if (ids.Contains(keyGet(node))) { node = null; break; }
                        ids.Push(keyGet(node));
                    }
                }
            }
            while (ids.Count > 0) result.Add(ids.Pop());
            return result;
        }

        public static List<T> SubTree(List<T> data, string rootId,
            Func<T, string> keyGet, Func<T, string> parentKeyGet)
        {
            return SubTree<T>(data, rootId, keyGet, parentKeyGet, i => i);
        }
        public static List<T> SubTree<TSource>(List<TSource> data, string rootId,
            Func<TSource, string> keyGet, Func<TSource, string> parentKeyGet, Func<TSource, T> itemGet)
        {
            List<T> result = new List<T>();
            var root = data.SingleOrDefault(d => keyGet(d) == rootId);
            if (root != null) result.Add(itemGet(root));

            // 采用递归方式执行节点创建
            Action<List<TSource>, string> _do = (all, parentId) => { };
            _do = (all, parentId) =>
            {
                Func<TSource, bool> _where = t => parentKeyGet(t) == parentId;
                if (string.IsNullOrEmpty(parentId)) _where = t => string.IsNullOrEmpty(parentKeyGet(t));
                List<TSource> children = all.Where(_where).ToList();
                children.ForEach(c => all.Remove(c));
                children.ForEach(c => { result.Add(itemGet(c)); _do(all, keyGet(c)); });
            };
            _do(data.ToList(), rootId);
            return result;
        }

        public static List<T> Visit<TSource>(List<TSource> data, string rootId,
            Func<TSource, string> keyGet, Func<TSource, string> parentKeyGet, 
            Func<TSource, T> itemGet, Func<List<TSource>, List<TSource>> transform = null)
        {
            List<T> result = new List<T>();

            // 采用递归方式执行节点创建
            Action<List<TSource>, string> _do = (all, parentId) => { };
            _do = (all, parentId) =>
            {
                var parent = data.SingleOrDefault(d => keyGet(d) == parentId);
                if (parent != null) result.Add(itemGet(parent));
                Func<TSource, bool> _where = t => parentKeyGet(t) == parentId;
                if (string.IsNullOrEmpty(parentId)) _where = t => string.IsNullOrEmpty(parentKeyGet(t));
                List<TSource> children = all.Where(_where).ToList();
                children.ForEach(c => all.Remove(c));
                if (transform != null) children = transform(children);
                children.ForEach(c => { _do(all, keyGet(c)); });
            };
            _do(data.ToList(), rootId);
            return result;
        }

    }
}
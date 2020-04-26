using Microsoft.Reporting.WebForms;

using System.Collections;
using System.Collections.Generic;

namespace eTaxi
{
    /// <summary>
    /// 为报表定义一个基础定义类
    /// </summary>
    public abstract class ReportGen
    {
        /// <summary>
        /// 报表文件路径
        /// </summary>
        public abstract string ReportPath { get; }
        /// <summary>
        /// 对象缓存
        /// </summary>
        protected TypedHashtable _Lists = new TypedHashtable();
        public List<T> Object<T>() { return _Lists.Get<List<T>>(key: typeof(T).Name); }
        public List<T> Replace<T>(List<T> list) { _Lists.Add(typeof(T).Name, list); return list; }
        /// <summary>
        /// 参数存储
        /// </summary>
        protected List<ReportParameter> _Parameters = new List<ReportParameter>();
        public ReportParameter CreateParameter<T>(string name, params T[] values)
        {
            ReportParameter param = new ReportParameter(name);
            for (int i = 0; i < values.Length; i++) param.Values.Add(values[i].ToStringEx());
            return param;
        }
        public void ReplaceParameters(params ReportParameter[] parameters)
        {
            _Parameters.Clear();
            _Parameters.AddRange(parameters);
        }

        /// <summary>
        /// 渲染数据源（默认做单值）
        /// </summary>
        protected virtual void _ResolveDataSources(ReportViewer rv)
        {
            foreach (DictionaryEntry de in _Lists)
                rv.LocalReport.DataSources
                    .Add(new ReportDataSource(de.Key.ToString(), de.Value));
        }

        /// <summary>
        /// 渲染参数
        /// </summary>
        protected virtual void _ResolveParameters(ReportViewer rv) { rv.LocalReport.SetParameters(_Parameters); }

        /// <summary>
        /// 执行总体渲染
        /// </summary>
        /// <param name="rv"></param>
        public void Go(ReportViewer rv)
        {
            // 报表参数
            rv.LocalReport.ReportPath = rv.Page.Server.MapPath(ReportPath);

            // 数据源
            rv.LocalReport.DataSources.Clear();
            _ResolveDataSources(rv);

            // 参数
            _ResolveParameters(rv);

            rv.ProcessingMode = ProcessingMode.Local;
            rv.LocalReport.Refresh();


        }

    }
}
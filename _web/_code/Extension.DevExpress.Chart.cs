using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

using LinqKit;

using DevExpress;
using DevExpress.Web;
using DevExpress.XtraCharts;
using DevExpress.XtraCharts.Web;

using eTaxi.Web;
namespace eTaxi
{
    public static partial class Extension
    {
        /// <summary>
        /// 执行报表的数据加载
        /// </summary>
        /// <param name="chart"></param>
        public static void Execute(this WebChartControl chart,
            Action<DXChartControlWrapper> populate, Action<Exception> exHandle = null)
        {
            try
            {
                chart.Series.Clear();
                chart.Titles.Clear();
                chart.EmptyChartText.Text = "（无可视数据）";
                populate(new DXChartControlWrapper(chart));
            }
            catch (Exception ex)
            {
                if (exHandle != null) exHandle(ex);
                chart.Visible = false;
            }
        }
    }
    
    namespace Web
    {
        /// <summary>
        /// 对图形报表的配置对象（采用包裹模式）
        /// </summary>
        public class DXChartControlWrapper
        {
            private int _Index = -1;
            private WebChartControl _Control = null;
            public WebChartControl Control { get { return _Control; } }
            public DXChartControlWrapper(WebChartControl c) { _Control = c; }

            /// <summary>
            /// 配置控件
            /// </summary>
            /// <param name="set"></param>
            /// <returns></returns>
            public DXChartControlWrapper Config(Action<WebChartControl> set)
            {
                set(_Control);
                return this;
            }

            /// <summary>
            /// 清除当前
            /// </summary>
            /// <returns></returns>
            public DXChartControlWrapper Clear()
            {
                _Control.Series.Clear();
                _Control.Titles.Clear();
                return this;
            }

            /// <summary>
            /// 加入数据
            /// </summary>
            /// <param name="add"></param>
            /// <returns></returns>
            public DXChartControlWrapper Data(ViewType type, Action<DXSeriesCreator> add = null)
            {
                _Index++;
                Series s = new Series("d" + _Index.ToString(), type);
                _Control.Series.Add(s);
                add(new DXSeriesCreator(s, _Control));
                return this;
            }

            /// <summary>
            /// 克隆一个当前的系列
            /// </summary>
            /// <param name="index"></param>
            /// <returns></returns>
            public DXChartControlWrapper DataClone(ViewType type, int index, Action<DXSeriesCreator> add = null)
            {
                if (index > _Index || index < 0)
                    throw new ArgumentOutOfRangeException("index");
                _Index++;
                Series s = new Series("d" + _Index.ToString(), type);
                _Control.Series.Add(s);
                foreach (SeriesPoint p in _Control.Series[index].Points) s.Points.Add(p.Clone() as SeriesPoint);
                add(new DXSeriesCreator(s, _Control));
                return this;
            }

            /// <summary>
            /// 获得系列的默认视图
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="set"></param>
            /// <param name="exceptionIfTypeMismatched"></param>
            /// <returns></returns>
            public DXChartControlWrapper FirstView<T>(
                Action<T> set, bool exceptionIfTypeMismatched = true) where T : Diagram
            {
                if (_Control.Series.Count == 0)
                    throw new Exception("请先调用 Data() 添加 Series，再配置 FirstView");
                if (exceptionIfTypeMismatched && !(_Control.Series[0].View is T))
                    throw new ArgumentException("T 只能是： " + _Control.Series[0].View.GetType().Name);
                _Control.Series[0].View.If<T>(set);
                return this;
            }

            /// <summary>
            /// 配置 Diagram
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="set"></param>
            /// <returns></returns>
            public DXChartControlWrapper Diagram<T>(
                Action<T> set, bool exceptionIfTypeMismatched = true) where T : Diagram
            {
                if (_Control.Diagram == null)
                    throw new Exception("请先调用 Data() 添加 Series，再配置 Diagram");
                if (exceptionIfTypeMismatched && !(_Control.Diagram is T))
                    throw new ArgumentException("T 只能是： " + _Control.Diagram.GetType().Name);
                _Control.Diagram.If<T>(set);
                return this;
            }

        }

        /// <summary>
        /// Series 添加对象
        /// </summary>
        public class DXSeriesCreator
        {
            private WebChartControl _Control = null;
            private Series _Series = null;
            public Series Series { get { return _Series; } }
            public DXSeriesCreator(Series s, WebChartControl c) { _Series = s; _Control = c; }

            /// <summary>
            /// 加一个点
            /// </summary>
            /// <param name="point"></param>
            /// <returns></returns>
            public DXSeriesCreator Add(SeriesPoint point)
            {
                _Series.Points.Add(point);
                return this;
            }

            /// <summary>
            /// 加多个点
            /// </summary>
            /// <param name="points"></param>
            /// <returns></returns>
            public DXSeriesCreator Add(SeriesPoint[] points)
            {
                _Series.Points.AddRange(points);
                return this;
            }

            /// <summary>
            /// 加系列点
            /// </summary>
            public DXSeriesCreator Add<T>(IEnumerable<T> data, Func<T, SeriesPoint> createPoint)
            {
                data.ForEach(d => _Series.Points.Add(createPoint(d)));
                return this;
            }

            /// <summary>
            /// 加系列点（带序号）
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="data"></param>
            /// <param name="createPoint">带参数，指示当前 item 的序号</param>
            /// <returns></returns>
            public DXSeriesCreator AddByOrder<T>(IEnumerable<T> data, Func<int, T, SeriesPoint> createPoint)
            {
                var index = -1;
                data.ForEach(d =>
                {
                    index++;
                    _Series.Points.Add(createPoint(index, d));
                });
                return this;
            }

            /// <summary>
            /// 配置视图
            /// </summary>
            public DXSeriesCreator View<T>(
                Action<T> config, bool exceptionIfTypeMismatched = true) where T : SeriesViewBase
            {
                if (exceptionIfTypeMismatched && !(_Series.View is T))
                    throw new ArgumentException("T 只能是： " + _Series.View.GetType().Name);
                _Series.View.If<T>(config);
                return this;
            }

            /// <summary>
            /// 配置标签
            /// </summary>
            public DXSeriesCreator Label<T>(
                Action<T> config, bool exceptionIfTypeMismatched = true) where T : SeriesLabelBase
            {
                if (exceptionIfTypeMismatched && !(_Series.Label is T))
                    throw new ArgumentException("T 只能是： " + _Series.Label.GetType().Name);
                _Series.Label.If<T>(config);
                return this;
            }

            /// <summary>
            /// 设置视图（带有 Diagram 参数）
            /// </summary>
            public DXSeriesCreator Config<TView, TLabel, TDiagram>(
                Action<Series, TView, TLabel, TDiagram> config, bool exceptionIfTypeMismatched = true)
                where TView : SeriesViewBase
                where TLabel : SeriesLabelBase
                where TDiagram : Diagram
            {
                if (_Control.Diagram == null)
                    throw new Exception("请先调用 Add() 添加 Series，再配置 Diagram");
                if (exceptionIfTypeMismatched && !(_Series.View is TView))
                    throw new ArgumentException("TView 只能是： " + _Series.View.GetType().Name);
                if (exceptionIfTypeMismatched && !(_Series.Label is TLabel))
                    throw new ArgumentException("TLabel 只能是： " + _Series.Label.GetType().Name);
                if (exceptionIfTypeMismatched && !(_Control.Diagram is TDiagram))
                    throw new ArgumentException("TDiagram 只能是： " + _Control.Diagram.GetType().Name);
                _Series.View.If<TView>(v =>
                    _Series.Label.If<TLabel>(l =>
                        _Control.Diagram.If<TDiagram>(d => config(_Series, v, l, d))));
                return this;
            }

        }

    }
}


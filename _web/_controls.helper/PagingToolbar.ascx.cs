using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace eTaxi.Web.Controls
{
    public partial class PagingToolbar : BaseControl
    {
        /// <summary>
        /// 待 ViewState 存储的项目
        /// </summary>
        public class States
        {
            /// <summary>
            /// 是否支持分页
            /// </summary>
            public const string Enabled = "enabled";
            /// <summary>
            /// 规格（一个页面的大小）
            /// </summary>
            public const string Size = "size";
            /// <summary>
            /// 当前页
            /// </summary>
            public const string Index = "index";
            /// <summary>
            /// 所有的记录数
            /// </summary>
            public const string Total = "total";
            /// <summary>
            /// 起始页（0 based）
            /// </summary>
            public const string Start = "start";
            /// <summary>
            /// 结束页
            /// </summary>
            public const string End = "";
        }

        /// <summary>
        /// 仅仅需要一个事件触发
        /// </summary>
        public event Action<object, EventArgs> Reload = null;

        /// <summary>
        /// 配置项
        /// </summary>
        public class ConfigOptions
        {
            public const int PageCount = 10;
        }

        public bool Enabled
        {
            get { return _ViewStateEx.Get<bool>(States.Enabled, true); }
            set { _ViewStateEx.Set<bool>(value, States.Enabled); }
        }

        public Nullable<int> Size
        {
            get { return _ViewStateEx.Get<Nullable<int>>(States.Size); }
            set { _ViewStateEx.Set<Nullable<int>>(value, States.Size); }
        }

        public int Index
        {
            get { return _ViewStateEx.Get<int>(States.Index, 0); }
            set { _ViewStateEx.Set<int>(value, States.Index); }
        }

        public int Total
        {
            get { return _ViewStateEx.Get<int>(States.Total); }
            set { _ViewStateEx.Set<int>(value, States.Total); }
        }

        public int Start
        {
            get { return _ViewStateEx.Get<int>(States.Start, 0); }
            set { _ViewStateEx.Set<int>(value, States.Start); }
        }

        public int Skip
        {
            get
            {
                if (Size.HasValue) return Size.Value * Index;
                return 0;
            }
        }

        public int Count
        {
            get
            {
                if (Size.HasValue)
                {
                    int count = Total / Size.Value;
                    int remain = Total % Size.Value;
                    if (remain > 0) count++;
                    return count;
                }
                return 0;
            }
        }

        public int End
        {
            get { return _ViewStateEx.Get<int>(States.End, ConfigOptions.PageCount); }
            set { _ViewStateEx.Set<int>(value, States.End); }
        }

        /// <summary>
        /// 0：20 1：50 ...
        /// </summary>
        /// <param name="index"></param>
        public void SetDefaultPageSizeIndex(int index)
        {
            ddl.SelectedIndex = index;
            Size = ddl.Value.ToStringEx().ToIntOrNull();
        }

        protected override void _SetInitialStates()
        {
            ddl.SelectedIndexChanged += (s, e) =>
            {
                if (Size.HasValue &&
                    Size.Value == ddl.Value.ToStringEx().ToIntOrDefault()) return;
                Size = ddl.Value.ToStringEx().ToIntOrNull();
                Index = 0;
                Execute();
                if (Reload != null) Reload(this, new EventArgs());
            };

            f.Click += (s, e) =>
            {
                Index = 0;
                Execute();
                if (Reload != null) Reload(this, new EventArgs());
            };

            p.Click += (s, e) =>
            {
                if (Index > 0)
                {
                    Index--;
                    Execute();
                    if (Reload != null) Reload(this, new EventArgs());
                }
            };

            n.Click += (s, e) =>
            {
                if (Index < Count - 1)
                {
                    Index++;
                    Execute();
                    if (Reload != null) Reload(this, new EventArgs());
                }
            };

            l.Click += (s, e) =>
            {
                if (Index < Count - 1)
                {
                    Index = Count - 1;
                    Execute();
                    if (Reload != null) Reload(this, new EventArgs());
                }
            };

            b.Click += (s, e) =>
            {
                Index = tb.Text.ToIntOrDefault(1) - 1;
                if (Index > 0) Index--;
                Execute();
                if (Reload != null) Reload(this, new EventArgs());
            };
        }

        protected override void _Execute()
        {
            int count = Count;
            if (Index == Start - 1)
            {
                Start = Start - ConfigOptions.PageCount;
                if (Start < 0) Start = 0;
                End = Start + ConfigOptions.PageCount;
            }
            else if (Index == End)
            {
                Start = Start + ConfigOptions.PageCount;
                End = Start + ConfigOptions.PageCount;
                if (End > count) End = count;
            }
            else
            {
                Start = (Index / ConfigOptions.PageCount) * ConfigOptions.PageCount;
                End = Start + ConfigOptions.PageCount;
                if (End > count) End = count;
            }

            // 生成页面数组
            List<int> lst = new List<int>();
            if (Start > 0) lst.Add(Start - 1);
            for (int i = Start; i < End; i++) lst.Add(i);
            if (End < count) lst.Add(End);

            tb.Text = (Index + 1).ToString();
            f.Enabled = Index > 0;
            p.Enabled = Index > 0;
            n.Enabled = ((Index + 1) * Size ?? 0) < Total;
            l.Enabled = ((Index + 1) * Size ?? 0) < Total;
            tdTB.Visible = Size.HasValue;
        }
    }
}

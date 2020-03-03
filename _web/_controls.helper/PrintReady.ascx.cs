using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Linq.Expressions;
using LinqKit;

using DevExpress.Web;

using D = eTaxi.Definitions;
using E = eTaxi.Exceptions;
using eTaxi.L2SQL;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 通用审核界面
    /// </summary>
    public partial class PrintReady : BaseControl
    {
        public string Url
        {
            get { return hl_Url.Text; }
            set
            {
                hl_Url.Text = value;
                hl_Url.NavigateUrl = value;
            }
        }

        public int PrintCount
        {
            get { return lb_PrintCount.Text.ToIntOrDefault(); }
            set { lb_PrintCount.Text = value.ToString(); }
        }

    }
}
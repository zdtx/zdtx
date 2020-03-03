using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress.Web;
using eTaxi.L2SQL;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 由于 DevExpress 的特殊性
    /// 需要 Session 配合上传控件执行值的回传
    /// </summary>
    public partial class NTKO_DX : BaseControl
    {
        protected override void _Execute()
        {
            p.Panes["C"].Panes["CC"].ContentUrl = "~/shared/ntkoobject.aspx?control=" + ClientID;
        }

    }

}
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
    /// 提示消息的通用控件
    /// </summary>
    public partial class MessagePanel : BaseControl
    {
        public virtual PlaceHolder MessageBody { get { return null; } }
        public virtual string MessageText { get; set; }
        public virtual string Title { get; set; }
        public virtual string Remark { get; set; }

    }
}
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.SessionState;
using System.Web.Security;
using System.Resources;
using System.Threading;
using System.Globalization;
using Microsoft.Practices.Unity;

using Ext.Net;
using eTaxi.L2SQL;

using WebUI = System.Web.UI.WebControls;
using P = eTaxi.Parameters;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    /// <summary>
    /// 为适用在门户控件的控件设定基类
    /// </summary>
    public class BasePortlet : BaseControl
    {
        /// <summary>
        /// 门户放置的地点
        /// </summary>
        public enum Area
        {
            Left, Center1, Center2
        }
        
        /// <summary>
        /// 控件展示的次序（越大越靠后）
        /// </summary>
        public virtual string Ordinal { get { return string.Empty; } }

        /// <summary>
        /// 控件放置地点
        /// </summary>
        public virtual Area TargetArea { get { return Area.Center1; } }
    }
}
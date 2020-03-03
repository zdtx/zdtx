using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

using Ext.Net;
namespace eTaxi.Web
{
    /// <summary>
    /// 修饰模式应对 各种页面应用
    /// </summary>
    public abstract class PageDecorator
    {
        protected Page _Page = null;
        public PageDecorator(Page page) { _Page = page; }

        /// <summary>
        /// 进行所有配置完成后，执行页面的最终配置（应该放入 Init 事件）
        /// </summary>
        public virtual void Go() { }
    }

}
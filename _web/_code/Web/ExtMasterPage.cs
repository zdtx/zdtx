using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

using LinqKit;
using Ext.Net;

namespace eTaxi.Web
{
    public abstract class ExtMasterPage : System.Web.UI.MasterPage
    {
        public abstract HtmlForm Form { get; }
        public abstract ResourceManager ExtManager { get; }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (string.IsNullOrEmpty(Page.Theme)) return;

            var styles = new HtmlLink[]
            {
                new HtmlLink(){ Href = string.Format("../content/themes/{0}/frame.css", Page.Theme)}
            };

            styles.ForEach(s =>
            {
                s.Attributes.Add("rel", "stylesheet");
                s.Attributes.Add("type", "text/css");
                Page.Header.Controls.AddAt(1, s);
            });

        }

    }

}
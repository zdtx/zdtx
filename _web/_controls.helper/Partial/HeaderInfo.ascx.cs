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

using DevExpress.Web;

namespace eTaxi.Web.Controls
{
    public partial class HeaderInfo : BaseControl
    {
        public virtual HeaderInfo Back(string name, string url) { return this; }
        public virtual HeaderInfo Title(params string[] parts) { return this; }
    }

}

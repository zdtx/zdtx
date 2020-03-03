using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using Microsoft.Practices.Unity;

using eTaxi.L2SQL;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    public partial class Global : System.Web.HttpApplication
    {
        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender,
            EventArgs e)
        {
            Global.Sessions.Unregister(Session.SessionID);
        }
    }
}
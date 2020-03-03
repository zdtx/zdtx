using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Linq;
using System.Data.Linq.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress.Web;
using LinqKit;

using eTaxi.L2SQL;
namespace eTaxi.Web.Controls.Selection.Car
{
    public partial class Item : BaseControl
    {
        public virtual List<TB_car> Selection { get { return new List<TB_car>(); } }
    }
}
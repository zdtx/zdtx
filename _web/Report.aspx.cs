using System;
using System.Collections.Generic;

namespace eTaxi
{
    public partial class WebForm1 : eTaxi.Web.BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            rv.LocalReport.DataSources.Clear();

            var data = new List<eTaxi.Reports.Driver.RPT_MonthlyStatement.DC1>();

            for (var i = 0; i < 100; i++)
            {
                data.Add(new Reports.Driver.RPT_MonthlyStatement.DC1 { Name = "item " + i.ToString() });
            }

            rv.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DC1", data));

            rv.LocalReport.ReportPath = Server.MapPath("~") + "/____reports/Driver/MonthlyStatement.rdlc";

            rv.LocalReport.Refresh();

        }
    }
}
<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Import Namespace="eTaxi.Reports.Driver" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
<div style="padding: 10px;">
    <div class="actionTB" style="padding-top:2px;">
        <table>
            <tr>
                <td>
                    月份（年月）：
                </td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbMonthIndex" Width="100" AutoPostBack="true" />
                </td>
            </tr>
        </table>
    </div>
    <div style="padding:30px;">
        <asp:LinkButton runat="server" Font-Size="Medium" ID="lb_Report" Text="打印应收款月报表" CssClass="aBtn" OnClientClick="ISEx.loadingPanel.show();" />
    </div>
</div>
<script runat="server">

    private const string CMD_Report_1 = "report1";

    private string _ObjectId
    {
        get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); }
        set { _ViewStateEx.Set<string>(value, DataStates.ObjectId); }
    }

    public override string ModuleId { get { return Finance.Account_Report ; } }
    protected override void _SetInitialStates()
    {
        // 月份
        var monthIds = new List<string>();
        var todate = DateTime.Now.Date;

        for (var i = 0; i< 10; i++)
        {
            if (i == 0)
            {
                monthIds.AddRange(todate.ToMonthIds());
                continue;
            }

            monthIds.AddRange(todate.AddYears(i).ToMonthIds());
            monthIds.AddRange(todate.AddYears(-1 * i).ToMonthIds());
        }

        cbMonthIndex.FromList(monthIds, (dd, i) => { i.Text = dd; i.Value = dd; return true; });
        cbMonthIndex.SelectedIndexChanged += (s, e) => _Execute(VisualSections.List);

        lb_Report.Click += (s, e) =>
        {
            Execute(CMD_Report_1);
        };

    }

    protected override void _Execute()
    {
        cbMonthIndex.Value = DateTime.Now.ToMonthId();
    }

    protected override void _Execute(string section)
    {
        if (section == CMD_Report_1)
        {
            var context = _DTService.Context;
            _ObjectId = cbMonthIndex.Value.ToStringEx();

            Alert("Report 1");





        }
    }

</script>

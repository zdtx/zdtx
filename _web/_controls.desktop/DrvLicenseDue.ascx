<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePortlet" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<table style="width: 100%;" class="dsTb">
    <tr>
        <th colspan="3">
            <span class="text">行驶证到期提醒（一个月内）</span>
        </th>
        <th style="text-align:right;">
            <span class="text">还有多少天过期</span>
        </th>
    </tr>
    <tr>
        <td colspan="4" style="padding: 0px;">
            <asp:Panel runat="server" Visible="false" ID="pNone" style="padding:10px;">
                （无）
            </asp:Panel>
            <asp:Panel runat="server" Visible="false" ID="pTips" CssClass="tips" Style="padding: 2px; padding-left: 5px; margin: 1px;">
                列出前 <%= ROW_COUNT.ToString() %> 个
            </asp:Panel>
        </td>
    </tr>
    <asp:Repeater runat="server" ID="r">
        <ItemTemplate>
            <tr class="row">
                <td style="width: 50px;">
                    <asp:Literal runat="server" ID="PlateNumber" />
                </td>
                <td class="noWrap">
                    <asp:Literal runat="server" ID="DrvLicense" />
                </td>
                <td class="num">到期：<asp:Label runat="server" ID="DrvLicenseRenewTime" ForeColor="Green" />
                </td>
                <td class="num">
                    <asp:Label runat="server" ID="Days" />
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
    <tr>
        <td colspan="4" style="text-align: right; padding: 5px;">
            <asp:LinkButton runat="server" ID="lMore" Text="进行处理.." CssClass="aBtn" />
        </td>
    </tr>
</table>
<script runat="server">

    private const int ROW_COUNT = 10;
    private RepeaterWrapper _Wp = null;
    public override string ModuleId { get { return Desktop.RentalPaymentDue; } }
    public override bool AccessControlled { get { return false; } }
    public override BasePortlet.Area TargetArea { get { return Area.Center1; } }
    public override string Ordinal { get { return "003"; } }
    protected override void _SetInitialStates()
    {
        _Wp = new RepeaterWrapper(r);
        lMore.Click += (s, e) =>
        {
            Response.Redirect("~/domain/business/inspection.aspx", true);
        };
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var data = (
            from c in context.Cars
            where
                c.DrvLicense != null && c.DrvLicense != string.Empty &&
                c.DrvLicenseRenewTime <= _CurrentTime.AddMonths(1)
            orderby c.DrvLicenseRenewTime
            select new
            {
                c.PlateNumber,
                c.DrvLicense,
                c.DrvLicenseRenewTime
            }).Take(ROW_COUNT).ToList();

        pTips.Visible = data.Count > 0;
        pNone.Visible = !pTips.Visible;

        _Wp.Execute(data, b => b
            .Do<Literal>("PlateNumber", (l, d, i) => l.Text = d.PlateNumber)
            .Do<Literal>("DrvLicense", (l, d, i) => l.Text = d.DrvLicense)
            .Do<Label>("Days", (l, d, i) =>
                {
                    var gap = d.DrvLicenseRenewTime.Subtract(_CurrentTime);
                    l.Text = gap.TotalDays.ToCHNRounded(0).ToStringOrEmpty(true, true);
                    if (gap.TotalDays < 0)
                    {
                        l.Text = "（已过期）";
                        l.ForeColor = System.Drawing.Color.Red;
                    }
                })
            .Do<Label>("DrvLicenseRenewTime", (l, d, i) =>
            {
                l.Text = d.DrvLicenseRenewTime.ToISDate();
                if (d.DrvLicenseRenewTime <= _CurrentTime.Date) l.ForeColor = System.Drawing.Color.Red;
            }), true);
    }

</script>

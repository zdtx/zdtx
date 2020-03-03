<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePortlet" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<table style="width: 100%;" class="dsTb">
    <tr>
        <th colspan="4">
            <span class="text">欠费情况汇总</span>
        </th>
    </tr>
    <tr>
        <td colspan="4" style="padding:0px;">
            <asp:Panel runat="server" Visible="false" ID="pNone" style="padding:10px;">
                （无）
            </asp:Panel>
            <asp:Panel runat="server" Visible="false" ID="pTips" CssClass="tips" style="padding:2px;padding-left:5px;margin:1px;">
                列出前 <%= ROW_COUNT.ToString() %> 个
            </asp:Panel>
        </td>
    </tr>
    <asp:Repeater runat="server" ID="r1">
        <ItemTemplate>
            <tr class="row">
                <td style="width:50px;">
                    <asp:Literal runat="server" ID="PlateNumber" />
                </td>
                <td class="noWrap">
                    <asp:Literal runat="server" ID="Name" />
                </td>
                <td class="num">
                    到期：<asp:Label runat="server" ID="Due" ForeColor="Green" />
                </td>
                <td class="num">
                    <asp:Label runat="server" ID="Amount" ForeColor="Red" />
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
    <asp:Repeater runat="server" ID="r2">
        <HeaderTemplate>
            <tr>
                <td colspan="4">
                    <b>部门汇总</b>
                </td>
            </tr>
        </HeaderTemplate>
        <ItemTemplate>
            <tr class="row">
                <td colspan="3">
                    <asp:Literal runat="server" ID="Name" />
                </td>
                <td class="num">
                    <asp:Label runat="server" ID="Amount" ForeColor="Red" />
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
    <tr runat="server" class="row" id="tr">
        <td colspan="3" style="text-align:right">
            <b>累计未缴纳欠款：</b>
        </td>
        <td class="num">
            - <asp:Label runat="server" ID="lSum" ForeColor="Red" />
        </td>
    </tr>
    <tr>
        <td colspan="4" style="text-align:right;padding:5px;">
            <asp:LinkButton runat="server" ID="lMore" Text="进行处理.." CssClass="aBtn" />
        </td>
    </tr>
</table>
<script runat="server">

    private const int ROW_COUNT = 10;
    private RepeaterWrapper _Wp1 = null;
    private RepeaterWrapper _Wp2 = null;
    public override string ModuleId { get { return Desktop.RentalPaymentDue; } }
    public override bool AccessControlled { get { return false; } }
    public override BasePortlet.Area TargetArea { get { return Area.Center1; } }
    public override string Ordinal { get { return "001"; } }
    protected override void _SetInitialStates()
    {
        _Wp1 = new RepeaterWrapper(r1);
        _Wp2 = new RepeaterWrapper(r2);
        lMore.Click += (s, e) =>
        {
            Response.Redirect("~/domain/business/payment.aspx", true);
        };
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var data = (
            from p in context.CarPayments
            join c in context.Cars on p.CarId equals c.Id
            join d in context.Drivers on p.DriverId equals d.Id
            where p.Paid < p.Amount && p.Due < _CurrentTime
            orderby p.Due
            select new
            {
                c.PlateNumber,
                d.Name,
                Amount = p.Amount - p.Paid,
                p.Due
            }).Take(ROW_COUNT).ToList();

        pTips.Visible = data.Count > 0;
        pNone.Visible = !pTips.Visible;

        _Wp1.Execute(data, b => b
            .Do<Literal>("PlateNumber", (l, d, i) => l.Text = d.PlateNumber)
            .Do<Literal>("Name", (l, d, i) => l.Text = d.Name)
            .Do<Label>("Amount", (l, d, i) =>
            {
                l.Text = " - " + d.Amount.ToStringOrEmpty(comma: true);
                l.ForeColor = System.Drawing.Color.Red;
            })
            .Do<Label>("Due", (l, d, i) => l.Text = d.Due.ToISDate()), true);

        var sum = (
            from p in context.CarPayments
            join c in context.Cars on p.CarId equals c.Id
            join d in context.Departments on c.DepartmentId equals d.Id
            where p.Paid < p.Amount && p.Due < _CurrentTime
            group p by new { d.Id, d.Name } into g
            select new
            {
                g.Key.Id,
                g.Key.Name,
                Amount = g.Sum(gg => (gg.Amount - gg.Paid))
            }).ToList();

        _Wp2.Execute(sum, b => b
            .Do<Literal>("Name", (l, d, i) => l.Text = d.Name)
            .Do<Label>("Amount", (l, d, i) =>
            {
                l.Text = " - " + d.Amount.ToStringOrEmpty(comma: true);
            }), true);

        tr.Visible = sum.Count > 0;
        lSum.Text = sum.Sum(s => s.Amount).ToCHNRounded().ToStringOrEmpty(comma: true);
    }

</script>

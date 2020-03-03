<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePortlet" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<asp:Repeater runat="server" ID="r">
    <HeaderTemplate>
        <tr>
            <td colspan="2" style="padding:0px;">
                <div class="info" style="padding:5px;margin:1px">
                    投诉通报
                    <asp:LinkButton runat="server" ID="lMore" Text="查看更多.." CssClass="aBtn" />
                </div>
            </td>
        </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr class="row">
            <td></td>
            <td>
                <asp:Label runat="server" ID="PlateNumber" ForeColor="Blue" />
                <asp:Label runat="server" ID="Time" Font-Italic="true" />
                <asp:Label runat="server" ID="Driver" ForeColor="Green" />
                - 发生
                <asp:Label runat="server" ID="Type" />
                投诉
                [来自：<asp:Label runat="server" ID="Source" />]
                <i>“<asp:Literal runat="server" ID="Message" />”</i>
            </td>
        </tr>
    </ItemTemplate>
</asp:Repeater>
<script runat="server">

    private const int ROW_COUNT = 5;
    private RepeaterWrapper _Wp = null;
    public override string ModuleId { get { return Desktop.RentalPaymentDue; } }
    public override bool AccessControlled { get { return false; } }
    public override BasePortlet.Area TargetArea { get { return Area.Center2; } }
    public override string Ordinal { get { return "001"; } }
    protected override void _SetInitialStates()
    {
        _Wp = new RepeaterWrapper(r);
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var data = (
            from c in context.CarComplains
            join o in context.Cars on c.CarId equals o.Id
            join d in context.Drivers on c.DriverId equals d.Id
            orderby c.Time descending
            select new
            {
                o.PlateNumber,
                Driver = d.Name,
                c.Type,
                c.Time,
                c.Name,
                c.Description,
                c.Source,
                c.OwnFault,
                c.ContactPerson,
                c.Contact,
                c.Fine
            }).Take(ROW_COUNT).ToList();

        _Wp.Execute(data, b => b
            .Do<Label>("PlateNumber", (l, d, i) => l.Text = d.PlateNumber)
            .Do<Label>("Driver", (l, d, i) => l.Text = d.Driver)
            .Do<Label>("Time", (l, d, i) => l.Text = d.Time.ToISDateWithTime())
            .Do<Label>("Type", (l, d, i) =>
                {
                    _Util.Convert<ComplainType>(d.Type, v => l.Text = DefinitionHelper.Caption(v));
                })
            .Do<Label>("Source", (l, d, i) =>
                {
                    _Util.Convert<ComplainSource>(d.Source, v => l.Text = DefinitionHelper.Caption(v));
                })
            .Do<Literal>("Message", (l, d, i) =>
                {
                    l.Text = d.Name;
                })
            , true);
    }

</script>

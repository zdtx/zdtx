<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/GridWrapperForList.ascx" TagPrefix="uc1" TagName="GridWrapperForList" %>
<uc1:Popup_DX runat="server" ID="pop" />
<div class="title" style="margin-top:10px;">
    出租车合同
</div>
<uc1:GridWrapperForList runat="server" ID="gw" />
<asp:GridView runat="server" ID="gv" Width="100%">
    <SelectedRowStyle CssClass="gridRow-selected" />
    <HeaderStyle CssClass="gridHeader" />
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }

    private string _CarId
    {
        set { _ViewStateEx.Set<string>(value, "carId"); }
        get { return _ViewStateEx.Get<string>("carId", null); }
    }

    private string _DriverId
    {
        set { _ViewStateEx.Set<string>(value, "driverId"); }
        get { return _ViewStateEx.Get<string>("driverId", null); }
    }

    private string _PaymentId
    {
        set { _ViewStateEx.Set<string>(value, "paymentId"); }
        get { return _ViewStateEx.Get<string>("paymentId", null); }
    }

    public override string ModuleId { get { return Car.Payment_Item_List; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("DriverId", "DriverId", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Ordinal", "Ordinal", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Code", "编号", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
            })
            .TemplateField("Name", "名称", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
            })
            .TemplateField("Amount", "金额", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Remark", "备注", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
            })
            , showFooter: false, mode: GridWrapper.SelectionMode.Single
        );

    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);






        var paymentItems = (
            from i in context.CarPaymentItems
            where i.CarId == _CarId && i.DriverId == _DriverId && i.PaymentId == _PaymentId
            orderby i.Code
            select new
            {
                i.Amount,
                i.CarId,
                i.ChargeId,
                i.Code,
                i.DriverId,
                i.Name,
                i.PaymentId,
                i.Remark,
                i.SpecifiedMonth,
                i.Type

            }).ToList();

        gw.Execute(paymentItems, b => b
            .Do<Literal>("Code", (c, d) =>
            {
                c.Text = d.Code;
            })
            .Do<Literal>("Name", (c, d) =>
            {
                c.Text = d.Name;
            })
            .Do<Label>("Amount", (c, d) =>
            {
                c.Text = d.Amount.ToStringOrEmpty(comma: true, emptyValue: " - ");
            })
            .Do<Literal>("Remark", (c, d) =>
            {
                c.Text = d.Remark;
            })
        );
    }

</script>

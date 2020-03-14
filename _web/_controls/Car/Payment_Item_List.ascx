<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/GridWrapperForList.ascx" TagPrefix="uc1" TagName="GridWrapperForList" %>
<uc1:Popup_DX runat="server" ID="pop" />
<div class="title" style="margin-top:8px;">
    <asp:Literal runat="server" ID="lHeader" />
</div>
<uc1:GridWrapperForList runat="server" ID="gw" />
<asp:GridView runat="server" ID="gv" Width="100%">
    <SelectedRowStyle CssClass="gridRow-selected" />
    <HeaderStyle CssClass="gridHeader" />
    <FooterStyle HorizontalAlign="Right" CssClass="gridFooter" />
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
                f.ItemStyle.Width = 50;
            })
            .TemplateField("Name", "名称", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("IsNegative", "类型", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;

            }, GridWrapper.FooterType.Label)

            .TemplateField("Amount", "金额", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;

            }, GridWrapper.FooterType.Label)

            .TemplateField("Remark", "备注", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
            })
            , showFooter: true, mode: GridWrapper.SelectionMode.Single
        );

    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);

        var header =
            from p in context.CarPayments
            join d in context.Drivers on p.DriverId equals d.Id
            join c in context.Cars on p.CarId equals c.Id
            select new
            {
                d.Name,
                d.CHNId,
                p.MonthInfo,
                c.PlateNumber
            };

        header.FirstOrDefault().IfNN(h =>
        {
            lHeader.Text = string.Format("{0}[{1}] - 车：{2} - {3} 结单", h.Name, h.CHNId, h.PlateNumber, h.MonthInfo);
        });

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
                i.Type,
                i.IsNegative

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
            .Do<Literal>("IsNegative", (c, d) =>
            {
                c.Text = d.IsNegative ? "付" : "收";
            })
            .Do<Label>("Amount", (c, d) =>
            {
                c.Text = d.Amount.ToStringOrEmpty(comma: true, emptyValue: " - ");
                c.ColorizeNumber(d, dd => d.IsNegative);
            })
            .Do<Literal>("Remark", (c, d) =>
            {
                c.Text = d.Remark;
            }),

            f => f

            .Do<Label>("IsNegative", c => c.Text = "合计：")
            .Do<Label>("Amount", c =>
            {
                var sum = paymentItems.Sum(i => i.IsNegative ? -1 * i.Amount : i.Amount);
                c.Text = sum.ToStringOrEmpty(comma: true);
                c.ColorizeNumber(sum, s => s < 0, s => s == 0);
            })

        );
    }

</script>

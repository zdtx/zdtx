<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/GridWrapperForList.ascx" TagPrefix="uc1" TagName="GridWrapperForList" %>
<uc1:Popup_DX runat="server" ID="pop" />
<uc1:GridWrapperForList runat="server" ID="gw" />
<asp:GridView runat="server" ID="gv" Width="100%">
    <SelectedRowStyle CssClass="gridRow-selected" />
    <HeaderStyle CssClass="gridHeader" />
    <EmptyDataTemplate>
        <div class="emptyData">
            （无费租金/管理费记录）
        </div>
    </EmptyDataTemplate>
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Driver.View_Payment; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("MonthInfo", "月份", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 60;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("PlateNumber", "车牌号码", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Days", "月天数", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("CountDays", "应缴费天数", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Name", "名目抬头", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Amount", "金额", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Paid", "已缴", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Balance", "结算", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Due", "到期", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("CreateTime", "登记时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("CreatedById", "操作人", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Remark", "备注", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
            })
            , showFooter: false, mode: GridWrapper.SelectionMode.Single
        );
    }

    protected override void _Execute()
    {
        gv.Visible = !string.IsNullOrEmpty(_ObjectId);
        var context = _DTContext<CommonContext>(true);
        var data = (
            from o in context.CarPayments
            join c in context.Cars on o.CarId equals c.Id
            where o.DriverId == _ObjectId
            orderby o.MonthInfo descending
            select new
            {
                c.PlateNumber,
                o.Id,
                o.MonthInfo,
                o.CreateTime,
                o.CreatedById,
                o.Days,
                o.CountDays,
                o.Name,
                o.Due,
                o.Amount,
                o.Paid,
                Balance = 0m,
                o.Remark,
            }).ToList();
        gw.Execute(data, b => b
            .Do<Label>("MonthInfo", (l, d, r) => l.Text = d.MonthInfo)
            .Do<Label>("PlateNumber", (l, d, r) => l.Text = d.PlateNumber)
            .Do<Label>("Name", (l, d, r) => l.Text = d.Name)
            .Do<Label>("Days", (l, d, r) => l.Text = d.Days.ToStringEx())
            .Do<Label>("CountDays", (l, d, r) => l.Text = d.CountDays.ToStringEx())
            .Do<Label>("Amount", (l, d, r) => l.Text = d.Amount.ToStringOrEmpty(comma: true))
            .Do<Label>("Paid", (l, d, r) => l.Text = d.Paid.ToStringOrEmpty(comma: true))
            .Do<Label>("Balance", (l, d, r) =>
            {
                l.Text = "（收讫）";
                l.ForeColor = System.Drawing.Color.Green;
                if (d.Paid == d.Amount)
                    return;
                l.ColorizeNumber(d, dd =>
                {
                    l.Text = Math.Abs(d.Paid - d.Amount).ToStringOrEmpty(comma: true);
                    if (dd.Paid >= dd.Amount)
                    {
                        l.Text = "+ " + l.Text;
                    }
                    {
                        l.Text = "- " + l.Text;
                    }
                    return dd.Paid >= dd.Amount;
                });
            })
            .Do<Label>("Due", (l, d, r) => l.Text = d.Due.ToISDate())
            .Do<Label>("CreateTime", (l, d, r) => l.Text = d.CreateTime.ToISDateWithTime())
            .Do<Label>("CreatedById", (l, d, r) => l.Text = Global.Cache.GetPersonById(d.CreatedById).Name)
            .Do<Label>("Remark", (l, d, r) => l.Text = d.Remark)
        );
    }

</script>

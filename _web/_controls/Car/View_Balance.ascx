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
            （无费用登记项）
        </div>
    </EmptyDataTemplate>
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.View_Balance; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Time", "时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Source", "获得方式", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("Title", "名目", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 200;
            })
            .TemplateField("Amount", "金额", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("CreateTime", "登记时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
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
            from o in context.CarBalances
            where o.CarId == _ObjectId
            orderby o.Time descending
            select new
            {
                o.Id,
                o.Time,
                o.CreateTime,
                o.CreatedById,
                o.Ref1,
                o.Ref2,
                o.Ref3,
                o.Source,
                o.Title,
                o.IsIncome,
                o.Amount,
                o.Paid,
                o.Status,
                o.Remark,
            }).ToList();
        gw.Execute(data, b => b
            .Do<Label>("Time", (l, d, r) => l.Text = d.Time.ToISDateWithTime())
            .Do<Label>("Source", (l, d, r) => l.Text = DefinitionHelper.Caption<CarBalanceSource>(d.Source))
            .Do<Label>("Title", (l, d, r) => l.Text = d.Title)
            .Do<Label>("Amount", (l, d, r) =>
            {
                l.Text = d.Amount.ToStringOrEmpty(comma: true);
                l.ColorizeNumber(d.IsIncome, dd =>
                {
                    if (dd)
                    {
                        l.Text = "+ " + l.Text;
                    }
                    else
                    {
                        l.Text = "- " + l.Text;
                    }
                    return dd;
                });
            })
            .Do<Label>("CreateTime", (l, d, r) => l.Text = d.CreateTime.ToISDateWithTime())
            .Do<Label>("CreatedById", (l, d, r) => l.Text = Global.Cache.GetPersonById(d.CreatedById).Name)
            .Do<Label>("Remark", (l, d, r) => l.Text = d.Remark)
        );
    }

</script>

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
            （无好人好事记录）
        </div>
    </EmptyDataTemplate>
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.View_Log; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Time", "时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("DriverName", "当事司机", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 60;
            })
            .TemplateField("Type", "类型", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Name", "摘要", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("Description", "事情经过", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 200;
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
            from o in context.CarLogs
            join d in context.Drivers on o.DriverId equals d.Id
            where o.CarId == _ObjectId
            orderby o.Time descending
            select new
            {
                o.Id,
                DriverName = d.Name,
                o.Time,
                o.CreateTime,
                o.CreatedById,
                o.Type,
                o.Name,
                o.Description,
                Remark = string.Empty
            }).ToList();
        gw.Execute(data, b => b
            .Do<Label>("Time", (l, d, r) => l.Text = d.Time.ToISDateWithTime())
            .Do<Label>("DriverName", (l, d, r) => l.Text = d.DriverName)
            .Do<Label>("Type", (l, d, r) => l.Text = DefinitionHelper.Caption<CarLogType>(d.Type))
            .Do<Label>("Name", (l, d, r) => l.Text = d.Name)
            .Do<Label>("Description", (l, d, r) => l.Text = d.Description)
            .Do<Label>("CreateTime", (l, d, r) => l.Text = d.CreateTime.ToISDateWithTime())
            .Do<Label>("CreatedById", (l, d, r) => l.Text = Global.Cache.GetPersonById(d.CreatedById).Name)
            .Do<Label>("Remark", (l, d, r) => l.Text = d.Remark)
        );
    }

</script>

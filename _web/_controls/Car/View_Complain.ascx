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
            （无投诉记录）
        </div>
    </EmptyDataTemplate>
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.View_Complain; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Time", "发生时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("OwnFault", "", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 30;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            })
            .TemplateField("DriverName", "当事司机", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Source", "获得方式", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("Type", "类型", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("Name", "摘要", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Description", "事情经过", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("ContactPerson", "投诉人", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Contact", "联系方式", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Coordinator", "协调人", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Fine", "罚款", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
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
            from o in context.CarComplains
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
                o.Source,
                o.Type,
                o.Name,
                o.Description,
                o.Coordinator,
                o.ContactPerson,
                o.Contact,
                o.OwnFault,
                o.Fine,
                o.Remark,
            }).ToList();
        gw.Execute(data, b => b
            .Do<Label>("Time", (l, d, r) => l.Text = d.Time.ToISDateWithTime())
            .Do<Label>("OwnFault", (l, d, r) =>
            {
                l.Text = "无责";
                if (d.OwnFault)
                {
                    l.Text = "有责";
                    l.ForeColor = System.Drawing.Color.Red;
                }
            })
            .Do<Label>("Source", (l, d, r) => l.Text = DefinitionHelper.Caption<ComplainSource>(d.Source))
            .Do<Label>("Type", (l, d, r) => l.Text = DefinitionHelper.Caption<ComplainType>(d.Type))
            .Do<Label>("DriverName", (l, d, r) => l.Text = d.DriverName)
            .Do<Label>("Name", (l, d, r) => l.Text = d.Name)
            .Do<Label>("Description", (l, d, r) => l.Text = d.Description)
            .Do<Label>("Coordinator", (l, d, r) => l.Text = d.Coordinator)
            .Do<Label>("Fine", (l, d, r) => l.Text = d.Fine.ToStringOrEmpty(comma: true))
            .Do<Label>("CreateTime", (l, d, r) => l.Text = d.CreateTime.ToISDateWithTime())
            .Do<Label>("CreatedById", (l, d, r) => l.Text = Global.Cache.GetPersonById(d.CreatedById).Name)
            .Do<Label>("Remark", (l, d, r) => l.Text = d.Remark)
        );
    }

</script>

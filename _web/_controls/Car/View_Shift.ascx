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
            （无代班记录）
        </div>
    </EmptyDataTemplate>
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.View_Shift; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Time", "发生时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("IsActive", "", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("DriverName", "正班司机", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("ShiftDriverName", "代班司机", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Reason", "代班原因", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("StartTime", "开始", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
            })
            .TemplateField("EndTime", "结束", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
            })
            .TemplateField("ActualEndTime", "实际结束", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
            })
            .TemplateField("ConfirmedDays", "代班天数", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
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
            from o in context.CarRentalShifts
            join d in context.Drivers on o.DriverId equals d.Id
            join x in context.Drivers on o.SubDriverId equals x.Id
            where o.CarId == _ObjectId
            orderby o.Time descending
            select new
            {
                o.Id,
                DriverName = d.Name,
                ShiftDriverName = x.Name,
                o.Time,
                o.CreateTime,
                o.CreatedById,
                o.Reason,
                o.StartTime,
                o.EndTime,
                o.SubDriverId,
                o.IsActive,
                o.ConfirmedDays,
                o.ActualEndTime,
                o.Remark,
            }).ToList();
        gw.Execute(data, b => b
            .Do<Label>("IsActive", (l, d, r) =>
            {
                if (d.IsActive)
                {
                    r.CssClass = "gridRow-selected";
                    l.Text = "[代班中]";
                    l.ForeColor = System.Drawing.Color.Red;
                }
            })
            .Do<Label>("Time", (l, d, r) => l.Text = d.Time.ToISDateWithTime())
            .Do<Label>("CreateTime", (l, d, r) => l.Text = d.CreateTime.ToISDateWithTime())
            .Do<Label>("CreatedById", (l, d, r) => l.Text = Global.Cache.GetPersonById(d.CreatedById).Name)
            .Do<Label>("DriverName", (l, d, r) => l.Text = d.DriverName)
            .Do<Label>("ShiftDriverName", (l, d, r) => l.Text = d.ShiftDriverName)
            .Do<Label>("StartTime", (l, d, r) => l.Text = d.StartTime.ToISDate())
            .Do<Label>("EndTime", (l, d, r) => l.Text = d.EndTime.ToISDate())
            .Do<Label>("ConfirmedDays", (l, d, r) => l.Text = d.ConfirmedDays.ToStringEx())
            .Do<Label>("ActualEndTime", (l, d, r) => l.Text = d.ActualEndTime.ToISDate())
            .Do<Label>("Remark", (l, d, r) => l.Text = d.Remark)
        );
    }

</script>

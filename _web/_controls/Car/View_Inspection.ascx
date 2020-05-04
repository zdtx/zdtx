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
            （无营审、行审记录）
        </div>
    </EmptyDataTemplate>
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.View_Inspection; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("CreateTime", "变更时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
            })
            .TemplateField("CreatedById", "操作人", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("IsDrivingLicense", "类型", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("License", "原证照号", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("ExpiryDate", "原到期日", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
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
            from o in context.CarInspections
            where o.CarId == _ObjectId
            orderby o.CreateTime descending
            select new
            {
                o.Id,
                o.CreateTime,
                o.CreatedById,
                o.IsDrivingLicense,
                o.ExpiryDate,
                o.License,
                Remark = string.Empty,
            }).ToList();
        gw.Execute(data, b => b
            .Do<Label>("CreateTime", (l, d, r) => l.Text = d.CreateTime.ToISDateWithTime())
            .Do<Label>("CreatedById", (l, d, r) => l.Text = Global.Cache.GetPersonById(d.CreatedById).Name)
            .Do<Label>("License", (l, d, r) => l.Text = d.License)
            .Do<Label>("IsDrivingLicense", (l, d, r) =>
            {
                l.Text = "[营运证到期]";
                if (d.IsDrivingLicense)
                {
                    l.Text = "[行驶证到期]";
                    l.ForeColor = System.Drawing.Color.Blue;
                }
            })
            .Do<Label>("ExpiryDate", (l, d, r) => l.Text = d.ExpiryDate.ToISDate())
            .Do<Label>("Remark", (l, d, r) => l.Text = d.Remark)
            );
    }

</script>

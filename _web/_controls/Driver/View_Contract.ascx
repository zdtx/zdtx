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
            （无合同记录）
        </div>
    </EmptyDataTemplate>
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Driver.View_Contract; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("PlateNumber", "车牌号码", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Type", "合同类型", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("Code", "合同编号", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("CommenceDate", "合同开始", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("EndDate", "到期", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Url", "附件", new TemplateItem.Link(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
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
            from o in context.CarContracts
            join c in context.Cars on o.CarId equals c.Id
            where o.DriverId == _ObjectId
            orderby c.PlateNumber, o.CommenceDate descending
            select new
            {
                c.PlateNumber,
                o.Id,
                o.Type,
                o.Code,
                o.CommenceDate,
                o.EndDate,
                o.BlobOrginalName,
                o.CreateTime,
                o.CreatedById,
                o.Remark,
            }).ToList();
        gw.Execute(data, b => b
            .Do<Label>("PlateNumber", (l, d, r) => l.Text = d.PlateNumber)
            .Do<Label>("Type", (l, d, r) => l.Text = DefinitionHelper.Caption<ContractType>(d.Type))
            .Do<Label>("Code", (l, d, r) => l.Text = d.Code)
            .Do<Label>("CommenceDate", (l, d, r) => l.Text = d.CommenceDate.ToISDate())
            .Do<Label>("EndDate", (l, d, r) => l.Text = d.EndDate.ToISDate())
            .Do<HyperLink>("Url", (l, d, r) =>
            {
                if (string.IsNullOrEmpty(d.BlobOrginalName))
                {
                    l.Text = " - ";
                    return;
                }

                var extension = System.IO.Path.GetExtension(d.BlobOrginalName);
                var filename = string.Format("{0}{1}", d.Id, extension);
                var path = string.Format("~{0}/{1}", Parameters.Filebase, filename);

                l.Text = filename;
                l.NavigateUrl = path;
                l.ForeColor = System.Drawing.Color.Blue;
                l.Target = "_blank";

            })
            .Do<Label>("CreateTime", (l, d, r) => l.Text = d.CreateTime.ToISDateWithTime())
            .Do<Label>("CreatedById", (l, d, r) => l.Text = Global.Cache.GetPersonById(d.CreatedById).Name)
            .Do<Label>("Remark", (l, d, r) => l.Text = d.Remark)
        );
    }

</script>

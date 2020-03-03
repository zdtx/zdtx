<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<%@ Register Src="~/_controls.helper/PagingToolbar.ascx" TagPrefix="uc1" TagName="PagingToolbar" %>
<%@ Register Src="~/_controls.helper/PopupField_DX.ascx" TagPrefix="uc1" TagName="PopupField_DX" %>
<%@ Register Src="~/_controls.helper/Callback.ascx" TagPrefix="uc1" TagName="Callback" %>

<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="../../content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="N" ContentPlaceHolderID="N">
    <uc1:HeaderInfo runat="server" ID="hi" />
    <uc1:Popup_DX runat="server" ID="pop" />
    <uc1:Callback runat="server" ID="cb" />
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <div class="actionTB" style="padding-left: 1px;">
        <dx:ASPxMenu runat="server" ID="tb" CssClass="dxTb" />
    </div>
    <asp:Panel runat="server" ID="pT" CSSClass="filterTb">
        <div class="inner">
            <table>
                <tr>
                    <td class="name">车牌号：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_PlateNumber" Width="100" />
                    </td>
                    <td class="name">单位：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Company" Width="100" />
                    </td>
                    <td class="name">品牌型号：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Model" Width="100" />
                    </td>
                    <td class="name">营运证：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_License" Width="100" />
                    </td>
                    <td rowspan="2" class="btn">
                        <dx:ASPxButton ID="bSearch" runat="server" Text="查找">
                            <Image Url="~/images/_op_flatb_search.gif" />
                            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        </dx:ASPxButton>
                    </td>
                    <td rowspan="2" class="btn">
                        <dx:ASPxButton ID="bExport" runat="server" Text="导出">
                            <Image Url="~/images/_op_flatb_reply.gif" />
                            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        </dx:ASPxButton>
                    </td>
                </tr>
                <tr>
                    <td class="name">原车牌号：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_FormerPlateNumber" Width="100" />
                    </td>
                    <td class="name">性质：
                    </td>
                    <td class="cl">
                        <dx:ASPxComboBox runat="server" ID="cb_Type" Width="100" />
                    </td>
                    <td class="name">营运部门：
                    </td>
                    <td class="cl">
                        <uc1:PopupField_DX runat="server" ID="pf_DepartmentId" Width="100" />
                    </td>
                    <td class="name">治安证：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_SecSerialNum" Width="100" />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:DXGridWrapper runat="server" ID="gw" />
    <dx:ASPxGridView ID="gv" runat="server" KeyFieldName="Id" Width="100%">
        <Border BorderStyle="None" />
        <SettingsBehavior ColumnResizeMode="NextColumn" EnableRowHotTrack="true" />
        <Columns>
            <dx:GridViewDataColumn FieldName="Id" Visible="false" />
            <dx:GridViewDataColumn FieldName="PlateNumber" Caption="车牌号" Width="80" VisibleIndex="3" />
            <dx:GridViewDataColumn FieldName="FormerPlateNum" Caption="原车牌号" Width="80" VisibleIndex="4" />
            <dx:GridViewDataColumn FieldName="Model" Caption="品牌型号" Width="100" VisibleIndex="5" />
            <dx:GridViewDataColumn FieldName="Company" Caption="单位" Width="200" VisibleIndex="6" />
            <dx:GridViewDataColumn FieldName="DepartmentId" Caption="营运部门" Width="120" VisibleIndex="7" />
            <dx:GridViewDataColumn FieldName="Type" Caption="性质" Width="80" VisibleIndex="8" />
            <dx:GridViewDataColumn FieldName="License" Caption="营运证" Width="120" VisibleIndex="9" />
            <dx:GridViewDataColumn FieldName="SecSerialNum" Caption="治安证" Width="100" VisibleIndex="10" />
            <dx:GridViewDataColumn FieldName="ModifyTime" Caption="最后更新" Width="130" VisibleIndex="11">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Remark" Caption="备注" VisibleIndex="12" />
        </Columns>
    </dx:ASPxGridView>
    <div class="darkBar">
        <uc1:PagingToolbar runat="server" ID="pg" />
    </div>
</asp:Content>
<script runat="server">

    protected override bool _PACK_0001 { get { return true; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => { c.MaxSize = c.Size = 30; c.AutoHeight = false; })
            .West(true, c => { c.MinSize = c.Size = 50; })
            .CenterTop(true, c => { c.Size = 20; c.AutoHeight = true; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        cb_Type.FromEnum<CarType>(valueAsInteger: true);
        pf_DepartmentId.Initialize<eTaxi.Web.Controls.Selection.Department.TreeItem>(pop,
            "~/_controls.helper/selection/department/treeitem.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择车辆的营运部门";
                pop.Width = 500;
                pop.Height = 400;
                if (isFirst) cc.Execute();
            }, (c, b, h) =>
            {
                b.Text = c.Selection[0].Name;
                h.Value = c.Selection[0].Id;
                pop.Close();
                return true;
            }, null, c => c.Button(BaseControl.EventTypes.OK, s => s.CausesValidation = false));

        tb
            .MenuItem("create", "新车建档", "_op_flatb_add.gif")
            .MenuItem("delete", "删除", "_op_flatb_delete.gif", i => { i.BeginGroup = true; })
            .ItemClickJSFunc(string.Format(
@"function(s,e){{
switch(e.item.name){{
case'create':
case'delete':ISEx.loadingPanel.show();break; 
}}}}", gv.ClientID))
            .ItemClick += (s, e) =>
                {
                    switch (e.Item.Name)
                    {
                        case "create":
                            Response.Redirect("create.aspx", true);
                            break;
                        case "delete":

                            if (gv.Selection.Count == 0)
                            {
                                _JS.Alert("请先选择待删除的条目");
                                return;
                            }

                            cb.Break("Do", Actions.Delete, () => true, postBack =>
                            {
                                _JS.Write(string.Format("if(confirm('{0}')){{ISEx.loadingPanel.show();{1}}}", "确定删除选中的条目吗？", postBack));
                            });

                            break;
                    }
                };

        gw.Initialize(gv, d =>
        {
            d
                .ShowRowNumber()
                .ShowCheckAll()
            ;
        });

        gv.BeforeColumnSortingGrouping += (s, e) => { Execute(); };
        gv.CustomColumnDisplayText += (s, e) =>
        {
            switch (e.Column.FieldName)
            {
                case "Type":
                    _Util.Convert<CarType>(e.Value, d => e.DisplayText = DefinitionHelper.Caption(d));
                    break;
                case "ModifyTime":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDate());
                    break;
                case "DepartmentId":
                    e.DisplayText = Global.Cache.GetDepartment(d => d.Id == e.Value.ToStringEx()).Name;
                    break;
            }
        };
        gv.HtmlRowPrepared += (s, e) =>
        {
            if (e.RowType == GridViewRowType.Data)
            {
                //if (!(bool)
                //    e.GetValue("Enabled")) e.Row.Font.Strikeout = true;
            }
        };

        pg.SetDefaultPageSizeIndex(0);
        pg.Reload += (s, e) => Execute();

        gw.RowDblClick += (s, e) =>
        {
            if (gv.Selection.Count != 1) return;
            var objectId = gv.GetSelectedFieldValues("Id")[0].ToStringEx();
            _JS.Write(string.Format("ISEx.openMaxWin('view.aspx?id={0}');", objectId));
        };

        bSearch.Click += (s, e) => Execute();
        bExport.Click += (s, e) => Execute(VisualSections.Export);
        
        cb.Resumed += (caller, parameter) =>
        {
            switch (parameter)
            {
                case Actions.Delete:
                    if (Do(Actions.Delete, true))
                    {
                        _JS.Alert("删除成功");
                        Execute();
                    }
                    break;
            }
        };

    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../../portal/desktop.aspx")
            .Title("车辆管理", "查看");
        
        _Execute(VisualSections.List);
    }
    protected override void _Execute(string section)
    {
        var context = _DTContext<CommonContext>(true);
        var exp = PredicateBuilder.True<TB_car>();
        exp = exp.Append(tb_PlateNumber.Text, v => exp.And(e => e.PlateNumber.Contains(v)));
        exp = exp.Append(tb_FormerPlateNumber.Text, v => exp.And(e => e.FormerPlateNum.Contains(v)));
        exp = exp.Append(tb_Company.Text, v => exp.And(e => e.Company.Contains(v)));
        exp = exp.Append(cb_Type.Value.ToStringEx().ToIntOrNull(), v => exp.And(e => e.Type == v.Value));
        exp = exp.Append(tb_Model.Text, v => exp.And(e => e.Model.Contains(v)));
        exp = exp.Append(pf_DepartmentId.Value, v => exp.And(e => e.DepartmentId == v));
        exp = exp.Append(tb_License.Text, v => exp.And(e => e.License.Contains(v)));
        exp = exp.Append(tb_SecSerialNum.Text, v => exp.And(e => e.SecSerialNum.Contains(v)));
        
        var q =
            from o in context.Cars.Where(exp)
            select new
            {
                o.Id,
                o.PlateNumber,
                o.FormerPlateNum,
                o.Company,
                o.Manufacturer,
                o.Model,
                o.Type,
                o.Source,
                o.EngineNum,
                o.CarriageNum,
                o.SecSerialNum,
                o.License,
                o.DrvLicense,
                o.DepartmentId,
                o.ModifiedById,
                o.ModifyTime,
                o.Remark
            };

        // 独立导出数据
        if (section == VisualSections.Export)
        {
            _ExportToExcel("CR", q.Select(o => new
            {
                o.Id,
                o.PlateNumber,
                o.FormerPlateNum,
                o.Company,
                o.Manufacturer,
                o.Model,
                o.Type,
                o.Source,
                o.EngineNum,
                o.CarriageNum,
                o.SecSerialNum,
                o.License,
                o.DrvLicense,
                o.DepartmentId,
                o.Remark

            }).ToList(), new string[] 
            { 
                "唯一码",
                "车牌号码",
                "原车牌号",
                "车辆单位",
                "品牌",
                "型号",
                "车辆性质",
                "获得方式",
                "发动机号",
                "车架号",
                "治安证号",
                "营运证号",
                "行驶证号",
                "营运部门",
                "备注"
                
            }, d => new
            {
                d.Id,
                d.PlateNumber,
                d.FormerPlateNum,
                d.Company,
                d.Manufacturer,
                d.Model,
                Type = DefinitionHelper.Caption(Util.ParseEnum<CarType>(d.Type, CarType.GY)),
                d.Source,
                d.EngineNum,
                d.CarriageNum,
                d.SecSerialNum,
                d.License,
                d.DrvLicense,
                DepartmentName = Global.Cache.GetDepartment(dd => dd.Id == d.DepartmentId).Name,
                d.Remark
            }, pop);

            return;
        }
        
        q = gv.ApplySorts(q);

        gv.DataSource = q.Skip(pg.Skip).Take(pg.Size ?? 100).ToList();
        gv.DataBind();
        gv.Selection.UnselectAll();

        pg.Total = q.Count();
        pg.Execute();
    }
    
    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Delete) return;
        var ids = gv.GetSelectedFieldValues("Id");
        ids.ForEach(id =>
        {
            var carId = id.ToString();
            _DTService.DeleteCar(carId);
        });
    }

</script>

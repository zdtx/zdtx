<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<%@ Register Src="~/_controls.helper/PagingToolbar.ascx" TagPrefix="uc1" TagName="PagingToolbar" %>
<%@ Register Src="~/_controls.helper/PopupField_DX.ascx" TagPrefix="uc1" TagName="PopupField_DX" %>
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
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <asp:Panel runat="server" ID="pT" CSSClass="filterTb">
        <div class="inner">
            <table>
                <tr>
                    <td class="name">车牌号：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_PlateNumber" Width="120" />
                    </td>
                    <td class="name">当事司机：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Name" Width="120" />
                    </td>
                    <td class="name">部门：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_DepartmentName" Width="120" />
                    </td>
                    <td class="name">投诉来源：
                    </td>
                    <td class="cl">
                        <dx:ASPxComboBox runat="server" ID="cb_Source" Width="120" />
                    </td>
                    <td></td>
                    <td></td>
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
                    <td class="name">时间 从：
                    </td>
                    <td class="cl">
                        <dx:ASPxDateEdit runat="server" ID="de_Start" Width="120"
                            DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                            <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                                <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                            </CalendarProperties>
                        </dx:ASPxDateEdit>
                    </td>
                    <td class="name">到：
                    </td>
                    <td class="cl">
                        <dx:ASPxDateEdit runat="server" ID="de_End" Width="120"
                            DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                            <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                                <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                            </CalendarProperties>
                        </dx:ASPxDateEdit>
                    </td>
                    <td class="name">投诉人：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_ContactPerson" Width="120" />
                    </td>
                    <td class="name">协调人：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Coordinator" Width="120" />
                    </td>
                    <td class="name">投诉类型：
                    </td>
                    <td class="cl">
                        <dx:ASPxComboBox runat="server" ID="cb_Type" Width="120" />
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
            <dx:GridViewDataColumn FieldName="CarId" Visible="false" />
            <dx:GridViewDataColumn FieldName="PlateNumber" Caption="车牌号" Width="80" VisibleIndex="3" />
            <dx:GridViewDataColumn FieldName="DriverName" Caption="当事司机" Width="80" VisibleIndex="4" />
            <dx:GridViewDataColumn FieldName="DepartmentId" Caption="部门" Width="100" VisibleIndex="5" />
            <dx:GridViewDataColumn FieldName="Source" Caption="投诉来源" Width="80" VisibleIndex="5" />
            <dx:GridViewDataColumn FieldName="Type" Caption="投诉类型" Width="80" VisibleIndex="6" />
            <dx:GridViewDataColumn FieldName="Time" Caption="发生时间" Width="90" VisibleIndex="7" />
            <dx:GridViewDataColumn FieldName="Name" Caption="摘要" Width="150" VisibleIndex="8" />
            <dx:GridViewDataColumn FieldName="ContactPerson" Caption="投诉人" Width="60" VisibleIndex="9" />
            <dx:GridViewDataColumn FieldName="Contact" Caption="联系方式" Width="100" VisibleIndex="10" />
            <dx:GridViewDataColumn FieldName="Coordinator" Caption="协调人" Width="100" VisibleIndex="11" />
            <dx:GridViewDataColumn FieldName="ModifyTime" Caption="最后更新" Width="130" VisibleIndex="12">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="ModifiedById" Caption="操作人" Width="80" VisibleIndex="13">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Remark" Caption="备注" VisibleIndex="14" />
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
        cb_Source.FromEnum<ComplainSource>(valueAsInteger: true);
        cb_Type.FromEnum<ComplainType>(valueAsInteger: true);

        gw.Initialize(gv, d =>
        {
            d
                .ShowRowNumber()
                .ShowCheckAll()
            ;
        });

        gv.BeforeColumnSortingGrouping += (s, e) =>
        {
            Execute();
        };
        gv.CustomColumnDisplayText += (s, e) =>
        {
            switch (e.Column.FieldName)
            {
                case "ModifiedById":
                    e.DisplayText = Global.Cache.GetPersonById(e.Value.ToStringEx()).Name;
                    break;
                case "Time":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDate());
                    break;
                case "ModifyTime":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDateWithTime(false));
                    break;
                case "Source":
                    _Util.Convert<ComplainSource>(e.Value, d => e.DisplayText = DefinitionHelper.Caption(d));
                    break;
                case "Type":
                    _Util.Convert<ComplainType>(e.Value, d => e.DisplayText = DefinitionHelper.Caption(d));
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

        pg.SetDefaultPageSizeIndex(5);
        pg.Reload += (s, e) => Execute();

        gw.RowDblClick += (s, e) =>
        {
            if (gv.Selection.Count != 1)
                return;
            var objectId = gv.GetSelectedFieldValues("CarId")[0].ToStringEx();
            _JS.Write(string.Format("ISEx.openMaxWin('../car/view.aspx?id={0}');", objectId));
        };

        bSearch.Click += (s, e) => Execute();
        bExport.Click += (s, e) => Execute(VisualSections.Export);
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../../portal/desktop.aspx")
            .Title("信息查询", "投诉查询");

        _Execute(VisualSections.List);
    }

    protected override void _Execute(string section)
    {
        var context = _DTContext<CommonContext>(true);
        var exp_Car = PredicateBuilder.True<TB_car>();
        var exp_Driver = PredicateBuilder.True<TB_driver>();
        var exp_Department = PredicateBuilder.True<TB_department>();
        var exp = PredicateBuilder.True<TB_car_complain>();

        exp_Car = exp_Car.Append(tb_PlateNumber.Text, v => exp_Car.And(e => e.PlateNumber.Contains(v)));
        exp_Driver = exp_Driver.Append(tb_Name.Text, v => exp_Driver.And(e => e.Name.Contains(v)));
        exp_Department = exp_Department.Append(tb_DepartmentName.Text, v => exp_Department.And(e => e.Name.Contains(v)));
        exp = exp.Append(cb_Source.Value.ToStringEx().ToIntOrNull(), v => exp.And(e => e.Source == v.Value));
        exp = exp.Append(cb_Type.Value.ToStringEx().ToIntOrNull(), v => exp.And(e => e.Type == v.Value));
        exp = exp.Append(tb_ContactPerson.Text, v => exp.And(e => e.ContactPerson.Contains(v)));
        exp = exp.Append(tb_Coordinator.Text, v => exp.And(e => e.Coordinator.Contains(v)));
        exp = exp.Append(de_Start.Value.ToStringEx(), v => exp.And(e => e.Time >= de_Start.Date));
        exp = exp.Append(de_End.Value.ToStringEx(), v => exp.And(e => e.Time <= de_End.Date));

        var q =
            from a in context.CarComplains.Where(exp)
            join c in context.Cars.Where(exp_Car) on a.CarId equals c.Id
            join o in context.Departments.Where(exp_Department) on c.DepartmentId equals o.Id
            join d in context.Drivers.Where(exp_Driver) on a.DriverId equals d.Id
            select new
            {
                a.CarId,
                a.Id,
                c.PlateNumber,
                c.DepartmentId,
                DriverName = d.Name,
                d.CHNId,
                d.Gender,
                a.Time,
                a.Source,
                a.Type,
                a.Name,
                a.Description,
                a.Coordinator,
                a.Contact,
                a.ContactPerson,
                a.OwnFault,
                a.ModifiedById,
                a.ModifyTime,
                a.Remark
            };

        // 独立导出数据
        if (section == VisualSections.Export)
        {
            _ExportToExcel("CR", q.Select(a => new
            {
                a.PlateNumber,
                a.DepartmentId,
                a.DriverName,
                a.CHNId,
                a.Gender,
                a.Time,
                a.Source,
                a.Type,
                a.Name,
                a.Description,
                a.Coordinator,
                a.Contact,
                a.ContactPerson,
                a.OwnFault,
                a.ModifiedById,
                a.ModifyTime,
                a.Remark
            }).ToList(), new string[]
            {
                "车牌号",
                "部门",
                "当事司机",
                "身份证",
                "性别",
                "发生时间",
                "来源",
                "类别",
                "摘要",
                "详细",
                "接待人",
                "联系方式",
                "投诉人",
                "有无责任",
                "操作人",
                "最后修改",
                "备注"
            }, a => new
            {
                a.PlateNumber,
                Department = Global.Cache.GetDepartment(d => d.Id == a.DepartmentId).Name,
                a.DriverName,
                a.CHNId,
                Gender = a.Gender.HasValue ? a.Gender.Value ? "男" : "女" : "（未知）",
                Time = a.Time.ToISDateWithTime(),
                Source = DefinitionHelper.Caption<ComplainSource>(a.Source, " - "),
                Type = DefinitionHelper.Caption<ComplainType>(a.Type, " - "),
                a.Name,
                a.Description,
                a.Coordinator,
                a.Contact,
                a.ContactPerson,
                OwnFault = a.OwnFault ? "有" : "无",
                ModifiedBy = Global.Cache.GetPersonById(a.ModifiedById).Name,
                ModifyTime = a.ModifyTime.ToISDateWithTime(),
                a.Remark
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

</script>

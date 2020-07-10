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
                    <td class="name">姓名：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Name" Width="100" />
                    </td>
                    <td class="name">部门：
                    </td>
                    <td class="cl">
                        <uc1:PopupField_DX runat="server" ID="pf_DepartmentId" ShowEdit="true" Width="150" />
                    </td>
                    <td class="name">文化程度：
                    </td>
                    <td class="cl">
                        <dx:ASPxComboBox runat="server" ID="cb_Education" Width="100" />
                    </td>
                    <td class="name">常住地址：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Address" Width="150" />
                    </td>
                    <td></td>
                    <td></td>
                    <td rowspan="2" class="btn">
                        <dx:ASPxButton ID="bSearch" runat="server" Text="查找">
                            <Image Url="~/images/_op_flatb_search.gif" />
                        </dx:ASPxButton>
                    </td>
                    <td rowspan="2" class="btn">
                        <dx:ASPxButton ID="bExport" runat="server" Text="导出">
                            <Image Url="~/images/_op_flatb_reply.gif" />
                        </dx:ASPxButton>
                    </td>
                </tr>
                <tr>
                    <td class="name">资格证号：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_CertNumber" Width="100" />
                    </td>
                    <td class="name">车牌：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_PlateNumber" Width="150" />
                    </td>
                    <td class="name">性别：
                    </td>
                    <td class="cl">
                        <dx:ASPxComboBox runat="server" ID="cb_Gender" Width="100" />
                    </td>
                    <td class="name">户口地址：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_HKAddress" Width="150" />
                    </td>
                    <td class="name">当前状态：
                    </td>
                    <td class="cl">
                        <dx:ASPxComboBox runat="server" ID="cb_Status" Width="100" />
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
            <dx:GridViewDataColumn FieldName="Name" Caption="姓名" Width="80" VisibleIndex="3" />
            <dx:GridViewDataColumn FieldName="Gender" Caption="性别" Width="50" VisibleIndex="4" />
            <dx:GridViewDataColumn FieldName="DayOfBirth" Caption="出生年月" Width="90" VisibleIndex="5" />
            <dx:GridViewDataColumn FieldName="CHNId" Caption="身份证" Width="160" VisibleIndex="6" />
            <dx:GridViewDataColumn FieldName="PlateNumber" Caption="车牌号码" Width="90" VisibleIndex="7" />
            <dx:GridViewDataColumn FieldName="DepartmentId" Caption="部门归属" Width="80" VisibleIndex="8" />
            <dx:GridViewDataColumn FieldName="Status" Caption="状态" Width="60" VisibleIndex="9" />
            <dx:GridViewDataColumn FieldName="Tel1" Caption="联系电话" Width="110" VisibleIndex="10" />
            <dx:GridViewDataColumn FieldName="Address" Caption="常住地址" Width="200" VisibleIndex="11" />
            <dx:GridViewDataColumn FieldName="Education" Caption="文化程度" Width="100" VisibleIndex="12" />
            <dx:GridViewDataColumn FieldName="SocialCat" Caption="政治面貌" Width="80" VisibleIndex="13" />
            <dx:GridViewDataColumn FieldName="ModifyTime" Caption="最后更新" Width="130" VisibleIndex="14">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Remark" Caption="备注" VisibleIndex="15" />
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
        cb_Gender.FromEnum<Gender>(valueAsInteger: true);
        cb_Education.FromEnum<Education>(valueAsInteger: true);
        cb_Status.FromEnum<DriverStatus>(valueAsInteger: true, canBeNull: true);

        pf_DepartmentId.Initialize<eTaxi.Web.Controls.Selection.Department.TreeItem>(pop,
            "~/_controls.helper/selection/department/treeitem.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择部门";
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
            .MenuItem("create", "新司机建档", "_op_flatb_add.gif")
            // .MenuItem("delete", "删除", "_op_flatb_delete.gif", i => { i.BeginGroup = true; })
            .MenuItem("disable", "删除", "_op_flatb_rejectedit.gif", i => { i.BeginGroup = true; })
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

                    case "disable":

                        if (gv.Selection.Count == 0)
                        {
                            _JS.Alert("请先选择待解除合同的司机档案");
                            return;
                        }

                        cb.Break("Do", Actions.Remove, () => true, postBack =>
                        {
                            _JS.Write(string.Format("if(confirm('{0}')){{ISEx.loadingPanel.show();{1}}}", "确定解除合同吗？", postBack));
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
                case "Gender":
                    e.DisplayText = "(未知)";
                    _Util.Convert<bool>(e.Value, d => e.DisplayText = d ? "男" : "女");
                    break;
                case "DayOfBirth":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDate());
                    break;
                case "ModifyTime":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDateWithTime(false));
                    break;
                case "Education":
                    _Util.Convert<Education>(e.Value, d => e.DisplayText = DefinitionHelper.Caption(d));
                    break;
                case "SocialCat":
                    _Util.Convert<SocialCat>(e.Value, d => e.DisplayText = DefinitionHelper.Caption(d));
                    break;
                case "DepartmentId":
                    e.DisplayText = Global.Cache.GetDepartment(d => d.Id == e.Value.ToStringEx()).Name;
                    break;
                case "Status":
                    var departmentId = e.GetFieldValue("DepartmentId").ToStringEx();
                    var enabled = _Util.Convert<bool>(e.GetFieldValue("Enabled"));
                    var worked = _Util.Convert<bool>(e.GetFieldValue("Worked"));
                    e.DisplayText = enabled ? string.IsNullOrEmpty(departmentId) ? worked ? "暂离" : "代班" : "在职" : "离职";
                    if (!enabled)
                    {
                        e.EncodeHtml = false;
                        e.DisplayText = string.Format("<span class='fonRed'>{0}</span>", e.DisplayText);
                    }
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
                case Actions.Remove:
                    if (Do(Actions.Remove, true))
                    {
                        _JS.Alert("解除成功");
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
        var exp = PredicateBuilder.True<TB_driver>();
        exp = exp.Append(tb_Name.Text, v => exp.And(e => e.Name.Contains(v)));
        exp = exp.Append(tb_CertNumber.Text, v => exp.And(e => e.CertNumber.Contains(v)));
        exp = exp.Append(cb_Education.Value.ToStringEx().ToIntOrNull(), v => exp.And(e => e.Education == v.Value));
        exp = exp.Append(tb_Address.Text, v => exp.And(e => e.Address.Contains(v)));
        exp = exp.Append(tb_HKAddress.Text, v => exp.And(e => e.HKAddress.Contains(v)));

        var exp_Car = PredicateBuilder.True<TB_car>();
        exp_Car = exp_Car.Append(tb_PlateNumber.Text, v => exp_Car.And(e => e.PlateNumber.Contains(v)));
        exp_Car = exp_Car.Append(pf_DepartmentId.Value, v => exp_Car.And(e => e.DepartmentId == v));

        var status = cb_Status.Value.ToStringEx().ToIntOrNull();
        if (status.HasValue)
        {
            switch(status.Value)
            {
                case (int)DriverStatus.On:
                    exp = exp.And(d => d.Enabled && context.CarRentals.Any(r => r.DriverId == d.Id));
                    break;
                case (int)DriverStatus.Off:
                    exp = exp.And(d => !d.Enabled);
                    break;
                case (int)DriverStatus.Shift:
                    exp = exp.And(d => d.Enabled && !context.CarRentals.Any(r => r.DriverId == d.Id));
                    break;
            }
        }

        if (!
            string.IsNullOrEmpty(
            cb_Gender.Value.ToStringEx()))
        {
            var g = (Gender)cb_Gender.Value.ToStringEx().ToIntOrDefault();
            switch (g)
            {
                case Gender.Female: exp = exp.And(e => e.Gender.HasValue && !e.Gender.Value); break;
                case Gender.Male: exp = exp.And(e => e.Gender.HasValue && e.Gender.Value); break;
                case Gender.Unknown: exp = exp.And(e => !e.Gender.HasValue); break;
            }
        }

        var q =
            from o in context.Drivers.Where(exp)
            from r in
                (
                    from x1 in context.CarRentals
                    join x2 in context.Cars on x1.CarId equals x2.Id
                    select new { x1.DriverId, x2.DepartmentId, x2.PlateNumber }
                ).Where(x => x.DriverId == o.Id).DefaultIfEmpty()
            select new
            {
                o.Id,
                o.Name,
                o.Gender,
                o.DayOfBirth,
                DepartmentId = (r == null) ? null : r.DepartmentId,
                PlateNumber = (r == null) ? null : r.PlateNumber,
                o.Enabled,
                Status = string.Empty,
                o.CHNId,
                o.Tel1,
                o.Education,
                o.SocialCat,
                o.Address,
                o.HKAddress,
                o.ModifiedById,
                o.ModifyTime,
                o.Remark,
                Worked = (o.Tel2 != null && o.Tel2 == "1")
            };

        var plateNumber = tb_PlateNumber.Text.ToStringEx();
        var departmentId = pf_DepartmentId.Value;

        if (!string.IsNullOrEmpty(plateNumber))
            q = q.Where(d => d.PlateNumber.Contains(plateNumber));
        if (!string.IsNullOrEmpty(departmentId))
            q = q.Where(d => d.DepartmentId == departmentId);

        // 独立导出数据
        if (section == VisualSections.Export)
        {
            _ExportToExcel("DV", q.Select(o => new
            {
                o.Id,
                o.Name,
                o.Gender,
                o.DayOfBirth,
                o.DepartmentId,
                o.PlateNumber,
                o.Enabled,
                o.CHNId,
                o.Tel1,
                o.Education,
                o.SocialCat,
                o.Address,
                o.HKAddress,
                o.Remark,
                o.Worked

            }).ToList(), new string[]
            {
                "唯一码",
                "姓名",
                "性别",
                "出生日期",
                "部门归属",
                "车牌号码",
                "当前状态",
                "身份证号",
                "联系电话",
                "文化程度",
                "政治面目",
                "常住地址",
                "户口地址",
                "备注"

            }, d => new
            {
                d.Id,
                d.Name,
                Gender = d.Gender.HasValue ? d.Gender.Value ? "男" : "女" : "（未知）",
                DayOfBirth = d.DayOfBirth.ToISDate(),
                Department = Global.Cache.GetDepartment(o => o.Id == d.DepartmentId).Name,
                d.PlateNumber,
                Status = d.Enabled ? string.IsNullOrEmpty(d.DepartmentId) ? d.Worked ? "暂离" : "代班" : "在职" : "离职",
                d.CHNId,
                d.Tel1,
                Education = DefinitionHelper.Caption(Util.ParseEnum<Education>(d.Education, Education.Unknown)),
                SocialCat = DefinitionHelper.Caption(Util.ParseEnum<SocialCat>(d.SocialCat, SocialCat.QZ)),
                d.Address,
                d.HKAddress,
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
        if (section != Actions.Delete &&
            section != Actions.Remove) return;
        var ids = gv.GetSelectedFieldValues("Id");
        ids.ForEach(id =>
        {
            var driverId = id.ToString();
            switch (section)
            {
                case Actions.Delete:
                    _DTService.DeleteDriver(driverId);
                    break;
                case Actions.Remove:
                    _DTService.DisableDriver(driverId);
                    break;
            }
        });
    }

</script>

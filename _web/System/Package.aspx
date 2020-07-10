<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<%@ Register Src="~/_controls.helper/PagingToolbar.ascx" TagPrefix="uc1" TagName="PagingToolbar" %>
<%@ Register Src="~/_controls.helper/Callback.ascx" TagPrefix="uc1" TagName="Callback" %>

<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="../content/scripts/__page.js"></script>
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
                    <td class="name">套餐名称：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Name" Width="100" />
                    </td>
                    <td style="padding-left: 10px;">
                        <dx:ASPxButton ID="bSearch" runat="server" Text="查找">
                            <Image Url="~/images/_op_flatb_search.gif" />
                        </dx:ASPxButton>
                    </td>
                    <td>
                        <dx:ASPxButton ID="bExport" runat="server" Text="导出">
                            <Image Url="~/images/_op_flatb_reply.gif" />
                        </dx:ASPxButton>
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
            <dx:GridViewDataColumn FieldName="Code" Caption="套餐代码" Width="120" VisibleIndex="3" />
            <dx:GridViewDataColumn FieldName="Name" Caption="名称" Width="120" VisibleIndex="4" />
            <dx:GridViewDataColumn FieldName="Deposit" Caption="押金（参考）" Width="80" VisibleIndex="5" />
            <dx:GridViewDataColumn FieldName="Rent" Caption="租金（参考）" Width="80" VisibleIndex="6" />
            <dx:GridViewDataColumn FieldName="AdminFee" Caption="管理费" Width="80" VisibleIndex="7" />
            <dx:GridViewDataColumn FieldName="Premium" Caption="保险" Width="80" VisibleIndex="8" />
            <dx:GridViewDataColumn FieldName="OwnershipPercentage" Caption="模式" Width="80" VisibleIndex="9" />
            <dx:GridViewDataColumn FieldName="ModifiedById" Caption="修改人" Width="100" VisibleIndex="10">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="ModifyTime" Caption="修改日期" Width="130" VisibleIndex="11">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Remark" Caption="说明" VisibleIndex="12" />
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
            .West(true, c => { c.MinSize = c.Size = 100; })
            .CenterTop(true, c => { c.Size = 20; c.AutoHeight = true; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        tb
            .MenuItem("create", "添加", "_op_flatb_add.gif")
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
                        pop.Begin<BaseControl>("~/_controls.sys/package/edit.ascx",
                            null, c =>
                            {
                                c.ViewStateEx.Set<bool>(true, DataStates.IsCreating);
                                c.Execute();
                            }, c =>
                            {
                                c
                                    .Width(450)
                                    .Height(500)
                                    .Title("新套餐")
                                    .Button(BaseControl.EventTypes.Save, b => b.CausesValidation = true)
                                ;
                            });
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
                case "Deposit":
                case "Rent":
                case "AdminFee":
                case "Premium":
                    _Util.Convert<decimal>(e.Value, d => e.DisplayText = d.ToStringOrEmpty(comma: true, emptyValue: "-"));
                    break;
                case "OwnershipPercentage":
                    _Util.Convert<int>(e.Value, d => e.DisplayText = d == 0 ? "租赁" : "已买断");
                    break;
                case "ModifiedById":
                    e.DisplayText = Global.Cache.GetPersonById(e.Value.ToStringEx()).Name;
                    break;
                case "ModifyTime":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDateWithTime(false));
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
            var name = gv.GetSelectedFieldValues("Name")[0].ToStringEx();
            pop.Begin<BaseControl>("~/_controls.sys/package/edit.ascx",
                null, c =>
                {
                    c.ViewStateEx.Set(objectId, DataStates.ObjectId);
                    c.Execute();
                }, c =>
                {
                    c
                        .Width(450)
                        .Height(500)
                        .Title("编辑 - " + name)
                        .Button(BaseControl.EventTypes.Save)
                    ;
                });
        };

        bSearch.Click += (s, e) => Execute();
        bExport.Click += (s, e) => Execute(VisualSections.Export);

        pop.EventSinked += (c, eType, parm) =>
        {
            if (c.ModuleId == Package.Edit)
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Save:
                        if (c.Do(Actions.Save, true))
                        {
                            // _JS.Alert("保存成功。");
                            pop.Close();
                            Execute();
                        }
                        break;
                }
            }
        };

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
            .Back("返回桌面", "../portal/desktop.aspx")
            .Title("基础数据", "经营模式（套餐）管理");

        _Execute(VisualSections.List);
    }
    protected override void _Execute(string section)
    {
        var context = _DTContext<CommonContext>(true);
        var exp = PredicateBuilder.True<TB_package>();
        exp = exp.And(p => p.Enabled);
        exp = exp.Append(tb_Name.Text.Trim(), v => exp.And(e => e.Name.Contains(v)));

        var q =
            from p in context.Packages.Where(exp)
            select new
            {
                p.Id,
                p.Code,
                p.Name,
                p.OwnershipPercentage,
                p.Deposit,
                p.Rent,
                p.Premium,
                p.AdminFee,
                p.DriverCount,
                p.ModifiedById,
                p.ModifyTime,
                p.Remark
            };

        // 独立导出数据
        if (section == VisualSections.Export)
        {
            _ExportToExcel("PG", q.Select(o => new
            {
                o.Id,
                o.Code,
                o.Name,
                o.ModifiedById,
                o.ModifyTime,
                o.Remark

            }).ToList(), new string[]
            {
                "唯一码",
                "套餐编号",
                "名称",
                "修改人",
                "修改时间",
                "备注"

            }, d => new
            {
                d.Id,
                d.Code,
                d.Name,
                Modifier = Global.Cache.GetPerson(p => p.Id == d.ModifiedById).Name,
                ModifyTime = d.ModifyTime.ToISDateWithTime(),
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
        var context = _DTService.Context;
        var packages = context.Packages.Where(p => ids.Contains(p.Id)).ToList();
        ids.ForEach(id =>
        {
            var packageId = id.ToString();
            _DTService.DeletePackage(packageId);
        });
        Global.Cache.SetDirty(CachingTypes.Package);
    }

</script>

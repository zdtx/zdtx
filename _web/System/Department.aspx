<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
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
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:DXGridWrapper runat="server" ID="gw" />
    <dx:ASPxGridView ID="gv" runat="server" KeyFieldName="Id" Width="100%">
        <Border BorderStyle="None" />
        <SettingsBehavior ColumnResizeMode="NextColumn" EnableRowHotTrack="true" />
        <Columns>
            <dx:GridViewDataColumn FieldName="Id" Visible="false" />
            <dx:GridViewDataColumn FieldName="Name" Caption="部门名称" Width="250" VisibleIndex="3">
                <CellStyle Wrap="False" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Ordinal" Caption="同层排序" Width="100" VisibleIndex="4" />
            <dx:GridViewDataColumn FieldName="ModifiedById" Caption="修改人" Width="100" VisibleIndex="5">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="ModifyTime" Caption="修改日期" Width="130" VisibleIndex="6">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Description" Caption="说明" VisibleIndex="7" />
        </Columns>
    </dx:ASPxGridView>
    <div class="darkBar">
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
            .CenterTop(true, c => { c.MaxSize = c.Size = 28; c.AutoHeight = false; })
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
case'create':ISEx.loadingPanel.show();break; 
}}}}"))
            .ItemClick += (s, e) =>
            {
                switch (e.Item.Name)
                {
                    case "create":
                        pop.Begin<BaseControl>("~/_controls.sys/department/edit.ascx",
                            null, c =>
                            {
                                c.ViewStateEx.Set<bool>(true, DataStates.IsCreating);
                                c.Execute();
                            }, c =>
                            {
                                c
                                    .Width(450)
                                    .Height(400)
                                    .Title("新部门")
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
                case "Name":
                    var dept = e.GetFieldValue("Dept").ToStringEx();
                    var img = _Util.Convert<bool>(e.GetFieldValue("HasChildren")) ?
                        "../images/icon_folder_open.gif" : "../../images/icon_folder_close.gif";
                    e.EncodeHtml = false;
                    e.DisplayText = string.Format(
@"<div style='padding-left:{2}0px;'>
<img src='{0}'/>&nbsp;{1}
</div>", img, e.Value, dept);
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

        gw.RowDblClick += (s, e) =>
        {
            if (gv.Selection.Count != 1) return;
            var objectId = gv.GetSelectedFieldValues("Id")[0].ToStringEx();
            var name = gv.GetSelectedFieldValues("Name")[0].ToStringEx();
            pop.Begin<BaseControl>("~/_controls.sys/department/edit.ascx",
                null, c =>
                {
                    c.ViewStateEx.Set(objectId, DataStates.ObjectId);
                    c.Execute();
                }, c =>
                {
                    c
                        .Width(450)
                        .Height(400)
                        .Title("编辑 - " + name)
                        .Button(BaseControl.EventTypes.Save)
                    ;
                });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            if (c.ModuleId == Department.Edit)
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Save:
                        if (c.Do(Actions.Save, true))
                        {
                            _JS.Alert("保存成功。");
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
            .Title("基础数据", "部门管理");

        var context = _DTContext<CommonContext>(true);
        var exp = PredicateBuilder.True<TB_department>();
        var data = (
            from o in context.Departments.Where(exp)
            orderby o.Path + o.Id, o.Ordinal, o.Name
            select new
            {
                o.Id,
                o.ParentId,
                o.Path,
                o.Name,
                o.Ordinal,
                o.Description,
                o.ModifiedById,
                o.ModifyTime
            }).ToList();

        var final = TreeUtil<TB_department>.Visit(data, null, d => d.Id, d => d.ParentId, d =>
        {
            var f = new TB_department();
            d.FlushTo(f);
            return f;
        }, sl => sl.OrderBy(c => c.Ordinal).ThenBy(c => c.Name).ToList());

        gv.DataSource = final;
        gv.DataBind();
        gv.Selection.UnselectAll();

    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Delete) return;
        var ids = gv.GetSelectedFieldValues("Id");
        ids.ForEach(id =>
        {
            var departmentId = id.ToString();
            _DTService.DeleteDepartment(departmentId);
            _RoleProvider.DeleteRole(departmentId, false);
        });
        Global.Cache.SetDirty(CachingTypes.Department);
    }

</script>

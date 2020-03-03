<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Definitions.Module" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="../content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="N" ContentPlaceHolderID="N">
    <uc1:HeaderInfo runat="server" ID="hi" />
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <asp:Panel runat="server" ID="pT" CSSClass="filterTb">
        <div class="inner">
            <table>
                <tr>
                    <td class="name">类别：
                    </td>
                    <td class="cl">
                        <dx:ASPxComboBox runat="server" ID="cbType" Width="100" AutoPostBack="true">
                            <Items>
                                <dx:ListEditItem Text="（全部）" Value="0" Selected="true" />
                                <dx:ListEditItem Text="功能" Value="1" />
                                <dx:ListEditItem Text="信息块" Value="2" />
                            </Items>
                        </dx:ASPxComboBox>
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
            <dx:GridViewDataColumn FieldName="Folder" Visible="false" Caption="模块" />
            <dx:GridViewDataColumn FieldName="SubFolder" Caption="子模块" Width="60" VisibleIndex="3" />
            <dx:GridViewDataColumn FieldName="Name" Caption="功能" Width="150" VisibleIndex="4" />
            <dx:GridViewDataColumn FieldName="Path" Caption="地址" Width="300" VisibleIndex="5">
                <CellStyle Wrap="False" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="IsPage" Caption="功能/信息块" Width="80" VisibleIndex="6" />
            <dx:GridViewDataColumn FieldName="Ordinal" Caption="同层排序" Width="60" VisibleIndex="7">
                <HeaderStyle HorizontalAlign="Right" />
                <CellStyle HorizontalAlign="Right" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Remark" Caption="备注" VisibleIndex="9" />
        </Columns>
        <ClientSideEvents
            RowCollapsing="function(s,e){e.cancel=true;}" />
    </dx:ASPxGridView>
</asp:Content>
<asp:Content runat="server" ID="W" ContentPlaceHolderID="W">
    <div style="padding:10px;text-align:center">
        <dx:ASPxButton runat="server" Text="刷新" ID="bRefresh" ImagePosition="Top">
            <Image Url="~/images/_op_flatb_refresh.gif" />
            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
        </dx:ASPxButton>
    </div>
</asp:Content>
<script runat="server">

    private DefinitionItemHelper<Folder> _FolderHelper = new DefinitionItemHelper<Folder>();
    private DefinitionItemHelper<SubFolder> _SubFolderHelper = new DefinitionItemHelper<SubFolder>();
    protected override bool _PACK_0001 { get { return true; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => { c.MaxSize = c.Size = 30; c.AutoHeight = false; })
            .West(true, c => { c.MinSize = c.MaxSize = c.Size = 100; })
            .CenterTop(true, c => { c.Size = 28; c.AutoHeight = true; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        cbType.SelectedIndexChanged += (s, e) => Execute();
        bRefresh.Click += (s, e) =>
        {
            if (Do(Actions.Syn, true)) Execute();
        };

        gw.Initialize(gv, d =>
        {
            d
                .ShowRowNumber()
                //.ShowCheckAll()
            ;
        });

        gv.GroupBy(gv.Columns["Folder"]);
        gv.BeforeColumnSortingGrouping += (s, e) => { Execute(); };
        gv.CustomColumnDisplayText += (s, e) =>
        {
            switch (e.Column.FieldName)
            {
                case "Folder":
                    _FolderHelper
                        .GetItem(i => e.Value.ToStringEx().EndsWith(i.Value))
                        .IfNN(i => e.DisplayText = i.Caption);
                    break;
                case "SubFolder":
                    _SubFolderHelper
                        .GetItem(i => i.Value == e.Value.ToStringEx())
                        .IfNN(i => e.DisplayText = i.Caption, () => { e.DisplayText = " - "; });
                    break;
                case "IsPage":
                    e.DisplayText = _Util.Convert<bool>(e.Value, true) ? "功能" : "信息块";
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
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../portal/desktop.aspx")
            .Title("基础数据", "模块管理");

        var context = _DTContext<CommonContext>(true);
        var exp = PredicateBuilder.True<TB_sys_module>();
        switch (_Util.Convert<int>(cbType.Value))
        {
            case 1:
                exp = exp.And(e => e.IsPage);
                break;
            case 2:
                exp = exp.And(e => !e.IsPage);
                break;
        }
        
        var data = (
            from o in context.Modules.Where(exp)
            where o.Enabled
            select new
            {
                o.Id,
                o.Folder,
                o.SubFolder,
                o.Name,
                o.Path,
                o.IsPage,
                o.Ordinal
            }).ToList();

        var final = new List<TB_sys_module>();
        data.ForEach(d =>
        {
            var dd = new TB_sys_module();
            d.FlushTo(dd);
            _FolderHelper
                .GetItem(i => i.Value == dd.Folder)
                .IfNN(i => dd.Folder = i.Ordinal.ToString() + "." + dd.Folder);
            final.Add(dd);
        });

        gv.DataSource = final.OrderBy(f => f.Folder).ThenBy(f => f.Ordinal);
        gv.DataBind();
        gv.Selection.UnselectAll();
        gv.ExpandAll();
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Syn) return;
        Util.SynModules(msg => _JS.Alert(msg));
        Global.Cache.SetDirty(CachingTypes.Module);
    }
    
</script>

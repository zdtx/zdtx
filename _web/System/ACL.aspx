<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Definitions.Module" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls.helper/GridWrapperForList.ascx" TagPrefix="uc1" TagName="GridWrapperForList" %>
<%@ Register Src="~/_controls.sys/ACL/Edit.ascx" TagPrefix="uc1" TagName="Edit" %>
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
    <div class="actionTB" style="padding-left: 1px;">
        <dx:ASPxMenu runat="server" ID="tb" CssClass="dxTb" Visible="false" />
        <asp:Panel runat="server" ID="pTips" style="padding:5px;">
            （请选择 部门 和 人员）
        </asp:Panel>
    </div>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:Edit runat="server" id="u" Visible="false" />
</asp:Content>
<asp:Content runat="server" ID="W" ContentPlaceHolderID="W">
<uc1:GridWrapperForList runat="server" ID="gw" />
    <div class="filterTb-L">
        <table>
            <tr>
                <td>选择部门：</td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbDepartment" AutoPostBack="true" />
                </td>
            </tr>
        </table>
    </div>
    <div style="padding-top:5px;padding-left:5px;padding-bottom:5px;">
        <asp:GridView runat="server" ID="gv" Width="100%">
            <SelectedRowStyle CssClass="gridRow-selected" />
            <HeaderStyle CssClass="gridHeader" />
            <EmptyDataTemplate>
                <div class="emptyData">
                    （空）
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
<script runat="server">

    private string _PersonId
    {
        get { return _ViewStateEx.Get<string>("personId", string.Empty); }
        set { _ViewStateEx.Set<string>(value, "personId"); }
    }

    private DefinitionItemHelper<Folder> _FolderHelper = new DefinitionItemHelper<Folder>();
    private DefinitionItemHelper<SubFolder> _SubFolderHelper = new DefinitionItemHelper<SubFolder>();
    protected override bool _PACK_0001 { get { return true; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => { c.MaxSize = c.Size = 30; c.AutoHeight = false; })
            .West(true, c => { c.Size = 300; })
            .CenterTop(true, c => { c.MaxSize = c.Size = 28; c.AutoHeight = false; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        cbDepartment.SelectedIndexChanged += (s, e) => Execute(VisualSections.List);
        gw.RowButtonVisible = false;
        gw.Initialize(gv, c => c
            .TemplateField("Id", string.Empty, new TemplateItem.Label(), f =>
                {
                    f.Visible = false;
                })
            .TemplateField("Name", "姓名", new TemplateItem.Label(), f =>
                {
                    f.HeaderStyle.Width = f.ItemStyle.Width = 150;
                    f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                })
            .TemplateField("Gender", "性别", new TemplateItem.Label(), f =>
                {
                    f.HeaderStyle.Width = f.ItemStyle.Width = 50;
                    f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                }), null, r =>
                {
                    //r.Row.CssClass = "gridRow-selected";
                    r.Visit<Label>("Id", l =>
                    {
                        _PersonId = l.Text;
                        Execute(VisualSections.Detail);
                    });
                }, GridWrapper.SelectionMode.Single);

        tb
            .MenuItem("create", "赋权", "_op_flatb_add.gif")
            .MenuItem("delete", "回收权限", "_op_flatb_delete.gif", i => { i.BeginGroup = true; })
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
                        if (u.Do(Actions.Create, true)) u.Execute();
                        break;
                    case "delete":
                        if (u.Do(Actions.Delete, true)) u.Execute();
                        break;
                }
            };        
    
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../portal/desktop.aspx")
            .Title("基础数据", "权限管理");

        var data = TreeUtil<TB_department>.Visit(Global.Cache.Departments, null, d => d.Id, d => d.ParentId, d =>
        {
            var f = new TB_department();
            d.FlushTo(f);
            return f;
        }, sl => sl.OrderBy(c => c.Ordinal).ThenBy(c => c.Name).ToList());

        cbDepartment.Items.Clear();
        cbDepartment.FromList(data, (d, i) =>
        {
            i.Text = "  ".Repeat(d.ParentIds.Length) + d.Name;
            i.Value = d.Id;
            return true;
        });

        _PersonId = null;
        _Execute(VisualSections.List);
        _Execute(VisualSections.Detail);
        
    }

    protected override void _Execute(string section)
    {
        var context = _DTContext<CommonContext>(true);
        if (section == VisualSections.List)
        {
            var departmentId = cbDepartment.Value.ToStringEx();
            var persons = (
                from p in context.Persons
                from u in context.AS_Users.Where(u => u.UserId == p.UniqueId).DefaultIfEmpty()
                where p.DepartmentId == departmentId
                select new
                {
                    p.Id,
                    p.Name,
                    p.Gender,
                    p.DayOfBirth,
                    p.CHNId,
                    UserName = u == null ? "（未创建）" : u.UserName
                }).ToList();

            gw.Execute(persons, b => b
                .Do<Label>("Id", (l, d) => l.Text = d.Id)
                .Do<Label>("Name", (l, d) =>
                    {
                        l.Text = string.Format("{0} [用户：{1}]", d.Name, d.UserName);
                    })
                .Do<Label>("Gender", (l, d) =>
                    {
                        l.Text = d.Gender.HasValue ? d.Gender.Value ? "男" : "女" : "（未知）";
                    })
                );
            
            return;
        }

        if (section == VisualSections.Detail)
        {
            tb.Visible = u.Visible = !string.IsNullOrEmpty(_PersonId);
            pTips.Visible = !tb.Visible;
            u
                .Import(_PersonId, DataStates.ObjectId)
                .Execute();
            
            return;
        }
    }
    
    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Syn) return;
        Util.SynModules(msg => _JS.Alert(msg));
    }
    
</script>

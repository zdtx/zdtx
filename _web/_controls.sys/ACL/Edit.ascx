<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Definitions.Module" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<div class="title" style="margin-top:5px;">
    注意：当前展示
    <span class="fonRed">
        <b>
            <asp:Literal runat="server" ID="lCurrent" />
        </b>
    </span>
    的权限分配情况
</div>
<uc1:DXGridWrapper runat="server" ID="gw" />
<dx:ASPxGridView ID="gv" runat="server" KeyFieldName="Id" Width="100%">
    <Border BorderStyle="None" />
    <SettingsBehavior EnableRowHotTrack="true" ColumnResizeMode="NextColumn" />
    <Columns>
        <dx:GridViewDataColumn FieldName="Id" Visible="false" />
        <dx:GridViewDataColumn FieldName="Folder" Visible="false" Caption="模块" />
        <dx:GridViewDataColumn FieldName="SubFolder" Caption="子模块" Width="60" VisibleIndex="3" />
        <dx:GridViewDataColumn FieldName="Name" Caption="功能" Width="150" VisibleIndex="4" />
        <dx:GridViewDataColumn FieldName="IsPage" Caption="功能/信息块" Width="80" VisibleIndex="6" />
        <dx:GridViewDataColumn FieldName="Enabled" Caption="赋权情况" VisibleIndex="7" />
    </Columns>
    <ClientSideEvents
        RowCollapsing="function(s,e){e.cancel=true;}" />
</dx:ASPxGridView>
<script runat="server">

    private DefinitionItemHelper<Folder> _FolderHelper = new DefinitionItemHelper<Folder>();
    private DefinitionItemHelper<SubFolder> _SubFolderHelper = new DefinitionItemHelper<SubFolder>();
    public override string ModuleId { get { return ACL.Edit; } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, d =>
        {
            d
                .ShowRowNumber()
                .ShowCheckAll()
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
                case "Enabled":
                    if (_Util.Convert<bool>(e.Value, false))
                    {
                        e.DisplayText = "已赋";
                    }
                    else
                    {
                        e.DisplayText = "未赋";
                    }
                    break;
            }
        };
        gv.HtmlRowPrepared += (s, e) =>
        {
            if (e.RowType == GridViewRowType.Data)
            {
                var enabled = (bool)e.GetValue("Enabled");
                if (enabled)
                {
                    e.Row.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    e.Row.ForeColor = System.Drawing.Color.Red;
                }
            }
        };
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        context.Persons.SingleOrDefault(o => o.Id == _ObjectId).IfNN(person =>
            {
                lCurrent.Text = string.Format(" {0} [- {1} -] ", person.Name,
                    Global.Cache.GetDepartment(d => d.Id == person.DepartmentId).Name);
            });
        
        var acls = context.ACLs.Where(a => a.ActorId == _ObjectId).ToList();
        var data = (
            from o in Global.Cache.Modules
            select new
            {
                o.Id,
                o.Folder,
                o.SubFolder,
                o.Name,
                o.IsPage,
                o.Ordinal,
                o.Enabled
            }).ToList();

        var final = new List<TB_sys_module>();
        data.ForEach(d =>
        {
            var dd = new TB_sys_module();
            d.FlushTo(dd);
            _FolderHelper
                .GetItem(i => i.Value == dd.Folder)
                .IfNN(i => dd.Folder = i.Ordinal.ToString() + "." + dd.Folder);
            dd.Enabled = false;
            acls.SingleOrDefault(a => a.ModuleId == dd.Id).IfNN(a =>
            {
                dd.Enabled = !a.IsForbidden;
            });
            final.Add(dd);
        });

        gv.DataSource = final.OrderBy(f => f.Folder).ThenBy(f => f.Ordinal);
        gv.DataBind();
        gv.Selection.UnselectAll();
        gv.ExpandAll();
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Create &&
            section != Actions.Delete) return;
        if (gv.Selection.Count == 0)
        {
            Alert("请选择要赋的模块（勾选行首的方格）");
            return;
        }

        var context = _DTService.Context;
        var moduleIds = gv.GetSelectedFieldValues("Id");
        if (section == Actions.Delete)
        {
            moduleIds.ForEach(obj =>
            {
                var moduleId = new Guid(obj.ToString());
                context
                    .DeleteAll<TB_sys_acl>(a => a.ActorId == _ObjectId && a.ModuleId == moduleId)
                    .SubmitChanges();
                
            });
            return;
        }

        if (section == Actions.Create)
        {
            moduleIds.ForEach(obj =>
            {
                var moduleId = new Guid(obj.ToString());
                context
                    .CreateWhenNotExists<TB_sys_acl>(_SessionEx,
                        a => a.ActorId == _ObjectId && a.ModuleId == moduleId, (a, isNew) =>
                        {
                            if (!isNew) return;
                            a.ActorId = _ObjectId;
                            a.ModuleId = moduleId;
                        })
                    .SubmitChanges();
            });
            return;            
        }
    }

</script>

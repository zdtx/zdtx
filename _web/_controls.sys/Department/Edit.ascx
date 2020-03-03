<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/DropDownField_DX.ascx" TagPrefix="uc1" TagName="DropDownField_DX" %>

<uc1:FormHelper runat="server" ID="fh" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title">
                    基本信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">（系统唯一码）
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Id" />
            </td>
        </tr>
        <tr>
            <td class="name">命名
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Name" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">父部门
            </td>
            <td class="cl">
                <uc1:DropDownField_DX runat="server" ID="df_Parent" Width="200"
                    HeaderText="选择部门" ShowEdit="true" NullText="（无）" />
            </td>
        </tr>
        <tr>
            <td class="name">排序
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Ordinal" Width="200" NumberType="Integer"
                    HelpText="注：值越小，排序越靠前。">
                    <SpinButtons ShowIncrementButtons="false" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">说明
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Description" Width="300" Rows="5" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public override string ModuleId { get { return Department.Edit; } }
    private bool _IsCreating { get { return _ViewStateEx.Get<bool>(DataStates.IsCreating, false); } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_Name).IsRequired();
        df_Parent.BE.HelpText = "注：若留空，则作为根部门。";
        df_Parent.Initialize<eTaxi.Web.Controls.Selection.Department.TreeItem>(
            "~/_controls.helper/selection/department/treeitem.ascx", (c, b, h) =>
            {
                b.Text = c.Selection[0].Name;
                h.Value = c.Selection[0].Id;
                return true;
            });
    }

    protected override void _Execute()
    {
        tb_Name.Focus();
        if (_IsCreating)
        {
            p.Controls.PresentedBy(new TB_department(), (d, n, c) =>
            {
            }, recursive: false);
            l_Id.Text = "（保存后系统自动生成）";
            return;
        }

        // 修改
        var context = _DTContext<CommonContext>(true);
        var id = _ViewStateEx.Get<string>(DataStates.ObjectId, exceptionIfInvalid: true);
        context.Single<TB_department>(r => r.Id == id,
            department => p.Controls.PresentedBy(department, (d, n, c) =>
            {
            }, recursive: false));
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        if (_IsCreating) _Do_Create(); else _Do_Update();
    }

    private void _Do_Create()
    {
        var context = _DTService.Context;
        var newId = string.Empty;
        context
            .NewSequence<TB_department>(_SessionEx, (seq, id) =>
                {
                    newId = id;
                })
            .Create<TB_department>(_SessionEx, department =>
                {
                    _Util.FillObject(p.Controls, department, recursive: false);
                    department.Id = newId;
                    context.ResolveParent(department, df_Parent.Value);
                    _RoleProvider.CreateRole(newId);
                })
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.Department);
    }

    private void _Do_Update()
    {
        var context = _DTService.Context;
        context
            .Update<TB_department>(_SessionEx, r => r.Id == _ObjectId,
                department =>
                {
                    _Util.FillObject(p.Controls, department, recursive: false);
                    context.ResolveParent(department, df_Parent.Value);
                })
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.Department);
    }
    
</script>

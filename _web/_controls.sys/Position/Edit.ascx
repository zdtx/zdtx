<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
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
            <td class="name">行政级别
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_RankId" Width="200" />
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

    public override string ModuleId { get { return Position.Edit; } }
    private bool _IsCreating { get { return _ViewStateEx.Get<bool>(DataStates.IsCreating, false); } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(cb_RankId).IsRequired();
        cb_RankId.FromList(Global.Cache.Ranks, (d, i) =>
            {
                i.Text = string.Format("{0} [{1}]", d.Name, d.Value);
                i.Value = d.Id;
                return true;
            });
    }

    protected override void _Execute()
    {
        tb_Name.Focus();
        if (_IsCreating)
        {
            p.Controls.PresentedBy(new TB_position(), (d, n, c) =>
            {
            }, recursive: false);
            l_Id.Text = "（保存后系统自动生成）";
            return;
        }

        // 修改
        var context = _DTContext<CommonContext>(true);
        var id = _ViewStateEx.Get<string>(DataStates.ObjectId, exceptionIfInvalid: true);
        context.Single<TB_position>(r => r.Id == id,
            position => p.Controls.PresentedBy(position, (d, n, c) =>
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
            .NewSequence<TB_position>(_SessionEx, (seq, id) =>
                {
                    newId = id;
                })
            .Create<TB_position>(_SessionEx, position =>
                {
                    _Util.FillObject(p.Controls, position, recursive: false);
                    position.Id = newId;
                    _RoleProvider.CreateRole(newId);
                })
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.Position);
    }

    private void _Do_Update()
    {
        var context = _DTService.Context;
        context
            .Update<TB_position>(_SessionEx, r => r.Id == _ObjectId,
                position => _Util.FillObject(p.Controls, position, recursive: false))
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.Position);
    }
    
</script>

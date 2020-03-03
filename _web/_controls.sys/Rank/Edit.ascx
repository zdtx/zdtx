﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
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
            <td class="name">取值
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Value" Width="200"
                    NullText="越大行政级别越高" NumberType="Integer">
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

    public override string ModuleId { get { return Rank.Edit; } }
    private bool _IsCreating { get { return _ViewStateEx.Get<bool>(DataStates.IsCreating, false); } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(sp_Value).IsRequired();
    }

    protected override void _Execute()
    {
        tb_Name.Focus();
        if (_IsCreating)
        {
            p.Controls.PresentedBy(new TB_rank(), (d, n, c) =>
            {
            }, recursive: false);
            l_Id.Text = "（保存后系统自动生成）";
            return;
        }

        // 修改
        var context = _DTContext<CommonContext>(true);
        var id = _ViewStateEx.Get<string>(DataStates.ObjectId, exceptionIfInvalid: true);
        context.Single<TB_rank>(r => r.Id == id,
            rank => p.Controls.PresentedBy(rank, (d, n, c) =>
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
            .NewSequence<TB_rank>(_SessionEx, (seq, id) =>
            {
                newId = id;
            })
            .Create<TB_rank>(_SessionEx, rank =>
            {
                _Util.FillObject(p.Controls, rank, recursive: false);
                rank.Id = newId;
                if (!
                    context.AS_Roles.Any(r => r.RoleName == newId))
                    _RoleProvider.CreateRole(newId);
            })
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.Rank);
    }

    private void _Do_Update()
    {
        var context = _DTService.Context;
        context
            .Update<TB_rank>(_SessionEx, r => r.Id == _ObjectId,
                rank => _Util.FillObject(p.Controls, rank, recursive: false))
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.Rank);
    }

</script>

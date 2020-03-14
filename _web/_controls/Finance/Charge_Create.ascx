<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/PopupField_DX.ascx" TagPrefix="uc1" TagName="PopupField_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
<uc1:FormHelper runat="server" ID="fh" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title">
                    新建结算项
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
            <td class="name">编号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Code" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">名称
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Name" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">收取模式
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Type" Width="200" AutoPostBack="true" />
            </td>
        </tr>
        <tr>
            <td class="name">类型
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_IsNegative" Width="200">
                    <Items>
                        <dx:ListEditItem Text="收" Value="0" />
                        <dx:ListEditItem Text="付" Value="1" />
                    </Items>
                </dx:ASPxComboBox>
            </td>
        </tr>
        <tr>
            <td class="name">金额
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Amount" Width="200"
                    NullText="请输入金额"
                    DisplayFormatString="{0:N} 元" MaxValue="1000000" MinValue="0">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr runat="server" id="trSpecifiedMonth" visible="false">
            <td class="name">收取月份
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_SpecifiedMonth" Width="200" 
                    NullText="指定收取月份" />
            </td>
        </tr>
        <tr>
            <td class="name">备注
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Remark" Width="300" Rows="5" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public override string ModuleId { get { return Finance.Charge_Create; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(cb_Type).IsRequired();
        fh.Validate(tb_Name).IsRequired();

        cb_Type.FromEnum<ChargeType>(valueAsInteger: true);
        cb_SpecifiedMonth.FromEnum<MonthType>(valueAsInteger: true);

        cb_Type.SelectedIndexChanged += (s, e) =>
        {
            _Util.Convert<ChargeType>(cb_Type.Value, d =>
            {
                trSpecifiedMonth.Visible = d == ChargeType.Yearly;
            });
        };

    }

    protected override void _Execute()
    {
        p.Controls.PresentedBy(new TB_charge(), (d, n, c) =>
        {
            cb_IsNegative.Value = d.IsNegative ? "0" : "1";

        }, recursive: false);
        l_Id.Text = "（保存后系统自动生成）";
        tb_Code.Focus();
    }

    protected override void _Do(string section, string subSection = null)
    {
        switch (section)
        {
            case Actions.Save:
                _Do_Save();
                break;
        }
    }

    private void _Do_Save()
    {
        var context = _DTService.Context;
        var newId = string.Empty;
        context
            .NewSequence<TB_charge>(_SessionEx, (seq, id) =>
            {
                newId = id;
            })
            .Create<TB_charge>(_SessionEx, charge =>
            {
                _Util.FillObject(p.Controls, charge, recursive: false);
                charge.Id = newId;
                if (charge.Type != (int)ChargeType.Yearly) charge.SpecifiedMonth = 0;
                charge.IsNegative = _Util.Convert<bool>(cb_IsNegative.Value, false);
            })
            .SubmitChanges();
    }

</script>

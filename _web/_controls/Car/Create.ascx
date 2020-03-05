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
            <td class="name">车牌号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_PlateNumber" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">原车牌号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_FormerPlateNum" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆单位
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Company" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">发动机号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_EngineNum" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车架号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_CarriageNum" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆品牌
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Manufacturer" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆型号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Model" Width="200" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top: 15px;">
                    管理信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">经营模式（套餐）
            </td>
            <td class="cl">
                <uc1:PopupField_DX runat="server" ID="pf_PackageId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">管理费
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Rental" Width="200"
                    NullText="请输入月度管理费金额"
                    DisplayFormatString="{0:N} 元" MaxValue="1000000" MinValue="0">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">车辆性质
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Type" Width="200" 
                    NullText="请选择车辆性质" />
            </td>
        </tr>
        <tr>
            <td class="name">获得方式
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Source" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">部门归属
            </td>
            <td class="cl">
                <uc1:PopupField_DX runat="server" ID="pf_DepartmentId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车队
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Fleet" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">治安证号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_SecSerialNum" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">营运证号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_License" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">营审到期日
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_LicenseRenewTime" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">行驶证号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_DrvLicense" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">行审到期日
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_DrvLicenseRenewTime" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">交接班地点
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_HandOverPlace" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">交接班时间
            </td>
            <td class="cl">
                <dx:ASPxTimeEdit runat="server" ID="te_HandOverTime" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">承保公司
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_InsuranceCom" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">保单号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_InsuranceTransCode" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">保险到期日
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_InsuranceEnd" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">保险费用
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Premium" Width="200"
                    NullText="请输入年度保险缴费金额"
                    DisplayFormatString="{0:N} 元" MaxValue="1000000" MinValue="0">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">定点维修公司
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_ServiceCom" Width="200" />
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

    public override string ModuleId { get { return Car.Create; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_PlateNumber).IsRequired();
        fh.Validate(tb_Manufacturer).IsRequired();
        fh.Validate(tb_Model).IsRequired();
        fh.Validate(cb_Type).IsRequired();
        fh.Validate(tb_Source).IsRequired();
        fh.Validate(tb_EngineNum).IsRequired();
        fh.Validate(tb_Company).IsRequired();
        fh.Validate(sp_Rental).IsRequired();
        fh.Validate(tb_Fleet).IsRequired();
        fh.Validate(de_LicenseRenewTime).IsRequired();
        fh.Validate(tb_License).IsRequired();
        fh.Validate(de_DrvLicenseRenewTime).IsRequired();
        fh.Validate(tb_DrvLicense).IsRequired();
        fh.Validate(pf_DepartmentId).IsRequired();
        fh.Validate(pf_PackageId).IsRequired();
        fh.Validate(de_InsuranceEnd).IsRequired();
        fh.Validate(tb_CarriageNum).IsRequired();
        fh.Validate(tb_InsuranceCom).IsRequired();
        fh.Validate(tb_SecSerialNum).IsRequired();
        cb_Type.FromEnum<CarType>(valueAsInteger: true);
        pf_DepartmentId.Initialize<eTaxi.Web.Controls.Selection.Department.TreeItem>(pop,
            "~/_controls.helper/selection/department/treeitem.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择车辆的营运部门";
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
        pf_PackageId.Initialize<eTaxi.Web.Controls.Selection.Package.Item>(pop,
            "~/_controls.helper/selection/package/item.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择车辆的经营模式（套餐）";
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

    }

    protected override void _Execute()
    {
        p.Controls.PresentedBy(new TB_car(), (d, n, c) =>
        {
            
        }, recursive: false);
        l_Id.Text = "（保存后系统自动生成）";
        tb_PlateNumber.Focus();
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
            .NewSequence<TB_car>(_SessionEx, (seq, id) =>
                {
                    newId = id;
                })
            .Create<TB_car>(_SessionEx, car =>
                {
                    _Util.FillObject(p.Controls, car, recursive: false);
                    car.Id = newId;
                    car.DepartmentId = "0001";
                    
                    // 处理交接班时间（补齐年月日）
                    if (!string.IsNullOrEmpty(te_HandOverTime.Value.ToStringEx()))
                    {
                        car.HandOverTime = 
                            new DateTime(2000, 1,1).Add(((DateTime)te_HandOverTime.Value).TimeOfDay);
                    }
                })
            .SubmitChanges();
    }
    
</script>

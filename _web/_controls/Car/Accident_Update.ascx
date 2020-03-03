﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
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
                    交通事故登记
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">案卷编号（车辆系统唯一码）
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Id" />
            </td>
        </tr>
        <tr>
            <td class="name">车牌号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_PlateNumber" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆单位
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Company" />
            </td>
        </tr>
        <tr id="tr" runat="server" visible="false">
            <td colspan="2" class="tips" style="padding:5px;">
                <asp:Label runat="server" ID="lb" ForeColor="Red" />
            </td>
        </tr>
        <tr>
            <td class="name">当事司机
            </td>
            <td class="cl">
                <asp:Literal runat="server" ID="l_Driver" />
            </td>
        </tr>
        <tr>
            <td class="name">责任划分
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_RespLevel" Width="200" 
                    NullText="责任划分" />
            </td>
        </tr>
        <tr>
            <td class="name">发生时间
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_Time" Width="200" 
                    DisplayFormatString="yyyy-MM-dd HH:mm" EditFormatString="yyyy-MM-dd HH:mm">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                    <TimeSectionProperties Visible="true"></TimeSectionProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">发生地点
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Place" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">摘要
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Name" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">事情经过
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Description" Width="300" Rows="5" />
            </td>
        </tr>
        <tr>
            <td class="name">现场协调处理人
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Coordinator" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">维修公司
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_ServiceCom" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">赔付金额
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Claim" Width="200"
                    NullText="请输入赔付金额"
                    DisplayFormatString="{0:N} 元" MaxValue="1000000" MinValue="0">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public string CarId
    {
        get { return _ViewStateEx.Get<string>("carId"); }
        set { _ViewStateEx.Set<string>(value, "carId"); }
    }

    public string AccidentId
    {
        get { return _ViewStateEx.Get<string>("accidentId"); }
        set { _ViewStateEx.Set<string>(value, "accidentId"); }
    }

    public override string ModuleId { get { return Car.Accident_Edit; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(cb_RespLevel).IsRequired();
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(tb_Place).IsRequired();
        fh.Validate(mm_Description).IsRequired();
        fh.Validate(de_Time).IsRequired();
        cb_RespLevel.FromEnum<AccidentFaultLevel>(valueAsInteger: true);
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var accident = context.CarAccidents.SingleOrDefault(a => a.CarId == CarId && a.Id == AccidentId);
        if (accident == null) throw DTException.NotFound<TB_car_accident>(AccidentId);

        var car = context.Cars.SingleOrDefault(c => c.Id == CarId);
        var driver = context.Drivers.SingleOrDefault(d => d.Id == accident.DriverId);
        if (car == null) throw DTException.NotFound<Car>(CarId);
        if (driver == null) throw DTException.NotFound<Car>(accident.DriverId);

        l_Id.Text = car.Id;
        l_Company.Text = car.Company;
        l_PlateNumber.Text = car.PlateNumber;
        l_Driver.Text = driver.Name;

        p.Controls.PresentedBy(accident);
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        var context = _DTContext<CommonContext>();
        context
            .Update<TB_car_accident>(_SessionEx, a => a.CarId == CarId && a.Id == AccidentId, o =>
                {
                    o.Time = de_Time.Date;
                    o.RespLevel = cb_RespLevel.Value.ToStringEx().ToIntOrDefault(-1);
                    o.Status = (int)IssueStatus.Pending;
                    o.Place = tb_Place.Text;
                    o.Name = tb_Name.Text;
                    o.Description = mm_Description.Text;
                    o.Coordinator = tb_Coordinator.Text;
                    o.ServiceCom = tb_ServiceCom.Text;
                    if (!
                        string.IsNullOrEmpty(sp_Claim.Value.ToStringEx()))
                        o.Claim = sp_Claim.Number;
                })
            .SubmitChanges();
    }

</script>

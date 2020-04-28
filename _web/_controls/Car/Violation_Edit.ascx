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
                    违章违纪登记
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">（车辆系统唯一码）
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
                <dx:ASPxComboBox runat="server" ID="cb_Driver" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">违章违纪类型
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Type" Width="200" 
                    NullText="请选择违章违纪类型" />
            </td>
        </tr>
        <tr>
            <td class="name">违章违纪性质
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_SeverityLevel" Width="200" 
                    NullText="选择违章违纪性质" />
            </td>
        </tr>
        <tr>
            <td class="name">发生时间
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_Time" Width="200" 
                    DisplayFormatString="yyyy-MM-dd HH:mm" EditFormatString="yyyy-MM-dd HH:mm">
                    <TimeSectionProperties Visible="true"></TimeSectionProperties>
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
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
            <td class="name">标题
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Name" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">处罚内容
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Description" Width="300" Rows="3" />
            </td>
        </tr>
        <tr>
            <td class="name">扣分
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_DemeritPoints" Width="200"
                    NumberType="Integer" DisplayFormatString="{0:N0} 分">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">罚款
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Fine" Width="200" DisplayFormatString="{0:N} 元">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">备注
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Remark" Width="300" Rows="3" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Violation_Edit; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(cb_Driver).IsRequired();
        fh.Validate(cb_Type).IsRequired();
        fh.Validate(cb_SeverityLevel).IsRequired();
        fh.Validate(de_Time).IsRequired();
        fh.Validate(tb_Place).IsRequired();
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(mm_Description).IsRequired();
        cb_Type.FromEnum<ViolationType>(valueAsInteger: true);
        cb_SeverityLevel.FromEnum<SeverityLevel>(valueAsInteger: true);
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        context.Cars.SingleOrDefault(c => c.Id == _ObjectId).IfNN(car =>
        {
            l_Id.Text = car.Id;
            l_Company.Text = car.Company;
            l_PlateNumber.Text = car.PlateNumber;
            
            // 取得当前承租关系
            var drivers = (
                from r in context.CarRentals
                join d in context.Drivers on r.DriverId equals d.Id
                where r.CarId == _ObjectId 
                select new
                {
                    d.Id,
                    d.Name,
                    d.DayOfBirth
                }).Distinct().ToList();
            if (drivers.Count == 0)
                throw new Exception("找不到当前承租司机，请检查承租关系");
            
            // 取得代班关系
            var shifts = (
                from r in context.CarRentalShifts
                join d in context.Drivers on r.SubDriverId equals d.Id
                where r.CarId == _ObjectId && r.IsActive
                select new
                {
                    d.Id,
                    d.Name,
                    d.DayOfBirth
                }).ToList();

            var all = new List<KeyValuePair<string, string>>();
            drivers.ForEach(d => all.Add(new KeyValuePair<string, string>(d.Id, d.Name)));
            shifts.ForEach(d => all.Add(new KeyValuePair<string, string>(d.Id, d.Name)));
            cb_Driver.FromList(all, (d, i) =>
            {
                i.Text = d.Value;
                i.Value = d.Key;
                return true;
            });

            p.Controls.Reset();
            
        }, () =>
        {
            throw DTException.NotFound<TB_car>(_ObjectId);
        });
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        var context = _DTContext<CommonContext>();
        var car = context.Cars.SingleOrDefault(o => o.Id == _ObjectId);
        var newId = string.Empty;
        if (car == null) throw DTException.NotFound<TB_car>(_ObjectId);

        var driverId = cb_Driver.Value.ToStringEx();
        if (string.IsNullOrEmpty(driverId)) 
            throw new Exception("请选定当事司机");
        
        context
            .NewSequence<TB_car_violation>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_violation>(_SessionEx, o =>
                {
                    o.CarId = _ObjectId;
                    o.Id = newId;
                    o.Time = de_Time.Date;
                    o.Type = cb_Type.Value.ToStringEx().ToIntOrDefault(-1);
                    o.SeverityLevel = cb_SeverityLevel.Value.ToStringEx().ToIntOrDefault(-1);
                    o.Status = (int)IssueStatus.Pending;
                    o.Place = tb_Place.Text;
                    o.Name = tb_Name.Text;
                    o.DriverId = driverId;
                    o.Description = mm_Description.Text;
                    if (!
                        string.IsNullOrEmpty(sp_Fine.Value.ToStringEx()))
                        o.Fine = sp_Fine.Number;
                    if (!
                        string.IsNullOrEmpty(sp_DemeritPoints.Value.ToStringEx()))
                        o.DemeritPoints = (int)sp_DemeritPoints.Number;
                })
            .SubmitChanges();
    }

</script>

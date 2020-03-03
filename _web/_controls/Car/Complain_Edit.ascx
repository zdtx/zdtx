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
                    投诉登记
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
            <td colspan="2" class="tips" style="padding: 5px;">
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
            <td class="name">投诉来源
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Source" Width="200"
                    NullText="请选择投诉来源" />
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
            <td class="name">投诉类型
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Type" Width="200"
                    NullText="请选择投诉类型" />
            </td>
        </tr>
        <tr>
            <td class="name">驾驶员有无责任
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_OwnFault" Width="200">
                    <Items>
                        <dx:ListEditItem Text="有" Value="1" Selected="true" />
                        <dx:ListEditItem Text="无" Value="0" />
                    </Items>
                </dx:ASPxComboBox>
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
            <td class="name">详细描述
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Description" Width="300" Rows="5" />
            </td>
        </tr>
        <tr>
            <td class="name">投诉人
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_ContactPerson" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">投诉人联系方式
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Contact" Width="200" />
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
            <td class="name">罚款
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Fine" Width="200"
                    NullText="请输入奖罚金额"
                    DisplayFormatString="{0:N} 元" MaxValue="1000000" MinValue="0">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>


    </table>
</asp:Panel>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Complain_Edit; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(cb_Driver).IsRequired();
        fh.Validate(cb_Source).IsRequired();
        fh.Validate(cb_Type).IsRequired();
        fh.Validate(de_Time).IsRequired();
        fh.Validate(cb_OwnFault).IsRequired();
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(mm_Description).IsRequired();
        cb_Source.FromEnum<ComplainSource>(valueAsInteger: true);
        cb_Type.FromEnum<ComplainType>(valueAsInteger: true);
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
            .NewSequence<TB_car_complain>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_complain>(_SessionEx, o =>
                {
                    o.CarId = _ObjectId;
                    o.Id = newId;
                    o.Time = de_Time.Date;
                    o.Source = cb_Source.Value.ToStringEx().ToIntOrDefault(-1);
                    o.Type = cb_Type.Value.ToStringEx().ToIntOrDefault(-1);
                    o.Status = (int)IssueStatus.Pending;
                    o.Name = tb_Name.Text;
                    o.DriverId = driverId;
                    o.Description = mm_Description.Text;
                    o.ContactPerson = tb_ContactPerson.Text;
                    o.Contact = tb_Contact.Text;
                    o.Coordinator = tb_Coordinator.Text;
                    o.Fine = sp_Fine.Value.ToStringEx().ToDecimalOrNull();

                    if (o.Fine.HasValue)
                    {
                        var amount = o.Fine.Value;
                        var newBalanceId = string.Empty;
                        context
                            .NewSequence<TB_car_balance>(_SessionEx, (seq, id) => newBalanceId = id)
                            .Create<TB_car_balance>(_SessionEx, m =>
                            {
                                m.CarId = _ObjectId;
                                m.Id = newBalanceId;
                                m.Ref1 = newId;
                                m.Ref2 = driverId;
                                m.Source = (int)CarBalanceSource.Complain;
                                m.Title = tb_Name.Text;
                                m.IsIncome = false;
                                m.Time = de_Time.Date;
                                m.Amount = Math.Abs(amount);
                                m.Status = (int)IssueStatus.Pending;
                            });
                    }
                })
            .SubmitChanges();

    }

</script>

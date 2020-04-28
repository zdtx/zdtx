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
                    参与公益、保障及好人好事记录
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
            <td class="name">发生时间
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_Time" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">类型
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Type" Width="200" 
                    NullText="请选择类型" />
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
            <td class="name">补偿或奖励（金额）
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Money" Width="200"
                    NullText="请输入金额"
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
    public override string ModuleId { get { return Car.Log_Edit; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(cb_Driver).IsRequired();
        fh.Validate(cb_Type).IsRequired();
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(mm_Description).IsRequired();
        fh.Validate(de_Time).IsRequired();
        cb_Type.FromEnum<CarLogType>(valueAsInteger: true);
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
            .NewSequence<TB_car_log>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_log>(_SessionEx, o =>
            {
                o.CarId = _ObjectId;
                o.Id = newId;
                o.Type = cb_Type.Value.ToStringEx().ToIntOrDefault(-1);
                o.Time = de_Time.Date;
                o.DriverId = driverId;
                o.Name = tb_Name.Text;
                o.Description = mm_Description.Text;
            });

        if (!string.IsNullOrEmpty(sp_Money.Value.ToStringEx()))
        {
            if (sp_Money.Number > 0)
            {
                var amount = sp_Money.Number;
                var newBalanceId = string.Empty;
                context
                    .NewSequence<TB_car_balance>(_SessionEx, (seq, id) => newBalanceId = id)
                    .Create<TB_car_balance>(_SessionEx, o =>
                    {
                        o.CarId = _ObjectId;
                        o.Id = newBalanceId;
                        o.Ref1 = newId;
                        o.Ref2 = driverId;
                        o.Source = (int)CarBalanceSource.Log;
                        o.Title = tb_Name.Text;
                        o.IsIncome = (amount > 0);
                        o.Time = _CurrentTime;
                        o.Amount = Math.Abs(amount);
                        o.Paid = 0;
                        o.Status = (int)IssueStatus.Pending;
                    });
            }
        }

        context.SubmitChanges();
    }

</script>

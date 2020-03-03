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
                    代班申请
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
            <td class="name">申请司机
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Driver" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">代班司机
            </td>
            <td class="cl">
                <uc1:PopupField_DX runat="server" ID="pf_SubDriverId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">代班原因
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Reason" Width="300" Rows="3" />
            </td>
        </tr>
        <tr>
            <td class="name">代班开始
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_StartTime" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">代班结束
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_EndTime" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
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
    public override string ModuleId { get { return Car.Shift_Edit; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(mm_Reason).IsRequired();
        fh.Validate(cb_Driver).IsRequired();
        fh.Validate(de_StartTime).IsRequired();
        fh.Validate(de_EndTime).IsRequired();
        fh.Validate(pf_SubDriverId).IsRequired();
        pf_SubDriverId.Initialize<eTaxi.Web.Controls.Selection.Driver.Item>(pop,
            "~/_controls.helper/selection/driver/item.ascx", (cc, b, h, isFirst) =>
            {
                pop.EventChannel = "d1";
                pop.Title = "选择代班司机";
                pop.Width = 650;
                pop.Height = 500;
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
            cb_Driver.FromList(drivers, (d, i) =>
            {
                i.Text = d.Name;
                i.Value = d.Id;
                return true;
            });
            
            // 呈报当前的代班情况
            tr.Visible = false;
            var currents = (
                from r in context.Drivers 
                join s in context.CarRentalShifts on r.Id equals s.DriverId
                join d in context.Drivers on s.SubDriverId equals d.Id
                where s.CarId == _ObjectId && s.IsActive
                select new
                {
                    r.Name,
                    SubName = d.Name,
                    SubDayOfBirth = d.DayOfBirth
                }).ToList();
                
            if (currents.Count > 0)
            {
                tr.Visible = true;
                lb.Text = "当前已有代班情况：";
                lb.Text += currents.ToFlat(", ", d =>
                    string.Format("由 [{0}] 代替正班 [{1}]", d.SubName, d.Name));
            }

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
            throw new Exception("请选定申请（正班）司机");
        var rental = (
            from r in context.CarRentals
            where r.CarId == _ObjectId && r.DriverId == driverId
            select r).FirstOrDefault();
        if (rental == null) 
            throw new Exception("找不到当前承租关系，请检查");
        
        // 将被取代的关系 IsActive 标记设为 true
        var currents = context.CarRentalShifts
            .Where(s => s.CarId == _ObjectId && s.DriverId == rental.DriverId && s.IsActive)
            .ToList();
        var subDriverId = pf_SubDriverId.Value;
        if (string.IsNullOrEmpty(subDriverId))
            throw new Exception("请选择代班司机");
        
        // 检查选定的代班司机是否可以代班
        if ((
            from r in context.CarRentals
            where r.DriverId == subDriverId
            select r).Any())
            throw new Exception("选定的司机属于正班司机，不能代班");
        if (context.CarRentalShifts.Any(s => s.SubDriverId == subDriverId && s.IsActive))
            throw new Exception("选定的司机还未完成上一次代班，不能重复代班");
        
        currents.SingleOrDefault(c => c.DriverId == driverId && c.SubDriverId == subDriverId).IfNN(c =>
            {
                c.IsActive = false;
                c.ActualEndTime = _CurrentTime;
                c.ConfirmedDays = 0;
                TimeSpan gap = _CurrentTime.Subtract(c.StartTime);
                if (gap.TotalDays > 0) c.ConfirmedDays = gap.Days;
            });
        
        context
            .NewSequence<TB_car_rental_shift>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_rental_shift>(_SessionEx, o =>
                {
                    o.CarId = rental.CarId;
                    o.DriverId = rental.DriverId;
                    o.Id = newId;
                    o.DriverId = driverId;
                    o.Time = _CurrentTime;
                    o.Reason = mm_Reason.Text;
                    o.Remark = mm_Remark.Text;
                    o.StartTime = de_StartTime.Date;
                    o.EndTime = de_EndTime.Date;
                    o.SubDriverId = subDriverId;
                })
            .SubmitChanges();
    }

</script>

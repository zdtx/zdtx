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
                    当前
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">管理费
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Rental" />
            </td>
        </tr>
        <tr>
            <td class="name">社保金
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Extra1" />
            </td>
        </tr>
        <tr>
            <td class="name">当前司机
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="lCurrent" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top:5px;">
                    变更为   ↓ 
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">新管理费
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Rental" Number="0" Width="200" DisplayFormatString="{0:N} 元">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">社保金
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Extra1" Number="0" Width="200" DisplayFormatString="{0:N} 元">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">新司机
            </td>
            <td class="cl">
                <uc1:PopupField_DX runat="server" ID="pf_DriverId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">生效时间（默认今天）
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
            <td class="name">是否试用（请酌情勾选）
            </td>
            <td class="cl">
                <dx:ASPxCheckBox ID="ck_IsProbation" runat="server" Text="是" AutoPostBack="true" />
            </td>
        </tr>
        <tr id="tr" runat="server" visible="false">
            <td class="name">试用到期日
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_ProbationExpiryDate" Width="200" NullText="请填写试用到期时间"
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
                <dx:ASPxMemo runat="server" ID="mm_Remark" Width="300" Rows="5" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    private string _CarId { get { return _ViewStateEx.Get<string>("CarId", null); } }
    private string _DriverId { get { return _ViewStateEx.Get<string>("DriverId", null); } }
    private bool _IsCreating { get { return _ViewStateEx.Get<bool>(DataStates.IsCreating, false); } }
    public override string ModuleId { get { return Car.Rental_Create; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(pf_DriverId).IsRequired();
        fh.Validate(de_ProbationExpiryDate).IsRequired();
        fh.Validate(sp_Extra1).IsRequired();
        fh.Validate(sp_Rental).IsRequired();

        pf_DriverId.Initialize<eTaxi.Web.Controls.Selection.Driver.Item>(pop,
            "~/_controls.helper/selection/driver/item.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择司机";
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
        ck_IsProbation.CheckedChanged += (s, e) =>
        {
            tr.Visible = ck_IsProbation.Checked;
            if (!
                string.IsNullOrEmpty(de_StartTime.Value.ToStringEx()))
                de_ProbationExpiryDate.Date = de_StartTime.Date.AddMonths(3);
        };
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var car = context.Cars.SingleOrDefault(c => c.Id == _CarId);
        if (car == null) throw DTException.NotFound<TB_car>(_CarId);

        var rentals = context.CarRentals.Where(r => r.CarId == _CarId).ToList();
        var newRental = (car.Rental / (rentals.Count + 1)).ToCHNRounded();
        de_StartTime.Date = _CurrentTime.Date;

        p.Controls.Reset();

        if (_IsCreating)
        {
            lCurrent.Text = "（空缺）";
            l_Rental.Text = string.Format("建议金额 => {0}", newRental.ToStringOrEmpty(comma:true));
            l_Extra1.Text = " - ";
            sp_Rental.Number = newRental;
        }
        else
        {
            var q =
                from r in context.CarRentals
                join d in context.Drivers on r.DriverId equals d.Id
                where r.CarId == _CarId && r.DriverId == _DriverId
                select new
                {
                    d.Id,
                    d.Name,
                    d.Gender,
                    d.DayOfBirth,
                    d.CHNId,
                    r.StartTime,
                    r.IsProbation,
                    r.ProbationExpiryDate,
                    r.Rental,
                    r.Extra1
                };

            q.SingleOrDefault().IfNN(rental =>
            {
                l_Rental.Text = rental.Rental.ToStringOrEmpty(comma: true);
                sp_Rental.Number = rental.Rental;
                lCurrent.Text = string.Format("{0} [身份证：{1}]", rental.Name, rental.CHNId);
                if (rental.IsProbation)
                {
                    lCurrent.Text += "<br />- 试用中";
                    if (rental.ProbationExpiryDate.HasValue)
                        lCurrent.Text += "<br />- 试用期至：" + rental.ProbationExpiryDate.Value.ToISDate();
                }

            }, () =>
            {
                throw DTException.NotFound<TB_car_rental>(string.Empty, s => s
                    .Record("CarId", _CarId)
                    .Record("DriverId", _DriverId));
            });
        }

        
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        if (_IsCreating) _Do_Create(); else _Do_Update();
    }

    private void _Do_Create()
    {
        var context = _DTContext<CommonContext>();
        var car = context.Cars.SingleOrDefault(c => c.Id == _CarId);
        if (car == null)
            throw DTException.NotFound<TB_car>(_CarId);
        var rentals = context.CarRentals.Where(r => r.CarId == _CarId).ToList();
        if (rentals.Count >= 2)
            throw new Exception("不能添加司机，因为当前已经存在超过两个正班司机，请检查");
        var driverId = pf_DriverId.Value;
        if (rentals.Any(r => r.DriverId == driverId))
            throw new Exception("当前已经存在该正班司机");
        var startDate = _CurrentTime.Date;
        if (!string.IsNullOrEmpty(de_StartTime.Value.ToStringEx()))
            startDate = de_StartTime.Date.Date;
        if (ck_IsProbation.Checked && string.IsNullOrEmpty(de_ProbationExpiryDate.Value.ToStringEx()))
        {
            de_ProbationExpiryDate.Focus();
            throw new Exception("请填入试用到期日");
        }

        // 添加关系
        var newId = context.NewSequence<TB_car_rental>(_SessionEx);
        context
            .Create<TB_car_rental>(_SessionEx, r =>
            {
                r.CarId = _CarId;
                r.DriverId = driverId;
                r.Ordinal = rentals.Count;
                r.StartTime = startDate;
                r.Rental = sp_Rental.Number;
                r.Extra1 = sp_Extra1.Number;
                r.IsProbation = ck_IsProbation.Checked;
                if (!
                    string.IsNullOrEmpty(de_ProbationExpiryDate.Value.ToStringEx()))
                    r.ProbationExpiryDate = de_ProbationExpiryDate.Date;
            })
            .SubmitChanges();
    }

    private void _Do_Update()
    {
        var context = _DTContext<CommonContext>();
        var car = context.Cars.SingleOrDefault(c => c.Id == _CarId);
        if (car == null)
            throw DTException.NotFound<TB_car>(_CarId);
        var rentals = context.CarRentals.Where(r => r.CarId == _CarId).ToList();
        var rental = rentals.SingleOrDefault(r => r.DriverId == _DriverId);
        if (rental == null)
            throw DTException.NotFound<TB_car_rental>(string.Empty, s => s
                .Record("CarId", _CarId)
                .Record("DriverId", _DriverId));
        var driverId = pf_DriverId.Value;
        if (rentals.Any(r => r.DriverId == driverId))
            throw new Exception("当前已经存在该正班司机");
        var startDate = _CurrentTime.Date;
        if (!string.IsNullOrEmpty(de_StartTime.Value.ToStringEx()))
            startDate = de_StartTime.Date.Date;
        if (ck_IsProbation.Checked && string.IsNullOrEmpty(de_ProbationExpiryDate.Value.ToStringEx()))
        {
            de_ProbationExpiryDate.Focus();
            throw new Exception("请填入试用到期日");
        }

        /// 1. 将当前的存为历史
        /// 2. 为撤下来的司机生成一张待收单据
        var newHistoryId = context.NewSequence<TB_car_rental_history>(_SessionEx);
        var newPaymentId = context.NewSequence<TB_car_payment>(_SessionEx);
        var endDate = startDate.AddDays(-1);

        /// 如果在一天之内换的，则不产生历史计算记录
        var gap = _CurrentTime.Subtract(rental.StartTime);
        if (gap.TotalDays > 2)
        {
            context
                .Create<TB_car_rental_history>(_SessionEx, h =>
                {
                    h.CarId = _CarId;
                    h.DriverId = _DriverId;
                    h.Id = newHistoryId;
                    h.Rental = rental.Rental;
                    h.Extra1 = rental.Extra1;
                    h.Extra2 = rental.Extra2;
                    h.Extra3 = rental.Extra3;
                    h.StartTime = rental.StartTime;
                    h.EndTime = endDate;
                })
                .DeleteAll<TB_car_payment>(p =>
                    p.CarId == _CarId && p.DriverId == _DriverId && p.Due >= endDate)
                .Create<TB_car_payment>(_SessionEx, p =>
                {
                    p.CarId = _CarId;
                    p.DriverId = _DriverId;
                    p.Id = newPaymentId;
                    p.MonthInfo = endDate.ToMonthId();
                    p.Name = string.Format("{0} - 换班结算", p.MonthInfo);
                    p.Days = DateTime.DaysInMonth(endDate.Year, endDate.Month);
                    p.CountDays = endDate.Day;

                    var totalDays = (int)endDate.Subtract(rental.StartTime).TotalDays;
                    if (totalDays < endDate.Day) p.CountDays = totalDays;

                    p.Due = endDate;
                    p.Amount =
                        (rental.Rental * p.CountDays / p.Days + rental.Extra1 + rental.Extra2 + rental.Extra3).ToCHNRounded();
                    p.Paid = p.Amount;
                });
        }

        context
            .DeleteAll<TB_car_rental>(rr => rr.CarId == _CarId && rr.DriverId == _DriverId)
            .Create<TB_car_rental>(_SessionEx, r =>
            {
                r.CarId = _CarId;
                r.DriverId = driverId;
                r.Ordinal = rental.Ordinal;
                r.StartTime = startDate;
                r.Rental = sp_Rental.Number;
                r.Extra1 = sp_Extra1.Number;
                r.IsProbation = ck_IsProbation.Checked;
                if (!
                    string.IsNullOrEmpty(de_ProbationExpiryDate.Value.ToStringEx()))
                    r.ProbationExpiryDate = de_ProbationExpiryDate.Date;
            })
            .SubmitChanges();
    }

</script>

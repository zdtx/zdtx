<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.TimerService.TaskBase" %>
<script runat="server">

    /// <summary>
    /// 生成月结单
    /// </summary>

    public override bool Enabled { get { return true; } }
    public override int ContainerIndex { get { return 1; } }
    public override string Code { get { return "UpdateRentalStatus"; } }
    public override string Name { get { return "更新承租状态，生成应收款"; } }
    public override bool RequireTransaction { get { return true; } }
    protected override bool _ShouldDo(TB_sys_batch last, Action<string> tip)
    {
        if (last == null) return true; // 1
        var gap = _CurrentTime.Subtract(last.LastActionTime);
        if (gap.TotalHours >= 12 || !last.Completed) return true; // 2
        if (_CurrentTime.Day >= 25) return true; // 每月最后 5 天才进行生成
        return false;
    }

    protected override void _Execute(TB_sys_batch last, TB_sys_batch current, Action<string> succeeded)
    {
        var context = _DTService.Context;
        context.CommandTimeout = _CommandExecutionTimeout;

        // 每个月 20 日 - 月底 生成月结单
        var rentals = (
            from r in context.CarRentals
            where
                r.Rental + r.Extra1 + r.Extra2 + r.Extra3 > 0 &&
                (
                    !r.LastPaymentGenTime.HasValue ||
                    (r.LastPaymentGenTime.HasValue && r.LastPaymentGenTime.Value.AddMonths(1) <= _CurrentTime)
                )
            select r).ToList();
        var monthIndex = _CurrentTime.ToMonthId();
        rentals.ForEach(r=>
        {
            var lastDay = _CurrentTime.LastDayDate();
            var gap = (int)lastDay.Subtract(r.StartTime).TotalDays;
            var days = lastDay.Day;
            var countDays = days;
            var extra = r.Extra1 + r.Extra2 + r.Extra3;
            if (gap < countDays) countDays = gap;
            r.LastPaymentGenTime = _CurrentTime;
            context
                .Create<TB_car_payment>(new AdminSession(_CurrentTime), payment =>
                {
                    payment.CarId = r.CarId;
                    payment.DriverId = r.DriverId;
                    payment.MonthIndex = monthIndex;
                    payment.Name = monthIndex;
                    payment.Days = days;
                    payment.CountDays = countDays;
                    payment.Due = lastDay;
                    payment.Amount = payment.Paid =
                        (r.Rental * countDays / days + extra).ToCHNRounded();
                });
        });
    }

    private void _Do(DateTime specificTime)
    {
        _CurrentTime = specificTime;
        var context = _DTService.Context;
        context.CommandTimeout = _CommandExecutionTimeout;

        var rentals = (
            from r in context.CarRentals
            where
                r.Rental + r.Extra1 + r.Extra2 + r.Extra3 > 0
            select r).ToList();
        var monthIndex = _CurrentTime.ToMonthId();
        rentals.ForEach(r=>
        {
            var lastDay = _CurrentTime.LastDayDate();
            var gap = (int)lastDay.Subtract(r.StartTime).TotalDays;
            var days = lastDay.Day;
            var countDays = days;
            var extra = r.Extra1 + r.Extra2 + r.Extra3;
            if (gap < countDays) countDays = gap;
            r.LastPaymentGenTime = _CurrentTime;
            context
                .Create<TB_car_payment>(new AdminSession(_CurrentTime), payment =>
                {
                    payment.CarId = r.CarId;
                    payment.DriverId = r.DriverId;
                    payment.MonthIndex = monthIndex;
                    payment.Name = monthIndex;
                    payment.Days = days;
                    payment.CountDays = countDays;
                    payment.Due = lastDay;
                    payment.Amount = payment.Paid =
                        (r.Rental * countDays / days + extra).ToCHNRounded();
                });
        });
    }

</script>

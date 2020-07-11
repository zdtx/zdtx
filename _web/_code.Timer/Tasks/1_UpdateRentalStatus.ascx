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
        if (_CurrentTime.Day >= 1) return true; // 每月 5 天才进行生成
        return false;
    }

    protected override void _Execute(TB_sys_batch last, TB_sys_batch current, Action<string> succeeded)
    {
        var context = _DTService.Context;
        context.CommandTimeout = _CommandExecutionTimeout;

        var monthIndex = _CurrentTime.ToMonthId();
        var rentals = (
            from r in context.CarRentals
            from p in context.CarPayments.Where(pp =>
                pp.CarId == r.CarId &&
                pp.DriverId == r.DriverId &&
                pp.MonthIndex == monthIndex).DefaultIfEmpty()
            where p == null
            select new RentalHeader
            {
                CarId = r.CarId,
                DriverId = r.DriverId
            });

        var batch = rentals.Take(20).ToList();
        batch.ForEach(header =>
        {
            _DTService.GenerateInvoice(header, monthIndex);
        });
    }

</script>

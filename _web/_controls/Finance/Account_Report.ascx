<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Import Namespace="eTaxi.Reports.Driver" %>
<%@ Import Namespace="Microsoft.Reporting.WebForms" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
<div style="padding: 10px;">
    <div class="actionTB" style="padding-top:2px;">
        <table>
            <tr>
                <td>
                    月份（年月）：
                </td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbMonthIndex" Width="100" AutoPostBack="true" />
                </td>
            </tr>
        </table>
    </div>
    <div style="padding:30px;">
        <asp:LinkButton runat="server" Font-Size="Medium" ID="lb_Report" Text="打印应收款月报表" CssClass="aBtn" OnClientClick="ISEx.loadingPanel.show();" />
    </div>
</div>
<script runat="server">

    private const string CMD_Report_1 = "report1";

    private string _ObjectId
    {
        get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); }
        set { _ViewStateEx.Set<string>(value, DataStates.ObjectId); }
    }

    public override string ModuleId { get { return Finance.Account_Report ; } }
    protected override void _SetInitialStates()
    {
        // 月份
        var monthIds = new List<string>();
        var todate = DateTime.Now.Date;

        for (var i = 0; i< 10; i++)
        {
            if (i == 0)
            {
                monthIds.AddRange(todate.ToMonthIds());
                continue;
            }

            monthIds.AddRange(todate.AddYears(i).ToMonthIds());
            monthIds.AddRange(todate.AddYears(-1 * i).ToMonthIds());
        }

        cbMonthIndex.FromList(monthIds, (dd, i) => { i.Text = dd; i.Value = dd; return true; });
        cbMonthIndex.SelectedIndexChanged += (s, e) => _Execute(VisualSections.List);

        lb_Report.Click += (s, e) =>
        {
            Execute(CMD_Report_1);
        };

    }

    protected override void _Execute()
    {
        cbMonthIndex.Value = DateTime.Now.ToMonthId();
    }

    protected override void _Execute(string section)
    {
        if (section == CMD_Report_1)
        {
            var context = _DTService.Context;
            _ObjectId = cbMonthIndex.Value.ToStringEx();

            var payments = (
                from d in context.Drivers
                join p in context.CarPayments on d.Id equals p.DriverId
                join c in context.Cars on p.CarId equals c.Id
                where p.MonthIndex == _ObjectId
                orderby d.Name, d.Manager
                select new
                {
                    c.PlateNumber,
                    d.Name,
                    d.CHNId,
                    d.Manager,
                    p.CarId,
                    p.DriverId,
                    p.MonthIndex,
                    p.OpeningBalance,
                    p.ClosingBalance,
                    p.Amount,
                    p.Paid

                }).ToList();

            var paymentItems = context.CarPaymentItems.Where(i => i.MonthIndex == _ObjectId).ToList();
            var d1 = new List<RPT_MonthlyStatement.DC1>();
            var ordinal = 0;

            payments.ForEach(p =>
            {
                ordinal++;
                var d = new RPT_MonthlyStatement.DC1()
                {
                    Ordinal = ordinal.ToString(),
                    Name = p.Name,
                    PlateNumber = p.PlateNumber,
                    OpeningBalance = p.OpeningBalance.ToStringOrEmpty(emptyValue: "0.00"),
                    ClosingBalance = p.ClosingBalance.ToStringOrEmpty(emptyValue: "0.00"),
                    Amount = p.Amount.ToStringOrEmpty(emptyValue: "0.00"),
                    Paid = p.Paid.ToStringOrEmpty(emptyValue: "0.00")
                };

                d1.Add(d);
                var items = paymentItems
                    .Where(i => i.CarId == p.CarId && i.DriverId == p.DriverId)
                    .ToList();

                foreach (var i in items)
                {
                    switch (i.AccountingIndex)
                    {
                        case (int)AccountingIndex.AdminFee:     // 管理费
                            d.AdminFee_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                            d.AdminFee_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                            break;
                        case (int)AccountingIndex.Log:          // 奖金
                            d.Bonus_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                            d.Bonus_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                            break;
                        case (int)AccountingIndex.Rental:       // 月租金
                            d.Rental_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                            d.Rental_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                            break;
                        case (int)AccountingIndex.Violation:    // 罚金
                            d.Fine_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                            d.Fine_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                            break;
                        default:
                            switch (i.Name)
                            {
                                case "代班费":
                                    d.Shift_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                                    d.Shift_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                                    break;
                                case "轮胎基金":
                                    d.Tyre_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                                    d.Tyre_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                                    break;
                                case "违纪基金":
                                    d.Violation_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                                    d.Violation_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                                    break;
                                case "公交卡销":
                                    d.Card_Amount = i.Amount.ToStringOrEmpty(emptyValue: "0.00");
                                    d.Card_Paid = i.Paid.ToStringOrEmpty(emptyValue: "0.00");
                                    break;

                            }
                            break;
                    }
                }
            });

            var report = new RPT_MonthlyStatement();
            report.Replace(d1);

            var openingBalance = payments.Sum(p => p.OpeningBalance).ToStringOrEmpty(emptyValue: "0.00");
            var closingBalance = payments.Sum(p => p.ClosingBalance).ToStringOrEmpty(emptyValue: "0.00");
            var amount = payments.Sum(p => p.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var paid = payments.Sum(p => p.Paid).ToStringOrEmpty(emptyValue: "0.00");

            var adminFee_Amount = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.AdminFee)
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var adminFee_Paid = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.AdminFee)
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");
            var bonus_Amount = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.Log)
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var bonus_Paid = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.Log)
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");
            var rental_Amount = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.Rental)
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var rental_Paid = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.Rental)
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");
            var fine_Amount = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.Violation)
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var fine_Paid = paymentItems
                .Where(i => i.AccountingIndex == (int)AccountingIndex.Violation)
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");
            var shift_Amount = paymentItems
                .Where(i => i.Name == "代班费")
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var shift_Paid = paymentItems
                .Where(i => i.Name == "代班费")
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");
            var tyre_Amount = paymentItems
                .Where(i => i.Name == "轮胎基金")
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var tyre_Paid = paymentItems
                .Where(i => i.Name == "轮胎基金")
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");
            var violation_Amount = paymentItems
                .Where(i => i.Name == "违纪基金")
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var violation_Paid = paymentItems
                .Where(i => i.Name == "违纪基金")
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");
            var card_Amount = paymentItems
                .Where(i => i.Name == "公交卡销")
                .Sum(i => i.Amount).ToStringOrEmpty(emptyValue: "0.00");
            var card_Paid = paymentItems
                .Where(i => i.Name == "公交卡销")
                .Sum(i => i.Paid).ToStringOrEmpty(emptyValue: "0.00");

            //report.ReplaceParameters(
            //    report.CreateParameter("openingBalance", openingBalance),
            //    report.CreateParameter("closingBalance", closingBalance),
            //    report.CreateParameter("amount", amount),
            //    report.CreateParameter("paid", paid),
            //    report.CreateParameter("adminFee_Amount", adminFee_Amount),
            //    report.CreateParameter("adminFee_Paid", adminFee_Paid),
            //    report.CreateParameter("rental_Amount", rental_Amount),
            //    report.CreateParameter("rental_Paid", rental_Paid),
            //    report.CreateParameter("shift_Amount", shift_Amount),
            //    report.CreateParameter("shift_Paid", shift_Paid),
            //    report.CreateParameter("tyre_Amount", tyre_Amount),
            //    report.CreateParameter("tyre_Paid", tyre_Paid),
            //    report.CreateParameter("violation_Amount", violation_Amount),
            //    report.CreateParameter("violation_Paid", violation_Paid),
            //    report.CreateParameter("fine_Amount", fine_Amount),
            //    report.CreateParameter("fine_Paid", fine_Paid),
            //    report.CreateParameter("bonus_Amount", bonus_Amount),
            //    report.CreateParameter("bonus_Paid", bonus_Paid),
            //    report.CreateParameter("card_Amount", card_Amount),
            //    report.CreateParameter("card_Paid", card_Paid)
            //);

            var ticketId = _SessionEx.TKObjectManager.RegCounter(report, 50);
            JS(string.Format("ISEx.openMaxWin(\"{0}?id={1}\");",
                _ResolvePath("/report.aspx"), ticketId.ToISFormatted()));

        }
    }

</script>

using eTaxi.Definitions;

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace eTaxi.L2SQL
{
    public partial class CommonService : DTServiceBase<CommonContext>
    {
        /// <summary>
        /// 生成月结单
        /// </summary>
        public void GenerateInvoice(RentalHeader header, string monthIndex)
        {
            var invoiceDayIndex = Host.Settings.Get<int>("MonthlyInvoiceDayIndex", 1);
            var payments = Context.CarPayments
                .Where(p => p.CarId == header.CarId && p.DriverId == header.DriverId)
                .ToList();
            var date = new DateTime(
                monthIndex.Substring(0, 4).ToIntOrDefault(),
                monthIndex.Substring(4, 2).ToIntOrDefault(), invoiceDayIndex);

            // 如果日子之前的，就算上个月，如果之后，则算下个月
            var factor = invoiceDayIndex < 15 ? 1 : -1;
            var startDate = factor > 0 ? date : date.AddMonths(-1);
            var endDate = factor > 0 ? date.AddMonths(1) : date;
            var dayCount = (int)endDate.Subtract(startDate).TotalDays;

            // 已生成月结，省略
            if (payments.FirstOrDefault(p => p.MonthIndex == monthIndex) != null) return;

            var charges = Context.Charges.Where(c => c.Enabled).ToList();
            var payment = new TB_car_payment();
            var previousPayment = payments
                .Where(p => p.MonthIndex.ToIntOrDefault() < monthIndex.ToIntOrDefault())
                .OrderBy(p => p.MonthIndex)
                .LastOrDefault();
            var previousPaymentItems = new List<TB_car_payment_item>();
            if (previousPayment != null)
            {
                previousPaymentItems = Context.CarPaymentItems
                    .Where(i => i.CarId == header.CarId && i.DriverId == header.DriverId && i.MonthIndex == previousPayment.MonthIndex)
                    .ToList();
            }

            var paymentItems = new List<TB_car_payment_item>();

            charges.ForEach(c =>
            {
                var item = new TB_car_payment_item()
                {
                    Paid = 0,
                    Amount = c.Amount,
                    CarId = header.CarId,
                    ChargeId = c.Id,
                    Code = c.Code,
                    DriverId = header.DriverId,
                    MonthIndex = monthIndex,
                    SpecifiedMonth = c.SpecifiedMonth,
                    Type = c.Type,
                    IsNegative = c.IsNegative,
                    AccountingIndex = c.AccountingIndex,
                    Name = c.Name
                };

                item = UpdatePaymentItem(item, startDate, endDate);
                previousPaymentItems
                    .FirstOrDefault(i => i.ChargeId == c.Id)
                    .IfNN(i =>
                    {
                        item.Amount += (i.Amount - i.Paid);
                    });

                // item.Paid = item.Amount;

                paymentItems.Add(item);

            });

            payment.Paid = 0;
            payment.Amount = paymentItems.Sum(p => p.IsNegative ? -1 * p.Amount : p.Amount);
            payment.CarId = header.CarId;
            payment.CountDays = dayCount;
            payment.Days = dayCount;
            payment.DriverId = header.DriverId;
            payment.Due = DateTime.Now.Date.AddMonths(1);
            payment.MonthIndex = monthIndex;
            payment.StartDate = startDate;
            payment.EndDate = endDate;
            payment.Name = monthIndex;
            payment.OpeningBalance = previousPayment == null ? 0 : previousPayment.ClosingBalance;
            // payment.ClosingBalance = payment.OpeningBalance + payment.Paid - payment.Amount; 
            payment.ClosingBalance = payment.Paid - (payment.Amount - payment.OpeningBalance ?? 0m); // 
            payment.PreviousAmount = previousPayment == null ? 0 : previousPayment.Amount;
            payment.PreviousPaid = previousPayment == null ? 0 : previousPayment.Paid;
            Context.Endorse(_CurrentSession, payment);

            Context.CarPayments.InsertOnSubmit(payment);
            paymentItems.ForEach(item => Context.CarPaymentItems.InsertOnSubmit(item));
            Context.SubmitChanges();
        }

        /// <summary>
        /// 租金
        /// </summary>
        public TB_car_payment_item UpdateRentalItem(TB_car_payment_item item, DateTime startDate, DateTime endDate)
        {
            var rental = Context.CarRentals
                .SingleOrDefault(r => r.CarId == item.CarId && r.DriverId == item.DriverId);
            if (rental == null) return item;
            item.Amount = rental.Rental;
            return item;
        }

        /// <summary>
        /// 管理费
        /// </summary>
        public TB_car_payment_item UpdateAdminFeeItem(TB_car_payment_item item, DateTime startDate, DateTime endDate)
        {
            // 未实现
            return item;
        }

        /// <summary>
        /// 罚金
        /// </summary>
        public TB_car_payment_item UpdateViolationItem(TB_car_payment_item item, DateTime startDate, DateTime endDate)
        {
            var violations = Context.CarViolations
                .Where(v =>
                    v.CarId == item.CarId && v.DriverId == item.DriverId &&
                    v.Time >= startDate && v.Time < endDate)
                .ToList();

            item.Amount = violations.Sum(v => v.Fine ?? 0);
            return item;
        }

        /// <summary>
        /// 奖金
        /// </summary>
        public TB_car_payment_item UpdateLogItem(TB_car_payment_item item, DateTime startDate, DateTime endDate)
        {
            var balances = Context.CarBalances
                .Where(b =>
                    b.CarId == item.CarId && b.Ref2 == item.DriverId &&
                    b.Source == (int)CarBalanceSource.Log &&
                    b.Time >= startDate && b.Time < endDate)
                .ToList();

            item.Amount = balances.Sum(l => l.Amount);
            return item;
        }

        /// <summary>
        /// 更新月结金额
        /// </summary>
        public void UpdatePayment(string carId, string driverId, string monthIndex)
        {
            var payment = Context.CarPayments
                .FirstOrDefault(p => p.CarId == carId && p.DriverId == driverId && p.MonthIndex == monthIndex);
            if (payment == null) return;

            var yearIndex = payment.MonthIndex.Substring(0, 4);
            var payments = Context.CarPayments
                .Where(p => p.CarId == carId && p.DriverId == driverId && p.MonthIndex.StartsWith(yearIndex))
                .OrderBy(p => p.MonthIndex)
                .ToList();

            payment = payments.Single(p => p.MonthIndex == payment.MonthIndex);
            var paymentItems = Context.CarPaymentItems
                .Where(i => i.CarId == carId && i.DriverId == driverId && i.MonthIndex == monthIndex)
                .ToList();

            // 更新计算项
            paymentItems.ForEach(item =>
            {
                paymentItems.Add(UpdatePaymentItem(item, payment.StartDate, payment.EndDate));
            });

            payment.Amount = paymentItems.Sum(i => i.IsNegative ? -1 * i.Amount : i.Amount);
            payment.Paid = paymentItems.Sum(i => i.IsNegative ? -1 * i.Paid : i.Paid);
            payment.ClosingBalance = payment.OpeningBalance - payment.Amount + payment.Paid;

            var date = new DateTime(
                monthIndex.Substring(0, 4).ToIntOrDefault(),
                monthIndex.Substring(4, 2).ToIntOrDefault(), 1);
            for (var i = 0; i < payments.Count; i++)
            {
                var p = payments[i];
                var d = new DateTime(
                    p.MonthIndex.Substring(0, 4).ToIntOrDefault(),
                    p.MonthIndex.Substring(4, 2).ToIntOrDefault(), 1);
                if (d <= date) continue;

                p.OpeningBalance = payment.ClosingBalance;
                p.ClosingBalance = p.OpeningBalance - p.Amount + p.Paid;
            }

            Context.SubmitChanges();
        }


        public TB_car_payment_item UpdatePaymentItem(TB_car_payment_item item, DateTime startDate, DateTime endDate)
        {
            switch (item.AccountingIndex)
            {
                case (int)AccountingIndex.Rental:
                    return UpdateRentalItem(item, startDate, endDate);
                case (int)AccountingIndex.AdminFee:
                    return UpdateAdminFeeItem(item, startDate, endDate);
                case (int)AccountingIndex.Violation:
                    return UpdateViolationItem(item, startDate, endDate);
                case (int)AccountingIndex.Log:
                    return UpdateLogItem(item, startDate, endDate);
                default:
                    return item;
            }
        }

    }
}

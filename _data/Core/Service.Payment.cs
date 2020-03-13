using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;
using System.Data.Linq.Mapping;
using System.Text;
using System.Data;
using System.Data.Linq;
using Microsoft.Practices.Unity;

namespace eTaxi.L2SQL
{
    public partial class CommonService : DTServiceBase<CommonContext>
    {
        /// <summary>
        /// 生成月结单
        /// </summary>
        public void GenerateInvoice(RentalHeader header, string monthIndex)
        {
            var year = monthIndex.Substring(0, 4);
            var payments = Context.CarPayments
                .Where(p => p.CarId == header.CarId && p.DriverId == header.DriverId)
                .ToList();
            var date = new DateTime(
                monthIndex.Substring(0, 4).ToIntOrDefault(),
                monthIndex.Substring(4, 2).ToIntOrDefault(), 1);
            var dayCount = date.ToDates().Length;

            // 已生成月结，省略
            if (payments.FirstOrDefault(p => p.MonthInfo == monthIndex) != null) return;

            var charges = Context.Charges.Where(c => c.Enabled).ToList();
            var newId = string.Empty;
            var payment = new TB_car_payment();
            var previousPayment = payments
                .Where(p => p.MonthInfo.ToIntOrDefault() < monthIndex.ToIntOrDefault())
                .OrderBy(p => p.MonthInfo)
                .LastOrDefault();
            var paymentItems = new List<TB_car_payment_item>();

            Context
                .NewSequence<TB_car_payment>(_CurrentSession, (seq, id) =>
                {
                    newId = id;
                })
                .SubmitChanges();

            charges.ForEach(c =>
            {
                paymentItems.Add(new TB_car_payment_item()
                {
                    Amount = c.Amount,
                    CarId = header.CarId,
                    ChargeId = c.Id,
                    Code = c.Code,
                    DriverId = header.DriverId,
                    PaymentId = newId,
                    SpecifiedMonth = c.SpecifiedMonth,
                    Type = c.Type
                });
            });

            payment.Amount = paymentItems.Sum(p => p.Amount);
            payment.CarId = header.CarId;
            payment.CountDays = dayCount;
            payment.Days = dayCount;
            payment.DriverId = header.DriverId;
            payment.Due = DateTime.Now.Date.AddMonths(1);
            payment.Id = newId;
            payment.MonthInfo = monthIndex;
            payment.Name = monthIndex;
            payment.OpeningBalance = previousPayment == null ? 0 : previousPayment.ClosingBalance;
            payment.Paid = 0;
            payment.ClosingBalance = payment.OpeningBalance - payment.Amount;
            Context.Endorse(_CurrentSession, payment);

            Context.CarPayments.InsertOnSubmit(payment);
            paymentItems.ForEach(item => Context.CarPaymentItems.InsertOnSubmit(item));
            Context.SubmitChanges();
        }
    }
}

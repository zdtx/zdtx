using System;
namespace eTaxi.Reports.Driver
{
    /// <summary>
    /// 司机月结单
    /// </summary>
    public class RPT_MonthlyStatement : ReportGen
    {
        public class Parameters
        {
            public const string DaysCount = "DaysCount";
        }

        public override string ReportPath
        {
            get { return @"~/____reports/Driver/MonthlyStatement.rdlc"; }
        }

        [Serializable]
        public class DC1
        {
            public string Ordinal { get; set; }
            public string Id { get; set; }
            public string Name { get; set; }
            public string Manager { get; set; }
            public string PlateNumber { get; set; }
            public string CarriageNum { get; set; }
            public decimal OpeningBalance { get; set; }
            public decimal ClosingBalance { get; set; }
            public decimal AdminFee_Amount { get; set; }
            public decimal AdminFee_Paid { get; set; }
            public decimal Rental_Amount { get; set; }
            public decimal Rental_Paid { get; set; }
            public decimal Shift_Amount { get; set; }
            public decimal Shift_Paid { get; set; }
            public decimal Tyre_Amount { get; set; }
            public decimal Tyre_Paid { get; set; }
            public decimal Violation_Amount { get; set; }
            public decimal Violation_Paid { get; set; }
            public decimal Fine_Amount { get; set; }
            public decimal Fine_Paid { get; set; }
            public decimal Bonus_Amount { get; set; }
            public decimal Bonus_Paid { get; set; }
            public decimal Card_Amount { get; set; }
            public decimal Card_Paid { get; set; }
            public decimal Compensation_Amount { get; set; }
            public decimal Compensation_Paid { get; set; }
            public decimal Termination_Paid { get; set; }
            public decimal Amount { get; set; }
            public decimal Paid { get; set; }
        }
    }
}


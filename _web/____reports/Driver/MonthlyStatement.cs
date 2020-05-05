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
            public string OpeningBalance { get; set; }
            public string ClosingBalance { get; set; }
            public string AdminFee_Amount { get; set; }
            public string AdminFee_Paid { get; set; }
            public string Rental_Amount { get; set; }
            public string Rental_Paid { get; set; }
            public string Shift_Amount { get; set; }
            public string Shift_Paid { get; set; }
            public string Tyre_Amount { get; set; }
            public string Tyre_Paid { get; set; }
            public string Violation_Amount { get; set; }
            public string Violation_Paid { get; set; }
            public string Fine_Amount { get; set; }
            public string Fine_Paid { get; set; }
            public string Bonus_Amount { get; set; }
            public string Bonus_Paid { get; set; }
            public string Card_Amount { get; set; }
            public string Card_Paid { get; set; }
            public string Amount { get; set; }
            public string Paid { get; set; }
        }
    }
}


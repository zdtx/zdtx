using System;
namespace eTaxi.Reports.Driver
{
    /// <summary>
    /// 司机月结单（收据）
    /// </summary>
    public class RPT_MonthlyReceipt : ReportGen
    {
        public class Parameters
        {
            public const string DaysCount = "DaysCount";
        }

        public override string ReportPath
        {
            get { return @"~/____reports/Driver/MonthlyReceipt.rdlc"; }
        }

        [Serializable]
        public class DC1
        {
            public string Ordinal { get; set; }
            public string Id { get; set; }
            public string Name { get; set; }
            public string Amount { get; set; }
            public string Paid { get; set; }
            public string Gap { get; set; }
            public string Remark { get; set; }
        }
    }
}


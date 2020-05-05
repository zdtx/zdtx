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
            public string Name { get; set; }
            public string Amount { get; set; }
        }
    }
}


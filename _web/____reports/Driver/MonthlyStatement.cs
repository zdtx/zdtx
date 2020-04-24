using System;
using System.Collections.Generic;
namespace eTaxi.Web.Reports.Driver
{
    /// <summary>
    /// 司机月结单
    /// </summary>
    public class RPT_MonthlyStatement : ReportGen
    {
        public class parameters
        {
            public const string ReportDateInfo = "ReportDateInfo";
            public const string SubmitTimeInfo = "SubmitTimeInfo";
            public const string PersonInfo = "PersonInfo";
            public const string DaysCount = "DaysCount";
        }

        public override string ReportPath
        {
            get { return @"~/____reports/Driver/MonthlyStatement.rdlc"; }
        }

        public RPT_MonthlyStatement()
        {
            _Lists.Add(new List<DC1>() { new DC1() });
        }

        public IEnumerable<DC1> GetDC1(Func<IEnumerable<DC1>> getter) { return getter(); }

        [Serializable]
        public class DC1
        {
            public string DriverId { get; set; }
            public string CHNId { get; set; }
        }
    }
}


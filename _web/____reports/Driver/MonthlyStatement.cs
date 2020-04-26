using System;
using System.Collections.Generic;
namespace eTaxi.Reports.Driver
{
    /// <summary>
    /// 司机月结单
    /// </summary>
    public class RPT_MonthlyStatement : ReportGen
    {
        public class parameters
        {
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
            public string Name { get; set; }
            public string Amount { get; set; }
        }
    }
}


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace eTaxi.Web
{
    /// <summary>
    /// 关键方法执行状态
    /// </summary>
    public enum ManagedMethodExecution
    {
        Waiting, Succeeded, Failed, ByPassed
    }

    /// <summary>
    /// 方法执行器
    /// </summary>
    public class VitalMethodExecution
    {
        public string _Ordinal;
        public string Ordinal { get { return _Ordinal; } }
        public string MethodName { get; set; }
        public ManagedMethodExecution Status { get; set; }
        public Exception ReportedException { get; set; }
        public VitalMethodExecution(string ordinal) { _Ordinal = ordinal; }
    }

    public partial class Global : System.Web.HttpApplication
    {
        /// <summary>
        /// 当前站点所在的物理路径
        /// </summary>
        public static string SitePath = string.Empty;

        /// <summary>
        /// 标识应用程序是否已经完成初始化
        /// </summary>
        private static bool _Initialized = false;
        public static bool Initialized
        {
            get { return _Initialized; }
            set { _Initialized = value; }
        }

        private int _MethodIndex = 0;
        private static List<VitalMethodExecution> _VitalMethodExecutions = new List<VitalMethodExecution>();
        public static List<VitalMethodExecution> VitalMethodExecutions
        {
            get { return _VitalMethodExecutions; }
        }

        /// <summary>
        /// 单线执行器
        /// </summary>
        private void ExecuteVitalMethod(Action a)
        {
            if (_VitalMethodExecutions.Any(m => m.MethodName == a.Method.Name)) return;

            _MethodIndex++;
            VitalMethodExecution execution = new VitalMethodExecution(_MethodIndex.ToString())
            {
                MethodName = a.Method.Name,
                Status = ManagedMethodExecution.Waiting
            };

            _VitalMethodExecutions.Add(execution);
            try
            {
                a(); // 执行方法
                execution.Status = ManagedMethodExecution.Succeeded;
            }
            catch (Exception ex)
            {
                _Initialized = false;
                execution.Status = ManagedMethodExecution.Failed;
                execution.ReportedException = ex;
            }
        }

    }
}
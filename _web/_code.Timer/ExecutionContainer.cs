using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web.UI;
using System.Web.SessionState;
using System.Linq;
using System.Globalization;
using System.Web;
using Microsoft.Practices.Unity;

using LinqKit;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 为 BaseUnit 的执行提供线程管理，避免堵塞
    /// </summary>
    public partial class ExecutionContainer
    {
        public const string BASE_PATH = "_code.timer";
        private List<TimerService.TaskBase> _Tasks = new List<TimerService.TaskBase>();
        private DateTime _CurrentTime = DateTime.Now;

        private object _Locker = new object();
        private bool _IsBusy = false;
        public bool IsBusy { get { return _IsBusy; } }

        private List<string> _FilePaths = new List<string>();
        public List<string> FilePaths { get { return _FilePaths; } }

        public void Pulse(DateTime currentTime)
        {
            if (_FilePaths.Count == 0) return;
            if (_IsBusy) return;
            lock (_Locker)
            {
                if (_IsBusy) return;
                _IsBusy = true;
            }

            _CurrentTime = currentTime;

            // 主逻辑：完成控件的加载和执行
            try
            {
                _Go();
            }
            catch (Exception ex)
            {

#if DEBUG
                throw ex;
#else
                Util.Log("TTask", System.Diagnostics.EventLogEntryType.Warning,
                    string.Format("时序任务执行异常[Go] - {0} | {1}", ex.Message, ex.StackTrace));
#endif

            }
            finally
            {
                lock (_Locker) { _IsBusy = false; }
            }
        }

        private void _Go()
        {
            var uc = new UserControl();
            _Tasks.Clear();
            _FilePaths.ForEach(path =>
            {
                var task = uc.LoadControl(path) as TimerService.TaskBase;
                var dtService = Host.CreateService<CommonService>();
                dtService.Initialize(new AdminSession(_CurrentTime), _CurrentTime, Web.Global.Cache);
                if (task != null && task.Enabled)
                {
                    task.Initialize(dtService, _CurrentTime);
                    _Tasks.Add(task);
                }
            });

            // 执行
            _Tasks.ForEach(t => t.Execute(ex =>
            {
#if DEBUG
                throw ex;
#else
                Util.Log("TTask." + t.Code, System.Diagnostics.EventLogEntryType.Warning,
                    string.Format("时序任务执行异常 - {0} @{1} | {2}", ex.Message, t.CurrentTime.ToISDateWithTime(), ex.StackTrace));
#endif

            }, log =>
            {
                Util.Log("TTask." + t.Code, System.Diagnostics.EventLogEntryType.Information,
                    string.Format("执行成功{0} @{1}", log.ToStringEx(v => string.Format("（{0}）", v)),
                    t.CurrentTime.ToISDateWithTime()));
            }, tip =>
            {
                Util.Log("TTask." + t.Code, System.Diagnostics.EventLogEntryType.Information,
                    string.Format("人为忽略{0} @{1}", tip.ToStringEx(v => string.Format("（{0}）", v)),
                    t.CurrentTime.ToISDateWithTime()));
            }));

        }

    }
}
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
    /// 执行时序任务的引擎（作用：进行线程和操作协调）
    /// </summary>
    public partial class TimerEngine
    {
        private object _Locker = new object();
        private List<ExecutionContainer> _Containers = new List<ExecutionContainer>();
        public List<ExecutionContainer> Containers { get { return _Containers; } }

        public TimerEngine()
        {
            var settings = new SystemSettings();
            for (int i = 0; i < settings.Get<int>("taskExecutionContainerCount"); i++)
                _Containers.Add(new ExecutionContainer());
            LoadTasks();
        }

        public void LoadTasks()
        {
            var files = new Dictionary<string, int>();
            var uc = new UserControl();
            var codes = new List<string>();

            const string BASE_PATH = "_code.timer";
            string[] paths = Directory.GetFiles(Parameters.SitePath + BASE_PATH + "\\tasks");
            paths.ForEach(p =>
            {
                var n = p.Substring(p.LastIndexOf('\\') + 1);
                if (!n.EndsWith(".ascx")) return;
                var path = ("~/" + BASE_PATH + "/tasks/" + n).ToLower();
                var task = uc.LoadControl(path) as TimerService.TaskBase;

                if (task != null)
                {
                    if (codes.Contains(task.Code))
                        throw new Exception(string.Format("控件 {0} 的 Code 命名重复，请检查", path));
                    codes.Add(task.Code);
                    files.Add(path, task.ContainerIndex);
                }
            });
            
            // 分配到容器
            lock (_Locker)
            {
                _Containers.ForEach(c => c.FilePaths.Clear());
                files.ForEach(kv =>
                {
                    if (kv.Value >= _Containers.Count)
                        throw new Exception(string.Format("控件 {0} 的 ContainerIndex 超限，请重新分配", kv.Key));
                    _Containers[kv.Value].FilePaths.Add(kv.Key);    
                });
            }

        }

        public void Pulse()
        {
            lock (_Locker)
            {
                var currentTime = DateTime.Now;
                _Containers.ForEach(c => c.Pulse(currentTime));
            }
        }

    }
}
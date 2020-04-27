using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.ServiceProcess;
using System.Timers;

namespace eTaxi.Service
{
    public partial class Host : ServiceBase
    {
        private Timer _Timer = null;
        private int _ExCount = 0;

        public Host()
        {
            InitializeComponent();
        }

        protected override void OnStop() { _Timer.Stop(); }
        protected override void OnPause() { _Timer.Stop(); }
        protected override void OnContinue()
        {
            _Timer.Start();
        }
        protected override void OnStart(string[] args)
        {
            var settings = new SystemSettings();
            _Timer = new Timer() { Enabled = false };

            var interval = settings.Interval;
            if (interval == 0)
            {
                _Timer.Interval = 5000; // 10 秒一次（用于压力测试）
            }
            else
            {
                _Timer.Interval = interval * 1000 * 60;
            }

            Action<string, List<KeyValuePair<int, int>>> _slotProcess = (v, slots) =>
                {
                    var pair = v.SplitEx('-');
                    if (pair.Length != 2) return;
                    var v1 = pair[0].ToIntOrDefault();
                    var v2 = pair[1].ToIntOrDefault();
                    if (v1 > v2)
                    {
                        slots.Add(new KeyValuePair<int, int>(v2, v1));
                    }
                    else
                    {
                        slots.Add(new KeyValuePair<int, int>(v1, v2));
                    }
                };

            var times = new List<KeyValuePair<int, int>>();
            var days = new List<KeyValuePair<int, int>>();

            settings.DayInfo.SplitEx((data, index) => _slotProcess(data[index], days));
            settings.TimeInfo.SplitEx((data, index) => _slotProcess(data[index], times));

            if (days.Count == 0) days.Add(new KeyValuePair<int, int>(0, 7));
            if (times.Count == 0) times.Add(new KeyValuePair<int, int>(0, 24));

            /// 主程：
            /// 1. 在允许的时间段，日段内，发送 web 服务的心跳驱动
            /// 2. 加入静态挑战字段，屏蔽噪声
            _Timer.Elapsed += (s, e) =>
                {
                    bool dayHit = false;
                    bool timeHit = false;

                    var currentHour = e.SignalTime.Hour;
                    var currentDay = (int)e.SignalTime.DayOfWeek;

                    foreach (var l in days)
                        if (currentDay >= l.Key && currentDay < l.Value) { dayHit = true; break; }
                    foreach (var l in times)
                        if (currentHour >= l.Key && currentHour < l.Value) { timeHit = true; break; }

                    // 比对不中时间发送时间，则退出
                    if (dayHit && timeHit) _Elapse(e.SignalTime, settings.Secret);
                };

            // 开始 Timer 服务
            _Timer.Start();

        }

        private void _Elapse(DateTime currentTime, string secret)
        {
            try
            {
                var remoting = new External.Timer();
                remoting.Elapse(secret);
                _Log("Elapse", System.Diagnostics.EventLogEntryType.Information,
                    string.Format("远程调用成功：{0}", currentTime));
                _ExCount = 0;
            }
            catch (Exception ex)
            {
                _ExCount++;
                if (_ExCount > 50)
                {
                    _Log("Elapse", System.Diagnostics.EventLogEntryType.Information,
                        string.Format("远程调用失效，已累计 {0} 次 | {1}", _ExCount.ToString(), ex.Message));
                    _ExCount = 0;
                }
            }
        }

        private static void _Log(string section, EventLogEntryType type, string message)
        {

#if !DEBUG
            string source = "eTaxi.SV." + section;
            if (!
                EventLog.SourceExists(source))
                EventLog.CreateEventSource(source, "Application");
            EventLog.WriteEntry(source, message, type, 1011);
#endif

        }


    }
}

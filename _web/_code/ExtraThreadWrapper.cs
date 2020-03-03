using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace eTaxi
{
    /// <summary>
    /// 建立一个命名步骤列表，开通线程片段独立执行
    /// </summary>
    public class ExtraThreadWrapper
    {
        private object _Locker = new object();
        private List<string> _Names = new List<string>();
        private List<Action<int>> _Periods = new List<Action<int>>();

        private Exception _Exception = null;
        public Exception Exception { get { return _Exception; } }
        public int Count { get { return _Names.Count; } }

        private int _Index = -1;
        public int Index { get { return _Index; } }

        private string _Name = string.Empty;
        public string Name { get { return _Name; } }

        private bool _Idling = true;
        public bool Idling { get { return _Idling; } }

        public ExtraThreadWrapper Add(string name, Action<int> period)
        {
            _Index = -1;
            _Names.Add(name);
            _Periods.Add(period);
            return this;
        }

        /// <summary>
        /// 异步实现
        /// </summary>
        /// <param name="next"></param>
        public void _Go(Action<string> next = null, bool requireTransaction = false)
        {
            if (_Index >= Count)
            {
                _Idling = true;
                return;
            }

            // 要求同步（锁线程）
            Action _wrap = () => { };
            if (requireTransaction)
            {
                _wrap = () =>
                {
                    Util.TransCall(() =>
                    {
                        for (int i = 0; i < Count; i++)
                        {
                            if (next != null) next(_Names[i]);
                            _Periods[i](i);
                        }
                    }, ex => _Exception = ex, requireTransaction);
                };

                _wrap.BeginInvoke(r =>
                {
                    _wrap.EndInvoke(r);
                    _Idling = true;

                }, null);

                return;
            }

            // 异步执行（迭代）
            
            if (next != null) next(_Names[_Index]);
            _wrap = () =>
            {
                try
                {
                    _Periods[_Index](_Index);
                }
                catch (Exception ex)
                {
                    lock (_Locker)
                    {
                        _Exception = ex;
                    }
                }
            };

            _wrap.BeginInvoke(r =>
            {
                _wrap.EndInvoke(r);
                Exception ex = null;
                lock (_Locker) { ex = _Exception; }

                // 执行下一个
                if (ex == null)
                {
                    _Index++;
                    _Go(next, requireTransaction);
                }
                else
                {
                    _Idling = true;
                }

            }, null);
        }

        /// <summary>
        /// 开线程执行
        /// </summary>
        public void Go(bool requireTransaction = false)
        {
            if (Count == 0 || !_Idling) return;
            _Index = 0;
            _Idling = false;
            _Go((name) => _Name = name, requireTransaction);
        }

        /// <summary>
        /// 重置
        /// </summary>
        public ExtraThreadWrapper New()
        {
            if (!_Idling) throw new Exception("Busy");
            _Names.Clear();
            _Periods.Clear();
            _Exception = null;
            return this;
        }

    }

}
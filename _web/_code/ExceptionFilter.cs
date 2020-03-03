using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web.UI;
using System.Web.SessionState;

namespace eTaxi
{
    /// <summary>
    /// 异常处理过滤器
    /// </summary>
    public class ExceptionFilter
    {
        private Exception _Exception = null;
        public ExceptionFilter(Exception ex) { _Exception = ex; }

        public Exception Exception { get { return _Exception; } }
        public bool Handled { get; set; }

        /// <summary>
        /// 处理 DTException
        /// </summary>
        /// <returns></returns>
        public ExceptionFilter DT(Action<DTException> handleDT)
        {
            _Exception.If<DTException>(handleDT);
            return this;
        }

    }
}
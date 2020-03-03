using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace eTaxi
{
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点。
        /// </summary>
        static void Main()
        {
            var ServicesToRun = new ServiceBase[] { new Service.Host() };
            ServiceBase.Run(ServicesToRun);
        }
    }
}

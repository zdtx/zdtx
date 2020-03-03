using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data.Linq;
using System.Data;
using Microsoft.Practices.Unity;

namespace eTaxi.L2SQL.Plugger
{
    public static class Common
    {
        public static void Register(Microsoft.Practices.Unity.IUnityContainer container)
        {
            container
                .RegisterType<CommonService>()
                ;
        }
    }
}

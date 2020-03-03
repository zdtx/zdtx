using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;
using System.Web.Configuration;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 数据
    /// </summary>
    public class DataConnectionManager : ConnectionManager, IDataConnectionManager
    {
        public DataConnectionManager()
            : base(
            WebConfigurationManager
                .ConnectionStrings[D.NamedSection.DataConnection].ConnectionString) { }
    }

}
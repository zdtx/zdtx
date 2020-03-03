using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Data;
using System.Data.Common;

using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 进行数据库连接串装箱
    /// </summary>
    public interface IConnectionManagerEx: IConnectionManager
    {
        List<DataContextEx> Contexts { get; }
        string InitConnectionString { get; }
        void RegisterContext(DataContextEx context);
        bool TrackingContextExists();
    }

    /// <summary>
    /// 数据库访问连接管理
    /// </summary>
    public interface IDataConnectionManager : IConnectionManagerEx { }

}

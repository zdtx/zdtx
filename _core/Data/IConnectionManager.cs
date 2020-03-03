using System;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace eTaxi
{
    /// <summary>
    /// 进行数据库连接串装箱
    /// </summary>
    public interface IConnectionManager
    {
        DbConnection Connection { get; }
        DbTransaction Transaction { get; }
        DbTransaction StartTransaction();
        void EndTransaction();
        event Action<DbTransaction> TransactionOpened;
        event Action TransactionClosed;
        bool HasTransaction(Action<DbTransaction> transHandle = null);
    }
}

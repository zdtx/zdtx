using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Linq;

using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 连接管理对象
    /// </summary>
    public class ConnectionManager : IDisposable
    {
        private string _InitConnectionString = string.Empty;
        private DbConnection _Connection = null;
        private DbTransaction _Transaction = null;
        private ConnectionState _InitialState = ConnectionState.Closed;
        private Dictionary<int, DataContextEx> _Contexts = new Dictionary<int, DataContextEx>();

        public event Action<DbTransaction> TransactionOpened;
        public event Action TransactionClosed;

        public DbConnection Connection
        {
            get { return _Connection; }
        }

        public DbTransaction Transaction
        {
            get { return _Transaction; }
        }

        public List<DataContextEx> Contexts
        {
            get { return _Contexts.Select(kv => kv.Value).ToList(); }
        }

        public string InitConnectionString
        {
            get { return _InitConnectionString; }
        }

        public bool TrackingContextExists()
        {
            if (_Contexts.Count == 0) return false;
            foreach (var kv in _Contexts) if (kv.Value.ObjectTrackingEnabled) return true;
            return false;
        }

        public void RegisterContext(DataContextEx context)
        {
            int hash = context.GetHashCode();
            if (_Contexts.ContainsKey(hash)) return;
            _Contexts.Add(hash, context);

            // 有事务，则不能创建只读的了
            if (_Transaction != null && _Transaction.Connection != null)
            {
                context.ObjectTrackingEnabled = true;
                context.Transaction = _Transaction;
            }
        }

        public bool HasTransaction(Action<DbTransaction> transHandle = null)
        {
            if (_Transaction != null && _Transaction.Connection != null)
            {
                if (transHandle != null) transHandle(_Transaction);
                return true;
            }
            return false;
        }

        public DbTransaction StartTransaction()
        {
            if (_Transaction != null && _Transaction.Connection != null) return _Transaction;
            _InitialState = _Connection.State;
            if (_InitialState == ConnectionState.Closed) _Connection.Open();
            _Transaction = _Connection.BeginTransaction(IsolationLevel.ReadCommitted);
            if (TransactionOpened != null) TransactionOpened(_Transaction);
            foreach (var kv in _Contexts) kv.Value.Transaction = _Transaction;
            return _Transaction;
        }

        public void EndTransaction()
        {
            try
            {
                if (_Transaction != null) { _Transaction.Dispose(); _Transaction = null; }
                foreach (var kv in _Contexts) kv.Value.Transaction = null;
                if (_InitialState == ConnectionState.Closed) _Connection.Close();
                if (TransactionClosed != null) TransactionClosed();
            }
            catch (Exception)
            {
                // TODO: Logging
            }
        }

        public ConnectionManager(string conn)
        {
            _Connection = new SqlConnection(conn);
            _InitConnectionString = conn;
        }
        public ConnectionManager() { _Connection = new SqlConnection(); }

        public void Dispose()
        {
            _InitialState = ConnectionState.Closed;
            EndTransaction();
            _Connection.Dispose();
        }
    }
}

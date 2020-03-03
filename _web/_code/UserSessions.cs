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
    public class AdminSession : IUserSession
    {
        public string BranchId
        {
            get { return string.Empty; }
        }

        public string DepartmentId
        {
            get { return string.Empty; }
        }

        public string Id
        {
            get { return string.Empty; }
        }

        public string Name
        {
            get { return "系统管理员"; }
        }

        public string[] RoleIds
        {
            get { return new string[] { }; }
        }

        public string UserName
        {
            get { return "admin"; }
        }

        private DateTime _CurrentTime = DateTime.Now;
        public DateTime CurrentTime { get { return _CurrentTime; } }
        public Guid UniqueId { get { return new Guid(D.Login.AdministratorId); } }
        public AdminSession(DateTime currentTime) { _CurrentTime = currentTime; }

    }

}
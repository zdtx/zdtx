using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Expressions;
using System.Data.Linq.Mapping;
using System.Text;
using System.Data;
using System.Data.Linq;
using Microsoft.Practices.Unity;

namespace eTaxi.L2SQL
{
    public partial class CommonService : DTServiceBase<CommonContext>
    {
        /// <summary>
        /// 删除部门
        /// </summary>
        /// <param name="id"></param>
        public void DeleteDepartment(string id)
        {
            if (Context.Persons.Any(p => p.DepartmentId == id))
                throw new Exception("存在捆绑该部门的人员，请先删除");
            if (Context.Departments.Any(d => d.Path.Contains(id)))
                throw new Exception("存在子部门，请先删除");
            if (Context.Cars.Any(c => c.DepartmentId == id))
                throw new Exception("存在车辆档案，请先删除");
            Store<TB_department>().DeleteAll(d => d.Id == id);
        }
    }
}

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
        public void DeletePerson(string id)
        {
            Context
                .Update<TB_person>(_CurrentSession, p => p.Id == id, p => p.Deleted = true)
                .SubmitChanges();
        }
    }
}

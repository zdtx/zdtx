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
        /// 删除岗位
        /// </summary>
        /// <param name="id"></param>
        public void DeletePosition(string id)
        {
            if (Context.Persons.Any(p => p.PositionId == id))
                throw new Exception("存在捆绑该岗位的人员，请先删除");
            Store<TB_position>().DeleteAll(p => p.Id == id);
        }
    }
}

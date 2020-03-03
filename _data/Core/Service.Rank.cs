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
        /// 删除行政级别
        /// </summary>
        /// <param name="id"></param>
        public void DeleteRank(string id)
        {
            if (Context.Positions.Any(p => p.RankId == id))
                throw new Exception("存在捆绑该级别的岗位，请先删除");
            Store<TB_rank>().DeleteAll(r => r.Id == id);
            
        }
    }
}

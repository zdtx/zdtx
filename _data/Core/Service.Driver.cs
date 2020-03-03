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
        /// 删除司机
        /// </summary>
        /// <param name="id"></param>
        public void DeleteDriver(string id)
        {
            if (Context.CarRentals.Any(r => r.DriverId == id))
                throw new Exception("司机存在承租关系，不能删除");
            if (Context.CarRentalHistories.Any(r => r.DriverId == id))
                throw new Exception("司机存在承租关系，不能删除");
            if (Context.CarRentalShifts.Any(r => r.DriverId == id))
                throw new Exception("司机存在代班关系，不能删除");
            Store<TB_driver>().DeleteAll(d => d.Id == id);
        }

        /// <summary>
        /// 解除档案
        /// </summary>
        /// <param name="id"></param>
        public void DisableDriver(string id)
        {
            Context.ExecuteUpdate(new TB_driver()
            {
                Id = id,
                Enabled = false
            }, new string[] { "Enabled" });
        }

    }
}

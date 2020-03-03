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
        /// 删除车辆档案
        /// </summary>
        /// <param name="id"></param>
        public void DeleteCar(string id)
        {
            if (Context.CarRentals.Any(r => r.CarId == id))
                throw new Exception("车辆已进入承租关系，不能删除");
            if (Context.CarRentalHistories.Any(r => r.CarId == id))
                throw new Exception("车辆已进入承租关系，不能删除");
            if (Context.CarRentalShifts.Any(r => r.CarId == id))
                throw new Exception("车辆已进入代班关系，不能删除");
            Store<TB_car>().DeleteAll(c => c.Id == id);
        }
    }
}

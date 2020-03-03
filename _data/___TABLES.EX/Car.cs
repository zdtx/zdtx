using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;

using D = eTaxi.Definitions;
namespace eTaxi.L2SQL
{
    public partial class TB_car : TBObject<TB_car>
    {
        public TB_car()
        {
            Id = "----------";
            Type = (int)D.CarType.GY;
        }
    }

    public partial class TB_car_rental : TBObject<TB_car_rental>
    {
        public TB_car_rental()
        {
            Extra1 = Extra2 = Extra3 = 0;
        }
    }

    public partial class TB_car_rental_shift : TBObject<TB_car_rental_shift>
    {
        public TB_car_rental_shift()
        {
            IsActive = true;
            ConfirmedDays = 0;
        }
    }

    public partial class TB_car_accident : TBObject<TB_car_accident>
    {
        public TB_car_accident()
        {
            RespLevel = (int)D.AccidentFaultLevel.Major;
        }
    }

    public partial class TB_car_violation : TBObject<TB_car_violation>
    {
        public TB_car_violation()
        {
            Type = (int)D.ViolationType.CHD;
            SeverityLevel = (int)D.SeverityLevel.Normal;
        }
    }

    public partial class TB_car_complain : TBObject<TB_car_complain>
    {
        public TB_car_complain()
        {
            Source = (int)D.ComplainSource.DH;
            Type = (int)D.ComplainType.BWM;
        }
    }


}



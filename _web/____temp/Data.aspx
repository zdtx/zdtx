<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" %>

<%@ Import Namespace="ET.L2SQL" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="theHead" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="../../content/scripts/__page.js"></script>
</head>
<body>
    <form runat="server" id="theForm">
        <asp:ScriptManager ID="theManager" runat="server" />
        <dx:ASPxButton runat="server" Text="导入车辆" ID="b1" />
        <br />
        <dx:ASPxButton runat="server" Text="导入司机" ID="b2" />
        <br />
        <dx:ASPxButton runat="server" Text="创建关系" ID="b3" />
        <br />
        <dx:ASPxButton runat="server" Text="重新生成3月份社保" ID="b4" />
    </form>
</body>
</html>
<script runat="server">

    /// <summary>
    /// 旧数据上下文
    /// </summary>
    public class LegacyContext : DataContextEx
    {
        /// <summary>
        /// 车辆信息
        /// </summary>
        public Table<TB_车辆信息> Cars
        {
            get { return this.GetTable<TB_车辆信息>(); }
        }

        /// <summary>
        /// 代班记录
        /// </summary>
        public Table<TB_代班记录> Shifts
        {
            get { return this.GetTable<TB_代班记录>(); }
        }

        /// <summary>
        /// 驾驶员信息
        /// </summary>
        public Table<TB_驾驶员信息> Drivers
        {
            get { return this.GetTable<TB_驾驶员信息>(); }
        }

        /// <summary>
        /// 事故处理
        /// </summary>
        public Table<TB_事故处理> Accidents
        {
            get { return this.GetTable<TB_事故处理>(); }
        }

        /// <summary>
        /// 投诉接待与处理
        /// </summary>
        public Table<TB_投诉接待与处理> Complains
        {
            get { return this.GetTable<TB_投诉接待与处理>(); }
        }

        /// <summary>
        /// 员工账号
        /// </summary>
        public Table<TB_员工账号> Users
        {
            get { return this.GetTable<TB_员工账号>(); }
        }

        public LegacyContext(IDbConnection connection) : base(connection) { }
    }

    private ConnectionManager _CM = new ConnectionManager(
        @"Data Source=.\sqlexpress;Initial Catalog=et;User Id=sa;Password=sa;MultipleActiveResultSets=true");
    private LegacyContext _Context = null;
    protected override bool _LoginRequired { get { return false; } }
    protected override void _SetInitialStates()
    {
        _Context = new LegacyContext(_CM.Connection);
        var session = new AdminSession(_CurrentTime);
        var defaultDate = new DateTime(2000, 1, 1);
        var newContext = _DTService.Context;

        Func<string, Nullable<DateTime>> _processDate = str =>
        {
            var tmp = str.ToStringEx(string.Empty).Replace('/', '-').Replace('.', '-');
            if (tmp.Length < 4) return null;
            var parts = tmp.SplitEx('-');
            if (parts.Length == 1) tmp += "-01-01";
            if (parts.Length == 2) tmp += "-01";
            parts = tmp.SplitEx('-');
            return new DateTime(
                parts[0].ToIntOrDefault(),
                parts[1].ToIntOrDefault(),
                parts[2].ToIntOrDefault());
        };

        b1.Click += (s, e) =>
        {
            _Context.Cars.ToList().ForEach(car =>
            {
                var carId = newContext.NewSequence<TB_car>(session);
                newContext
                    .Create<TB_car>(session, newCar =>
                    {
                        newCar.Id = carId;
                        newCar.PlateNumber = car.车牌号.ToStringEx();
                        newCar.FormerPlateNum = car.原车牌号.ToStringEx(v =>
                        {
                            if (v == "0") return null;
                            return v;
                        });
                        newCar.Company = car.车辆单位.ToStringEx();
                        newCar.Manufacturer = car.车辆品牌型号.ToStringEx();
                        switch (car.车辆性质.ToStringEx())
                        {
                            case "公营":
                                newCar.Type = (int)CarType.GY;
                                break;
                            case "挂靠":
                                newCar.Type = (int)CarType.GK;
                                break;
                            case "收购":
                                newCar.Type = (int)CarType.SG;
                                break;
                            case "个体":
                                newCar.Type = (int)CarType.GT;
                                break;
                        }

                        newCar.Source = car.车辆获得方式.ToStringEx();
                        newCar.EngineNum = car.发动机号.ToStringEx();
                        newCar.CarriageNum = car.车架号.ToStringEx();
                        newCar.SecSerialNum = car.治安证编号.ToStringEx();
                        newCar.License = car.营运证号.ToStringEx();
                        newCar.LicenseRenewTime = defaultDate;
                        newCar.DrvLicense = string.Empty;
                        newCar.DrvLicenseRenewTime = defaultDate;
                        newCar.InsuranceCom = string.Empty;
                        newCar.Premium = 0;
                        newCar.InsuranceEnd = defaultDate;
                        newCar.DepartmentId = string.Empty;
                        newCar.Rental = 0;
                        newCar.HandOverTime = defaultDate;

                    })
                    .SubmitChanges();
            });
        };

        b2.Click += (s, e) =>
        {
            _Context.Drivers.ToList().ForEach(driver =>
            {
                var driverId = newContext.NewSequence<TB_driver>(session);
                var tryDate = DateTime.MinValue;
                if (string.IsNullOrEmpty(driver.姓名.ToStringEx())) return;

                newContext
                    .Create<TB_driver>(session, newDriver =>
                    {
                        newDriver.Id = driverId;
                        newDriver.Name = driver.姓名.ToStringEx();
                        newDriver.FirstName = newDriver.Name.Substring(1);
                        newDriver.LastName = newDriver.Name.Substring(0, 1);
                        switch (driver.性别.ToStringEx())
                        {
                            case "男":
                                newDriver.Gender = true;
                                break;
                            case "女":
                                newDriver.Gender = false;
                                break;
                            default:
                                newDriver.Gender = null;
                                break;
                        }

                        newDriver.CHNId = driver.身份证号码.ToStringEx();
                        if (!string.IsNullOrEmpty(newDriver.CHNId))
                        {
                            try
                            {
                                newDriver.DayOfBirth = new DateTime(
                                    newDriver.CHNId.Substring(6, 4).ToIntOrDefault(),
                                    newDriver.CHNId.Substring(10, 2).ToIntOrDefault(),
                                    newDriver.CHNId.Substring(12, 2).ToIntOrDefault());
                                newDriver.Gender =
                                    newDriver.CHNId.Substring(16, 1).ToIntOrDefault() % 2 != 0;
                            }
                            catch
                            {
                                newDriver.CHNId = null;
                                newDriver.Gender = null;
                                newDriver.DayOfBirth = null;
                            }
                        }

                        if (!newDriver.DayOfBirth.HasValue)
                        {
                            newDriver.DayOfBirth = _processDate(driver.出生年月.ToStringEx());
                        }

                        switch (driver.文化程度.ToStringEx())
                        {
                            case "初中":
                                newDriver.Education = (int)Education.CZ;
                                break;
                            case "大专":
                                newDriver.Education = (int)Education.DZ;
                                break;
                            case "高中":
                                newDriver.Education = (int)Education.GZ;
                                break;
                            case "小学":
                                newDriver.Education = (int)Education.XX;
                                break;
                            case "职高":
                                newDriver.Education = (int)Education.ZG;
                                break;
                            case "中专":
                                newDriver.Education = (int)Education.ZZ;
                                break;
                            default:
                                newDriver.Education = (int)Education.Unknown;
                                break;
                        }

                        switch (driver.政治面貌.ToStringEx())
                        {
                            case "党员":
                            case "中共党员":
                                newDriver.SocialCat = (int)SocialCat.DY;
                                break;
                            case "群众":
                                newDriver.SocialCat = (int)SocialCat.QZ;
                                break;
                        }

                        newDriver.Tel1 = driver.联系电话.ToStringEx(v =>
                        {
                            if (v == "0") return null;
                            return v;
                        });
                        newDriver.HKAddress = driver.户口地址.ToStringEx(v =>
                        {
                            if (v == "0") return null;
                            return v;
                        });
                        newDriver.Address = driver.常住地址.ToStringEx();
                        newDriver.CertNumber = driver.从业资格证号.ToStringEx(v =>
                        {
                            if (v == "0") return null;
                            return v;
                        });
                        newDriver.CareerStart = _processDate(driver.从业时间.ToStringEx());

                        // 人为
                        newDriver.Guarantor = string.Empty;
                        newDriver.Remark = driver.车牌号.ToStringEx(v =>
                        {
                            if (v == "0") return null;
                            return v.ToUpper();
                        });
                        _processDate(driver.上车时间.ToStringEx()).IfNN(startTime =>
                        {
                            newDriver.Tel2 = startTime.Value.ToString("yyyy-MM-dd");
                        });

                    })
                    .SubmitChanges();
            });
        };

        b3.Click += (s, e) =>
        {
            newContext.Drivers.ToList().ForEach(driver =>
            {
                newContext.Cars.SingleOrDefault(c => c.PlateNumber == driver.Remark).IfNN(car =>
                {
                    newContext
                        .Create<TB_car_rental>(session, rental =>
                        {
                            rental.CarId = car.Id;
                            rental.DriverId = driver.Id;
                            rental.Ordinal = 0;
                            rental.IsProbation = false;
                            rental.ProbationExpiryDate = null;
                            rental.Rental = (car.Rental / 2).ToCHNRounded();
                            rental.StartTime = _processDate(driver.Tel2).Value;
                        })
                        .SubmitChanges();
                });
            });
        };

        b4.Click += (s, e) =>
        {
            var march = new DateTime(2016, 3, 1);
            var context = _DTService.Context;
            var rentals = (
                from r in context.CarRentals
                where r.Rental + r.Extra1 + r.Extra2 + r.Extra3 > 0
                select r).ToList();
            var monthInfo = march.ToMonthId();
            rentals.ForEach(r=>
            {
                var newId = context.NewSequence<TB_car_payment>(new AdminSession(march.LastDayDate()));
                var lastDay = march.LastDayDate();
                var gap = (int)lastDay.Subtract(r.StartTime).TotalDays;
                var days = lastDay.Day;
                var countDays = days;
                var extra = r.Extra1 + r.Extra2 + r.Extra3;
                if (gap < countDays) countDays = gap;
                r.LastPaymentGenTime = march.LastDayDate();
                context
                    .Create<TB_car_payment>(new AdminSession(march.LastDayDate()), payment =>
                    {
                        payment.CarId = r.CarId;
                        payment.DriverId = r.DriverId;
                        payment.Id = newId;
                        payment.Name = monthInfo;
                        payment.MonthInfo = monthInfo;
                        payment.Days = days;
                        payment.CountDays = countDays;
                        payment.Due = lastDay;
                        payment.Amount = payment.Paid =
                            (r.Rental * countDays / days + extra).ToCHNRounded();
                    })
                    .SubmitChanges();
            });
        };

    }

    protected override void _Execute()
    {



    }


</script>

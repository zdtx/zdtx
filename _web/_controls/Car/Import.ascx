<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/ProgressReporter.ascx" TagPrefix="uc1" TagName="ProgressReporter" %>
<uc1:ProgressReporter runat="server" ID="pr" />
<uc1:Popup_DX runat="server" ID="pop" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title">
                    <asp:LinkButton runat="server"
                        Text="上传 Excel" ID="bUpload" CssClass="aBtn" CausesValidation="false" />
                </div>
            </th>
        </tr>
        <tr>
            <td class="name"></td>
            <td class="cl">
                <div class="alert" style="padding: 10px; width: 200px;">
                    * 请使用兼容的数据录入模板
                </div>
            </td>
        </tr>
        <tr>
            <td class="name">已上传的文件：
            </td>
            <td class="val">
                <asp:HyperLink runat="server" ID="l_Id" Text="（未上传）" />
            </td>
        </tr>
        <tr runat="server" visible="false" id="tr">
            <td class="name"></td>
            <td class="val">
                <asp:LinkButton runat="server"
                    Text="开始处理" ID="bSubmit" CssClass="aBtn" CausesValidation="false" />
            </td>
        </tr>

    </table>
</asp:Panel>
<script runat="server">

    private string UploadedFilePath = string.Empty;
    public override string ModuleId { get { return Car.Import; } }
    protected override void _SetInitialStates()
    {
        bUpload.Click += (s, e) =>
        {
            pop.PACK_0001();
            pop.Begin<eTaxi.Web.BaseControl>("~/_controls/car/import_upload.ascx",
                null, c =>
                {
                    c.Execute();
                }, c =>
                {
                    c
                        .Width(420)
                        .Height(250)
                        .Title("导入车辆数据上传")
                        .Button(BaseControl.EventTypes.OK, b =>
                        {
                            b.CausesValidation = false;
                            b.Text = "开始上传";
                            b.JSHandle = string.Format(
                                "if({0}.GetFileInputCount()>0){{ISEx.loadingPanel.show('上传中，请稍候..');{0}.Upload();}}else{{alert('请先点击 [浏览] 选定待上传的文件');e.processOnServer=false;}}",
                                pop.HostingControl.ClientID);
                        })
                    ;
                });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            if (c.ModuleId == Car.Contract_Upload)
            {
                if (eType != EventTypes.OK) return;
                if (c.Do(Actions.Save, false))
                {
                    var objectId = c.ViewStateEx.Get<string>(DataStates.ObjectId);
                    var filename = c.ViewStateEx.Get<string>(DataStates.Detail);
                    var extension = c.ViewStateEx.Get<string>(DataStates.Selected);

                    UploadedFilePath = Util.GetPhysicalPath(string.Format("{0}/file/{1}{2}", Parameters.Tempbase, objectId, extension));

                    if (Do(Actions.Add, false))
                    {
                        l_Id.Text = filename;
                        l_Id.NavigateUrl = string.Format("~/{0}/file/{1}{2}", Parameters.Tempbase, objectId, extension);

                        tr.Visible = true;
                        pop.Close();
                    }

                }
            }
        };

        pr.Callback += (caller, text) =>
        {
            if (_SessionEx.ExtraThread.Idling)
            {
                pr.Close();
                if (_SessionEx.ExtraThread.Exception != null)
                {
                    var msg = _SessionEx.ExtraThread.Exception.Message;
                    if (msg.Length > 500) msg = msg.Substring(0, 500);
                    Alert(msg);
                }
                else
                {
                    Alert("操作成功");
                }

                Execute();
                return;
            }

            if (text !=
                _SessionEx.ExtraThread.Name) pr.Show(_SessionEx.ExtraThread.Name);
        };

        bSubmit.Click += (s, e) =>
        {
            var dt = _SessionEx.Get<DataTable>();
            var fields = dt.Rows[1].ItemArray;
            var count = dt.Rows.Count - 3;
            for (var i = 3; i < dt.Rows.Count; i++)
            {
                var plateNumber = dt.Rows[i][0].ToString();
                _SessionEx.ExtraThread.Add(plateNumber, _Do_Save);
            }
            _SessionEx.ExtraThread.Go(true);
            pr.Go(1000);
        };

    }

    protected override void _Do(string section, string subSection = null)
    {
        switch (section)
        {
            case Actions.Add:
                _Do_Add();
                break;
        }
    }

    private void _Do_Add()
    {
        var ds = new DataSet();
        var file = UploadedFilePath;
        using (var stream = System.IO.File.Open(file, System.IO.FileMode.Open, System.IO.FileAccess.Read))
        {
            using (var reader = ExcelReaderFactory.CreateReader(stream))
            {
                ds = reader.AsDataSet();
            }
        }

        _SessionEx.Set(ds.Tables[0]);
    }

    private void _Do_Save(int index)
    {
        var dt = _SessionEx.Get<DataTable>();
        if (dt.Rows.Count <= index + 3) return;

        var fields = dt.Rows[1].ItemArray;
        var values = dt.Rows[index + 3].ItemArray;

        var plateNumber = values[IndexOf("PlateNumber")].ToStringEx();
        var chnId = values[IndexOf("CHNId")].ToStringEx();
        var company = values[IndexOf("Company")].ToStringEx();
        var departmentName = values[IndexOf("DepartmentId")].ToStringEx();

        var context = _DTService.Context;

        // - CHECK
        if (string.IsNullOrEmpty(plateNumber) ||
            string.IsNullOrEmpty(chnId))
        {
            return;
        }

        // - CHECK Department
        var checkDepartment = string.IsNullOrEmpty(departmentName) ? company : departmentName;
        if (string.IsNullOrEmpty(checkDepartment))
        {
            return;
        }

        var department = Global.Cache.GetDepartment(d => d.Name.Trim() == checkDepartment.Trim());
        var departmentId = department.Id;
        if (string.IsNullOrEmpty(departmentId))
        {
            context
                .NewSequence<TB_department>(_SessionEx, (seq, id) =>
                {
                    departmentId = id;
                })
                .Create<TB_department>(_SessionEx, d =>
                {
                    d.Id = departmentId;
                    d.Name = string.IsNullOrEmpty(departmentName) ? company : departmentName;
                    _RoleProvider.CreateRole(departmentId);
                })
                .SubmitChanges();

            Global.Cache.SetDirty(CachingTypes.Department);
        }

        var car = context.Cars.SingleOrDefault(c => c.PlateNumber == plateNumber);
        var driver = context.Drivers.SingleOrDefault(d => d.CHNId == chnId);
        var newId = string.Empty;

        if (car == null)
        {
            // 车辆建档
            context

                .NewSequence<TB_car>(_SessionEx, (seq, id) =>
                {
                    newId = id;
                })

                .Create<TB_car>(_SessionEx, newCar =>
                {
                    car = newCar;
                    car.Id = newId;

                    SetValues(car, values, (f, v) =>
                    {
                        switch (f)
                        {
                            case "Type": return GetCarType(v);
                            case "HandOverTime": return GetHandOverTime(v, DateTime.Now.Date);
                            case "LicenseRenewTime": return GetDateTime(v, DateTime.Now.Date);
                            case "DrvLicenseRenewTime": return GetDateTime(v, DateTime.Now.Date);
                            case "InsuranceEnd": return GetDateTime(v, DateTime.Now.Date);
                            case "Premium": return GetDecimal(v, 0);
                            case "Rental": return GetDecimal(v, 0);

                            case "Company": return v.ToStringEx(string.Empty);
                            case "Manufacturer": return v.ToStringEx(string.Empty);
                            case "Source": return v.ToStringEx(string.Empty);
                            case "CarriageNum": return v.ToStringEx(string.Empty);
                            case "SecSerialNum": return v.ToStringEx(string.Empty);
                            case "License": return v.ToStringEx(string.Empty);
                            case "DrvLicense": return v.ToStringEx(string.Empty);
                            case "InsuranceCom": return v.ToStringEx(string.Empty);

                            default:
                                return v.ToStringEx();
                        }
                    });

                    car.DepartmentId = departmentId;
                    if (string.IsNullOrEmpty(car.Company)) car.Company = departmentName;

                    var secret = Host.Settings.Get<string>("apiSecret");
                    var response = PostExternal(new
                    {
                        brand = car.Manufacturer,
                        businessDistrict = car.Fleet,
                        buytime = "",
                        color = "",
                        companyId = "",
                        companyName = car.Company,
                        createBy = "",
                        createTime = "",
                        delFlag = 0,
                        engineNo = car.EngineNum,
                        isOnline = 0,
                        issuingAgency = "",
                        licenseNumber = "",
                        moduleCtlPass = "",
                        moduleHardVersion = "",
                        moduleInstallPerson = "",
                        moduleInstallPlace = "",
                        moduleNo = car.ModuleNo,
                        moduleProtocol = "",
                        moduleRemark = "",
                        moduleSim = "",
                        moduleSoftVersion = "",
                        moduleType = "",
                        name = car.PlateNumber,
                        ownerName = "",
                        ownerPhone = "",
                        ownerSex = "",
                        photoUrls = "",
                        remark = "",
                        status = 0,
                        token = secret.ToMd5(),
                        type = "",
                        updateBy = "",
                        updateTime = "",
                        validityEnd = "",
                        validityStart = "",
                        vinCode = ""

                    }, "car/save");

                    try
                    {
                        dynamic x = JsonConvert.DeserializeObject<System.Dynamic.ExpandoObject>(response);
                        if (string.IsNullOrEmpty(x.result.id))
                        {
                            throw new Exception(response);
                        }

                        car.ZId = x.result.id;
                    }
                    catch
                    {
                        throw new Exception("填报不成功：" + response);
                    }
                })

                .SubmitChanges();
        }

        if (driver == null)
        {
            var lastName = values[IndexOf("LastName")].ToStringEx();
            var firstName = values[IndexOf("FirstName")].ToStringEx();

            if (string.IsNullOrEmpty(firstName) ||
                string.IsNullOrEmpty(lastName)) return;

            // 司机建档
            context

                .NewSequence<TB_driver>(_SessionEx, (seq, id) =>
                {
                    newId = id;
                })

                .Create<TB_driver>(_SessionEx, newDriver =>
                {
                    driver = newDriver;
                    driver.Id = newId;
                    driver.LastName = lastName;
                    driver.FirstName = firstName;
                    driver.CHNId = chnId;

                    driver.DayOfBirth = new DateTime(
                        driver.CHNId.Substring(6, 4).ToIntOrDefault(),
                        driver.CHNId.Substring(10, 2).ToIntOrDefault(),
                        driver.CHNId.Substring(12, 2).ToIntOrDefault());
                    driver.Gender = driver.CHNId.Substring(16, 1).ToIntOrDefault() % 2 > 0;

                    SetValues(driver, values, (f, v) =>
                    {
                        switch (f)
                        {
                            case "DayOfBirth": return GetDateTime(v);
                            case "CareerStart": return GetDateTime(v);

                            case "Name": return v.ToStringEx(string.Format("{0}{1}", lastName, firstName));
                            case "Guarantor": return v.ToStringEx(string.Empty);
                            case "Gender": return GetGender(v);
                            case "Education": return GetEducation(v);
                            case "SocialCat": return GetSocialCat(v);
                            default:
                                return v.ToStringEx();
                        }
                    });

                    driver.Name = string.Format("{0}{1}", lastName, firstName);

                    var secret = Host.Settings.Get<string>("apiSecret");
                    var response = PostExternal(new
                    {
                        carId = car.ZId,
                        carName = car.PlateNumber,
                        certficateUnit = "",
                        companyId = "",
                        companyName = car.Company,
                        createBy = "",
                        createTime = "",
                        delFlag = 0,
                        driverIdcard = driver.CHNId,
                        driverName = driver.Name,
                        driverPhone = driver.Tel1,

                        operationNo = "",
                        operationRealNo = driver.CertNumber,
                        photoUrls = "",
                        remark = "",
                        starLevel = "",
                        supervisesTel = "",
                        token = secret.ToMd5(),
                        updateBy = "",
                        updateTime = ""

                    }, "driver/save");

                    try
                    {
                        dynamic x = JsonConvert.DeserializeObject<System.Dynamic.ExpandoObject>(response);
                        if (string.IsNullOrEmpty(x.result.id))
                        {
                            throw new Exception(response);
                        }

                        driver.ZId = x.result.id;
                    }
                    catch
                    {
                        throw new Exception("填报不成功：" + response);
                    }
                })

                .SubmitChanges();
        }

        var rental = context.CarRentals.SingleOrDefault(r => r.CarId == car.Id && r.DriverId == driver.Id);
        if (rental == null)
        {
            // 承租建档
            context

                .Create<TB_car_rental>(_SessionEx, newRental =>
                {
                    rental = newRental;
                    rental.CarId = car.Id;
                    rental.DriverId = driver.Id;

                    SetValues(rental, values, (f, v) =>
                    {
                        switch (f)
                        {
                            case "StartTime": return GetDateTime(v, DateTime.Now.Date);

                            case "Rental": return GetDecimal(v, 0);
                            case "Extra1": return GetDecimal(v, 0);
                            case "Extra2": return GetDecimal(v, 0);
                            case "Extra3": return GetDecimal(v, 0);
                            case "IsProbation": return false;
                            case "ProbationExpiryDate": return GetDateTime(v);
                            default:
                                return v.ToStringEx();
                        }
                    });

                    rental.Rental = car.Rental;
                    rental.IsProbation = false;

                    if (rental.Rental == 0)
                    {
                        rental.Rental = GetDecimal(values[IndexOf("Rental", true)], 0) ?? 0;
                    }

                })

                .SubmitChanges();
        }

    }

    private void SetValues<T>(T obj, object[] values, Func<string, object, object> getValue)
    {
        var dt = _SessionEx.Get<DataTable>();
        var fields = dt.Rows[1].ItemArray;
        foreach (var f in fields)
        {
            var field = f.ToStringEx();
            if (string.IsNullOrEmpty(field)) continue;
            var p = typeof(T).GetProperty(field);
            if (p == null) continue;
            var value = values[IndexOf(field)];
            p.SetValue(obj, getValue(field, value), null);
        }
    }

    private int GetCarType(object value)
    {
        var carType = CarType.GY;
        if (value == null) return (int)carType;
        switch (value.ToStringEx())
        {
            default: carType = CarType.GY; break;
            case "公营": carType = CarType.GY; break;
            case "挂靠": carType = CarType.GK; break;
            case "收购": carType = CarType.SG; break;
            case "众联": carType = CarType.ZL; break;
            case "个体": carType = CarType.GT; break;
        }
        return (int)carType;
    }

    private Nullable<DateTime> GetHandOverTime(object value, DateTime? defaultValue = null)
    {
        if (value == null) return defaultValue;
        TimeSpan ts = TimeSpan.Zero;
        if (TimeSpan.TryParse(value.ToStringEx(), out ts))
        {
            return new DateTime(2000, 1, 1).Add(ts);
        }
        return defaultValue;
    }

    private Nullable<DateTime> GetDateTime(object value, DateTime? defaultValue = null)
    {
        if (value == null) return defaultValue;
        DateTime dt = DateTime.Now.Date;
        var strValue = value.ToStringEx(string.Empty);
        if (strValue.Length == 8)
        {
            int year = 0;
            int month = 0;
            int day = 0;
            if (int.TryParse(strValue.Substring(0, 4), out year))
            {
                if (int.TryParse(strValue.Substring(4, 2), out month))
                {
                    if (int.TryParse(strValue.Substring(6, 2), out day))
                    {
                        try
                        {
                            return new DateTime(year, month, day);
                        }
                        catch
                        {
                            return null;
                        }
                    }
                }
            }
        }
        if (DateTime.TryParse(value.ToStringEx(), out dt))
        {
            return dt;
        }
        return defaultValue;
    }

    private Nullable<decimal> GetDecimal(object value, decimal? defaultValue = null)
    {
        if (value == null) return defaultValue;
        decimal dm = 0;
        if (decimal.TryParse(value.ToStringEx(), out dm))
        {
            return dm;
        }
        return defaultValue;
    }

    private int IndexOf(string name, bool fromLast = false)
    {
        var dt = _SessionEx.Get<DataTable>();
        var fields = dt.Rows[1].ItemArray;

        if (fromLast)
        {
            for (var i = fields.Length - 1; i >= 0; i--)
            {
                if (fields[i].ToStringEx() == name) return i;
            }
        }
        else
        {
            for (var i = 0; i < fields.Length; i++)
            {
                if (fields[i].ToStringEx() == name) return i;
            }
        }
        return -1;
    }

    private bool? GetGender(object value)
    {
        if (value == null) return null;
        switch (value.ToStringEx())
        {
            case "男": return true;
            case "女": return false;
            default: return null;
        }
    }

    private int GetEducation(object value)
    {
        var education = Education.Unknown;
        if (value == null) return (int)education;
        switch (value.ToStringEx())
        {
            default: education = Education.Unknown; break;
            case "小学或以下": education = Education.XX; break;
            case "初中": education = Education.CZ; break;
            case "高中": education = Education.GZ; break;
            case "大专": education = Education.DZ; break;
            case "本科或以上": education = Education.DB; break;
            case "职高": education = Education.ZG; break;
            case "中专": education = Education.ZZ; break;
        }
        return (int)education;
    }

    private int GetSocialCat(object value)
    {
        var socialCat = SocialCat.QZ;
        switch (value.ToStringEx())
        {
            case "群众": socialCat = SocialCat.QZ; break;
            case "党员": socialCat = SocialCat.DY; break;
            case "共青团员": socialCat = SocialCat.TY; break;
            default: socialCat = SocialCat.QZ; break;
        }
        return (int)socialCat;
    }

</script>

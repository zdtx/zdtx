<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/PopupField_DX.ascx" TagPrefix="uc1" TagName="PopupField_DX" %>

<uc1:Popup_DX runat="server" ID="pop" />
<uc1:FormHelper runat="server" ID="fh" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title">
                    基本信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">（系统唯一码）
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Id" />
            </td>
        </tr>
        <tr>
            <td class="name">全名
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Name" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">姓
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_LastName" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">名
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_FirstName" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">身份证号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_CHNId" Width="200">
                    <MaskSettings Mask="000000-<1..2>0000000-000<0|1|2|3|4|5|6|7|8|9|X>" />
                </dx:ASPxTextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="tips" style="padding:5px;">
                <asp:LinkButton runat="server"
                    Text="通过身份证号生成性别和出生年月日" ID="lbCal" CssClass="aBtn" CausesValidation="false" />
            </td>
        </tr>
        <tr>
            <td class="name">性别
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Gender" />
            </td>
        </tr>
        <tr>
            <td class="name">出生年月日
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_DayOfBirth" />
            </td>
        </tr>
        <tr>
            <td class="name">文化程度
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_Education" Width="200"
                    NullText="请选择文化程度" />
            </td>
        </tr>
        <tr>
            <td class="name">政治面貌
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_SocialCat" Width="200"
                    NullText="请选择政治面貌" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top: 15px;">
                    联系信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">电话
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Tel1" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">常住地址
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Address" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">户口地址
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_HKAddress" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">亲属联系人
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_ContactPerson" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">亲属联系电话
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_ContactNumber" Width="200" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top: 15px;">
                    管理信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">介绍人
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Guarantor" 
                    Width="200" ForeColor="Red" Font-Bold="true" />
            </td>
        </tr>
        <tr>
            <td class="name">司机卡号（工号）
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_EmployeeId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">从业时间
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_CareerStart" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">从业资格证号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_CertNumber" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">银行卡号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_BankAccount" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">司管员姓名
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Manager" Width="200" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top: 15px;">
                    分配车辆
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">选择车辆
            </td>
            <td class="val">
                <uc1:PopupField_DX runat="server" ID="pf_CarId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">承包金/管理费
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Rental" Text="（请先选择车辆）" />
            </td>
        </tr>
        <tr>
            <td class="name">社保金
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Extra1" Number="0" Width="200" DisplayFormatString="{0:N} 元">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">生效时间（默认今天）
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_StartTime" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">是否试用（请酌情勾选）
            </td>
            <td class="cl">
                <dx:ASPxCheckBox ID="ck_IsProbation" runat="server" Text="是" AutoPostBack="true" />
            </td>
        </tr>
        <tr id="tr" runat="server" visible="false">
            <td class="name">试用到期日
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_ProbationExpiryDate" Width="200" NullText="请填写试用到期时间"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">备注
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Remark" Width="300" Rows="5" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public override string ModuleId { get { return Driver.Create; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(tb_FirstName).IsRequired();
        fh.Validate(tb_LastName).IsRequired();
        fh.Validate(tb_CHNId).IsRequired();
        fh.Validate(tb_CertNumber).IsRequired();
        fh.Validate(tb_Guarantor).IsRequired();
        fh.Validate(de_CareerStart).IsRequired();
        fh.Validate(tb_Address).IsRequired();
        fh.Validate(pf_CarId).IsRequired();
        fh.Validate(de_ProbationExpiryDate).IsRequired();
        cb_Education.FromEnum<Education>(valueAsInteger: true);
        cb_SocialCat.FromEnum<SocialCat>(valueAsInteger: true);
        tb_FirstName.ClientInstanceName = ClientID + "__f";
        tb_LastName.ClientInstanceName = ClientID + "__l";
        tb_Name.ClientSideEvents.LostFocus = string.Format(
@"function(s,e){{if(s.GetText()=='')return;{0}.SetText(s.GetText().substring(0,1));{1}.SetText(s.GetText().substring(1));}}",
        tb_LastName.ClientInstanceName, tb_FirstName.ClientInstanceName);
        lbCal.Click += (s, e) =>
        {
            l_DayOfBirth.Text = "（请先正确填写身份证号）";
            l_Gender.Text = "（请先正确填写身份证号）";
            if (string.IsNullOrEmpty(tb_CHNId.Value.ToStringEx()))
            {
                Alert("身份证号未填报");
                return;
            }
            var id = tb_CHNId.Value.ToStringEx().Replace("-", string.Empty);
            if (string.IsNullOrEmpty(id))
            {
                Alert("身份证号未填报");
                return;
            }
            try
            {
                l_DayOfBirth.Text = new DateTime(
                    id.Substring(6, 4).ToIntOrDefault(),
                    id.Substring(10, 2).ToIntOrDefault(),
                    id.Substring(12, 2).ToIntOrDefault()).ToISDate();
                l_Gender.Text =
                    id.Substring(16, 1).ToIntOrDefault() % 2 == 0 ?
                    "女" : "男";
                cb_Education.Focus();
            }
            catch
            {
                Alert("身份证号格式错误");
            }
        };

        pf_CarId.Initialize<eTaxi.Web.Controls.Selection.Car.Item>(pop,
            "~/_controls.helper/selection/car/item.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择车辆";
                pop.Width = 600;
                pop.Height = 450;
                if (isFirst) cc.Execute();
            }, (c, b, h) =>
            {
                var carId = c.Selection[0].Id;
                var context = _DTContext<CommonContext>(true);
                if (context.CarRentals.Count(r => r.CarId == carId) >= 2)
                {
                    Alert("车辆已经存在正班司机，请先解除关系");
                    return false;
                }

                context.Cars.SingleOrDefault(o => o.Id == carId).IfNN(o =>
                {
                    l_Rental.Text = o.Rental.ToStringOrEmpty(comma: true, emptyValue: "（未设置）");
                });

                b.Text = c.Selection[0].PlateNumber;
                h.Value = c.Selection[0].Id;
                pop.Close();
                return true;
            }, null, c => c.Button(BaseControl.EventTypes.OK, s => s.CausesValidation = false));

        ck_IsProbation.CheckedChanged += (s, e) =>
        {
            tr.Visible = ck_IsProbation.Checked;
            if (!
                string.IsNullOrEmpty(de_StartTime.Value.ToStringEx()))
                de_ProbationExpiryDate.Date = de_StartTime.Date.AddMonths(3);
        };

    }

    protected override void _Execute()
    {
        p.Controls.PresentedBy(new TB_driver(), (d, n, c) =>
        {

        }, recursive: false);
        l_Id.Text = "（保存后系统自动生成）";
        l_DayOfBirth.Text = "（请先正确填写身份证号）";
        l_Gender.Text = "（请先正确填写身份证号）";
        de_StartTime.Value = _CurrentTime.Date;
    }

    protected override void _Do(string section, string subSection = null)
    {
        switch (section)
        {
            case Actions.Save:
                _Do_Save();
                break;
        }
    }

    private void _Do_Save()
    {
        var context = _DTService.Context;
        var newId = string.Empty;
        var car = context.Cars.FirstOrDefault(c => c.Id == pf_CarId.Value);
        if (car == null ) //|| string.IsNullOrEmpty(car.ZId))
            throw new Exception("找不到车辆档案，请检查：" + pf_CarId.Value);
        var department = Global.Cache.GetDepartment(d => d.Id == car.DepartmentId);

        context
            .NewSequence<TB_driver>(_SessionEx, (seq, id) =>
            {
                newId = id;
            })
            .Create<TB_driver>(_SessionEx, driver =>
            {
                _Util.FillObject(p.Controls, driver, (nn, pp, cc) =>
                {
                    switch (nn)
                    {
                        case "CHNId":
                            pp.SetValue(driver,
                                tb_CHNId.Value.ToStringEx().Replace("-", string.Empty), null);
                            break;
                    }

                }, recursive: false);

                driver.Id = newId;
                driver.DayOfBirth = new DateTime(
                    driver.CHNId.Substring(6, 4).ToIntOrDefault(),
                    driver.CHNId.Substring(10, 2).ToIntOrDefault(),
                    driver.CHNId.Substring(12, 2).ToIntOrDefault());
                driver.Gender = driver.CHNId.Substring(16, 1).ToIntOrDefault() % 2 > 0;

                var secret = Host.Settings.Get<string>("apiSecret");
                //var response = PostExternal(new
                //{
                //    carId = car.ZId,
                //    carName = car.PlateNumber,
                //    certficateUnit = "",
                //    companyId = "",
                //    companyName = department.Name,
                //    createBy = "",
                //    createTime = "",
                //    delFlag = 0,
                //    driverIdcard = driver.CHNId,
                //    driverName = driver.Name,
                //    driverPhone = driver.Tel1,

                //    operationNo = "",
                //    operationRealNo = driver.CertNumber,
                //    photoUrls = "",
                //    remark = "",
                //    starLevel = "",
                //    supervisesTel = "",
                //    token = secret.ToMd5(),
                //    updateBy = "",
                //    updateTime = ""

                //}, "driver/save");

                //try
                //{
                //    dynamic x = JsonConvert.DeserializeObject<System.Dynamic.ExpandoObject>(response);
                //    if (string.IsNullOrEmpty(x.result.id))
                //    {
                //        throw new Exception(response);
                //    }

                //    driver.ZId = x.result.id;
                //}
                //catch
                //{
                //    throw new Exception("填报不成功：" + response);
                //}

            })

            .SubmitChanges();

        // 加入车辆捆绑关系
        var newRentalId = context.NewSequence<TB_car_rental>(_SessionEx);
        var rentals = context.CarRentals.Where(r => r.CarId == pf_CarId.Value).ToList();
        context
            .Create<TB_car_rental>(_SessionEx, r =>
            {
                r.CarId = pf_CarId.Value;
                r.DriverId = newId;
                r.Ordinal = rentals.Count;
                r.StartTime = de_StartTime.Date;
                r.Rental = (car.Rental / (rentals.Count + 1)).ToCHNRounded();
                r.Extra1 = sp_Extra1.Number;
                r.IsProbation = ck_IsProbation.Checked;
                if (!
                    string.IsNullOrEmpty(de_ProbationExpiryDate.Value.ToStringEx()))
                    r.ProbationExpiryDate = de_ProbationExpiryDate.Date;
            })

            .SubmitChanges();

        // 更新控件的 id 归属
        _ViewStateEx.Set(newId, DataStates.ObjectId);
    }

</script>

<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
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
            <td class="name">（车辆系统唯一码）
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Id" />
            </td>
        </tr>
        <tr>
            <td class="name">车牌号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_PlateNumber" />
            </td>
        </tr>
        <tr>
            <td class="name">原车牌号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_FormerPlateNum" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆单位
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Company" />
            </td>
        </tr>
        <tr>
            <td class="name">发动机号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_EngineNum" />
            </td>
        </tr>
        <tr>
            <td class="name">车架号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_CarriageNum" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆品牌
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Manufacturer" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆型号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Model" />
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
            <td class="name">当前驾驶
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="lDrivers" />
            </td>
        </tr>
        <tr>
            <td class="name">管理费
            </td>
            <td class="val">
                <asp:Label runat="server" ID="lb_Rental" Width="300" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆性质
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Type" />
            </td>
        </tr>
        <tr>
            <td class="name">获得方式
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Source" />
            </td>
        </tr>
        <tr>
            <td class="name">部门归属
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Department" />
            </td>
        </tr>
        <tr>
            <td class="name">车队
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Fleet" />
            </td>
        </tr>
        <tr>
            <td class="name">治安证号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_SecSerialNum" />
            </td>
        </tr>
        <tr>
            <td class="name">营运证号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_License" />
            </td>
        </tr>
        <tr>
            <td class="name">营审到期日
            </td>
            <td class="val">
                <asp:Label runat="server" ID="lb_LicenseRenewTime" />
            </td>
        </tr>
        <tr>
            <td class="name">行驶证号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_DrvLicense" />
            </td>
        </tr>
        <tr>
            <td class="name">行审到期日
            </td>
            <td class="val">
                <asp:Label runat="server" ID="lb_DrvLicenseRenewTime" />
            </td>
        </tr>
        <tr>
            <td class="name">交接班地点
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_HandOverPlace" />
            </td>
        </tr>
        <tr>
            <td class="name">交接班时间
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_HandOverTime" />
            </td>
        </tr>
        <tr>
            <td class="name">承保公司
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_InsuranceCom" />
            </td>
        </tr>
        <tr>
            <td class="name">保单号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_InsuranceTransCode" />
            </td>
        </tr>
        <tr>
            <td class="name">保险到期日
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_InsuranceEnd" />
            </td>
        </tr>
        <tr>
            <td class="name">保险费用
            </td>
            <td class="val">
                <asp:Label runat="server" ID="lb_Premium" />
            </td>
        </tr>
        <tr>
            <td class="name">定点维修公司
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_ServiceCom" />
            </td>
        </tr>
        <tr>
            <td class="name">备注
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Remark" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public override string ModuleId { get { return Car.View; } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var car = context.Cars.SingleOrDefault(c => c.Id == _ObjectId);
        if (car == null) throw DTException.NotFound<TB_car>(_ObjectId);
        p.Controls.PresentedBy(car, (d, n, c) =>
        {
            switch (n)
            {
                case "Rental":
                    c.As<Label>().Text = d.Rental.ToStringOrEmpty(comma: true);
                    break;
                case "LicenseRenewTime":
                    c.As<Label>().Text = d.LicenseRenewTime.ToISDate();
                    break;
                case "DrvLicenseRenewTime":
                    c.As<Label>().Text = d.DrvLicenseRenewTime.ToISDate();
                    break;
                case "InsuranceEnd":
                    c.As<Literal>().Text = d.InsuranceEnd.ToISDate();
                    break;
                case "HandOverTime":
                    c.As<Literal>().Text = "（无）";
                    d.HandOverTime.IfNN(dd =>
                    {
                        c.As<Literal>().Text = dd.Value.ToString("HH:mm");
                    });
                    break;
                case "Premium":
                    c.As<Label>().Text = d.Premium.ToStringOrEmpty(comma: true);
                    break;
            }
        }, recursive: false);

        l_Department.Text =
            Global.Cache.GetDepartment(d => d.Id == car.DepartmentId).Name;
        l_Type.Text =
            DefinitionHelper.Caption(Util.ParseEnum<CarType>(car.Type, CarType.GY));

        var currentDrivers = (
            from r in context.CarRentals
            join o in context.Drivers on r.DriverId equals o.Id
            where r.CarId == _ObjectId
            select new
            {
                r.CarId,
                r.DriverId,
                o.Name,
                r.IsProbation,
                r.ProbationExpiryDate
            }).ToList();
        var shiftDrivers = (
            from s in context.CarRentalShifts
            join o in context.Drivers on s.SubDriverId equals o.Id
            where s.CarId == _ObjectId && s.IsActive
            select new
            {
                s.CarId,
                s.DriverId,
                o.Name,
                s.EndTime
            }).ToList();

        lDrivers.Text = string.Empty;
        currentDrivers.ForEach(o =>
        {
            var probation = string.Empty;
            if (o.IsProbation)
                probation = string.Format("试用中.. {0}",
                    o.ProbationExpiryDate.HasValue ?
                        "截止：" + o.ProbationExpiryDate.Value.ToISDate() : string.Empty);
            lDrivers.Text += string.Format("- {0}{1}<br/>", o.Name, probation);
        });
        shiftDrivers.ForEach(o =>
        {
            lDrivers.Text += string.Format("- {0} （代班至：{1}）<br/>", o.Name, o.EndTime.ToISDate());
        });
        if (string.IsNullOrEmpty(lDrivers.Text)) lDrivers.Text = "（无）";

    }

    protected override void _Do(string section, string subSection = null)
    {
    }

</script>

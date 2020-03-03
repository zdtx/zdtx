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
                    换车（变更车辆品牌、车架、发动机等）
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
            <td class="name">车辆单位
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Company" />
            </td>
        </tr>
        <tr>
            <td class="name">当前信息
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="lCurrent" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title">
                    变更为   ↓ 
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">发动机号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_EngineNum" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车架号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_CarriageNum" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆品牌
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Manufacturer" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆型号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Model" Width="200" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Replace_Update; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_CarriageNum).IsRequired();
        fh.Validate(tb_Manufacturer).IsRequired();
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        context.Cars.SingleOrDefault(c => c.Id == _ObjectId).IfNN(car =>
        {
            l_Id.Text = car.Id;
            l_Company.Text = car.Company;
            l_PlateNumber.Text = car.PlateNumber;
            lCurrent.Text = string.Empty;
            lCurrent.Text += "发动机号：" + car.EngineNum.ToStringEx("（未填报）");
            lCurrent.Text += "<br />车架号：" + car.CarriageNum.ToStringEx("（未填报）");
            lCurrent.Text += "<br />车辆品牌：" + car.Manufacturer.ToStringEx("（未填报）");
            lCurrent.Text += "<br />车辆型号：" + car.Model.ToStringEx("（未填报）");

            p.Controls.Reset();
            
        }, () =>
        {
            throw DTException.NotFound<TB_car>(_ObjectId);
        });
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        var context = _DTContext<CommonContext>();
        context
            .Single<TB_car>(c => c.Id == _ObjectId, car =>
                {
                    var newId = context.NewSequence<TB_car_replace>(_SessionEx);
                    context.Create<TB_car_replace>(_SessionEx, replace =>
                        {
                            replace.CarId = _ObjectId;
                            replace.Id = newId;
                            replace.Manufacturer = car.Manufacturer;
                            replace.Model = car.Model;
                            replace.EngineNum = car.EngineNum;
                            replace.CarriageNum = car.CarriageNum;
                        });
                    
                    car.EngineNum = tb_EngineNum.Text;
                    car.CarriageNum = tb_CarriageNum.Text;
                    car.Manufacturer = tb_Manufacturer.Text;
                    car.Model = tb_Model.Text;
                    
                })
            .SubmitChanges();
    }

</script>

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
                    更新车险
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
            <td class="name">当前保险公司
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_InsuranceCom" />
            </td>
        </tr>
        <tr>
            <td class="name">当前保险费用
            </td>
            <td class="val">
                <asp:Label runat="server" ID="lb_Premium" />
            </td>
        </tr>
        <tr>
            <td class="name">当前保险到期日
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_InsuranceEnd" />
            </td>
        </tr>
        <tr>
            <td colspan="2" class="tips" style="padding:5px;">
                <asp:LinkButton runat="server"
                    Text="延续上一年" ID="lb" CssClass="aBtn" CausesValidation="false" />
            </td>
        </tr>
        <tr>
            <td class="name">保险公司
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_InsuranceCom" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">保险费用
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_Premium" Width="200"
                    NullText="请输入年度保险缴费金额"
                    DisplayFormatString="{0:N} 元" MaxValue="1000000" MinValue="0">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <td class="name">保险到期日
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_InsuranceEnd" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Insurance_Update; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_InsuranceCom).IsRequired();
        fh.Validate(sp_Premium).IsRequired();
        fh.Validate(de_InsuranceEnd).IsRequired();
        lb.Click += (s, e) =>
        {
            var context = _DTContext<CommonContext>(true);
            context.Cars.SingleOrDefault(c => c.Id == _ObjectId).IfNN(car =>
            {
                tb_InsuranceCom.Text = car.InsuranceCom;
                sp_Premium.Number = car.Premium;
            });            
        };
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        context.Cars.SingleOrDefault(c => c.Id == _ObjectId).IfNN(car =>
        {
            l_Id.Text = car.Id;
            l_Company.Text = car.Company;
            l_PlateNumber.Text = car.PlateNumber;
            l_InsuranceCom.Text = car.InsuranceCom;
            l_InsuranceEnd.Text = car.InsuranceEnd.ToISDate();
            lb_Premium.Text = car.Premium.ToStringOrEmpty(comma: true);

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
        var car = context.Cars.SingleOrDefault(o => o.Id == _ObjectId);
        var newId = string.Empty;
        if (car == null) throw DTException.NotFound<TB_car>(_ObjectId);
        context
            .NewSequence<TB_car_insurance>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_insurance>(_SessionEx, o =>
                {
                    o.CarId = car.Id;
                    o.Id = newId;
                    o.InsuranceCom = car.InsuranceCom;
                    o.InsuranceEnd = car.InsuranceEnd;
                    o.Premium = car.Premium;
                })
            .Update<TB_car>(_SessionEx, o => o.Id == _ObjectId, o =>
                {
                    o.InsuranceCom = tb_InsuranceCom.Text;
                    o.InsuranceEnd = de_InsuranceEnd.Date;
                    o.Premium = sp_Premium.Number;
                })
            .SubmitChanges();
    }

</script>

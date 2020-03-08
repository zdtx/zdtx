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
                <div class="title" style="margin-top:10px;">
                    出租车合同
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
        <tr id="tr" runat="server" visible="false">
            <td colspan="2" class="tips" style="padding:5px;">
                <asp:Label runat="server" ID="lb" ForeColor="Red" />
            </td>
        </tr>
        <tr>
            <td class="name">合同类型
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_ContractType" Width="200" 
                    NullText="请选择合同类型" />
            </td>
        </tr>
        <tr>
            <td class="name">合同编号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Code" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">合同开始
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_CommenceDate" Width="200" 
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                    <TimeSectionProperties Visible="false"></TimeSectionProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">合同到期
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_NextServiceTime" Width="200" 
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                    <TimeSectionProperties Visible="false"></TimeSectionProperties>
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

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Contract_Edit ; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(de_CommenceDate).IsRequired();
        cb_ContractType.FromEnum<ContractType>(valueAsInteger: true);
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        context.Cars.SingleOrDefault(c => c.Id == _ObjectId).IfNN(car =>
        {
            l_Id.Text = car.Id;
            l_Company.Text = car.Company;
            l_PlateNumber.Text = car.PlateNumber;
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

        var contract = new TB_car_contract();
        context
            .NewSequence<TB_car_contract>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_contract>(_SessionEx, o =>
            {
                o.CarId = _ObjectId;
                o.Id = newId;

                contract = o;
            })
            .SubmitChanges();

        // 更新车辆信息

        if (contract.CommenceDate <= DateTime.Now.Date &&
            (!contract.EndDate.HasValue ||
            contract.EndDate.HasValue && DateTime.Now.Date <= contract.EndDate.Value))
        {
            car.ContractId = contract.Id;
            car.ConstructDueTime = contract.EndDate;
        }

        context.SubmitChanges();

    }

</script>

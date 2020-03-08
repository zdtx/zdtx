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
                    车辆保养记录
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
            <td class="name">保养内容
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_ServiceContent" Width="200" HelpText="例如：常规保养" />
            </td>
        </tr>
        <tr>
            <td class="name">保养完成时间
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_ServiceTime" Width="200" 
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                    <TimeSectionProperties Visible="false"></TimeSectionProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">服务公司
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_ServiceProvider" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">服务费用
            </td>
            <td class="cl">
                <dx:ASPxSpinEdit runat="server" ID="sp_ServiceCost" Width="200"
                    NullText="请输入服务费用金额"
                    DisplayFormatString="{0:N} 元" MaxValue="1000000" MinValue="0">
                    <SpinButtons ShowIncrementButtons="false" />
                    <HelpTextSettings Position="Bottom" />
                </dx:ASPxSpinEdit>
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top:10px;">
                    下次保养设置
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">保养内容
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_NextServiceContent" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">保养到期时间
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
    public override string ModuleId { get { return Car.Service_Edit; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_ServiceContent).IsRequired();
        fh.Validate(de_ServiceTime).IsRequired();
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

            tb_NextServiceContent.Text = car.ServiceNextContent;
            de_NextServiceTime.Value = car.ServiceNextTime;

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

        var service = new TB_car_service();
        context
            .NewSequence<TB_car_service>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_service>(_SessionEx, o =>
            {
                o.CarId = _ObjectId;
                o.Id = newId;
                o.ServiceContent = tb_ServiceContent.Text;
                o.ServiceTime = de_ServiceTime.Date;
                o.ServiceProvider = tb_ServiceProvider.Text;
                if (!
                    string.IsNullOrEmpty(sp_ServiceCost.Value.ToStringEx()))
                    o.ServiceCost = sp_ServiceCost.Number;
                service = o;
            })
            .SubmitChanges();

        // 更新车辆信息

        if (!
            car.ServiceTime.HasValue ||
            service.ServiceTime > car.ServiceTime.Value)
        {
            car.ServiceId = service.Id;
            car.ServiceContent = service.ServiceContent;
            car.ServiceTime = service.ServiceTime;

            car.ServiceNextContent = tb_NextServiceContent.Text;

            if (!
                string.IsNullOrEmpty(de_NextServiceTime.Value.ToStringEx()))
            {
                var nextTime = de_NextServiceTime.Date;
                if (nextTime <= DateTime.Now || nextTime <= service.ServiceTime)
                {
                    throw new Exception("设置错误：下次保养时间需大于今天，且大于本次已服务时间。");
                }
                car.ServiceNextTime = nextTime;
            }
        }

        context.SubmitChanges();

    }

</script>

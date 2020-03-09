<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="System.IO" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls/Driver/View.ascx" TagPrefix="uc1" TagName="View" %>
<%@ Register Src="~/_controls/Driver/View_Payment.ascx" TagPrefix="uc1" TagName="View_Payment" %>
<%@ Register Src="~/_controls/Driver/View_Accident.ascx" TagPrefix="uc1" TagName="View_Accident" %>
<%@ Register Src="~/_controls/Driver/View_Complain.ascx" TagPrefix="uc1" TagName="View_Complain" %>
<%@ Register Src="~/_controls/Driver/View_Log.ascx" TagPrefix="uc1" TagName="View_Log" %>
<%@ Register Src="~/_controls/Driver/View_Violation.ascx" TagPrefix="uc1" TagName="View_Violation" %>
<%@ Register Src="~/_controls/Driver/View_Contract.ascx" TagPrefix="uc1" TagName="View_Contract" %>

<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="../../content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="N" ContentPlaceHolderID="N">
    <uc1:HeaderInfo runat="server" ID="hi" />
</asp:Content>
<asp:Content runat="server" ID="W" ContentPlaceHolderID="W">
    <table style="width:100%;height:100%;border-spacing:0px;">
        <tr>
            <td style="text-align:center;height:200px;" class="leftPane">
                <asp:Image runat="server" ID="img" AlternateText="照片" Width="210" />
            </td>
        </tr>
        <tr>
            <td style="padding-left:18px;height:100px;">
                <dx:ASPxTabControl ID="tc" runat="server" TabPosition="Left" Width="100%">
                    <TabStyle HorizontalAlign="Right" />
                    <ActiveTabStyle BackColor="Transparent">
                        <BorderRight BorderStyle="None" />
                    </ActiveTabStyle>
                    <Tabs>
                        <dx:Tab Text="综合">
                            <TabImage Url="~/images/_doc_16.gif" />
                        </dx:Tab>
                        <dx:Tab Text="合同情况" />
                        <dx:Tab Text="缴费情况" />
                        <dx:Tab Text="违章情况" />
                        <dx:Tab Text="事故情况" />
                        <dx:Tab Text="被投诉情况" />
                        <dx:Tab Text="好人好事" />
                    </Tabs>
                </dx:ASPxTabControl>
            </td>
        </tr>
        <tr>
            <td class="leftPane">&nbsp;</td>
        </tr>
    </table>
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <div class="toolbar" style="border-bottom:dashed #9F9F9F 1px;">
        <table>
            <tr>
                <td class="dsTitle">
                    <h1>
                        <asp:Literal runat="server" ID="l_Name" />
                        <asp:Literal runat="server" ID="l_Car" />
                    </h1>
                </td>
            </tr>
            <tr>
                <td class="dsFooter">
                    身份证号：<asp:Literal runat="server" ID="l_CHNId" />
                    &nbsp;最后更新：
                    <asp:Label runat="server" ID="l_ModifyTime" ForeColor="Red" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:View_Contract runat="server" id="cT" />
    <uc1:View_Violation runat="server" id="cV" />
    <uc1:View_Accident runat="server" id="cA" />
    <uc1:View_Complain runat="server" id="cC" />
    <uc1:View_Log runat="server" ID="cL" />
    <uc1:View_Payment runat="server" ID="cP" />
    <div style="padding:10px;">
        <uc1:View runat="server" id="cI" />
    </div>
</asp:Content>
<script runat="server">

    private string _ObjectId
    {
        get { return _ViewStateEx.Get<string>(DataStates.ObjectId, string.Empty); }
        set { _ViewStateEx.Set<string>(value, DataStates.ObjectId); }
    }

    private const string DEFAULT_URL = "~/images/customer.png";
    protected override bool _PACK_0001 { get { return true; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => { c.MaxSize = c.Size = 30; c.AutoHeight = false; })
            .West(true, c => c.MinSize = c.Size = 250)
            .CenterTop(true, c => { c.MaxSize = c.MinSize = c.Size = 48; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        // 获得控件路径
        _Util
            .GetRequestParameter<string>("id", id => _ObjectId = id)
            ;

        tc.Switch(new BaseControl[] { cI, cT, cP, cV, cA, cC, cL }, (index, c) =>
        {
            c.ViewStateEx.Set(_ObjectId, DataStates.ObjectId);
            c.Execute();
        }, (index, c) =>
        {
            c.ViewStateEx.Clear();
        });
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../../portal/desktop.aspx")
            .Title("司机管理", "档案浏览");

        var context = _DTContext<CommonContext>(true);
        context.Drivers.SingleOrDefault(o => o.Id == _ObjectId).IfNN(o =>
        {
            l_Name.Text = o.Name;
            l_CHNId.Text = o.CHNId;
            l_ModifyTime.Text = o.ModifyTime.ToISDateWithTime();
            l_Car.Text = string.Empty;

            // 获取车辆情况
            var cars = (
                from r in context.CarRentals
                join c in context.Cars on r.CarId equals c.Id
                where r.DriverId == _ObjectId
                select c.PlateNumber).ToArray();

            if (cars.Length > 0)
                l_Car.Text = string.Format("&nbsp;[ 车牌：{0} ]", cars.ToFlat("，"));

        }, () =>
        {
            throw DTException.NotFound<TB_driver>(_ObjectId);
        });

        img.Width = Unit.Empty;
        img.ImageUrl = DEFAULT_URL;
        var imgUrl = string.Format("~{0}/{1}.jpg", Parameters.Filebase, _ObjectId);
        if (File.Exists(Util.GetPhysicalPath(imgUrl)))
        {
            img.Width = 220;
            img.ImageUrl = imgUrl;
        }

        cI.Import(_ObjectId, DataStates.ObjectId);
        cI.Execute();
    }

</script>

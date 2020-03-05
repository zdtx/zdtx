<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls/Car/View.ascx" TagPrefix="uc1" TagName="View" %>
<%@ Register Src="~/_controls/Car/View_Accident.ascx" TagPrefix="uc1" TagName="View_Accident" %>
<%@ Register Src="~/_controls/Car/View_Balance.ascx" TagPrefix="uc1" TagName="View_Balance" %>
<%@ Register Src="~/_controls/Car/View_Complain.ascx" TagPrefix="uc1" TagName="View_Complain" %>
<%@ Register Src="~/_controls/Car/View_Inspection.ascx" TagPrefix="uc1" TagName="View_Inspection" %>
<%@ Register Src="~/_controls/Car/View_Insurance.ascx" TagPrefix="uc1" TagName="View_Insurance" %>
<%@ Register Src="~/_controls/Car/View_Log.ascx" TagPrefix="uc1" TagName="View_Log" %>
<%@ Register Src="~/_controls/Car/View_Payment.ascx" TagPrefix="uc1" TagName="View_Payment" %>
<%@ Register Src="~/_controls/Car/View_Rental.ascx" TagPrefix="uc1" TagName="View_Rental" %>
<%@ Register Src="~/_controls/Car/View_Replace.ascx" TagPrefix="uc1" TagName="View_Replace" %>
<%@ Register Src="~/_controls/Car/View_Shift.ascx" TagPrefix="uc1" TagName="View_Shift" %>
<%@ Register Src="~/_controls/Car/View_Violation.ascx" TagPrefix="uc1" TagName="View_Violation" %>
<%@ Register Src="~/_controls/Car/View_Contract.ascx" TagPrefix="uc1" TagName="View_Contract" %>

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
    <table style="width:100%;height:100%;">
        <tr>
            <td style="padding-left:30px;height:100%">
                <dx:ASPxTabControl ID="tc" runat="server" TabPosition="Left" Width="100%" Height="100%">
                    <TabStyle HorizontalAlign="Right" />
                    <ActiveTabStyle BackColor="Transparent">
                        <BorderRight BorderStyle="None" />
                    </ActiveTabStyle>
                    <Tabs>
                        <dx:Tab Text="综合">
                            <TabImage Url="~/images/_doc_16.gif" />
                        </dx:Tab>
                        <dx:Tab Text="合同" />
                        <dx:Tab Text="车架变更历史" />
                        <dx:Tab Text="司机变更历史" />
                        <dx:Tab Text="代班历史" />
                        <dx:Tab Text="租金/管理费" />
                        <dx:Tab Text="其他费用情况" />
                        <dx:Tab Text="年审、行审情况" />
                        <dx:Tab Text="保险缴纳情况" />
                        <dx:Tab Text="事故历史" />
                        <dx:Tab Text="违章历史" />
                        <dx:Tab Text="投诉历史" />
                        <dx:Tab Text="好人好事记录" />
                    </Tabs>
                </dx:ASPxTabControl>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <div class="toolbar" style="border-bottom:dashed #9F9F9F 1px;">
        <table>
            <tr>
                <td class="dsTitle">
                    <h1>
                        <asp:Literal runat="server" ID="l_PlateNumber" />
                    </h1>
                </td>
            </tr>
            <tr>
                <td class="dsFooter">
                    单位：<asp:Literal runat="server" ID="l_Company" />
                    &nbsp;最后更新：
                    <asp:Label runat="server" ID="l_ModifyTime" ForeColor="Red" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:View_Contract runat="server" id="cX" />
    <uc1:View_Accident runat="server" id="cA" />
    <uc1:View_Balance runat="server" id="cB" />
    <uc1:View_Complain runat="server" id="cC" />
    <uc1:View_Inspection runat="server" id="cS" />
    <uc1:View_Insurance runat="server" id="cU" />
    <uc1:View_Log runat="server" id="cL" />
    <uc1:View_Payment runat="server" id="cP" />
    <uc1:View_Rental runat="server" id="cR" />
    <uc1:View_Replace runat="server" id="cE" />
    <uc1:View_Shift runat="server" id="cH" />
    <uc1:View_Violation runat="server" id="cV" />
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

    protected override bool _PACK_0001 { get { return true; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => { c.MaxSize = c.Size = 30; c.AutoHeight = false; })
            .West(true, c => { c.Size = 150; c.MinSize = 150; })
            .CenterTop(true, c => { c.MaxSize = c.MinSize = c.Size = 48; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        _Util
            .GetRequestParameter<string>("id", id => _ObjectId = id)
            ;
        tc.Switch(new BaseControl[] { cX, cI, cE, cR, cH, cP, cB, cS, cU, cA, cV, cC, cL }, (index, c) =>
        {
            c
                .Import(_ObjectId, DataStates.ObjectId)
                .Execute();

        }, (index, c) =>
        {
            c.ViewStateEx.Clear();
        });
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../../portal/desktop.aspx")
            .Title("车辆管理", "档案浏览");

        var context = _DTContext<CommonContext>(true);
        context.Cars.SingleOrDefault(o => o.Id == _ObjectId).IfNN(o =>
        {
            l_PlateNumber.Text = o.PlateNumber;
            l_Company.Text = o.Company;
            l_ModifyTime.Text = o.ModifyTime.ToISDateWithTime();

        }, () =>
        {
            throw DTException.NotFound<TB_car>(_ObjectId);
        });

        cI
            .Import(_ObjectId, DataStates.ObjectId)
            .Execute();
    }

</script>

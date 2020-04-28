<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" EnableEventValidation="false" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls/Business/Violation.ascx" TagPrefix="uc1" TagName="Violation" %>
<%@ Register Src="~/_controls/Business/Violation_Batch.ascx" TagPrefix="uc1" TagName="Violation_Batch" %>
<%@ Register Src="~/_controls/Business/File_Batch.ascx" TagPrefix="uc1" TagName="File_Batch" %>
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
                        <dx:Tab Text="违章违纪登记 - 单个录入">
                            <TabImage Url="~/images/_doc_16_formeddocument.gif" />
                        </dx:Tab>
                        <dx:Tab Text="批量录入">
                            <TabImage Url="~/images/_doc_16_foldercollection.gif" />
                        </dx:Tab>
                        <dx:Tab Text="文件导入" Visible="false">
                            <TabImage Url="~/images/_doc_16_foldercollection.gif" />
                        </dx:Tab>
                    </Tabs>
                </dx:ASPxTabControl>
            </td>
        </tr>
    </table>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:Violation runat="server" id="c1" />
    <uc1:Violation_Batch runat="server" ID="c2" />
    <uc1:File_Batch runat="server" ID="c3" Mode="Violation" />
</asp:Content>
<script runat="server"> // 违章管理

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
            .West(true, c => c.MinSize = c.Size = 250)
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        tc.Switch(new BaseControl[] { c1, c2, c3 }, (index, c) =>
        {
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
            .Title("业务处理", "违章违纪登记");
        c1.Execute();
    }

</script>

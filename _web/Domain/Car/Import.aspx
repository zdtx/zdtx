<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls/Car/Import.ascx" TagPrefix="uc1" TagName="Import" %>
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
    <div style="padding:10px;">
        <dx:ASPxHyperLink runat="server" NavigateUrl="Create.aspx" Text="单个录入" ForeColor="Red" />
    </div>
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <div style="padding:10px;">
        <uc1:Import runat="server" id="c" />
    </div>
</asp:Content>
<script runat="server">

    protected override bool _PACK_0001 { get { return true; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => { c.MaxSize = c.Size = 30; c.AutoHeight = false; })
            .West(true, c => c.Size = 200)
            .CenterTop(true, c => { c.MaxSize = c.Size = 26; c.AutoHeight = false; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        c.EventSinked += (s, eType, param) =>
        {
            switch (eType)
            {
                case BaseControl.EventTypes.Save:
                    break;
                case BaseControl.EventTypes.Submit:
                    break;
            }
        };
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../../portal/desktop.aspx")
            .Title("车辆管理", "导入");
        
        c.Execute();
    }
    
</script>

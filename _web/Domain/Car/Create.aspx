<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls/Car/Create.ascx" TagPrefix="uc1" TagName="Create" %>
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
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <uc1:ActionToolbar runat="server" ID="at" />
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <div style="padding:10px;">
        <uc1:Create runat="server" id="c" />
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
        at.Initialize(c, cc => cc
            .Button(BaseControl.EventTypes.Submit, b => { b.Visible = true; b.Text = "保存再新建"; })    
            .Button(BaseControl.EventTypes.Save, b => { b.Visible = true; })
            .Button(BaseControl.EventTypes.Cancel, b => { b.Visible = true; b.ConfirmText = "确定返回吗？"; })
            );
        c.EventSinked += (s, eType, param) =>
        {
            switch (eType)
            {
                case BaseControl.EventTypes.Cancel:
                    Response.Redirect("list.aspx", true);
                    break;
                case BaseControl.EventTypes.Save:
                    if (!
                        c.Do(Actions.Save, true)) return;
                    _JS.Alert("保存完成", postScript: "window.location.replace('list.aspx');");
                    break;
                case BaseControl.EventTypes.Submit:
                    if (!
                        c.Do(Actions.Save, true)) return;
                    _JS.Alert("保存完成", postScript: "window.location.replace('create.aspx');");
                    break;
            }
        };
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../../portal/desktop.aspx")
            .Title("车辆管理", "建档");
        
        c.Execute();
    }
    
</script>

<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" Title="eTaxi :: 登录" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
            bypassFrame: function () {
                if (window === window.parent) {
                    window.close();
                    return;
                }
                if (window.parent.__begin) {
                    window.parent.location.replace("../close.aspx");
                }
                else {
                    window.close();
                }
            }
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
</asp:Content>
<script runat="server">

    protected override bool _LoginRequired { get { return false; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => c.Size = 200)
            .Center(true)
            );

        // 检查 off 参数
        _Util.GetRequestParameter<bool>(
            "off", f => { if (f) _Auth.Logout(); }, false, false);
    }

    protected override void _FirstGet()
    {
        // 跳 frame
        _JS.Write("ISEx.bypassFrame();");
    }

</script>

    <%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" %>

<%@ Register Src="~/_controls.helper/Flashcam.ascx" TagPrefix="uc1" TagName="Flashcam" %>
<%@ Register Src="~/____temp/Test.ascx" TagPrefix="uc1" TagName="Test" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="theHead" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="../../content/scripts/__page.js"></script>
</head>
<body>

    <form runat="server" id="theForm">

        <asp:ScriptManager ID="theManager" runat="server" />
        <%--<uc1:Flashcam runat="server" ID="c" />--%>
        <asp:Literal runat="server" ID="l" />

        <dx:ASPxButton runat="server" Text="EX" ID="bEx" />
        <uc1:Test runat="server" ID="Test" />
    </form>


</body>
</html>
<script runat="server">

    protected override bool _LoginRequired { get { return false; } }
    protected override void _SetInitialStates()
    {
        bEx.Click += (s, e) =>
        {




        };
    }

    protected override void _Execute()
    {

        //c.ObjectId = Guid.NewGuid().ToISFormatted();
        //c.Execute();

        Global.Cache.SetDirty(CachingTypes.Module);

    }


</script>

﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="eTaxi.WebForm1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title></title>
</head>
<body>
    <form id="theForm" runat="server">
        <asp:ScriptManager ID="theManager" runat="server"></asp:ScriptManager>
        <rsweb:ReportViewer ID="rv" runat="server" Width="100%" SizeToReportContent="true">
        </rsweb:ReportViewer>
    </form>
</body>
</html>

<script runat="server">

    protected override void _SetInitialStates(bool isPartial)
    {
        base._SetInitialStates();
        _ViewStateEx.Register<string>("未找到票据对象，请重新发起。", Messages.NotReady);

        // 配置 Viewer
        rv.ShowRefreshButton = false;
    }

    protected override void _Execute()
    {
        Action _return = () =>
        {
            string pattern = @"window.alert('{0}');window.close();";
            ClientScript.RegisterStartupScript(GetType(), ClientID,
                string.Format(pattern, _ViewStateEx.Get<string>(Messages.NotReady)), true);
        };

        Guid ticketId = Guid.Empty;
        if (string.IsNullOrEmpty(Request["id"])) { _return(); return; }
        if (!Guid.TryParse(Request["id"], out ticketId)) { _return(); return; }
        ReportGen gen = null;
        try
        {
            gen = _SessionEx.TKObjectManager.Get(ticketId) as ReportGen;
            if (gen == null) { _return(); return; }
        }
        catch
        {
            _return();
            return;
        }

        try
        {
            gen.Go(rv);
        }
        catch (Exception ex)
        {
            HandleException(ex);
        }
    }

</script>

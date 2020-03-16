<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="theHead" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>出租车数据管理系统（eTaxi）</title>
</head>
<body>
    <div style="padding: 20px;">
        欢迎使用 出租车数据管理系统，系统正在打开，请稍候..
    </div>
</body>
</html>
<script runat="server">

    protected override void _SetInitialStates(bool isPartial)
    {
        /// 中转页面，如果：
        /// 1. 未登录，则跳转到 Login 页面
        /// 2. 已经登录了，则进入门户默认页面

        if (_Logined)
        {
            Response.Redirect("~/portal");
        }
        else
        {
            Response.Redirect("~/login.aspx");
        }
    }

</script>
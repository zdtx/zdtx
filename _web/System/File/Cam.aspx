<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected override void _Execute()
    {
        var fileId = string.Empty;
        var content = Request.Form["pic"];

        _Util
            .GetRequestParameter<string>("id", id => fileId = id, exceptionIfNotExists: false)
            ;

        if (string.IsNullOrEmpty(content) ||
            string.IsNullOrEmpty(fileId))
        {
            Response.End();
            return;
        }

        var file = Util.GetPhysicalPath(
            string.Format("{0}/file/{1}.jpg", Parameters.Tempbase, fileId));
        var bytes = Convert.FromBase64String(content);  // 将 2 进制编码转换为 8 位无符号整数数组
        using (var fs = new FileStream(file, FileMode.Create))
        {
            fs.Write(bytes, 0, bytes.Length);
            fs.Close();
        }

        var url = GetSitePrefix() + string.Format("/____temp/file/{0}.jpg", fileId);
        Response.Write("{\"code\":1,");
        Response.Write("\"picUrl\":\"" + url + "\"}");
    }
    
</script>

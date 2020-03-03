<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProgressReporter.ascx.cs" Inherits="eTaxi.Web.Controls.ProgressReporter" %>
<asp:Button runat="server" ID="b" style="display:none;" OnClientClick="return false;" />
<script runat="server">

    /// <summary>
    /// 形成调用闭包（触发一个动作，然后给定一个检测操作）
    /// </summary>
    /// <param name="caller"></param>
    /// <param name="parameter"></param>
    /// <param name="wrapCall"></param>
    /// <param name="jsExecute"></param>
    public override void Go(int interval, string caller = null, string text = null)
    {
        Caller = caller;
        Text = text;
        Interval = interval;
        if (!
            string.IsNullOrEmpty(text))
            Page.Master.If<MasterPageEx>(m => m.SetLoadingText(text));
        string handle = Page.ClientScript.GetPostBackEventReference(b, null);
        string js = Page.ClientScript.GetPostBackEventReference(b, string.Empty) + ";";
        string pattern =
            "ISEx.{0}=setInterval(function(){{var x=ISEx.loadingPanel;if(x.control){{{3}x.control.Show();x.paused=true;}}{1}}},{2});";
        js = string.Format(
            pattern, ClientID, js, Interval.ToString(),
            string.IsNullOrEmpty(text) ? string.Empty :
            string.Format("x.control.SetText('{0}');", HttpUtility.JavaScriptStringEncode(text)));
        JS(js);
    }

    /// <summary>
    /// 展示提示信息
    /// </summary>
    public override void Show(string text)
    {
        Text = text;
        Page.Master.If<MasterPageEx>(m => m.SetLoadingText(Text));
        string pattern = "if(ISEx.loadingPanel.control){{ISEx.loadingPanel.control.SetText('{0}');}}";
        JS(string.Format(pattern, HttpUtility.JavaScriptStringEncode(text)));
    }

    /// <summary>
    /// 关闭提示框
    /// </summary>
    public override void Close()
    {
        Page.Master.If<MasterPageEx>(m => m.ResetLoadingText());
        string pattern =
            "if(ISEx.loadingPanel.control){{ISEx.loadingPanel.control.Hide();ISEx.loadingPanel.paused=false;}}" +
            "clearInterval(ISEx.{0});";
        JS(string.Format(pattern, ClientID));
    }


</script>

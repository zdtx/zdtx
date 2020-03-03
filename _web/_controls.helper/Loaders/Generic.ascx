<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.Controls.ControlLoader" %>
<asp:Panel runat="server" ID="pTips" CssClass="tips" Style="margin: 5px; padding: 5px;" Visible="false">
    <asp:Literal runat="server" ID="ltTips" />
</asp:Panel>
<asp:PlaceHolder runat="server" ID="h" />
<script runat="server">

    public override Control Frame { get { return h; } }
    public override PlaceHolder Holder { get { return h; } }
    public override string Title { set { return; } }
    public override Unit Height { set { return; } }
    public override Unit Width { set { return; } }
    public override string Tips
    {
        set
        {
            if (string.IsNullOrEmpty(value))
            {
                pTips.Visible = false;
                ltTips.Text = value;
                return;
            }
            pTips.Visible = true;
            ltTips.Text = value;
        }
    }
    
    /// <summary>
    /// 用于提示用户的校验错误提示
    /// </summary>
    public string ValidationFailTips
    {
        get
        {
            return "操作不成功。数据填报不完整，请检查（特别是带红线标注的框框）。";
        }
    }

    public override void Show() { }
    public override void Close(string message = null)
    {
        Execute();
        h.Controls.Clear();
        var l = new Label() { Text = "（无）" };
        if (!string.IsNullOrEmpty(message)) l.Text = message;
        h.Controls.Add(l);
    }

</script>



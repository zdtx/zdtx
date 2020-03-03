<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MessagePanel.ascx.cs" Inherits="eTaxi.Web.Controls.MessagePanel" %>
<asp:Panel runat="server" ID="p" CssClass="pan">
    <div class="title">
        <asp:Literal runat="server" ID="l_Title" />
    </div>
    <div class="pan" style="margin-top:10px;">
        <asp:Literal runat="server" ID="l_Message" />
        <asp:PlaceHolder runat="server" ID="ph" />
    </div>
    <asp:Panel runat="server" ID="pF" CssClass="footer" style="padding:10px;" Visible="false">
        <asp:Literal runat="server" ID="l_Remark" />
    </asp:Panel>
</asp:Panel>
<script runat="server">

    public override string Title
    {
        get { return l_Title.Text; }
        set { l_Title.Text = value; }
    }

    public override string MessageText
    {
        get { return l_Message.Text; }
        set { l_Message.Text = value; }
    }

    public override PlaceHolder MessageBody { get { return ph; } }
    public override string Remark
    {
        get { return l_Remark.Text; }
        set
        {
            pF.Visible = value.Trim().Length > 0;
            l_Remark.Text = value;
        }
    }

</script>

<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PrintReady.ascx.cs" Inherits="eTaxi.Web.Controls.PrintReady" %>
<asp:Panel runat="server" ID="p" CssClass="pan">
    <table class="form">
        <tr>
            <td colspan="2">
                <div class="info" style="padding:10px;margin-bottom:10px;">
                    您好，打印数据已经准备好。<br />
                    <ul>
                        <li>
                            本次是第 <asp:Label runat="server" ID="lb_PrintCount" /> 打印
                        </li>
                        <li>
                            请点击以下链接，在弹出窗口内预览内容，并完成打印
                        </li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td class="val" colspan="2">
                <asp:HyperLink runat="server" ID="hl_Url" Width="350" Target="_blank" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    protected override void _SetInitialStates()
    {
        base._SetInitialStates();
    }
    
</script>

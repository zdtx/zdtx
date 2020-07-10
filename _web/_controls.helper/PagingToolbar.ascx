<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.Controls.PagingToolbar" CodeBehind="PagingToolbar.ascx.cs" %>
<table class="pgTB">
    <tr>
        <td runat="server" id="tdTB">
            <table>
                <tr>
                    <td>
                        <dx:ASPxComboBox ID="ddl" runat="server" AutoPostBack="True" Height="23" Width="100">
                            <Items>
                                <dx:ListEditItem Text="显示 10 笔" Value="10" Selected="true" />
                                <dx:ListEditItem Text="显示 20 笔" Value="20" />
                                <dx:ListEditItem Text="显示 50 笔" Value="50" />
                                <dx:ListEditItem Text="显示 100 笔" Value="100" />
                                <dx:ListEditItem Text="显示 200 笔" Value="200" />
                                <dx:ListEditItem Text="显示 500 笔" Value="500" />
                            </Items>
                        </dx:ASPxComboBox >
                    </td>
                    <td>
                        <dx:ASPxButton runat="server" ID="f" Text="首页">
                            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        </dx:ASPxButton>
                    </td>
                    <td>
                        <dx:ASPxButton runat="server" ID="p" Text=" ← " ToolTip="上一页">
                            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        </dx:ASPxButton>
                    </td>
                    <td>
                        <dx:ASPxButton runat="server" ID="n" Text=" → " ToolTip="下一页">
                            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        </dx:ASPxButton>
                    </td>
                    <td>
                        <dx:ASPxButton runat="server" ID="l" Text="尾页">
                            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        </dx:ASPxButton>
                    </td>
                    <td>
                        <dx:ASPxSpinEdit runat="server" ID="tb" Width="50" Height="23" MaxValue="1000000" MinValue="1">
                            <SpinButtons ShowIncrementButtons="false" />
                            <HelpTextSettings Position="Bottom" />
                        </dx:ASPxSpinEdit>
                    </td>
                    <td>
                        <dx:ASPxButton runat="server" ID="b" Text="去此页">
                            <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        </dx:ASPxButton>
                    </td>
                </tr>
            </table>
        </td>
        <td class="text" title="[总记录数] / [起始记录] - [结束]">
            共
            <%= Total.ToString() %>
            /
            当前
            <%= Total == 0 ? "0" : (Index * Size + 1).ToString() %>
            -
            <%= ((Index + 1) * Size > Total ? Total: (Index + 1) * Size).ToString() %>
        </td>
    </tr>
</table>
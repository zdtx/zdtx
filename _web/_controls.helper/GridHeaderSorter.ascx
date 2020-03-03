<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GridHeaderSorter.ascx.cs" Inherits="eTaxi.Web.Controls.GridHeaderSorter" %>
<asp:LinkButton runat="server" ID="l" CommandName="O" />
<asp:Image ID="u" title="按升序排列" runat="server" ImageUrl="~/images/view-sortup.gif" Visible="False" />
<asp:Image ID="d" title="按降序排列" runat="server" ImageUrl="~/images/view-sortdown.gif" Visible="False" />
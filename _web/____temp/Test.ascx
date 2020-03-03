<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<asp:Button runat="server" ID="b" Text="TEST" />
<script runat="server">

    protected override void _SetInitialStates()
    {
        b.Click += (s, e) =>
        {
            Alert(AppRelativeVirtualPath);
            
        };
        
    }

</script>

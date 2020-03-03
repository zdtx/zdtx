<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PopupField_DX.ascx.cs" Inherits="eTaxi.Web.Controls.PopupField_DX" %>
<asp:HiddenField runat="server" ID="h" />
<asp:HiddenField runat="server" ID="t" />
<dx:ASPxButtonEdit runat="server" ID="b" NullText="（空）" ReadOnly="true">
    <Buttons>
        <dx:DropDownButton Text=".." Width="12" />
    </Buttons>
    <ClientSideEvents ButtonClick="function(s,e){ISEx.loadingPanel.show();}" />
</dx:ASPxButtonEdit>
<script runat="server">
    
    protected override void _SetInitialStates()
    {
        base._SetInitialStates();
        if (ShowEdit) b.Buttons.Add(new EditButton() { Text = EditText, Width = 12 });
    }

</script>

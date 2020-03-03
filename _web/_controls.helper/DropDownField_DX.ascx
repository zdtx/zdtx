<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DropDownField_DX.ascx.cs" Inherits="eTaxi.Web.Controls.DropDownField_DX" %>
<asp:HiddenField runat="server" ID="_shown" Value="False" />
<asp:HiddenField runat="server" ID="v" />
<dx:ASPxButtonEdit runat="server" ID="b" NullText="（空）" ReadOnly="true">
    <Buttons>
        <dx:DropDownButton Text="↓" Width="12" />
    </Buttons>
</dx:ASPxButtonEdit>
<dx:ASPxPopupControl runat="server" ID="p"
    PopupElementID="b" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below"
    EnableHierarchyRecreation="True" PopupAction="None" PopupAlignCorrection="Auto" 
    ScrollBars="Auto" PopupAnimationType="None" ShowShadow="false" AllowDragging="false" MaxHeight="400">
    <ContentStyle>
        <Paddings Padding="0" />
    </ContentStyle>
    <ContentCollection>
        <dx:PopupControlContentControl ID="pC" runat="server" />
    </ContentCollection>
</dx:ASPxPopupControl>
<script runat="server">
    
    protected override void _SetInitialStates()
    {
        base._SetInitialStates();
        if (ShowEdit) b.Buttons.Add(new EditButton() { Text = EditText, Width = 12 });
        p.ClientInstanceName = p.ClientID;
        b.ClientInstanceName = b.ClientID;
        b.ClientSideEvents.ButtonClick = string.Format(
            "function(s,e){{switch(e.buttonIndex){{case 0:if($get('{0}').value==='True')e.processOnServer=false;else ISEx.loadingPanel.show();{1}.Show();break;}} }}",
            _shown.ClientID, p.ClientID);
    }

</script>

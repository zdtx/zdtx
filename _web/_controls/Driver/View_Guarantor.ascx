<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<tr>
    <td class="name">介绍人
    </td>
    <td class="val">
        <asp:Label runat="server" ID="l_Guarantor" 
            Width="300" ForeColor="Red" Font-Bold="true" />
    </td>
</tr>
<script runat="server">

    public override string ModuleId { get { return Driver.View_Guarantor; } }
    public override bool AccessControlled { get { return true; } }
    private string _Detail { get { return _ViewStateEx.Get<string>(DataStates.Detail, null); } }
    protected override void _Execute()
    {
        Visible = AC(AccessCode);
        l_Guarantor.Text = _Detail;
    }

</script>

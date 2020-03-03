<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<table class="actionTB">
    <tr>
        <td runat="server" id="tdOK" class="btn">
            <dx:ASPxButton runat="server" ID="bOK" Text="开始">
                <Image Url="~/images/_op_flatb_tick.gif" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdCancel" class="btn">
            <dx:ASPxButton runat="server" ID="bCancel" Text="取消">
                <Image Url="~/images/_op_flatb_cancel.gif" />
            </dx:ASPxButton>
        </td>
    </tr>
</table>
<script runat="server">
    
    private Dictionary<EventTypes, ASPxButton> _Buttons = new Dictionary<EventTypes, ASPxButton>();
    private Dictionary<EventTypes, HtmlTableCell> _Cells = new Dictionary<EventTypes, HtmlTableCell>();
    private void _Initialize()
    {
        _Buttons = new Dictionary<EventTypes, ASPxButton>()
        {
            { EventTypes.Cancel, bCancel },
            { EventTypes.OK, bOK }
        };

        _Cells = new Dictionary<EventTypes, HtmlTableCell>()
        {
            { EventTypes.Cancel, tdCancel },
            { EventTypes.OK, tdOK }
        };        
    }
    
    protected override void _SetInitialStates()
    {
        _Initialize();
        _Buttons.ForEach(kv => kv.Value.Click += (s, e) => SinkEvent(this, kv.Key));
    }

</script>

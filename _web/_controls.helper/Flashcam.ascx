<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Flashcam.ascx.cs" Inherits="eTaxi.Web.Controls.Flashcam" %>
<asp:Button runat="server" ID="_b" style="display:none" />
<div class="tips" style="padding:5px;margin-bottom:5px;">
    请对准拍照对象后点击“[拍]”完成拍照。
</div>
<table>
    <tr>
        <td>
            <dx:ASPxButton runat="server" ID="b" Text="[拍]" Height="60" Font-Bold="true" Font-Size="12">
                <Image Url="~/images/_doc_16_product.gif" />
            </dx:ASPxButton>
        </td>
        <td>
            <object 
                classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
                codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"
                width="320" height="240" id="<%= ClientID %>">
            <param name="movie" value="<%= _GetSitePrefix() %>/content/swf/flashcam.swf">
            <param name="quality" value="high">
            <param name="bgcolor" value="#FFFFFF">
            <param name="flashvars" value="url=<%= _GetSitePrefix() %>/system/file/cam.aspx?id=<%= ObjectId %>">
            <embed width="320" height="240" 
                align="middle" 
                flashvars="url=<%= _GetSitePrefix() %>/system/file/cam.aspx?id=<%= ObjectId %>"
                pluginspage="http://www.macromedia.com/go/getflashplayer" 
                type="application/x-shockwave-flash" 
                allowfullscreen="true" 
                allowscriptaccess="always" 
                name="flashcam" 
                bgcolor="#ffffff" 
                quality="best" 
                menu="false" 
                loop="false" 
                src="<%= _GetSitePrefix() %>/content/swf/flashcam.swf" 
                id="<%= ClientID %>" 
                allownetworking="all"></embed>
            </object>
        </td>
    </tr>
</table>
<script runat="server">

    protected override void _SetInitialStates()
    {
        _b.Click += (s, e) => SinkEvent(EventTypes.OK);
    }

    protected override void _Execute()
    {
        b.ClientSideEvents.Click = 
            string.Format(
@"function(s,e){{var x=ISEx;x.loadingPanel.show();x.swf('{0}').save();e.processOnServer=false;x.sleep(1000,function(){{{1};}});}}"
                , ClientID, Page.ClientScript.GetPostBackEventReference(_b, string.Empty));
    }
    
</script>

<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.Controls.HeaderInfo" CodeBehind="HeaderInfo.ascx.cs" %>
<div class="headerTB">
    <table class="path">
        <tr>
            <td>
                <dx:ASPxButton runat="server" RenderMode="Link" Text="返回桌面" ID="bBack">
                    <Image Url="~/images/arrow_left.png" />
                    <Paddings Padding="2" PaddingRight="5" />
                    <HoverStyle CssClass="link" Font-Underline="false" />
                    <ClientSideEvents Click="function(s,e){history.back();e.processOnServer=false;}" />
                </dx:ASPxButton>
            </td>
            <td style="border-left: dashed 1px silver;">
                <dx:ASPxButton ID="bLink" runat="server" RenderMode="Link" CssClass="link">
                    <Paddings Padding="2" PaddingRight="5" />
                    <HoverStyle Font-Underline="false" />
                    <ClientSideEvents Click="function(s,e){e.processOnServer=false;}" />
                </dx:ASPxButton>
            </td>
        </tr>
    </table>
    <table class="current">
        <tr>
            <td style="border-left: dashed 1px silver;">操作:</td>
            <td>
                <asp:LinkButton runat="server" ID="lb_Name" ForeColor="#044C82" />
                &nbsp;
            </td>
            <td style="border-left: dashed 1px silver;">部门:</td>
            <td>
                <asp:LinkButton runat="server" ID="lb_Department" ForeColor="#044C82" />
                &nbsp;
            </td>
            <td style="border-left: dashed 1px silver;">时间:</td>
            <td style="padding-top: 1px;">
                <asp:Literal runat="server" ID="lt_Time" /></td>
        </tr>
    </table>
</div>
<script runat="server">

    protected override void _ViewStateProcess()
    {
        lb_Name.Text =
            _SessionEx.Logined ? _SessionEx.Name : "（未登录）";
        lb_Department.Text =
            Global.Cache.GetDepartment(d => d.Id == _SessionEx.DepartmentId).Name.ToStringEx("（无）");
        lt_Time.Text = _CurrentTime.ToISDateWithTime();
    }

    public override HeaderInfo Back(string name, string url)
    {
        bBack.Text = name;
        bBack.ClientSideEvents.Click = string.Format(
            @"function(s,e){{window.location.href='{0}';e.processOnServer=false;}}", url);
        return this;
    }

    public override HeaderInfo Title(params string[] parts)
    {
        bLink.Text = parts.ToFlat(" → ");
        return this;
    }
    
    
</script>

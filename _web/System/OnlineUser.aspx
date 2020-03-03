<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>

<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/GridWrapperForDetail.ascx" TagPrefix="uc1" TagName="GridWrapperForDetail" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="../content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="N" ContentPlaceHolderID="N">
    <uc1:HeaderInfo runat="server" ID="hi" />
    <uc1:Popup_DX runat="server" ID="pop" />
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:GridWrapperForDetail runat="server" ID="gw" />
    <asp:GridView runat="server" ID="gv" Width="100%">
        <headerstyle cssclass="gridHeader" />
        <rowstyle height="20" />
        <emptydatatemplate>
            <div class="emptyData">
                （无信息）
            </div>
        </emptydatatemplate>
    </asp:GridView>
</asp:Content>
<script runat="server">

    protected override bool _PACK_0001
    {
        get
        {
            return true;
        }
    }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c =>
            {
                c.MaxSize = c.Size = 30;
                c.AutoHeight = false;
            })
            .West(true, c =>
            {
                c.MinSize = c.Size = 100;
            })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c

            .TemplateField("UserName", "登录帐号", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("Name", "人员", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("Department", "部门", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("LastVisitTime", "最后活跃时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("LastVisitHostAddress", "来自", new TemplateItem.Label(), f =>
            {
                f.ItemStyle.Wrap = false;
                f.HeaderStyle.Width = 100;
            })
            .TemplateField("LastVisitUrl", "最后访问页面", new TemplateItem.TextBox(e =>
            {
                e.ReadOnly = true;
                e.Style.Add("width", "100%");
            }), f =>
            {

            })
            .TemplateField("LastVisitUserAgent", "浏览器信息", new TemplateItem.TextBox(e =>
            {
                e.ReadOnly = true;
                e.Width = 200;
            }), f =>
            {
                f.HeaderStyle.Width = 150;
            }), checkBox: false

            );
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../portal/desktop.aspx")
            .Title("系统管理", "在线人员情况");

        var data = Global.Sessions.Snapshot(s => true, s => new
        {
            s.Id,
            s.UserName,
            Name = Global.Cache.GetPerson(p => p.Id == s.Id).Name,
            Department = Global.Cache.GetDepartment(d => d.Id == s.DepartmentId).Name.ToStringEx("（无）"),
            s.LastVisitTime,
            s.LastVisitUserAgent,
            s.LastVisitUrl,
            s.LastVisitUserHostAddress,
            s.LastVisitUrlReferrer
        });

        data = data.OrderByDescending(d => d.LastVisitTime).ToList();
        gw.Execute(data, b => b
            .Do<Label>("UserName", (c, d) => c.Text = d.UserName)
            .Do<Label>("Name", (c, d) =>
            {
                c.Text = d.Name;
                if (d.UserName == eTaxi.Definitions.Login.Administrator)
                    c.Text = "（系统管理员）";
            })
            .Do<Label>("Department", (c, d) => c.Text = d.Department)
            .Do<Label>("LastVisitTime", (c, d) => c.Text = d.LastVisitTime.ToISDateWithTime())
            .Do<TextBox>("LastVisitUrl", (c, d, r) =>
            {
                c.Text = d.LastVisitUrl.ToLower();
                if (d.LastVisitUrl.Contains("__test") ||
                    d.UserName.ToLower().Contains("admin"))
                {
                    c.Text = "（保密）";
                    r.CssClass = "alert";
                }

                if (d.LastVisitUrl.ToLower().Contains("onlineuser.aspx"))
                {
                    c.Text = d.LastVisitUrlReferrer;
                }

            })
            .Do<Label>("LastVisitHostAddress", (c, d) => c.Text = d.LastVisitUserHostAddress)
            .Do<TextBox>("LastVisitUserAgent", (c, d) => c.Text = d.LastVisitUserAgent)

            );
    }

    protected override void _Do(string section, string subSection = null)
    {
    }

</script>

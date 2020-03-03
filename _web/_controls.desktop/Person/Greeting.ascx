<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePortlet" %>
<div style="padding: 5px;">
    <table>
        <tr>
            <td>
                <asp:Image ID="ig" runat="server" ImageUrl="~/images/male.png" Height="60" />
            </td>
            <td>
                <table class="form" style="border-spacing: 1px;">
                    <tr>
                        <td class="name">今天：
                        </td>
                        <td class="val">
                            <%= _CurrentTime.ToString("yyyy年M月d日") %>
                        </td>
                    </tr>
                    <tr>
                        <td class="name">部门：
                        </td>
                        <td class="val">
                            <%= Global.Cache.GetDepartment(d => d.Id == _SessionEx.DepartmentId).Name %>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <div class="footer" style="margin-top: 5px; padding-top: 5px;">
        <table style="border-spacing:0px;">
            <tr>
                <td>
                    <asp:LinkButton ID="lb1" runat="server" Text="更多信息.." CssClass="aBtn" OnClientClick="ISEx.loadingPanel.show();" />
                </td>
                <td>
                    <asp:LinkButton ID="lb2" runat="server" Text="修改密码" CssClass="aBtn" Visible="false" />
                </td>
            </tr>
        </table>
    </div>
</div>
<script runat="server">

    protected override void _SetInitialStates()
    {
        lb1.Click += (s, e) =>
        {
            if (MasterLoader == null) return;
            MasterLoader.Begin<BaseControl>(
                "~/controls.x.humanfactor/person/view.ascx", null, cc =>
            {
                cc
                    .Import(_SessionEx.Id, DataStates.ObjectId)
                    .Execute();
                
            }, cc => cc
                .Width(500)
                .Height(400)
                .Title(string.Format("{0}（登录用户：{1}）", _SessionEx.Name, _SessionEx.UserName))
                .Button(BaseControl.EventTypes.Cancel, b => b.Text = "关闭")
            );
        };
    }

    protected override void _Execute()
    {
        var person = Global.Cache.GetPerson(p=>p.Id == _SessionEx.Id);
        ig.ImageUrl = "~/images/male.png";
        if (person.Gender.HasValue && !person.Gender.Value) ig.ImageUrl = "~/images/female.png";
    }

</script>

<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" Title="eTaxi :: 登录" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
            bypassFrame: function () {
                if (window === window.parent) return;
                if (window.parent.__begin) { // 判别是 ext 页面罩着
                    window.parent.location.replace("../login.aspx");
                }
            }
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <table class="login">
        <tr>
            <td style="width:500px;">
                <div style="float:right;padding-right:20px;">
                    <img alt="常州交服" src="images/czjf.jpg" />
                </div>
            </td>
            <td style="border-left:silver 1px solid;padding-left:20px;vertical-align:top;padding-top:200px;">
                <table>
                    <tr>
                        <td class="name">用户名：</td>
                        <td>
                            <dx:ASPxTextBox ID="tb_UserName" runat="server" Width="150" TabIndex="1" />
                        </td>
                        <td rowspan="2">
                            <dx:ASPxButton ID="bLogin" runat="server" Text="登录" Height="45" TabIndex="4" />
                        </td>
                    </tr>
                    <tr>
                        <td class="name">密　码：</td>
                        <td>
                            <dx:ASPxTextBox ID="tb_Password" Password="true" runat="server" Width="150" TabIndex="2" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2">
                            <dx:ASPxCheckBox ID="cb_RememberMe" runat="server" Text="记住我" TabIndex="3" />
                        </td>
                    </tr>
                    <tr id="tr" runat="server" visible="false">
                        <td></td>
                        <td colspan="2" class="error" style="padding:5px;width:200px;">
                            <asp:Literal runat="server" ID="lMsg" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
<script runat="server">

    protected override bool _LoginRequired { get { return false; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => c.Size = 200)
            .Center(true)
            );

        // 检查 off 参数
        _Util.GetRequestParameter<bool>(
            "off", f => { if (f) _Auth.Logout(); }, false, false);
    }

    protected override void _SetInitialStates()
    {
        bLogin.Click += (s, e) =>
        {
            if (Do(Actions.Login, true))
                _JS.Write("window.location.replace('default.aspx');");
        };
    }

    protected override void _FirstGet()
    {
        tb_UserName.Focus();
        tb_Password.ClientSideEvents.KeyPress = string.Format(
            @"function(s,e){{if(e.htmlEvent.keyCode===13){0};}}",
            ClientScript.GetPostBackEventReference(bLogin, string.Empty));
        
        // 跳 frame
        _JS.Write("ISEx.bypassFrame();");
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Login)
        {
            tr.Visible = false;            
            var userName = tb_UserName.Value.ToStringEx();
            var password = tb_Password.Text;
            if (string.IsNullOrEmpty(userName))
                throw new Exception("请填入用户名");

            if (userName == eTaxi.Definitions.Login.Administrator)
            {
                // 处理管理员
                var adminPassword = Host.Settings.Get<string>("adminPassword", "123456");
                var admin = Membership.GetUser(new Guid(eTaxi.Definitions.Login.AdministratorId));
                if (admin == null)
                {
                    MembershipCreateStatus status;
                    _MembershipProvider.CreateUser(
                        eTaxi.Definitions.Login.Administrator, adminPassword, null, null, null, true,
                        new Guid(eTaxi.Definitions.Login.AdministratorId), out status);
                }
                else
                {
                    if (!
                        Membership.ValidateUser(userName, adminPassword))
                    {
                        // 如果 web.config 中的密码不对，则重置
                        var newPass = _MembershipProvider.ResetPassword(userName, null);
                        _MembershipProvider.ChangePassword(userName, newPass, adminPassword);
                    }
                }
            }
            
            _Auth.Login(userName, password, u =>
            {
                _SessionEx.UniqueId = (Guid)u.ProviderUserKey;
                _SessionEx.UserName = u.UserName;
                _SynSession();
            }, cb_RememberMe.Checked);
        }
    }

    protected override bool _HandleException(Type callerType, 
        ExceptionFilter exFilter, string step, Action<string> msgSend = null)
    {
        return base._HandleException(callerType, exFilter, step, msg =>
        {
            tr.Visible = true;
            lMsg.Text = exFilter.Exception.Message;
            tb_UserName.Focus();
        });
    }
    
</script>

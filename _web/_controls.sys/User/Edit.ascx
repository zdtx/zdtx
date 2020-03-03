<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<uc1:FormHelper runat="server" ID="fh" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title">
                    修改用户名
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">用户名
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_UserName" Width="200" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
            </td>
        </tr>
        <tr>
            <td class="name">密码
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tbPassword" Width="200" Password="true" MaxLength="16" />
            </td>
        </tr>
        <tr>
            <td class="name">重新输入
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tbRetype" Width="200" Password="true" MaxLength="16" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public override string ModuleId { get { return User.Edit; } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_UserName).IsRequired();
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var id = _ViewStateEx.Get<string>(DataStates.ObjectId, exceptionIfInvalid: true);
        context.Persons.SingleOrDefault(p => p.Id == id).IfNN(person =>
        {
            var user = _MembershipProvider.GetUser(person.UniqueId, false);
            tb_UserName.Value = user == null ? null : user.UserName;
        }, () =>
        {
            throw DTException.NotFound<TB_person>(id);
        });
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        var context = _DTService.Context;
        var id = _ViewStateEx.Get<string>(DataStates.ObjectId, exceptionIfInvalid: true);
        context
            .Update<TB_person>(_SessionEx, pp => pp.Id == id, person =>
                {
                    Action _checkPassword = () =>
                    {
                        if (string.IsNullOrEmpty(tbPassword.Text))
                            throw new Exception("密码不能为空");
                        if (!tbPassword.Text.Equals(tbRetype.Text))
                        {
                            tbPassword.Focus();
                            throw new Exception("两次输入密码不一致，请检查");
                        }
                    };

                    Action _create = () =>
                    {
                        MembershipCreateStatus status;
                        _MembershipProvider.CreateUser(person.UserName,
                            person.Password, null, null, null, true, person.UniqueId, out status);
                        if (status != MembershipCreateStatus.Success)
                            throw new DTException("用户创建不成功，请检查", s => s.Record("status", status.ToString()));
                    };

                    if (string.IsNullOrEmpty(tb_UserName.Value.ToStringEx()))
                        throw new Exception("请输入用户名");
                    var user = _MembershipProvider.GetUser(person.UniqueId, false);

                    if (user == null)
                    {
                        // 无用户
                        _checkPassword();
                        person.UserName = tb_UserName.Value.ToStringEx();
                        person.Password = tbPassword.Text;
                        _create();
                    }
                    else
                    {
                        var newUserName = tb_UserName.Value.ToStringEx();
                        var passwordShouldChange = false;
                        var newPassword = tbPassword.Text;

                        person.UserName = user.UserName;

                        if (!
                            string.IsNullOrEmpty(newPassword))
                        {
                            _checkPassword();
                            passwordShouldChange = person.Password != newPassword;
                            person.Password = newPassword;
                        }

                        if (user.UserName != newUserName)
                        {
                            _MembershipProvider.DeleteUser(user.UserName, true);
                            person.UserName = newUserName;
                            _create();
                        }
                        else if (passwordShouldChange)
                        {
                            _MembershipProvider.DeleteUser(user.UserName, true);
                            _create();
                        }
                    }
                })
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.User);
    }
    
</script>

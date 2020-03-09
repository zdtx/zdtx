<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" Title="eTaxi :: 转接中" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Dynamic" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<p>
    <asp:Literal runat="server" Text="请稍候 ..." ID="l" />
<p />
<script runat="server">

    protected override bool _LoginRequired { get { return false; } }
    protected override void _SetInitialStates()
    {
        /// base64({username:[用户名]}.[哈希])
        /// 哈希计算：
        ///     - {username:[用户名],key:[共享秘钥]}
        ///     - SHA 256
        /// 共享秘钥：
        ///     - ZDTX@2020!!!^%@$^*Forward
        /// 例子：
        ///     - 原文：{"username":"陈大文"}.56914496972b4cf76a3c47540330a5a7e3313648d31e5f1fe73e15452df7a64f
        ///     - 密文：eyJ1c2VybmFtZSI6IumZiOWkp+aWhyJ9LjU2OTE0NDk2OTcyYjRjZjc2YTNjNDc1NDAzMzBhNWE3ZTMzMTM2NDhkMzFlNWYxZmU3M2UxNTQ1MmRmN2E2NGY=
        ///     - 查询：/redirect.aspx?t=eyJ1c2VybmFtZSI6IumZiOWkp%2BaWhyJ9LjU2OTE0NDk2OTcyYjRjZjc2YTNjNDc1NDAzMzBhNWE3ZTMzMTM2NDhkMzFlNWYxZmU3M2UxNTQ1MmRmN2E2NGY%3D

        try
        {
            var query = Request.QueryString["t"];
            if (string.IsNullOrEmpty(query))
            {
                Response.Redirect("~/login.aspx", true);
                return;
            }

            var payload = Encoding.UTF8.GetString(Convert.FromBase64String(query));
            var parts = payload.Split('.');
            var content = parts[0];
            var hash = parts[1];

            dynamic obj = JsonConvert.DeserializeObject<ExpandoObject>(content);
            string username = obj.username;

            if (string.IsNullOrEmpty(username))
            {
                Response.Redirect("~/login.aspx", true);
                return;
            }

            obj.key = "ZDTX@2020!!!^%@$^*Forward";
            var challenge = JsonConvert.SerializeObject(obj);
            var challengingHash = GetHash(challenge);

            if (hash != challengingHash)
            {
                Response.Redirect("~/login.aspx", true);
                return;
            }

            // Login system
            var context = _DTService.Context;

            var person = context.Persons.FirstOrDefault(p => p.UserName == username);
            if (person == null)
            {
                Response.Redirect("~/login.aspx", true);
                return;
            }

            _Auth.Login(person.UserName, person.Password, u =>
            {
                _SessionEx.UniqueId = (Guid)u.ProviderUserKey;
                _SessionEx.UserName = u.UserName;
                _SynSession();

            });

            Response.Redirect("~/default.aspx", true);

        }
        catch (Exception ex)
        {
            l.Text = ex.Message;
        }
    }

    private string GetHash(string payload)
    {
        var bytes = Encoding.UTF8.GetBytes(payload);
        var sha256 = new  SHA256Managed();
        var digestBytes = sha256.ComputeHash(bytes);
        var sb = new StringBuilder();
        foreach (var b in digestBytes) sb.Append(b.ToString("x2"));
        return sb.ToString();
    }


</script>

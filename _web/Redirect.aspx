<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" Title="eTaxi :: 转接中" %>

<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Dynamic" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<p>
    <asp:Literal runat="server" Text="请稍候 ..." ID="l" />
<p />
<script runat="server">

    private string department;
    private string username;
    private string departmentId;
    private string role;
    private string userId;
    private string defaultPassword = "a123456";

    private readonly Dictionary<Guid, bool[]> matrix = new Dictionary<Guid, bool[]>
    {
        // 财务主管 主管 操作员
        {new Guid("693DD454-8D1A-428F-A23D-EE90143F3156"), new bool[]{true,true,false}},	//_controls/driver/view_guarantor.ascx	查看司机介绍人
        {new Guid("FD22D1C7-17C0-45F2-8692-30D2400CA6D6"), new bool[]{true,true,true}},	//domain/business/accident.aspx	事故登记
        {new Guid("9E69EB8F-5F3A-46E2-A024-9C06BF5CD66A"), new bool[]{true,true,true}},	//domain/business/complain.aspx	投诉接待登记
        {new Guid("CF84A673-D7FA-4A18-934B-B2D4FC53890C"), new bool[]{true,true,true}},	//domain/business/contract.aspx	租车合同
        {new Guid("C40868E6-FE98-4001-9CEC-822FDE38288A"), new bool[]{true,true,true}},	//domain/business/event.aspx	好人好事登记
        {new Guid("B38A3245-9C35-487B-B04F-D967DACA037C"), new bool[]{true,true,true}},	//domain/business/inspection.aspx	营审、行审更新
        {new Guid("1BD879BA-BDD9-483F-9B57-E39AAE67154D"), new bool[]{true,true,true}},	//domain/business/insurance.aspx	车辆保险更新
        {new Guid("CC39B505-BA79-4762-9346-E6F2524C1C21"), new bool[]{true,true,true}},	//domain/business/payment.aspx	欠费登记
        {new Guid("BF6195CA-1537-486B-B602-74EC2A6CF450"), new bool[]{true,true,true}},	//domain/business/rental.aspx	车辆司机分配
        {new Guid("E98B3196-BE96-4E5F-999B-364BDA59EF76"), new bool[]{true,true,true}},	//domain/business/replace.aspx	车架及发动机号维护
        {new Guid("6831C04D-A363-4C42-BBC5-50AE1D388A9E"), new bool[]{true,true,true}},	//domain/business/shift.aspx	代班登记
        {new Guid("B99600DE-AE13-488F-9130-87326C2623B5"), new bool[]{true,true,true}},	//domain/business/violation.aspx	违章登记
        {new Guid("302B6237-3B45-47B1-9C2C-E218333795A6"), new bool[]{true,true,true}},	//domain/car/create.aspx	车辆建档
        {new Guid("2C3E2435-6A8E-4888-BAA3-735BE59083E7"), new bool[]{true,true,true}},	//domain/car/list.aspx	档案浏览
        {new Guid("18B41D53-54D9-4168-A137-9555C5190A57"), new bool[]{true,true,true}},	//domain/car/service.aspx	车辆保养
        {new Guid("EDBB9711-6E67-45CC-B634-266129264CFB"), new bool[]{true,true,true}},	//domain/car/update_1.aspx	批量更新
        {new Guid("4615A9CC-3291-4758-A0AD-B3936DE91B16"), new bool[]{true,true,true}},	//domain/car/update_rental_batch.aspx	车辆关系更新（批量）
        {new Guid("08A1EC36-2AAC-473D-90E8-71E0A0FE3F12"), new bool[]{true,true,true}},	//domain/driver/complain.aspx	投诉接待
        {new Guid("EC4D216C-B0D5-4EAB-92A9-8E858F87AE24"), new bool[]{true,true,true}},	//domain/driver/contract.aspx	合同管理
        {new Guid("9EC1E083-903B-4DE5-961D-1167C5AE7FF8"), new bool[]{true,true,true}},	//domain/driver/create.aspx	司机建档
        {new Guid("2F2A6323-A19E-4D81-B772-E0D2CA66E5CC"), new bool[]{true,true,true}},	//domain/driver/event.aspx	好人好事
        {new Guid("A580046D-79C1-4BCE-844F-82AAE52E2C2C"), new bool[]{true,true,true}},	//domain/driver/list.aspx	档案浏览
        {new Guid("2CD5B28D-4894-4F0D-8D85-019A8A489BE9"), new bool[]{true,true,true}},	//domain/driver/update_1.aspx	批量更新
        {new Guid("8F053635-53B5-4747-B05F-6E884693B75F"), new bool[]{true,true,true}},	//domain/driver/update_photo_batch.aspx	批量更新人员照片
        {new Guid("C7C28E06-A457-40D6-95CC-AD80B2A7B43B"), new bool[]{true,true,false}},	//domain/finance/account.aspx	驾驶员账户查询
        {new Guid("55F0592C-AB60-4348-ACCA-7A02BC2C2A88"), new bool[]{true,false,false}},	//domain/finance/charge.aspx	结算设置
        {new Guid("D93FC084-298A-497D-8794-E2BD12887F85"), new bool[]{true,true,false}},	//domain/finance/ledger.aspx	款项结算管理
        {new Guid("0DAA1639-BECF-43B0-9403-ACECB2084269"), new bool[]{true,true,false}},	//domain/query/car_accident.aspx	事故查询
        {new Guid("542F2856-05C2-4741-BB8F-9DDCD8B46023"), new bool[]{true,true,false}},	//domain/query/car_complain.aspx	投诉查询
        {new Guid("523364E0-ECBB-41F6-80AA-212899B9B267"), new bool[]{true,true,false}},	//domain/query/car_log.aspx	好人好事查询
        {new Guid("8FCF3193-0ECF-42E4-A6D1-69AAAAF8B4B3"), new bool[]{true,true,false}},	//domain/query/car_violation.aspx	违章查询
        {new Guid("12FCAA2B-7F52-437D-9C21-EA8636D869EE"), new bool[]{false,false,false}},	//system/acl.aspx	权限管理
        {new Guid("919DD7FD-850D-466F-8993-6E08E8AD0341"), new bool[]{false,false,false}},	//system/department.aspx	部门管理
        {new Guid("DD1DA39E-9B89-4B1A-95E0-4270E5018A99"), new bool[]{false,false,false}},	//system/module.aspx	模块一览
        {new Guid("27402C0C-7ACE-453E-8670-305EC6D6394E"), new bool[]{false,false,false}},	//system/onlineuser.aspx	在线用户
        {new Guid("6C057E3D-6F0A-46D9-94F3-9643176EC453"), new bool[]{true,true,false}},	//system/package.aspx	经营模式
        {new Guid("1FF17E64-652D-40DC-9E06-9FD215B1B910"), new bool[]{false,false,false}},	//system/person.aspx	人员及登录管理
        {new Guid("42E0E7B9-E2F7-4CE3-9BC9-2DFFD9E5F600"), new bool[]{false,false,false}},	//system/position.aspx	岗位管理
        {new Guid("F2B982D4-BA3E-4550-89B6-CA2C44EA834F"), new bool[]{false,false,false}}	//system/rank.aspx	行政级别管理
    };


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

            username = obj.username;
            role = obj.role;
            department = obj.department;

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

            // 1. 如果部门不在，则创建
            var currentDepartment = Global.Cache.GetDepartment(d => d.Name == department);
            if (string.IsNullOrEmpty(currentDepartment.Id))
            {
                Do(CREATE_DEPARTMENT, true);
            }
            else
            {
                departmentId = currentDepartment.Id;
            }

            // 2. 如果用户不在，则创建
            if (string.IsNullOrEmpty(Global.Cache.GetPerson(p => p.UserName == username).Id))
            {
                Do(CREATE_PERSON, true);
            }

            // Login system

            var person = Global.Cache.GetPerson(p => p.UserName == username);
            if (person == null)
            {
                Response.Redirect("~/login.aspx", true);
                return;
            }

            // 3. 如果用户的部门改变，则改变
            if (person.DepartmentId != departmentId)
            {
                _DTService.Context
                    .Update<TB_person>(_SessionEx, p=>p.Id == person.Id, p =>
                        {
                            p.DepartmentId = departmentId;
                        })
                    .SubmitChanges();

                Global.Cache.SetDirty(CachingTypes.Person);
            }

            _Auth.Login(person.UserName, person.Password, u =>
            {
                _SessionEx.UniqueId = (Guid)u.ProviderUserKey;
                _SessionEx.UserName = u.UserName;
                _SynSession();

            });

            var secret = Host.Settings.Get<string>("apiSecret");
            var token = secret.ToMd5();
            GetExternal(string.Format("company/getList?token={0}", token), rsp =>
            {
                dynamic x = JsonConvert.DeserializeObject<ExpandoObject>(rsp);
                List<object> companies = x.result;
                if (companies.Count == 0) return;

                List<string> names = new List<string>();
                foreach (dynamic c in companies)
                {
                    names.Add(c.companyName);
                }

                List<string> newNames = new List<string>();
                names.ForEach(n =>
                {
                    if (string.IsNullOrEmpty(Global.Cache.GetDepartment(d => d.Name == n).Id)) newNames.Add(n);
                });

                var cx = _DTContext<CommonContext>();

                newNames.ForEach(n =>
                {
                    var newId = string.Empty;
                    cx
                        .NewSequence<TB_department>(_SessionEx, (seq, id) =>
                        {
                            newId = id;
                        })
                        .Create<TB_department>(_SessionEx, d =>
                        {
                            d.Id = newId;
                            d.Name = n;
                        })
                        .SubmitChanges();
                });

                if (newNames.Count > 0) Global.Cache.SetDirty(CachingTypes.Department);

            });

            Response.Redirect("~/default.aspx", true);

        }
        catch (Exception ex)
        {
            l.Text = ex.Message;
        }
    }

    const string CREATE_DEPARTMENT = "createDepartment";
    const string CREATE_PERSON = "createPerson";

    protected override void _Do(string section, string subSection = null)
    {
        switch(section)
        {
            case CREATE_DEPARTMENT:
                _Do_CreateDepartment();
                break;
            case CREATE_PERSON:
                _Do_CreatePerson();
                break;
        }
    }

    private void _Do_CreateDepartment()
    {
        var context = _DTService.Context;
        var newId = string.Empty;

        context
            .NewSequence<TB_department>(_SessionEx, (seq, id) =>
            {
                newId = id;
            })
            .Create<TB_department>(_SessionEx, d =>
            {
                d.Id = newId;
                d.Name = department;
                _RoleProvider.CreateRole(newId);
            })
            .SubmitChanges();

        departmentId = newId;
        Global.Cache.SetDirty(CachingTypes.Department);
    }

    private void _Do_CreatePerson()
    {
        var context = _DTService.Context;
        var newId = string.Empty;

        context
            .NewSequence<TB_person>(_SessionEx, (seq, id) =>
            {
                newId = id;
            })
            .Create<TB_person>(_SessionEx, person =>
            {
                userId = newId;

                person.Code = "000000";
                person.PositionId = "PS0000";
                person.DepartmentId = departmentId;
                person.UserName = username;
                person.Name = username.Substring(0, 8);
                person.FirstName = string.Empty;
                person.LastName = string.Empty;
                person.Password = defaultPassword;
                person.Id = newId;
                person.UniqueId = Guid.NewGuid();

                _MembershipProvider.DeleteUser(person.UserName, true);

                MembershipCreateStatus status;
                _MembershipProvider.CreateUser(person.UserName,
                    person.Password, null, null, null, true, person.UniqueId, out status);
                if (status != MembershipCreateStatus.Success)
                    throw new DTException("用户创建不成功，请检查", s => s.Record("status", status.ToString()));
            })
            .SubmitChanges();

        Global.Cache.SetDirty(CachingTypes.Person);
        Global.Cache.SetDirty(CachingTypes.User);

        // 3. 分配给用户权限

        var acIndex = 0;
        switch (role)
        {
            case "ROLE_CWZG":
                acIndex = 0;
                break;
            case "ROLE_YBZG":
                acIndex = 1;
                break;
            case "ROLE_CZY":
                acIndex = 2;
                break;
        }

        foreach (var acl in matrix)
        {
            if (acl.Value[acIndex])
            {
                context
                    .Create<TB_sys_acl>(_SessionEx, a =>
                    {
                        a.ActorId = userId;
                        a.ModuleId = acl.Key;
                    })
                    .SubmitChanges();
            }
        }

    }

    private string GetHash(string payload)
    {
        var bytes = Encoding.UTF8.GetBytes(payload);
        var sha256 = new SHA256Managed();
        var digestBytes = sha256.ComputeHash(bytes);
        var sb = new StringBuilder();
        foreach (var b in digestBytes) sb.Append(b.ToString("x2"));
        return sb.ToString();
    }


</script>

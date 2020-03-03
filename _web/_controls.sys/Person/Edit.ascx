<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/PopupField_DX.ascx" TagPrefix="uc1" TagName="PopupField_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
<uc1:FormHelper runat="server" ID="fh" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title">
                    基本信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">（系统唯一码）
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Id" />
            </td>
        </tr>
        <tr>
            <td class="name">全名
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Name" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">姓
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_LastName" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">名
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_FirstName" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">工号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Code" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">身份证号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_CHNId" Width="200">
                    <MaskSettings Mask="000000-<1..2>0000000-000<0|1|2|3|4|5|6|7|8|9|X>" />
                </dx:ASPxTextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="tips" style="padding: 5px;">
                <asp:LinkButton runat="server"
                    Text="通过身份证号生成性别和出生年月日" ID="lbCal" CssClass="aBtn" />
            </td>
        </tr>
        <tr>
            <td class="name">性别
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cbGender" Width="200">
                    <Items>
                        <dx:ListEditItem Text="（未知）" Value="0" Selected="true" />
                        <dx:ListEditItem Text="男" Value="1" />
                        <dx:ListEditItem Text="女" Value="-1" />
                    </Items>
                </dx:ASPxComboBox>
            </td>
        </tr>
        <tr>
            <td class="name">出生年月
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_DayOfBirth" Width="200"
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">部门
            </td>
            <td class="cl">
                <uc1:PopupField_DX runat="server" ID="pf_DepartmentId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">岗位
            </td>
            <td class="cl">
                <uc1:PopupField_DX runat="server" ID="pf_PositionId" Width="200" />
            </td>
        </tr>

        <tr>
            <td class="name">备注
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Remark" Width="300" Rows="5" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public override string ModuleId { get { return Person.Edit; } }
    private bool _IsCreating { get { return _ViewStateEx.Get<bool>(DataStates.IsCreating, false); } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(tb_Name).IsRequired();
        fh.Validate(tb_FirstName).IsRequired();
        fh.Validate(tb_LastName).IsRequired();
        fh.Validate(pf_DepartmentId).IsRequired();
        fh.Validate(pf_PositionId).IsRequired();

        tb_FirstName.ClientInstanceName = ClientID + "__f";
        tb_LastName.ClientInstanceName = ClientID + "__l";
        tb_Name.ClientSideEvents.LostFocus = string.Format(
@"function(s,e){{if(s.GetText()=='')return;{0}.SetText(s.GetText().substring(0,1));{1}.SetText(s.GetText().substring(1));}}",
        tb_LastName.ClientInstanceName, tb_FirstName.ClientInstanceName);
        lbCal.Click += (s, e) =>
        {
            var id = tb_CHNId.Value.ToStringEx().Replace("-", string.Empty);
            if (string.IsNullOrEmpty(id))
            {
                Alert("身份证号未填报");
                return;
            }
            try
            {
                de_DayOfBirth.Date = new DateTime(
                    id.Substring(6, 4).ToIntOrDefault(),
                    id.Substring(10, 2).ToIntOrDefault(),
                    id.Substring(12, 2).ToIntOrDefault());
                switch (id.Substring(16, 1).ToIntOrDefault() % 2)
                {
                    case 0:
                        cbGender.SelectedIndex = 2;
                        break;
                    case 1:
                        cbGender.SelectedIndex = 1;
                        break;
                }
                pf_DepartmentId.Focus();
            }
            catch
            {
                Alert("身份证号格式错误");
            }
        };

        pf_DepartmentId.Initialize<eTaxi.Web.Controls.Selection.Department.TreeItem>(pop,
            "~/_controls.helper/selection/department/treeitem.ascx", (c, b, h, isFirst) =>
            {
                pop.Title = "选择人员的部门归属";
                pop.Width = 500;
                pop.Height = 400;
                if (isFirst) c.Execute();
            }, (c, b, h) =>
            {
                b.Text = c.Selection[0].Name;
                h.Value = c.Selection[0].Id;
                pop.Close();
                return true;
            }, null, c => c.Button(EventTypes.OK, s => s.CausesValidation = false));

        pf_PositionId.Initialize<eTaxi.Web.Controls.Selection.Position.Item>(pop,
            "~/_controls.helper/selection/position/item.ascx", (c, b, h, isFirst) =>
            {
                pop.Title = "选择人员的岗位";
                pop.Width = 500;
                pop.Height = 400;
                if (isFirst) c.Execute();
            }, (c, b, h) =>
            {
                b.Text = c.Selection[0].Name;
                h.Value = c.Selection[0].Id;
                pop.Close();
                return true;
            }, null, c => c.Button(EventTypes.OK, s => s.CausesValidation = false));

    }

    protected override void _Execute()
    {
        tb_Name.Focus();
        if (_IsCreating)
        {
            p.Controls.PresentedBy(new TB_person(), (d, n, c) =>
            {
            }, recursive: false);
            l_Id.Text = "（保存后系统自动生成）";
            return;
        }

        // 修改
        var context = _DTContext<CommonContext>(true);
        var id = _ViewStateEx.Get<string>(DataStates.ObjectId, exceptionIfInvalid: true);
        context.Single<TB_person>(r => r.Id == id,
            person =>
            {
                p.Controls.PresentedBy(person, (d, n, c) =>
                    {
                        switch (n)
                        {
                            case "DepartmentId":
                                c.If<PopupField_DX>(cc =>
                                    {
                                        cc.Text = Global.Cache.GetDepartment(dd => dd.Id == d.DepartmentId).Name;
                                        cc.Value = d.DepartmentId;
                                    });
                                break;
                            case "PositionId":
                                c.If<PopupField_DX>(cc =>
                                    {
                                        cc.Text = Global.Cache.GetPosition(pp => pp.Id == d.PositionId).Name;
                                        cc.Value = d.PositionId;
                                    });
                                break;
                        }
                    }, recursive: false);
                cbGender.SelectedIndex = person.Gender.HasValue ? person.Gender.Value ? 1 : 2 : 0;
            });
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        if (_IsCreating) _Do_Create(); else _Do_Update();
    }

    private void _Do_Create()
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
                    _Util.FillObject(p.Controls, person, recursive: false);
                    person.Id = newId;
                    person.UniqueId = Guid.NewGuid();
                })
            .SubmitChanges();
    }

    private void _Do_Update()
    {
        var context = _DTService.Context;
        context
            .Update<TB_person>(_SessionEx, r => r.Id == _ObjectId,
                person =>
                {
                    _Util.FillObject(p.Controls, person, recursive: false);
                    cbGender.Value.ToStringEx().ToIntOrNull().IfNN(g =>
                    {
                        switch (g)
                        {
                            case 0:person.Gender = null;break;
                            case 1: person.Gender = true; break;
                            default: person.Gender = false; break;
                        }
                    });
                })
            .SubmitChanges();
        Global.Cache.SetDirty(CachingTypes.Person);
    }
    
</script>

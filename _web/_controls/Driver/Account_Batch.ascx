<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/GridWrapperForDetail.ascx" TagPrefix="uc1" TagName="GridWrapperForDetail" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Callback_Generic.ascx" TagPrefix="uc1" TagName="Callback_Generic" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<uc1:Popup_DX runat="server" ID="pop" />
<uc1:FormHelper runat="server" ID="fh" />
<uc1:Callback_Generic runat="server" ID="cb" />
<div class="filterTb">
    <div class="inner" style="padding: 10px;">
        <table style="border-spacing: 0px;">
            <tr>
                <td style="padding-right: 10px;">请填入司机姓名（然后回车）：
                </td>
                <td>
                    <dx:ASPxTextBox runat="server" ID="tbInput" Width="100" />
                </td>
                <td style="padding-left: 10px;">或者：
                </td>
                <td>
                    <dx:ASPxButton runat="server" Text="在列表中选择司机" ID="bSelect">
                        <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        <Image Url="~/images/_doc_16_workflowtemplate.gif" />
                    </dx:ASPxButton>
                </td>
                <td style="padding-left: 10px;">
                    <dx:ASPxButton runat="server" Text="重来" ID="bReset">
                        <ClientSideEvents Click="function(s,e){e.processOnServer=confirm('确定清除数据重新选择吗？');}" />
                        <Image Url="~/images/_op_flatb_back.gif" />
                    </dx:ASPxButton>
                </td>
            </tr>
        </table>
    </div>
</div>
<div style="padding: 10px;">
    <uc1:ActionToolbar runat="server" ID="at" Visible="false" />
    <uc1:GridWrapperForDetail runat="server" ID="gw" />
    <asp:GridView runat="server" ID="gv">
        <HeaderStyle CssClass="gridHeader" />
        <RowStyle Height="20" />
        <EmptyDataTemplate>
            <div class="emptyData">
                （请先选择司机）
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
<script runat="server">

    private List<TB_driver> _List
    {
        get { return _ViewStateEx.Get<List<TB_driver>>(DataStates.List, new List<TB_driver>()); }
        set { _ViewStateEx.Set<List<TB_driver>>(value, DataStates.List); }
    }

    private string[] _DriverIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Driver.Update_Batch_1; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;

        // 执行反调配置
        cb.Initialize(r => r.Do(tbInput, handle =>
        {
            tbInput.ClientSideEvents.KeyPress =
                string.Format("function(s,e){{if(e.htmlEvent.keyCode===13){{ISEx.loadingPanel.show();try{{e.htmlEvent.preventDefault();}}catch(ee){{}}{0};}}}}", handle);
        }), c =>
        {
            if (c == tbInput.ClientID)
            {
                if (tbInput.Text.Trim().Length == 0) return;
                var context = _DTContext<CommonContext>(true);
                var name = tbInput.Text.ToStringEx();
                var drivers = context.Drivers.Where(d => d.Name.Contains(name)).ToList();
                if (drivers.Count == 0)
                {
                    Alert("找不到司机，请重新输入");
                    tbInput.Text = string.Empty;
                    tbInput.Focus();
                    return;
                }
                if (drivers.Count == 1)
                {
                    _DriverIds = new string[] { drivers[0].Id };
                    if (Do(Actions.Select, false)) Execute(VisualSections.List);
                    tbInput.Text = string.Empty;
                    tbInput.Focus();
                    return;
                }
                Alert("有超过一个司机符合该姓名特征，请检查");
                tbInput.Focus();
                return;
            }
        });

        at
            .Initialize(cc => cc
                .Button(BaseControl.EventTypes.Save, b => { b.Visible = true; })
                .Button(BaseControl.EventTypes.Cancel, b =>
                {
                    b.CausesValidation = false;
                    b.Text = "移除选定的司机（不作修改）";
                    b.Visible = true;
                    b.ConfirmText = "确定移除吗？";
                }), fh.CurrentGroup)
            .EventSinked += (s, eType, param) =>
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Cancel:
                        var selection = gw.GetSelected();
                        if (!selection
                            .Any(kv => kv.Value)) { Alert("请选择待移除的条目。"); return; }
                        gw.GetSelected(_List, d => d).ForEach(item => _List.Remove(item));
                        Execute(VisualSections.List);
                        break;
                    case BaseControl.EventTypes.Save:
                        if (Do(Actions.Save, true))
                        {
                            Alert("保存成功");
                            Execute();
                        }
                        break;
                }
            };

        bReset.Click += (s, e) =>
        {
            _List.Clear();
            Execute(VisualSections.List);
            tbInput.Focus();
        };

        bSelect.Click += (s, e) =>
        {
            pop.Begin<eTaxi.Web.Controls.Selection.Driver.Item>(
                "~/_controls.helper/selection/driver/items.ascx", null, c =>
                {
                    c.Execute();
                }, c =>
                {
                    c
                        .Width(650)
                        .Height(500)
                        .Title("先选择司机")
                        .Button(BaseControl.EventTypes.OK, b => b.CausesValidation = true)
                    ;
                });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            c.If<eTaxi.Web.Controls.Selection.Driver.Item>(cc =>
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.OK:

                        if (cc.Selection.Count == 0)
                        {
                            Alert("您还没选定司机，请先选择司机");
                            return;
                        }

                        pop.Close();
                        var driverIds = cc.Selection.Select(s => s.Id).ToArray();
                        _ViewStateEx.Set(driverIds, DataStates.Selected);
                        if (Do(Actions.Select, false)) Execute(VisualSections.List);
                        break;
                }
            });
        };

        gw.Initialize(gv, c => c
            .TemplateField("Id", "（内码）", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("Name", "姓名", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 60;
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 60;
                f.ItemStyle.Width = 60;
            })
            .TemplateField("CHNId", "身份证号", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 150;
            }), f =>
            {
                f.HeaderStyle.Width = 150;
                f.ItemStyle.Width = 150;
            })
        );
    }

    protected override void _Execute()
    {
        tbInput.Focus();
        _List.Clear();
        _Execute(VisualSections.List);
    }

    protected override void _Execute(string section)
    {
        if (section == VisualSections.List)
        {
            gw.Execute(_List, b => b
                .Do<Literal>("Id", (c, d) => { c.Text = d.Id; })
                .Do<ASPxTextBox>("Name", (c, d) => c.Text = d.Name)
                .Do<ASPxTextBox>("LastName", (c, d) => c.Text = d.LastName)
                .Do<ASPxTextBox>("FirstName", (c, d) => c.Text = d.FirstName)
                .Do<ASPxComboBox>("Gender", (c, d) =>
                {
                    c.Value = d.Gender.HasValue ? d.Gender.Value ?
                        ((int)Gender.Male).ToString() :
                        ((int)Gender.Female).ToString() :
                        ((int)Gender.Unknown).ToString();
                })
                .Do<ASPxTextBox>("CHNId", (c, d) => c.Text = d.CHNId)
                .Do<ASPxDateEdit>("DayOfBirth", (c, d) => c.Value = d.DayOfBirth)
                .Do<ASPxComboBox>("Education", (c, d) => c.Value = d.Education.ToString())
                .Do<ASPxComboBox>("SocialCat", (c, d) => c.Value = d.SocialCat.ToString())
                .Do<ASPxTextBox>("Tel1", (c, d) => c.Text = d.Tel1)
                .Do<ASPxTextBox>("Address", (c, d) => c.Text = d.Address)
                .Do<ASPxTextBox>("HKAddress", (c, d) => c.Text = d.HKAddress)
                .Do<ASPxDateEdit>("CareerStart", (c, d) => c.Value = d.CareerStart)
                .Do<ASPxTextBox>("CertNumber", (c, d) => c.Text = d.CertNumber)
            );

            at.Visible = _List.Count > 0;
            return;
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Select) _Do_Select();
        if (section == Actions.Save) _Do_Save();
    }

    private void _Do_Save()
    {
        if (_List.Count == 0) return;
        _Do_Collect();

        var context = _DTService.Context;
        _List.ForEach(d =>
        {
            context.Update<TB_driver>(_SessionEx, c => c.Id == d.Id, driver =>
            {
                driver.Name = d.Name;
                driver.LastName = d.LastName;
                driver.FirstName = d.FirstName;
                driver.Gender = d.Gender;
                driver.CHNId = d.CHNId;
                driver.DayOfBirth = d.DayOfBirth;
                driver.Education = d.Education;
                driver.SocialCat = d.SocialCat;
                driver.Tel1 = d.Tel1;
                driver.Address = d.Address;
                driver.HKAddress = d.HKAddress;
                driver.CareerStart = d.CareerStart;
                driver.CertNumber = d.CertNumber;
                driver.Remark = d.Remark;
            });
        });
        context.SubmitChanges();
    }

    private void _Do_Select()
    {
        _Do_Collect();
        _DriverIds.ForEach(id =>
        {
            if (_List.Any(l => l.Id == id)) return;
            var context = _DTContext<CommonContext>(true);
            context.Drivers.SingleOrDefault(d => d.Id == id).IfNN(d => _List.Add(d));
        });
    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxTextBox>("Name", (d, c) => d.Name = c.Value.ToStringEx())
            .Do<ASPxTextBox>("LastName", (d, c) => d.LastName = c.Value.ToStringEx())
            .Do<ASPxTextBox>("FirstName", (d, c) => d.FirstName = c.Value.ToStringEx())
            .Do<ASPxComboBox>("Gender", (d, c) =>
            {
                switch (Util.ParseEnum<Gender>(
                    c.Value.ToStringEx(string.Empty).ToIntOrDefault(-1), Gender.Unknown))
                {
                    case Gender.Male: d.Gender = true; break;
                    case Gender.Female: d.Gender = false; break;
                    default: d.Gender = null; break;
                }
            })
            .Do<ASPxTextBox>("CHNId", (d, c) => d.CHNId = c.Value.ToStringEx())
            .Do<ASPxDateEdit>("DayOfBirth", (d, c) =>
            {
                if (string.IsNullOrEmpty(c.Value.ToStringEx()))
                {
                    d.DayOfBirth = null;
                }
                else
                {
                    d.DayOfBirth = c.Date.Date;
                }
            })
            .Do<ASPxComboBox>("Education", (d, c) => d.Education = _Util.Convert<int>(c.Value))
            .Do<ASPxComboBox>("SocialCat", (d, c) => d.SocialCat = _Util.Convert<int>(c.Value))
            .Do<ASPxTextBox>("Tel1", (d, c) => d.Tel1 = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Address", (d, c) => d.Address = c.Value.ToStringEx())
            .Do<ASPxTextBox>("HKAddress", (d, c) => d.HKAddress = c.Value.ToStringEx())
            .Do<ASPxDateEdit>("CareerStart", (d, c) =>
            {
                if (string.IsNullOrEmpty(c.Value.ToString()))
                {
                    d.CareerStart = null;
                }
                else
                {
                    d.CareerStart = c.Date.Date;
                }
            })
            .Do<ASPxTextBox>("CertNumber", (d, c) => d.CertNumber = c.Value.ToStringEx())
        );
    }

</script>

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
                <td>
                    <dx:ASPxButton runat="server" Text="添加结算项目" ID="bAdd">
                        <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        <Image Url="~/images/_doc_16_foldercollection.gif" />
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
                （无结算项目，请添加）
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
<script runat="server">

    private List<TB_charge> _List
    {
        get { return _ViewStateEx.Get<List<TB_charge>>(DataStates.List, new List<TB_charge>()); }
        set { _ViewStateEx.Set<List<TB_charge>>(value, DataStates.List); }
    }

    public override string ModuleId { get { return Finance.Charge_Batch; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;

        at
            .Initialize(cc => cc
            .Button(BaseControl.EventTypes.Save, b => { b.Visible = true; }), fh.CurrentGroup)
            .EventSinked += (s, eType, param) =>
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Save:
                        if (Do(Actions.Save, true))
                        {
                            Alert("保存成功");
                            Execute();
                        }
                        break;
                }
            };

        bAdd.Click += (s, e) =>
        {
            pop.Begin<BaseControl>("~/_controls/finance/charge_create.ascx", null, c =>
            {
                c.Execute();
            }, c =>
            {
                c
                    .Width(500)
                    .Height(400)
                    .Title("添加新的结算项")
                    .Button(BaseControl.EventTypes.Save, b => b.CausesValidation = true)
                ;
            });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            if (c.ModuleId == Finance.Charge_Create)
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Save:

                        if (!
                            c.Do(Actions.Save, true)) return;

                        Alert("保存完成");

                        pop.Close();
                        Execute();
                        break;
                }
            }
        };

        gw.Initialize(gv, c => c
            .TemplateField("Id", "（系统唯一码）", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("Code", "编号", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 100;
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Name", "名称", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 150;
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 150;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("Type", "收取模式", new TemplateItem.DXComboBox(e =>
            {
                e.Width = 100;
                e.FromEnum<ChargeType>(valueAsInteger: true);
                fh.Validate(e).IsRequired();
            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Amount", "金额", new TemplateItem.DXSpinEdit(e =>
            {
                e.Width = 100;
                e.HorizontalAlign = HorizontalAlign.Right;
                e.SpinButtons.ShowIncrementButtons = false;
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("SpecifiedMonth", "指定收取月份", new TemplateItem.DXComboBox(e =>
            {
                e.Width = 100;
                e.FromEnum<MonthType>(valueAsInteger: true);
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Remark", "备注", new TemplateItem.DXTextBox(e =>
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
        _List = _DTService.Context.Charges.ToList();
        _Execute(VisualSections.List);
    }

    protected override void _Execute(string section)
    {
        if (section == VisualSections.List)
        {
            gw.Execute(_List, b => b
                .Do<Literal>("Id", (c, d) => { c.Text = d.Id; })
                .Do<ASPxTextBox>("Code", (c, d) => c.Text = d.Code)
                .Do<ASPxTextBox>("Name", (c, d) => c.Text = d.Name)
                .Do<ASPxComboBox>("Type", (c, d) => c.Value = d.Type.ToStringEx())
                .Do<ASPxComboBox>("SpecifiedMonth", (c, d) => c.Value = d.SpecifiedMonth.ToStringEx())
                .Do<ASPxSpinEdit>("Amount", (c, d) => { c.Number = d.Amount.ToCHNRounded(); })
                .Do<ASPxTextBox>("Remark", (c, d) => c.Text = d.Remark)
            );

            at.Visible = _List.Count > 0;
            return;
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Save) _Do_Save();
    }

    private void _Do_Save()
    {
        if (_List.Count == 0) return;
        _Do_Collect();

        var context = _DTService.Context;
        _List.ForEach(d =>
        {
            context.Update<TB_charge>(_SessionEx, c => c.Id == d.Id, charge =>
            {
                charge.Code = d.Code;
                charge.Name = d.Name;
                charge.Type = d.Type;
                charge.Amount = d.Amount;
                charge.SpecifiedMonth = d.SpecifiedMonth;
                charge.Remark = d.Remark;
            });
        });
        context.SubmitChanges();
    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxTextBox>("Code", (d, c) => d.Code = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Name", (d, c) => d.Name = c.Value.ToStringEx())
            .Do<ASPxComboBox>("Type", (d, c) => d.Type = c.Value.ToStringEx().ToIntOrDefault(0))
            .Do<ASPxSpinEdit>("Amount", (d, c) => d.Amount = c.Number)
            .Do<ASPxComboBox>("SpecifiedMonth", (d, c) => d.SpecifiedMonth = c.Value.ToStringEx().ToIntOrDefault(0))
            .Do<ASPxTextBox>("Remark", (d, c) => d.Remark = c.Value.ToStringEx())
        );
    }

</script>

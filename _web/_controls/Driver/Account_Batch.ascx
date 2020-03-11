<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/GridWrapperForDetail.ascx" TagPrefix="uc1" TagName="GridWrapperForDetail" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Callback_Generic.ascx" TagPrefix="uc1" TagName="Callback_Generic" %>
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
    <div class="actionTB" style="padding-top:2px;">
        <table>
            <tr>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbMonthIndex" Width="100" />
                </td>
                <td>
                    <dx:ASPxButton runat="server" ID="bSubmit" Text="生成月结单（不会重复生成）">
                        <Paddings Padding="0" />
                        <Image Url="~/images/_doc_16_position.gif" />
                    </dx:ASPxButton>
                </td>
            </tr>
        </table>
    </div>
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

    private string[] _DriverIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    const string CMD_ChangeRental = "ChangeRental";

    public override string ModuleId { get { return Driver.Account_Batch; } }
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

        bReset.Click += (s, e) =>
        {
            _DriverIds = new string[] { };
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
            .TemplateField("Name", "姓名", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("PlateNumber", "车牌号码", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("CHNId", "身份证号", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("Month", "当前月份", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("OpeningBalance", "上期结余", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("InvoiceAmount", "本期应缴", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("PaidAmount", "本期实缴", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("ClosingBalance", "本期结余", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("lb1", " - ", new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.CommandName = CMD_ChangeRental;
                l.Text = "改押金";
                l.OnClientClick = "ISEx.loadingPanel.show();";

            }), f =>
            {
                f.ItemStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("Remark", "备注", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
        );

        gv.RowCommand += (s, e) =>
        {
            if (e.CommandName != CMD_ChangeRental) return;
            var rowIndex = e.CommandArgument.ToStringEx().ToIntOrDefault();
            var v = new GridWrapper.RowVisitor(gv.Rows[rowIndex]);
            v.Get<Literal>("CarId", carL => v.Get<Literal>("DriverId", driverL =>
            {
                switch (e.CommandName)
                {
                    case CMD_ChangeRental:
                        Execute(e.CommandName);
                        break;
                }

            }));
        };

        // 月份
        var monthIds = new List<string>();
        var todate = DateTime.Now.Date;

        for (var i = 0; i< 10; i++)
        {
            if (i == 0)
            {
                monthIds.AddRange(todate.ToMonthIds());
                continue;
            }

            monthIds.AddRange(todate.AddYears(i).ToMonthIds());
            monthIds.AddRange(todate.AddYears(-1 * i).ToMonthIds());
        }

        cbMonthIndex.FromList(monthIds, (dd, i) => { i.Text = dd; i.Value = dd; return true; });

    }

    protected override void _Execute()
    {
        tbInput.Focus();
        cbMonthIndex.Value = DateTime.Now.ToMonthId();
        _Execute(VisualSections.List);
    }

    protected override void _Execute(string section)
    {
        if (section == VisualSections.List)
        {
            // 根据 DriverIds 取得相关数据

            var context = _DTService.Context;
            var todate = DateTime.Now.SpecificDayDate();
            var monthIndex = cbMonthIndex.Value.ToStringEx();

            if (!string.IsNullOrEmpty(monthIndex))
            {
                todate = string.Format("{0}-{1}-1", monthIndex.Substring(0, 4), monthIndex.Substring(4, 2)).ToDateTime();
            }

            // 获取已生成 payment

            var payments = (
                from p in context.CarPayments
                join d in context.Drivers on p.DriverId equals d.Id
                join c in context.Cars on p.CarId equals c.Id
                select new
                {
                    p.Id

                }).ToList();

            payments.Add(new
            {

            });







            //gw.Execute(_List, b => b
            //    .Do<Literal>("Id", (c, d) => { c.Text = d.Id; })
            //    .Do<Literal>("Name", (c, d) => c.Text = d.Name)
            //    .Do<Literal>("CHNId", (c, d) => c.Text = d.CHNId)
            //);

            return;
        }

        if (section == CMD_ChangeRental)
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
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
    }

</script>

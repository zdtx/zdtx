<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Import Namespace="eTaxi.Reports.Driver" %>
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
                <td style="padding-right: 10px;">请填入司机姓名或者车牌（然后回车）：
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
                <td style="padding-left:5px;">
                    <dx:ASPxButton runat="server" Text="显示未交齐司机" ID="bOwing">
                        <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        <Image Url="~/images/_op_flatb_rejectedit.gif" />
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
                    月份（年月）：
                </td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbMonthIndex" Width="100" AutoPostBack="true" />
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

    private List<RentalHeader> _List
    {
        get { return _ViewStateEx.Get<List<RentalHeader>>(DataStates.List, new List<RentalHeader>()); }
        set { _ViewStateEx.Set<List<RentalHeader>>(value, DataStates.List); }
    }

    private string[] _DriverIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    const string CMD_Detail = "ItemsDetail";
    const string CMD_Print = "ItemPrint";

    private string _ObjectId
    {
        get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); }
        set { _ViewStateEx.Set<string>(value, DataStates.ObjectId); }
    }

    public override string ModuleId { get { return Finance.Account_List; } }
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
                    var cars = (
                        from cc in context.Cars
                        join rr in context.CarRentals on cc.Id equals rr.CarId
                        where cc.PlateNumber.Contains(name)
                        select new
                        {
                            rr.DriverId

                        }).Distinct().ToList();

                    if (cars.Count == 0)
                    {
                        Alert("找不到车辆，请重新输入");
                        tbInput.Focus();
                        return;
                    }

                    _DriverIds = new string[] { cars[0].DriverId };
                    if (Do(Actions.Select, false)) Execute(VisualSections.List);
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

        bOwing.Click += (s, e) =>
        {
            Execute("owing");
        };

        bSubmit.Click += (s, e) =>
        {
            var selection = gw.GetSelected();
            if (!selection
                .Any(kv => kv.Value)) { Alert("请选择待生成账户。"); return; }
            if (Do(Actions.Submit, true))
            {
                Execute(VisualSections.List);
            }
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

            if (c.ModuleId == Car.Payment_Items_Update)
            {
                if (eType != EventTypes.Save) return;
                if (c.Do(Actions.Save, true))
                {
                    // _JS.Alert("保存成功。");
                    pop.Close();
                    Execute(VisualSections.List);
                }
            }

        };

        gw.Initialize(gv, c => c
            .TemplateField("CarId", "CarId", new TemplateItem.Literal(), f => f.Visible = false)
            .TemplateField("DriverId", "（内码）", new TemplateItem.Literal(l =>
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
            .TemplateField("MonthIndex", "当前月份", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("PreviousAmount", "上期应收", new TemplateItem.Label(e =>
            {
            }), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("PreviousPaid", "上期实缴", new TemplateItem.Label(e =>
            {
            }), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("OpeningBalance", "上期结余", new TemplateItem.Label(e =>
            {
            }), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("InvoiceAmount", "本期应收", new TemplateItem.Label(e =>
            {
            }), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 60;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("PaidAmount", "本期实缴", new TemplateItem.Label(e =>
            {
            }), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 60;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("ClosingBalance", "本期结余", new TemplateItem.Label(e =>
            {
            }), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("lb1", " - ", new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.CommandName = CMD_Detail;
                l.Text = "修改明细";
                l.OnClientClick = "ISEx.loadingPanel.show();";

            }), f =>
            {
                f.ItemStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            })
            .TemplateField("prnt", " - ", new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.CommandName = CMD_Print;
                l.Text = "打印";
                l.Visible = false;
                l.OnClientClick = "ISEx.loadingPanel.show();";

            }), f =>
            {
                f.ItemStyle.Width = 30;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            })
            .TemplateField("Remark", "备注", new TemplateItem.Label(e =>
            {
            }), f =>
            {
            })
        );

        gv.RowCommand += (s, e) =>
        {
            if (!new string[] { CMD_Detail, CMD_Print }.Contains(e.CommandName)) return;

            var rowIndex = e.CommandArgument.ToStringEx().ToIntOrDefault();
            var v = new GridWrapper.RowVisitor(gv.Rows[rowIndex]);
            v.Get<Literal>("CarId", carL => v.Get<Literal>("DriverId", driverL => v.Get<Literal>("MonthIndex", monthL =>
            {
                switch (e.CommandName)
                {
                    case CMD_Detail:

                        pop.PACK_0001();
                        pop.Begin<BaseControl>("~/_controls/car/payment_items_update.ascx", null, c =>
                        {
                            c.ViewStateEx.Set(carL.Text, "carId");
                            c.ViewStateEx.Set(driverL.Text, "driverId");
                            c.ViewStateEx.Set(monthL.Text, "monthIndex");
                            c.Execute();

                        }, c =>
                        {
                            c
                                .Width(700)
                                .Height(500)
                                .Title("结算明细")
                                .Button(BaseControl.EventTypes.Save, b => b.CausesValidation = true)
                            ;
                        });

                        break;

                    case CMD_Print:

                        var d1 = new List<object>();

                        //public string Ordinal { get; set; }
                        //public string Id { get; set; }
                        //public string Name { get; set; }
                        //public string Amount { get; set; }
                        //public string Paid { get; set; }
                        //public string Gap { get; set; }
                        //public string Remark { get; set; }

                        d1.Add(new
                        {
                            Name = "管理费",
                            Amount = "2500"
                        });

                        d1.Add(new
                        {
                            Name = "保险费",
                            Amount = "230"
                        });

                        var report = new RPT_MonthlyReceipt();
                        report.Replace(d1);

                        var ticketId = _SessionEx.TKObjectManager.RegCounter(report, 50);
                        JS(string.Format("ISEx.openMaxWin(\"{0}?id={1}\");",
                            _ResolvePath("/report.aspx"), ticketId.ToISFormatted()));

                        break;
                }

            })));
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
        cbMonthIndex.SelectedIndexChanged += (s, e) => _Execute(VisualSections.List);

    }

    protected override void _Execute()
    {
        tbInput.Focus();
        cbMonthIndex.Value = DateTime.Now.ToMonthId();

        _Execute("initial");

        //_List.Clear();
        //_Execute(VisualSections.List);
    }

    protected override void _Execute(string section)
    {
        if (section == "initial")
        {
            _ObjectId = DateTime.Now.SpecificDayDate().ToMonthId();
            var context = _DTService.Context;
            _DriverIds = context.CarPayments
                .Where(p => p.MonthIndex == _ObjectId)
                .Select(p => p.DriverId)
                .Distinct()
                .ToArray();

            _Execute(VisualSections.List);
        }

        if (section == "owing")
        {
            var context = _DTService.Context;
            _DriverIds = context.CarPayments
                .Where(p => p.ClosingBalance < 0 && p.MonthIndex == _ObjectId)
                .Select(p => p.DriverId)
                .Distinct()
                .ToArray();

            _Execute(VisualSections.List);

        }

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

            _ObjectId = todate.ToMonthId();

            // 获取已生成 payment

            var payments = context.CarPayments
                .Where(p => _DriverIds.Contains(p.DriverId) && p.MonthIndex == monthIndex)
                .ToList();

            var rentals = context.CarRentals
                .Where(r => _DriverIds.Contains(r.DriverId))
                .ToList();

            var headers = new List<RentalHeader>();

            headers.AddRange(payments.Select(p => new RentalHeader()
            {
                DriverId = p.DriverId,
                CarId = p.CarId
            }));

            headers.AddRange(rentals
                .Where(r => !headers.Any(h=> h.CarId == r.CarId && h.DriverId == r.DriverId))
                .Select(r => new RentalHeader()
                {
                    DriverId = r.DriverId,
                    CarId = r.CarId
                }));

            _List = headers.Distinct().ToList();

            var carIds = headers.Select(h => h.CarId).Distinct().ToArray();
            var drivers = context.Drivers.Where(d => _DriverIds.Contains(d.Id)).ToList();
            var cars = context.Cars.Where(c => carIds.Contains(c.Id)).ToList();

            _List = (
                from l in _List
                join cc in cars on l.CarId equals cc.Id
                join dd in drivers on l.DriverId equals dd.Id
                select new RentalHeader
                {
                    DriverId = l.DriverId,
                    DriverName = dd.Name,
                    CarId = l.CarId,
                    Invoiced = l.Invoiced,
                    PlateNumber = cc.PlateNumber,
                    Rental = l.Rental
                }).OrderBy(l => l.PlateNumber).ThenBy(l => l.DriverName).ToList();

            gw.Execute(_List, b => b
                .Do<Literal>("CarId", (c, d) =>
                {
                    c.Text = d.CarId;
                })
                .Do<Literal>("DriverId", (c, d) =>
                {
                    c.Text = d.DriverId;
                })
                .Do<Literal>("Name", (c, d) => drivers.FirstOrDefault(dd => dd.Id == d.DriverId).IfNN(dd =>
                {
                    c.Text = dd.Name;
                }))
                .Do<Literal>("CHNId", (c, d) => drivers.FirstOrDefault(dd => dd.Id == d.DriverId).IfNN(dd =>
                {
                    c.Text = dd.CHNId;
                }))
                .Do<Literal>("PlateNumber", (c, d) => cars.FirstOrDefault(cc => cc.Id == d.CarId).IfNN(cc =>
                {
                    c.Text = cc.PlateNumber;
                }))
                .Do<Literal>("MonthIndex", (c, d) =>
                {
                    c.Text = monthIndex;
                })
                .Do<Label>("PreviousInvoiceAmount", (c, d) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp =>
                    {
                        c.Text = pp.PreviousAmount.ToStringOrEmpty(comma: true, emptyValue: " - ", alwaysDisplaySign: true);
                        c.ColorizeNumber(pp.PreviousAmount, dd => dd > 0, dd => dd == 0);

                    }, () => c.Text = " - "))
                .Do<Label>("PreviousPaidAmount", (c, d) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp =>
                    {
                        c.Text = pp.PreviousPaid.ToStringOrEmpty(comma: true, emptyValue: " - ");
                        c.ColorizeNumber(pp.PreviousPaid, dd => dd > 0, dd => dd == 0);

                    }, () => c.Text = " - "))
                .Do<Label>("OpeningBalance", (c, d) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp =>
                    {
                        c.Text = pp.OpeningBalance.ToStringOrEmpty(comma: true, emptyValue: " - ", alwaysDisplaySign: true);
                        c.ColorizeNumber(pp.OpeningBalance, dd => dd > 0, dd => dd == 0);

                    }, () => c.Text = " - "))
                .Do<Label>("InvoiceAmount", (c, d) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp =>
                    {
                        var converted = pp.Amount; // * -1 ;
                        c.Text = converted.ToStringOrEmpty(comma: true, emptyValue: " - ");
                        // c.ColorizeNumber(converted, dd => dd > 0, dd => dd == 0);

                    }, () => c.Text = " - "))
                .Do<Label>("PaidAmount", (c, d) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp =>
                    {
                        c.Text = pp.Paid.ToStringOrEmpty(comma: true, emptyValue: " - ");
                        // c.ColorizeNumber(pp.Paid, dd => dd > 0, dd => dd == 0);

                    }, () => c.Text = " - "))
                .Do<Label>("ClosingBalance", (c, d) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp =>
                    {
                        c.Text = pp.ClosingBalance.ToStringOrEmpty(comma: true, emptyValue: " - ", alwaysDisplaySign: true);
                        c.ColorizeNumber(pp.ClosingBalance, dd => dd > 0, dd => dd == 0);

                    }, () => c.Text = " - "))
                .Do<LinkButton>("lb1", (l, d, r) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp => { l.CommandArgument = r.RowIndex.ToString(); }, () => l.Visible = false))
                .Do<Label>("Remark", (c, d) => payments
                    .FirstOrDefault(p => p.CarId == d.CarId && p.DriverId == d.DriverId)
                    .IfNN(pp =>
                    {
                        c.ForeColor = System.Drawing.Color.Empty;
                        c.Text = pp.Remark.ToStringEx(valueWhenNullOrEmpty: " - ");

                    }, () =>
                    {
                        c.ForeColor = System.Drawing.Color.Red;
                        c.Text = " (未生成) ";
                    }))
            );

        }

        if (section == Actions.Select)
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
        switch (section)
        {
            case Actions.Submit:
                _Do_Submit();
                break;
        }
    }

    private void _Do_Submit()
    {
        gw.GetSelected(_List, d => d).ForEach(item =>
        {
            _TransCall(() =>
            {
                _DTService.GenerateInvoice(item, _ObjectId);

            }, ex =>
            {
                throw ex;

            }, true);
        });
    }

</script>

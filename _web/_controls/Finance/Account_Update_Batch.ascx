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
    <div class="actionTB" style="padding-top: 2px;">
        <table>
            <tr>
                <td>
                    月份（年月）：
                </td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbMonthIndex" Width="100" AutoPostBack="true" />
                </td>
                <td>
                    <dx:ASPxButton runat="server" ID="bSave" Text="保存">
                        <Paddings Padding="0" />
                        <Image Url="~/images/_op_flatb_save.gif" />
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

    private List<TB_car_payment_item> _Items
    {
        get { return _ViewStateEx.Get<List<TB_car_payment_item>>(DataStates.Detail, new List<TB_car_payment_item>()); }
        set { _ViewStateEx.Set<List<TB_car_payment_item>>(value, DataStates.Detail); }
    }

    private string[] _DriverIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    private string _ObjectId
    {
        get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); }
        set { _ViewStateEx.Set<string>(value, DataStates.ObjectId); }
    }

    private int _InvoiceDayIndex
    {
        get { return Host.Settings.Get<int>("MonthlyInvoiceDayIndex", 15); }
    }

    private List<RentalHeader> _UnresolvedList = new List<RentalHeader>();
    private List<TB_charge> _Fields = new List<TB_charge>();
    public override string ModuleId { get { return Finance.Account_Update_Batch; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;

        // 获取元数据
        var context = _DTService.Context;
        _Fields = context.Charges.OrderBy(c => c.Code).ToList();

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

        gw.Initialize(gv, c =>
        {
            c
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
                .TemplateField("StartDate", "期初", new TemplateItem.Label(e =>
                {
                }), f =>
                {
                })
                .TemplateField("EndDate", "期末", new TemplateItem.Label(e =>
                {
                }), f =>
                {
                })
                ;

            _Fields.ForEach(f =>
            {
                c.TemplateField(f.Id + "_Amount", f.Name + "-应收", new TemplateItem.DXSpinEdit(e =>
                {
                    switch (f.AccountingIndex)
                    {
                        case (int)AccountingIndex.AdminFee:
                        case (int)AccountingIndex.Log:
                        case (int)AccountingIndex.Violation:
                            e.Enabled = false;
                            e.Width = 70;
                            break;
                        case (int)AccountingIndex.Rental:
                            e.Enabled = false;
                            e.Width = 100;
                            break;
                        default:
                            e.Width = 70;
                            break;
                    }

                    e.HorizontalAlign = HorizontalAlign.Right;
                    e.SpinButtons.ShowIncrementButtons = false;
                    e.DisplayFormatString = "{0:N2}";
                    e.DecimalPlaces = 2;

                }), ff =>
                {
                    ff.ItemStyle.Width = 10;
                });

                c.TemplateField(f.Id + "_Paid", f.Name + "-实收", new TemplateItem.DXSpinEdit(e =>
                {
                    switch (f.AccountingIndex)
                    {
                        case (int)AccountingIndex.AdminFee:
                        case (int)AccountingIndex.Log:
                        case (int)AccountingIndex.Violation:
                            e.Width = 70;
                            break;
                        case (int)AccountingIndex.Rental:
                            e.Width = 100;
                            break;
                        default:
                            e.Width = 70;
                            break;
                    }

                    e.HorizontalAlign = HorizontalAlign.Right;
                    e.SpinButtons.ShowIncrementButtons = false;
                    e.DisplayFormatString = "{0:N2}";
                    e.DecimalPlaces = 2;
                    e.ForeColor = System.Drawing.Color.Green;

                }), ff =>
                {
                    ff.ItemStyle.Width = 10;
                });
            });

        });

        // 月份
        var monthIds = new List<string>();
        var todate = DateTime.Now.Date;

        for (var i = 0; i < 10; i++)
        {
            if (i == 0)
            {
                monthIds.AddRange(todate.ToMonthIds(extraMonths: 1));
                continue;
            }

            monthIds.AddRange(todate.AddYears(i).ToMonthIds());
            monthIds.AddRange(todate.AddYears(-1 * i).ToMonthIds());
        }

        cbMonthIndex.FromList(monthIds, (dd, i) => { i.Text = dd; i.Value = dd; return true; });
        cbMonthIndex.SelectedIndexChanged += (s, e) => _Execute(VisualSections.List);

        bSave.Click += (s, e) =>
        {
            if (Do(Actions.Save, true))
            {
                Alert("保存成功");
                Execute(VisualSections.List);
            }
        };

    }

    protected override void _Execute()
    {
        tbInput.Focus();
        cbMonthIndex.Value = _ObjectId = DateTime.Now.ToMonthId();
        _List.Clear();
        _Execute(VisualSections.List);
    }

    protected override void _Execute(string section)
    {
        if (section == VisualSections.List)
        {
            // 根据 DriverIds 取得相关数据

            var context = _DTService.Context;
            _ObjectId = cbMonthIndex.Value.ToStringEx();

            // 获取已生成 payment

            var payments = context.CarPayments
                .Where(p => _DriverIds.Contains(p.DriverId) && p.MonthIndex == _ObjectId)
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

            // 如有未生成的，则马上生成
            _UnresolvedList.Clear();
            _UnresolvedList.AddRange(rentals
                .Where(r => !headers.Any(h => h.CarId == r.CarId && h.DriverId == r.DriverId))
                .Select(r => new RentalHeader()
                {
                    DriverId = r.DriverId,
                    CarId = r.CarId
                }));

            if (_UnresolvedList.Count > 0)
            {
                if (!Do(Actions.Process, true)) return;

                // Reload payment
                payments = context.CarPayments
                    .Where(p => _DriverIds.Contains(p.DriverId) && p.MonthIndex == _ObjectId)
                    .ToList();
            }

            _List = payments.Select(p => new RentalHeader() { CarId = p.CarId, DriverId = p.DriverId }).ToList();

            var carIds = rentals.Select(r => r.CarId).Distinct().ToArray();
            var drivers = context.Drivers.Where(d => _DriverIds.Contains(d.Id)).ToList();
            var cars = context.Cars.Where(c => carIds.Contains(c.Id)).ToList();

            _Items = context.CarPaymentItems
                .Where(i => carIds.Contains(i.CarId) && _DriverIds.Contains(i.DriverId) && i.MonthIndex == _ObjectId)
                .ToList();

            gw.Execute(_List, b =>
            {
                b
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
                        c.Text = _ObjectId;
                    })
                    .Do<Label>("StartDate", (c, d) =>
                    {
                        payments.FirstOrDefault(p => p.DriverId == d.DriverId).IfNN(p =>
                        {
                            c.Text = p.StartDate.ToISDate();
                        }, ()=>
                        {
                            c.Text = "(未生成)";
                            c.ForeColor = System.Drawing.Color.Red;
                        });
                    })
                    .Do<Label>("EndDate", (c, d) =>
                    {
                        payments.FirstOrDefault(p => p.DriverId == d.DriverId).IfNN(p =>
                        {
                            c.Text = p.EndDate.ToISDate();
                        }, ()=>
                        {
                            c.Text = " - ";
                        });
                    })
                    ;

                _Fields.ForEach(f =>
                {
                    b.Do<ASPxSpinEdit>(f.Id + "_Amount", (c, d) =>
                    {
                        _Items
                            .FirstOrDefault(i =>
                                i.CarId == d.CarId && i.DriverId == d.DriverId && i.ChargeId == f.Id)
                            .IfNN(item =>
                            {
                                c.Visible = true;
                                c.Value = item.Amount;

                            }, ()=>
                            {
                                c.Visible = false;
                            });
                    });

                    b.Do<ASPxSpinEdit>(f.Id + "_Paid", (c, d) =>
                    {
                        _Items
                            .FirstOrDefault(i =>
                                i.CarId == d.CarId && i.DriverId == d.DriverId && i.ChargeId == f.Id)
                            .IfNN(item =>
                            {
                                c.Visible = true;
                                c.Value = item.Paid;

                            }, ()=>
                            {
                                c.Visible = false;
                            });
                    });

                });

            });

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
            case Actions.Select:
                _Do_Collect();
                break;
            case Actions.Process:
                _Do_Process();
                break;
            case Actions.Save:
                _Do_Save();
                break;
        }
    }

    private void _Do_Process()
    {
        // 仅仅支持当月的自动生成
        if (_ObjectId != DateTime.Now.SpecificDayDate().ToMonthId()) return;
        _UnresolvedList.ForEach(item => _DTService.GenerateInvoice(item, _ObjectId));
    }

    private void _Do_Save()
    {
        if (_List.Count == 0) return;
        _Do_Collect();

        var context = _DTService.Context;
        var carIds = _List.Select(d => d.CarId).ToArray();
        var driverIds = _List.Select(d => d.DriverId).ToArray();
        var payments = context.CarPayments
            .Where(i => carIds.Contains(i.CarId) && _DriverIds.Contains(i.DriverId) && i.MonthIndex == _ObjectId)
            .ToList();
        var items = context.CarPaymentItems
            .Where(i => carIds.Contains(i.CarId) && _DriverIds.Contains(i.DriverId) && i.MonthIndex == _ObjectId)
            .ToList();

        items.ForEach(i =>
        {
            _Items
                .FirstOrDefault(ii =>
                    ii.CarId == i.CarId && ii.DriverId == i.DriverId && ii.ChargeId == i.ChargeId)
                .IfNN(ii =>
                {
                    i.Amount = ii.Amount;
                    i.Paid = ii.Paid;
                });
        });

        foreach (var payment in payments)
        {
            payment.Amount = items
                .Where(i => i.CarId == payment.CarId && i.DriverId == payment.DriverId)
                .Sum(i => i.Amount);
            payment.Paid = items
                .Where(i => i.CarId == payment.CarId && i.DriverId == payment.DriverId)
                .Sum(i => i.Paid);
            payment.ClosingBalance = payment.Paid - (payment.Amount - (payment.OpeningBalance ?? 0m));
        }

        context.SubmitChanges();

    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col =>
        {
            _Fields.ForEach(f =>
            {
                col.Do<ASPxSpinEdit>(f.Id + "_Amount", (d, c) =>
                {
                    _Items
                        .FirstOrDefault(i =>
                            i.CarId == d.CarId && i.DriverId == d.DriverId && i.ChargeId == f.Id)
                        .IfNN(item =>
                        {
                            item.Amount = c.Number;
                        });
                });

                col.Do<ASPxSpinEdit>(f.Id + "_Paid", (d, c) =>
                {
                    _Items
                        .FirstOrDefault(i =>
                            i.CarId == d.CarId && i.DriverId == d.DriverId && i.ChargeId == f.Id)
                        .IfNN(item =>
                        {
                            item.Paid = c.Number;
                        });
                });
            });
        });
    }


</script>

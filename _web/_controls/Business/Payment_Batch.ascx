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
                <td style="padding-right: 10px;">请填入车牌号（然后回车）：
                </td>
                <td>
                    <dx:ASPxTextBox runat="server" ID="tbInput" Width="100" />
                </td>
                <td style="padding-left: 10px;">或者：
                </td>
                <td>
                    <dx:ASPxButton runat="server" Text="在列表中选择车辆" ID="bSelect">
                        <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        <Image Url="~/images/_doc_16_workflowtemplate.gif" />
                    </dx:ASPxButton>
                </td>
                <td style="padding-left: 10px;">选择月份：
                </td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbMonth" AutoPostBack="true" Width="100" />
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
                （ 请先选择车辆和对应的 <b>月份</b> ）
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
<script runat="server">

    private List<TB_car_payment> _List
    {
        get { return _ViewStateEx.Get<List<TB_car_payment>>(DataStates.List, new List<TB_car_payment>()); }
        set { _ViewStateEx.Set<List<TB_car_payment>>(value, DataStates.List); }
    }

    private List<string> _CarIds
    {
        get { return _ViewStateEx.Get<List<string>>(DataStates.Selected, new List<string>()); }
        set { _ViewStateEx.Set<List<string>>(value, DataStates.Selected); }
    }

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Business.Payment_Batch; } }
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
                var plateNumber = tbInput.Text.ToStringEx();
                var cars = context.Cars.Where(cc => cc.PlateNumber.Contains(plateNumber)).ToList();
                if (cars.Count == 0)
                {
                    Alert("找不到车辆，请重新输入");
                    tbInput.Text = string.Empty;
                    tbInput.Focus();
                    return;
                }
                if (cars.Count == 1)
                {
                    _CarIds.Add(cars[0].Id);
                    if (Do(Actions.Select, false)) Execute(VisualSections.List);
                    tbInput.Text = string.Empty;
                    tbInput.Focus();
                    return;
                }
                Alert("有超过一辆车符合该车牌特征，请检查");
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
                    b.Text = "移除选定的车辆（不作修改）";
                    b.Visible = true;
                    b.ConfirmText = "确定移除吗？";
                })
                .Button(BaseControl.EventTypes.Yes, b =>
                {
                    b.Visible = true;
                    b.Text = "设为收讫";
                    b.ConfirmText = "以下司机的月份欠款将做平帐处理（将设置 已缴 = 应缴 ），门户将不会出现催缴信息，确定修改吗?";
                })
                , fh.CurrentGroup)
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
                            Execute(VisualSections.List);
                        }
                        break;
                    case BaseControl.EventTypes.Yes:
                        if (Do(Actions.Approve, true))
                        {
                            Alert("保存成功");
                            Execute(VisualSections.List);
                        }
                        break;
                }
            };

        cbMonth.FromList(_CurrentTime.ToMonthIds().ToList(),
            (d, i) => { i.Text = d; i.Value = d; return true; }, false,
            () => _CurrentTime.AddMonths(-1).ToMonthId());
        cbMonth.SelectedIndexChanged += (s, e) =>
        {
            _List.Clear();
            if (Do(Actions.Select, false)) Execute(VisualSections.List);
        };

        bReset.Click += (s, e) =>
        {
            _List.Clear();
            _CarIds = new List<string>();
            Execute(VisualSections.List);
            tbInput.Focus();
        };

        bSelect.Click += (s, e) =>
        {
            if (string.IsNullOrEmpty(cbMonth.Value.ToStringEx()))
            {
                Alert("请先选择要填报的月份");
                return;
            }

            pop.Begin<eTaxi.Web.Controls.Selection.Car.Item>(
                "~/_controls.helper/selection/car/items.ascx", null, c =>
                {
                    c.Execute();
                }, c =>
                {
                    c
                        .Width(650)
                        .Height(500)
                        .Title("先选择车辆")
                        .Button(BaseControl.EventTypes.OK, b => b.CausesValidation = true)
                    ;
                });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            c.If<eTaxi.Web.Controls.Selection.Car.Item>(cc =>
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.OK:

                        if (cc.Selection.Count == 0)
                        {
                            Alert("您还没选定车辆，请先选择车辆");
                            return;
                        }

                        pop.Close();
                        var carIds = cc.Selection.Select(s => s.Id).ToArray();
                        _CarIds.AddRange(carIds);
                        _ViewStateEx.Set(carIds, DataStates.Selected);
                        if (Do(Actions.Select, false)) Execute(VisualSections.List);
                        break;
                }
            });
        };

        gw.Initialize(gv, c => c
            .TemplateField("PlateNumber", "车牌号", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("DriverName", "司机", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("MonthIndex", "月份", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("Days", "本月天数", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("CountDays", "计费天数", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Amount", "应缴", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Paid", "已缴", new TemplateItem.DXSpinEdit(e =>
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
            .TemplateField("Balance", "结欠", new TemplateItem.Label(e =>
            {
                e.Width = 100;
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            );
    }

    protected override void _Execute()
    {
        tbInput.Focus();
    }

    protected override void _Execute(string section)
    {
        if (section == VisualSections.List)
        {
            var context = _DTContext<CommonContext>(true);
            var carIds = _List.Select(d => d.CarId).ToArray();
            var driverIds = _List.Select(d => d.DriverId).ToArray();
            var cars = context.Cars
                .Where(c => carIds.Contains(c.Id))
                .Select(c => new { c.Id, c.PlateNumber })
                .ToList();
            var drivers = context.Drivers
                .Where(d => driverIds.Contains(d.Id))
                .Select(d => new { d.Id, d.Name })
                .ToList();
            var data = (
                from l in _List
                join c in cars on l.CarId equals c.Id
                join d in drivers on l.DriverId equals d.Id
                select new
                {
                    l.CarId,
                    l.DriverId,
                    c.PlateNumber,
                    DriverName = d.Name,
                    l.MonthIndex,
                    l.Days,
                    l.CountDays,
                    l.Amount,
                    l.Paid
                }).ToList();

            gw.Execute(data, b => b
                .Do<Literal>("PlateNumber", (c, d) => { c.Text = d.PlateNumber; })
                .Do<Literal>("DriverName", (c, d) => { c.Text = d.DriverName; })
                .Do<Literal>("MonthIndex", (c, d) => { c.Text = d.MonthIndex; })
                .Do<Literal>("Days", (c, d) => { c.Text = d.Days.ToString(); })
                .Do<Literal>("CountDays", (c, d) => { c.Text = d.CountDays.ToString(); })
                .Do<Literal>("Amount", (c, d) => { c.Text = d.Amount.ToStringOrEmpty(comma: true); })
                .Do<ASPxSpinEdit>("Paid", (c, d) => { c.Number = d.Paid.ToCHNRounded(); })
                .Do<Label>("Balance", (c, d) =>
                {
                    var gap = d.Paid - d.Amount;
                    c.Text = gap.ToStringOrEmpty(comma: true, emptyValue: "（收讫）");
                    c.ColorizeNumber(gap, v => v >= 0);
                })
            );

            at.Visible = data.Count > 0;
            return;
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Select) _Do_Select();
        if (section == Actions.Save) _Do_Save();
        if (section == Actions.Approve) _Do_Approve();
    }

    private void _Do_Save()
    {
        if (_List.Count == 0) return;
        var context = _DTService.Context;
        var monthIndex = cbMonth.Value.ToStringEx();
        var carIds = _List.Select(d => d.CarId).ToArray();
        var payments = context.CarPayments.Where(p =>
            carIds.Contains(p.CarId) && p.MonthIndex == monthIndex).ToList();
        _Do_Collect();
        _List.ForEach(d =>
        {
            context
                .Update<TB_car_payment>(_SessionEx,
                    p => p.CarId == d.CarId && p.MonthIndex == d.MonthIndex, payment =>
                    {
                        var delayed =
                            payment.Amount > payment.Paid && payment.Due < _CurrentTime.Date;
                        payment.Paid = d.Paid;
                        payment.Name = (payment.Paid >= payment.Amount && delayed) ? // 建立逾期标记
                            payment.Name = payment.MonthIndex + ".d" : payment.MonthIndex;
                    })
                .SubmitChanges();
        });
    }

    private void _Do_Approve()
    {
        if (_List.Count == 0) return;
        var context = _DTService.Context;
        var monthIndex = cbMonth.Value.ToStringEx();
        var carIds = _List.Select(d => d.CarId).ToArray();
        var payments = context.CarPayments.Where(p =>
            carIds.Contains(p.CarId) && p.MonthIndex == monthIndex).ToList();
        _Do_Collect();
        _List.ForEach(d =>
        {
            context
                .Update<TB_car_payment>(_SessionEx,
                    p => p.CarId == d.CarId && p.MonthIndex == d.MonthIndex, payment =>
                    {
                        var delayed =
                            payment.Amount > payment.Paid && payment.Due < _CurrentTime.Date;
                        d.Paid = payment.Paid = payment.Amount;
                        payment.Name = (payment.Paid >= payment.Amount && delayed) ? // 建立逾期标记
                            payment.Name = payment.MonthIndex + ".d" : payment.MonthIndex;
                    })
                .SubmitChanges();
        });
    }

    private void _Do_Select()
    {
        if (_List.Count > 0) _Do_Collect();
        var context = _DTContext<CommonContext>(true);
        var curDriverIds = context.CarRentals
            .Where(r => _CarIds.Contains(r.CarId))
            .Select(r => r.DriverId).ToArray();
        var hisDriverIds = context.CarRentalHistories
            .Where(r => _CarIds.Contains(r.CarId))
            .Select(r => r.DriverId).Distinct().ToArray();
        var driverIds = curDriverIds.Union(hisDriverIds).ToArray();
        var monthIndex = cbMonth.Value.ToStringEx();
        var payments = (
            from p in context.CarPayments
            where
                _CarIds.Contains(p.CarId) &&
                driverIds.Contains(p.DriverId) &&
                p.MonthIndex == monthIndex
            select p).ToList();

        // 补充没有的部分
        payments.ForEach(p =>
        {
            if (!
                _List.Any(l => l.CarId == p.CarId && l.MonthIndex == p.MonthIndex))
                _List.Add(p);
        });

        // 优化车牌号的存储
        _CarIds = _CarIds.Distinct().ToList();

        // 执行优化排序
        var cars = context.Cars
            .Where(c => _CarIds.Contains(c.Id)).Select(c => new { c.Id, c.PlateNumber }).ToList();
        _List = (
            from d in _List
            join c in cars on d.CarId equals c.Id
            orderby c.PlateNumber
            select d).ToList();
    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxSpinEdit>("Paid", (d, c) => d.Paid = c.Number)
        );
    }

</script>

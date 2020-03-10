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
                （请先选择车辆）
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
<script runat="server">

    private List<TB_car_complain> _List
    {
        get { return _ViewStateEx.Get<List<TB_car_complain>>(DataStates.List, new List<TB_car_complain>()); }
        set { _ViewStateEx.Set<List<TB_car_complain>>(value, DataStates.List); }
    }

    private string[] _CarIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    public override string ModuleId { get { return Business.Complain_Batch; } }
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
                    _CarIds = new string[] { cars[0].Id };
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
            .TemplateField("DriverId", "当事司机", new TemplateItem.DXComboBox(e =>
                {
                    e.Width = 80;
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 80;
                    f.ItemStyle.Width = 80;
                })
            .TemplateField("Source", "投诉来源", new TemplateItem.DXComboBox(e =>
                {
                    e.Width = 80;
                    e.FromEnum<ComplainSource>(valueAsInteger: true);
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 80;
                    f.ItemStyle.Width = 80;
                })
            .TemplateField("Time", "发生时间", new TemplateItem.DXDateEdit(e =>
                {
                    e.Width = 140;
                    e.DisplayFormatString = 
                    e.EditFormatString = "yyyy-MM-dd HH:mm";
                    e.TimeSectionProperties.Visible = true;
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 140;
                    f.ItemStyle.Width = 140;
                })
            .TemplateField("Type", "投诉类型", new TemplateItem.DXComboBox(e =>
                {
                    e.Width = 80;
                    e.FromEnum<ComplainType>(valueAsInteger: true);
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 80;
                    f.ItemStyle.Width = 80;
                })
            .TemplateField("OwnFault", "责任", new TemplateItem.DXCheckBox(e =>
                {
                    e.Text = "有";
                    e.Width = 50;
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 50;
                    f.ItemStyle.Width = 50;
                })
            .TemplateField("Name", "标题", new TemplateItem.DXTextBox(e =>
                {
                    e.Width = 150;
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 150;
                    f.ItemStyle.Width = 150;
                })
            .TemplateField("Description", "描述", new TemplateItem.DXTextBox(e =>
                {
                    e.Width = 200;
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 200;
                    f.ItemStyle.Width = 200;
                })
            .TemplateField("ContactPerson", "投诉人", new TemplateItem.DXTextBox(e =>
                {
                    e.Width = 60;
                    fh.Validate(e).IsRequired();
                }), f =>
                {
                    f.HeaderStyle.Width = 60;
                    f.ItemStyle.Width = 60;
                })
            .TemplateField("Contact", "联系方式", new TemplateItem.DXTextBox(e =>
                {
                    e.Width = 100;
                }), f =>
                {
                    f.HeaderStyle.Width = 100;
                    f.ItemStyle.Width = 100;
                })
            .TemplateField("Coordinator", "协调处理人", new TemplateItem.DXTextBox(e =>
                {
                    e.Width = 100;
                }), f =>
                {
                    f.HeaderStyle.Width = 100;
                    f.ItemStyle.Width = 100;
                })
            .TemplateField("Fine", "罚款", new TemplateItem.DXSpinEdit(e =>
                {
                    e.Width = 80;
                    e.HorizontalAlign = HorizontalAlign.Right;
                    e.SpinButtons.ShowIncrementButtons = false;
                    e.DisplayFormatString = "{0:N0} 元";
                }), f =>
                {
                    f.HeaderStyle.Width = 80;
                    f.ItemStyle.Width = 80;
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
            var context = _DTContext<CommonContext>(true);
            var carIds = _List.Select(d => d.CarId).ToArray();
            var cars = context.Cars
                .Where(c => carIds.Contains(c.Id))
                .Select(c => new { c.Id, c.PlateNumber })
                .ToList();
            var currentDrivers = (
                from r in context.CarRentals
                join d in context.Drivers on r.DriverId equals d.Id
                where carIds.Contains(r.CarId)
                select new
                {
                    r.CarId,
                    r.DriverId,
                    d.Name
                }).ToList();
            var shiftDrivers = (
                from s in context.CarRentalShifts
                join d in context.Drivers on s.SubDriverId equals d.Id
                where carIds.Contains(s.CarId) && s.IsActive
                select new
                {
                    s.CarId,
                    s.DriverId,
                    d.Name
                }).ToList();
            
            var data = (
                from l in _List
                join c in cars on l.CarId equals c.Id
                select new
                {
                    CarId = c.Id,
                    l.DriverId,
                    c.PlateNumber,
                    l.Source,
                    l.Time,
                    l.Type,
                    l.OwnFault,
                    l.Name,
                    l.Description,
                    l.ContactPerson,
                    l.Contact,
                    l.Coordinator,
                    l.Fine
                }).ToList();

            gw.Execute(data, b => b
                .Do<Literal>("PlateNumber", (c, d) => { c.Text = d.PlateNumber; })
                .Do<ASPxComboBox>("DriverId", (c, d) =>
                    {
                        var drivers = 
                            currentDrivers.Where(dd => dd.CarId == d.CarId).Concat(
                            shiftDrivers.Where(dd => dd.CarId == d.CarId)).ToList();
                        c.Items.Clear();
                        c.FromList(drivers, (dd, i) =>
                            {
                                i.Text = dd.Name;
                                i.Value = dd.DriverId;
                                return true;
                            });
                        c.Value = d.DriverId;
                    })

                .Do<ASPxComboBox>("Source", (c, d) => c.Value = d.Source.ToStringEx())
                .Do<ASPxDateEdit>("Time", (c, d) => c.Date = d.Time)
                .Do<ASPxComboBox>("Type", (c, d) => c.Value = d.Type.ToStringEx())
                .Do<ASPxCheckBox>("OwnFault", (c, d) => c.Checked = d.OwnFault)
                .Do<ASPxTextBox>("Name", (c, d) => c.Text = d.Name)
                .Do<ASPxTextBox>("Description", (c, d) => c.Text = d.Description)
                .Do<ASPxTextBox>("ContactPerson", (c, d) => c.Text = d.ContactPerson)
                .Do<ASPxTextBox>("Contact", (c, d) => c.Text = d.Contact)
                .Do<ASPxTextBox>("Coordinator", (c, d) => c.Text = d.Coordinator)
                .Do<ASPxSpinEdit>("Fine", (c, d) => c.Value = d.Fine)
            );

            at.Visible = data.Count > 0;
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
        var context = _DTService.Context;
        _Do_Collect();
        _List.ForEach(d =>
        {
            var newId = context.NewSequence<TB_car_complain>(_SessionEx);
            context
                .Create<TB_car_complain>(_SessionEx, violation =>
                    {
                        d.FlushTo(violation);
                        violation.Id = newId;

                        if (violation.Fine.HasValue)
                        {
                            var amount = violation.Fine.Value;
                            var newBalanceId = string.Empty;
                            context
                                .NewSequence<TB_car_balance>(_SessionEx, (seq, id) => newBalanceId = id)
                                .Create<TB_car_balance>(_SessionEx, o =>
                                {
                                    o.CarId = d.CarId;
                                    o.Id = newBalanceId;
                                    o.Ref1 = newId;
                                    o.Ref2 = d.DriverId;
                                    o.Source = (int)CarBalanceSource.Complain;
                                    o.Title = d.Name;
                                    o.IsIncome = false;
                                    o.Time = d.Time.Date;
                                    o.Amount = Math.Abs(amount);
                                    o.Status = (int)IssueStatus.Pending;
                                });
                        }
                        
                    })
                .SubmitChanges();
        });
    }

    private void _Do_Select()
    {
        _Do_Collect();
        _CarIds.ForEach(id =>
        {
            _List.Add(new TB_car_complain()
            {
                CarId = id
            });
        });
    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxComboBox>("DriverId", (d, c) => d.DriverId = c.Value.ToStringEx())
            .Do<ASPxComboBox>("Source", (d, c) => d.Source = c.Value.ToStringEx().ToIntOrDefault(-1))
            .Do<ASPxDateEdit>("Time", (d, c) => d.Time = c.Date)
            .Do<ASPxComboBox>("Type", (d, c) => d.Type = c.Value.ToStringEx().ToIntOrDefault(-1))
            .Do<ASPxCheckBox>("OwnFault", (d, c) => d.OwnFault = c.Checked)
            .Do<ASPxTextBox>("Name", (d, c) => d.Name = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Description", (d, c) => d.Description = c.Value.ToStringEx())
            .Do<ASPxTextBox>("ContactPerson", (d, c) => d.ContactPerson = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Contact", (d, c) => d.Contact = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Coordinator", (d, c) => d.Coordinator = c.Value.ToStringEx())
            .Do<ASPxSpinEdit>("Fine", (d, c) => d.Fine = c.Value.ToStringEx().ToDecimalOrNull())
        );
    }    

</script>

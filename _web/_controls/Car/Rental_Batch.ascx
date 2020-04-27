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

    private List<TB_car_rental> _List
    {
        get { return _ViewStateEx.Get<List<TB_car_rental>>(DataStates.List, new List<TB_car_rental>()); }
        set { _ViewStateEx.Set<List<TB_car_rental>>(value, DataStates.List); }
    }

    private string[] _CarIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Rental_Batch; } }
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
                            Execute(VisualSections.List);
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
            .TemplateField("DriverName", "司机", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("CarRental", "车辆租金/管理费", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Ordinal", "排序", new TemplateItem.DXSpinEdit(e =>
            {
                e.Width = 50;
                e.SpinButtons.ShowIncrementButtons = false;
                e.NumberType = SpinEditNumberType.Integer;
                fh.Validate(e).IsRequired();
            }), f =>
            {
                f.HeaderStyle.Width = 50;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("StartTime", "发车时间", new TemplateItem.DXDateEdit(e =>
            {
                e.Width = 100;
                e.DisplayFormatString = e.EditFormatString = "yyyy-MM-dd";
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("IsProbation", "是否试用", new TemplateItem.DXCheckBox(e =>
            {
                e.Width = 50;
                e.Text = "是";
                fh.Validate(e).IsRequired();
            }), f =>
            {
                f.HeaderStyle.Width = 50;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("ProbationExpiryDate", "试用结束时间", new TemplateItem.DXDateEdit(e =>
            {
                e.Width = 100;
                e.DisplayFormatString = e.EditFormatString = "yyyy-MM-dd";
            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Rental", "租金/管理费", new TemplateItem.DXSpinEdit(e =>
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
            .TemplateField("Extra1", "社保", new TemplateItem.DXSpinEdit(e =>
            {
                e.Width = 100;
                e.HorizontalAlign = HorizontalAlign.Right;
                e.SpinButtons.ShowIncrementButtons = false;
            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Extra2", "其他月扣款", new TemplateItem.DXSpinEdit(e =>
            {
                e.Width = 100;
                e.HorizontalAlign = HorizontalAlign.Right;
                e.SpinButtons.ShowIncrementButtons = false;
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
                .Select(c => new { c.Id, c.PlateNumber, c.Rental })
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
                    CarRental = c.Rental,
                    DriverName = d.Name,
                    l.Ordinal,
                    l.StartTime,
                    l.Rental,
                    l.Extra1,
                    l.Extra2,
                    l.IsProbation,
                    l.ProbationExpiryDate,
                    l.Remark
                }).ToList();

            gw.Execute(data, b => b
                .Do<Literal>("PlateNumber", (c, d) => { c.Text = d.PlateNumber; })
                .Do<Literal>("DriverName", (c, d) => { c.Text = d.DriverName; })
                .Do<Literal>("CarRental", (c, d) => { c.Text = d.CarRental.ToCHNRounded().ToString(); })
                .Do<ASPxSpinEdit>("Ordinal", (c, d) => { c.Number = d.Ordinal; })
                .Do<ASPxDateEdit>("StartTime", (c, d) => { c.Date = d.StartTime; })
                .Do<ASPxSpinEdit>("Rental", (c, d) => { c.Number = d.Rental.ToCHNRounded(); })
                .Do<ASPxSpinEdit>("Extra1", (c, d) => { c.Number = d.Extra1.ToCHNRounded(); })
                .Do<ASPxSpinEdit>("Extra2", (c, d) => { c.Number = d.Extra2.ToCHNRounded(); })
                .Do<ASPxCheckBox>("IsProbation", (c, d) => { c.Checked = d.IsProbation; })
                .Do<ASPxDateEdit>("ProbationExpiryDate", (c, d) => { c.Value = d.ProbationExpiryDate; })
                .Do<ASPxTextBox>("Remark", (c, d) => { c.Value = d.Remark; })
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
        var carIds = _List.Select(d => d.CarId).ToArray();
        var rentals = context.CarRentals.Where(p => carIds.Contains(p.CarId)).ToList();
        _Do_Collect();
        _List.ForEach(d =>
        {
            rentals
                .SingleOrDefault(r => r.CarId == d.CarId && r.DriverId == d.DriverId).IfNN(r =>
                {
                    r.Ordinal = d.Ordinal;
                    r.StartTime = d.StartTime;
                    r.Rental = d.Rental;
                    r.Extra1 = d.Extra1;
                    r.Extra2 = d.Extra2;
                    r.IsProbation = d.IsProbation;
                    r.ProbationExpiryDate = d.ProbationExpiryDate;
                });
        });
        context.SubmitChanges();
    }

    private void _Do_Select()
    {
        _Do_Collect();
        var context = _DTContext<CommonContext>(true);
        var driverIds = context.CarRentals
            .Where(r => _CarIds.Contains(r.CarId))
            .Select(r => r.DriverId).ToArray();
        var rentals = (
            from p in context.CarRentals
            where
                _CarIds.Contains(p.CarId) &&
                driverIds.Contains(p.DriverId)
            select p).ToList();

        // 补充没有的部分
        rentals.ForEach(p =>
        {
            if (!
                _List.Any(l => l.CarId == p.CarId && l.DriverId == p.DriverId))
                _List.Add(p);
        });
    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxSpinEdit>("Ordinal", (d, c) => d.Ordinal = (int)c.Number)
            .Do<ASPxDateEdit>("StartTime", (d,c)=>d.StartTime = c.Date.Date)
            .Do<ASPxSpinEdit>("Rental", (d, c) => d.Rental = c.Number)
            .Do<ASPxSpinEdit>("Extra1", (d, c) =>
            {
                if (string.IsNullOrEmpty(c.Value.ToStringEx()))
                {
                    d.Extra1 = 0;
                }
                else
                {
                    d.Extra1 = c.Number;
                }
            })
            .Do<ASPxSpinEdit>("Extra2", (d, c) =>
            {
                if (string.IsNullOrEmpty(c.Value.ToStringEx()))
                {
                    d.Extra2 = 0;
                }
                else
                {
                    d.Extra2 = c.Number;
                }
            })
            .Do<ASPxCheckBox>("IsProbation", (d, c) => d.IsProbation = c.Checked)
            .Do<ASPxDateEdit>("ProbationExpiryDate", (d, c) =>
            {
                if (string.IsNullOrEmpty(c.Value.ToStringEx()))
                {
                    if (d.IsProbation) throw new Exception("请指定试用到期日");
                    d.ProbationExpiryDate = null;
                }
                else
                {
                    d.ProbationExpiryDate = c.Date.Date;
                }
            })
            .Do<ASPxTextBox>("Remark", (d, c) => d.Remark = c.Value.ToStringEx())
        );
    }

</script>

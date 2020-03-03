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
                <td style="padding-right:10px;">
                    选择车辆来源：
                </td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cbSource" AutoPostBack="true" Width="150">
                        <ClientSideEvents
                            SelectedIndexChanged="function(s,e){ISEx.loadingPanel.show();}" /> 
                    </dx:ASPxComboBox>
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

    private List<TB_car> _List
    {
        get { return _ViewStateEx.Get<List<TB_car>>(DataStates.List, new List<TB_car>()); }
        set { _ViewStateEx.Set<List<TB_car>>(value, DataStates.List); }
    }

    private string[] _CarIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Update_Batch_1; } }
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
            .TemplateField("Id", "（内码）", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("PlateNumber", "车牌号", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("Source", "获得方式", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 200;
            }), f =>
            {
                f.HeaderStyle.Width = 200;
                f.ItemStyle.Width = 200;
            })
            .TemplateField("FormerPlateNum", "原车牌号", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 80;
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 80;
                f.ItemStyle.Width = 80;
            })
            .TemplateField("Manufacturer", "车辆品牌", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 100;
                fh.Validate(e).IsRequired();

            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Model", "型号", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 100;
            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Type", "性质", new TemplateItem.DXComboBox(e =>
            {
                e.Width = 50;
                e.FromEnum<CarType>(valueAsInteger: true);
                fh.Validate(e).IsRequired();
            }), f =>
            {
                f.HeaderStyle.Width = 50;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("HandOverTime", "交接班时间", new TemplateItem.DXTimeEdit(e =>
            {
                e.Width = 80;
                e.SpinButtons.ShowIncrementButtons = false;
            }), f =>
            {
                f.HeaderStyle.Width = 80;
                f.ItemStyle.Width = 80;
            })
            .TemplateField("HandOverPlace", "交接班地点", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 100;
            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Fleet", "所属车队", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 100;
            }), f =>
            {
                f.HeaderStyle.Width = 100;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Remark", "备注", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 200;
            }), f =>
            {
                f.HeaderStyle.Width = 200;
                f.ItemStyle.Width = 200;
            })
        );

        cbSource.SelectedIndexChanged += (s, e) =>
        {
            if (Do(Actions.Select, "source", false)) Execute(VisualSections.List);
        };

    }

    protected override void _Execute()
    {
        _List.Clear();
        _Execute(VisualSections.List);
        cbSource.SelectedIndex = -1;

        var context = _DTContext<CommonContext>(true);
        var sources = context.Cars.Select(c => c.Source).OrderBy(d => d).Distinct().ToList();
        cbSource.FromList(sources, (d, i) =>
        {
            i.Text = d;
            i.Value = d;
            return true;
        });
        tbInput.Focus();
    }

    protected override void _Execute(string section)
    {
        if (section == VisualSections.List)
        {
            gw.Execute(_List, b => b
                .Do<Literal>("Id", (c, d) => { c.Text = d.Id; })
                .Do<Literal>("PlateNumber", (c, d) => { c.Text = d.PlateNumber; })
                .Do<Literal>("Source", (c, d) => { c.Text = d.Source; })
                .Do<ASPxTextBox>("FormerPlateNum", (c, d) => c.Text = d.FormerPlateNum)
                .Do<ASPxTextBox>("Manufacturer", (c, d) => c.Text = d.Manufacturer)
                .Do<ASPxTextBox>("Model", (c, d) => c.Text = d.Model)
                .Do<ASPxComboBox>("Type", (c, d) => c.Value = d.Type.ToStringEx())
                .Do<ASPxTextBox>("Source", (c, d) => c.Text = d.Source)
                .Do<ASPxTimeEdit>("HandOverTime", (c, d) => c.Value = d.HandOverTime)
                .Do<ASPxTextBox>("HandOverPlace", (c, d) => c.Text = d.HandOverPlace)
                .Do<ASPxTextBox>("Fleet", (c, d) => c.Text = d.Fleet)
                .Do<ASPxTextBox>("Remark", (c, d) => c.Text = d.Remark)
            );

            at.Visible = _List.Count > 0;
            return;
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Select)
        {
            if (string.IsNullOrEmpty(subSection))
            {
                _Do_Select();
            }
            else
            {
                _Do_SelectBySource();
            }
        }
        if (section == Actions.Save) _Do_Save();
    }

    private void _Do_Save()
    {
        if (_List.Count == 0) return;
        _Do_Collect();

        var context = _DTService.Context;
        _List.ForEach(d =>
        {
            context.Update<TB_car>(_SessionEx, c => c.Id == d.Id, car =>
            {
                car.FormerPlateNum = d.FormerPlateNum;
                car.Manufacturer = d.Manufacturer;
                car.Model = d.Model;
                car.Type = d.Type;
                car.Source = d.Source;
                car.HandOverTime = d.HandOverTime;
                car.HandOverPlace = d.HandOverPlace;
                car.Fleet = d.Fleet;
                car.Remark = d.Remark;
            });
        });
        context.SubmitChanges();
    }

    private void _Do_Select()
    {
        _Do_Collect();
        _CarIds.ForEach(id =>
        {
            if (_List.Any(l => l.Id == id)) return;
            var context = _DTContext<CommonContext>(true);
            context.Cars.SingleOrDefault(c => c.Id == id).IfNN(c => _List.Add(c));
        });

            // 排序
        _List = _List.OrderBy(d => d.PlateNumber).ToList();
    }

    private void _Do_SelectBySource()
    {
        _Do_Collect();
        var context = _DTContext<CommonContext>(true);
        var source = cbSource.Value.ToStringEx();
        var cars = (
            from o in context.Cars
            where o.Source == source
            select o).ToList();
        cars.ForEach(o =>
        {
            if (!
                _List.Any(l => l.Id == o.Id))
                _List.Add(o);
        });

        // 排序
        _List = _List.OrderBy(d => d.PlateNumber).ToList();

    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxTextBox>("FormerPlateNum", (d, c) => d.FormerPlateNum = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Manufacturer", (d, c) => d.Manufacturer = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Model", (d, c) => d.Model = c.Value.ToStringEx())
            .Do<ASPxComboBox>("Type", (d, c) => d.Type = c.Value.ToStringEx().ToIntOrDefault(-1))
            .Do<ASPxTextBox>("Source", (d, c) => d.Source = c.Value.ToStringEx())
            .Do<ASPxTimeEdit>("HandOverTime", (d, c) =>
            {
                d.HandOverTime = null;
                if (!string.IsNullOrEmpty(c.Value.ToStringEx()))
                {
                    d.HandOverTime =
                        new DateTime(2000, 1,1).Add(((DateTime)c.Value).TimeOfDay);
                }
            })
            .Do<ASPxTextBox>("HandOverPlace", (d, c) => d.HandOverPlace = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Fleet", (d, c) => d.Fleet = c.Value.ToStringEx())
            .Do<ASPxTextBox>("Remark", (d, c) => d.Remark = c.Value.ToStringEx())
        );
    }

</script>

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
    <div class="inner" style="padding:10px;">
        <table style="border-spacing:0px;">
            <tr>
                <td style="padding-right:10px;">
                    请填入车牌号（然后回车）：
                </td>
                <td>
                    <dx:ASPxTextBox runat="server" ID="tbInput" Width="100" />
                </td>
                <td style="padding-left:10px;">
                    或者：
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
                <td style="padding-left:10px;">
                    或者：
                </td>
                <td>
                    <dx:ASPxButton runat="server" Text="在列表中选择车辆" ID="bSelect">
                        <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
                        <Image Url="~/images/_doc_16_workflowtemplate.gif" />
                    </dx:ASPxButton>
                </td>
                <td style="padding-left:10px;">
                    <dx:ASPxButton runat="server" Text="重来" ID="bReset">
                        <ClientSideEvents Click="function(s,e){e.processOnServer=confirm('确定清除数据重新选择吗？');}" />
                        <Image Url="~/images/_op_flatb_back.gif" />
                    </dx:ASPxButton>
                </td>
            </tr>
        </table>
    </div>
</div>
<div style="padding:10px;">
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

    public override string ModuleId { get { return Business.Replace_Batch; } }
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
            cbSource.SelectedIndex = -1;
            Execute(VisualSections.List);
            tbInput.Focus();
            cbSource.SelectedIndex = -1;
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
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("Source", "获得方式", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("EngineNum", "发动机号", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 150;
            }), f =>
            {
                f.HeaderStyle.Width = 150;
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("CarriageNum", "车架号", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 150;
                fh.Validate(e).IsRequired();
            }), f =>
            {
                f.HeaderStyle.Width = 150;
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("Manufacturer", "车辆品牌", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 150;
                fh.Validate(e).IsRequired();
            }), f =>
            {
                f.HeaderStyle.Width = 150;
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("Model", "车辆型号", new TemplateItem.DXTextBox(e =>
            {
                e.Width = 150;
            }), f =>
            {
                f.HeaderStyle.Width = 150;
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
        );

        cbSource.SelectedIndexChanged += (s, e) =>
        {
            if (Do(Actions.Select, "source", false)) Execute(VisualSections.List);
        };
    }

    protected override void _Execute()
    {
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
                .Do<Literal>("PlateNumber", (c, d) => { c.Text = d.PlateNumber; })
                .Do<Literal>("Source", (c, d) => { c.Text = d.Source; })
                .Do<ASPxTextBox>("EngineNum", (c, d) => { c.Text = d.EngineNum; })
                .Do<ASPxTextBox>("CarriageNum", (c, d) => { c.Text = d.CarriageNum; })
                .Do<ASPxTextBox>("Manufacturer", (c, d) => { c.Text = d.Manufacturer; })
                .Do<ASPxTextBox>("Model", (c, d) => { c.Text = d.Model; })
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
        var carIds = _List.Select(d => d.Id).ToArray();
        var context = _DTService.Context;
        var cars = context.Cars.Where(c => carIds.Contains(c.Id)).ToList();
        _Do_Collect();
        _List.ForEach(d =>
        {
            cars.SingleOrDefault(o => o.Id == d.Id).IfNN(o =>
            {
                var changed =
                    o.EngineNum != d.EngineNum ||
                    o.CarriageNum != d.CarriageNum ||
                    o.Manufacturer != d.Manufacturer ||
                    o.Model != d.Model;
                if (changed) context.Create<TB_car_replace>(_SessionEx, replace =>
                {
                    replace.CarId = o.Id;
                    replace.Id = context.NewSequence<TB_car_replace>(_SessionEx);
                    replace.EngineNum = o.EngineNum;
                    replace.CarriageNum = o.CarriageNum;
                    replace.Manufacturer = o.Manufacturer;
                    replace.Model = o.Model;
                });
                o.EngineNum = d.EngineNum;
                o.CarriageNum = d.CarriageNum;
                o.Manufacturer = d.Manufacturer;
                o.Model = d.Model;
            });
        });
        context.SubmitChanges();
    }

    private void _Do_Select()
    {
        _Do_Collect();
        var context = _DTContext<CommonContext>(true);
        var cars = (
            from o in context.Cars
            where _CarIds.Contains(o.Id)
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

    protected void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxTextBox>("EngineNum", (d, c) => d.EngineNum = c.Text)
            .Do<ASPxTextBox>("CarriageNum", (d, c) => d.CarriageNum = c.Text)
            .Do<ASPxTextBox>("Manufacturer", (d, c) => d.Manufacturer = c.Text)
            .Do<ASPxTextBox>("Model", (d, c) => d.Model = c.Text)
        );
    }

</script>

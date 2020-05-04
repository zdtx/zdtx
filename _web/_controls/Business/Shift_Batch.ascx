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

    private List<TB_car_rental_shift> _List
    {
        get { return _ViewStateEx.Get<List<TB_car_rental_shift>>(DataStates.List, new List<TB_car_rental_shift>()); }
        set { _ViewStateEx.Set<List<TB_car_rental_shift>>(value, DataStates.List); }
    }

    private string[] _CarIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    private string _CarId
    {
        set { _ViewStateEx.Set<string>(value, "carId"); }
        get { return _ViewStateEx.Get<string>("carId", null); }
    }

    private string _DriverId
    {
        set { _ViewStateEx.Set<string>(value, "driverId"); }
        get { return _ViewStateEx.Get<string>("driverId", null); }
    }

    private string _Id
    {
        set { _ViewStateEx.Set<string>(value, "shiftId"); }
        get { return _ViewStateEx.Get<string>("shiftId", null); }
    }

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Business.Violation_Batch; } }
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
            .TemplateField("Ids", string.Empty, new TemplateItem.PlaceHolder(h =>
            {
                h.Controls.Add(new Literal() { ID = "CarId" });
                h.Controls.Add(new Literal() { ID = "DriverId" });
                h.Controls.Add(new Literal() { ID = "Id" });
            }), f =>
            {
                f.Visible = false;
            })
            .TemplateField("PlateNumber", "车牌号", new TemplateItem.Literal(l =>
            {
            }), f =>
            {
            })
            .TemplateField("DriverName", "正班司机", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("SubDriverName", "代班司机", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 90;
            })
            .TemplateField("Reason", "代班原因", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("StartTime", "开始", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
            })
            .TemplateField("EndTime", "结束", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 130;
            })
            .TemplateField("ed1", string.Empty, new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.CommandName = "ed1";
                l.OnClientClick = "ISEx.loadingPanel.show();";
            }), f =>
            {
                f.ItemStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            })
            .TemplateField("ed2", string.Empty, new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.CommandName = "ed2";
                l.OnClientClick = "ISEx.loadingPanel.show();";
            }), f =>
            {
                f.ItemStyle.Width = 30;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            })
        );

        gv.RowCommand += (s, e) =>
        {
            if (e.CommandName != "ed1" && e.CommandName != "ed2") return;
            var rowIndex = e.CommandArgument.ToStringEx().ToIntOrDefault();
            var v = new GridWrapper.RowVisitor(gv.Rows[rowIndex]);
            v.Get<Literal>("CarId", carL => v.Get<Literal>("DriverId", driverL => v.Get<Literal>("Id", idL =>
            {
                _CarId = carL.Text;
                _DriverId = driverL.Text;
                _Id = idL.Text;
                switch (e.CommandName)
                {
                    case "ed1":
                        if (Do("1", true))
                            Execute(VisualSections.List);
                        break;
                    case "ed2":
                        if (Do("2", true))
                            Execute(VisualSections.List);
                        break;
                }
            })));
        };
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
            var list = (
                from s in context.CarRentalShifts
                join c in context.Cars on s.CarId equals c.Id
                join d in context.Drivers on s.DriverId equals d.Id
                join x in context.Drivers on s.SubDriverId equals x.Id
                where carIds.Contains(s.CarId) && s.IsActive
                select new
                {
                    c.PlateNumber,
                    DriverName = d.Name,
                    SubDriverName = x.Name,
                    s.CarId,
                    s.DriverId,
                    s.Id,
                    s.Time,
                    s.Reason,
                    s.StartTime,
                    s.EndTime,
                    s.SubDriverId,
                    s.IsActive,
                    s.ConfirmedDays,
                    s.ActualEndTime,
                    s.Remark
                }).ToList();

            var data = (
                from l in _List
                join d in list on
                    new { l.CarId, l.DriverId, l.Id } equals new { d.CarId, d.DriverId, d.Id }
                select new
                {
                    d.PlateNumber,
                    d.DriverName,
                    d.SubDriverName,
                    d.CarId,
                    d.DriverId,
                    d.Id,
                    d.SubDriverId,
                    d.Time,
                    d.Reason,
                    d.StartTime,
                    d.EndTime,
                }).ToList();

            gw.Execute(data, b => b
                .Do<Literal>("CarId", (c, d) => c.Text = d.CarId)
                .Do<Literal>("DriverId", (c, d) => c.Text = d.DriverId)
                .Do<Literal>("Id", (c, d) => c.Text = d.Id)
                .Do<Literal>("PlateNumber", (c, d) => c.Text = d.PlateNumber)
                .Do<Literal>("DriverName", (c, d) => c.Text = d.DriverName)
                .Do<Literal>("SubDriverName", (c, d) => c.Text = d.SubDriverName)
                .Do<Literal>("Reason", (c, d) => c.Text = d.Reason)
                .Do<Literal>("StartTime", (c, d) => c.Text = d.StartTime.ToISDate())
                .Do<Literal>("EndTime", (c, d) => c.Text = d.EndTime.ToISDate())
                .Do<Literal>("Time", (c, d) => c.Text = d.Time.ToISDate())
                .Do<LinkButton>("ed1", (ll, d, rr) =>
                {
                    ll.Text = "按计划时间结束代班";
                    ll.CommandArgument = rr.RowIndex.ToString();
                    ll.OnClientClick = string.Format("return confirm('代班结束时间为：{0}');", d.EndTime.ToISDate());
                })
                .Do<LinkButton>("ed2", (ll, d, rr) =>
                {
                    ll.Text = "按今天结束代班";
                    ll.CommandArgument = rr.RowIndex.ToString();
                    ll.OnClientClick = string.Format("return confirm('代班结束时间为（今天）：{0}');", _CurrentTime.Date.ToISDate());
                })
            );

            at.Visible = data.Count > 0;
            return;
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != "1" && section != "2" && section != Actions.Select)
            return;
        if (section == Actions.Select)
            _Do_Select();
        if (section == "1")
            _Do_1();
        if (section == "2")
            _Do_2();
    }

    private void _Do_1()
    {
        var context = _DTService.Context;
        context
            .Update<TB_car_rental_shift>(_SessionEx,
                s => s.CarId == _CarId && s.DriverId == _DriverId && s.Id == _Id, shift =>
                {
                    shift.ActualEndTime = shift.EndTime;
                    shift.ConfirmedDays = (int)shift.EndTime.Subtract(shift.StartTime).TotalDays;
                    shift.IsActive = false;
                })
            .SubmitChanges();
    }

    private void _Do_2()
    {
        var context = _DTService.Context;
        context
            .Update<TB_car_rental_shift>(_SessionEx,
                s => s.CarId == _CarId && s.DriverId == _DriverId && s.Id == _Id, shift =>
                {
                    shift.ActualEndTime = _CurrentTime.Date;
                    shift.ConfirmedDays = (int)shift.EndTime.Subtract(shift.StartTime).TotalDays;
                    shift.IsActive = false;
                })
            .SubmitChanges();
    }

    private void _Do_Select()
    {
        var context = _DTContext<CommonContext>(true);
        var activeShifts = (
            from s in context.CarRentalShifts
            where _CarIds.Contains(s.CarId) && s.IsActive
            select s).ToList();
        _CarIds.ForEach(id =>
        {
            var shifts = activeShifts.Where(s => s.CarId == id).ToList();
            if (shifts.Count == 0)
            {
                Alert("您选择的车辆不存在代班");
            }
            else
            {
                shifts.ForEach(s =>
                {
                    if (!
                        _List.Any(l => l.CarId == s.CarId && l.DriverId == s.DriverId && l.Id == s.Id))
                        _List.Add(s);
                });
            }
        });
    }

</script>

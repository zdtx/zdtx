<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/GridWrapperForList.ascx" TagPrefix="uc1" TagName="GridWrapperForList" %>
<uc1:Popup_DX runat="server" ID="pop" />
<uc1:GridWrapperForList runat="server" ID="gw" />
<asp:GridView runat="server" ID="gv" Width="100%">
    <SelectedRowStyle CssClass="gridRow-selected" />
    <HeaderStyle CssClass="gridHeader" />
</asp:GridView>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    private string _DriverId
    {
        set { _ViewStateEx.Set<string>(value, "driverId"); }
        get { return _ViewStateEx.Get<string>("driverId", null); }
    }

    public override string ModuleId { get { return Car.Rental_List; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, c => c
            .TemplateField("DriverId", "DriverId", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Ordinal", "Ordinal", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("PlateNumber", "车牌号", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
            })
            .TemplateField("Name", "司机", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 80;
            })
            .TemplateField("CHNId", "身份证号", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("StartTime", "生效时间", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Rental", "租金/管理费", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("Extra1", "社保", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            })
            .TemplateField("IsProbation", "是否试用", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 200;
            })
            .TemplateField("ed", string.Empty, new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.CommandName = "ed";
                l.OnClientClick = "ISEx.loadingPanel.show();";
            }), f =>
            {
                f.ItemStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("dl", string.Empty, new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.CommandName = "dl";
                l.OnClientClick = "ISEx.loadingPanel.show();";
            }), f =>
            {
                f.ItemStyle.Width = 30;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Wrap = false;
            })
            .TemplateField("", "备注", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
            })
            , showFooter: false, mode: GridWrapper.SelectionMode.Single
        );

        gv.RowCommand += (s, e) =>
        {
            if (e.CommandName != "ed" && e.CommandName != "dl") return;
            var rowIndex = e.CommandArgument.ToStringEx().ToIntOrDefault();
            var v = new GridWrapper.RowVisitor(gv.Rows[rowIndex]);
            v.Get<Label>("DriverId", l =>
            {
                switch (e.CommandName)
                {
                    case "ed":
                        pop.Begin<BaseControl>("~/_controls/car/rental_create.ascx",
                            null, c =>
                            {
                                if (string.IsNullOrEmpty(l.Text))
                                {
                                    c
                                        .Import(true, DataStates.IsCreating)
                                        .Import(_ObjectId, "CarId")
                                        .Execute();
                                }
                                else
                                {
                                    c
                                        .Import(false, DataStates.IsCreating)
                                        .Import(_ObjectId, "CarId")
                                        .Import(l.Text, "DriverId")
                                        .Execute();
                                }
                            }, c =>
                            {
                                c
                                    .Width(550)
                                    .Height(450)
                                    .Title(string.IsNullOrEmpty(l.Text) ? "加入司机" : "更换司机")
                                    .Button(BaseControl.EventTypes.Save, b => b.CausesValidation = true)
                                ;
                            });
                        break;
                    case "dl":
                        _DriverId = l.Text;
                        if(Do(Actions.Delete, true))
                        {
                            Alert("保存成功");
                            Execute();
                        }
                        break;
                }
            });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            if (c.ModuleId == Car.Rental_Create)
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Save:
                        if (c.Do(Actions.Save, true))
                        {
                            Alert("保存成功。");
                            pop.Close();
                            Execute();
                        }
                        break;
                }
            }
        };

    }

    protected override void _Execute()
    {
        gv.Visible = !string.IsNullOrEmpty(_ObjectId);
        var context = _DTContext<CommonContext>(true);
        var rentals = (
            from r in context.CarRentals
            join c in context.Cars on r.CarId equals c.Id
            join d in context.Drivers on r.DriverId equals d.Id
            where r.CarId == _ObjectId
            orderby r.Ordinal
            select new
            {
                r.CarId,
                c.PlateNumber,
                r.DriverId,
                r.Rental,
                r.StartTime,
                r.IsProbation,
                r.ProbationExpiryDate,
                r.Ordinal,
                r.Remark,
                d.Name,
                d.CHNId,
                d.Gender,
                d.DayOfBirth
            }).ToList();
        var count = (rentals.Count > 2 ? rentals.Count : 2) - 1;
        gw.Execute(count.ToList(), b => b
            .Do<Label>("DriverId", (l, i) =>
            {
                l.Text = string.Empty;
                if (i < rentals.Count)
                {
                    // 有记录
                    var r = rentals[i];
                    l.Text = r.DriverId;
                    b
                        .Do<Literal>("PlateNumber", (ll, d) => ll.Text = r.PlateNumber)
                        .Do<Label>("Ordinal", (ll, d) => ll.Text = r.Ordinal.ToString())
                        .Do<Label>("Name", (ll, d) => ll.Text = r.Name)
                        .Do<Label>("CHNId", (ll, d) => ll.Text = r.CHNId)
                        .Do<Label>("StartTime", (ll, d) => ll.Text = r.StartTime.ToISDate())
                        .Do<Label>("Rental", (ll, d) => ll.Text = r.Rental.ToStringOrEmpty(comma: true))
                        .Do<Label>("IsProbation", (ll, d) =>
                        {
                            if (r.IsProbation)
                            {
                                ll.Text = "试用中";
                                if (r.ProbationExpiryDate.HasValue)
                                    ll.Text += "，至 " + r.ProbationExpiryDate.Value.ToISDate();
                            }
                            else
                            {
                                ll.Text = "长期";
                            }
                        })
                        .Do<Label>("Remark", (ll, d) => ll.Text = r.Remark)
                        .Do<LinkButton>("ed", (ll, d, rr) =>
                        {
                            ll.Text = "更改司机";
                            ll.ToolTip = "将当前司机作离岗结算，并换另一个司机驾驶此班";
                            ll.CommandArgument = rr.RowIndex.ToString();
                        })
                        .Do<LinkButton>("dl", (ll, d, rr) =>
                        {
                            ll.Text = "解除绑定";
                            ll.ToolTip = "司机离岗，做解除绑定操作后，此班将空缺";
                            ll.CommandArgument = rr.RowIndex.ToString();
                            ll.OnClientClick = "return confirm('确定解除吗？');";
                        })
                        ;
                }
                else
                {
                    // 空闲填报
                    b
                        .Do<Label>("Ordinal", (ll, d) => ll.Text = i.ToString())
                        .Do<Label>("Name", (ll, d) => ll.Text = "（空缺）")
                        .Do<Label>("CHNId", (ll, d) => ll.Text = " - ")
                        .Do<Label>("StartTime", (ll, d) => ll.Text = " - ")
                        .Do<Label>("Rental", (ll, d) => ll.Text = " - ")
                        .Do<Label>("IsProbation", (ll, d) => ll.Text = " - ")
                        .Do<Label>("Remark", (ll, d) => ll.Text = " - ")
                        .Do<LinkButton>("ed", (ll, d, rr) =>
                        {
                            ll.Text = "加入司机";
                            ll.ToolTip = "加入一个司机驾驶此班";
                            ll.CommandArgument = rr.RowIndex.ToString();
                        })
                        .Do<LinkButton>("dl", (ll, d) =>
                        {
                            ll.Visible = false;
                        })
                        ;
                }
            })
        );
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Delete) _Do_Delete();
    }

    private void _Do_Delete()
    {
        var context = _DTService.Context;
        var rental = context.CarRentals
            .SingleOrDefault(r => r.CarId == _ObjectId && r.DriverId == _DriverId);
        context
            .Create<TB_car_rental_history>(_SessionEx, h =>
            {
                var newId = context.NewSequence<TB_car_rental_history>(_SessionEx);
                h.CarId = _ObjectId;
                h.DriverId = _DriverId;
                h.Id = newId;
                h.Rental = rental.Rental;
                h.Extra1 = rental.Extra1;
                h.Extra2 = rental.Extra2;
                h.Extra3 = rental.Extra3;
                h.StartTime = rental.StartTime;
                h.EndTime = _CurrentTime.Date;
            })
            .DeleteAll<TB_car_rental>(r => r.CarId == _ObjectId && r.DriverId == _DriverId)
            .Update<TB_driver>(_SessionEx, o => o.Id == _DriverId, o => o.Tel2 = "1")
            .SubmitChanges();
    }

</script>

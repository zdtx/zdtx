<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/GridWrapperForDetail.ascx" TagPrefix="uc1" TagName="GridWrapperForDetail" %>
<uc1:FormHelper runat="server" ID="fh" />
<div class="title" style="margin-top:8px;">
    <asp:Literal runat="server" ID="lHeader" />
</div>
<uc1:GridWrapperForDetail runat="server" ID="gw" />
<asp:GridView runat="server" ID="gvv" Width="100%">
    <SelectedRowStyle CssClass="gridRow-selected" />
    <HeaderStyle CssClass="gridHeader" />
    <FooterStyle HorizontalAlign="Right" CssClass="gridFooter" />
</asp:GridView>
<div class="actionTB" style="padding-top:2px;">
    <table>
        <tr>
            <td>
                <dx:ASPxButton runat="server" ID="bFill" Text="已收讫">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_doc_16_position.gif" />
                </dx:ASPxButton>
            </td>
        </tr>
    </table>
</div>
<script runat="server">

    private List<TB_car_payment_item> _List
    {
        get { return _ViewStateEx.Get<List<TB_car_payment_item>>(DataStates.List, new List<TB_car_payment_item>()); }
        set { _ViewStateEx.Set<List<TB_car_payment_item>>(value, DataStates.List); }
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

    private string _MonthIndex
    {
        set { _ViewStateEx.Set<string>(value, "monthIndex"); }
        get { return _ViewStateEx.Get<string>("monthIndex", null); }
    }

    public override string ModuleId { get { return Car.Payment_Items_Update; } }
    protected override void _SetInitialStates()
    {
        gw.Initialize(gvv, c => c
            .TemplateField("Ordinal", "Ordinal", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Code", "编号", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("Name", "名称", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("IsNegative", "类型", new TemplateItem.Literal(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.Width = 50;
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;

            }, GridWrapper.FooterType.Label)

            .TemplateField("Amount", "金额", new TemplateItem.DXSpinEdit(f =>
            {
                f.MinValue = 0;
                f.Width = 100;
                f.HorizontalAlign = HorizontalAlign.Right;
                f.SpinButtons.ShowIncrementButtons = false;
                f.MinValue = 0;
                f.ValidationSettings.ValidateOnLeave = true;

            }), footer: GridWrapper.FooterType.Label)

            .TemplateField("Paid", "已付（绝对金额）", new TemplateItem.DXSpinEdit(f =>
            {
                f.MinValue = 0;
                f.Width = 100;
                f.HorizontalAlign = HorizontalAlign.Right;
                f.SpinButtons.ShowIncrementButtons = false;
                f.MinValue = 0;
                f.ValidationSettings.ValidateOnLeave = true;

            }))

            .TemplateField("Remark", "备注：收款日期", new TemplateItem.DXTextBox(f =>
            {
                f.Width = 260;

            }), f =>
            {
            })

            , showFooter: true
        );

        bFill.Click += (s, e) =>
        {
            _List.ForEach(d => d.Paid = d.Amount);
            _BindData();
        };

    }

    protected override void _PrepareData()
    {
        var context = _DTContext<CommonContext>(true);

        var header =
            from p in context.CarPayments
            join d in context.Drivers on p.DriverId equals d.Id
            join c in context.Cars on p.CarId equals c.Id
            select new
            {
                d.Name,
                d.CHNId,
                p.MonthIndex,
                c.PlateNumber
            };

        header.FirstOrDefault().IfNN(h =>
        {
            lHeader.Text = string.Format("{0}[{1}] - 车：{2} - {3} 结单", h.Name, h.CHNId, h.PlateNumber, h.MonthIndex);
        });

        _List = (
            from i in context.CarPaymentItems
            where i.CarId == _CarId && i.DriverId == _DriverId && i.MonthIndex == _MonthIndex
            orderby i.Code
            select i
            ).ToList();
    }

    protected override void _BindData()
    {
        gw.Execute(_List, b => b
            .Do<Literal>("Code", (c, d) =>
            {
                c.Text = d.Code;
            })
            .Do<Literal>("Name", (c, d) =>
            {
                c.Text = d.Name;
            })
            .Do<Literal>("IsNegative", (c, d) =>
            {
                c.Text = d.IsNegative ? "付" : "收";
            })
            .Do<ASPxSpinEdit>("Amount", (c, d) => { c.Number = d.Amount.ToCHNRounded(); })
            .Do<ASPxSpinEdit>("Paid", (c, d) => { c.Number = d.Paid.ToCHNRounded(); })
            .Do<ASPxTextBox>("Remark", (c, d) => { c.Text = d.Remark; })

            ,

            f => f

            .Do<Label>("IsNegative", c => c.Text = "合计：")
            .Do<Label>("Amount", c =>
            {
                var sum = -1 * _List.Sum(i => i.IsNegative ? -1 * i.Amount : i.Amount);
                c.Text = sum.ToStringOrEmpty(comma: true, emptyValue: " - ", alwaysDisplaySign: true);
                c.ColorizeNumber(sum, s => s > 0, s => s == 0);
            })

        );
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Save) _Do_Save();
    }

    private void _Do_Save()
    {
        if (_List.Count == 0) return;

        _Do_Collect();

        var context = _DTService.Context;
        var payment = context.CarPayments
            .FirstOrDefault(p => p.CarId == _CarId && p.DriverId == _DriverId && p.MonthIndex == _MonthIndex);
        var paymentItems = context.CarPaymentItems
            .Where(i => i.CarId == _CarId && i.DriverId == _DriverId && i.MonthIndex == _MonthIndex)
            .ToList();

        _List.ForEach(d =>
        {
            paymentItems
                .SingleOrDefault(i => i.ChargeId == d.ChargeId)
                .IfNN(i =>
                {
                    i.Amount = Math.Abs(d.Amount);
                    i.Paid = Math.Abs(d.Paid);
                    i.Remark = d.Remark;
                });
        });

        if (payment != null)
        {
            payment.Amount = paymentItems.Sum(i => i.Amount);
            payment.Paid = paymentItems.Sum(i => i.Paid);
            payment.ClosingBalance = payment.Paid - (payment.Amount - payment.OpeningBalance ?? 0m);
        }

        context.SubmitChanges();

        //_DTService.UpdatePayment(_CarId, _DriverId, _MonthIndex);

    }

    private void _Do_Collect()
    {
        gw.Syn(_List, col => col
            .Do<ASPxSpinEdit>("Amount", (d, c) => d.Amount = c.Number)
            .Do<ASPxSpinEdit>("Paid", (d, c) => d.Paid = c.Number)
            .Do<ASPxTextBox>("Remark", (d, c) => d.Remark = c.Value.ToStringEx())
        );
    }

</script>

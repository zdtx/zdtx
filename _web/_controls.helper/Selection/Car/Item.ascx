<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Item.ascx.cs" Inherits="eTaxi.Web.Controls.Selection.Car.Item" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<%@ Register Src="~/_controls.helper/PagingToolbar.ascx" TagPrefix="uc1" TagName="PagingToolbar" %>
<asp:Panel runat="server" ID="pT" CssClass="filterTb">
    <div class="inner">
        <table>
            <tr>
                <td class="name">车牌号：
                </td>
                <td class="cl">
                    <dx:ASPxTextBox runat="server" ID="tb_PlateNumber" Width="100" />
                </td>
                <td class="name">单位：
                </td>
                <td class="cl">
                    <dx:ASPxTextBox runat="server" ID="tb_Company" Width="100" />
                </td>
                <td class="name">
                    选择车辆来源：
                </td>
                <td>
                    <dx:ASPxComboBox runat="server" ID="cb_Source" AutoPostBack="true" Width="150">
                        <ClientSideEvents
                            SelectedIndexChanged="function(s,e){ISEx.loadingPanel.show();}" /> 
                    </dx:ASPxComboBox>
                </td>
            </tr>
            <tr>
                <td class="name">原车牌号：
                </td>
                <td class="cl">
                    <dx:ASPxTextBox runat="server" ID="tb_FormerPlateNumber" Width="100" />
                </td>
                <td class="name">性质：
                </td>
                <td class="cl">
                    <dx:ASPxComboBox runat="server" ID="cb_Type" Width="100" />
                </td>
                <td class="btn">
                    <dx:ASPxButton ID="bSearch" runat="server" Text="查找">
                        <Image Url="~/images/_op_flatb_search.gif" />
                    </dx:ASPxButton>
                </td>
            </tr>
        </table>
    </div>
</asp:Panel>
<div style="margin-top: 1px;">
    <uc1:DXGridWrapper runat="server" ID="gw" />
    <dx:ASPxGridView ID="gv" runat="server" KeyFieldName="Id" Width="100%">
        <Columns>
            <dx:GridViewDataColumn FieldName="Id" Visible="false" />
            <dx:GridViewDataColumn FieldName="PlateNumber" Caption="车牌号" Width="90" VisibleIndex="3" />
            <dx:GridViewDataColumn FieldName="Source" Caption="来源" Width="120" VisibleIndex="6" />
            <dx:GridViewDataColumn FieldName="Type" Caption="性质" Width="60" VisibleIndex="8" />
            <dx:GridViewDataColumn FieldName="ModifyTime" Caption="最后更新" Width="90" VisibleIndex="11">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" Wrap="False" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Company" Caption="单位" VisibleIndex="12" />
        </Columns>
        <SettingsBehavior AllowFocusedRow="false" AllowSelectSingleRowOnly="true" />
    </dx:ASPxGridView>
</div>
<div class="darkBar">
    <uc1:PagingToolbar runat="server" ID="pg" />
</div>
<script runat="server">

    protected override void _SetInitialStates()
    {
        gw.Initialize(gv, d =>
        {
            d
                .ShowRowNumber()
            ;
        });

        gw.RowDblClick += (s, e) => { SinkEvent(EventTypes.OK, string.Empty); };
        gv.SortBy(gv.Columns["PlateNumber"], DevExpress.Data.ColumnSortOrder.Ascending);
        gv.BeforeColumnSortingGrouping += (s, e) => { Execute(); };
        gv.CustomColumnDisplayText += (s, e) =>
        {
            switch (e.Column.FieldName)
            {
                case "Type":
                    _Util.Convert<CarType>(e.Value, d => e.DisplayText = DefinitionHelper.Caption(d));
                    break;
                case "ModifyTime":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDate());
                    break;
                case "DepartmentId":
                    e.DisplayText = Global.Cache.GetDepartment(d => d.Id == e.Value.ToStringEx()).Name;
                    break;
            }
        };

        pg.SetDefaultPageSizeIndex(5);
        pg.Reload += (s, e) => { Execute(); };

        cb_Type.FromEnum<CarType>(valueAsInteger: true);
        bSearch.Click += (s, e) => { pg.Index = 0; Execute(); };

    }

    public override List<TB_car> Selection
    {
        get
        {
            var result = new List<TB_car>();
            if (gv.Selection.Count == 0) return result;
            var values = gv.GetSelectedFieldValues("Id", "PlateNumber");
            values.ForEach(v =>
            {
                var vs = (object[])v;
                result.Add(new TB_car()
                {
                    Id = vs[0].ToString(),
                    PlateNumber = vs[1].ToString()
                });
            });
            return result;
        }
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        if (cb_Source.Items.Count == 0)
        {
            var sources = context.Cars.Select(c => c.Source).OrderBy(d => d).Distinct().ToList();
            cb_Source.FromList(sources, (d, i) =>
            {
                i.Text = d;
                i.Value = d;
                return true;
            });
        }

        var exp = PredicateBuilder.True<TB_car>();
        exp = exp.Append(tb_PlateNumber.Text, v => exp.And(e => e.PlateNumber.Contains(v)));
        exp = exp.Append(tb_FormerPlateNumber.Text, v => exp.And(e => e.FormerPlateNum.Contains(v)));
        exp = exp.Append(tb_Company.Text, v => exp.And(e => e.Company.Contains(v)));
        exp = exp.Append(cb_Type.Value.ToStringEx().ToIntOrNull(), v => exp.And(e => e.Type == v.Value));
        exp = exp.Append(cb_Source.Value.ToStringEx(), v => exp.And(e => e.Source == v));

        var q =
            from o in context.Cars.Where(exp)
            select new
            {
                o.Id,
                o.PlateNumber,
                o.FormerPlateNum,
                o.Company,
                o.Model,
                o.Type,
                o.Source,
                o.EngineNum,
                o.CarriageNum,
                o.SecSerialNum,
                o.License,
                o.DrvLicense,
                o.DepartmentId,
                o.ModifiedById,
                o.ModifyTime,
                o.Remark
            };

        q = gv.ApplySorts(q);

        gv.DataSource = q.Skip(pg.Skip).Take(pg.Size ?? 100).ToList();
        gv.DataBind();
        gv.Selection.UnselectAll();

        pg.Total = q.Count();
        pg.Execute();
    }

</script>

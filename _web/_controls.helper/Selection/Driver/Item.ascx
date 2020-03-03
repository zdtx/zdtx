<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Item.ascx.cs" Inherits="eTaxi.Web.Controls.Selection.Driver.Item" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<%@ Register Src="~/_controls.helper/PagingToolbar.ascx" TagPrefix="uc1" TagName="PagingToolbar" %>
<asp:Panel runat="server" ID="pT" CssClass="filterTb">
    <div class="inner">
        <table>
            <tr>
                <td class="name">姓名：
                </td>
                <td class="cl">
                    <dx:ASPxTextBox runat="server" ID="tb_Name" Width="100" />
                </td>
                <td class="name">姓：
                </td>
                <td class="cl">
                    <dx:ASPxTextBox runat="server" ID="tb_LastName" Width="100" />
                </td>
                <td>
                </td>
                <td>
                </td>
                <td rowspan="2" class="btn">
                    <dx:ASPxButton ID="bSearch" runat="server" Text="查找">
                        <Image Url="~/images/_op_flatb_search.gif" />
                    </dx:ASPxButton>
                </td>
            </tr>
            <tr>
                <td class="name">资格证号：
                </td>
                <td class="cl">
                    <dx:ASPxTextBox runat="server" ID="tb_CertNumber" Width="100" />
                </td>
                <td class="name">名：
                </td>
                <td class="cl">
                    <dx:ASPxTextBox runat="server" ID="tb_FirstName" Width="100" />
                </td>
                <td class="name">性别：
                </td>
                <td class="cl">
                    <dx:ASPxComboBox runat="server" ID="cb_Gender" Width="100" />
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
            <dx:GridViewDataColumn FieldName="Name" Caption="姓名" Width="80" VisibleIndex="3" />
            <dx:GridViewDataColumn FieldName="Gender" Caption="性别" Width="50" VisibleIndex="4" />
            <dx:GridViewDataColumn FieldName="DayOfBirth" Caption="出生年月" Width="120" VisibleIndex="5" />
            <dx:GridViewDataColumn FieldName="CHNId" Caption="身份证" Width="200" VisibleIndex="6" />
            <dx:GridViewDataColumn FieldName="ModifyTime" Caption="最后更新" Width="130" VisibleIndex="10">
                <HeaderStyle HorizontalAlign="Center" />
                <CellStyle HorizontalAlign="Center" />
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="Remark" Caption="备注" VisibleIndex="11" />
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
        gv.SortBy(gv.Columns["Name"], DevExpress.Data.ColumnSortOrder.Ascending);
        gv.BeforeColumnSortingGrouping += (s, e) => { Execute(); };
        gv.CustomColumnDisplayText += (s, e) =>
        {
            switch (e.Column.FieldName)
            {
                case "Gender":
                    e.DisplayText = "(未知)";
                    _Util.Convert<bool>(e.Value, d => e.DisplayText = d ? "男" : "女");
                    break;
                case "DayOfBirth":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDate());
                    break;
                case "ModifyTime":
                    _Util.Convert<DateTime>(e.Value, d => e.DisplayText = d.ToISDateWithTime(false));
                    break;
            }
        };

        pg.SetDefaultPageSizeIndex(0);
        pg.Reload += (s, e) => { Execute(); };

        cb_Gender.FromEnum<Gender>(valueAsInteger: true);
        bSearch.Click += (s, e) => { pg.Index = 0; Execute(); };

    }

    public override List<TB_driver> Selection
    {
        get
        {
            var result = new List<TB_driver>();
            if (gv.Selection.Count == 0) return result;
            var values = gv.GetSelectedFieldValues("Id", "Name");
            values.ForEach(v =>
            {
                var vs = (object[])v;
                result.Add(new TB_driver()
                {
                    Id = vs[0].ToString(),
                    Name = vs[1].ToString()
                });
            });
            return result;
        }
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var exp = PredicateBuilder.True<TB_driver>();
        exp = exp.And(d => d.Enabled);
        exp = exp.Append(tb_Name.Text, v => exp.And(e => e.Name.Contains(v)));
        exp = exp.Append(tb_LastName.Text, v => exp.And(e => e.LastName.Contains(v)));
        exp = exp.Append(tb_FirstName.Text, v => exp.And(e => e.FirstName.Contains(v)));

        if (!
            string.IsNullOrEmpty(
            cb_Gender.Value.ToStringEx()))
        {
            var g = (Gender)cb_Gender.Value.ToStringEx().ToIntOrDefault();
            switch (g)
            {
                case Gender.Female: exp = exp.And(e => e.Gender.HasValue && !e.Gender.Value); break;
                case Gender.Male: exp = exp.And(e => e.Gender.HasValue && e.Gender.Value); break;
                case Gender.Unknown: exp = exp.And(e => !e.Gender.HasValue); break;
            }
        }

        var q =
            from o in context.Drivers.Where(exp)
            select new
            {
                o.Id,
                o.Name,
                o.Gender,
                o.DayOfBirth,
                o.CHNId,
                o.Tel1,
                o.Education,
                o.SocialCat,
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

<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Item.ascx.cs" Inherits="eTaxi.Web.Controls.Selection.Position.Item" %>
<%@ Register Src="~/_controls.helper/DXGridWrapper.ascx" TagPrefix="uc1" TagName="DXGridWrapper" %>
<uc1:DXGridWrapper runat="server" ID="gw" />
<dx:ASPxGridView ID="gv" runat="server" KeyFieldName="Id" Width="100%">
    <Columns>
        <dx:GridViewDataTextColumn FieldName="Id" Visible="false" />
        <dx:GridViewDataTextColumn Caption="名称" FieldName="Name" VisibleIndex="3" Width="150" />
        <dx:GridViewDataTextColumn Caption="级别" FieldName="RankName" VisibleIndex="4" Width="150">
            <HeaderStyle HorizontalAlign="Center" />
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn Caption="说明" FieldName="Description" VisibleIndex="5">
            <HeaderStyle HorizontalAlign="Center" />
        </dx:GridViewDataTextColumn>
    </Columns>
    <SettingsBehavior AllowFocusedRow="false" AllowSelectSingleRowOnly="true" />
</dx:ASPxGridView>
<div class="darkBar">
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
    }

    public override List<TB_position> Selection
    {
        get
        {
            var result = new List<TB_position>();
            if (gv.Selection.Count == 0) return result;
            string[] Ids = Exp<object>.Transform(
                gv.GetSelectedFieldValues("Id"), o => o.ToString()).ToArray();
            result.AddRange(Global.Cache.Positions.Where(p => Ids.Contains(p.Id)).ToList());
            return result;
        }
    }

    protected override void _Execute()
    {
        var exp = PredicateBuilder.True<TB_position>();
        var q =
            from p in Global.Cache.Positions.Where(exp.Compile())
            select p;
        var rawData = q.ToList();

        // 过滤，筛选
        var data = Exp<TB_position>.Transform(rawData, d => new
        {
            d.Id,
            d.Name,
            d.RankId,
            RankName = Global.Cache.GetRank(r => r.Id == d.RankId).Name,
            d.Description
        });

        gv.DataSource = data;
        gv.DataBind();
        gv.Selection.UnselectAll();

    }

</script>

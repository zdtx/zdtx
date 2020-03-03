<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TreeItem.ascx.cs" Inherits="eTaxi.Web.Controls.Selection.Department.TreeItem" %>
<asp:Panel runat="server" ID="l" Visible="false" style="padding:10px;">
    （没有数据）
</asp:Panel>
<dx:ASPxTreeView runat="server" ID="tv" EnableAnimation="false" />
<script runat="server">

    protected override void _SetInitialStates()
    {
        base._SetInitialStates();
        tv.NodeClick += (s, e) =>
        {
            Selection.Clear();
            Selection.Add(new TB_department() { Id = e.Node.Name, Name = e.Node.Text });
            SinkEvent(this, EventTypes.OK, string.Empty);
        };
    }

    private List<TB_department> _Selection = new List<TB_department>();
    public override List<TB_department> Selection { get { return _Selection; } }
    
    protected override void _Execute()
    {
        var exp = PredicateBuilder.True<TB_department>();
        if (!
            string.IsNullOrEmpty(RootId))
            exp = exp.And(e => e.Id == RootId || e.Path.Contains(RootId + "/"));
        var q =
            from d in Global.Cache.Departments.Where(exp.Compile())
            select d;

        switch (SearchScope)
        {
            case Scope.OperatorChildDept:
                q = q.Where(
                    d => Global.Cache.GetChildDepartmentIds(_SessionEx.DepartmentId).Contains(d.Id));
                break;
            case Scope.OperatorSite:
                q = q.Where(
                    d => Global.Cache.GetChildDepartmentIds(_SessionEx.BranchId).Contains(d.Id));
                break;
        }

        if (ApplySessionFilter)
            q = q.Where(d => _SessionEx.RoleIds.Contains(d.Id));

        // 根据当前集合，找到展示的最佳方式
        var data = q.OrderBy(s => s.Ordinal).ToList();
        var final = new List<string[]>();
        data.ForEach(d =>
        {
            var dd = new string[] { d.ParentId, d.Id, d.Name };
            if (_Filter == null || (_Filter != null && _Filter(d)))
            {
                final.Add(dd);
                if (!
                    data.Any(ddd => ddd.Id == dd[0]))
                    dd[0] = string.Empty;
            }
        });

        if (!
            string.IsNullOrEmpty(OnClickHandle))
            tv.ClientSideEvents.NodeClick = string.Format("function(s,e){{{0}}}", OnClickHandle);

        tv.FromList(final,
            i => i[1],
            i => i[0], (n, i) => { n.Name = i[1]; n.Text = i[2]; }, string.Empty);
        tv.Visible = tv.Nodes.Count > 0;
        tv.ExpandAll();

        l.Visible = tv.Nodes.Count == 0;
    }

    public override void EnableJSInteractionOnly(string nodeClickHandle)
    {
        tv.ClientSideEvents.NodeClick = string.Format(
            "function(s,e){{{0}e.processOnServer=false;}}", nodeClickHandle);
    }

</script>

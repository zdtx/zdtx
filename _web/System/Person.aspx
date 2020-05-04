<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Register Src="~/_controls.helper/Partial/HeaderInfo.ascx" TagPrefix="uc1" TagName="HeaderInfo" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/PagingToolbar.ascx" TagPrefix="uc1" TagName="PagingToolbar" %>
<%@ Register Src="~/_controls.helper/GridWrapperForList.ascx" TagPrefix="uc1" TagName="GridWrapperForList" %>
<%@ Register Src="~/_controls.helper/Callback.ascx" TagPrefix="uc1" TagName="Callback" %>
<%@ Register Src="~/_controls.helper/PopupField_DX.ascx" TagPrefix="uc1" TagName="PopupField_DX" %>

<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="../content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="N" ContentPlaceHolderID="N">
    <uc1:HeaderInfo runat="server" ID="hi" />
    <uc1:Popup_DX runat="server" ID="pop" />
    <uc1:Callback runat="server" ID="cb" />
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <div class="actionTB" style="padding-left: 1px;">
        <dx:ASPxMenu runat="server" ID="tb" CssClass="dxTb" />
    </div>
    <asp:Panel runat="server" ID="pT" CSSClass="filterTb">
        <div class="inner">
            <table>
                <tr>
                    <td class="name">姓名：
                    </td>
                    <td class="cl">
                        <dx:ASPxTextBox runat="server" ID="tb_Name" Width="100" />
                    </td>
                    <td class="name">部门：
                    </td>
                    <td class="cl">
                        <uc1:PopupField_DX runat="server" ID="pf_DepartmentId" ShowEdit="true" Width="150" />
                    </td>
                    <td class="name">岗位：
                    </td>
                    <td class="cl">
                        <uc1:PopupField_DX runat="server" ID="pf_PositionId" ShowEdit="true" Width="150" />
                    </td>
                    <td style="padding-left: 10px;">
                        <dx:ASPxButton ID="bSearch" runat="server" Text="查找">
                            <Image Url="~/images/_op_flatb_search.gif" />
                        </dx:ASPxButton>
                    </td>
                    <td>
                        <dx:ASPxButton ID="bExport" runat="server" Text="导出">
                            <Image Url="~/images/_op_flatb_reply.gif" />
                        </dx:ASPxButton>
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <uc1:GridWrapperForList runat="server" ID="gw" />
    <asp:GridView runat="server" ID="gv" Width="100%">
        <selectedrowstyle cssclass="gridRow-selected" />
        <headerstyle cssclass="gridHeader" />
        <emptydatatemplate>
            <div class="emptyData">
                （无数据，请添加人员 或者 重置筛选条件）
            </div>
        </emptydatatemplate>
    </asp:GridView>
    <div class="darkBar" style="margin-top:1px;">
        <uc1:PagingToolbar runat="server" ID="pg" />
    </div>
</asp:Content>
<script runat="server">

    protected override bool _PACK_0001 { get { return true; } }
    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .North(true, c => { c.MaxSize = c.Size = 30; c.AutoHeight = false; })
            .West(true, c => { c.MinSize = c.Size = 100; })
            .CenterTop(true, c => { c.Size = 20; c.AutoHeight = true; })
            .Center(true)
            );
    }

    protected override void _SetInitialStates()
    {
        pf_DepartmentId.Initialize<eTaxi.Web.Controls.Selection.Department.TreeItem>(pop,
            "~/_controls.helper/selection/department/treeitem.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择部门";
                pop.Width = 500;
                pop.Height = 400;
                if (isFirst) cc.Execute();
            }, (c, b, h) =>
            {
                b.Text = c.Selection[0].Name;
                h.Value = c.Selection[0].Id;
                pop.Close();
                return true;
            }, null, c => c.Button(BaseControl.EventTypes.OK, s => s.CausesValidation = false));

        pf_PositionId.Initialize<eTaxi.Web.Controls.Selection.Position.Item>(pop,
            "~/_controls.helper/selection/position/item.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择岗位";
                pop.Width = 500;
                pop.Height = 400;
                if (isFirst) cc.Execute();
            }, (c, b, h) =>
            {
                b.Text = c.Selection[0].Name;
                h.Value = c.Selection[0].Id;
                pop.Close();
                return true;
            }, null, c => c.Button(BaseControl.EventTypes.OK, s => s.CausesValidation = false));
     
        tb
            .MenuItem("create", "添加", "_op_flatb_add.gif")
            .MenuItem("delete", "删除", "_op_flatb_delete.gif", i => { i.BeginGroup = true; })
            .ItemClickJSFunc(string.Format(
@"function(s,e){{
switch(e.item.name){{
case'create':
case'delete':ISEx.loadingPanel.show();break; 
}}}}", gv.ClientID))
            .ItemClick += (s, e) =>
            {
                switch (e.Item.Name)
                {
                    case "create":
                        pop.Begin<BaseControl>("~/_controls.sys/person/edit.ascx",
                            null, c =>
                            {
                                c.ViewStateEx.Set<bool>(true, DataStates.IsCreating);
                                c.Execute();
                            }, c =>
                            {
                                c
                                    .Width(450)
                                    .Height(500)
                                    .Title("新人员")
                                    .Button(BaseControl.EventTypes.Save, b => b.CausesValidation = true)
                                ;
                            });
                        break;
                    case "delete":

                        if (!gw.Selection.Any(kv => kv.Value))
                        {
                            _JS.Alert("请先选择待删除的条目");
                            return;
                        }

                        cb.Break("Do", Actions.Delete, () => true, postBack =>
                        {
                            _JS.Write(string.Format("if(confirm('{0}')){{ISEx.loadingPanel.show();{1}}}", "确定删除选中的条目吗？", postBack));
                        });

                        break;
                }
            };

        gw.Initialize(gv, c => c
            .TemplateField("Id", "Id", new TemplateItem.Label(), f => f.Visible = false)
            .TemplateField("Code", "工号", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Name", "姓名", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("Gender", "性别", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 50;
            })
            .TemplateField("Department", "部门归属", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("Position", "岗位", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 150;
            })
            .TemplateField("UserName", "登录帐号", new TemplateItem.Label(), f =>
            {
                f.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
                f.ItemStyle.Width = 100;
            })
            .TemplateField("lu", "管理", new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.Text = "登录帐号";
                l.ToolTip = "添加、修改 或 删除人员登录信息";
                l.CommandName = "user";
                l.OnClientClick = "ISEx.loadingPanel.show();";
            }), f =>
            {
                f.ItemStyle.Width = 50;
            })
            .TemplateField("lp", "管理", new TemplateItem.LinkButton(l =>
            {
                l.CssClass = "aBtn";
                l.Text = "人员信息";
                l.ToolTip = "修改人员基本信息";
                l.CommandName = "person";
                l.OnClientClick = "ISEx.loadingPanel.show();";
            }), f =>
            {
                f.ItemStyle.Width = 50;
            })
            .TemplateField("", "备注", new TemplateItem.Label())

                , showFooter: false, mode: GridWrapper.SelectionMode.Multiple
            );

        gv.RowCommand += (s, e) =>
        {
            if (e.CommandName != "user" && e.CommandName != "person") return;
            var rowIndex = e.CommandArgument.ToStringEx().ToIntOrDefault();
            var v = new GridWrapper.RowVisitor(gv.Rows[rowIndex]);
            v.Get<Label>("Id", l => v.Get<Label>("Name", n =>
            {
                switch (e.CommandName)
                {
                    case "user":
                        pop.Begin<BaseControl>("~/_controls.sys/user/edit.ascx",
                            null, c =>
                            {
                                c.ViewStateEx.Set(l.Text, DataStates.ObjectId);
                                c.Execute();
                            }, c =>
                            {
                                c
                                    .Width(450)
                                    .Height(300)
                                    .Title("登录 - " + n.Text)
                                    .Button(BaseControl.EventTypes.Save, b => b.CausesValidation = true)
                                ;
                            });
                        break;
                    case "person":
                        pop.Begin<BaseControl>("~/_controls.sys/person/edit.ascx",
                            null, c =>
                            {
                                c.ViewStateEx.Set(l.Text, DataStates.ObjectId);
                                c.Execute();
                            }, c =>
                            {
                                c
                                    .Width(450)
                                    .Height(500)
                                    .Title("编辑 - " + n.Text)
                                    .Button(BaseControl.EventTypes.Save, b => b.CausesValidation = true)
                                ;
                            });
                        break;
                }
            }));
        };

        pg.SetDefaultPageSizeIndex(0);
        pg.Reload += (s, e) => Execute();

        pop.EventSinked += (c, eType, parm) =>
        {
            if (c.ModuleId == Person.Edit)
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Save:
                        if (c.Do(Actions.Save, true))
                        {
                            _JS.Alert("保存成功。");
                            pop.Close();
                            Execute();
                        }
                        break;
                }
            }

            if (c.ModuleId == eTaxi.Definitions.Ascx.User.Edit)
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.Save:
                        if (c.Do(Actions.Save, true))
                        {
                            _JS.Alert("保存成功。");
                            pop.Close();
                            Execute();
                        }
                        break;
                }
            }
        };

        bSearch.Click += (s, e) => Execute();
        bExport.Click += (s, e) => Execute(VisualSections.Export);

        cb.Resumed += (caller, parameter) =>
        {
            switch (parameter)
            {
                case Actions.Delete:
                    if (Do(Actions.Delete, true))
                    {
                        _JS.Alert("删除成功");
                        Execute();
                    }
                    break;
            }
        };
    }

    protected override void _Execute()
    {
        hi
            .Back("返回桌面", "../portal/desktop.aspx")
            .Title("基础数据", "人员管理");

        _Execute(VisualSections.List);
    }
    protected override void _Execute(string section)
    {
        var context = _DTContext<CommonContext>(true);
        var exp = PredicateBuilder.True<TB_person>();
        exp = exp.And(p => !p.Deleted);
        exp = exp.Append(tb_Name.Text.Trim(), v => exp.And(e => e.Name.Contains(v)));
        exp = exp.Append(pf_DepartmentId.Value, v => exp.And(e => e.DepartmentId == v));
        exp = exp.Append(pf_PositionId.Value, v => exp.And(e => e.PositionId == v));

        var q =
            from p in context.Persons.Where(exp)
            from u in context.Users.Where(u => u.UserId == p.UniqueId).DefaultIfEmpty()
            select new
            {
                p.Id,
                p.Code,
                p.Name,
                p.Gender,
                p.PositionId,
                p.DepartmentId,
                p.UniqueId,
                p.ModifiedById,
                p.ModifyTime,
                p.Remark,
                UserName = u == null ? null : u.LoweredUserName,
                Created = u != null
            };

        // 独立导出数据
        if (section == VisualSections.Export)
        {
            _ExportToExcel("PN", q.Select(o => new
            {
                o.Id,
                o.Code,
                o.Name,
                o.Gender,
                o.PositionId,
                o.DepartmentId,
                o.ModifiedById,
                o.ModifyTime,
                o.UserName,
                o.Remark

            }).ToList(), new string[]
            {
                "唯一码",
                "工号",
                "姓名",
                "性别",
                "岗位",
                "部门归属",
                "修改人",
                "修改时间",
                "用户名",
                "备注"

            }, d => new
            {
                d.Id,
                d.Code,
                d.Name,
                Gender = d.Gender.HasValue ? d.Gender.Value ? "男" : "女" : "（未知）",
                PositionName = Global.Cache.GetPosition(dd => dd.Id == d.PositionId).Name,
                DepartmentName = Global.Cache.GetDepartment(dd => dd.Id == d.DepartmentId).Name,
                Modifier = Global.Cache.GetPerson(p => p.Id == d.ModifiedById).Name,
                ModifyTime = d.ModifyTime.ToISDateWithTime(),
                UserName = string.IsNullOrEmpty(d.UserName) ? "（无）" : d.UserName,
                d.Remark

            }, pop);

            return;
        }

        gw.Execute(q.Skip(pg.Skip).Take(pg.Size ?? 100).ToList(), b => b
            .Do<Label>("Id", (l, d) => l.Text = d.Id)
            .Do<Label>("Name", (l, d) => l.Text = d.Name)
            .Do<Label>("Code", (l, d) => l.Text = d.Code)
            .Do<Label>("Gender", (l, d) =>
            {
                l.Text = d.Gender.HasValue ? d.Gender.Value ? "男" : "女" : "（未知）";
            })
            .Do<Label>("Department", (l, d) => l.Text = Global.Cache.GetDepartment(dd => dd.Id == d.DepartmentId).Name)
            .Do<Label>("Position", (l, d) => l.Text = Global.Cache.GetPosition(p => p.Id == d.PositionId).Name)
            .Do<Label>("UserName", (l, d) =>
            {
                l.Text = d.UserName;
                if (string.IsNullOrEmpty(d.UserName))
                {
                    l.Text = "（未创建用户）";
                    l.ForeColor = System.Drawing.Color.Red;
                }
            })
            .Do<LinkButton>("lu", (l, d, r) => l.CommandArgument = r.RowIndex.ToString())
            .Do<LinkButton>("lp", (l, d, r) => l.CommandArgument = r.RowIndex.ToString())
            .Do<Label>("Remark", (l, d) => l.Text = d.Remark)
            );

        pg.Total = q.Count();
        pg.Execute();
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Delete) return;
        var ids = gw.GetSelected<Label, string>("Id", l => l.Text);
        var context = _DTService.Context;
        var persons = context.Persons.Where(p => ids.Contains(p.Id)).ToList();
        ids.ForEach(id =>
        {
            var personId = id.ToString();
            persons.SingleOrDefault(p => p.Id == personId).IfNN(p =>
            {
                Membership.GetUser(p.UniqueId)
                    .IfNN(u => _MembershipProvider.DeleteUser(u.UserName, true));
            });
            _DTService.DeletePerson(personId);
        });
        Global.Cache.SetDirty(CachingTypes.Person);
    }

</script>

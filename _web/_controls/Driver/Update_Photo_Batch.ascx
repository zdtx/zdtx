<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Import Namespace="System.IO" %>
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
                <td style="padding-right: 10px;">请填入司机姓名（然后回车）：
                </td>
                <td>
                    <dx:ASPxTextBox runat="server" ID="tbInput" Width="100" />
                </td>
                <td style="padding-left: 10px;">或者：
                </td>
                <td>
                    <dx:ASPxButton runat="server" Text="在列表中选择司机" ID="bSelect">
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
                （请先选择司机）
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
<script runat="server">

    private List<TB_driver> _List
    {
        get { return _ViewStateEx.Get<List<TB_driver>>(DataStates.List, new List<TB_driver>()); }
        set { _ViewStateEx.Set<List<TB_driver>>(value, DataStates.List); }
    }

    private string[] _DriverIds
    {
        get { return _ViewStateEx.Get<string[]>(DataStates.Selected, new string[] { }); }
        set { _ViewStateEx.Set<string[]>(value, DataStates.Selected); }
    }

    private string _ObjectId
    {
        get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); }
        set { _ViewStateEx.Set<string>(value, DataStates.ObjectId); }
    }

    private string _Selected
    {
        get { return _ViewStateEx.Get<string>(DataStates.Selected, null); }
        set { _ViewStateEx.Set<string>(value, DataStates.Selected); }
    }

    public override string ModuleId { get { return Driver.Update_Batch_1; } }
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
                if (tbInput.Text.Trim().Length == 0)
                    return;
                var context = _DTContext<CommonContext>(true);
                var name = tbInput.Text.ToStringEx();
                var drivers = context.Drivers.Where(d => d.Name.Contains(name)).ToList();
                if (drivers.Count == 0)
                {
                    Alert("找不到司机，请重新输入");
                    tbInput.Text = string.Empty;
                    tbInput.Focus();
                    return;
                }
                if (drivers.Count == 1)
                {
                    _DriverIds = new string[] { drivers[0].Id };
                    if (Do(Actions.Select, false))
                        Execute(VisualSections.List);
                    tbInput.Text = string.Empty;
                    tbInput.Focus();
                    return;
                }
                Alert("有超过一个司机符合该姓名特征，请检查");
                tbInput.Focus();
                return;
            }
        });

        at
            .Initialize(cc => cc
                .Button(BaseControl.EventTypes.Cancel, b =>
                {
                    b.CausesValidation = false;
                    b.Text = "移除选定的司机（不作修改）";
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
                                .Any(kv => kv.Value))
                            { Alert("请选择待移除的条目。"); return; }
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
            pop.Begin<eTaxi.Web.Controls.Selection.Driver.Item>(
                "~/_controls.helper/selection/driver/items.ascx", null, c =>
                {
                    c.Execute();
                }, c =>
                {
                    c
                        .Width(650)
                        .Height(500)
                        .Title("先选择司机")
                        .Button(BaseControl.EventTypes.OK, b => b.CausesValidation = true)
                    ;
                });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            c.If<eTaxi.Web.Controls.Selection.Driver.Item>(cc =>
            {
                switch (eType)
                {
                    case BaseControl.EventTypes.OK:

                        if (cc.Selection.Count == 0)
                        {
                            Alert("您还没选定司机，请先选择司机");
                            return;
                        }

                        pop.Close();
                        var driverIds = cc.Selection.Select(s => s.Id).ToArray();
                        _ViewStateEx.Set(driverIds, DataStates.Selected);
                        if (Do(Actions.Select, false))
                            Execute(VisualSections.List);
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
            .TemplateField("Name", "姓名", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("Gender", "性别", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("CHNId", "身份证号", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("DayOfBirth", "出生日期", new TemplateItem.Literal(e =>
            {
            }), f =>
            {
            })
            .TemplateField("Photo", "照片", new TemplateItem.Image(e =>
            {
            }), f =>
            {
                f.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                f.ItemStyle.VerticalAlign = VerticalAlign.Middle;
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
                f.ItemStyle.Wrap = false;
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
                f.ItemStyle.Wrap = false;
            })
        );

        gv.RowCommand += (s, e) =>
        {
            if (e.CommandName != "ed1" && e.CommandName != "ed2") return;
            var rowIndex = e.CommandArgument.ToStringEx().ToIntOrDefault();
            var v = new GridWrapper.RowVisitor(gv.Rows[rowIndex]);
            v.Get<Literal>("Id", l =>
            {
                _ObjectId = l.Text;
                switch (e.CommandName)
                {
                    case "ed1":
                        pop.Begin<eTaxi.Web.Controls.Flashcam>("~/_controls.helper/flashcam.ascx",
                            null, c =>
                            {
                                c.ObjectId = Guid.NewGuid().ToISFormatted();
                                c.Execute();
                            }, c =>
                            {
                                c
                                    .Width(420)
                                    .Height(360)
                                    .Title("摄像机")
                                ;
                            });
                        break;
                    case "ed2":
                        pop.Begin<eTaxi.Web.BaseControl>("~/_controls.sys/upload_photo.ascx",
                            null, c =>
                            {
                                c.Execute();
                            }, c =>
                            {
                                c
                                    .Width(420)
                                    .Height(250)
                                    .Title("图片上传")
                                    .Button(BaseControl.EventTypes.OK, b =>
                                    {
                                        b.CausesValidation = false;
                                        b.Text = "开始上传";
                                        b.JSHandle = string.Format(
                                            "if({0}.GetFileInputCount()>0){{ISEx.loadingPanel.show('上传中，请稍候..');{0}.Upload();}}else{{alert('请先点击 [浏览] 选定待上传的文件');e.processOnServer=false;}}",
                                            pop.HostingControl.ClientID);
                                    })
                                ;
                            });
                        break;
                }
            });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            c.If<eTaxi.Web.Controls.Flashcam>(cc =>
            {
                if (eType != EventTypes.OK) return;
                _Selected = string.Format("~{0}/file/{1}.jpg", Parameters.Tempbase, cc.ObjectId);
                if (Do(Actions.Save, false))
                {
                    pop.Close();
                    Execute(VisualSections.List);
                }
            });

            if (c.ModuleId == Sys.Upload_Photo)
            {
                if (eType != EventTypes.OK) return;
                if (c.Do(Actions.Save, false))
                {
                    var objectId = c.ViewStateEx.Get<string>(DataStates.ObjectId);
                    _Selected = string.Format("~{0}/file/{1}.jpg", Parameters.Tempbase, objectId);
                    if (Do(Actions.Save, false))
                    {
                        pop.Close();
                        Execute(VisualSections.List);
                    }
                }
            }
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
            gw.Execute(_List, b => b
                .Do<Literal>("Id", (c, d) => { c.Text = d.Id; })
                .Do<Literal>("Name", (c, d) => c.Text = d.Name)
                .Do<Literal>("Gender", (c, d) => c.Text = d.Gender.HasValue ? d.Gender.Value ? "男" : "女" : "（未知）")
                .Do<Literal>("CHNId", (c, d) => c.Text = d.CHNId)
                .Do<Literal>("DayOfBirth", (c, d) => c.Text = d.DayOfBirth.ToISDate())
                .Do<Image>("Photo", (c, d) =>
                {
                    var path = string.Format("~{0}/{1}.jpg", Parameters.Filebase, d.Id);
                    if (File.Exists(Util.GetPhysicalPath(path)))
                    {
                        c.ImageUrl = path;
                    }
                    else
                    {
                        c.ImageUrl = "~/images/del.gif";
                    }
                })
                .Do<LinkButton>("ed1", (ll, d, rr) =>
                {
                    ll.Text = "摄像头拍照";
                    ll.CommandArgument = rr.RowIndex.ToString();
                })
                .Do<LinkButton>("ed2", (ll, d, rr) =>
                {
                    ll.Text = "图片文件上传";
                    ll.CommandArgument = rr.RowIndex.ToString();
                })
            );

            at.Visible = _List.Count > 0;
            return;
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section == Actions.Select)
            _Do_Select();
        if (section == Actions.Save)
            _Do_Save();
    }

    private void _Do_Select()
    {
        _DriverIds.ForEach(id =>
        {
            if (_List.Any(l => l.Id == id))
                return;
            var context = _DTContext<CommonContext>(true);
            context.Drivers.SingleOrDefault(d => d.Id == id).IfNN(d => _List.Add(d));
        });
    }

    private void _Do_Save()
    {
        // 将 temp 目录 文件放入 同名 id
        var file = Util.GetPhysicalPath(_Selected);
        var newFile = Util.GetPhysicalPath(
            string.Format("{0}/{1}.jpg", Parameters.Filebase, _ObjectId));
        File.Copy(file, newFile, true);
    }

</script>

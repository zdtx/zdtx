<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" MasterPageFile="~/_master/default.split.master" %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Register Src="~/_controls.desktop/Person/Greeting.ascx" TagPrefix="uc1" TagName="Greeting" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<asp:Content runat="server" ID="H" ContentPlaceHolderID="H">
    <script type="text/javascript" src="../content/scripts/__page.js"></script>
    <script type="text/javascript">

        ISEx.extend({
        });

    </script>
</asp:Content>
<asp:Content runat="server" ID="W" ContentPlaceHolderID="W">
    <div style="padding: 5px; padding-right: 0px;">
        <div class="pane">
            <div class="header">
                <b><%= _SessionEx.Name %>，您好。</b>
            </div>
            <uc1:Greeting runat="server" ID="uG" />
        </div>
        <div class="pane" style="margin-top: 5px;">
            <div class="cHeader">
                <b>信息面板</b>
            </div>
            <div style="padding: 10px;">
                <table class="form" style="width: 100%; border-spacing: 1px;">
                    <tr>
                        <td class="name">系统通告
                        </td>
                        <td style="padding: 5px;">“<asp:LinkButton runat="server" ID="lb1" Text="系统通知" Font-Italic="true" />
                            ”
                        </td>
                    </tr>
                    <tr>
                        <td class="name">常用链接
                        </td>
                        <td style="padding: 5px;">
                            <a class="aBtn" href="javascript:void(0);" onclick="alert('即将上线，请留意系统公告。')">个人查询</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:Panel runat="server" CssClass="pane" ID="pL" Style="margin-top: 5px;">
            <div class="cHeader">
                <b>业务处理</b>
            </div>
            <div style="padding: 10px;">
                <table class="form" style="width: 100%; border-spacing: 1px;">
                    <asp:PlaceHolder runat="server" ID="l" />
                </table>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
<asp:Content runat="server" ID="T" ContentPlaceHolderID="T">
    <uc1:Popup_DX runat="server" ID="pp" />
    <dx:ASPxTimer runat="server" ID="t" Interval="300000" />
    <div class="actionTB">
        <table>
            <tr>
                <td>
                    <img src="../images/_doc_22.gif" alt="桌面" />
                </td>
                <td style="padding: 2px;">
                    <h1>我的桌面 &nbsp;<asp:Button ID="bReload" runat="server" Text="刷新" OnClientClick="ISEx.loadingPanel.show();" /></h1>
                </td>
                <td style="padding-left:5px;">
                    <div class="tips" style="padding:3px;">
                        <asp:Literal runat="server" ID="ltTime" />
                    </div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
<asp:Content runat="server" ID="C" ContentPlaceHolderID="C">
    <table class="ds" style="width: 100%;">
        <tr>
            <td class="dsWrap" style="padding-top:0px;">
                <asp:PlaceHolder runat="server" ID="cL" />
            </td>
            <td class="dsWrap" style="padding-top:0px;width: 40%;">
                <table class="dsTb">
                    <tr>
                        <th colspan="2">
                            <span class="text">管理动态汇总</span>
                        </th>
                    </tr>
                    <asp:PlaceHolder runat="server" ID="cR" />
                </table>
            </td>
        </tr>
    </table>
</asp:Content>
<script runat="server">

    protected override void _SetPreInitControls()
    {
        Master.RegisterScriptManager(new ScriptManager());
        Master.ConfigZone(s => s
            .West(true, c => c.Size = 280)
            .CenterTop(true, c => c.AutoHeight = true)
            .Center(true)
        );
    }

    protected List<BasePortlet> _Portlets = new List<BasePortlet>();
    protected bool _LeftVisible = false;
    protected override void _SetInitialStates()
    {
        _SessionEx.Portlets.ForEach(p => _Portlets.Add(LoadControl("~/" + p) as BasePortlet));

        // 根据门户控件信息放置到不同的容器
        for (int i = 0; i < _Portlets.Count; i++)
        {
            var p = _Portlets[i];
            p.ID = "x" + i.ToString();
            p.MasterLoader = pp;

            switch (p.TargetArea)
            {
                case BasePortlet.Area.Left:
                    l.Controls.Add(p);
                    break;
                case BasePortlet.Area.Center1:
                    cL.Controls.Add(p);
                    break;
                case BasePortlet.Area.Center2:
                    cR.Controls.Add(p);
                    break;
            }
        }

        uG.MasterLoader = pp;
        t.ClientInstanceName = t.ClientID;

        bReload.Click += (s, e) =>
        {
            Execute();
            _JS.Write(string.Format("{0}.Start();", t.ClientID));
        };

        //lb1.Click += (s, e) =>
        //{
        //    _Context.UpdateNotes
        //        .OrderByDescending(n => n.CreateDate)
        //        .FirstOrDefault().IfNN(n =>
        //        {
        //            pp.Begin<ISoft.Web.Controls.Message>("~/controls/message.ascx", null, cc =>
        //            {
        //                cc.Title = n.Title;
        //                cc.MessageText = n.Context;
        //                cc.Remark = n.Remark;
        //            }, cc => cc
        //                .Width(400)
        //                .Height(300)
        //                .Title("系统公告")
        //                .Button(BaseControl.EventTypes.Cancel, b => b.Text = "关闭")
        //            );
        //        });
        //};
    }
    
    protected override void _FirstGet()
    {
        base._FirstGet();

        // 设置定期刷新
        if (_Logined)
        {
            t.ClientSideEvents.Tick =
                string.Format("function(s,e){{e.processOnServer=false;s.Stop();{0}}}",
                    Page.ClientScript.GetPostBackEventReference(bReload, string.Empty) + ";" +
                    "ISEx.loadingPanel.show('自动刷新中..');");
        }
    }

    protected override void _Execute()
    {
        uG.Execute();

        // 对已经进驻的门户控件执行渲染方法
        _LeftVisible = false;

        _Portlets.ForEach(x =>
        {
            x.Execute();
            if (x.TargetArea == BasePortlet.Area.Left && x.Visible) _LeftVisible = true;
        });

        pL.Visible = _LeftVisible;
        ltTime.Text = "最后刷新：" + _CurrentTime.ToISDateWithTime();
    }

    protected override bool _HandleException(
        Type callerType, ExceptionFilter exFilter, string step, Action<string> msgSend = null)
    {
        // 如果发生错误，则停止自动刷新机制
        t.ClientSideEvents.Tick = null;
        return base._HandleException(callerType, exFilter, step, msgSend);
    }
        
</script>

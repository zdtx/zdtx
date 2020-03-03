<%@ Page Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.Page" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="theHead" runat="server">
    <title>eTaxi : 出错提示</title>
    <link href="content/default.css" rel="stylesheet" type="text/css" />
    <link href="content/icons.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form runat="server" id="theForm">
        <ext:ResourceManager runat="server" ID="theManager" Theme="Default" IDMode="Inherit" />
        <ext:Window runat="server" Modal="true" Draggable="false" Width="550" Height="400"
            Title="十分抱歉，系统遇到了点问题。" Icon="Error" Layout="CardLayout"
            Closable="false" ShadowMode="None" ID="win">
            <TopBar>
                <ext:Toolbar runat="server" Layout="FitLayout">
                    <Items>
                        <ext:TabStrip runat="server">
                            <Items>
                                <ext:Tab ActionItemID="p1" Text="提示" />
                                <ext:Tab ActionItemID="p2" Text="运维参数（供系统维护人员参考）" />
                            </Items>
                        </ext:TabStrip>
                    </Items>

                </ext:Toolbar>
            </TopBar>
            <Items>
                <ext:Panel runat="server" ID="p1" Border="false" BodyPadding="10" AutoScroll="true">
                    <Content>
                        <table>
                            <tr>
                                <td><asp:Image ID="Image1" runat="server" ImageUrl="~/images/cw.gif" /></td>
                                <td style="font-size:15px;font-weight:bold;padding:10px;">
                                    <asp:Literal runat="server" ID="ltMessage" />
                                </td>
                            </tr>
                        </table>
                        <div class="toolbar" style="padding:10px;">
                            <b>解决方案</b>：
                            <div class="footer" style="margin-top:10px;padding-top:10px;">
                                <asp:Literal runat="server" ID="ltSolution" Text="（无）" />
                            </div>
                        </div>
                    </Content>
                </ext:Panel>
                <ext:Panel runat="server" ID="p2" Border="false" BodyPadding="10" AutoScroll="true">
                    <Content>
                        <div class="toolbar" style="padding:10px">
                            <asp:Repeater runat="server" ID="repData">
                                <HeaderTemplate>
                                    <table class="form" style="border-spacing:1px;">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="name"><asp:Literal runat="server" ID="ltKey" /></td>
                                        <td class="val" style="width:380px;"><asp:Literal runat="server" ID="ltValue" /></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="footer" style="padding:10px;">
                            <asp:Literal runat="server" ID="ltTrace" />
                        </div>
                    </Content>
                </ext:Panel>
            </Items>
            <Buttons>
                <ext:Button runat="server" Text="重来一次" IconCls="icon-left-large" 
                    Scale="Large" PaddingSpec="5 10 5 5">
                    <Listeners>
                        <Click Handler="history.go(-1);" />
                    </Listeners>
                </ext:Button>
                <ext:Button runat="server" ID="bLogin" Text="重新登录试试" IconCls="icon-home-large"
                    Scale="Large" PaddingSpec="5 10 5 5">
                    <Listeners>
                        <Click Handler="location.href='login.aspx?off=true'" />
                    </Listeners>
                </ext:Button>
            </Buttons>
        </ext:Window>
    </form>
</body>
</html>
<script runat="server">

    private eTaxi.HttpSessionStateWrapper _Wrapper;
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        _Wrapper = new eTaxi.HttpSessionStateWrapper(Session, DateTime.Now);
        if (_Wrapper.LastException == null) Response.Redirect("~/login.aspx", true);
    }

    protected override void OnLoad(EventArgs e)
    {
        if (_Wrapper.LastException == null) return;
        Action<IDictionary> _fillTB = d =>
        {
            repData.ItemDataBound += (s, ee) =>
            {
                if (ee.Item.ItemType == ListItemType.Item ||
                    ee.Item.ItemType == ListItemType.AlternatingItem)
                {
                    ee.Item.FindControl("ltKey").As<Literal>().Text =
                        DataBinder.Eval(ee.Item.DataItem, "Key").ToStringEx();
                    ee.Item.FindControl("ltValue").As<Literal>().Text =
                        DataBinder.Eval(ee.Item.DataItem, "Value").ToStringEx();
                }
            };

            repData.DataSource = d;
            repData.DataBind();
        };

        if (_Wrapper.LastException is TTableRecordNotFound)
        {
            _Wrapper.LastException.If<TTableRecordNotFound>(ex =>
            {
                ltMessage.Text = string.Format(
                    "数据表（{0}）中找不到相关记录。", ex.TableName);
                ltSolution.Text = string.Format(
                    "这也许是：<ul><li>{0}</li><li>{1}</li><li>{2}</li></ul>",
                    "数据库访问出现不同步；",
                    "您操作过程中，别人也在操作该数据从而导致冲突；",
                    "您可以按 F5 键 刷新页面，重新提交数据，如果问题继续存在，请联系运维人员。");
                ltTrace.Text = ex.StackTrace;
                _fillTB(ex.Data);
            });

            _Wrapper.Remove(eTaxi.HttpSessionStateWrapper.Keys.LastException);
            return;
        }

        if (_Wrapper.LastException is DTException)
        {
            _Wrapper.LastException.If<DTException>(ex =>
            {
                if (ex.Enumed)
                {
                    //ex.Value.If<Document.Common>(v =>
                    //    ltMessage.Text = Global.Cache.GetEnumCaption((E.Document.Common)ex.Value));
                    //ex.Value.If<Document.Folder>(v =>
                    //    ltMessage.Text = Global.Cache.GetEnumCaption((E.Document.Folder)ex.Value));

                    ltMessage.Text.Split('|', (c, s) =>
                    {
                        if (c > 1)
                        {
                            ltMessage.Text = s[0];
                            ltSolution.Text = s[1];
                        }
                    });
                }
                else
                {
                    ltMessage.Text = ex.Message;
                }

                ltTrace.Text = ex.StackTrace;
                _fillTB(ex.Data);
            });

            _Wrapper.Remove(eTaxi.HttpSessionStateWrapper.Keys.LastException);
            return;
        }

        // 一般处理

        var exception = _Wrapper.LastException;
        ltMessage.Text = exception.Message;
        ltTrace.Text = exception.StackTrace;
        _fillTB(exception.Data);
        _Wrapper.Remove(eTaxi.HttpSessionStateWrapper.Keys.LastException);
    }

</script>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="eTaxi.Web.Portal.Default" MasterPageFile="~/_master/frame1.master" EnableViewState="false"
    Title="eTaxi :: 门户"  %>
<%@ MasterType TypeName="eTaxi.Web.MasterPageEx" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Module" %>
<asp:Content ID="T" runat="server" ContentPlaceHolderID="T">
    <link type="text/css" rel="stylesheet" href="../content/icons.css" />
    <link type="text/css" rel="stylesheet" href="../content/ext.ie.patch.css" />
    <script src="../content/scripts/__page.ext.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ContentPlaceHolderID="N" runat="server">
    <ext:Container runat="server" ID="cBanner" Layout="HBoxLayout" Cls="mainHeader" Height="50" IDMode="Inherit">
        <LayoutConfig>
            <ext:HBoxLayoutConfig Align="Stretch" />
        </LayoutConfig>
        <Bin>
            <ext:TaskManager runat="server" ID="ts" Interval="60000">
                <Tasks>
                    <ext:Task TaskID="t1">
                        <Listeners>
                            <Update Handler="#{txtTime}.setText(Ext.Date.format(new Date(), 'Y年m月d日 H:i'));" />
                        </Listeners>
                    </ext:Task>
                </Tasks>
            </ext:TaskManager>
        </Bin>
        <Content>
            <ext:Container runat="server" Cls="topLeft" PaddingSpec="5 5 5 5" Width="40">
                <Content>
                    <img src="../images/czjf-logo.png" alt="常州交服" height="38" />
                </Content>
            </ext:Container>
            <ext:Container runat="server" Cls="topRight" PaddingSpec="24 0 0 100" Flex="1">
                <Items>
                    <ext:Toolbar runat="server" Flat="true">
                        <Items>
                            <ext:ToolbarTextItem runat="server" Text="常州交服出租车有限公司" 
                                StyleSpec="font-size:20px;font-family:YouYuan;" PaddingSpec="0 0 5 0" />
                            <ext:ToolbarFill runat="server" />
                            <ext:Button runat="server" Text="桌面" Icon="HouseConnect" Padding="3" />
                            <ext:ToolbarSeparator runat="server" />
                            <ext:Button runat="server" Text="后退" Icon="ArrowLeft" Padding="3">
                                <Listeners>
                                    <Click Handler="ISEx.back();" />
                                </Listeners>
                            </ext:Button>
                            <ext:Button runat="server" Text="前进" Icon="ArrowRight" IconAlign="Right" Padding="3">
                                <Listeners>
                                    <Click Handler="ISEx.forward();" />
                                </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator runat="server" />
                            <ext:Button runat="server" Text="设置" Icon="Wrench" IconAlign="Right" Padding="3" />
                            <ext:ToolbarSeparator runat="server" />
                            <ext:Button runat="server" Text="退出" IconAlign="Right" Icon="KeyGo" Padding="3">
                                <Listeners>
                                    <Click Handler="ISEx.logout();" />
                                </Listeners>
                            </ext:Button>
                            <ext:ToolbarFill runat="server" />
                            <ext:ToolbarTextItem runat="server" ID="txtTime" />
                        </Items>
                    </ext:Toolbar>
                </Items>
            </ext:Container>
        </Content>
    </ext:Container>
    <ext:Toolbar runat="server" ID="topTB" BaseCls="topTB" Height="30" IDMode="Inherit" EnableOverflow="true">
        <Defaults>
            <ext:Parameter Name="margin" Value="0 2 0 2" />
        </Defaults>
        <Items>
            <ext:Button runat="server" ID="bHome" IconCls="icon-home-medium"
                Text="&nbsp;&nbsp;<b>主菜单</b>" EnableToggle="true">
                <Listeners>
                    <Toggle Handler="ISEx.toggleMenu(pressed);" />
                </Listeners>
            </ext:Button>
            <ext:ToolbarSeparator runat="server" />
            <ext:ToolbarFill runat="server" />
            <ext:ToolbarSeparator runat="server" />
            <ext:ToolbarTextItem runat="server" ID="bWC" Text="欢迎您" MarginSpec="0 5 0 5" />
            <ext:ToolbarSeparator runat="server" />
            <ext:Button runat="server" Icon="ApplicationGet" EnableToggle="true" ToolTip="打开/收起面板">
                <Listeners>
                    <Toggle Handler="ISEx.toggleTop(pressed);" />
                </Listeners>
            </ext:Button>
        </Items>
        <Bin>
            <ext:Window runat="server" ID="winHome" AutoShow="false" Width="550" ButtonAlign="Left"
                Header="false" Border="false" CloseAction="Hide" Layout="BorderLayout">
                <Items>
                    <ext:Panel runat="server" ID="pMenu" Header="false"
                        Layout="AccordionLayout" Width="250" Region="West">
                        <LayoutConfig>
                            <ext:AccordionLayoutConfig Animate="false" />
                        </LayoutConfig>
                    </ext:Panel>
                    <ext:TreePanel runat="server" ID="tpItems" RootVisible="false" Region="Center" BodyPaddingSummary="10 10 10 5"
                        MarginSpec="0 0 0 3" Title="功能列表" EmptyText="请选择菜单项" Lines="false" AnimCollapse="false" Animate="false">
                        <Store>
                            <ext:TreeStore runat="server" ID="dsT" AutoLoad="false">
                                <Model>
                                    <ext:Model runat="server">
                                        <Fields>
                                            <ext:ModelField Name="value" />
                                        </Fields>
                                    </ext:Model>
                                </Model>
                            </ext:TreeStore>
                        </Store>
                        <Root>
                            <ext:Node Text="[root]">
                                <Children>
                                    <ext:Node Text="车辆管理" Icon="Car"></ext:Node>
                                </Children>
                            </ext:Node>
                        </Root>
                        <SelectionModel>
                            <ext:TreeSelectionModel runat="server" />
                        </SelectionModel>
                        <Listeners>
                            <ItemClick Handler="ISEx.navigate(record.get('value'));" />
                        </Listeners>
                    </ext:TreePanel>
                </Items>
                <Buttons>
                    <ext:Button runat="server" Text="关闭菜单" Icon="ApplicationSideContract" Width="200" Padding="5">
                        <Listeners>
                            <Click Handler="#{bHome}.toggle();" />
                        </Listeners>
                    </ext:Button>
                </Buttons>
            </ext:Window>
        </Bin>
    </ext:Toolbar>
</asp:Content>
<asp:Content ID="S" ContentPlaceHolderID="S" runat="server">
    <ext:Toolbar runat="server" BorderSpec="1 0 0 0" Region="South" PaddingSpec="2 1 1 1">
        <Items>
            <ext:Button runat="server" Text="请求帮助" IconCls="icon-ISOFT" MenuArrow="false">
                <Listeners>
                    <Click Handler="window.alert('即将上线，请留意系统公告。');" />
                </Listeners>
            </ext:Button>
            <ext:ToolbarSeparator runat="server" />
            <ext:ToolbarTextItem runat="server" Text="技术支持：常州市中电通讯技术有限公司" Disabled="true" />
            <ext:ToolbarSeparator runat="server" />
            <ext:Button runat="server" ID="bUsers" Icon="Group" Text="在线人数：0">
                <Listeners>
                    <Click Handler="var x=ISEx;x.navigate('../system/onlineuser.aspx');" />
                </Listeners>
            </ext:Button>
            <ext:ToolbarFill runat="server" />
            <ext:ToolbarSeparator runat="server" />
            <ext:ToolbarTextItem runat="server" ID="bBtm" />
            <ext:ToolbarSeparator runat="server" />
            <ext:Button runat="server" ID="bHit" EnableToggle="true" Disabled="true" Icon="Application" Text="无推送">
            </ext:Button>
        </Items>
    </ext:Toolbar>
</asp:Content>
<asp:Content ID="C" ContentPlaceHolderID="C" runat="server">
    <ext:Container runat="server" ID="cMain" Region="Center" Layout="FitLayout">
        <Loader runat="server" Mode="Frame" AutoLoad="false">
            <LoadMask ShowMask="true" Msg="正在打开，请稍候.." />
        </Loader>
    </ext:Container>
</asp:Content>
<asp:Content runat="server" ID="B" ContentPlaceHolderID="B">
    <ext:Panel runat="server" ID="np1" Layout="FitLayout" Hidden="true">
        <Items>
            <ext:DataView runat="server" ID="dv1" ItemSelector="div.rec" LoadMask="false">
                <Store>
                    <ext:Store runat="server" ID="dsNF" AutoLoad="false">
                    </ext:Store>
                </Store>
                <Tpl runat="server">
                    <Html>
                        <tpl for="."></tpl>
                    </Html>
                </Tpl>
            </ext:DataView>
        </Items>
    </ext:Panel>
    <script type="text/javascript">

        ISEx.apply({
            loaded: false,
            menuData: undefined,
            his: [],
            hisCount: 50,
            hisCur: -1,
            load: function () {
                var x = ISEx;
                App.direct.LoadMenu({
                    success: function (result) {
                        try {
                            x.loaded = true;
                            x.os.winHome.showBy(x.os.bHome, "tl-bl?", [0, 6]);
                            x.menuData = X.decode(result);
                            x.os.dsT.setRootNode(X.decode(x.menuData[0][1]));
                            x.os.tpItems.expandAll();
                        } catch (e) { }
                    }
                });
            },
            resize: function (w, h) {
                var x = ISEx;
            },
            toggleMenu: function (pressed) {
                var x = ISEx;
                if (!pressed) {
                    x.os.winHome.hide();
                    return;
                }
                if (x.loaded) {
                    x.os.winHome.showBy(x.os.bHome, "tl-bl?", [0, 6]);
                } else {
                    x.load();
                }
            },
            toggleTop: function (pressed) {
                var x = ISEx;
                var c = ISEx.os.cBanner;
                if (pressed) c.hide(); else c.show();
                if (x.os.bHome.pressed) x.os.bHome.toggle();
                x.os.winHome.setHeight(x.os.cMain.getHeight() - 5);
            },
            selectMenu: function (itemId) {
                var x = ISEx;
                if (x.menuData) {
                    for (var i = 0; i < x.menuData.length; i++) {
                        if (x.menuData[i][0] === itemId) {
                            x.os.dsT.setRootNode(X.decode(x.menuData[i][1]));
                            x.os.tpItems.expandAll();
                            break;
                        }
                    }
                }
            },
            navigate: function (url, clean) {
                var x = ISEx;
                if (url === "") return;
                if (clean) {
                    if (!clean) {
                        x.os.bHome.toggle();
                    } else {
                        if (x.os.bHome.pressed) x.os.bHome.toggle();
                    }
                } else {
                    if (x.os.bHome.pressed) x.os.bHome.toggle();
                }
                x.os.cMain.load({ url: url });
            },
            back: function () {
                history.back();
            },
            forward: function () {
                history.forward();
            },
            logout: function () {
                Ext.Msg.show({
                    title: '确认',
                    msg: "退出系统，回到登录界面吗？",
                    buttons: Ext.Msg.OKCANCEL,
                    fn: function (buttonId, text, opt) {
                        if (buttonId == "ok") {
                            window.location.replace('../login.aspx?off=true');
                        }
                    },
                    icon: Ext.MessageBox.QUESTION
                });
            }
        });

        var __begin = function () {
            var x = ISEx;
            x.os.winHome.setHeight(x.os.cMain.getHeight() - 5);
            x.os.txtTime.setText(Ext.Date.format(new Date(), 'Y年m月d日 H:i'));
            x.navigate("desktop.aspx", true);
            <%= _ParentCheck ? "x.checkParent();": string.Empty %>
        }

    </script>
</asp:Content>
<script runat="server">
    
    protected bool _ParentCheck = true;
    public override void Decorate(eTaxi.Web.ExtPageDecorator decorator)
    {
        decorator
            .Register(new Control[] { cMain, winHome, bHome, cBanner, dsT, tpItems, txtTime })
            .EnableStartup("__begin")
            .Configure(rm =>
            {
                switch (Theme)
                {
                    case Themes.Office2010Blue:
                        rm.Theme = Ext.Net.Theme.Default;
                        break;
                    case Themes.Office2010Silver:
                        rm.Theme = Ext.Net.Theme.Gray;
                        break;
                    default:
                        rm.Theme = Ext.Net.Theme.Default;
                        break;
                }
            });
    }

    protected override void _BindData()
    {
        base._BindData();
        bWC.Text = string.Format("欢迎您，{0}{1}", _SessionEx.Name, string.Empty);
        bUsers.Text = string.Format("在线用户：{0}", Global.Sessions.Count().ToString());
        string btmText = string.Format("当前用户：{0}", _SessionEx.UserName);
        bBtm.Text = btmText;
    }

    protected Dictionary<string, Icon> _FolderIcons = new Dictionary<string, Icon>()
    {
        { Folder.System, Icon.Database },
        { Folder.Car, Icon.Car },
        { Folder.Driver, Icon.UserSuitBlack },
        { Folder.Business, Icon.PastePlain },
        { Folder.Query, Icon.Magnifier },
        { Folder.Workflow, Icon.ArrowSwitch }
    };

    protected Dictionary<string, Icon> _SubFolderIcons = new Dictionary<string, Icon>()
    {
        { SubFolder.Car, Icon.Folder },
        { SubFolder.Driver, Icon.Folder}
    };
    
    [DirectMethod(ShowMask = true, Msg = "正在加载菜单，请稍候..")]
    public string LoadMenu()
    {
        var context = _DTContext<CommonContext>(true);
        var acls = context.ACLs.Where(a => a.ActorId == _SessionEx.Id).ToList();
        var modules = Global.Cache.Modules.Where(m => m.IsPage).ToList();
        var folders = modules.Select(m => m.Folder).Distinct().ToList();
        var results = new List<object>();
        var mp = new MenuPanel() { Title = "主菜单", Icon = Icon.ApplicationSideList };
        var definitions = DefinitionHelper.GenerateItems<Folder>();
        var subHelper = new DefinitionItemHelper<SubFolder>();

        // 管理员不用过滤
        if (_SessionEx.UniqueId !=
            new Guid(eTaxi.Definitions.Login.AdministratorId))
        {
            modules = (
                from m in modules
                join a in acls on m.Id equals a.ModuleId
                where !a.IsForbidden
                select m).ToList();
        }
        
        definitions.ForEach(d =>
        {
            if (!folders.Any(f => f.StartsWith(d.Value.ToString()))) return;
            var item = new Ext.Net.MenuItem(d.Caption);
            item.Icon = _FolderIcons[d.Value];
            item.Listeners.Click.Handler =
                string.Format("ISEx.selectMenu('{0}');", d.Value);

            var root = new Node();
            Node node = null;
            var items = (
                from mm in modules
                where mm.Folder.StartsWith(d.Value.ToString())
                orderby mm.Ordinal, mm.Name
                select mm).ToList();

            var subFolders = items.Select(i => i.SubFolder).Distinct().ToList();
            if (subFolders.Count <= 1)
            {
                items.ForEach(s =>
                {
                    node = new Node() { Text = s.Name, Leaf = true, Icon = Icon.BulletGreen };
                    node.CustomAttributes.Add(new ConfigItem()
                    {
                        Name = "value",
                        Value = string.IsNullOrEmpty(s.Path) ? string.Empty : "../" + s.Path
                    });
                    root.Children.Add(node);
                });
            }
            else
            {
                subFolders.ForEach(f =>
                {
                    var subRoot = new Node() { Icon = Icon.Folder, Cls = "menuGroup" };
                    subHelper.GetItem(i => i.Value == f).IfNN(i =>
                        {
                            subRoot.Text = i.Caption;
                            subRoot.Icon = _SubFolderIcons[i.Value];
                        });
                    
                    var subItems = items.Where(i => i.SubFolder == f).ToList();
                    subItems.ForEach(s =>
                    {
                        node = new Node() { Text = s.Name, Leaf = true, Icon = Icon.BulletGreen };
                        node.CustomAttributes.Add(new ConfigItem()
                        {
                            Name = "value",
                            Value = string.IsNullOrEmpty(s.Path) ? string.Empty : "../" + s.Path
                        });
                        subRoot.Children.Add(node);
                    });
                    root.Children.Add(subRoot);
                });
            }

            if(root.Children.Count > 0) mp.Menu.Items.Add(item);
            results.Add(new string[] { d.Value, JSON.Serialize(root) });
        });

        if (mp.Menu.Items.Count > 0) mp.Menu.ActiveIndex = 0;
        mp.AddTo(pMenu);
        return JSON.Serialize(results);
    }

    protected override void _Execute()
    {
        _Util
            .GetRequestParameter<bool>("ck", ck => _ParentCheck = ck, true, false);
        base._Execute();
    }
    
</script>

<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.Controls.ControlLoader" %>
<asp:Button runat="server" ID="_b" Style="display: none;" />
<asp:Button runat="server" ID="___b_pack_0001" Style="display: none;" />
<dx:ASPxPopupControl runat="server" ID="p" CloseAction="CloseButton" AllowResize="true"
    ShowMaximizeButton="true" ScrollBars="Auto" ShowFooter="true" ShowShadow="true"
    AllowDragging="true" PopupHorizontalAlign="WindowCenter" Modal="true" AutoUpdatePosition="true"
    PopupVerticalAlign="WindowCenter" PopupAnimationType="None">
    <ContentStyle>
        <Paddings Padding="1" />
    </ContentStyle>
    <HeaderStyle CssClass="bar" Paddings-Padding="6" />
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="c">
            <asp:Panel runat="server" ID="pTips" CssClass="tips" Style="margin: 5px; padding: 5px;" Visible="false">
                <asp:Literal runat="server" ID="ltTips" />
            </asp:Panel>
            <asp:PlaceHolder runat="server" ID="h" />
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
<script runat="server">
    
    public bool Patched
    {
        get { return _ViewStateEx.Get<bool>("patched", false); }
        set { _ViewStateEx.Set<bool>(value, "patched"); }
    }

    private const string DEFAULT_LOADER_PATH = "~/_controls.helper/loaders/popup_dx_footer.ascx";
    public override PlaceHolder Holder { get { return h; } }
    public override Control Frame { get { return p; } }
    public override string Title { set { p.HeaderText = value; } }
    public override Unit Height { set { p.Height = value; } }
    public override Unit Width { set { p.Width = value; } }
    public override string Tips
    {
        set
        {
            if (string.IsNullOrEmpty(value))
            {
                pTips.Visible = false;
                ltTips.Text = value;
                return;
            }
            pTips.Visible = true;
            ltTips.Text = value;
        }
    }

    protected override void _SetInitialStates()
    {
        base._SetInitialStates();
        p.ClientInstanceName = ClientID + "_p";
        p.ClientSideEvents.CloseButtonClick = string.Format("function(s,e){{{0};}}",
            Page.ClientScript.GetPostBackEventReference(_b, string.Empty));
        
        _b.Click += (s, e) => Close();
        ___b_pack_0001.Click += (s, e) => { Patched = true; Show(); };
    }

    protected override void _InitializeFooter()
    {
        var controlPath = _SessionEx.Get<string>(Key_Footer, DEFAULT_LOADER_PATH);
        var useDefault = controlPath == DEFAULT_LOADER_PATH;
        var footer = new TemplateItem.BaseItem<eTaxi.Web.Controls.Loader.Footer>(controlPath, f =>
        {
            f.ID = "f";
            f.MasterLoader = this;
            if (HostingControl != null)
            {
                // 关联两个事件源
                f.ImpersonatingControl = HostingControl;
                f.EventSinked += (s, eT, e) => HostingControl.SinkEvent(eT, e);
            }
        });

        p.FooterContentTemplate = null;
        p.FooterTemplate = null;
        
        if (useDefault)
        {
            p.FooterContentTemplate = footer;
        }
        else
        {
            p.FooterTemplate = footer;
        }

        // 仅仅保留控件句柄信息
        footer.Instantiated += f => FooterControl = f;
    }

    /// <summary>
    /// 按需加载页脚（加载后，需要放入 session ）
    /// </summary>
    /// <typeparam name="TFooter"></typeparam>
    /// <param name="path"></param>
    /// <returns></returns>
    public override void LoadFooter<TFooter>(string path = null, Action<TFooter> execute = null)
    {
        var useDefault = string.IsNullOrEmpty(path);
        var controlPath = path.ToStringEx(DEFAULT_LOADER_PATH).ToLower();
        
        _SessionEx.Set(controlPath, Key_Footer);
        var footer = new TemplateItem.BaseItem<eTaxi.Web.Controls.Loader.Footer>(controlPath, f =>
        {
            f.ID = "f";
            f.MasterLoader = this;
            if (HostingControl != null)
            {
                // 关联两个事件源
                f.ImpersonatingControl = HostingControl;
                f.EventSinked += (s, eT, e) => HostingControl.SinkEvent(s, eT, e);
            }
        });

        p.FooterContentTemplate = null;
        p.FooterTemplate = null;

        if (useDefault)
        {
            p.FooterContentTemplate = footer;
        }
        else
        {
            p.FooterTemplate = footer;
        }

        LastFooterPath = controlPath;
        footer.Instantiated += f =>
        {
            if (!(f is TFooter))
                throw new ArgumentException(controlPath + " 不是要求的类型： '" + typeof(TFooter).Name + "'");
            f.Load += (s, e) =>
            {
                if (execute != null) { execute(f as TFooter); return; }
                f.Execute();
            };
        };
    }
    
    public override void Show()
    {
        p.ShowOnPageLoad = true;
        //JS("ISEx.sleep(100, function(){s.UpdateWindowPosition();s.UpdatePosition();});");
    }
    public override void Close(string message = null)
    {
        _Execute();
        
        if (string.IsNullOrEmpty(message))
        {
            p.ShowOnPageLoad = false;
            p.ClientSideEvents.Shown = string.Empty;
            Patched = false;
            return;
        }

        JS(string.Format("{0}.Show();", ClientID + "_p"));
        Alert(this, message, string.Format("{0};",
            Page.ClientScript.GetPostBackEventReference(_b, string.Empty)));
    }
    public override void JS(string snippet)
    {
        p.ClientSideEvents.Shown = string.Format("function(s,e){{{0}}}", snippet);
    }
    public override void Alert(string message, string postScript = null, bool executeBeforeAlert = false)
    {
        string pattern = "function(s,e){{alert('{0}');{1}}}";
        if (executeBeforeAlert) pattern = "{1}alert('{0}');";
        p.ClientSideEvents.Shown =
            string.Format(pattern, HttpUtility.JavaScriptStringEncode(message), postScript ?? string.Empty);
    }

    protected override void _ViewStateProcess()
    {
        p.ClientSideEvents.Shown = string.Empty;
        Action busy = () =>
        {
            Execute();
            Tips = "对不起，系统繁忙，本次操作无效。";
        };

        if (!IsPostBack) { Execute(); return; }
        if (LastContentPath != _SessionEx.Get<string>(Key, string.Empty)) { busy(); return; }
        if (LastFooterPath != _SessionEx.Get<string>(Key_Footer, string.Empty)) { busy(); return; }
    }

    public override void PACK_0001()
    {
        if (Patched) return;

        p.ShowOnPageLoad = false;
        p.ClientSideEvents.Shown = string.Empty;
        Patched = false;
        
        string js = Page.ClientScript.GetPostBackEventReference(___b_pack_0001, string.Empty) + ";";
        JS(js + "ISEx.loadingPanel.show();");
    }
    
</script>



<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.Controls.Loader.Footer" %>
<%@ Import Namespace="eTaxi.Web.Controls" %>
<table>
    <tr>
        <td runat="server" id="tdSubmit">
            <dx:ASPxButton runat="server" ID="bSubmit">
                <Image Url="~/images/_op_flatb_submit.gif" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdSave">
            <dx:ASPxButton runat="server" ID="bSave">
                <Image Url="~/images/_op_flatb_save.gif" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdOK">
            <dx:ASPxButton runat="server" ID="bOK">
                <Image Url="~/images/_op_flatb_tick.gif" />
                <ClientSideEvents Click="function(s,e){}" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdReload">
            <dx:ASPxButton runat="server" ID="bReload">
                <Image Url="~/images/_op_flatb_refresh.gif" />
                <ClientSideEvents Click="function(s,e){}" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdYes">
            <dx:ASPxButton runat="server" ID="bYes">
                <Image Url="~/images/_op_flatb_tick.gif" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdNo">
            <dx:ASPxButton runat="server" ID="bNo">
                <Image Url="~/images/_op_flatb_cross.gif" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdCancel">
            <dx:ASPxButton runat="server" ID="bCancel">
                <Image Url="~/images/_op_flatb_cancel.gif" />
                <ClientSideEvents Click="function(s,e){ISEx.loadingPanel.show();}" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdPrevious">
            <dx:ASPxButton runat="server" ID="bPrevious">
                <Image Url="~/images/icons/previous.png" />
            </dx:ASPxButton>
        </td>
        <td runat="server" id="tdNext">
            <dx:ASPxButton runat="server" ID="bNext">
                <Image Url="~/images/icons/next.png" />
            </dx:ASPxButton>
        </td>
    </tr>
</table>
<script runat="server">
    
    /// <summary>
    /// 用于提示用户的校验错误提示
    /// </summary>
    public string ValidationFailTips
    {
        get
        {
            return "操作不成功。数据填报不完整，请检查（特别是带红线标注的框框）。";
        }
    }

    private Dictionary<EventTypes, ASPxButton> _Buttons = new Dictionary<EventTypes, ASPxButton>();
    private Dictionary<EventTypes, HtmlTableCell> _Cells = new Dictionary<EventTypes, HtmlTableCell>();
    private Dictionary<EventTypes, ControlLoader.Button> _DefaultSettings = new Dictionary<EventTypes, ControlLoader.Button>()
    {
        { EventTypes.Cancel, new ControlLoader.Button(){ Visible = true, Text = "关闭" } },
        { EventTypes.Yes, new ControlLoader.Button(){ Visible = false, Text = "同意" } },
        { EventTypes.No, new ControlLoader.Button(){ Visible = false, Text = "驳回" } },
        { EventTypes.Submit, new ControlLoader.Button(){ Visible = false, Text = "提交" } },
        { EventTypes.OK, new ControlLoader.Button(){ Visible = false, Text = "确定" } },
        { EventTypes.Save, new ControlLoader.Button(){ Visible = false, Text = "保存" } },
        { EventTypes.Next, new ControlLoader.Button(){ Visible = false, Text = "下一个" } },
        { EventTypes.Previous, new ControlLoader.Button(){ Visible = false, Text = "上一个" } },
        { EventTypes.Reload, new ControlLoader.Button(){ Visible = false, Text = "重新加载" } }
    };

    private void _Initialize()
    {
        _Buttons = new Dictionary<EventTypes, ASPxButton>()
        {
            { EventTypes.Cancel, bCancel },
            { EventTypes.Yes, bYes },
            { EventTypes.No, bNo },
            { EventTypes.Submit, bSubmit },
            { EventTypes.OK, bOK },
            { EventTypes.Save, bSave },
            { EventTypes.Next, bNext },
            { EventTypes.Previous, bPrevious },
            { EventTypes.Reload, bReload }
        };

        _Cells = new Dictionary<EventTypes, HtmlTableCell>()
        {
            { EventTypes.Cancel, tdCancel },
            { EventTypes.Yes, tdYes },
            { EventTypes.No, tdNo },
            { EventTypes.Submit, tdSubmit },
            { EventTypes.OK, tdOK },
            { EventTypes.Save, tdSave },
            { EventTypes.Next, tdNext },
            { EventTypes.Previous, tdPrevious },
            { EventTypes.Reload, tdReload }
        };        
    }
    
    protected override void _SetInitialStates()
    {
        _Initialize();
        _Buttons.ForEach(kv => kv.Value.Click += (s, e) =>
        {
            if (kv.Key == EventTypes.Cancel) MasterLoader.Close();
            SinkEvent(this, kv.Key);
        });

        _SetDefault();
    }

    protected override void _Execute()
    {
        _Initialize();
        _Cells.ForEach(kv => kv.Value.Visible = kv.Key == EventTypes.Cancel);
        _Buttons.ForEach(kv => _SetButton(kv.Value, _DefaultSettings[kv.Key]));
        if (_ButtonSettings.Count > 0)
        {
            _ButtonSettings.ForEach(kv =>
            {
                if (!_Buttons.ContainsKey(kv.Key)) return;
                _SetButton(_Buttons[kv.Key], kv.Value);
                _Cells[kv.Key].Visible = kv.Value.Visible;
            });
            return;
        }

        // 如果没有配置信息，则保留一个“关闭按钮”
        _SetDefault();
    }

    /// <summary>
    /// 默认设置（一个关闭按钮，关掉弹窗）
    /// </summary>
    private void _SetDefault()
    {
        _Cells[EventTypes.Cancel].Visible = true;
        _SetButton(_Buttons[EventTypes.Cancel], _DefaultSettings[EventTypes.Cancel]);
    }

    /// <summary>
    /// 将 button 参数放入具体的按钮
    /// </summary>
    /// <param name="button"></param>
    /// <param name="param"></param>
    private void _SetButton(ASPxButton button, ControlLoader.Button param)
    {
        string group = string.Empty;
        if (ImpersonatingControl != null) group = ImpersonatingControl.ClientID;
        if (!string.IsNullOrEmpty(group)) button.ValidationGroup = group;
        if (!string.IsNullOrEmpty(param.Text)) button.Text = param.Text;
        button.Visible = param.Visible;
        button.CausesValidation = param.CausesValidation;
        if (!string.IsNullOrEmpty(param.ImageFile)) button.ImageUrl = "~/images/" + param.ImageFile;
        if (!string.IsNullOrEmpty(param.JSHandle))
        {
            button.ClientSideEvents.Click = string.Format("function(s,e){{{0}}}", param.JSHandle);
            return;
        }
        if (!string.IsNullOrEmpty(param.ConfirmText))
        {
            if (param.CausesValidation)
            {
                button.ClientSideEvents.Click = string.Format(
                    "function(s,e){{if({0}()){{e.processOnServer=confirm('{1}');if(e.processOnServer)ISEx.loadingPanel.show({2});}}else{{e.processOnServer=false;alert('{3}');}}}}",
                    string.IsNullOrEmpty(param.ConfirmJSFunc) ? "ASPxClientEdit.AreEditorsValid" : param.ConfirmJSFunc,
                    HttpUtility.HtmlEncode(param.ConfirmText),
                    string.IsNullOrEmpty(param.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(param.LoadingText) + "'",
                    ValidationFailTips);
            }
            else
            {
                if (string.IsNullOrEmpty(param.ConfirmJSFunc))
                {
                    button.ClientSideEvents.Click = string.Format(
                        "function(s,e){{e.processOnServer=confirm('{0}');if(e.processOnServer)ISEx.loadingPanel.show({1});}}",
                        HttpUtility.HtmlEncode(param.ConfirmText),
                        string.IsNullOrEmpty(param.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(param.LoadingText) + "'");
                }
                else
                {
                    button.ClientSideEvents.Click = string.Format(
                        "function(s,e){{if(!{0}())e.processOnServer=false;else{{e.processOnServer=confirm('{1}');if(e.processOnServer)ISEx.loadingPanel.show({2});}}}}",
                        param.ConfirmJSFunc, HttpUtility.HtmlEncode(param.ConfirmText),
                        string.IsNullOrEmpty(param.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(param.LoadingText) + "'");
                }
            }
        }
        else
        {
            if (param.CausesValidation)
            {
                button.ClientSideEvents.Click = string.Format(
                    "function(s,e){{e.processOnServer={0}();if(e.processOnServer)ISEx.loadingPanel.show({1});else alert('{2}');}}",
                    string.IsNullOrEmpty(param.ConfirmJSFunc) ? "ASPxClientEdit.AreEditorsValid" : param.ConfirmJSFunc,
                    string.IsNullOrEmpty(param.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(param.LoadingText) + "'",
                    ValidationFailTips);
            }
            else
            {
                if (string.IsNullOrEmpty(param.ConfirmJSFunc))
                {
                    button.ClientSideEvents.Click = string.Format(
                        "function(s,e){{ISEx.loadingPanel.show({0});}}",
                        string.IsNullOrEmpty(param.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(param.LoadingText) + "'");
                }
                else
                {
                    button.ClientSideEvents.Click = string.Format(
                        "function(s,e){{e.processOnServer={0}();if(e.processOnServer)ISEx.loadingPanel.show({1});}}",
                        param.ConfirmJSFunc,
                        string.IsNullOrEmpty(param.LoadingText) ? string.Empty : "'" + HttpUtility.HtmlEncode(param.LoadingText) + "'");
                }
            }
        }
    }

</script>

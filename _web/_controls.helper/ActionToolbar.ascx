<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.Controls.ActionToolbar" CodeBehind="ActionToolbar.ascx.cs" %>
<%@ Import Namespace="eTaxi.Web.Controls" %>
<div class="actionTB">
    <table>
        <tr>
            <td runat="server" id="tdSubmit">
                <dx:ASPxButton runat="server" ID="bSubmit">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_submit.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdSave">
                <dx:ASPxButton runat="server" ID="bSave">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_save.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdOK">
                <dx:ASPxButton runat="server" ID="bOK">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_tick.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdYes">
                <dx:ASPxButton runat="server" ID="bYes">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_tick.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdNo">
                <dx:ASPxButton runat="server" ID="bNo">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_cross.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdReload">
                <dx:ASPxButton runat="server" ID="bReload">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_refresh.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdPrevious">
                <dx:ASPxButton runat="server" ID="bPrevious">
                    <Paddings Padding="0" />
                    <Image Url="~/images/icons/previous.png" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdNext">
                <dx:ASPxButton runat="server" ID="bNext">
                    <Paddings Padding="0" />
                    <Image Url="~/images/icons/next.png" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdPrint">
                <dx:ASPxButton runat="server" ID="bPrint">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_print.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdExport">
                <dx:ASPxButton runat="server" ID="bExport">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_send.gif" />
                </dx:ASPxButton>
            </td>
            <td runat="server" id="tdCancel">
                <dx:ASPxButton runat="server" ID="bCancel">
                    <Paddings Padding="0" />
                    <Image Url="~/images/_op_flatb_cancel.gif" />
                </dx:ASPxButton>
            </td>
        </tr>
    </table>
</div>
<script runat="server">

    public override string ValidationFailTips
    {
        get
        {
            return "操作不成功。数据填报不完整，请检查（特别是带红线标注的框框）。";
        }
    }

    public override ActionToolbar Initialize(Action<ActionToolbar.Configurator> config, string valiationGroup = null)
    {
        _ValidationGroup = valiationGroup;
        return Initialize(this, config);
    }
    
    public override ActionToolbar Initialize(BaseControl control, Action<ActionToolbar.Configurator> config)
    {
        _Buttons.Clear();
        _Buttons.Add(BaseControl.EventTypes.Cancel, new ControlLoader.Button() { Visible = false, Text = "取消", CausesValidation = false });
        _Buttons.Add(BaseControl.EventTypes.No, new ControlLoader.Button() { Visible = false, Text = "驳回", CausesValidation = true });
        _Buttons.Add(BaseControl.EventTypes.OK, new ControlLoader.Button() { Visible = false, Text = "确定", CausesValidation = true });
        _Buttons.Add(BaseControl.EventTypes.Reload, new ControlLoader.Button() { Visible = false, Text = "重置", CausesValidation = false });
        _Buttons.Add(BaseControl.EventTypes.Save, new ControlLoader.Button() { Visible = false, Text = "保存", CausesValidation = true });
        _Buttons.Add(BaseControl.EventTypes.Submit, new ControlLoader.Button() { Visible = false, Text = "提交", CausesValidation = true });
        _Buttons.Add(BaseControl.EventTypes.Yes, new ControlLoader.Button() { Visible = false, Text = "同意", CausesValidation = true });
        _Buttons.Add(BaseControl.EventTypes.Next, new ControlLoader.Button() { Visible = false, Text = "下一个", CausesValidation = false });
        _Buttons.Add(BaseControl.EventTypes.Previous, new ControlLoader.Button() { Visible = false, Text = "上一个", CausesValidation = false });
        _Buttons.Add(BaseControl.EventTypes.Print, new ControlLoader.Button() { Visible = false, Text = "打印", CausesValidation = false });
        _Buttons.Add(BaseControl.EventTypes.Export, new ControlLoader.Button() { Visible = false, Text = "导出", CausesValidation = false });

        _HostingControl = control ?? this;
        if (string.IsNullOrEmpty(_ValidationGroup)) _ValidationGroup = _HostingControl.ClientID;
        if (config != null)
        {
            ActionToolbar.Configurator c = new Configurator(this);
            config(c);
        }

        _SetButtons();
        tdCancel.Visible = _Buttons[EventTypes.Cancel].Visible;
        tdNo.Visible = _Buttons[EventTypes.No].Visible;
        tdOK.Visible = _Buttons[EventTypes.OK].Visible;
        tdReload.Visible = _Buttons[EventTypes.Reload].Visible;
        tdSave.Visible = _Buttons[EventTypes.Save].Visible;
        tdSubmit.Visible = _Buttons[EventTypes.Submit].Visible;
        tdYes.Visible = _Buttons[EventTypes.Yes].Visible;
        tdNext.Visible = _Buttons[EventTypes.Next].Visible;
        tdPrevious.Visible = _Buttons[EventTypes.Previous].Visible;
        tdPrint.Visible = _Buttons[EventTypes.Print].Visible;
        tdExport.Visible = _Buttons[EventTypes.Export].Visible;

        bCancel.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Cancel);
        bNo.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.No);
        bOK.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.OK);
        bReload.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Reload);
        bSave.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Save);
        bSubmit.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Submit);
        bYes.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Yes);
        bNext.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Next);
        bPrevious.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Previous);
        bPrint.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Print);
        bExport.Click += (s, e) => _HostingControl.SinkEvent(EventTypes.Export);

        return this;
    }

</script>

<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MultiRequester.ascx.cs" Inherits="eTaxi.Web.Controls.MultiRequester" %>
<dx:ASPxPopupControl runat="server" ID="p" CloseAction="CloseButton" AllowResize="true"
    ShowMaximizeButton="true" ScrollBars="Auto" ShowFooter="true" ShowShadow="true"
    AllowDragging="true" PopupHorizontalAlign="WindowCenter" Modal="true" AutoUpdatePosition="true"
    PopupVerticalAlign="WindowCenter" PopupAnimationType="None">
    <HeaderStyle CssClass="bar" Paddings-Padding="6" />
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="c">
            <asp:Button runat="server" ID="b" Style="display: none;" />
            <asp:Button runat="server" ID="bC" Style="display: none;" />
            <asp:HiddenField runat="server" ID="hd" Value="0" />
            <table class="form">
                <tr>
                    <td colspan="2">
                        <div class="info" style="padding: 10px; margin-bottom: 10px;">
                            您好，本批次共包含
                            <asp:Label runat="server" ID="lbTotal" Font-Size="Large" ForeColor="Red" />
                            个任务，请注意：
                            <br />
                            <br />
                            <ul>
                                <li>点击“开始”执行批处理任务；
                                </li>
                                <li>在任务执行过程中，不要随意关闭浏览器或访问其他页面；
                                </li>
                                <li>如果您需要终止批处理，请点击“取消”按钮，并留意系统提示多少个任务已经执行。
                                </li>
                            </ul>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <dx:ASPxProgressBar runat="server" ID="pb" Width="100%" />
                    </td>
                </tr>
                <tr>
                    <td class="val" colspan="2">
                        <dx:ASPxLabel runat="server" ID="lbTask" Text="&nbsp;" />
                    </td>
                </tr>
            </table>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
<script runat="server">

    /// <summary>
    /// 缓存主要的方法
    /// </summary>
    private Func<object[], bool> _Go = null;
    private Func<object[], string> _Describe = null;
    private Action _Done = null;
    private Action _Abort = null;
    private ASPxButton _ButtonOK = null;
    private ASPxButton _ButtonCancel = null;
    
    private void _Next()
    {
        Index++;
        if (Index >= Total)
        {
            if (_Done != null) _Done();
            pb.Value = Total;
            Reset();
            lbTask.Text = "完成";
            p.ShowOnPageLoad = false;
            return;
        }
        
        pb.Value = Index;
        string js = string.Empty;
        string cb = Page.ClientScript.GetPostBackEventReference(b, string.Empty) + ";";
        string cbX = Page.ClientScript.GetPostBackEventReference(bC, string.Empty) + ";";
        if (hd.Value == "0")
        {
            js = cb;
        }
        else
        {
            js = string.Format(
                @"if(confirm('终止批任务吗？（提示：已经执行了‘{0}’个）')){{{2}}}else{{$get('{1}').value='0';{3}}}",
                Index.ToString(), hd.ClientID, cbX, cb);
        }

        JS(js);
    }

    public override void Initialize(Func<object[], bool> go,
        Func<object[], string> taskDescribe, Action done = null, Action abort = null)
    {
        _Go = go;
        _Done = done;
        _Describe = taskDescribe;

        b.Click += (s, e) =>
        {
            List<object> tasks = _SessionEx.TKObjectManager.Get<List<object>>(TicketId);

            // 获取批次

            List<object> batch = new List<object>();
            for (int i = 0; i < BatchSize; i++)
            {
                if (Index < tasks.Count)
                {
                    batch.Add(tasks[Index]);
                    Index++;
                }
                else
                {
                    break;
                }
            }

            var t = tasks[Index - 1];
            lbTask.Text = "正在处理：" + t.ToString();
            if (_Describe != null) lbTask.Text = "正在处理：" + _Describe(batch.ToArray());
            if (_Go(batch.ToArray()))
            {
                _Next();
            }
            else
            {
            }
        };

        bC.Click += (s, e) =>
        {
            if (_Abort != null) _Abort();
            _ButtonOK.Enabled = true;
            hd.Value = "0";
        };

        p.FooterContentTemplate = new TemplateItem.BaseItem<BaseControl>(
            "~/controls.helper/multirequester_footer.ascx", f =>
        {
            _ButtonOK = f.FindControl("bOK") as ASPxButton;
            _ButtonCancel = f.FindControl("bCancel") as ASPxButton;
            f.EventSinked += (s, eType, param) =>
            {
                switch (eType)
                {
                    case EventTypes.OK:
                        _ButtonOK.Enabled = false;
                        _Next();
                        break;
                    case EventTypes.Cancel:
                        if (_ButtonOK.Enabled)
                        {
                            Reset();
                            p.ShowOnPageLoad = false;
                        }
                        else
                        {
                            hd.Value = "1";
                            _Next();
                        }
                        break;
                }
            };
        });
    }

    public override void Execute(Action<List<object>> tasksSet, string name)
    {
        Reset();
        List<object> list = new List<object>();
        if (tasksSet != null) tasksSet(list);
        Index = -1;
        Total = list.Count;
        TicketId = _SessionEx.TKObjectManager.RegManual(list);

        // 

        lbTotal.Text = Total.ToString();
        pb.Minimum = 0;
        pb.Maximum = Total;

        // 

        p.ShowOnPageLoad = true;
        Name = name;
    }

    public override void Reset()
    {
        _SessionEx.TKObjectManager.Remove(TicketId);
        Index = -1;
        Total = 0;

        pb.Minimum = pb.Maximum = 0;
        pb.Value = null;
        hd.Value = "0";
        lbTask.Text = string.Empty;
        _ButtonOK.Enabled = true;
    }
    
</script>

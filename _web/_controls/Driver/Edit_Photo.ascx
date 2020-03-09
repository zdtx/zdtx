<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Import Namespace="System.IO" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
<div class="photo">
    <asp:Image runat="server" ID="img" AlternateText="照片" Width="210" />
</div>
<div class="text">
    <dx:ASPxButton ID="bTake" runat="server" Text="拍照" />
    <dx:ASPxButton ID="bUp" runat="server" Text="上传" />
    <dx:ASPxButton ID="bReset" runat="server" Text="重来" />
</div>
<script runat="server">

    private string _NewId
    {
        get { return _ViewStateEx.Get<string>("newId", null); }
        set { _ViewStateEx.Set<string>(value, "newId"); }
    }

    private const string DEFAULT_URL = "~/images/customer.png";
    private bool _IsCreating { get { return _ViewStateEx.Get<bool>(DataStates.IsCreating, false); } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Driver.Edit_Photo; } }
    protected override void _SetInitialStates()
    {
        bTake.Click += (s, e) =>
        {
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
        };

        bUp.Click += (s, e) =>
        {
            pop.PACK_0001();
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
        };

        bReset.Click += (s, e) => Execute();

        pop.EventSinked += (c, eType, parm) =>
        {
            c.If<eTaxi.Web.Controls.Flashcam>(cc =>
            {
                if (eType != EventTypes.OK) return;
                img.Width = 220;
                img.ImageUrl = string.Format("~{0}/file/{1}.jpg", Parameters.Tempbase, cc.ObjectId);
                _NewId = cc.ObjectId;
                pop.Close();
            });

            if (c.ModuleId == Sys.Upload_Photo)
            {
                if (eType != EventTypes.OK) return;
                if (c.Do(Actions.Save, false))
                {
                    var objectId = c.ViewStateEx.Get<string>(DataStates.ObjectId);
                    img.Width = 220;
                    img.ImageUrl = string.Format("~{0}/file/{1}.jpg", Parameters.Tempbase, objectId);
                    _NewId = objectId;
                    pop.Close();
                }
            }
        };

    }

    protected override void _Execute()
    {
        _NewId = null;
        if (_IsCreating)
        {
            img.Width = Unit.Empty;
            img.ImageUrl = DEFAULT_URL;
        }
        else
        {
            img.Width = 220;
            img.ImageUrl = string.Format("~{0}/{1}.jpg", Parameters.Filebase, _ObjectId);
        }
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        if (string.IsNullOrEmpty(_NewId)) return;
        
        // 将 temp 目录 文件放入 同名 id
        var file = Util.GetPhysicalPath(
            string.Format("{0}/file/{1}.jpg", Parameters.Tempbase, _NewId));
        var newFile = Util.GetPhysicalPath(
            string.Format("{0}/{1}.jpg", Parameters.Filebase, _ObjectId));
        File.Copy(file, newFile, true);
    }

</script>

<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Import Namespace="System.IO" %>
<%@ Register Src="~/_controls.helper/Uploader_DX.ascx" TagPrefix="uc1" TagName="Uploader_DX" %>
<asp:Panel runat="server" ID="pAddnew" CssClass="tips" Style="padding: 5px; margin: 1px;">
    请选择文件
</asp:Panel>
<uc1:Uploader_DX runat="server" ID="u" Width="300" />
<script runat="server">

    /// <summary>
    /// 缓存
    /// </summary>
    private List<KeyValuePair<Guid, UploadedFileWrapper>> _Files = new List<KeyValuePair<Guid, UploadedFileWrapper>>();
    public List<KeyValuePair<Guid, UploadedFileWrapper>> Files { get { return _Files; } }
    public override string ModuleId { get { return Car.Contract_Upload; } }
    private bool _Uploaded
    {
        get { return _ViewStateEx.Get<bool>("uploaded", false); }
        set { _ViewStateEx.Set<bool>(value, "uploaded"); }
    }

    protected override void _SetInitialStates()
    {
        u.ClientInstanceName = ClientID;
        u.TextChangeHandle = string.Format(
            "$get('{0}').innerText='文件已经选定，请点击 “上传” 按钮。';", pAddnew.ClientID);
        u.Config();
        u.MultiFilesEnabled = false;
        u.ObjectId = Guid.NewGuid();
    }

    protected override void _ViewStateProcess()
    {
        base._ViewStateProcess();
        u.Uploading(fs =>
        {
            Files.Clear();
            Files.AddRange(fs);
        });
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        if(Files.Count == 0)
        {
            throw new Exception("上传文件未送达，这可能是浏览器兼容性问题，请再选择一次");
        }

        var f = Files[0];
        var extension = System.IO.Path.GetExtension(f.Value.FileName);
        
        _ViewStateEx.Set(f.Key.ToISFormatted(), DataStates.ObjectId);
        _ViewStateEx.Set(f.Value.FileName, DataStates.Detail);
        _ViewStateEx.Set(extension, DataStates.Selected);

        var file = Util.GetPhysicalPath(
            string.Format("{0}/file/{1}{2}", Parameters.Tempbase, f.Key.ToISFormatted(), extension));
        using (var fs = new FileStream(file, FileMode.Create))
        {
            fs.Write(f.Value.Content, 0, f.Value.Content.Length);
            fs.Close();
        }
    }

</script>

<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Uploader_DX.ascx.cs" Inherits="eTaxi.Web.Controls.Uploader_DX" %>
<dx:ASPxUploadControl runat="server" ID="u"
    OnFileUploadComplete="u_FileUploadComplete" 
    OnFilesUploadComplete="u_FilesUploadComplete" ShowUploadButton="false"
    FileUploadMode="OnPageLoad" NullText="选择文件">
    <AddButton Text="上传多个文件" />
    <BrowseButton Text="选择文件" />
    <RemoveButton Text="移除" />
</dx:ASPxUploadControl>
<script runat="server">

    protected void u_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
    {
        if (!e.UploadedFile.IsValid) return;
        List<KeyValuePair<Guid, UploadedFileWrapper>> files =
            _SessionEx.Get<List<KeyValuePair<Guid, UploadedFileWrapper>>>(
            ClientID + "." + States.Files, new List<KeyValuePair<Guid, UploadedFileWrapper>>());
        if (MultiFilesEnabled)
        {
            // e.UploadedFile.SaveAs(path, true);
            files.Add(new KeyValuePair<Guid, UploadedFileWrapper>(
                Guid.NewGuid(), new UploadedFileWrapper(e.UploadedFile, e.UploadedFile.FileBytes)));
        }
        else
        {
            files.Clear();
            files.Add(new KeyValuePair<Guid, UploadedFileWrapper>(
                ObjectId, new UploadedFileWrapper(e.UploadedFile, e.UploadedFile.FileBytes)));
        }
        _SessionEx.Set(files, ClientID + "." + States.Files);
    }

    protected void u_FilesUploadComplete(object sender, FilesUploadCompleteEventArgs e)
    {
    }
    
</script>

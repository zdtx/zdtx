using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress.Web;
using eTaxi.L2SQL;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 缓存文件定义
    /// </summary>
    public class UploadedFileWrapper
    {
        /// <summary>
        /// 文件存储路径（如果非空）
        /// </summary>
        public string Path { get { return _Path; } }
        private string _Path = string.Empty;

        /// <summary>
        /// 文件内容
        /// </summary>
        public byte[] Content { get { return _Content; } }
        private byte[] _Content = new byte[] { };

        private UploadedFile _File = null;
        public UploadedFile File { get { return _File; } }
        public string FileName { get { return _File.FileName; } }
        public long ContentLength { get { return _File.ContentLength; } }
        public string ContentType { get { return _File.ContentType; } }
        public Stream Stream { get { return _File.FileContent; } }

        public UploadedFileWrapper(UploadedFile postedFile, byte[] copyedContent) { _File = postedFile; _Content = copyedContent; }
        public UploadedFileWrapper(UploadedFile postedFile, string path) { _File = postedFile; _Path = path; }
    }

    /// <summary>
    /// 由于 DevExpress 的特殊性
    /// 需要 Session 配合上传控件执行值的回传
    /// </summary>
    public partial class Uploader_DX : BaseControl
    {
        public class States
        {
            public const string Files = "files";
            public const string Id = "id";
        }

        public Unit Width { set { u.Width = value; } }
        public UploadControlFileUploadMode FileUploadMode { set { u.FileUploadMode = value; } }
        public bool ShowProgressPanel { set { u.ShowProgressPanel = value; } }
        public string NullText { set { u.NullText = value; } }
        public bool ShowClearFileSelectionButton { set { u.ShowClearFileSelectionButton = value; } }
        public string ClientInstanceName { set { u.ClientInstanceName = value; } }

        /// <summary>
        /// 主控对象 Id
        /// </summary>
        public Guid ObjectId
        {
            set { _SessionEx.Set<Guid>(value, ClientID + "." + States.Id); }
            get { return _SessionEx.Get<Guid>(ClientID + "." + States.Id); }
        }

        private string _TextChangeHandle = string.Empty;
        public string TextChangeHandle
        {
            get { return _TextChangeHandle; }
            set { _TextChangeHandle = value; }
        }

        private bool _MultiFilesEnabled = false;
        public bool MultiFilesEnabled
        {
            get { return _MultiFilesEnabled; }
            set { _MultiFilesEnabled = value; }
        }

        public void Config()
        {
            if (_MultiFilesEnabled)
            {
                u.ShowAddRemoveButtons = true;
            }

            string handle = string.Empty;
            if (!
                string.IsNullOrEmpty(_TextChangeHandle))
                handle += _TextChangeHandle;
            if (!
                string.IsNullOrEmpty(handle))
                u.ClientSideEvents.TextChanged =
                    string.Format("function(s,e){{{0}}}", handle);
        }

        /// <summary>
        /// 获得上传文件句柄
        /// </summary>
        /// <param name="handle"></param>
        /// <returns></returns>
        public bool Uploading(Action<List<KeyValuePair<Guid, UploadedFileWrapper>>> handle = null)
        {
            string key = ClientID + "." + States.Files;
            if (!_SessionEx.Contains(key)) return false;
            var files = _SessionEx.Get<List<KeyValuePair<Guid, UploadedFileWrapper>>>(key);
            _SessionEx.Remove(key);
            if (handle != null) handle(files);
            return true;
        }

    }

}
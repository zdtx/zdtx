using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace eTaxi
{
    public partial class Parameters
    {
        /// <summary>
        /// 默认界面语言：中文简体
        /// </summary>
        public const string UICulture = "zh-HANS";
        /// <summary>
        /// 默认使用习惯（区域）：中国大陆
        /// </summary>
        public const string Culture = "zh-CN";
        /// <summary>
        /// 文件库的位置
        /// </summary>
        public const string Filebase = "/____files";
        /// <summary>
        /// 临时目录
        /// </summary>
        public const string Tempbase = "/____temp";
        /// <summary>
        /// 可经由 NTKO 打开的文档
        /// </summary>
        public const string NTKODocuments = ".doc;.docx;.xls;.xlsx;.ppt;.pptx;";
        /// <summary>
        /// 当前应用程序归属的文件目录
        /// </summary>
        public static string SitePath = string.Empty;
        /// <summary>
        /// 默认多条记录数显示的时候单页显示的记录数
        /// </summary>
        public const int DefaultPageSize = 20;
        /// <summary>
        /// 默认内部应用
        /// </summary>
        public const string ApplicationName = "/";
    }
}
using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Globalization;

using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 为 web 的处理提供方法集合
    /// </summary>
    public static partial class Util
    {
        /// <summary>
        /// 为客户端写出文件
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="response"></param>
        public static void ResponseWithFile(string filePath, HttpResponse response, string fileName = null)
        {
            int size = 1024;
            byte[] buffer = new byte[size];
            int startIndex = 0;
            int actualRead = 0;
            using (var fs = File.Open(
                filePath, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                response.Clear();
                if (!
                    string.IsNullOrEmpty(fileName))
                    response.AddHeader("content-disposition", "attachment;filename=" + fileName);

                // 添加头信息，指定文件大小，让浏览器能够显示下载进度
                response.AddHeader("content-length", fs.Length.ToString());
                // response.ContentType = "application/octet-stream";

                while ((actualRead = fs.Read(buffer, startIndex, size)) > 0)
                {
                    response.OutputStream.Write(buffer, 0, actualRead);
                    response.Flush();
                }
            }
            response.Close();
            response.End();
        }

        /// <summary>
        /// 为客户端写出文本流
        /// </summary>
        /// <param name="filePath"></param>
        /// <param name="response"></param>
        public static void ResponseWithText(string content, HttpResponse response, string fileName = null)
        {
            int size = 1024;
            byte[] buffer = new byte[size];
            int startIndex = 0;
            int actualRead = 0;
            using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(content)))
            {
                response.Clear();
                if (!
                    string.IsNullOrEmpty(fileName))
                    response.AddHeader("content-disposition", "attachment;filename=" + fileName);
                response.ContentType = "application/octet-stream";
                response.AddHeader("content-length", ms.Length.ToString());
                while ((actualRead = ms.Read(buffer, startIndex, size)) > 0)
                {
                    response.OutputStream.Write(buffer, 0, actualRead);
                    response.Flush();
                }
            }

            response.Close();
            response.End();
        }

        #region HTML 

        /// <summary>
        /// 标注红或者蓝
        /// </summary>
        /// <param name="text"></param>
        /// <param name="makeRed"></param>
        /// <returns></returns>
        public static string ColorMarkup(string text, bool enabled, bool makeRed)
        {
            if (!enabled) return text;
            if (makeRed) return string.Format("<span class='fonRed'>{0}</span>", text);
            return string.Format("<span class='fonGreen'>{0}</span>", text);
        }

        #endregion

    }
}
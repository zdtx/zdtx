using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Globalization;

namespace eTaxi.Web
{
    /// <summary>
    /// ExportExcel 的摘要说明
    /// </summary>
    public class ExportExcel
    {
        /// <summary>
        /// 纯数据导出
        /// </summary>
        /// <param name="exportFileName"></param>
        /// <param name="_data"></param>
        /// <returns></returns>
        public bool ExportExcelData(string serverPath, string exportFileName, DataSet _data)
        {
            //string serverPath = @"http://" + Context.Request.Url.Host + Context.Request.ApplicationPath;
            //string _strPath = Server.MapPath(Context.Request.ApplicationPath) + "/DownLoadDir/";

            // string serverPath = AppDomain.CurrentDomain.BaseDirectory;
            string _strPath = serverPath + "____temp\\Export\\";

            if (!Directory.Exists(_strPath))
            {
                Directory.CreateDirectory(_strPath);
            }
            if (exportFileName == null || exportFileName.Trim() == "")
            {
                exportFileName = DateTime.Now.ToString("s", DateTimeFormatInfo.InvariantInfo).Replace("-", "").Replace(":", "").Replace("T", "");
            }
            string _fileName = exportFileName + ".xls";
            _strPath += _fileName;
            _strPath = _strPath.Replace('\\', '/');

            DataSet _dsCopy = _data.Copy();
            DataSet _Newdata = new DataSet();
            _Newdata.Tables.Add();
            for (int i = _dsCopy.Tables[0].Columns.Count - 1; i >= 0; i--)
            {
                DataColumn myCol = _dsCopy.Tables[0].Columns[i];

                if (_dsCopy.Tables[0].Columns[i].Caption != "")
                {
                    myCol.ColumnName = myCol.Caption;
                }
                else
                {
                    _dsCopy.Tables[0].Columns.RemoveAt(i);
                }
            }
            _dsCopy.AcceptChanges();
            _dsCopy.Tables[0].PrimaryKey = null;
            BuildExcel(_dsCopy, _strPath);

            return true;
        }

        /// <summary>
        /// 纯数据导出
        /// </summary>
        /// <param name="exportFileName"></param>
        /// <param name="_data"></param>
        /// <returns></returns>
        public bool ExportExcelData(string serverPath, string exportFileName, DataTable _datadt)
        {
            if (!Directory.Exists(serverPath))
            {
                Directory.CreateDirectory(serverPath);
            }
            if (exportFileName == null || exportFileName.Trim() == "")
            {
                exportFileName = DateTime.Now.ToString("s", DateTimeFormatInfo.InvariantInfo).Replace("-", "").Replace(":", "").Replace("T", "");
            }

            var filename = exportFileName;
            if (!
                filename.EndsWith(".xls")) filename = filename + ".xls";
            var path = serverPath;
            if (!
                path.EndsWith("\\")) path = path + "\\";
            filename = path + filename;

            DataTable _dtCopy = _datadt.Copy();
            DataSet _Newdata = new DataSet();
            _Newdata.Tables.Add();
            for (int i = _dtCopy.Columns.Count - 1; i >= 0; i--)
            {
                DataColumn myCol = _dtCopy.Columns[i];

                if (_dtCopy.Columns[i].Caption != "")
                {
                    myCol.ColumnName = myCol.Caption;
                }
                else
                {
                    _dtCopy.Columns.RemoveAt(i);
                }
            }
            _dtCopy.AcceptChanges();
            _dtCopy.PrimaryKey = null;
            DataSet ds = new DataSet();
            ds.Tables.Add(_dtCopy.Copy());
            ds.AcceptChanges();
            BuildExcel(ds, filename);

            return true;
        }

        public static void BuildExcel(DataSet ds, string path)
        {
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            string _path = path.Substring(0, path.Length - 4);
            string _fileXml = _path + ".xml";
            string _fileXsl = _path + ".xsl";
            string _fileXls = _path + ".xls";
            string _fileHtm = _path + ".htm";

            try
            {
                GetXmlFile(ds, _fileXml);
                GetXSLFile(ds, _fileXsl);

                //Excel转换
                if (File.Exists(_fileHtm))
                {
                    File.Delete(_fileHtm);
                }
                XmlDocument doc = new XmlDocument();
                doc.Load(_fileXml);
                XslTransform xslt = new XslTransform();
                xslt.Load(_fileXsl);
                XmlElement root = doc.DocumentElement;
                XPathNavigator nav = root.CreateNavigator();
                XmlTextWriter writer = new XmlTextWriter(_fileHtm, null);
                xslt.Transform(nav, null, writer, null);
                writer.Close();
                FileStream stream = new FileStream(_fileHtm, FileMode.Open);
                StreamReader reader = new StreamReader(stream);
                string _str = reader.ReadToEnd();
                reader.Close();
                string rep = @"<table border=""1"" cellpadding=""0"" cellspacing=""0"">";
                string rep1 = @"<table x:str border=""1"" cellpadding=""0"" cellspacing=""0"">";
                if (_str.IndexOf(rep) != -1)
                {
                    _str = _str.Replace(rep, rep1);
                }

                if (File.Exists(_fileXls))
                {
                    File.Delete(_fileXls);
                }
                stream = new FileStream(_fileXls, FileMode.Create);
                StreamWriter writer1 = new StreamWriter(stream);
                writer1.Write(_str);
                writer1.Close();
                stream.Close();
                File.Delete(_fileXml);
                File.Delete(_fileXsl);
                File.Delete(_fileHtm);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 根据数据集,生成替换后的xml文件
        /// </summary>
        /// <param name="ds">数据集合</param>
        /// <param name="XmlFilePath">xml文件路径</param>
        private static void GetXmlFile(DataSet ds, string XmlFilePath)
        {

            string strXml = ds.GetXml();
            if (File.Exists(XmlFilePath))
            {
                File.Delete(XmlFilePath);
            }
            FileStream fs1 = File.Create(XmlFilePath);
            StreamWriter writer = new StreamWriter(fs1);
            writer.Write(strXml);
            writer.Close();
            fs1.Close();
        }

        /// <summary>
        /// 创建转换格式文件(XSL)
        /// </summary>
        /// <param name="ds">要导出的数据集</param>
        /// <param name="XslPath">xsl文件存放路径</param>
        private static void GetXSLFile(DataSet ds, string XslPath)
        {
            string strColumn = "";
            string strRow = "";
            string dsName = ds.DataSetName;
            string tableName = ds.Tables[0].TableName;
            string header = dsName + "/" + tableName;
            foreach (DataColumn clm in ds.Tables[0].Columns)
            {
                #region 特殊字符 <,>,",*,%,(,),& 替换
                //*************************************************
                //*************************************************
                // 符号         xml下的值      excel中的值
                //  < --------  _x003C_  ------ &lt;
                //  > --------　_x003E_  ------ &gt;
                //  " --------  _x0022_  ------ &quot;
                //  * --------  _x002A_  ------ *
                //  % --------  _x0025_  ------ %
                //  & --------  _x0026_  ------ &amp;
                //  ( --------  _x0028_  ------ (
                //  ) --------  _x0029_  ------ )
                //  = --------  _x003D_  ------ = 
                // 空格-------  _x0020_  ------ 空格
                //  [ --------  _x005B_  ------ [
                //  ] --------  _x005D_  ------ ]
                //  / --------  _x002F_  ------ /
                //  \ --------  _x005C_  ------ \
                //*************************************************
                //*************************************************
                string strClmName = clm.ColumnName;
                string strRowName = clm.ColumnName;

                #region 列名替换(Excel表头)
                if (strClmName.IndexOf("&") != -1)
                    strClmName = strClmName.Replace("&", "&amp;");
                if (strClmName.IndexOf("<") != -1)
                    strClmName = strClmName.Replace("<", "&lt;");
                if (strClmName.IndexOf(">") != -1)
                    strClmName = strClmName.Replace(">", "&gt;");
                if (strClmName.IndexOf("\"") != -1)
                    strClmName = strClmName.Replace("\"", "&quot;");
                #endregion

                #region 行单元列名称替换
                if (strRowName.IndexOf("<") != -1)
                    strRowName = strRowName.Replace("<", "_x003C_");
                if (strRowName.IndexOf(">") != -1)
                    strRowName = strRowName.Replace(">", "_x003E_");
                if (strRowName.IndexOf("\"") != -1)
                    strRowName = strRowName.Replace("\"", "_x0022_");
                if (strRowName.IndexOf("*") != -1)
                    strRowName = strRowName.Replace("*", "_x002A_");
                if (strRowName.IndexOf("%") != -1)
                    strRowName = strRowName.Replace("%", "_x0025_");
                if (strRowName.IndexOf("&") != -1)
                    strRowName = strRowName.Replace("&", "_x0026_");
                if (strRowName.IndexOf("(") != -1)
                    strRowName = strRowName.Replace("(", "_x0028_");
                if (strRowName.IndexOf(")") != -1)
                    strRowName = strRowName.Replace(")", "_x0029_");
                if (strRowName.IndexOf("=") != -1)
                    strRowName = strRowName.Replace("=", "_x003D_");
                if (strRowName.IndexOf(" ") != -1)
                    strRowName = strRowName.Replace(" ", "_x0020_");
                if (strRowName.IndexOf("[") != -1)
                    strRowName = strRowName.Replace("[", "_x005B_");
                if (strRowName.IndexOf("]") != -1)
                    strRowName = strRowName.Replace("]", "_x005D_");
                if (strRowName.IndexOf("/") != -1)
                    strRowName = strRowName.Replace("/", "_x002F_");
                if (strRowName.IndexOf("\\") != -1)
                    strRowName = strRowName.Replace("\\", "_x005C_");
                #endregion

                #endregion

                strColumn += "<th>" + strClmName + "</th>" + "\r\n";
                strRow += "<td>" + "<xsl:value-of select=" + "\"" + strRowName + "\"" + "/>" + "</td>" + "\r\n";
            }

            string str = 
@"<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">
<xsl:template match=""/"">
    <html xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:x=""urn:schemas-microsoft-com:office:excel"" xmlns=""http://www.w3.org/TR/REC-html40""> 
        <head> 
            <meta http-equiv=""Content-Type"" content=""text/html;charset=utf-8"" /> 
            <style> 
                .xl24{mso-style-parent:style0;mso-number-format:""\@"";text-align:right;} 
            </style> 
			<xml> 
			<x:ExcelWorkbook> 
			<x:ExcelWorksheets> 
			<x:ExcelWorksheet> 
			<x:Name>Sheet1</x:Name> 
			<x:WorksheetOptions> 
					<x:ProtectContents>False</x:ProtectContents> 
					<x:ProtectObjects>False</x:ProtectObjects> 
					<x:ProtectScenarios>False</x:ProtectScenarios> 
			</x:WorksheetOptions> 
			</x:ExcelWorksheet> 
			</x:ExcelWorksheets> 
			</x:ExcelWorkbook> 
			</xml> 
			</head>  
			<body> ";

            str += "\r\n" + @"<table border=""1"" cellpadding=""0"" cellspacing=""0""> 
					<tr>" + "\r\n";
            str += strColumn;
            str += @" </tr> 
					<xsl:for-each select=""" + header + @""">
					<tr>";
            str += "\r\n" + strRow;
            str += 
@"</tr> 
                </xsl:for-each> 
            </table> 
        </body> 
    </html> 
</xsl:template> 
</xsl:stylesheet> ";

            string path = XslPath;
            if (File.Exists(path))
            {
                File.Delete(path);
            }
            FileStream fs = File.Create(path);
            StreamWriter sw = new StreamWriter(fs);
            sw.Write(str);
            sw.Close();
            fs.Close();
        }
    }
}
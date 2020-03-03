using System;
using System.Diagnostics;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

using DevExpress.Web;
using eTaxi.Web.Controls;
using D = eTaxi.Definitions;
namespace eTaxi
{
    /// <summary>
    /// 支持流畅语法的元素添加器械
    /// </summary>
    public class FluentListDataSetter<T>
    {
        private List<T> _Data = new List<T>();
        public List<T> Data { get { return _Data; } }
        public FluentListDataSetter<T> Add(T data) { _Data.Add(data); return this; }
    }


    /// <summary>
    /// 工具类，开放给扩展
    /// </summary>
    public static partial class Util
    {
        /// <summary>
        /// 对页面定义的 Section 类进行枚举
        /// </summary>
        public static string[] GetFields<T>() where T : class
        {
            List<string> result = new List<string>();
            foreach (FieldInfo f in typeof(T).GetFields()) result.Add(f.GetValue(null).ToString());
            return result.ToArray();
        }

        /// <summary>
        /// 获取类型的描述串
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public static string GetTypeInfo<T>() where T : class { return typeof(T).FullName; }

        /// <summary>
        /// 为页面定义的 Section 进行操作嵌入
        /// </summary>
        public static void ForFields<T>(Action<string> action, bool sortFirst = false)
        {
            if (!sortFirst)
            {
                foreach (FieldInfo f in typeof(T).GetFields()) action(f.GetValue(null).ToString());
                return;
            }
            List<string> values = new List<string>();
            foreach (FieldInfo f in typeof(T).GetFields()) values.Add(f.GetValue(null).ToString());
            values.Sort();
            values.ForEach(v => action(v));
        }

        /// <summary>
        /// 循环器，具有类型推导
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="listOrArray"></param>
        /// <param name="handle"></param>
        public static void For<T>(T firstElement, Action<T> handle, Action<FluentListDataSetter<T>> otherSet = null)
        {
            handle(firstElement);
            if (otherSet == null) return;
            var setter = new FluentListDataSetter<T>();
            otherSet(setter); foreach (T e in setter.Data) handle(e);
        }

        /// <summary>
        /// 为常量定义中的所有值进行遍历
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="action"></param>
        /// <param name="sortFirst"></param>
        public static void ForEnum<T>(Action<T> action, bool sortByValue = true)
            where T : struct, IComparable, IConvertible, IFormattable
        {
            Type t = typeof(T);
            List<FieldInfo> fields = new List<FieldInfo>(t.GetFields(BindingFlags.Public | BindingFlags.Static));
            if (sortByValue)
                fields = fields.Where(f => f.IsStatic).OrderBy(f => (int)f.GetValue(null)).ToList();
            else
                fields = fields.Where(f => f.IsStatic).OrderBy(f => ((T)f.GetValue(null)).ToString()).ToList();
            fields.ForEach(f =>
            {
                T v = (T)f.GetValue(null);
                action(v);
            });
        }

        /// <summary>
        /// 将 int 限制在 enum 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static void ParseEnum<T>(int data, T defaultValue, Action<T> handle, bool exceptionIfNotValid = false)
            where T : struct, IComparable, IConvertible, IFormattable
        {
            Type t = typeof(T);
            List<FieldInfo> fields = new List<FieldInfo>(t.GetFields(BindingFlags.Public | BindingFlags.Static));
            bool handled = false;
            fields.ForEach(f =>
            {
                T v = (T)f.GetValue(null);
                if (Convert.ToInt32(v) == data)
                {
                    handle(v);
                    handled = true;
                }
            });

            // 处理默认的
            if (!handled)
            {
                if (exceptionIfNotValid)
                {
                    throw new Exception(string.Format("{0} 不是合法的 {1} 类型", data.ToString(), typeof(T).Name));
                }
                else
                {
                    handle(defaultValue);
                }
            }
        }

        /// <summary>
        /// 单步获得枚举值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="data"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static T ParseEnum<T>(int data, T defaultValue, bool exceptionIfNotValid = false)
            where T : struct, IComparable, IConvertible, IFormattable
        {
            Type t = typeof(T);
            List<FieldInfo> fields = new List<FieldInfo>(t.GetFields(BindingFlags.Public | BindingFlags.Static));
            foreach (var f in fields)
            {
                T v = (T)f.GetValue(null);
                if (Convert.ToInt32(v) == data) return v;
            }
            if (exceptionIfNotValid)
            {
                throw new Exception(string.Format("{0} 不是合法的 {1} 类型", data.ToString(), typeof(T).Name));
            }
            return defaultValue;
        }

        /// <summary>
        /// If 结构
        /// </summary>
        /// <param name="result"></param>
        /// <param name="trueHandle"></param>
        /// <param name="falseHandle"></param>
        public static void If<T>(T obj,
            Func<T, bool> boolHandle, Action<T> trueHandle = null, Action<T> falseHandle = null)
        {
            if (boolHandle(obj))
            {
                if (trueHandle != null) trueHandle(obj);
            }
            else
            {
                if (falseHandle != null) falseHandle(obj);
            }
        }

        /// <summary>
        /// 生成类型标识字符串
        /// </summary>
        public static string GenerateTypeInfo(Type type) { return XUtil.GenerateTypeInfo(type); }

        /// <summary>
        /// 根据字符串获取扩展名
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string ParseFileExtension(string fileName)
        {
            string[] parts = fileName.Split('.');
            if (parts.Length <= 1) return string.Empty;
            return "." + parts[parts.Length - 1].Trim();
        }

        /// <summary>
        /// 根据字符获取文件名
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string ParseFileName(string fileName)
        {
            string[] parts = fileName.Split('.');
            if (parts.Length <= 1) return string.Empty;
            return fileName.Substring(0,
                fileName.Length - parts[parts.Length - 1].Length - 1);
        }

        /// <summary>
        /// 计算物理地址
        /// </summary>
        /// <returns></returns>
        public static string GetPhysicalPath(string url)
        {
            var file = url;
            if (!file.StartsWith("~")) file = (file.StartsWith("/") ? "~" : "~/") + file;
            return HttpContext.Current.Server.MapPath(file);
        }

        public static void SetControlValue(Control c, object v)
        {
            // 值和转户的字符处理
            string s = (v == null) ? string.Empty : v.ToString();
            v.If<double>(vv => s = vv.ToStringOrEmpty());
            v.If<int>(vv => s = vv.ToStringOrEmpty());

            // 赋值过程
            if (c is Literal) { (c as Literal).Text = s; }
            if (c is TextBox) { (c as TextBox).Text = s; }
            if (c is Label) { (c as Label).Text = s; }
            if (c is CheckBox && v is bool) { (c as CheckBox).Checked = (bool)v; }
            if (c is RadioButton && v is bool) { (c as RadioButton).Checked = (bool)v; }
            if (c is HyperLink) { (c as HyperLink).Text = s; }
            if (c is LinkButton) { (c as LinkButton).Text = s; }
            if (c is DropDownList) { (c as DropDownList).SelectedValue = (v == null) ? s : v.ToString(); }
            if (c is TableCell) { (c as TableCell).Text = s; }

            // DevExpress

            if (c is ASPxLabel) { (c as ASPxLabel).Text = s; }
            if (c is ASPxTextBox) { (c as ASPxTextBox).Text = s; }
            if (c is ASPxRadioButton && v is bool) { (c as ASPxRadioButton).Checked = (bool)v; }
            if (c is ASPxCheckBox && v is bool) { (c as ASPxCheckBox).Checked = (bool)v; }
            if (c is ASPxHyperLink) { (c as ASPxHyperLink).Text = s; }
            if (c is ASPxDateEdit) { (c as ASPxDateEdit).Value = v; }
            if (c is ASPxDropDownEdit) { (c as ASPxDropDownEdit).Value = v; }
            if (c is ASPxComboBox) { (c as ASPxComboBox).Value = (v == null) ? s : v.ToString(); }
            if (c is ASPxMemo) { (c as ASPxMemo).Text = s; }
            if (c is ASPxSpinEdit) { (c as ASPxSpinEdit).Value = v; }
            //if (c is ASPxTimeEdit && v is double){(c as ASPxTimeEdit).DateTime

            // ......
        }

        public static void CollectControlValue(Control c, Action<object> matched)
        {
            // 一般处理
            if (c is CheckBox) { matched(c.As<CheckBox>(true).Checked); return; }
            if (c is RadioButton) { matched(c.As<RadioButton>(true).Checked); return; }
            if (c is TextBox) { matched(c.As<TextBox>(true).Text); return; }
            if (c is DropDownList) { matched(c.As<DropDownList>(true).Text); return; }

            // DevExpress

            if (c is ASPxCheckBox) { matched(c.As<ASPxCheckBox>(true).Checked); return; }
            if (c is ASPxRadioButton) { matched(c.As<ASPxRadioButton>(true).Checked); return; }
            if (c is ASPxTextBox) { matched(c.As<ASPxTextBox>(true).Value); return; }
            if (c is ASPxMemo) { matched(c.As<ASPxMemo>(true).Value); return; }
            if (c is ASPxDateEdit) { matched(c.As<ASPxDateEdit>(true).Value); return; }
            if (c is ASPxSpinEditBase) { matched(c.As<ASPxSpinEditBase>(true).Value); return; }
            if (c is ASPxDropDownEdit) { matched(c.As<ASPxDropDownEdit>(true).Value); return; }
            if (c is ASPxComboBox) { matched(c.As<ASPxComboBox>(true).Value); return; }
            if (c is DropDownField_DX) { matched(c.As<DropDownField_DX>(true).Value); return; }
            if (c is PopupField_DX) { matched(c.As<PopupField_DX>(true).Value); return; }

            // 更多...
        }

        /// <summary>
        /// 通用检查两个对象是否相等的便捷处理
        /// </summary>
        /// <param name="v1"></param>
        /// <param name="v2"></param>
        /// <returns></returns>
        public static bool IsEqual(object v1, object v2)
        {
            if (v1 == null && v2 == null) return true;
            if (v1 == null && v2 != null) return false;
            return v1.Equals(v2);
        }

        /// <summary>
        /// 写入系统日志以做跟踪
        /// </summary>
        public static void Log(string section, EventLogEntryType type, string message)
        {

#if !DEBUG
            string source = "eTaxi.ST." + section;
            if (!
                EventLog.SourceExists(source))
                EventLog.CreateEventSource(source, "Application");
            EventLog.WriteEntry(source, message, type, 1011);
#endif

        }

        /// <summary>
        /// RM: Request Manager
        /// </summary>
        public static void Log_RM(string section, EventLogEntryType type, string message)
        {

#if !DEBUG
            string source = "eTaxi.RM." + section;
            if (!
                EventLog.SourceExists(source))
                EventLog.CreateEventSource(source, "Application");
            EventLog.WriteEntry(source, message, type, 1011);
#endif

        }

    }
}
using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using DevExpress.Web;

using eTaxi.L2SQL;
using eTaxi.Web.Controls;
using P = eTaxi.Parameters;
namespace eTaxi
{
    public interface IUserProfiles
    {
        CultureInfo UICulture { get; }
        CultureInfo Culture { get; }
    }

    /// <summary>
    /// 设计一个类为 BasePage 服务，负责：
    /// 1. 小规模函数实现
    /// 2. 通用的 web 操作
    /// </summary>
    public partial class UserProfilesRelatedUtil
    {
        /// <summary>
        /// 当前用户会话
        /// </summary>
        HttpSessionStateWrapper _SessionEx = null;

        /// <summary>
        /// 获得字符串的日期
        /// </summary>
        public bool TryParse(string data, out DateTime output)
        {
            return DateTime.TryParseExact(
                data, "yyyy-MM-dd", _SessionEx.Culture, DateTimeStyles.AllowWhiteSpaces, out output);
        }

        /// <summary>
        /// 执行上下文相关的数据类型转换
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public T Convert<T>(object value, T defaultValue = default(T))
        {
            if (value == null) return defaultValue;
            return DataConvert.From<T>(value, _SessionEx.Culture);
        }
        public void Convert<T>(object value, Action<T> notNullHandle)
        {
            if (value == null) return;
            notNullHandle(DataConvert.From<T>(value, _SessionEx.Culture));
        }

        public UserProfilesRelatedUtil(HttpSessionStateWrapper session) { _SessionEx = session; }

        /// <summary>
        /// 对一群控件组合进行值的展示
        /// </summary>
        /// <param name="l2Object">数据对象</param>
        /// <param name="controls">控件集合</param>
        /// <param name="fill">赋值过程</param>
        /// <param name="nameMatch">属性配对</param>
        public void FillObject<T>(ControlCollection controls,
            T l2Object, Action<string, PropertyInfo, Control> collect = null,
            Func<string, string, bool> nameMatch = null, bool recursive = true)
        {
            Func<string, string, bool> nm = nameMatch ?? Extension.DefaultNameMatchMethod;
            l2Object.If<TBObject>(o => o.Snap());
            foreach (Control c in controls)
            {
                foreach (PropertyInfo p in typeof(T).GetProperties())
                {
                    // 配对成功则开始收集值
                    if (nm(p.Name, c.ID))
                    {
                        Util.CollectControlValue(c, v => p.SetValue(
                            l2Object, DataConvert.From(v, _SessionEx.Culture, p.PropertyType), null));
                        
                        // 一般处理
                        if (c is CheckBox) { p.SetValue(l2Object, (c as CheckBox).Checked, null); break; }
                        if (c is RadioButton) { p.SetValue(l2Object, (c as RadioButton).Checked, null); break; }
                        if (c is TextBox)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as TextBox).Text, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is DropDownList)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as DropDownList).Text, _SessionEx.Culture, p.PropertyType), null);
                        }

                        // DevExpress

                        if (c is ASPxRadioButton) { p.SetValue(l2Object, (c as ASPxRadioButton).Checked, null); }
                        if (c is ASPxCheckBox) { p.SetValue(l2Object, (c as ASPxCheckBox).Checked, null); }
                        if (c is ASPxTextBox)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as ASPxTextBox).Value, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is ASPxMemo)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as ASPxMemo).Value, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is ASPxDateEdit)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as ASPxDateEdit).Value, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is ASPxSpinEditBase)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as ASPxSpinEditBase).Value, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is ASPxDropDownEdit)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as ASPxDropDownEdit).Value, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is ASPxComboBox)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as ASPxComboBox).Value, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is DropDownField_DX)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as DropDownField_DX).Value, _SessionEx.Culture, p.PropertyType), null);
                        }
                        if (c is PopupField_DX)
                        {
                            p.SetValue(l2Object,
                                DataConvert.From((c as PopupField_DX).Value, _SessionEx.Culture, p.PropertyType), null);
                        }

                        // 个性化值收集
                        if (collect != null) collect(p.Name, p, c);

                    }

                }

                // 递归扫描
                if (recursive) FillObject<T>(c.Controls, l2Object, collect, nameMatch, recursive);
            }
        }

        /// <summary>
        /// 获得会话中的所需字段
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="request"></param>
        /// <param name="name"></param>
        /// <param name="handle"></param>
        public UserProfilesRelatedUtil GetRequestParameter<T>(
            string key, Action<T> handle, T defaultValue = default(T), bool exceptionIfNotExists = true)
        {
            if (HttpContext.Current == null) return this;
            string value = HttpContext.Current.Request[key];
            if (string.IsNullOrEmpty(value) && exceptionIfNotExists)
                throw new ArgumentNullException(string.Format("'{0}' not found.", key));
            T result = defaultValue;
            if (!
                string.IsNullOrEmpty(value))
                result = DataConvert.From<T>(value, _SessionEx.Culture);
            handle(result);
            return this;
        }
    }

}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.Profile;
using System.Configuration;
using System.Globalization;

using D = eTaxi.Definitions;
namespace eTaxi
{
    /// <summary>
    /// 使用 Profile 供者存储内部用户的个性化参数
    /// </summary>
    public class PersonalSettings : ProfileBase
    {
        #region 系统方法

        public static PersonalSettings GetProfile()
        {
            return (PersonalSettings)HttpContext.Current.Profile;
        }
        public static PersonalSettings GetProfile(string userName)
        {
            return (PersonalSettings)ProfileBase.Create(userName);
        }

        #endregion

        private SettingsContext _Settings = new SettingsContext();

        public string Culture
        {
            get
            {
                string culture = base.GetPropertyValue("Culture").ToString();
                if (string.IsNullOrEmpty(culture)) return Parameters.Culture;
                return culture;
            }

            set { base.SetPropertyValue("Culture", value); }
        }

        private CultureInfo _CultureInfo;
        public CultureInfo CultureInfo
        {
            get
            {
                if (_CultureInfo == null)
                    _CultureInfo = CultureInfo.GetCultureInfo(Culture);
                return _CultureInfo;
            }
        }

        public string UICulture
        {
            get
            {
                string culture = base.GetPropertyValue("UICulture").ToString();
                if (string.IsNullOrEmpty(culture)) return Parameters.UICulture;
                return culture;
            }

            set { base.SetPropertyValue("UICulture", value); }
        }

        private CultureInfo _UICultureInfo;
        public CultureInfo UICultureInfo
        {
            get
            {
                if (_UICultureInfo == null)
                    _UICultureInfo = CultureInfo.GetCultureInfo(UICulture);
                return _UICultureInfo;
            }
        }

        public string UITheme
        {
            get
            {
                string theme = base.GetPropertyValue("UITheme").ToString();
                if (string.IsNullOrEmpty(theme)) return D.Themes.Office2010Silver;
                return theme;
            }

            set { base.SetPropertyValue("UITheme", value); }
        }

        public int PageSize
        {
            get
            {
                int size = int.Parse(
                    base.GetPropertyValue("PageSize").ToString());
                if (size != 0) return size;
                return Parameters.DefaultPageSize;
            }

            set { base.SetPropertyValue("PageSize", value); }
        }
    }

}

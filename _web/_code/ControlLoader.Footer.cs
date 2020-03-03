using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using LinqKit;
using D = eTaxi.Definitions;
namespace eTaxi.Web.Controls.Loader
{
    /// <summary>
    /// 用于控件页脚的通用中间对象
    /// </summary>
    public class Footer : BaseControl
    {
        protected Dictionary<EventTypes, ControlLoader.Button> 
            _ButtonSettings = new Dictionary<EventTypes, ControlLoader.Button>();

        private BaseControl _ImpersonatingControl = null;
        /// <summary>
        /// 主控控件
        /// </summary>
        public BaseControl ImpersonatingControl
        {
            get { return _ImpersonatingControl; }
            set { _ImpersonatingControl = value; }
        }

        /// <summary>
        /// 提示控件需要有哪些按钮（事件）需要特别注意的
        /// </summary>
        public Footer SpecifyButtonSetting(EventTypes eType, ControlLoader.Button button)
        {
            if (_ButtonSettings.ContainsKey(eType))
            {
                _ButtonSettings[eType] = button;
            }
            else
            {
                _ButtonSettings.Add(eType, button);
            }
            return this;
        }

        /// <summary>
        /// 批量
        /// </summary>
        public Footer SpecifyButtonSetting(
            IEnumerable<KeyValuePair<EventTypes, ControlLoader.Button>> buttons)
        {
            buttons.ForEach(b => _ButtonSettings.Add(b.Key, b.Value));
            return this;
        }

    }
}
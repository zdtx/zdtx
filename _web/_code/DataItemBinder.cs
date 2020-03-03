using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

using System.Web.UI;
using System.Web.UI.WebControls;
namespace eTaxi.Web
{
    /// <summary>
    /// 解决在 aspx 和 ascx 中绑定无类型 DataItem 到控件的流畅处理
    /// </summary>
    public class DataItemBinder
    {
        private Control _Container = null;
        private Object _DataItem = null;

        public DataItemBinder Do<TControl>(
            string control, Action<TControl> handle = null) where TControl : Control
        {
            Control c = _Container.FindControl(control);
            if (c == null) throw new
                ArgumentException(string.Format("'{0}' not found", control));
            c.If<TControl>(cc => { if (handle != null) handle(cc); }, true);
            return this;
        }

        public string Get(string expression, string format = null)
        {
            return DataBinder.Eval(_DataItem, expression, format);
        }
        public T Get<T>(string expression)
        {
            return (T)DataBinder.Eval(_DataItem, expression);
        }

        public DataItemBinder(Control container, object dataItem)
        {
            _Container = container;
            _DataItem = dataItem;
        }
    }



}
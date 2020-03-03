using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace eTaxi.Web.Controls
{
    /// <summary>
    /// ���ڽ��� GridView ������
    /// </summary>
    public partial class GridHeaderSorter : BaseControl
    {
        /// <summary>
        /// null: ������ / true: ���� / false: ����
        /// </summary>
        public Nullable<bool> Sort
        {
            get
            {
                if (u.Visible) return true;
                else if (d.Visible) return false;
                return null;
            }
            set
            {
                u.Visible = false; d.Visible = false;
                if (value.HasValue)
                {
                    u.Visible = value.Value;
                    d.Visible = !value.Value;
                }
            }
        }

        public string FieldName
        {
            get { return l.CommandArgument; }
            set { l.CommandArgument = value; }
        }

        public string CssClass
        {
            get { return l.CssClass;}
            set { l.CssClass = value; }
        }

        public string Caption
        {
            get { return l.Text; }
            set { l.Text = value; }
        }

    }
}
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress.Web;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// Flash 摄像机
    /// </summary>
    public partial class Flashcam : BaseControl
    {
        /// <summary>
        /// 主控对象 Id
        /// </summary>
        public string ObjectId
        {
            set { _SessionEx.Set<string>(value, D.DataStates.ObjectId); }
            get { return _SessionEx.Get<string>(D.DataStates.ObjectId); }
        }

    }

}
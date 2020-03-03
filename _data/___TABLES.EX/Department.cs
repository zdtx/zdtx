using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;

using D = eTaxi.Definitions;
namespace eTaxi.L2SQL
{
    public partial class TB_department : TBObject<TB_department>
    {
        /// <summary>
        /// 深度
        /// </summary>
        public int Dept
        {
            get
            {
                var shouldMinusOne = !
                    string.IsNullOrEmpty(Id) && Path.Contains(Id);
                var dept = Path.SplitEx('/').Length;
                if (dept > 0 && shouldMinusOne) dept -= 1;
                return dept;
            }
        }
        /// <summary>
        /// 父Id
        /// </summary>
        public string[] ParentIds { get { return Path.SplitEx('/'); } }
        /// <summary>
        /// 是否有儿子（此值不作为数据库存储）
        /// </summary>
        public bool HasChildren { get; set; }

        public TB_department()
        {
            Path = "/";
        }

    }
}



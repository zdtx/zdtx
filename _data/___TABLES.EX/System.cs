using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;

namespace eTaxi.L2SQL
{
    public partial class TB_sys_sequence : TBObject<TB_sys_sequence>
    {
        public TB_sys_sequence()
        {
        }
    }

    public partial class TB_sys_module : TBObject<TB_sys_module>
    {
        public TB_sys_module()
        {
            Id = Guid.NewGuid();
            Ordinal = 0;
            Enabled = true;
        }
    }

    public partial class TB_sys_acl : TBObject<TB_sys_acl>
    {
        public TB_sys_acl()
        {
            IsForbidden = false;
        }
    }

}



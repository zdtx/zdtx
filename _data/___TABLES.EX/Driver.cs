using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;

using D = eTaxi.Definitions;
namespace eTaxi.L2SQL
{
    public partial class TB_driver : TBObject<TB_driver>
    {
        public TB_driver()
        {
            Id = "----------";
            Education = (int)D.Education.Unknown;
            SocialCat = (int)D.SocialCat.QZ;
            Enabled = true;
        }
    }
}



using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;

using D = eTaxi.Definitions;
namespace eTaxi.L2SQL
{
    public partial class TB_charge : TBObject<TB_charge>
    {
        public TB_charge()
        {
            Enabled = true;
        }
    }
}



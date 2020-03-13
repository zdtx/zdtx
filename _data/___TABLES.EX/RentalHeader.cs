using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;

using D = eTaxi.Definitions;
namespace eTaxi.L2SQL
{
    [Serializable]
    public class RentalHeader
    {
        public string DriverId { get; set; }
        public string CarId { get; set; }
    }
}



using System;
namespace eTaxi.L2SQL
{
    [Serializable]
    public class RentalHeader
    {
        public string DriverId { get; set; }
        public string CarId { get; set; }
        public decimal Rental { get; set; }
        public bool Invoiced { get; set; }
    }
}



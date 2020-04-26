using System;
using System.Collections.Generic;

namespace eTaxi
{
    public class Class1
    {
        public class DC1
        {
            public string Id { get; set; }
        }

        public IEnumerable<DC1> GetDC1(Func<IEnumerable<DC1>> getter) { return getter(); }


    }
}
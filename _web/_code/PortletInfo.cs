using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.IO;

using D = eTaxi.Definitions;
using E = eTaxi.Exceptions;
using eTaxi.L2SQL;
namespace eTaxi
{
    /// <summary>
    /// 门户控件信息
    /// </summary>
    public class PortletInfo
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Ordinal { get; set; }
        public string Path { get; set; }
        public bool AccessControlled { get; set; }
    }
}
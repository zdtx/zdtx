using System;
using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;

using LinqKit;
namespace eTaxi
{
    /// <summary>
    /// 为定义类的属性编排设定排序值
    /// </summary>
    [AttributeUsageAttribute(AttributeTargets.All, Inherited = false, AllowMultiple = false)]
    public class DefinitionItemOrdinalAttribute : Attribute
    {
        public DefinitionItemOrdinalAttribute(int ordinal)
        {
            if (ordinal < 0) throw new ArgumentException("ordinal 必须设置为 大于或等于 0 的值");
            _Ordinal = ordinal;
        }

        private int _Ordinal;
        public int Ordinal { get { return _Ordinal; } }
    }

    /// <summary>
    /// 其他扩展属性
    /// </summary>
    [AttributeUsageAttribute(AttributeTargets.All, Inherited = false, AllowMultiple = false)]
    public class DefinitionItemSettingsAttribute : Attribute
    {
        public DefinitionItemSettingsAttribute(string captionOrSection, bool isUserDefined = false)
        {
            _CaptionOrSection = captionOrSection;
            _IsUserDefined = isUserDefined;
        }

        private string _CaptionOrSection;
        public string CaptionOrSection { get { return _CaptionOrSection; } }
        private bool _IsUserDefined = false;
        public bool IsUserDefined { get { return _IsUserDefined; } }
    }

    /// <summary>
    /// 代表一个生成的定义项
    /// </summary>
    public class DefinitionItemInfo
    {
        public int Ordinal { get; set; }
        public string UniqueString { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public string Caption { get; set; }
        public object Instance { get; set; }
        public string GetCombinedString()
        {
            if (Instance == null) return Value;
            return Instance.GetType().Name + "." + Value;
        }
    }

    /// <summary>
    /// 根据类型获得：
    /// 1. MasterItem 类形成的定义项目 比如 Definitions.Master
    /// 2. Items 对里面的常量值形成 定义项
    /// </summary>
    public class DefinitionItemHelper
    {
        private List<DefinitionItemInfo> _Items = new List<DefinitionItemInfo>();
        public List<DefinitionItemInfo> Items { get { return _Items; } }
        private DefinitionItemInfo _MasterItem;
        public DefinitionItemInfo MasterItem { get { return _MasterItem; } }
        
        public DefinitionItemInfo GetItem(
            Func<DefinitionItemInfo, bool> selector) { return _Items.Where(selector).SingleOrDefault(); }
        public DefinitionItemInfo GetItem(string value, bool ignoreCase = false)
        {
            var expItem = PredicateBuilder.True<DefinitionItemInfo>();
            if (ignoreCase)
            {
                expItem = expItem.And(i => 
                    i.Value.Equals(value, StringComparison.InvariantCultureIgnoreCase));
            }
            else
            {
                expItem = expItem.And(i => i.Value == value);
            }
            return _Items.SingleOrDefault(expItem.Compile());
        }

        public bool IsDefined(string itemValue, bool ignoreCase = false)
        {
            if (ignoreCase)
                return _Items.Exists(i => i.Value.Equals(itemValue, StringComparison.InvariantCultureIgnoreCase));
            return _Items.Exists(i => i.Value == itemValue);
        }

        public DefinitionItemHelper(Type type)
        {
            _Items.AddRange(DefinitionHelper.GenerateItems(type));
            _MasterItem = DefinitionHelper.GenerateItem(type);
        }
    }

    public class DefinitionItemHelper<T> : DefinitionItemHelper where T : new()
    {
        public DefinitionItemHelper() : base(typeof(T)) { }
    }

    public static class DefinitionHelper
    {
        public const string NamespaceSeparator = "Definitions";

        // create cache
        private static Dictionary<Type, DefinitionItemInfo> _Cache =
            new Dictionary<Type, DefinitionItemInfo>();
        private static object _Locker = new object();
        private static Dictionary<Type, List<DefinitionItemInfo>> _CacheItems =
            new Dictionary<Type, List<DefinitionItemInfo>>();
        private static object _LockerItems = new object();

        /// <summary>
        /// 生成类型字典项
        /// </summary>
        public static DefinitionItemInfo GenerateItem<T>() where T : new() { return GenerateItem(typeof(T)); }
        public static DefinitionItemInfo GenerateItem(Type type)
        {
            if (_Cache.ContainsKey(type)) return _Cache[type];
            lock (_Locker)
            {
                if (_Cache.ContainsKey(type)) return _Cache[type];
                var instance = Activator.CreateInstance(type);
                DefinitionItemInfo itemInfo = new DefinitionItemInfo();
                int startPosition = type.FullName.IndexOf(NamespaceSeparator);
                if (startPosition == -1) startPosition = 0;
                itemInfo.Ordinal = 0;
                itemInfo.Instance = instance;
                itemInfo.Name = type.Name;
                itemInfo.Value = type.Name;
                itemInfo.UniqueString =
                    type.FullName.Substring(startPosition)
                    .Replace(NamespaceSeparator + ".", string.Empty)
                    .Replace('.', '_')
                    .Replace('+', '_');
                foreach (DefinitionItemOrdinalAttribute attribute in
                    type.GetCustomAttributes(typeof(DefinitionItemOrdinalAttribute), false))
                    itemInfo.Ordinal = attribute.Ordinal;
                foreach (DefinitionItemSettingsAttribute attribute in
                    type.GetCustomAttributes(typeof(DefinitionItemSettingsAttribute), false))
                {
                    itemInfo.Caption = attribute.CaptionOrSection;
                    if (attribute.IsUserDefined)
                    {
                        itemInfo.Caption = Host.Settings.Get<string>(attribute.CaptionOrSection);
                    }
                }
                _Cache.Add(type, itemInfo);
                return itemInfo;
            }
        }

        /// <summary>
        /// 生成类型下常量的字典项组
        /// </summary>
        public static List<DefinitionItemInfo> GenerateItems<T>() where T : new() { return GenerateItems(typeof(T)); }
        public static List<DefinitionItemInfo> GenerateItems(Type type)
        {
            if (type == null) throw new ArgumentException("type");
            if (_CacheItems.ContainsKey(type)) return _CacheItems[type].ToList();
            lock (_LockerItems)
            {
                if (_CacheItems.ContainsKey(type)) return _CacheItems[type].ToList();
                List<DefinitionItemInfo> l = new List<DefinitionItemInfo>();
                var instance = Activator.CreateInstance(type);
                var shouldAdd = true;
                int startPosition = type.FullName.IndexOf(NamespaceSeparator);
                if (startPosition == -1) startPosition = 0;
                foreach (FieldInfo f in type.GetFields())
                {
                    shouldAdd = true;
                    DefinitionItemInfo itemInfo = new DefinitionItemInfo();
                    itemInfo.Ordinal = 0;
                    itemInfo.Instance = instance;
                    itemInfo.Name = f.Name;
                    itemInfo.Value = f.GetValue(null).ToString();
                    itemInfo.Caption = f.Name;
                    itemInfo.UniqueString =
                        type.FullName.Substring(startPosition)
                        .Replace(NamespaceSeparator + ".", string.Empty)
                        .Replace('.', '_')
                        .Replace('+', '_') + "_" + f.Name;
                    foreach (DefinitionItemOrdinalAttribute attribute in
                        f.GetCustomAttributes(typeof(DefinitionItemOrdinalAttribute), false))
                        itemInfo.Ordinal = attribute.Ordinal;
                    foreach (DefinitionItemSettingsAttribute attribute in
                        f.GetCustomAttributes(typeof(DefinitionItemSettingsAttribute), false))
                    {
                        itemInfo.Caption = attribute.CaptionOrSection;
                        if (attribute.IsUserDefined)
                        {
                            var content = Host.Settings.Get<string>(itemInfo.Caption);
                            itemInfo.Caption = null;
                            shouldAdd = false;
                            if (string.IsNullOrEmpty(content)) break;
                            content.SplitEx((parts, i) =>
                            {
                                var pair = parts[i].SplitEx('=');
                                if (pair.Length < 2) return;
                                if (pair[0] == itemInfo.Value)
                                {
                                    itemInfo.Caption = pair[1];
                                    shouldAdd = true;
                                }
                            }, '|');
                        }
                    }
                    if (shouldAdd) l.Add(itemInfo);
                }
                l = l.OrderBy(i => i.Ordinal).ToList();
                _CacheItems.Add(type, l);
                return l.ToList();
            }
        }

        /// <summary>
        /// 生成类型下常量的字典项组
        /// </summary>
        public static List<DefinitionItemInfo> GenerateEnums<T>()
            where T : struct, IComparable, IConvertible, IFormattable { return GenerateEnums(typeof(T)); }
        public static List<DefinitionItemInfo> GenerateEnums(Type type)
        {
            if (type == null) throw new ArgumentException("type");
            if (_CacheItems.ContainsKey(type)) return _CacheItems[type].ToList();
            lock (_LockerItems)
            {
                if (_CacheItems.ContainsKey(type)) return _CacheItems[type].ToList();
                List<DefinitionItemInfo> l = new List<DefinitionItemInfo>();
                var instance = Activator.CreateInstance(type);
                var shouldAdd = false;
                int startPosition = type.FullName.IndexOf(NamespaceSeparator);
                if (startPosition == -1) startPosition = 0;
                foreach (FieldInfo f in type.GetFields(BindingFlags.Public | BindingFlags.Static))
                {
                    // if (f.Name.Equals("value__")) continue;
                    shouldAdd = true;
                    DefinitionItemInfo itemInfo = new DefinitionItemInfo();
                    itemInfo.Ordinal = -1;
                    itemInfo.Instance = instance;
                    itemInfo.Name = f.Name;
                    itemInfo.Value = ((int)f.GetValue(null)).ToString();
                    itemInfo.Caption = f.Name;
                    itemInfo.UniqueString =
                        type.FullName.Substring(startPosition)
                        .Replace(NamespaceSeparator + ".", string.Empty)
                        .Replace('.', '_')
                        .Replace('+', '_') + "_" + f.Name;
                    foreach (DefinitionItemOrdinalAttribute attribute in
                        f.GetCustomAttributes(typeof(DefinitionItemOrdinalAttribute), false))
                        itemInfo.Ordinal = attribute.Ordinal;
                    foreach (DefinitionItemSettingsAttribute attribute in
                        f.GetCustomAttributes(typeof(DefinitionItemSettingsAttribute), false))
                    {
                        itemInfo.Caption = attribute.CaptionOrSection;
                        if (attribute.IsUserDefined)
                        {
                            var content = Host.Settings.Get<string>(itemInfo.Caption);
                            itemInfo.Caption = null;
                            shouldAdd = false;
                            if (string.IsNullOrEmpty(content)) break;
                            content.SplitEx((parts, i) =>
                            {
                                var pair = parts[i].SplitEx('=');
                                if (pair.Length < 2) return;
                                if (pair[0] == itemInfo.Value)
                                {
                                    itemInfo.Caption = pair[1];
                                    shouldAdd = true;
                                }
                            }, '|');
                        }
                    }
                    if (itemInfo.Ordinal == -1)
                        itemInfo.Ordinal = itemInfo.Value.ToIntOrDefault();
                    if (shouldAdd) l.Add(itemInfo);
                }
                l = l.OrderBy(i => i.Ordinal).ToList();
                _CacheItems.Add(type, l);
                return l.ToList();
            }
        }

        /// <summary>
        /// 生成类型下常量的字典项组
        /// </summary>
        public static string Caption<T>(T value)
            where T : struct, IComparable, IConvertible, IFormattable
        {
            var type = typeof(T);
            if (_CacheItems.ContainsKey(type))
            {
                return _CacheItems[type]
                    .Single(i => i.Value == (Convert.ToInt32(value).ToString())).Caption;
            }

            lock (_LockerItems)
            {
                if (_CacheItems.ContainsKey(type))
                {
                    return _CacheItems[type]
                        .Single(i => i.Value == (Convert.ToInt32(value).ToString())).Caption;
                }

                List<DefinitionItemInfo> l = new List<DefinitionItemInfo>();
                var instance = Activator.CreateInstance(type);
                var shouldAdd = true;
                int startPosition = type.FullName.IndexOf(NamespaceSeparator);
                if (startPosition == -1) startPosition = 0;
                foreach (FieldInfo f in type.GetFields(BindingFlags.Public | BindingFlags.Static))
                {
                    // if (f.Name.Equals("value__")) continue;
                    shouldAdd = true;
                    DefinitionItemInfo itemInfo = new DefinitionItemInfo();
                    itemInfo.Ordinal = -1;
                    itemInfo.Instance = instance;
                    itemInfo.Name = f.Name;
                    itemInfo.Value = ((int)f.GetValue(null)).ToString();
                    itemInfo.Caption = f.Name;
                    itemInfo.UniqueString =
                        type.FullName.Substring(startPosition)
                        .Replace(NamespaceSeparator + ".", string.Empty)
                        .Replace('.', '_')
                        .Replace('+', '_') + "_" + f.Name;
                    foreach (DefinitionItemOrdinalAttribute attribute in
                        f.GetCustomAttributes(typeof(DefinitionItemOrdinalAttribute), false))
                        itemInfo.Ordinal = attribute.Ordinal;
                    foreach (DefinitionItemSettingsAttribute attribute in
                        f.GetCustomAttributes(typeof(DefinitionItemSettingsAttribute), false))
                    {
                        itemInfo.Caption = attribute.CaptionOrSection;
                        if (attribute.IsUserDefined)
                        {
                            var content = Host.Settings.Get<string>(itemInfo.Caption);
                            itemInfo.Caption = null;
                            shouldAdd = false;
                            if (string.IsNullOrEmpty(content)) break;
                            content.SplitEx((parts, i) =>
                            {
                                var pair = parts[i].SplitEx('=');
                                if (pair.Length < 2) return;
                                if (pair[0] == itemInfo.Value)
                                {
                                    itemInfo.Caption = pair[1];
                                    shouldAdd = true;
                                }
                            }, '|');
                        }
                    }
                    if (itemInfo.Ordinal == -1)
                        itemInfo.Ordinal = itemInfo.Value.ToIntOrDefault();
                    if (shouldAdd) l.Add(itemInfo);
                }
                l = l.OrderBy(i => i.Ordinal).ToList();
                _CacheItems.Add(type, l);
                return l.Single(i => i.Value == (Convert.ToInt32(value).ToString())).Caption;
            }
        }

        /// <summary>
        /// 兼容所有 int 输入
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string Caption<T>(Nullable<int> value, string notValidText = null)
            where T : struct, IComparable, IConvertible, IFormattable
        {
            if (!value.HasValue)
                return notValidText;
            T result = default(T);
            if (Enum.TryParse<T>(value.Value.ToString(), out result))
            {
                return Caption(result);
            }
            return notValidText;
        }

        /// <summary>
        /// 获得短定义项目：比如 TraceStatus.Active
        /// </summary>
        public static string GenerateCombinedString<T>(string value, Func<DefinitionItemInfo, string> stringGet = null) where T : new() { return GenerateCombinedString(typeof(T), value); }
        public static string GenerateCombinedString(Type type, string value, Func<DefinitionItemInfo, string> stringGet = null)
        {
            DefinitionItemInfo item =
                GenerateItems(type).Single(i => i.Value == value);
            if (stringGet == null)
            {
                return item.Instance.GetType().Name + "." + item.Value;
            }
            else
            {
                return stringGet(item);
            }
        }

        /// <summary>
        /// 获得短定义项目组：比如 [ "TraceStatus.Active", "TraceStatus.Submitted" ]
        /// </summary>
        public static List<string> GenerateCombinedStrings<T>(Func<DefinitionItemInfo, string> stringGet = null) where T : new() { return GenerateCombinedStrings(typeof(T)); }
        public static List<string> GenerateCombinedStrings(Type type, Func<DefinitionItemInfo, string> stringGet = null)
        {
            List<DefinitionItemInfo> list = GenerateItems(type);
            if (stringGet == null)
            {
                return (
                    from i in list select i.Instance.GetType().Name + "." + i.Value).ToList();
            }
            else
            {
                return (from i in list select stringGet(i)).ToList();
            }
        }

    }

}

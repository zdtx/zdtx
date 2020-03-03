using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;
using System.ComponentModel;

namespace eTaxi
{
    public static class DataConvert
    {
        public static T From<T>(object value, CultureInfo culture) { return (T)From(value, culture, typeof(T)); }
        public static object From(object value, CultureInfo culture, Type targetType)
        {
            if (targetType == typeof(string) && value == null) return null;
            if (_IsNullableType(targetType))
            {
                if (value == null) return null;
                if (string.IsNullOrEmpty(value.ToString())) return null;
            }
            if (value == null) throw new ArgumentNullException("value");
            object resultValue;
            if (targetType == typeof(object)) return value;
            if (_TryConvert(value, culture, targetType, out resultValue)) return resultValue;
            throw new ArgumentException(
                "系统未能把类型为 '" + value.GetType().Name + "' 的数据，转换为 '" + targetType.Name + "' 的数据");
        }

        private static bool _TryConvert(object value, CultureInfo culture, Type targetType, out object convertedValue)
        {
            return _TryAction<object>(() =>
                _Convert(value, culture, targetType), out convertedValue);
        }

        private static bool _TryAction<T>(Func<T> creator, out T output)
        {
            try
            {
                output = creator();
                return true;
            }
            catch
            {
                output = default(T);
                return false;
            }
        }

        private static object _Convert(object value, CultureInfo culture, Type targetType)
        {
            if (value == null) throw new ArgumentNullException("value");
            if ((targetType.IsInterface || targetType.IsGenericTypeDefinition) || targetType.IsAbstract)
            {
                throw new ArgumentException("Target type {0} is not a value type or a non-abstract class.");
            }
            if (_IsNullableType(targetType)) targetType = Nullable.GetUnderlyingType(targetType);
            Type t = value.GetType();
            if (targetType == t) return value;
            if ((value is string) && typeof(Type).IsAssignableFrom(targetType)) return Type.GetType((string)value, true);
            if ((value is IConvertible) && typeof(IConvertible).IsAssignableFrom(targetType))
            {
                if (targetType.IsEnum)
                {
                    if (value is string)
                    {
                        return Enum.Parse(targetType, value.ToString(), true);
                    }
                    if (_IsInteger(value))
                    {
                        return Enum.ToObject(targetType, value);
                    }
                }
                return System.Convert.ChangeType(value, targetType, culture);
            }
            if ((value is DateTime) && (targetType == typeof(DateTimeOffset))) return new DateTimeOffset((DateTime)value);
            if (value is string)
            {
                if (targetType == typeof(Guid))
                {
                    return new Guid((string)value);
                }
                if (targetType == typeof(Uri))
                {
                    return new Uri((string)value);
                }
                if (targetType == typeof(TimeSpan))
                {
                    return TimeSpan.Parse((string)value);
                }
            }
            return System.Convert.ChangeType(value, targetType);
        }

        private static bool _IsInteger(object value)
        {
            switch (System.Convert.GetTypeCode(value))
            {
                case TypeCode.SByte:
                case TypeCode.Byte:
                case TypeCode.Int16:
                case TypeCode.UInt16:
                case TypeCode.Int32:
                case TypeCode.UInt32:
                case TypeCode.Int64:
                case TypeCode.UInt64:
                    return true;
            }
            return false;
        }

        private static bool _IsNullable(Type t)
        {
            if (t == null) throw new ArgumentNullException("t");
            if (t.IsValueType)
            {
                return _IsNullableType(t);
            }
            return true;
        }

        private static bool _IsNullableType(Type t)
        {
            if (t == null) throw new ArgumentNullException("t");
            return (t.IsGenericType && (t.GetGenericTypeDefinition() == typeof(Nullable<>)));
        }

    }
}
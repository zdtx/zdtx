using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using Microsoft.International.Converters.PinYinConverter;

namespace eTaxi
{
    public static partial class Extension
    {
        /// <summary>
        /// 汉字转拼音
        /// </summary>
        /// <param name="data">汉字</param>
        /// <returns>全拼</returns>
        public static String ToPYString(this string data)
        {
            string result = string.Empty;
            foreach (char obj in data)
            {
                try
                {
                    ChineseChar chineseChar = new ChineseChar(obj);
                    string t = chineseChar.Pinyins[0].ToString();
                    result += t.Substring(0, t.Length - 1);
                }
                catch
                {
                    result += obj.ToString();
                }
            }
            return result;
        }

        /// <summary>
        /// 汉字转化为拼音首字母
        /// </summary>
        /// <param name="data">汉字</param>
        /// <returns>首字母</returns>
        public static string ToFirstPYChars(this string data)
        {
            string result = string.Empty;
            foreach (char obj in data)
            {
                try
                {
                    ChineseChar chineseChar = new ChineseChar(obj);
                    string t = chineseChar.Pinyins[0].ToString();
                    result += t.Substring(0, 1);
                }
                catch
                {
                    result += obj.ToString();
                }
            }
            return result;
        }

        /// <summary>
        /// 获取一个汉字的拼音声母
        /// </summary>
        /// <param name="chinese">Unicode格式的一个汉字</param>
        /// <returns>汉字的声母</returns>
        public static char ToPYChar(this Char data) { return new ChineseChar(data).Pinyins[0][0]; }



    }

}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Reflection;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using ZXing;

namespace eTaxi
{
    /// <summary>
    /// Barcode 应用包
    /// </summary>
    public static class Barcode
    {
        public static Writer Write(BarcodeFormat format = BarcodeFormat.CODE_128, bool showContent = true) { return new Writer(format, showContent); }
        public class Writer
        {
            private BarcodeWriter _Writer = new BarcodeWriter();
            public Writer(BarcodeFormat format, bool showContent)
            {
                _Writer.Format = format;
                _Writer.Encoder = new MultiFormatWriter();
                _Writer.Renderer = new ZXing.Rendering.BitmapRenderer();
                _Writer.Options.PureBarcode = !showContent;
                _Writer.Options.Margin = 2;
            }
            public Writer Height(int height) { _Writer.Options.Height = height; return this; }
            public Writer Width(int width) { _Writer.Options.Width = width; return this; }
            public Writer Margin(int margin) { _Writer.Options.Margin = margin; return this; }

            /// <summary>
            /// 获取其他格式的图形
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="content"></param>
            /// <returns></returns>
            public Bitmap Image(string content) { return _Writer.Write(content); }
            public byte[] Bytes(string content, Action<MemoryStream> streamHandle = null) { return Bytes(content, ImageFormat.Bmp, streamHandle); }
            public byte[] Bytes(string content, ImageFormat format, Action<MemoryStream> streamHandle = null)
            {
                using (var ms = new MemoryStream())
                {
                    _Writer.Write(content).Save(ms, format);
                    if (streamHandle != null)
                    {
                        try { streamHandle(ms); }
                        catch { }
                    }
                    return ms.ToArray();
                }
            }
        }
    }
}
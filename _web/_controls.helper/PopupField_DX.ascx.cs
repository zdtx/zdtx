using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevExpress.Web;
using eTaxi.L2SQL;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// 由一个 ButtonEdit 和一个 DropDown 组成
    /// 仅仅支持 UpdatePanel 下操作
    /// </summary>
    public partial class PopupField_DX : BaseControl
    {
        private bool _ShowEdit = false;
        public bool ShowEdit
        {
            get { return _ShowEdit; }
            set { _ShowEdit = value; }
        }

        private string _EditText = "X";
        public string EditText
        {
            get { return _EditText; }
            set { _EditText = value; }
        }
        
        public ASPxButtonEdit BE { get { return b; } }
        public string Text
        {
            get { return b.Text; }
            set { b.Text = value; }
        }

        public string Value
        {
            get { return h.Value; }
            set { h.Value = value; }
        }

        public string Tag
        {
            get { return t.Value; }
            set { t.Value = value; }
        }

        public Unit Width { set { b.Width = value; } }
        public Unit Height { set { b.Height = value; } }
        public bool ReadOnly { set { b.ReadOnly = value; } }
        public string NullText { set { b.NullText = value; } }

        public void Clear()
        {
            Text = string.Empty;
            Value = string.Empty;
        }

        public void Initialize<T>(
            // 给定一个 加载器，用于给 ButtonEdit 控制 
            ControlLoader loader,
            // 要加载的控件
            string controlPath,
            // 检查事前条件
            Func<ASPxButtonEdit, HiddenField, bool> preShow,
            // 当下拉面板被拉下的时候（加载器，控件对象，输入框，是否第一次加载）
            Action<T, ASPxButtonEdit, HiddenField, bool> show,
            // 当值被选定的时候
            Func<T, ASPxButtonEdit, HiddenField, bool> set,
            // 清除值
            Action<ASPxButtonEdit> clear = null,
            // 额外配置 Loader
            Action<ControlLoader.Configurator<T>> config = null) where T : BaseControl
        {
            // 观察下拉按钮
            b.ValidationSettings.CausesValidation = false;
            b.ButtonClick += (s, e) =>
            {
                switch (e.ButtonIndex)
                {
                    case 0: // 弹出

                        // 事前检验
                        if (!preShow(BE, h)) return;

                        // 如果没有加载则进行加载
                        if (loader.HostingControl == null)
                        {
                            loader.Begin<T>(controlPath, null, c => show(c, b, h, true), config);
                        }
                        else
                        {
                            if (loader.HostingControl is T)
                            {
                                T c = loader.HostingControl as T;
                                show(c, b, h, false);

                                // -- 拷贝 loader 的实现片段 --
                                if (config != null)
                                {
                                    loader.ForConfigurator<T>(config, null, new ControlLoader.Configurator<T>(c, loader));
                                    loader.ForConfigurator<T>(cc =>
                                    {
                                        if (cc.FooterLoaded) return; // 已经在 configurator 中加载页脚
                                        loader.LoadFooter<Loader.Footer>(execute: f =>
                                        {
                                            f.SpecifyButtonSetting(cc.Buttons);
                                            f.Execute();
                                        });

                                    }, () =>
                                    {
                                        loader.LoadFooter<Loader.Footer>(execute: f => f.Execute());
                                    });
                                }

                                // 重新展示
                                loader.Show();
                            }
                            else
                            {
                                loader.Begin<T>(controlPath, null, c => show(c, b, h, true), config);
                            }
                        }

                        break;

                    case 1: // 点击编辑按钮

                        if (clear != null)
                        {
                            clear(b);
                        }
                        else
                        {
                            Text = Value = null;
                        }

                        break;
                }
            };

            // 观察 Loader 的状态，捕获 OK 事件
            loader.EventSinked += (c, eType, param) =>
            {
                if (eType == EventTypes.OK)
                    if (loader.HostingControl is T)
                        if (set((loader.HostingControl as T), b, h)) loader.Close();
            };
        }

        public void Initialize<T>(
            // 给定一个 加载器，用于给 ButtonEdit 控制 
            ControlLoader loader,
            // 要加载的控件
            string controlPath,
            // 当下拉面板被拉下的时候（加载器，控件对象，输入框，是否第一次加载）
            Action<T, ASPxButtonEdit, HiddenField, bool> show,
            // 当值被选定的时候
            Func<T, ASPxButtonEdit, HiddenField, bool> set,
            // 清除值
            Action<ASPxButtonEdit> clear = null,
            // 额外配置 Loader
            Action<ControlLoader.Configurator<T>> config = null) where T : BaseControl
        {
            Initialize<T>(loader, controlPath, (b, h) => true, show, set, clear, config);
        }
    }

}
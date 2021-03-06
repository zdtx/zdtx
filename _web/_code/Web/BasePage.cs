using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Reflection;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.SessionState;
using System.Web.Security;
using System.Web.Profile;
using System.Resources;
using System.Threading;
using System.IO;
using System.IO.Compression;
using System.Globalization;
using Microsoft.Practices.Unity;

using Ext.Net;
using eTaxi.L2SQL;

using WebUI = System.Web.UI.WebControls;
using P = eTaxi.Parameters;
using D = eTaxi.Definitions;
namespace eTaxi.Web
{
    public abstract partial class BasePage : System.Web.UI.Page, IPageEx
    {
        protected DateTime _CurrentTime = DateTime.Now; // 当日时间定值（每个 request 一个值，不用 now）
        protected TypedHashtable _Data = new TypedHashtable();      // 数据缓存
        protected IDataConnectionManager _DataConnectionManager;    // 数据库连接管理对象
        protected UserProfilesRelatedUtil _Util = null;
        protected CommonService _DTService = null;
        protected StateBagWrapper _ViewStateEx = null;
        protected HttpSessionStateWrapper _SessionEx = null;
        protected JS _JS = null;
        protected CK _CK = null;
        protected Auth _Auth = null;
        protected bool _IsPartial = false;
        protected Dictionary<string, TimeSpan> _TimeScales = new Dictionary<string, TimeSpan>();

        /// <summary>
        /// 生成数据上下文工厂方法的页面调用捷径
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="readOnly"></param>
        /// <returns></returns>
        protected static T _DTContext<T>(
            bool readOnly = false) where T : CommonContext { return Util.DTContext<T>(readOnly); }

        /// <summary>
        /// 当前登录状态
        /// </summary>
        protected bool _Logined = false;

        private string _AccessCode = string.Empty;
        /// <summary>
        /// 模块命名
        /// </summary>
        public string AccessCode
        {
            get
            {
                if (!string.IsNullOrEmpty(_AccessCode)) return _AccessCode;
                if (!Global.Cache.AccessIds.ContainsKey(AppRelativeVirtualPath.ToLower())) return _AccessCode;
                _AccessCode = Global.Cache.AccessIds[AppRelativeVirtualPath.ToLower()].ToISFormatted();
                return _AccessCode;
            }
        }

        /// <summary>
        /// 该页面是否需要登录才能使用（是否做权限检查）
        /// </summary>
        protected virtual bool _LoginRequired { get { return true; } }

        /// <summary>
        /// 页面是否受控于主皮肤控制
        /// </summary>
        protected virtual bool _EnableTheming { get { return true; } }

        /// <summary>
        /// 页面是否应该对每个请求做独立的时间计算
        /// </summary>
        protected virtual bool _EnableTimeScaling { get { return false; } }

        /// <summary>
        /// 用户服务
        /// </summary>
        protected MembershipProvider _MembershipProvider { get { return Host.Container.Resolve<MembershipProvider>(); } }
        
        /// <summary>
        /// 角色服务
        /// </summary>
        protected RoleProvider _RoleProvider { get { return Host.Container.Resolve<RoleProvider>(); } }

        /// <summary>
        /// Profile 服务
        /// </summary>
        protected ProfileProvider _ProfileProvider { get { return Host.Container.Resolve<ProfileProvider>(); } }

        // 补丁开关 -----
        protected virtual bool _PACK_0001 { get { return false; } }
        // --------------

        /// <summary>
        /// 方法计时
        /// </summary>
        protected virtual void _ScaleTime(string step, Action handle, string section = null)
        {
            var start = DateTime.Now;
            handle();
            var key = step;
            if (!string.IsNullOrEmpty(section)) key += "." + section;
            if (!_TimeScales.ContainsKey(key)) _TimeScales.Add(key, TimeSpan.Zero);
            _TimeScales[key] = DateTime.Now.Subtract(start);
        }

        #region 重新定义请求处理布局

        /// <summary>
        /// 页面的第一个可访问事件，之后加载个性化信息和主题
        /// </summary>
        protected override void OnPreInit(EventArgs e)
        {

#if !DEBUG
            Error += (s, ee) =>
            {
                _SessionEx.LastException = Server.GetLastError();
                if (_SessionEx.LastException != null)
                {
                    new 
                        DTException.DataSetter(_SessionEx.LastException.Data)
                            .Record("BASE.PageUrl", Request.RawUrl);
                }
                Response.Redirect("~/error.aspx");
            };
#endif

            base.OnPreInit(e);

            // 主构造上下文
            _PrepareContext();  

            if (!_Logined && _LoginRequired) _Auth.Logout(); // 如果页面需要登录，则跳出
            if (_EnableTheming) Theme = _SessionEx.Theme;

            try
            {
                if (_EnableTimeScaling)
                {
                    _ScaleTime(Steps.PreInit, () => _SetPreInitControls());
                }
                else
                {
                    _SetPreInitControls();
                }
            }
            catch (Exception ex)
            {
                if (_HandleException(GetType(), new ExceptionFilter(ex), Steps.PreInit)) return;
                throw ex;
            }
        }

        /// <summary>
        /// 初始化页面中声明的所有服务端控件的默认值，控件状态未加载
        /// </summary>
        /// <param name="e"></param>
        protected override void OnInit(EventArgs e)
        {
            ScriptManager sm = System.Web.UI.ScriptManager.GetCurrent(Page);
            _IsPartial = X.IsAjaxRequest || (sm != null && sm.IsInAsyncPostBack);
            if (!_Logined && _LoginRequired) return;

            if (System.Web.HttpContext.Current == null) return;
            base.OnInit(e);

            Thread.CurrentThread.CurrentCulture = _SessionEx.Culture;
            Thread.CurrentThread.CurrentUICulture = _SessionEx.UICulture;

            try
            {
                // 如果面对控件网络，这个方法用于给定一个初始状态，后期被 viewState 冲掉
                if (_EnableTimeScaling)
                {
                    _ScaleTime(Steps.Init, () => _SetInitialStates(_IsPartial));
                }
                else
                {
                    _SetInitialStates(_IsPartial);
                }

                // 补丁1
                if (_PACK_0001)
                {
                    var btn = new System.Web.UI.WebControls.Button()
                    {
                        ID = "___b_pack_0001",
                    };
                    btn.Style.Add("display", "none");
                    Form.FindControl("___x").IfNN(c => c.Controls.Add(btn), () => Form.Controls.Add(btn));
                    btn.Click += (s, ee) => Execute();
                }

            }
            catch (Exception ex)
            {
                if (_HandleException(GetType(), new ExceptionFilter(ex), Steps.Init)) return;
                throw ex;
            }
        }

        /// <summary>
        /// 控件完成状态和回传状态的加载
        /// </summary>
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            if (!_Logined && _LoginRequired) return;

            if (_Logined &&
                _LoginRequired && !
                string.IsNullOrEmpty(AccessCode))
            {
                if (!
                    AC(AccessCode))
                    throw new Exception("您没有权限访问此页面，请咨询管理员");
            }

            try
            {
                if (_EnableTimeScaling)
                {
                    _ScaleTime(Steps.Load, () =>
                    {
                        _ViewStateProcess(); // 处理视图状态（不管是否第一次加载）
                        if (!IsPostBack) _FirstGet(_IsPartial);
                    });
                }
                else
                {
                    _ViewStateProcess(); // 处理视图状态（不管是否第一次加载）
                    if (!IsPostBack) _FirstGet(_IsPartial);
                }
            }
            catch (Exception ex)
            {
                if (_HandleException(GetType(), new ExceptionFilter(ex), Steps.Load)) return;
                throw ex;
            }
        }

        #endregion

        #region 待重载方法集合

        /// <summary>
        /// Do 之前的校验方法，例如 校验 ，因为：
        /// 控件很大程度受控于外部 Loader 的调用，PreDo 返回控件状态是否满足下一步操作的校验条件
        /// </summary>
        /// <param name="section">可以与 _Do 的 section 对应</param>
        /// <returns></returns>
        public virtual bool PreDo(string section, Action<DTException> exceptionHandle = null) { return true; }

        /// <summary>
        /// Do 和 _Do
        /// 处理 Postback 的方法调用，作为系统时间处理的唯一入口
        /// </summary>
        protected virtual void _Do(string section, string subSection = null) { throw new NotImplementedException("未定义，请先重载 _Do"); }
        public bool Do(string section, bool requireTransaction) { return Do(section, null, requireTransaction); }
        public bool Do(string section, string subSection, bool requireTransaction)
        {
            return _TransCall(() =>
            {
                if (_EnableTimeScaling)
                {
                    _ScaleTime(Steps.Do, () => _Do(section, subSection), section);
                }
                else
                {
                    _Do(section, subSection);
                }

            }, ex =>
            {
                if (_HandleException(GetType(), new ExceptionFilter(ex), Steps.Do)) return;
                throw ex;
            }, requireTransaction);
        }

        /// <summary>
        /// 需要执行事务的方法闭包
        /// </summary>
        protected bool _TransCall(
            Action handle, Action<Exception> exceptionHandle = null, bool requireTransaction = true)
        {
            return Util.TransCall(handle, exceptionHandle, requireTransaction);
        }

        /// <summary>
        /// 第一次加载要做的事情
        /// </summary>
        protected virtual void _FirstGet()
        {
            if (_PACK_0001)
            {
                // 如果模板已经涵盖了这个补丁，则不需要自己实现
                if (Master.As<MasterPageEx>()._PACK_0001()) return;
                Form.FindControl("___b_pack_0001").If<System.Web.UI.WebControls.Button>(btn =>
                {
                    string js = Page.ClientScript.GetPostBackEventReference(btn, string.Empty) + ";";
                    _JS.Write(js + "ISEx.loadingPanel.show();");
                    
                    // 去除母板的脚本注册
                    Master.As<MasterPageEx>().RemoveScriptRegistration();
                });
            }
            else
            {
                _Execute();
            }
        }
        protected virtual void _FirstGet(bool isPartial) { if (!isPartial) _FirstGet(); }

        /// <summary>
        /// 执行视图状态的计算
        /// </summary>
        protected virtual void _ViewStateProcess() { }

        /// <summary>
        /// 进行初始化
        /// </summary>
        protected virtual void _SetInitialStates() { }
        protected virtual void _SetInitialStates(bool isPartial) { _SetInitialStates(); }

        /// <summary>
        /// 设定初始化前的控件布局（Theme Master ScriptManager 等）
        /// </summary>
        protected virtual void _SetPreInitControls() { }

        /// <summary>
        /// 访问并且准备好数据
        /// </summary>
        protected virtual void _PrepareData() { Util.ForFields<D.DataSections>(s => _PrepareData(s)); }
        protected void _PrepareData(string[] sections) { foreach (string s in sections) _PrepareData(s); }
        protected virtual void _PrepareData(string section) { }

        /// <summary>
        /// 将数据绑定到控件
        /// </summary>
        protected virtual void _BindData() { Util.ForFields<D.VisualSections>(s => _BindData(s)); }
        protected virtual void _BindData(string section) { }

        /// <summary>
        /// 一次完整的“处理 + 绑定”
        /// </summary>
        protected virtual void _Execute()
        {
            _PrepareData();
            _BindData();
        }
        protected virtual void _Execute(string section) { }
        public bool Execute()
        {
            try
            {
                if (_EnableTimeScaling)
                {
                    _ScaleTime(Steps.Execute, () => _Execute());
                }
                else
                {
                    _Execute();
                }
                
                return true;
            }
            catch (Exception ex)
            {
                if (_HandleException(GetType(), new ExceptionFilter(ex), Steps.Execute)) return false;
                throw ex;
            }
        }
        public bool Execute(string section)
        {
            try
            {
                if (_EnableTimeScaling)
                {
                    _ScaleTime(Steps.Execute, () => _Execute(section), section);
                }
                else
                {
                    _Execute(section);
                }

                return true;
            }
            catch (Exception ex)
            {
                if (_HandleException(GetType(), new ExceptionFilter(ex), Steps.Execute)) return false;
                throw ex;
            }
        }

        /// <summary>
        /// 适合外部调用的错误处理程序
        /// </summary>
        /// <param name="ex"></param>
        public void HandleException(Exception ex, Action<string> msgSend = null)
        {
            _HandleException(GetType(), new ExceptionFilter(ex), string.Empty, msgSend);
        }

        /// <summary>
        /// 处理异常，为以下顺序
        /// 1. 如果为 false，则表明没处理，让 BasePage_Error 处理
        /// 2. 如果重载为 true，则由页面处理
        /// </summary>
        /// <param name="ex">异常</param>
        /// <param name="step">哪个环节出现的</param>
        /// <param name="id">额外的 id 信息</param>
        /// <returns></returns>
        protected virtual bool _HandleException(Type callerType, 
            ExceptionFilter exFilter, string step, Action<string> msgSend = null)
        {
            // 首次加载报的错
            if (!IsPostBack && !_IsPartial)
            {
                if (exFilter.Exception != null)
                {
                    new
                        DTException.DataSetter(exFilter.Exception.Data)
                            .Record("BASE.Step", step)
                            .Record("BASE.PageUrl", Request.RawUrl);
                    throw exFilter.Exception;
                }
            }
            if (!exFilter.Handled)
            {
                string msg = exFilter.Exception.Message;
                exFilter.DT(ex =>
                {
                    if (ex is TTableRecordNotFound) msg = "您好，数据未能访问 ";
                    if (ex.Data != null && ex.Data.Count > 0)
                    {
                        msg += "\r\n参考（用于运维）：\r\n----------";
                        foreach (var key in exFilter.Exception.Data.Keys)
                        {
                            msg += string.Format("\r\n  {0}：{1} ",
                                key.ToStringEx(), exFilter.Exception.Data[key].ToStringEx());
                        }
                        msg += "\r\n----------";
                    }
                });
                if (msgSend != null) msgSend(msg); else _JS.Alert(msg);
            }
            return true;
        }

        #endregion

        /// <summary>
        /// 获得一个类似：http://[site]/[dir] 的结构，可以构建绝对访问路径
        /// </summary>
        /// <returns></returns>
        public string GetSitePrefix()
        {
            return
                Request.FilePath.Replace(
                Page.AppRelativeVirtualPath.Replace("~", string.Empty), string.Empty);
        }

        /// <summary>
        /// 简单版的查权限
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public bool AC(string code)
        {
            if (_SessionEx.UniqueId == new Guid(D.Login.AdministratorId)) return true;
            return _DTService.AC(code, _SessionEx.Id, _SessionEx.RoleIds);
        }

        /// <summary>
        /// 准备个性化会话工作对象
        /// </summary>
        protected void _PrepareContext()
        {
            _SessionEx = new HttpSessionStateWrapper(Session, _CurrentTime);
            _SessionEx.Dirty += d =>
            {
                var context = _DTContext<CommonContext>(true);
                switch (d)
                {
                    case HttpSessionStateWrapper.Types.Role:
                        var roles = (
                            from r in context.AS_Roles
                            join u in context.AS_UserInRoles on r.RoleId equals u.RoleId
                            select r.RoleName).ToArray();
                        _SessionEx.Set<string[]>(roles, HttpSessionStateWrapper.Keys.RoleIds);
                        _SessionEx.SetDirty(HttpSessionStateWrapper.Types.Role, false);
                        break;
                    case HttpSessionStateWrapper.Types.Portlet:

                        // 在全局 portlet 池中筛选出有权限访问的 portlet
                        var portlets = new List<string>();
                        Global.Cache.Portlets.ForEach(p =>
                        {
                            if (Global.Cache.AccessIds.ContainsKey(p.Id))
                            {
                                var accessId = Global.Cache.AccessIds[p.Id];
                                if (AC(accessId.ToString())) portlets.Add(p.Path);
                            }
                            else
                            {
                                portlets.Add(p.Path);
                            }
                        });

                        _SessionEx.Set<string[]>(portlets.ToArray(), HttpSessionStateWrapper.Keys.Portlets);
                        _SessionEx.SetDirty(HttpSessionStateWrapper.Types.Portlet, false);
                        break;
                }
            };

            try
            {
                _SessionEx.LastVisitTime = _CurrentTime;
                _SessionEx.LastVisitUrl = Request.Url.ToStringEx();
                _SessionEx.LastVisitUrlReferrer = Request.UrlReferrer.ToStringEx();
                _SessionEx.LastVisitUserAgent = Request.UserAgent;
                _SessionEx.LastVisitUserHostAddress = Request.UserHostAddress;
                _SessionEx.LastVisitUserHostName = Request.UserHostName;
            }
            catch
            {
            }

            // 同步当前线程
            _Auth.SynThread(p =>
            {
                _Logined = _SessionEx.Logined;
                if (_Logined) return;

                _Logined = !p.IsPublic && !p.IsGuest;
                _SessionEx.UserName = p.Identity.Name;
                _SessionEx.UniqueId = p.Id;
                if (_Logined && !_SessionEx.Logined) _SynSession();
            });

            _Util = new UserProfilesRelatedUtil(_SessionEx);
            _DTService.Initialize(_SessionEx, _CurrentTime, Global.Cache);
        }

        protected void _SynSession()
        {
            if (!_SessionEx.Logined) return;

            // 访问数据库，补齐信息
            var context = _DTContext<CommonContext>(true);
            context.Persons.SingleOrDefault(pp => pp.UniqueId == _SessionEx.UniqueId).IfNN(person =>
            {
                _SessionEx.Id = person.Id;
                _SessionEx.Name = person.Name;
                _SessionEx.DepartmentId = person.DepartmentId;
                _SessionEx.PositionId = person.PositionId;
            }, () =>
            {
                if (_SessionEx.UniqueId == new Guid(D.Login.AdministratorId))
                {
                    var adminSession = new AdminSession(_CurrentTime);
                    _SessionEx.Name = adminSession.Name;
                }
            });

            Global.Sessions.Register(_SessionEx);
        }

        /// <summary>
        /// Linq 数据导出Excel表格
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="section">标识，例如 Contract，InStorage，等，与 Export 子目录同</param>
        /// <param name="data"></param>
        /// <param name="headers"></param>
        protected virtual string _ExportToExcel<T>(
            string prefix, List<T> data, string[] headers, Controls.ControlLoader pop = null)
        {
            PropertyInfo[] properties = typeof(T).GetProperties();
            if (headers.Length < properties.Length)
                throw new ArgumentException("表头数量不够，请检查", "headers");
            if (headers.Distinct().Count() < headers.Length)
                throw new ArgumentException("表头命名不能重复，请检查", "headers");

            var ds = new DataSet();
            var tb = ds.Tables.Add();
            var folder = "____temp/export";

            // 放表头
            for (int i = 0; i < properties.Length; i++)
            {
                tb.Columns.Add(new DataColumn()
                {
                    Caption = headers[i],
                    ColumnName = properties[i].Name,
                    DataType = properties[i].PropertyType,
                    AllowDBNull = true
                });
            }

            // 放数据
            data.ForEach(d =>
            {
                var row = tb.NewRow();
                for (int i = 0;
                    i < properties.Length; i++) row[i] = properties[i].GetValue(d, null);
                tb.Rows.Add(row);
            });

            ds.AcceptChanges();
            var file = string.Format("{0}_{1}.xls", prefix, Guid.NewGuid().ToISFormatted()).ToLower();
            var path = Util.GetPhysicalPath(folder);
            new ExportExcel().ExportExcelData(path, file, tb);
            if (pop == null) return file;
            pop.Begin<Controls.MessagePanel>("~/_controls.helper/messagepanel.ascx",
                null, c =>
                {
                    var l = new WebUI.HyperLink()
                        {
                            CssClass = "aBtn",
                            Text = "点击此处下载 / 浏览",
                            Target = "_blank",
                            NavigateUrl = string.Format("~/{0}/{1}", folder, file)
                        };
                    l.Font.Bold = true;
                    l.Font.Size = 12;
                    c.MessageBody.Controls.Add(l);
                    c.Title = "成功";

                }, c =>
                {
                    c
                        .Width(400)
                        .Height(300)
                        .Title("文件导出")
                    ;
                });
            return file;
        }
        protected virtual string _ExportToExcel<T, TSource>(string section, List<TSource> data,
            string[] headers, Func<TSource, T> itemGet, Controls.ControlLoader pop = null)
        {
            return _ExportToExcel<T>(section, Exp<T>.Transform(data, itemGet), headers, pop);
        }

        public BasePage()
            : base()
        {
            _DataConnectionManager = Host.Container.Resolve<IDataConnectionManager>();
            _DTService = new CommonService(_DataConnectionManager);
            _ViewStateEx = new StateBagWrapper(ViewState);
            _JS = new JS(this);
            _CK = new CK(this);
            switch (Host.Settings.Get<string>("AuthMode", "forms"))
            {
                default:
                    _Auth = new FormsAuth(this);
                    break;
            }
        }
    }

    /// <summary>
    /// 带修饰器的页面
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class BasePage<T> : BasePage where T : PageDecorator
    {
        /// <summary>
        /// 扩充 PreInit
        /// </summary>
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            // 必要的修饰
            T decorator = Activator.CreateInstance(typeof(T), this) as T;
            Decorate(decorator);
            decorator.Go();
        }

        /// <summary>
        /// 获得页面修饰器，并且配置
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public virtual void Decorate(T decorator) { }
    }

}
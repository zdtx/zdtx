using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;

using D = eTaxi.Definitions;
using eTaxi.L2SQL;
namespace eTaxi.Web.Portal
{
    public partial class Default : BasePage<ExtPageDecorator>
    {
        public class Data
        {
            /// <summary>
            /// 菜单数据
            /// </summary>
            public const string Module = "module";
            /// <summary>
            /// 快捷方式
            /// </summary>
            public const string Shortcut = "shortcut";
            /// <summary>
            /// 角色数据
            /// </summary>
            public const string Role = "role";
            /// <summary>
            /// 对菜单的访问控制
            /// </summary>
            public const string ACL = "acl";
        }

        public class Jobs
        {
            public const string LoadMenu = "loadMenu";
        }

        protected CommonContext _Context = _DTContext<CommonContext>(true);
        protected override void _PrepareData() { Util.ForFields<Data>(f => _PrepareData(f)); }
        protected override void _PrepareData(string section)
        {
            switch (section)
            {
                case Data.ACL:

                    //// 获取用户的角色 Ids
                    //string[] roleIds = _SessionEx.RoleIds;
                    //_Data.Add<List<int>>((
                    //    from a in _Context.ModuleACLs
                    //    where (a.USERID == UserId || roleIds.Contains(a.ROLEID)) && a.MENUID.HasValue
                    //    select a.MENUID.Value).ToList(), Data.ACL);

                    break;

                case Data.Shortcut:

                    //_Data.Add<List<TB_MenuShortcut>>((
                    //    from s in _Context.MenuShortcuts
                    //    where s.PersonID == OperatorID
                    //    select s).ToList(), Data.Shortcut);

                    break;
            }
        }

        protected override void _BindData()
        {
            //List<TB_MenuShortcut> shortcuts = _Data.Get<List<TB_MenuShortcut>>(Data.Shortcut);
            //List<TB_T_Module> results = (
            //    from s in shortcuts
            //    join m in Global.Cache.Modules on s.ModuleID equals m.ID
            //    where (m.IsMenu == 1) && (m.Enabled == 1)
            //    orderby m.SortCode
            //    select m).ToList();
            //int startIndex = 3;
            //for (int i = 0; i < results.Count; i++)
            //{
            //    Ext.Net.Button button = new Ext.Net.Button()
            //    {
            //        Text = results[i].FullName,
            //        Icon = Icon.BulletArrowDown
            //    };
            //    button.Listeners.Click.Handler =
            //        string.Format("ISEx.navigate('../{0}',true);", results[i].NavigateUrl);
            //    topTB.Items.Insert(startIndex + i, button);
            //}
        }

        protected override void _Do(string section, string subSection = null)
        {
            switch (section)
            {
                case Jobs.LoadMenu:
                    _PrepareData(Data.ACL);
                    _PrepareData(Data.Shortcut);
                    break;
            }
        }

    }
}
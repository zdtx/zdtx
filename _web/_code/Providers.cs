using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Web.Security;
using System.Web.Profile;
using System.Configuration;

/// <summary>
/// 用于本系统的 帐号管理
/// </summary>
public class eTaxiMembershipProvider : SqlMembershipProvider
{

}

/// <summary>
/// 用于本系统的用户个性化参数管理
/// </summary>
public class eTaxiProfileProvider : SqlProfileProvider
{

}

/// <summary>
/// 用于本系统的角色管理
/// </summary>
public class eTaxiRoleProvider : SqlRoleProvider
{

}
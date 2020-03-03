using System;
using System.Security;
using System.Security.Principal;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class eTaxiPrincipal : GenericPrincipal
{
    private eTaxiIdentity _Identity;
    public override IIdentity Identity
    {
        get { return _Identity; }
    }

    private bool _IsPublic = false;
    public bool IsPublic
    {
        get { return _IsPublic; }
        set { _IsPublic = value; }
    }

    private bool _IsGuest = false;
    public bool IsGuest
    {
        get { return _IsGuest; }
        set { _IsGuest = value; }
    }

    private Guid _Id = Guid.Empty;
    public Guid Id
    {
        get { return _Id; }
        set { _Id = value; }
    }

    public eTaxiPrincipal(eTaxiIdentity identity)
        : base(identity, new string[] { })
    {
        _Identity = identity;
    }
}

public class eTaxiIdentity : IIdentity
{
    private bool _IsAuthenticated = false;
    public string AuthenticationType
    {
        get { return _Identity.AuthenticationType; }
    }

    public bool IsAuthenticated
    {
        get { return _IsAuthenticated; }
    }

    public string Name
    {
        get { return _Identity.Name; }
    }

    private IIdentity _Identity;
    public eTaxiIdentity(IIdentity identity, bool isAuthenticated)
    {
        _Identity = identity;
        _IsAuthenticated = isAuthenticated;
    }
}

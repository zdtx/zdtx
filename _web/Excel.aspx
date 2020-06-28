<%@ Page Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BasePage" %>
<script runat="server">

    protected override void _SetInitialStates(bool isPartial)
    {
        base._SetInitialStates();

        var id = Guid.Empty;
        var name = Request["name"];
        if (string.IsNullOrEmpty(Request["id"])) return; 
        if (!Guid.TryParse(Request["id"], out id)) return; 
        Util.ResponseWithFile(
            Util.GetPhysicalPath(string.Format(@"~/____temp_protected/Driver/{0}.xlsx", id.ToISFormatted())), Response, 
            string.IsNullOrEmpty(name) ? id + ".xlsx" : name + ".xlsx");

    }

</script>


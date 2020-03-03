<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls/Driver/View_Guarantor.ascx" TagPrefix="uc1" TagName="View_Guarantor" %>
<uc1:Popup_DX runat="server" ID="pop" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title">
                    基本信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">（系统唯一码）
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Id" />
            </td>
        </tr>
        <tr>
            <td class="name">全名
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Name" />
            </td>
        </tr>
        <tr>
            <td class="name">姓
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_LastName" />
            </td>
        </tr>
        <tr>
            <td class="name">名
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_FirstName" />
            </td>
        </tr>
        <tr>
            <td class="name">身份证号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_CHNId" />
            </td>
        </tr>
        <tr>
            <td class="name">性别
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Gender" />
            </td>
        </tr>
        <tr>
            <td class="name">出生年月
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_DayOfBirth" />
            </td>
        </tr>
        <tr>
            <td class="name">文化程度
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Education" />
            </td>
        </tr>
        <tr>
            <td class="name">政治面貌
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_SocialCat" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top: 15px;">
                    联系信息
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">电话
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Tel1" />
            </td>
        </tr>
        <tr>
            <td class="name">常住地址
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Address" />
            </td>
        </tr>
        <tr>
            <td class="name">户口地址
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_HKAddress" />
            </td>
        </tr>
        <tr>
            <td class="name">亲属联系人
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_ContactPerson" />
            </td>
        </tr>
        <tr>
            <td class="name">亲属联系电话
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_ContactNumber" />
            </td>
        </tr>
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top: 15px;">
                    管理信息
                </div>
            </th>
        </tr>
        <uc1:View_Guarantor runat="server" ID="uG" />
        <tr>
            <td class="name">从业时间
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_CareerStart" />
            </td>
        </tr>
        <tr>
            <td class="name">从业资格证号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_CertNumber" />
            </td>
        </tr>
        <tr>
            <td class="name">备注
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Remark" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    public override string ModuleId { get { return Driver.View; } }
    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    protected override void _SetInitialStates()
    {
    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        var driver = context.Drivers.SingleOrDefault(o => o.Id == _ObjectId);
        if (driver == null) throw DTException.NotFound<TB_car>(_ObjectId);
        p.Controls.PresentedBy(driver, (d, n, c) =>
        {
            switch (n)
            {
                case "Gender":
                    c.As<Literal>().Text = d.Gender.HasValue ? d.Gender.Value ? "男" : "女" : "（未知）";
                    break;
                case "DayOfBirth":
                    c.As<Literal>().Text = d.DayOfBirth.ToISDate();
                    break;
                case "Education":
                    c.As<Literal>().Text = DefinitionHelper.Caption((Education)d.Education);
                    break;
                case "SocialCat":
                    c.As<Literal>().Text = DefinitionHelper.Caption((SocialCat)d.SocialCat);
                    break;
                        
            }
            
        }, recursive: false);

        uG
            .Import(driver.Guarantor, DataStates.Detail)
            .Execute();
    }

    protected override void _Do(string section, string subSection = null)
    {
    }

</script>

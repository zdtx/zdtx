<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Register Src="~/_controls.helper/FormHelper.ascx" TagPrefix="uc1" TagName="FormHelper" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/PopupField_DX.ascx" TagPrefix="uc1" TagName="PopupField_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
<uc1:FormHelper runat="server" ID="fh" />
<asp:Panel runat="server" ID="p">
    <table class="form">
        <tr>
            <th colspan="2">
                <div class="title" style="margin-top:10px;">
                    出租车合同
                </div>
            </th>
        </tr>
        <tr>
            <td class="name">（车辆系统唯一码）
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Id" />
            </td>
        </tr>
        <tr>
            <td class="name">车牌号
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_PlateNumber" />
            </td>
        </tr>
        <tr>
            <td class="name">车辆单位
            </td>
            <td class="val">
                <asp:Literal runat="server" ID="l_Company" />
            </td>
        </tr>
        <tr id="tr" runat="server" visible="false">
            <td colspan="2" class="tips" style="padding:5px;">
                <asp:Label runat="server" ID="lb" ForeColor="Red" />
            </td>
        </tr>
        <tr>
            <td class="name">司机（合同承租方）
            </td>
            <td class="cl">
                <uc1:PopupField_DX runat="server" ID="pf_DriverId" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">合同类型
            </td>
            <td class="cl">
                <dx:ASPxComboBox runat="server" ID="cb_ContractType" Width="200" 
                    NullText="请选择合同类型" />
            </td>
        </tr>
        <tr>
            <td class="name">合同编号
            </td>
            <td class="cl">
                <dx:ASPxTextBox runat="server" ID="tb_Code" Width="200" />
            </td>
        </tr>
        <tr>
            <td class="name">合同开始
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_CommenceDate" Width="200" 
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                    <TimeSectionProperties Visible="false"></TimeSectionProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">合同到期
            </td>
            <td class="cl">
                <dx:ASPxDateEdit runat="server" ID="de_EndDate" Width="200" 
                    DisplayFormatString="yyyy-MM-dd" EditFormatString="yyyy-MM-dd">
                    <CalendarProperties TodayButtonText="今天" ClearButtonText="清空">
                        <FastNavProperties OkButtonText="选定" CancelButtonText="清空" />
                    </CalendarProperties>
                    <TimeSectionProperties Visible="false"></TimeSectionProperties>
                </dx:ASPxDateEdit>
            </td>
        </tr>
        <tr>
            <td class="name">
            </td>
            <td class="cl" style="padding:5px;">
                <asp:LinkButton runat="server"
                    Text="上传合同附件" ID="bUpload" CssClass="aBtn" CausesValidation="false" />
                <br />
                <asp:Literal runat="server" ID="l_BlobOriginalName" />
                <asp:Literal runat="server" ID="l_Blob" Visible="false" />
            </td>
        </tr>
        <tr>
            <td class="name">备注
            </td>
            <td class="cl">
                <dx:ASPxMemo runat="server" ID="mm_Remark" Width="300" Rows="5" />
            </td>
        </tr>
    </table>
</asp:Panel>
<script runat="server">

    private string _ObjectId { get { return _ViewStateEx.Get<string>(DataStates.ObjectId, null); } }
    public override string ModuleId { get { return Car.Contract_Edit ; } }
    protected override void _SetInitialStates()
    {
        fh.CurrentGroup = ClientID;
        fh.Validate(de_CommenceDate).IsRequired();
        fh.Validate(pf_DriverId).IsRequired();
        cb_ContractType.FromEnum<ContractType>(valueAsInteger: true);

        pf_DriverId.Initialize<eTaxi.Web.Controls.Selection.Driver.Item>(pop,
            "~/_controls.helper/selection/driver/item.ascx", (cc, b, h, isFirst) =>
            {
                pop.Title = "选择司机";
                pop.Width = 650;
                pop.Height = 500;
                if (isFirst) cc.Execute();
            }, (c, b, h) =>
            {
                b.Text = c.Selection[0].Name;
                h.Value = c.Selection[0].Id;
                pop.Close();
                return true;
            }, null, c => c.Button(BaseControl.EventTypes.OK, s => s.CausesValidation = false));

        bUpload.Click += (s, e) =>
        {
            pop.Begin<eTaxi.Web.BaseControl>("~/_controls/car/contract_upload.ascx",
                null, c =>
                {
                    c.Execute();
                }, c =>
                {
                    c
                        .Width(420)
                        .Height(250)
                        .Title("合同附件上传")
                        .Button(BaseControl.EventTypes.OK, b =>
                        {
                            b.CausesValidation = false;
                            b.Text = "开始上传";
                            b.JSHandle = string.Format(
                                "if({0}.GetFileInputCount()>0){{ISEx.loadingPanel.show('上传中，请稍候..');{0}.Upload();}}else{{alert('请先点击 [浏览] 选定待上传的文件');e.processOnServer=false;}}",
                                pop.HostingControl.ClientID);
                        })
                    ;
                });
        };

        pop.EventSinked += (c, eType, parm) =>
        {
            if (c.ModuleId == Car.Contract_Upload)
            {
                if (eType != EventTypes.OK) return;
                if (c.Do(Actions.Save, false))
                {
                    var objectId = c.ViewStateEx.Get<string>(DataStates.ObjectId);
                    var filename = c.ViewStateEx.Get<string>(DataStates.Detail);
                    l_Blob.Text = objectId;
                    l_BlobOriginalName.Text = filename;
                    pop.Close();
                }
            }
        };

    }

    protected override void _Execute()
    {
        var context = _DTContext<CommonContext>(true);
        context.Cars.SingleOrDefault(c => c.Id == _ObjectId).IfNN(car =>
        {
            l_Id.Text = car.Id;
            l_Company.Text = car.Company;
            l_PlateNumber.Text = car.PlateNumber;
            l_Blob.Text = null;
            l_BlobOriginalName.Text = null;
            p.Controls.Reset();

        }, () =>
        {
            throw DTException.NotFound<TB_car>(_ObjectId);
        });
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Save) return;
        var context = _DTContext<CommonContext>();
        var car = context.Cars.SingleOrDefault(o => o.Id == _ObjectId);
        var newId = string.Empty;
        if (car == null) throw DTException.NotFound<TB_car>(_ObjectId);

        var contract = new TB_car_contract();
        context
            .NewSequence<TB_car_contract>(_SessionEx, (seq, id) => newId = id)
            .Create<TB_car_contract>(_SessionEx, o =>
            {
                o.CarId = _ObjectId;
                o.DriverId = pf_DriverId.Value;
                o.Id = newId;
                o.Code = tb_Code.Text;
                o.Type = cb_ContractType.Value.ToStringEx().ToIntOrDefault(0);
                o.CommenceDate = de_CommenceDate.Date;
                
                if (!
                    string.IsNullOrEmpty(de_EndDate.Value.ToStringEx()))
                    o.EndDate = de_EndDate.Date;

                // 附件信息
                o.Blob = l_Blob.Text.ToGuidOrNull();
                o.BlobOrginalName = l_BlobOriginalName.Text;

                contract = o;
            })
            .SubmitChanges();

        // 更新车辆信息

        if (contract.CommenceDate <= DateTime.Now.Date &&
            (!contract.EndDate.HasValue ||
            contract.EndDate.HasValue && DateTime.Now.Date <= contract.EndDate.Value))
        {
            car.ContractId = contract.Id;
            car.ConstructDueTime = contract.EndDate;
        }

        context.SubmitChanges();

        // 继续处理附件文件

        if (string.IsNullOrEmpty(l_Blob.Text)) return;

        var blobId = new Guid(l_Blob.Text);
        var extension = System.IO.Path.GetExtension(l_BlobOriginalName.Text);

        // 将 temp 目录 文件放入 同名 id
        var file = Util.GetPhysicalPath(
            string.Format("{0}/file/{1}{2}", Parameters.Tempbase, blobId.ToISFormatted(), extension));
        var newFile = Util.GetPhysicalPath(
            string.Format("{0}/{1}{2}", Parameters.Filebase, contract.Id, extension));
        System.IO.File.Copy(file, newFile, true);

    }

</script>

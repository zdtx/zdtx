<%@ Control Language="C#" AutoEventWireup="true" Inherits="eTaxi.Web.BaseControl" %>
<%@ Import Namespace="eTaxi.Definitions" %>
<%@ Import Namespace="eTaxi.Definitions.Ascx" %>
<%@ Import Namespace="eTaxi.Exceptions" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Register Src="~/_controls.helper/Loaders/Popup_DX.ascx" TagPrefix="uc1" TagName="Popup_DX" %>
<%@ Register Src="~/_controls.helper/GridWrapperForDetail.ascx" TagPrefix="uc1" TagName="GridWrapperForDetail" %>
<%@ Register Src="~/_controls.helper/Callback_Generic.ascx" TagPrefix="uc1" TagName="Callback_Generic" %>
<%@ Register Src="~/_controls.helper/ActionToolbar.ascx" TagPrefix="uc1" TagName="ActionToolbar" %>
<%@ Register Src="~/_controls.helper/Uploader_DX.ascx" TagPrefix="uc1" TagName="Uploader_DX" %>
<uc1:Popup_DX runat="server" ID="pop" />
<uc1:Callback_Generic runat="server" ID="cb" />
<div class="filterTb">
    <div class="inner" style="padding: 10px;">
        <table style="border-spacing: 0px;">
            <tr>
                <td style="padding-right: 10px;">
                    <uc1:Uploader_DX runat="server" ID="u" />
                </td>
                <td style="padding-right: 10px;">选定的文件：
                    <asp:Label runat="server" ID="lbCount" Font-Bold="true" Text="0" />
                    个
                </td>
                <td>
                    <dx:ASPxButton runat="server" Text="开始导入" ID="bUpload">
                        <Image Url="~/images/_op_flatb_submit.gif" />
                    </dx:ASPxButton>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="padding-right: 10px;">默认 excel 工作表名字：
                </td>
                <td>
                    <dx:ASPxTextBox runat="server" Text="出租驾驶员考评信息列表" ID="tbSheetName" />
                </td>
            </tr>
        </table>
    </div>
</div>
<div style="padding: 10px;">
    <uc1:ActionToolbar runat="server" ID="at" Visible="false" />
    <uc1:GridWrapperForDetail runat="server" ID="gw" />
    <asp:GridView runat="server" ID="gv">
        <HeaderStyle CssClass="gridHeader" />
        <RowStyle Height="20" />
        <EmptyDataTemplate>
            <div class="emptyData">
                （空）
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</div>
<script runat="server">

    public class States
    {
        public const string Files = "files";
    }

    /// <summary>
    /// 缓存
    /// </summary>
    private List<KeyValuePair<Guid, UploadedFileWrapper>> _Files = new List<KeyValuePair<Guid, UploadedFileWrapper>>();
    public List<KeyValuePair<Guid, UploadedFileWrapper>> Files { get { return _Files; } }
    public enum WorkingMode { Complain, Violation }
    public WorkingMode Mode { set { _Mode = value; } }
    private WorkingMode _Mode = WorkingMode.Complain;
    protected override void _SetInitialStates()
    {
        u.ClientInstanceName = ClientID;
        u.TextChangeHandle = string.Format(
            "$get('{0}').innerText=s.GetFileInputCount();", lbCount.ClientID);
        u.Config();

        bUpload.ClientSideEvents.Click = string.Format(
            @"function(s,e){{
                if({0}.GetFileInputCount()>0){{
                    ISEx.loadingPanel.show('上传中，请稍候..');
                    {0}.Upload();
                }} else {{
                    alert('请先点击 [浏览] 选定待上传的文件');
                    e.processOnServer=false;
                }}
            }}", ClientID);

        bUpload.Click += (s, e) =>
        {
            if (Files.Count == 0)
            {
                Alert("请选择 excel 文件");
                return;
            }

            Do(Actions.Submit, true);
        };

        gw.Initialize(gv, c => c
            .TemplateField("A", "A:卷宗编号", new TemplateItem.Literal())
            .TemplateField("B", "B:考评年度", new TemplateItem.Literal())
            .TemplateField("C", "C:考评月份", new TemplateItem.Literal())
            .TemplateField("D", "D:案发时间", new TemplateItem.Literal())
            .TemplateField("E", "E:驾驶员", new TemplateItem.Literal())
            .TemplateField("F", "F:身份证", new TemplateItem.Literal())
            .TemplateField("G", "G:车牌号", new TemplateItem.Literal())
            .TemplateField("H", "H:考评信息", new TemplateItem.Literal())
            .TemplateField("I", "I:考评项目", new TemplateItem.Literal())
            .TemplateField("J", "J:考评标准", new TemplateItem.Literal())
            .TemplateField("K", "K:扣分", new TemplateItem.Literal())
            .TemplateField("L", "L:查出类型", new TemplateItem.Literal())
            .TemplateField("M", "M:查处部门", new TemplateItem.Literal())
            .TemplateField("N", "N:状态", new TemplateItem.Literal())
            .TemplateField("X", "（导入结果）", new TemplateItem.Literal(), f => f.ItemStyle.Wrap = false), checkBox: false);

    }

    protected override void _ViewStateProcess()
    {
        base._ViewStateProcess();
        u.Uploading(fs =>
        {
            Files.Clear();
            Files.AddRange(fs);
        });
    }

    protected override void _Do(string section, string subSection = null)
    {
        if (section != Actions.Submit) return;

        var context = _DTService.Context;
        var folder = "____temp/file";
        var fileName = Util.GetPhysicalPath(folder) + "\\" + string.Format("{0}_{1}.xls", "UPLOAD", Guid.NewGuid().ToISFormatted()).ToLower();
        var uploadedFile = Files[0].Value.File;
        uploadedFile.SaveAs(fileName);

        // 把EXCEL导入到DataSet
        var ds = new DataSet();
        var connString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source='" + fileName + "';Extended Properties=Excel 8.0";
        var connection = new OleDbConnection(connString);
        var handled = new List<object[]>();
        var unhandled = new List<object[]>();

        //A[0]: "201601223814"
        //B[1]: "2016"
        //C[2]: "1"
        //D[3]: "2016-01-11 19:28"
        //E[4]: "沈京阳"
        //F[5]: "32040219710707081X"
        //G[6]: "苏D5925X"
        //H[7]: "京沪高铁常州北站南一路违章上客"
        //I[8]: "经营行为"
        //J[9]: "在公示的营业区未按规定停放车辆、候客、揽客的。或在设立统一出租汽车调度服务站或实行排队候客的场所，出租汽车驾驶员未服从调度指挥，未按顺序排队候客的。或在排队候客区接受电话、手机召车软件等方式揽客的。"
        //K[10]: "5"
        //L[11]: "现场检查"
        //M[12]: "新北所"
        //N[13]: "企业已受理"

        try
        {
            connection.Open();
            var query = "SELECT * FROM [" + tbSheetName.Text.Trim() + "$] ";
            var command = new OleDbCommand(query, connection);
            var adapter = new OleDbDataAdapter(command);
            adapter.Fill(ds);
            ds.Tables[0].Rows.RemoveAt(0); // 去除第一行

            var keys = new Dictionary<string, string>();
            var plateNumbers = new List<string>();
            var driverMapping = new Dictionary<string, string>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                var vs = row.ItemArray;
                if (vs.Length != 14) continue;

                var numberInfo = vs[6].ToStringEx();
                if (numberInfo.Length > 5)
                {
                    var number = numberInfo.Substring(numberInfo.Length - 5, 5);
                    if (!
                        plateNumbers.Contains(number))
                        plateNumbers.Add(number);
                    var keyInfo = vs[0].ToStringEx();
                    if (!string.IsNullOrEmpty(keyInfo) &&
                        !keys.ContainsKey(keyInfo)) keys.Add(keyInfo, number);
                }

                var driverCHNId = vs[5].ToStringEx();
                if (!string.IsNullOrEmpty(driverCHNId) &&
                    !driverMapping.ContainsKey(driverCHNId))
                    driverMapping.Add(driverCHNId, driverCHNId);
            }

            // 查重

            var keyString = keys.Keys.ToArray().ToFlat();
            var processed = new List<string>();
            switch (_Mode)
            {
                case WorkingMode.Complain:
                    processed = context.CarComplains.Where(c => keyString.IndexOf(c.Id) != -1).Select(c => c.Id).ToList();
                    break;
                case WorkingMode.Violation:
                    processed = context.CarViolations.Where(c => keyString.IndexOf(c.Id) != -1).Select(c => c.Id).ToList();
                    break;
            }

            var numberString = plateNumbers.ToFlat();
            var numberMapping = context.Cars
                .Where(c => numberString.IndexOf(c.PlateNumber) != -1)
                .Select(c => new { c.PlateNumber, c.Id })
                .Distinct()
                .ToDictionary(c => c.PlateNumber, c => c.Id);
            var ids = keys.Keys.ToArray();
            foreach (var id in ids)
            {
                if (numberMapping.ContainsKey(keys[id]))
                    keys[id] = numberMapping[keys[id]];
            }
            foreach (var id in ids)
            {
                if (keys[id].Length != 10) keys.Remove(id);
            }

            var chnString = driverMapping.Keys.ToArray().ToFlat();
            var driverIdSet = context.Drivers
                .Where(d => chnString.IndexOf(d.CHNId) != -1)
                .Select(d => new { d.CHNId, d.Id })
                .Distinct()
                .ToList();
            ids = driverMapping.Keys.ToArray();
            foreach (var id in ids)
            {
                if (driverIdSet.Any(d => d.CHNId == id))
                    driverMapping[id] = driverIdSet.First(d => d.CHNId == id).Id;
            }
            foreach (var id in ids)
            {
                if (driverMapping[id].Length != 10) driverMapping.Remove(id);
            }

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                var vs = row.ItemArray;
                if (vs.Length != 14)
                {
                    unhandled.Add(vs.Concat(new object[] { "列数不对（应该是 14 列）" }).ToArray());
                    continue;
                }

                var keyInfo = vs[0].ToStringEx();
                var chnInfo = vs[5].ToStringEx();

                if (string.IsNullOrEmpty(keyInfo))
                {
                    unhandled.Add(vs.Concat(new object[] { "缺失案卷编号" }).ToArray());
                    continue;
                }

                if (string.IsNullOrEmpty(chnInfo))
                {
                    unhandled.Add(vs.Concat(new object[] { "司机身份证缺失" }).ToArray());
                    continue;
                }

                if (!driverMapping.ContainsKey(chnInfo))
                {
                    unhandled.Add(vs.Concat(new object[] { "通过身份证找不到对应司机" }).ToArray());
                    continue;
                }

                if (!keys.ContainsKey(keyInfo))
                {
                    unhandled.Add(vs.Concat(new object[] { "车牌号未在系统登记" }).ToArray());
                    continue;
                }

                if (processed.Contains(keyInfo.Substring(2)))
                {
                    unhandled.Add(vs.Concat(new object[] { "已经存在卷宗编号" }).ToArray());
                    continue;
                }

                switch (_Mode)
                {
                    case WorkingMode.Complain:
                        context
                            .Create<TB_car_complain>(_SessionEx, c =>
                            {
                                c.Id = keyInfo.Substring(2);
                                c.CarId = keys[keyInfo];
                                c.DriverId = driverMapping[chnInfo];
                                c.Time = DataConvert.From<DateTime>(vs[3].ToStringEx(), _SessionEx.Culture);
                                c.Status = (int)IssueStatus.Commit;
                                c.Name = vs[8].ToStringEx();
                                c.Description = vs[9].ToStringEx();
                                c.Result = vs[7].ToStringEx();
                                c.OwnFault = true;
                                c.Fine = DataConvert.From<int>(vs[10].ToStringEx(), _SessionEx.Culture);

                                switch (vs[11].ToStringEx())
                                {
                                    default:
                                        c.Source = (int)ComplainSource.S96169;
                                        break;
                                }

                                switch (vs[8].ToStringEx())
                                {
                                    default:
                                        c.Type = (int)ComplainType.BWM;
                                        break;
                                }

                            })
                            .SubmitChanges();
                        handled.Add(vs.Concat(new object[] { "成功导入" }).ToArray());
                        break;
                    case WorkingMode.Violation:
                        context
                            .Create<TB_car_violation>(_SessionEx, v =>
                            {
                                v.Id = keyInfo.Substring(2);
                                v.CarId = keys[keyInfo];
                                v.DriverId = driverMapping[chnInfo];
                                v.Time = DataConvert.From<DateTime>(vs[3].ToStringEx(), _SessionEx.Culture);
                                v.Status = (int)IssueStatus.Commit;
                                v.Name = vs[8].ToStringEx();
                                v.Description = vs[9].ToStringEx();
                                v.Place = vs[7].ToStringEx();
                                v.DemeritPoints = DataConvert.From<int>(vs[10].ToStringEx(), _SessionEx.Culture);
                                v.SeverityLevel = (int)SeverityLevel.Normal;

                                switch (vs[7].ToStringEx())
                                {
                                    default:
                                        v.Type = (int)ViolationType.QT;
                                        break;
                                }

                                switch (vs[8].ToStringEx())
                                {
                                    default:
                                        v.Type = (int)ComplainType.BWM;
                                        break;
                                }

                            })
                            .SubmitChanges();
                        handled.Add(vs.Concat(new object[] { "成功导入" }).ToArray());
                        break;
                }
            }

            var total = handled.Concat(unhandled).ToList();
            gw.Execute(total, b => b
                .Do<Literal>("A", (c, d) => c.Text = d[0].ToStringEx())
                .Do<Literal>("B", (c, d) => c.Text = d[1].ToStringEx())
                .Do<Literal>("C", (c, d) => c.Text = d[2].ToStringEx())
                .Do<Literal>("D", (c, d) => c.Text = d[3].ToStringEx())
                .Do<Literal>("E", (c, d) => c.Text = d[4].ToStringEx())
                .Do<Literal>("F", (c, d) => c.Text = d[5].ToStringEx())
                .Do<Literal>("G", (c, d) => c.Text = d[6].ToStringEx())
                .Do<Literal>("H", (c, d) => c.Text = d[7].ToStringEx())
                .Do<Literal>("I", (c, d) => c.Text = d[8].ToStringEx())
                .Do<Literal>("J", (c, d) => c.Text = d[9].ToStringEx())
                .Do<Literal>("K", (c, d) => c.Text = d[10].ToStringEx())
                .Do<Literal>("L", (c, d) => c.Text = d[11].ToStringEx())
                .Do<Literal>("M", (c, d) => c.Text = d[12].ToStringEx())
                .Do<Literal>("N", (c, d) => c.Text = d[13].ToStringEx())
                .Do<Literal>("X", (c, d) =>
                {
                    var content = d[14].ToStringEx();
                    switch (content)
                    {
                        case "成功导入":
                            c.Text = string.Format("<span class='fonBlue'>{0}</span>", content);
                            break;
                        default:
                            c.Text = string.Format("<span class='fonRed'>{0}</span>", content);
                            break;
                    }
                })
            );
        }
        catch (Exception ex)
        {
            Alert(ex.Message);
            gw.Execute(new List<object[]>()
            {
            });

        }
        finally
        {
            connection.Close();
        }

    }

</script>

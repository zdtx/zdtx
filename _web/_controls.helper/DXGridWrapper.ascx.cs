using System;
using System.Data;
using System.Configuration;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using DevExpress.Web;
namespace eTaxi.Web.Controls
{
    /// <summary>
    /// Ϊ DevExpress �� ASPxGridView �ṩ���β���
    /// </summary>
    public partial class DXGridWrapper : BaseControl
    {
        /// <summary>
        /// ʵ��������
        /// </summary>
        public class Decorator
        {
            private ASPxGridView _Grid = null;
            private bool _AutoPostBack = false;
            public bool AutoPostBack { get { return _AutoPostBack; } }

            /// <summary>
            /// ��ʾ����
            /// </summary>
            /// <returns></returns>
            public Decorator ShowRowNumber(int index = 0)
            {
                var c = new GridViewDataTextColumn()
                {
                    Name = "rn",
                    Caption = "#",
                    ReadOnly = true,
                    VisibleIndex = index,
                    UnboundType = DevExpress.Data.UnboundColumnType.String,
                    Width = 35
                };

                c.HeaderStyle.HorizontalAlign = HorizontalAlign.Right;
                c.CellStyle.HorizontalAlign = HorizontalAlign.Right;
                c.CellStyle.VerticalAlign = VerticalAlign.Middle;
                c.CellStyle.ForeColor = System.Drawing.Color.Gray;
                c.Settings.AllowAutoFilter = DevExpress.Utils.DefaultBoolean.False;
                c.Settings.AllowAutoFilterTextInputTimer = DevExpress.Utils.DefaultBoolean.False;
                c.Settings.AllowDragDrop = DevExpress.Utils.DefaultBoolean.False;
                c.Settings.AllowGroup = DevExpress.Utils.DefaultBoolean.False;
                c.Settings.AllowHeaderFilter = DevExpress.Utils.DefaultBoolean.False;
                c.Settings.AllowSort = DevExpress.Utils.DefaultBoolean.False;

                _Grid.Columns.Insert(index, c);
                _Grid.CustomColumnDisplayText += (s, e) =>
                {
                    if (!
                        _Grid.IsGroupRow(e.VisibleRowIndex) &&
                        e.Column.VisibleIndex == index &&
                        e.Column.Name == "rn")
                    {
                        int groupCount = 0;
                        for (int i = 0; i < e.VisibleRowIndex; i++)
                            if (_Grid.IsGroupRow(i)) groupCount++;
                        e.DisplayText = (e.VisibleRowIndex + 1 - groupCount).ToString();
                    }
                };

                return this;
            }

            /// <summary>
            /// ��ʵ�У�֧����ѡ��ȫѡ
            /// </summary>
            /// <returns></returns>
            public Decorator ShowCheckAll(int index = 0)
            {
                var c = new GridViewCommandColumn()
                {
                    Name = "slt",
                    Caption = "ѡ",
                    VisibleIndex = index,
                    ShowSelectCheckbox = true,
                    Width = 30,
                    SelectAllCheckboxMode = GridViewSelectAllCheckBoxMode.Page
                };
                c.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
                _Grid.Columns.Insert(index, c);
                return this;
            }

            /// <summary>
            /// ����ģʽ
            /// </summary>
            /// <returns></returns>
            public Decorator EnableAutoPostBack()
            {
                _AutoPostBack = true;
                return this;
            }
            
            public Decorator(ASPxGridView gv) { _Grid = gv; }
        }

        public class ValueGetter
        {
            private ASPxGridView _Grid = null;
            private int _RowIndex = -1;
            private CultureInfo _Culture = CultureInfo.InvariantCulture;
            public ValueGetter(ASPxGridView gv, int rowIndex, CultureInfo culture)
            {
                _Grid = gv; 
                _RowIndex = rowIndex;
                _Culture = culture;
            }
            public T Get<T>(string name, T defaultValue = default(T))
            {
                var objValue = _Grid.GetRowValues(_RowIndex, name);
                if (objValue == null) return defaultValue;
                return DataConvert.From<T>(objValue, _Culture); 
            }
        }

        public class States
        {
            public const string SingleRowSelectedForDblClick = "singleClick";
        }

        /// <summary>
        /// ��˫�� GridView ��ʱ��
        /// </summary>
        public event Action<ASPxGridView, EventArgs> RowDblClick;

        /// <summary>
        /// ������ѡ�� Row ��ʱ��
        /// </summary>
        public event Action<ASPxGridView, EventArgs> RowClick;

        /// <summary>
        /// ˫�����б���ֻ��һ����ѡ��
        /// </summary>
        public bool SingleRowSelectedForDblClick
        {
            get { return _ViewStateEx.Get<bool>(States.SingleRowSelectedForDblClick, true); }
            set { _ViewStateEx.Set<bool>(value, States.SingleRowSelectedForDblClick); }
        }

        /// <summary>
        /// ��ʼ�����ã��� T ����ָ�� ��������
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="gv"></param>
        /// <param name="columnSet"></param>
        /// <param name="itemGet"></param>
        /// <param name="count"></param>
        public void Initialize(ASPxGridView gv,
            Action<Decorator> decorate = null, Action<ASPxGridView> afterHandle = null)
        {
            // һ���趨
            gv.Font.Size = new FontUnit(9);
            gv.AutoGenerateColumns = false;
            gv.ClientInstanceName = gv.ClientID;
            gv.Border.BorderStyle = BorderStyle.None;
            gv.Styles.Cell.HorizontalAlign = HorizontalAlign.Left;
            gv.SettingsBehavior.ProcessFocusedRowChangedOnServer = false;
            gv.SettingsBehavior.ProcessSelectionChangedOnServer = false;
            gv.SettingsBehavior.ColumnResizeMode = DevExpress.Web.ColumnResizeMode.NextColumn;
            gv.SettingsBehavior.AllowSelectByRowClick = true;
            gv.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
            gv.SettingsPager.ShowEmptyDataRows = true;
            gv.SettingsPager.Visible = false;
            gv.ClientSideEvents.RowDblClick = string.Format(
                "function(s,e){{s.UnselectAllRowsOnPage();s.SelectRowOnPage(e.visibleIndex,true);ISEx.loadingPanel.show();{0};}}",
                Page.ClientScript.GetPostBackEventReference(_rdbc, string.Empty));
            gv.ClientSideEvents.RowClick =
                "function(s,e){s.SelectRowOnPage(e.visibleIndex,!s.IsRowSelectedOnPage(e.visibleIndex));}";

            // ����
            gv.SettingsText.EmptyDataRow = "�������ݣ�";
            gv.SettingsLoadingPanel.Text = "���Ժ�..";

            Decorator decorator = new Decorator(gv);
            if (decorate != null) decorate(decorator);

            // ������
            if (decorator.AutoPostBack)
            {
                gv.ClientSideEvents.RowClick = string.Format(
                    "function(s,e){{ISEx.loadingPanel.show();s.SelectRowOnPage(e.visibleIndex,!s.IsRowSelectedOnPage(e.visibleIndex));{0};}}",
                    Page.ClientScript.GetPostBackEventReference(_rc, string.Empty));
            }

            // �¼���

            _rdbc.Click += (s, e) =>
            {
                if ((
                    SingleRowSelectedForDblClick && gv.Selection.Count == 1) || !
                    SingleRowSelectedForDblClick)
                    if (RowDblClick != null) RowDblClick(gv, new EventArgs());
            };

            _rc.Click += (s, e) =>
            {
                if (RowClick != null) RowClick(gv, new EventArgs());
            };

            // ����������Ϣ
            if (afterHandle != null) afterHandle(gv);

        }

        // Execute

        /// <summary>
        /// ���ֵ
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="rowIndex"></param>
        /// <param name="Name"></param>
        /// <returns></returns>
        public DXGridWrapper DataGet(ASPxGridView gv, int rowIndex, CultureInfo culture,
            Action<ValueGetter> handle) { handle(new ValueGetter(gv, rowIndex, culture)); return this; }

    }
}
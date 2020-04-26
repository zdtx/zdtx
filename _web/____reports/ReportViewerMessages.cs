using Microsoft.Reporting.WebForms;

namespace eTaxi
{
    public class ReportViewerMessagesHANS : IReportViewerMessages, IReportViewerMessages5
    {
        public string DocumentMapButtonToolTip => string.Empty;

        public string ParameterAreaButtonToolTip => string.Empty;

        public string FirstPageButtonToolTip => string.Empty;

        public string PreviousPageButtonToolTip => string.Empty;

        public string CurrentPageTextBoxToolTip => string.Empty;

        public string PageOf => string.Empty;

        public string NextPageButtonToolTip => string.Empty;

        public string LastPageButtonToolTip => string.Empty;

        public string BackButtonToolTip => string.Empty;

        public string RefreshButtonToolTip => string.Empty;

        public string PrintButtonToolTip => "打印报表";

        public string ExportButtonToolTip => string.Empty;

        public string ZoomControlToolTip => string.Empty;

        public string SearchTextBoxToolTip => string.Empty;

        public string FindButtonToolTip => string.Empty;

        public string FindNextButtonToolTip => string.Empty;

        public string FoundResultText => string.Empty;

        public string ZoomToPageWidth => string.Empty;

        public string ZoomToWholePage => string.Empty;

        public string FindButtonText => "查找";

        public string FindNextButtonText => "下一个";

        public string ViewReportButtonText => "查看";

        public string ProgressText => string.Empty;

        public string TextNotFound => "找不到";

        public string NoMoreMatches => string.Empty;

        public string ChangeCredentialsText => string.Empty;

        public string NullCheckBoxText => string.Empty;

        public string NullValueText => string.Empty;

        public string TrueValueText => string.Empty;

        public string FalseValueText => string.Empty;

        public string SelectAValue => string.Empty;

        public string UserNamePrompt => string.Empty;

        public string PasswordPrompt => string.Empty;

        public string SelectAll => string.Empty;

        public string TodayIs => string.Empty;

        public string ExportFormatsToolTip => string.Empty;

        public string ExportButtonText => "导出";

        public string SelectFormat => string.Empty;

        public string DocumentMap => string.Empty;

        public string InvalidPageNumber => string.Empty;

        public string ChangeCredentialsToolTip => string.Empty;

        public string PrintText => "页面设置";

        public string PrintButtonText => "打印";

        public string CancelButtonText => "取消";

        public string DoneButtonText => "完成";

        public string PageSizeLabelText => string.Empty;

        public string PageOrientationLabelText => string.Empty;

        public string SettingText => string.Empty;

        public string PortraitText => "纵向";

        public string LandscapeText => "横向";

        public string LoadingText => string.Empty;

        public string FooterText => string.Empty;

        public string DoneText => string.Empty;

        public string DownloadText => string.Empty;

        public string DownloadLinkText => string.Empty;

        public string CaptionText => string.Empty;

        public string ShowDocumentMapButtonTooltip => string.Empty;

        public string HideDocumentMapButtonTooltip => string.Empty;

        public string ShowParameterAreaButtonToolTip => string.Empty;

        public string HideParameterAreaButtonToolTip => string.Empty;

        public string CancelLinkText => string.Empty;

        public string CalendarLoading => string.Empty;

        public string ClientNoScript => string.Empty;

        public string ParameterDropDownToolTip => string.Empty;

        public string CredentialMissingUserNameError(string dataSourcePrompt)
        {
            return dataSourcePrompt;
        }

        public string GetLocalizedNameForRenderingExtension(string format)
        {
            if (format.ToUpper().StartsWith("EXCEL")) return "EXCEL";
            if (format.ToUpper().StartsWith("WORD")) return "WORD";
            return format;
        }

        public string ParameterMissingSelectionError(string parameterPrompt)
        {
            return parameterPrompt;
        }

        public string ParameterMissingValueError(string parameterPrompt)
        {
            return parameterPrompt;
        }

        public string TotalPages(int pageCount, PageCountMode pageCountMode)
        {
            return string.Empty;
        }
    }
}
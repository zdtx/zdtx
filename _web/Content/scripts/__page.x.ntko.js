
// 必须先行 __page.js

ISEx.extend({
    ntko: {
        worker: undefined,
        urls: {},
        sessionId: "",
        initialized: false,
        documentOpened: false,
        docTypeEnum: {
            None: 0, Word: 1, Excel: 2, PowerPoint: 3, Visio: 4, Project: 5, WPS_Document: 6, WPS_Sheet: 7, Other: 100, Unknown: -1
        },
        currentUser: "未知用户",
        currentDocType: "",
        currentDocName: "",
        control: {
            showLoadProgress: true
        },
        outlook: {
            file: {
                create: false,
                close: false,
                open: false,
                save: false,
                saveAs: false
            },
            titleBar: false,
            menubar: true,
            toolbar: false
        },
        toolbar: {
            save: false,
            selectTemplate: false,

            // 编辑
            reviseByHand: false,
            insertPicture: false,
            insertPictureLocal: false,
            acceptRevision: false,

            // 阅读
            proofCheck: false,
            setRevisionVisible: false,
            print: false,
            printPreview: false,

            // 印章
            stamp: false,
            stampLocal: false,
            signByHand: false
        },
        secOption: {
            clipboard: false,
            copyPaste: false
        },
        initProtocol: { // 初始化协议
            succeeded: function () { },
            failed: function (msg) { alert(msg); }
        },
        openProtocol: {
            url: "",
            readOnly: true,
            trackRevisions: false,
            showRevisions: false,
            succeeded: function () { },
            failed: function (msg) { alert(msg); }
        },
        saveProtocol: {
            url: "",
            succeeded: function () { },
            failed: function (msg) { alert(msg); }
        },

        begin: function (protocol) {
            var x = this;
            ISEx.apply(x.initProtocol, protocol);
            if (x.initialized) { x.initProtocol.succeeded(); return; }
            alert("由于控件未能初始化，文档未加载");
        },

        // 根据反调回来的文档控件句柄判断初始化
        initWorker: function (worker) {
            var x = this;
            if (worker === undefined) {
                x.worker = undefined;
                x.initialized = false;
                return;
            }
            try {

                // 进行控件的初始化
                worker.FilePageSetup = true;
                worker.FileProperties = true;
                x.worker = worker;
                x.initialized = true;
                x.initProtocol.succeeded();
            }
            catch (err) {
                x.worker = undefined;
                x.initialized = false;
                x.initProtocol.failed("对象不可用（文档控件仅能运行在 IE 兼容的浏览器中，例如：360、遨游，等）");
            }
        },

        openDocument: function (protocol) {
            var x = this;
            var p = {};
            ISEx.apply(p, x.openProtocol);
            ISEx.apply(p, protocol);
            try {
                // alert(p.url);
                // x.worker.OpenFromURL(p.url, p.readOnly);
                ISEx.sleep(500, function () {
                    x.worker.BeginOpenFromURL(p.url, x.control.showLoadProgress, p.readOnly);
                });
            }
            catch (err) {
                x.documentOpened = false;
                x.openProtocol.failed("错误：" + err.number + ":" + err.description);
            }
        },

        saveDocument: function (protocol) {
        },

        configure: function (readOnly, fn) {

            var x = this;
            if (fn !== undefined) fn(x.Outlook, x.Toolbar, x.SecOption);
            if (readOnly) {
                with (x.Toolbar) {
                    Save = false;
                    SelectTemplate = false;
                    // 编辑
                    ReviseByHand = false;
                    InsertPicture = false;
                    InsertPictureLocal = false;
                    AcceptRevision = false;
                    // 印章
                    Stamp = false;
                    StampLocal = false;
                    SignByHand = false
                }
                with (x.SecOption) {
                    Clipboard = false;
                    CopyPaste = false;
                }
            }

            // 设定控件参数
            if (x.initialized) {
                with (x.worker) {
                    Menubar = x.Outlook.Menubar;
                    Titlebar = x.Outlook.Titlebar;
                    ToolBars = x.Outlook.Toolbar;
                    FileNew = x.Outlook.File.New;
                    FileOpen = x.Outlook.File.Open;
                    FileClose = x.Outlook.File.Close;
                    FileSave = x.Outlook.File.Save;
                    FileSaveAs = x.Outlook.File.SaveAs;

                    FilePrint = x.Toolbar.Print;
                    FilePrintPreview = x.Toolbar.PrintPreview;
                    IsNoCopy = !x.SecOption.Clipboard;
                    IsStructNoCopy = !x.SecOption.CopyPaste;
                }
                if (x.documentOpened) x.worker.SetReadOnly(readOnly, "");
            }

            x.os.bSave.setVisible(x.Toolbar.Save);
            x.os.bSelectTemplate.setVisible(x.Toolbar.SelectTemplate);
            x.os.bReviseByHand.setVisible(x.Toolbar.ReviseByHand);
            x.os.bInsertPicture.setVisible(x.Toolbar.InsertPicture);
            x.os.bAcceptRevision.setVisible(x.Toolbar.AcceptRevision);
            x.os.bProofCheck.setVisible(x.Toolbar.ProofCheck);
            x.os.bSetRevisionVisible.setVisible(x.Toolbar.SetRevisionVisible);
            x.os.bPrint.setVisible(x.Toolbar.Print);
            x.os.bStamp.setVisible(x.Toolbar.Stamp);
            x.os.bStampLocal.setVisible(x.Toolbar.StampLocal);
            x.os.bSignByHand.setVisible(x.Toolbar.SignByHand);

        },

        reviseByHand: function () {
            var x = this;
            if (x.initialized && x.documentOpened) x.worker.DoHandDraw2();
        },
        insertPicture: function (local) {
            var x = this;
            if (x.initialized && x.documentOpened) { x.worker.AddPicFromLocal("pic", true, true); }
        },
        acceptRevision: function () {
            var x = this;
            if (x.initialized && x.documentOpened) x.worker.ActiveDocument.AcceptAllRevisions();
        },
        proofCheck: function () {
            var x = this;
            if (x.initialized && x.documentOpened) x.worker.DoCheckSign();
        },
        stamp: function (local) {
            var x = this;
            if (x.initialized && x.documentOpened) if (local) x.worker.AddSignFromLocal(x.currentUser, "stamp"); else { }
        },
        setRevisionVisible: function (visible) {
            var x = this;
            if (x.initialized && x.documentOpened) x.worker.ActiveDocument.ShowRevisions = visible;
        },
        signByHand: function () {
            var x = this;
            if (x.initialized && x.documentOpened) x.worker.DoHandSign2(x.currentUser);
        },
        printDocument: function (preview) {
            var x = this;
            if (x.initialized && x.documentOpened) if (preview) x.worker.PrintPreview(); else x.worker.PrintOut();
        },
        saveDocument: function () {
            var x = this;
            ISEx.apply(x.SaveProtocol, protocol);
            try {
                x.worker.SaveToURL(x.SaveProtocol.Url, "EDITFILE", "", x.currentDocName, 0);
                x.SaveProtocol.succeeded();
            }
            catch (err) {
                x.SaveProtocol.failed(err);
            }
        },
        selectTemplate: function () { },

        // 处理页面事件
        processEvent: function (eventName, parameters) {
            var x = this;
            switch (eventName) {
                case "OnDocumentOpened":
                    x.onDocumentOpened(parameters.url, parameters.worker);
                    break;
                case "AfterOpenFromURL":
                    x.afterOpenFromURL(parameters.docObject);
                    break;
                case "OnDocumentClosed":
                    x.onDocumentClosed();
                    break;
                case "OnSignSelect":
                    x.onSignSelect(parameters.successful, parameters.signInfo);
                    break;
                case "AfterHandSignOrDraw":
                    x.afterHandSignOrDraw(parameters.action, parameters.hasCanceled);
                    break;
            }
        },

        // 文档对象顺利打开
        onDocumentOpened: function (url, worker) {

            var x = this;
            x.documentOpened = true;

            // 设定应用参数
            with (x.worker.ActiveDocument.Application) {
                UserName = x.currentUser;
            }

            with (x.worker.ActiveDocument) {
                TrackRevisions = x.openProtocol.TrackRevisions;
                ShowRevisions = x.openProtocol.ShowRevisions;
            }

            var enu = x.docTypeEnum;
            switch (x.worker.DocType) {
                case 0:
                    x.currentDocType = enu.None;
                    break;
                case 1:
                    x.currentDocType = enu.Word;
                    break;
                case 2:
                    x.currentDocType = enu.Excel;
                    break;
                case 3:
                    x.currentDocType = enu.PowerPoint;
                    break;
                case 4:
                    x.currentDocType = enu.Visio;
                    break;
                case 5:
                    x.currentDocType = enu.Project;
                    break;
                case 6:
                    x.currentDocType = enu.WPS_Document;
                    break;
                case 7:
                    x.currentDocType = enu.WPS_Sheet;
                    break;
                case 100:
                    x.currentDocType = enu.Other;
                    break;
                default:
                    x.currentDocType = enu.Unknown;
                    break;
            }

            x.documentOpened = true;
            x.openProtocol.succeeded();
        },

        afterOpenFromURL: function (docObject) {
            try {
                docObject.ActiveWindow.ActivePane.View.Zoom.PageFit = 2; // wdPageFitBestFit;
                docObject.ActiveWindow.ActivePane.View.ShowDrawings = true; // wdPageFitBestFit;
            }
            catch (err) { }
        },

        onDocumentClosed: function () {
            this.documentOpened = false;
        },

        onSignSelect: function (successful, signInfo) {
        },

        afterHandSignOrDraw: function (action, hasCanceled) {
        }
    }
});




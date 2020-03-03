namespace eTaxi
{
    partial class Installer
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region 组件设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this._ProcessInstaller = new System.ServiceProcess.ServiceProcessInstaller();
            this._Installer = new System.ServiceProcess.ServiceInstaller();
            // 
            // _ProcessInstaller
            // 
            this._ProcessInstaller.Account = System.ServiceProcess.ServiceAccount.LocalSystem;
            this._ProcessInstaller.Password = null;
            this._ProcessInstaller.Username = null;
            // 
            // _Installer
            // 
            this._Installer.Description = "为 eTaxi 系统提供实时服务加载平台";
            this._Installer.DisplayName = "eTaxi Services";
            this._Installer.ServiceName = "eTaxi.Services";
            this._Installer.StartType = System.ServiceProcess.ServiceStartMode.Automatic;
            // 
            // Installer
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this._ProcessInstaller,
            this._Installer});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller _ProcessInstaller;
        private System.ServiceProcess.ServiceInstaller _Installer;
    }
}
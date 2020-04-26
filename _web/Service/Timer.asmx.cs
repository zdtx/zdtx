using System.Web.Services;

namespace eTaxi.Web.Service
{
    /// <summary>
    /// 为站点产生时序事件而预留的接口
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class Timer : BaseService
    {
        [WebMethod(Description = "用于时序发起")]
        public void Elapse(string secret)
        {
            if (secret != _Settings.Get<string>("secret")) return;
            var engine = Global.Workers.Get<TimerEngine>();
            engine.Pulse();
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data.Linq;
using System.Data;

namespace eTaxi.Exceptions
{
    public enum Common
    {
        /// <summary>
        /// 已经审核过的不能进行修改
        /// </summary>
        CannotUpdateFlowedObject,

        /// <summary>
        /// 流转中的数据不接受修改
        /// </summary>
        CannotUpdateFlowingObject,

        /// <summary>
        /// 不能提交非草稿状态的数据
        /// </summary>
        CannotSubmitNonDraftingObject,

        /// <summary>
        /// 不能修改非提交中的数据
        /// </summary>
        CannotUpdateNotSubmittedObject,

        /// <summary>
        /// 正在审核中的对象，不能重复提交。
        /// </summary>
        CannotSubmitFlowingObject,

        /// <summary>
        /// 该对象已经失效（enabled != 1）
        /// </summary>
        CannotProcessDisabledObject,

        /// <summary>
        /// 该对象还未审批成功
        /// </summary>
        CannotProcessUnapprovedObject
    }

    public enum Workflow
    {
        /// <summary>
        /// 不能提交非草稿下的业务单子
        /// </summary>
        CannotSubmitNotDraftingObject,

        /// <summary>
        /// 流程已经存在
        /// </summary>
        CannotSubmitWhenProcessAlreadyExists,

        /// <summary>
        /// 流程引擎出问题
        /// </summary>
        EngineReturnEmptyAppId,

        /// <summary>
        /// 流程还未完成
        /// </summary>
        ProcessNotCommitted
    }

    public enum DSS
    {
        /// <summary>
        /// 指标的计算值没搞好
        /// </summary>
        TemplateItemComputationNotSet,

        /// <summary>
        /// 公式错误
        /// </summary>
        TemplateItemExpressionSetWrong,

        /// <summary>
        /// 参照存在，不能删除
        /// </summary>
        DeleteFailedReferenceExists,

        /// <summary>
        /// 版本号不对
        /// </summary>
        VersionMismatched

    }

    public enum Tree
    {
        /// <summary>
        /// 出现父子死循环
        /// </summary>
        CicularParentFound,

        /// <summary>
        /// 删除失败，必须先删除子
        /// </summary>
        DeleteFailedWhenChildrenExists

    }


}

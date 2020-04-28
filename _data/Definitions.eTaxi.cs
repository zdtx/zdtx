namespace eTaxi.Definitions
{
    /// <summary>
    /// 性别
    /// </summary>
    public enum Gender
    {
        /// <summary>
        /// 未知
        /// </summary>
        [DefinitionItemSettings("（未知）")]
        Unknown = -1,
        /// <summary>
        /// 男
        /// </summary>
        [DefinitionItemSettings("男")]
        Male = 0,
        /// <summary>
        /// 女
        /// </summary>
        [DefinitionItemSettings("女")]
        Female = 1
    }

    /// <summary>
    /// 文化程度
    /// </summary>
    public enum Education
    {
        /// <summary>
        /// 未知
        /// </summary>
        [DefinitionItemSettings("（未知）")]
        Unknown = -1,
        /// <summary>
        /// 小学或以下
        /// </summary>
        [DefinitionItemSettings("小学或以下")]
        XX = 0,
        /// <summary>
        /// 初中
        /// </summary>
        [DefinitionItemSettings("初中")]
        CZ = 1,
        /// <summary>
        /// 高中
        /// </summary>
        [DefinitionItemSettings("高中")]
        GZ = 2,
        /// <summary>
        /// 大专
        /// </summary>
        [DefinitionItemSettings("大专")]
        DZ = 3,
        /// <summary>
        /// 大本
        /// </summary>
        [DefinitionItemSettings("本科或以上")]
        DB = 4,
        /// <summary>
        /// 职高
        /// </summary>
        [DefinitionItemSettings("职高")]
        ZG = 5,
        /// <summary>
        /// 中专
        /// </summary>
        [DefinitionItemSettings("中专")]
        ZZ = 6
    }

    /// <summary>
    /// 政治面貌
    /// </summary>
    public enum SocialCat
    {
        /// <summary>
        /// 群众
        /// </summary>
        [DefinitionItemSettings("群众")]
        QZ = 0,
        /// <summary>
        /// 党员
        /// </summary>
        [DefinitionItemSettings("党员")]
        DY = 1,
        /// <summary>
        /// 共青团员
        /// </summary>
        [DefinitionItemSettings("共青团员")]
        TY = 2
    }

    /// <summary>
    /// 车辆性质
    /// </summary>
    public enum CarType
    {
        /// <summary>
        /// 公营
        /// </summary>
        [DefinitionItemSettings("公营")]
        GY = 0,
        /// <summary>
        /// 挂靠
        /// </summary>
        [DefinitionItemSettings("挂靠")]
        GK = 1,
        /// <summary>
        /// 收购
        /// </summary>
        [DefinitionItemSettings("收购")]
        SG = 2,
        /// <summary>
        /// 众联
        /// </summary>
        [DefinitionItemSettings("众联")]
        ZL = 3,
        /// <summary>
        /// 个体
        /// </summary>
        [DefinitionItemSettings("个体")]
        GT = 4
    }

    /// <summary>
    /// 投诉来源
    /// </summary>
    public enum ComplainSource
    {
        /// <summary>
        /// 96169
        /// </summary>
        [DefinitionItemSettings("96169")]
        S96169 = 0,
        /// <summary>
        /// 电话
        /// </summary>
        [DefinitionItemSettings("电话")]
        DH = 1,
        /// <summary>
        /// 网络
        /// </summary>
        [DefinitionItemSettings("网络")]
        WL = 2,
        /// <summary>
        /// 其他
        /// </summary>
        [DefinitionItemSettings("其他")]
        QT = -1,
        [DefinitionItemSettings("complainSource", true)]
        UD10 = 10,
        [DefinitionItemSettings("complainSource", true)]
        UD11 = 11,
        [DefinitionItemSettings("complainSource", true)]
        UD12 = 12,
        [DefinitionItemSettings("complainSource", true)]
        UD13 = 13,
        [DefinitionItemSettings("complainSource", true)]
        UD14 = 14,
        [DefinitionItemSettings("complainSource", true)]
        UD15 = 15,
        [DefinitionItemSettings("complainSource", true)]
        UD16 = 16,
        [DefinitionItemSettings("complainSource", true)]
        UD17 = 17,
        [DefinitionItemSettings("complainSource", true)]
        UD18 = 18,
        [DefinitionItemSettings("complainSource", true)]
        UD19 = 19,
        [DefinitionItemSettings("complainSource", true)]
        UD20 = 20
    }

    /// <summary>
    /// 投诉类型
    /// </summary>
    public enum ComplainType
    {
        /// <summary>
        /// 拒载
        /// </summary>
        [DefinitionItemSettings("拒载")]
        JZ = 0,
        /// <summary>
        /// 绕路
        /// </summary>
        [DefinitionItemSettings("绕路")]
        RL = 1,
        /// <summary>
        /// 不文明服务
        /// </summary>
        [DefinitionItemSettings("不文明")]
        BWM = 2,
        /// <summary>
        /// 其他
        /// </summary>
        [DefinitionItemSettings("其他")]
        QT = -1,
        [DefinitionItemSettings("complainType", true)]
        UD10 = 10,
        [DefinitionItemSettings("complainType", true)]
        UD11 = 11,
        [DefinitionItemSettings("complainType", true)]
        UD12 = 12,
        [DefinitionItemSettings("complainType", true)]
        UD13 = 13,
        [DefinitionItemSettings("complainType", true)]
        UD14 = 14,
        [DefinitionItemSettings("complainType", true)]
        UD15 = 15,
        [DefinitionItemSettings("complainType", true)]
        UD16 = 16,
        [DefinitionItemSettings("complainType", true)]
        UD17 = 17,
        [DefinitionItemSettings("complainType", true)]
        UD18 = 18,
        [DefinitionItemSettings("complainType", true)]
        UD19 = 19,
        [DefinitionItemSettings("complainType", true)]
        UD20 = 20
    }

    /// <summary>
    /// 事故责任划分
    /// </summary>
    public enum AcidentDivision
    {
        /// <summary>
        /// 无责
        /// </summary>
        [DefinitionItemSettings("无责")]
        WZ = 0,
        /// <summary>
        /// 次要责任
        /// </summary>
        [DefinitionItemSettings("次要责任")]
        CZ = 1,
        /// <summary>
        /// 主要责任
        /// </summary>
        [DefinitionItemSettings("主要责任")]
        ZZ = 2
    }

    /// <summary>
    /// 参与公益、保障及好人好事记录
    /// </summary>
    public enum CarLogType
    {
        /// <summary>
        /// 公益保障
        /// </summary>
        [DefinitionItemSettings("公益保障")]
        GY = 0,
        /// <summary>
        /// 好人好事
        /// </summary>
        [DefinitionItemSettings("好人好事")]
        HRHS = 1,
        /// <summary>
        /// 其他
        /// </summary>
        [DefinitionItemSettings("其他")]
        QT = -1
    }

    /// <summary>
    /// 关于车辆的增减费用明细
    /// </summary>
    public enum CarBalanceSource
    {
        /// <summary>
        /// 管理费
        /// </summary>
        [DefinitionItemSettings("管理费")]
        Rental = 0,
        /// <summary>
        /// 参与公益、保障及好人好事记录
        /// </summary>
        [DefinitionItemSettings("参与公益、保障及好人好事记录")]
        Log = 1,
        /// <summary>
        /// 有关投诉
        /// </summary>
        [DefinitionItemSettings("投诉")]
        Complain
    }

    /// <summary>
    /// 事情的两个状态
    /// </summary>
    public enum IssueStatus
    {
        /// <summary>
        /// 未处理
        /// </summary>
        [DefinitionItemSettings("未处理")]
        Pending = 0,
        /// <summary>
        /// 已经收讫
        /// </summary>
        [DefinitionItemSettings("已经处理")]
        Commit = 1
    }

    /// <summary>
    /// 责任类型
    /// </summary>
    public enum AccidentFaultLevel
    {
        /// <summary>
        /// 无责
        /// </summary>
        [DefinitionItemSettings("无责")]
        Zero = -1,
        /// <summary>
        /// 次责
        /// </summary>
        [DefinitionItemSettings("次责")]
        Minor = 1,
        /// <summary>
        /// 主责
        /// </summary>
        [DefinitionItemSettings("主责")]
        Major = 2,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD10 = 10,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD11 = 11,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD12 = 12,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD13 = 13,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD14 = 14,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD15 = 15,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD16 = 16,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD17 = 17,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD18 = 18,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD19 = 19,
        [DefinitionItemSettings("accidentFaultLevel", true)]
        UD20 = 20
    }

    /// <summary>
    /// 违章类型
    /// </summary>
    public enum ViolationType
    {
        /// <summary>
        /// 闯红灯
        /// </summary>
        [DefinitionItemSettings("违章-闯红灯")]
        CHD = 0,
        /// <summary>
        /// 压线
        /// </summary>
        [DefinitionItemSettings("违章-压线")]
        YX = 1,
        /// <summary>
        /// 逆行
        /// </summary>
        [DefinitionItemSettings("违章-逆行")]
        NX = 2,
        /// <summary>
        /// 违章停车
        /// </summary>
        [DefinitionItemSettings("违章-违章停车")]
        WZTC = 3,
        /// <summary>
        /// 超速
        /// </summary>
        [DefinitionItemSettings("违章-超速")]
        CS = 4,
        /// <summary>
        /// 其他
        /// </summary>
        [DefinitionItemSettings("违章-其他")]
        QT = -1,
        [DefinitionItemSettings("violationType", true)]
        UD10 = 10,
        [DefinitionItemSettings("violationType", true)]
        UD11 = 11,
        [DefinitionItemSettings("violationType", true)]
        UD12 = 12,
        [DefinitionItemSettings("violationType", true)]
        UD13 = 13,
        [DefinitionItemSettings("violationType", true)]
        UD14 = 14,
        [DefinitionItemSettings("violationType", true)]
        UD15 = 15,
        [DefinitionItemSettings("violationType", true)]
        UD16 = 16,
        [DefinitionItemSettings("violationType", true)]
        UD17 = 17,
        [DefinitionItemSettings("violationType", true)]
        UD18 = 18,
        [DefinitionItemSettings("violationType", true)]
        UD19 = 19,
        [DefinitionItemSettings("violationType", true)]
        UD20 = 20
    }

    /// <summary>
    /// 违章程度
    /// </summary>
    public enum SeverityLevel
    {
        /// <summary>
        /// 一般
        /// </summary>
        [DefinitionItemSettings("一般")]
        Normal = 0,
        /// <summary>
        /// 严重
        /// </summary>
        [DefinitionItemSettings("严重")]
        Serious = 1,
        [DefinitionItemSettings("severityLevel", true)]
        UD10 = 10,
        [DefinitionItemSettings("severityLevel", true)]
        UD11 = 11,
        [DefinitionItemSettings("severityLevel", true)]
        UD12 = 12,
        [DefinitionItemSettings("severityLevel", true)]
        UD13 = 13,
        [DefinitionItemSettings("severityLevel", true)]
        UD14 = 14,
        [DefinitionItemSettings("severityLevel", true)]
        UD15 = 15,
        [DefinitionItemSettings("severityLevel", true)]
        UD16 = 16,
        [DefinitionItemSettings("severityLevel", true)]
        UD17 = 17,
        [DefinitionItemSettings("severityLevel", true)]
        UD18 = 18,
        [DefinitionItemSettings("severityLevel", true)]
        UD19 = 19,
        [DefinitionItemSettings("severityLevel", true)]
        UD20 = 20
    }

    /// <summary>
    /// 事情的两个状态
    /// </summary>
    public enum DriverStatus
    {
        /// <summary>
        /// 在职
        /// </summary>
        [DefinitionItemSettings("在职")]
        On = 0,
        /// <summary>
        /// 离职
        /// </summary>
        [DefinitionItemSettings("离职")]
        Off = 1,
        /// <summary>
        /// 代班
        /// </summary>
        [DefinitionItemSettings("代班")]
        Shift = 2
    }

    public enum ContractType
    {
        [DefinitionItemSettings("标准合同")]
        Standard = 0
    }

    public enum ChargeType
    {
        [DefinitionItemSettings("按月")]
        Monthly = 0,
        [DefinitionItemSettings("按年")]
        Yearly = 1,
        [DefinitionItemSettings("按实际天数")]
        DayCount = 2,
        [DefinitionItemSettings("有系统计算")]
        Computed = 3,
        [DefinitionItemSettings("临时")]
        Addhoc = 9
    }

    public enum MonthType
    {
        [DefinitionItemSettings("(未指定)")]
        NotSpecified = 0,
        [DefinitionItemSettings("1月")]
        Jan = 1,
        [DefinitionItemSettings("2月")]
        Feb = 2,
        [DefinitionItemSettings("3月")]
        Mar = 3,
        [DefinitionItemSettings("4月")]
        Apr = 4,
        [DefinitionItemSettings("5月")]
        May = 5,
        [DefinitionItemSettings("6月")]
        Jun = 6,
        [DefinitionItemSettings("7月")]
        Jul = 7,
        [DefinitionItemSettings("8月")]
        Aug = 8,
        [DefinitionItemSettings("9月")]
        Sep = 9,
        [DefinitionItemSettings("10")]
        Oct = 10,
        [DefinitionItemSettings("11")]
        Nov = 11,
        [DefinitionItemSettings("12月")]
        Dec = 12,
    }


}

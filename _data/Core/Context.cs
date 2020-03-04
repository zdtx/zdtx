using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data;
using System.Reflection;

namespace eTaxi.L2SQL
{
    /// <summary>
    /// 全局通用上下文
    /// </summary>
    public partial class CommonContext : DataContextEx
    {
        /// <summary>
        /// 出租车记录
        /// </summary>
        public Table<TB_car> Cars
        {
            get { return this.GetTable<TB_car>(); }
        }

        /// <summary>
        /// 交通事故记录
        /// </summary>
        public Table<TB_car_accident> CarAccidents
        {
            get { return this.GetTable<TB_car_accident>(); }
        }

        public Table<TB_car_replace> CarReplaces
        {
            get { return this.GetTable<TB_car_replace>(); }
        }

        /// <summary>
        /// 车辆收支项
        /// </summary>
        public Table<TB_car_balance> CarBalances
        {
            get { return this.GetTable<TB_car_balance>(); }
        }

        /// <summary>
        /// 车辆投诉记录
        /// </summary>
        public Table<TB_car_complain> CarComplains
        {
            get { return this.GetTable<TB_car_complain>(); }
        }

        /// <summary>
        /// 车辆年审记录
        /// </summary>
        public Table<TB_car_inspection> CarInspections
        {
            get { return this.GetTable<TB_car_inspection>(); }
        }

        /// <summary>
        /// 车辆保险记录
        /// </summary>
        public Table<TB_car_insurance> CarInsurances
        {
            get { return this.GetTable<TB_car_insurance>(); }
        }

        /// <summary>
        /// 车辆日志
        /// </summary>
        public Table<TB_car_log> CarLogs
        {
            get { return this.GetTable<TB_car_log>(); }
        }

        /// <summary>
        /// 车辆承租记录
        /// </summary>
        public Table<TB_car_rental> CarRentals
        {
            get { return this.GetTable<TB_car_rental>(); }
        }

        /// <summary>
        /// 承租的司机记录
        /// </summary>
        public Table<TB_car_rental_history> CarRentalHistories
        {
            get { return this.GetTable<TB_car_rental_history>(); }
        }

        /// <summary>
        /// 车辆承租计费记录
        /// </summary>
        public Table<TB_car_payment> CarPayments
        {
            get { return this.GetTable<TB_car_payment>(); }
        }

        /// <summary>
        /// 车辆代班记录
        /// </summary>
        public Table<TB_car_rental_shift> CarRentalShifts
        {
            get { return this.GetTable<TB_car_rental_shift>(); }
        }

        /// <summary>
        /// 车辆违章
        /// </summary>
        public Table<TB_car_violation> CarViolations
        {
            get { return this.GetTable<TB_car_violation>(); }
        }

        /// <summary>
        /// 司机
        /// </summary>
        public Table<TB_driver> Drivers
        {
            get { return this.GetTable<TB_driver>(); }
        }

        /// <summary>
        /// 司机资质信誉考核记录
        /// </summary>
        public Table<TB_driver_certificate> DriverCertificates
        {
            get { return this.GetTable<TB_driver_certificate>(); }
        }

        /// <summary>
        /// 司机管理日志
        /// </summary>
        public Table<TB_driver_log> DriverLogs
        {
            get { return this.GetTable<TB_driver_log>(); }
        }

        /// <summary>
        /// 内部管理人员
        /// </summary>
        public Table<TB_person> Persons
        {
            get { return this.GetTable<TB_person>(); }
        }

        /// <summary>
        /// 用户
        /// </summary>
        public Table<TB_aspnet_Users> Users
        {
            get { return this.GetTable<TB_aspnet_Users>(); }
        }

        /// <summary>
        /// 岗位
        /// </summary>
        public Table<TB_position> Positions
        {
            get { return this.GetTable<TB_position>(); }
        }

        /// <summary>
        /// 行政级别
        /// </summary>
        public Table<TB_rank> Ranks
        {
            get { return this.GetTable<TB_rank>(); }
        }

        /// <summary>
        /// 部门
        /// </summary>
        public Table<TB_department> Departments
        {
            get { return this.GetTable<TB_department>(); }
        }

        /// <summary>
        /// 系统序列
        /// </summary>
        public Table<TB_sys_sequence> Sequences
        {
            get { return this.GetTable<TB_sys_sequence>(); }
        }

        /// <summary>
        /// 系统模块
        /// </summary>
        public Table<TB_sys_module> Modules
        {
            get { return this.GetTable<TB_sys_module>(); }
        }

        /// <summary>
        /// 访问控制列表
        /// </summary>
        public Table<TB_sys_acl> ACLs
        {
            get { return this.GetTable<TB_sys_acl>(); }
        }

        /// <summary>
        /// 批任务
        /// </summary>
        public Table<TB_sys_batch> Batches
        {
            get { return this.GetTable<TB_sys_batch>(); }
        }

        /// <summary>
        /// 批务项（分项）
        /// </summary>
        public Table<TB_sys_batch_item> BatchItems
        {
            get { return this.GetTable<TB_sys_batch_item>(); }
        }

        /// <summary>
        /// 经营模式（套餐）
        /// </summary>
        public Table<TB_package> Packages
        {
            get { return this.GetTable<TB_package>(); }
        }

        /// <summary>
        /// 应用集合（来自 aspnet 框架）
        /// </summary>
        public Table<TB_aspnet_Applications> AS_Applications
        {
            get { return this.GetTable<TB_aspnet_Applications>(); }
        }

        /// <summary>
        /// 人员帐号集合（来自 aspnet 框架）
        /// </summary>
        public Table<TB_aspnet_Membership> AS_Memberships
        {
            get { return this.GetTable<TB_aspnet_Membership>(); }
        }

        /// <summary>
        /// 人员集合（来自 aspnet 框架）
        /// </summary>
        public Table<TB_aspnet_Users> AS_Users
        {
            get { return this.GetTable<TB_aspnet_Users>(); }
        }

        /// <summary>
        /// 系统角色（来自 aspnet 框架）
        /// </summary>
        public Table<TB_aspnet_Roles> AS_Roles
        {
            get { return this.GetTable<TB_aspnet_Roles>(); }
        }

        /// <summary>
        /// 角色用户（来自 aspnet 框架）
        /// </summary>
        public Table<TB_aspnet_UsersInRoles> AS_UserInRoles
        {
            get { return this.GetTable<TB_aspnet_UsersInRoles>(); }
        }

        public CommonContext(IDbConnection connection) : base(connection) { }
    }
}

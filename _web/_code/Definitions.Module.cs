using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace eTaxi.Definitions.Ascx // 控件
{
    public class Business
    {
        public const string Accident = "business/accident.ascx";
        public const string Accident_Batch = "business/accident_batch.ascx";
        public const string Complain = "business/complain.ascx";
        public const string Complain_Batch = "business/complain_batch.ascx";
        public const string Insurance = "business/insurance.ascx";
        public const string Insurance_Batch = "business/insurance_batch.ascx";
        public const string Log = "business/log.ascx";
        public const string Rental = "business/rental.ascx";
        public const string Shift = "business/shift.ascx";
        public const string Violation = "business/violation.ascx";
        public const string Violation_Batch = "business/violation_batch.ascx";
        public const string Replace = "business/replace.ascx";
        public const string Replace_Batch = "business/replace_batch.ascx";
        public const string Payment = "business/payment.ascx";
        public const string Payment_Batch = "business/payment_batch.ascx";
        public const string Inspection_Batch = "business/inspection_batch.ascx";
        public const string Service = "business/service.ascx";
        public const string Service_Batch = "business/service_batch.ascx";
    }

    public class Car
    {
        public const string Create = "car/create.ascx";
        public const string View = "car/view.ascx";
        public const string View_Accident = "car/view_accident.ascx";
        public const string View_Balance = "car/view_balance.ascx";
        public const string View_Complain = "car/view_complain.ascx";
        public const string View_Inspection = "car/view_inspection.ascx";
        public const string View_Insurance = "car/view_insurance.ascx";
        public const string View_Log = "car/view.ascx_log";
        public const string View_Payment = "car/view_payment.ascx";
        public const string View_Rental = "car/view_rental.ascx";
        public const string View_Shift = "car/view_shift.ascx";
        public const string View_Replace = "car/view_replace.ascx";
        public const string View_Violation = "car/view_violation.ascx";
        public const string Update_Batch_1 = "car/update_batch_1.ascx";
        public const string Rental_List = "car/rental_list.ascx";
        public const string Rental_Batch = "car/rental_batch.ascx";
        public const string Rental_Create = "car/rental_create.ascx";
        public const string Accident_Edit = "car/accident_edit.ascx";
        public const string Complain_Edit = "car/complain_edit.ascx";
        public const string Insurance_Update = "car/insurance_update.ascx";
        public const string Log_Edit = "car/log_edit.ascx";
        public const string Shift_Edit = "car/shift_edit.ascx";
        public const string Violation_Edit = "car/violation_edit.ascx";
        public const string Replace_Update = "car/replace_update.ascx";
        public const string Payment_Update = "car/payment_update.ascx";
        public const string Service_Edit = "car/service_edit.ascx";
        public const string Contract_Edit = "car/contract_edit.ascx";
        public const string Contract_Upload = "car/contract_upload.ascx";
    }

    public class Department
    {
        public const string Edit = "department/edit.ascx";
    }

    public class Driver
    {
        public const string Create = "driver/create.ascx";
        public const string View = "driver/view.ascx";
        public const string View_Guarantor = "driver/view_guarantor.ascx";
        public const string View_Accident = "driver/view_payment.ascx";
        public const string View_Complain = "driver/view_payment.ascx";
        public const string View_Log = "driver/view_payment.ascx";
        public const string View_Payment = "driver/view_payment.ascx";
        public const string View_Violation = "driver/view_violation.ascx";
        public const string View_Contract = "driver/view_contract.ascx";
        public const string Edit_Photo = "driver/edit_photo.ascx";
        public const string Update_Batch_1 = "driver/update_batch_1.ascx";
        public const string Update_Batch_2 = "driver/update_batch_2.ascx";
    }

    public class Person
    {
        public const string Edit = "person/edit.ascx";
    }

    public class Position
    {
        public const string Edit = "position/edit.ascx";
    }

    public class Package
    {
        public const string Edit = "package/edit.ascx";
    }

    public class Rank
    {
        public const string Edit = "rank/edit.ascx";
    }

    public class Role
    {
    }

    public class User
    {
        public const string Edit = "user/edit.ascx";
    }

    public class ACL
    {
        public const string Edit = "acl/edit.ascx";
    }

    public class Sys
    {
        public const string Upload_Photo = "upload_photo.ascx";
    }

    public class Desktop
    {
        public const string RentalPaymentDue = "rentalpaymentdue.ascx";
    }
}

namespace eTaxi.Definitions.Module
{
    public struct Folder
    {
        [DefinitionItemOrdinal(0)]
        [DefinitionItemSettings("基础数据")]
        public const string System = "system";
        [DefinitionItemOrdinal(1)]
        [DefinitionItemSettings("车辆管理")]
        public const string Car = "domain.car";
        [DefinitionItemOrdinal(2)]
        [DefinitionItemSettings("司机管理")]
        public const string Driver = "domain.driver";
        [DefinitionItemOrdinal(3)]
        [DefinitionItemSettings("日常事务")]
        public const string Business = "domain.business";
        [DefinitionItemOrdinal(4)]
        [DefinitionItemSettings("结算管理")]
        public const string Finance = "domain.finance";
        [DefinitionItemOrdinal(5)]
        [DefinitionItemSettings("查询及报表管理")]
        public const string Query = "domain.query";
        [DefinitionItemOrdinal(6)]
        [DefinitionItemSettings("流程管理")]
        public const string Workflow = "domain.workflow";
        [DefinitionItemSettings("司机信息")]
        public const string Driver_Info = "_controls.driver";
        [DefinitionItemSettings("门户信息")]
        public const string Desktop = "_controls.desktop";
    }

    public struct SubFolder
    {
        [DefinitionItemOrdinal(0)]
        [DefinitionItemSettings("车辆")]
        public const string Car = "car";
        [DefinitionItemOrdinal(1)]
        [DefinitionItemSettings("司机")]
        public const string Driver = "driver";
    };

}



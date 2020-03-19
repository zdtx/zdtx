delete aspnet_Applications
delete aspnet_Roles
delete aspnet_Membership
delete aspnet_Paths
delete aspnet_PersonalizationAllUsers
delete aspnet_PersonalizationPerUser
delete aspnet_Profile
delete aspnet_Users
delete aspnet_UsersInRoles
delete aspnet_WebEvent_Events

delete car
delete car_balance
delete car_complain
delete car_contract
delete car_inspection
delete car_insurance
delete car_log
delete car_payment
delete car_payment_item
delete car_rental
delete car_rental_history
delete car_rental_shift
delete car_replace
delete car_service
delete car_violation
delete charge
delete charge_package
delete department
delete driver
delete driver_certificate
delete driver_log
delete package
delete person
delete position
delete [rank]
delete sys_acl
delete sys_batch
delete sys_batch_item

update sys_sequence set [count] = 0 

insert into position
(Id, Branch, RankId, [Name], [Description], CreatedById, CreateTime, ModifiedById, ModifyTime)
values
('PS0000', NULL, 'RK0000', '（未分配岗位）', NULL, '', '2016-04-07 22:06:48.833', '', '2016-04-07 22:06:48.833')

insert into [rank]
(Id, [Name], [Value], [Description], CreatedById, CreateTime, ModifiedById, ModifyTime)
values
('RK0000', '（未分配级别）', 0, NULL, '', '2020-03-19 19:35:51.520', '', '2020-03-19 19:35:51.520')

--INSERT INTO [dbo].[aspnet_SchemaVersions]
--           ([Feature]
--           ,[CompatibleSchemaVersion]
--           ,[IsCurrentVersion])
--     VALUES
--          ('common','1',1)

--INSERT INTO [dbo].[aspnet_SchemaVersions]
--           ([Feature]
--           ,[CompatibleSchemaVersion]
--           ,[IsCurrentVersion])
--     VALUES
--          ('health monitoring','1', 1);

--INSERT INTO [dbo].[aspnet_SchemaVersions]
--           ([Feature]
--           ,[CompatibleSchemaVersion]
--           ,[IsCurrentVersion])
--     VALUES
--          ('membership', '1', 1)

 
--INSERT INTO [dbo].[aspnet_SchemaVersions]
--           ([Feature]
--           ,[CompatibleSchemaVersion]
--           ,[IsCurrentVersion])
--     VALUES
--          ('personalization','1', 1)

 
--INSERT INTO [dbo].[aspnet_SchemaVersions]
--           ([Feature]
--           ,[CompatibleSchemaVersion]
--           ,[IsCurrentVersion])
--     VALUES
--          ('profile','1', 1)


--INSERT INTO [dbo].[aspnet_SchemaVersions]
--           ([Feature]
--           ,[CompatibleSchemaVersion]
--           ,[IsCurrentVersion])
--     VALUES
--          ('role manager','1', 1)


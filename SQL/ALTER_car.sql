-- 经营模式（套餐）设置
alter table car
add PackageId nvarchar(6) null

-- 当前维修记录
alter table car
add 
	ServiceId nvarchar(10) null,			-- 当前已做维修记录
	ServiceContent nvarchar(128) null,		-- 当前已做维修内容
	ServiceTime smalldatetime null,			-- 当前已做维修时间
	ServiceNextContent nvarchar(128) null,	-- 下次维修内容
	ServiceNextTime smalldatetime null		-- 下次维修时间

-- 绑定合同
alter table car
add
	ContractId nvarchar(10) null,			-- 当前捆绑的合同Id
	ConstructDueTime smalldatetime null		-- 当前合同到期时间



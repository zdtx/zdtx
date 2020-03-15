-- Module

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('6C057E3D-6F0A-46D9-94F3-9643176EC453', 'system', NULL, '经营模式', 'system/package.aspx', 1, 1, 6, '2020-03-04 21:55:33.220', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('C7C28E06-A457-40D6-95CC-AD80B2A7B43B', 'domain.finance', NULL, '驾驶员账户查询', 'domain/finance/account.aspx', 1, 1, 1, '2020-03-05 21:50:16.367', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('CF84A673-D7FA-4A18-934B-B2D4FC53890C', 'domain.business', NULL, '租车合同', 'domain/business/contract.aspx', 1, 1, 11, '2020-03-05 21:50:16.367', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('2F2A6323-A19E-4D81-B772-E0D2CA66E5CC', 'domain.driver', NULL, '好人好事', 'domain/driver/event.aspx', 1, 1, 4, '2020-03-05 21:50:16.367', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('D93FC084-298A-497D-8794-E2BD12887F85', 'domain.finance', NULL, '款项结算管理', 'domain/finance/ledger.aspx', 1, 1, 2, '2020-03-05 21:50:16.367', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('EC4D216C-B0D5-4EAB-92A9-8E858F87AE24', 'domain.driver', NULL, '合同管理', 'domain/driver/contract.aspx', 1, 1, 2, '2020-03-05 21:50:16.367', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('18B41D53-54D9-4168-A137-9555C5190A57', 'domain.car', NULL, '车辆保养', 'domain/car/service.aspx', 1, 1, 4, '2020-03-05 21:50:16.367', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('08A1EC36-2AAC-473D-90E8-71E0A0FE3F12', 'domain.driver', NULL, '投诉接待', 'domain/driver/complain.aspx', 1, 1, 0, '2020-03-05 21:50:16.367', '2020-03-09 21:39:24.097')

insert into sys_module
(id, folder, subfolder,[name], [path], ispage, [enabled], ordinal, createtime, modifytime)
values
('55F0592C-AB60-4348-ACCA-7A02BC2C2A88', 'domain.finance', NULL, '结算设置', 'domain/finance/charge.aspx', 1, 1, 0, '2020-03-09 21:39:24.097', '2020-03-09 21:39:24.097')

-- Sequence

insert into sys_sequence
(entity, prefix, separator, count, limit, shortform, step, remark, modifiedbyid, modifytime)
values
('package', 'PK', NULL, 0, 99999999, 1, 1, NULL, null, '2020-03-04 22:35:43.983')

insert into sys_sequence
(entity, prefix, separator, count, limit, shortform, step, remark, modifiedbyid, modifytime)
values
('car_service', 'CS', NULL, 0, 99999999, 1, 1, NULL, NULL, '2020-03-08 12:09:17.060')

insert into sys_sequence
(entity, prefix, separator, count, limit, shortform, step, remark, modifiedbyid, modifytime)
values
('car_contract', 'CT', NULL, 0, 99999999, 0, 1, NULL, NULL, '2020-03-09 10:41:35.247')

insert into sys_sequence
(entity, prefix, separator, count, limit, shortform, step, remark, modifiedbyid, modifytime)
values
('charge', 'CG', NULL, 0, 99999999, 1, 1, NULL, NULL, '2020-03-15 11:18:17.263')



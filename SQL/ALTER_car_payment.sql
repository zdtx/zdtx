-- 绑定合同
alter table car_payment
add
	OpeningBalance money null,		-- 结转上期
	ClosingBalance money null

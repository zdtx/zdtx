-- ��Ӫģʽ���ײͣ�����
alter table car
add PackageId nvarchar(6) null

-- ��ǰά�޼�¼
alter table car
add 
	ServiceId nvarchar(10) null,			-- ��ǰ����ά�޼�¼
	ServiceContent nvarchar(128) null,		-- ��ǰ����ά������
	ServiceTime smalldatetime null,			-- ��ǰ����ά��ʱ��
	ServiceNextContent nvarchar(128) null,	-- �´�ά������
	ServiceNextTime smalldatetime null		-- �´�ά��ʱ��

-- �󶨺�ͬ
alter table car
add
	ContractId nvarchar(10) null,			-- ��ǰ����ĺ�ͬId
	ConstructDueTime smalldatetime null		-- ��ǰ��ͬ����ʱ��



CREATE TABLE sampleTBL(
     memo varchar2(50)
     );
INSERT INTO sampleTBL values('���� Ǫ��');
INSERT INTO sampleTBL values('����� ��������');

-- Read OK --> scott�� ���� �Ҵ�
SELECT * FROM scott.emp;

GRANT SELECT ON scott.emp TO usertest02;


-- Read OK --> scott�� ���� �Ҵ�
SELECT * FROM scott.dept;

GRANT SELECT ON scott.dept TO usertest02;

SELECT * FROM systemTBL; -- ���뵿�Ǿ ���Ѿ����� �Ұ���



-- system�� ���� ���Ǿ�(public sysnonym) ����

SELECT * FROM systemTBL;


-- ���뵿�Ǿ� SELECT test
SELECT * FROM system.sampleTBL; -- ���� ȹ�������Ƿ� SELECT����
SELECT * FROM priv_sampleTBL;   -- ���� ���Ǿ��̹Ƿ� SELECT�Ұ�, user04�� ����


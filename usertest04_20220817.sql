-- Read X --> ���Ѿ���
SELECT * FROM scott.emp; --ORA-00942: table or view does not exist
-- Read OK --> scott�� ���� �Ҵ�
SELECT * FROM scott.student;
-- Read X --> scott�� Read ���Ѹ� �Ҵ�
UPDATE scott.student
SET    userid = 'kkk'
WHERE  studno = 10101;

-- 3. scott�� �ִ� student TBL�� Read ���� usertest03 �ּ��� --> X(���Ѿ���)
GRANT SELECT ON scott.student TO usertest03;

-- Read OK --> scott�� ���� �Ҵ�
SELECT * FROM scott.emp;

-- 4. scott�� �ִ� emp TBL�� Read ���� usertest03 �ּ��� -->

-- Read OK --> scott�� ���� �Ҵ�
SELECT * FROM scott.dept;

GRANT SELECT ON scott.dept TO usertest03 WITH GRANT OPTION;


-------------------------------------------------------------------------------------------------
-- system���κ��� Read ���� �ο� �ް� ��ȸ����
SELECT * FROM system.systemTBL;

-- ���� �ο� �޾����� ���ŷο� --> ���� ���Ǿ�(public sysnonym) �̿�
-- CREATE PUBLIC SYNONYM pub_system FOR systemTBL; <-- system�� ������
SELECT * FROM pub_system;
SELECT * FROM systemTBL;
GRANT SELECT ON systemTBL TO usertest03;

-------------------------------------------------------------------------------------------------
-- sampleTBL �̿��� ���� ���Ǿ� ���� --user04�� ��밡��
SELECT * FROM system.sampleTBL; -- system���κ��� ���� ����
CREATE synonym priv_sampleTBL FOR system.sampleTBL; --���� ���Ǿ� ����
-- synonym�� ���� ������ ���ٴ� ����. 
-- system �������� CONNECT, RESOURCE ROLE �޾����� �����߻�
-- ���翡�� CONNECT�� �ο��� ���� �� CREATE SYNONYM�� ���ԵǾ��־�����
-- ������ developer���� CONNECT�� �ο��� ������ ��ȸ�غ��� CREATE SESSION�� �־���.
-- �������� �ѿ� �ο��� ���ѵ��� �ٸ���. 9���������� �� ���� ������ �ο��Ǿ� �ִ�.
-- 10�������� CONNECT�� �ο��� ������ CREATE SESSION �ϳ��� �ο��ȴ�.
-- ���� ���� system���� CREATE SYNONYM ������ �ο����ְų� DBA ROLE �� �־�� �Ѵ�.
-- GRANT CREATE SYNONYM TO usertest04; �Ǵ� GRANT DBA TO usertest04;
-- �ǹ����� ������ �ܼ�ȭ? ���������� ���� DBA������ �ִ� ����� ���־��ٰ� �Ѵ�.

SELECT * FROM priv_sampleTBL; -- ���� ���Ǿ� �̿� SELECT

GRANT SELECT ON system.sampleTBL TO usertest03;

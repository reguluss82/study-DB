CREATE TABLE sampleTBL(
     memo varchar2(50)
     );
INSERT INTO sampleTBL values('���� Ǫ��');
INSERT INTO sampleTBL values('����� ��������');

-- Read OK --> scott�� ���� �Ҵ�
SELECT * FROM scott.emp;

-- Read OK --> scott�� ���� �Ҵ�
SELECT * FROM scott.dept;

GRANT SELECT ON scott.dept TO usertest01;
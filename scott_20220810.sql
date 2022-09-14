---------------------------------------------------------
----- SUB Query  ***
-- �ϳ��� SQL ��ɹ��� ����� �ٸ� SQL ��ɹ��� �����ϱ� ���� 
-- �� �� �̻��� SQL ��ɹ��� �ϳ��� SQL��ɹ����� �����Ͽ� ó���ϴ� ���
--ó������
--1. ���������� ���������� ����Ǳ� ���� �ѹ��� �����
--2. ������������ ����� ����� ���� ������ ���޵Ǿ� �������� ����� ���

-- ����
-- 1) ������ ��������
-- 2) ������ ��������
---------------------------------------------------------
--  1. ��ǥ : ���� ���̺��� ���������� ������ ������ ������ ��� ������ �̸� �˻�
--       1-1 ���� ���̺��� ���������� ������ ���� �˻� SQL ��ɹ� ����
--           9907	������	totoro	���Ӱ���	210	01/01/01		101
        SELECT position
        FROM   professor
        WHERE  name = '������';
--       1-2 ���� ���̺��� ���� Į������ 1 ���� ���� ��� ���� ������ ������ ���� ���� �˻� ��ɹ� ����
        SELECT name, position
        FROM   professor
        WHERE  position = '���Ӱ���';
        
        
-- 1. ��ǥ : ���� ���̺��� ���������� ������ ������ ������ ��� ������ �̸� �˻�--> SUB Query
SELECT name, position
FROM   professor
WHERE  position = (SELECT position
                   FROM   professor
                   WHERE  name = '������');

-- ����
-- 1) ������ ��������
-- ������������ �� �ϳ��� �ุ�� �˻��Ͽ� ���������� ��ȯ�ϴ� ���ǹ�
-- ���������� WHERE ������ ���������� ����� ���� ��쿡�� 
-- �ݵ�� ������ �� ������ �� �ϳ��� ����ؾ���
-- ���������� ����� �ϳ��� �ุ�� ��µǾ�� ��

-- ��1) ����� ���̵� ��jun123���� �л��� ���� �г��� �л��� �й�, �̸�, �г��� ����Ͽ���
SELECT studno, name, grade
FROM   student
WHERE  grade = (SELECT grade
                FROM   student
                WHERE  userid = 'jun123'); --PK �ΰ��� �˱⶧���� ������ ��ȯ�� ���� �ȴ�.
                                           --PK�� �ƴϸ� ������ ���ɼ��� ����
-- ��2) 101�� �а� �л����� ��� �����Ժ��� �����԰� ����
-- �л��� �̸�, �г�, �а���ȣ, �����Ը� ���
-- ���� : �а��� ���
SELECT name, grade, deptno, weight
FROM   student
WHERE  weight < (SELECT AVG(weight) --�����Լ��� �����Ƿ� ���������� �ȴ�.
                 FROM   student
                 WHERE  deptno = 101)
ORDER BY deptno;

-- ��3)  20101�� �л��� �г��� ����, Ű�� 20101�� �л����� ū �л��� 
-- �̸�, �г�, Ű�� ����Ͽ���
-- ���� : �а��� ���
SELECT name, grade, height
FROM   student
WHERE  grade  = (SELECT grade
                 FROM   student
                 WHERE  studno = 20101)
AND    height > (SELECT height
                 FROM   student
                 WHERE  studno = 20101)
ORDER BY deptno;

 --  ��3-1) 20101�� �л��� �г��� ����, Ű�� 20101�� �л����� ū �л��� 
--  �̸�, �г�, Ű, �а��� ����Ͽ���
--  ���� : �а��� ���
SELECT s.name, s.grade, s.height, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.grade  = (SELECT grade
                   FROM   student
                   WHERE  studno = 20101)
AND    s.height > (SELECT height
                   FROM   student
                   WHERE  studno = 20101)
ORDER BY d.dname;

-- ��4) 101�� �а� �л����� ��� �����Ժ��� �����԰� ���� �л��� 
-- �̸�, �а���ȣ, �����Ը� ����Ͽ���
-- ���� : �а��� ���
SELECT name, deptno, weight
FROM   student
WHERE  weight < (SELECT AVG(weight)
                 FROM   student
                 WHERE  deptno = 101)
ORDER BY deptno;

-- 2)������ ��������
-- ������������ ��ȯ�Ǵ� ��� ���� �ϳ� �̻��� �� ����ϴ� ��������
-- ���������� WHERE ������ ���������� ����� ���� ��쿡�� ���� �� �� ������ �� ����Ͽ� ��
-- ���� �� �� �����ڴ� ���� �� �� �����ڿ� �����Ͽ� ��� ����
-- ���� �� �� ������ : IN, ANY, SOME, ALL, EXISTS
-- 1) IN        : ���� ������ �� ������ ���������� ����߿��� �ϳ��� ��ġ�ϸ� ��, ��=���񱳸� ����
-- 2) ANY, SOME : ���� ������ �� ������ ���������� ����߿��� �ϳ��� ��ġ�ϸ� ��, ��=��, '<, >' ����
-- 3) ALL       : ���� ������ �� ������ ���������� ����߿��� ��簪�� ��ġ�ϸ� ��
-- 4) EXISTS    : ���� ������ �� ������ ���������� ����߿��� �����ϴ� ���� �ϳ��� �����ϸ� ��, 
             -- EXISTS *** ���������� ������ ���������� ������� �� ������ �ް� ���������� ����

-- 1. IN �����ڸ� �̿��� ���� �� ��������
-- error ORA-01427: single-row subquery returns more than one row
SELECT name, grade, deptno
FROM   student
WHERE  deptno = (SELECT deptno
                 FROM   department
                 WHERE  college = 100); --SUB QUERY�� ������ ��ȯ --> ����
                 
SELECT name, grade, deptno
FROM   student
WHERE  deptno IN (SELECT deptno -- 101, 102
                  FROM   department
                  WHERE  college = 100);
-- ��=�� �����ڸ� OR�� ������ �Ͱ� ���� �ǹ�

SELECT name, grade, deptno
FROM   student
WHERE  deptno IN (101, 102);


-- 2. ANY �����ڸ� �̿��� ���� �� ��������
-- ��) ��� �л� �߿��� 4�г� �л� �߿��� Ű�� ���� ���� �л����� Ű�� ū �л��� �й�, �̸�, Ű�� ����Ͽ���
SELECT studno, name, height
FROM   student
WHERE  height > ANY (SELECT height  --175,176,177 �� ���߿� ��ͺ��ٵ� Ŀ���� -> �ּҰ��� 175 ����
                     FROM   student
                     WHERE  grade = '4');


SELECT studno, name, height
FROM   student
WHERE  height > ANY 
                (SELECT MIN(height)
                 FROM   student
                 WHERE  grade = '4');
                   

-- 3. ALL �����ڸ� �̿��� ���� �� ��������
-- ANY �����ڿ� ������
-- ��>ANY�� : ���������� ��� �߿��� �ּ� ������ ũ�� ���������� �� ������ ��
-- ��>ALL�� : ���������� ��� �߿��� �ִ� ������ ũ�� ���������� �� ������ ��

SELECT studno, name, height
FROM   student
WHERE  height > ALL 
                (SELECT height  --175,176,177 ��������� ���̾�� �ϹǷ� -> �ִ밪�� 177 ����
                 FROM   student
                 WHERE  grade = '4');
                    

-- 4. EXISTS �����ڸ� �̿��� ���� �� �������� --���� ���� ���
SELECT profno, name, sal, comm, position
FROM   professor
WHERE  EXISTS 
        (SELECT position
         FROM   professor
         WHERE  comm IS NOT NULL);
               --comm�޴� ������ �Ѹ� �̻� ���� ->�� ->main query����
               -- -> sub�� ������ �ƴ� �������̺� ��� �� ���

SELECT profno, name, sal, comm, position
FROM   professor
WHERE  EXISTS 
        (SELECT sal
         FROM   professor
         WHERE  position = '����');
               

SELECT profno, name, sal, comm, position
FROM   professor
WHERE  EXISTS 
        (SELECT *
         FROM   emp
         WHERE  empno = 1000); 
               

-- ��1) ���������� �޴� ������ �� ���̶� ������ 
--    ��� ������ ���� ��ȣ, �̸�, �������� �׸��� �޿��� ���������� ���� ���
SELECT profno, name, sal, comm, sal+NVL(comm, 0)
FROM   professor
WHERE  EXISTS 
        (SELECT name
         FROM   professor
         WHERE  comm IS NOT NULL);


-- ��2) �л� �߿��� ��goodstudent���̶�� ����� ���̵� ������ 1�� ����Ͽ���
SELECT 1 userid_exist
FROM   dual
WHERE  NOT EXISTS 
            (SELECT userid
             FROM   student
             WHERE  userid = 'goodstudent');
             

-- ���� �÷� ��������
-- ������������ ���� ���� Į�� ���� �˻��Ͽ� ���������� �������� ���ϴ� ��������
-- ���������� ������������ ���������� Į�� ����ŭ �����ؾ� ��
-- ����
-- 1) PAIRWISE   : Į���� ������ ��� ���ÿ� ���ϴ� ���
--                 ���������� ������������ ���ϴ� Į���� ���� �ݵ�� �����ؾ� ��
-- 2) UNPAIRWISE : Į������ ����� ���� ��, AND ������ �ϴ� ���

-- 1) PAIRWISE ���� Į�� ��������

-- ��1) PAIRWISE �� ����� ���� �г⺰�� �����԰� �ּ��� 
--      �л��� �̸�, �г�, �����Ը� ����Ͽ���
SELECT name, grade, weight
FROM   student
WHERE (grade, weight) IN (SELECT   grade, MIN(weight)
                          FROM     student
                          GROUP BY grade);
                          
-- 2) UNPAIRWISE : Į������ ����� ���� ��, AND ������ �ϴ� ���
--                 �� Į���� ���ÿ� �������� �ʴ��� ���������� �����ϴ� ��쿡�� �� ������ ���� �Ǿ� ����� ��� ����

-- UNPAIRWISE �� ����� ���� �г⺰�� �����԰� �ּ��� �л��� �̸�, �г�, �����Ը� ���
SELECT name, grade, weight
FROM   student
WHERE grade  IN (SELECT   grade -- 1, 2, 3, 4
                 FROM     student
                 GROUP BY grade)
AND   weight IN (SELECT   MIN(weight) -- 52, 42, 70, 72
                 FROM     student
                 GROUP BY grade);
-- �����ڰ� �����Ѵ�� �� �ȵɼ� �ִ�.


-- ��ȣ���� �������� *** �𸣸� ���߽ð��� �þ��!
-- ������������ ������������ �˻� ����� ��ȯ�ϴ� �������� �޼��� ������ �����
-- ���������� ������������ ����� ��ȯ�ϱ� ���Ͽ� ���������� WHERE ���������� ���������� ���̺�� ����
-- ���� : ���� ���� ������ ����� �������� ��ȯ�ϴ� ����� ó�� ������ ���ϵ� �� ����

-- ��1) �� �а� �л��� ��� Ű���� Ű�� ū �л��� �̸�, �а� ��ȣ, Ű�� ����Ͽ���
--         ������� 1
--         ������� 3
SELECT deptno, name, grade, height
FROM   student s1
WHERE  height > (SELECT AVG(height)
                 FROM   student s2
                 -- WHERE s2.deptno = 101  <--�׽�Ʈ
                 --         ������� 2
                 WHERE  s2.deptno = s1.deptno)
ORDER BY deptno;

--sub query test
SELECT AVG(height)
FROM   student s2
WHERE  s2.deptno = 101;  <--�׽�Ʈ



-------------  HW  -----------------------
--  1. Blake�� ���� �μ��� �ִ� ��� ����� ���ؼ� ��� �̸��� �Ի����� ���÷����϶�
SELECT ename, hiredate
FROM   emp
WHERE  deptno = (SELECT deptno
                 FROM   emp
                 WHERE  UPPER(ename) = 'BLAKE'); --BLAKE �ҹ������� �빮������ ��. ���� INITCAP
                 -- WHERE  INITCAP(ename) = 'Blake'
                 -- WHERE  LOWER(ename) = 'blake'
--  2. ��� �޿� �̻��� �޴� ��� ����� ���ؼ� ��� ��ȣ�� �̸��� ���÷����ϴ� ���ǹ��� ����. 
--     �� ����� �޿� �������� �����϶�
SELECT empno, ename
FROM   emp
WHERE  sal > (SELECT AVG(sal)
              FROM   emp);
ORDER BY sal DESC;

--  3. ���ʽ��� �޴� � ����� �μ� ��ȣ�� 
--      �޿��� ��ġ�ϴ� ����� �̸�, �μ� ��ȣ �׸��� �޿��� ���÷����϶�.
SELECT ename, deptno, sal
FROM   emp
WHERE (deptno, sal) IN (SELECT deptno, sal
                        FROM   emp
                        WHERE  comm IS NOT NULL
                        AND    comm > 0);


--------------------------------------------------------------------------------
-- ������ ���۾� (DML:Data Manpulation Language) **         -------------------
-- 1.���� : ���̺� ���ο� �����͸� �Է��ϰų� ���� �����͸� ���� �Ǵ� �����ϱ� ���� ��ɾ�
-- 2.����
-- 1) INSERT : ���ο� ������ �Է� ��ɾ�
-- 2) UPDATE : ���� ������ ���� ��ɾ�
-- 3) DELETE : ���� ������ ���� ��ɾ�
-- 4) MERGE  : �ΰ��� ���̺��� �ϳ��� ���̺�� �����ϴ� ��ɾ�
-- 5) SELECT
-- Ʈ�����
--  ���� ���� ��ɹ��� �ϳ��� ������ �۾������� ó���ϴ� ���
-- Ʈ����� ���� ��ɾ�
--  COMMIT : Ʈ������� �������� ���Ḧ ���� ��ɾ�
--  ROLLBACK : Ʈ������� ���������� �ߴ��� ���� ��ɾ�
-- Ư¡ ACID

-- 1) Insert
--���� �� �Է� : �ѹ��� �ϳ��� ���� ���̺� �Է��ϴ� ���
-- INTO ���� ����� Į���� VALUES ������ ������ Į�� ���� �Է�
-- INTO ���� Į���� ������� ������ ���̺� ������ ������ Į�� ������ ������ ������ �Է�
-- �ԷµǴ� ������ Ÿ���� Į���� ������ Ÿ�԰� �����ؾ� ��
-- �ԷµǴ� �������� ũ��� Į���� ũ�⺸�� �۰ų� �����ؾ� ��
-- CHAR, VARCHAR2, DATE Ÿ���� �Է� �����ʹ� �����ο��ȣ(����)�� ��� �Է�

-- NULL �Է�
-- �����͸� �Է��ϴ� �������� �ش� �÷� ���� �𸣰ų�, ��Ȯ��
-- �������� ���
-- INSERT INTO ���� �ش� Į�� �̸��� ���� ����
-- �ش� Į���� NOT NULL ���������� ������ ��� �Ұ���
-- ����� ���
-- VALUES ���� Į�� ���� NULL , ���� ���


INSERT INTO dept VALUES (71, '�λ�'); --INSERT �ȵ� ��Ȯ�ϰ� -Į������ �Է������ �Ѵ�.
INSERT INTO dept VALUES (71, '�λ�', '�̴�'); -- Į�� ������� INSERT �ȴ�.
INSERT INTO dept (deptno, dname, loc) VALUES (72, 'ȸ����', '������');
INSERT INTO dept (deptno, dname, loc) VALUES (75, '������', '�Ŵ��'); --PK ���ϼ� ����
INSERT INTO dept (deptno, loc, dname) VALUES (75, '������', 'ȸ����'); --Į������ �����ָ� ������ �ٲ� ��������
INSERT INTO dept (deptno, loc) VALUES (73, 'ȫ��'); -- dname�� null �� INSERT
INSERT INTO dept (deptno, loc) VALUES (77, '���'); -- dname�� not null �������ǰɸ� INSERT�ȵ� -INSERT�� �ȵǸ� �������� Ȯ���ض�.

INSERT INTO professor (profno, name, position, hiredate, deptno)
            VALUES (9910, '�ڹ̼�', '���Ӱ���', TO_DATE('2006/01/01', 'YYYY/MM/DD'), 101);
INSERT INTO professor (profno, name, position, hiredate, deptno)
            VALUES (9920, '������', '������', sysdate, 102);

DROP TABLE JOB3;
CREATE TABLE JOB3
( jobno NUMBER(2) PRIMARY KEY, --PK �̸� ���������ָ� �ý��ۿ��� �˾Ƽ� ���ִµ� �ܿ�� ��ƴ�.
  jobname VARCHAR2(20)
  ) ;
INSERT INTO JOB3 VALUES (10, '�б�');
INSERT INTO JOB3 VALUES (11, '������');
INSERT INTO JOB3 (jobname, jobno) VALUES ('�����', 12);
INSERT INTO JOB3 (jobno, jobname) VALUES (13, '����');
INSERT INTO JOB3 (jobno, jobname) VALUES (14, '�߼ұ��');

CREATE TABLE Religion
( religion_no   NUMBER(2) CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
  religion_name VARCHAR2(20)
) ;

INSERT INTO religion VALUES(10, '�⵶��');
INSERT INTO religion (religion_no, religion_name) VALUES (20, 'ī�縯��');
INSERT INTO religion (religion_name, religion_no) VALUES ('�ұ�', 30);
INSERT INTO religion (religion_no, religion_name) VALUES (40, '����');




COMMIT;

ROLLBACK;


--------------------------------------------------------------------------------
----- ���� �� �Է�                                                          -----
--------------------------------------------------------------------------------
-- 1. ������ TBL�̿� �ű� TBL ����
CREATE TABLE dept_second
AS SELECT * FROM dept; --PK�� ��������ʴ´�

-- 2. TBL ���� ����
CREATE TABLE emp20
AS SELECT empno, ename, sal*12 annsal
FROM      emp
WHERE     deptno = 20;

-- 3. TBL ������
CREATE TABLE dept30
AS SELECT deptno, dname
FROM      dept
WHERE     0 = 1; --FALSE �� ����� �ȴ�

-- 4. Column �߰�
ALTER TABLE dept30
ADD(birth Date);

INSERT INTO dept30 VALUES(10, '�߾��б�', sysdate);

-- 5. Column ����
-- ORA-01441: cannot decrease column length because some value is too big --> ���� Data���� ũ�Ⱑ ������ �� ��
ALTER TABLE dept30
MODIFY dname VARCHAR2(11);

ALTER TABLE dept30
MODIFY dname VARCHAR2(30);

ALTER TABLE dept30
MODIFY dname VARCHAR2(20);

-- 6. Column ����
ALTER TABLE dept30
DROP COLUMN dname;

-- 7. TBL �� ����
RENAME dept30 TO dept35;

-- 8. TBL ����
DROP TABLE dept35;

-- 9. TRUNCATE
TRUNCATE TABLE dept_second;

--|delete, drop, truncate �� �ϱ� �������� ***
--+----------+------------+------------+---------+----------+------------+
--|          | ���̺����� |  �������   |  ������  | �۾��ӵ� | SQL�� ���� |
--+----------+------------+------------+---------+----------+------------+
--|  DELETE  |    ����    |    ����    |   ����   |   ����   |    DML     |
--| TRUNCATE |    ����    |    �ݳ�    |   ����   |   ����   |    DDL     |
--|   DROP   |    ����    |    �ݳ�    |   ����   |   ����   |    DDL     |
--+----------+------------+------------+---------+----------+------------+  
--�����ͺ��̽��� �����͸� �����ϴ� �� ���˴ϴ�. DML ����� �ڵ����� Ŀ�Ե��� �ʽ��ϴ�.
--��, DML ��ɿ� ���� ������ �����ͺ��̽��� ���������� �����Ƿ� �ѹ��� �� �ֽ��ϴ�.
--DML(INSERT, UPDATE, DELETE, SELECT) ��ɾ��� ���,
--�����Ϸ��� ���̺��� �޸� ���ۿ� �÷����� �۾��� �ϱ� ������
--�ǽð����� ���̺� ������ ��ġ�� ���� �ƴϴ�.
--���� ���ۿ��� ó���� DML ��ɾ ���� ���̺� �ݿ��Ǳ� ���ؼ���
--COMMIT ��ɾ �Է��Ͽ� TRANSACTION�� �����ؾ� �Ѵ�.


CREATE TABLE height_info
(sutdNo NUMBER(5),
 name   VARCHAR2(20),
 height NUMBER(5,2)
);
CREATE TABLE weight_info
(studNo NUMBER(5),
 name   VARCHAR2(20),
 weight NUMBER(5,2)
);

-- INSERT ALL(unconditional INSERT ALL) ��ɹ�
-- ���������� ��� ������ ���Ǿ��� ���� ���̺� ���ÿ� �Է�
-- ���������� �÷� �̸��� �����Ͱ� �ԷµǴ� ���̺��� Į���� �ݵ�� �����ؾ� ��
-- data conversion�� ����
INSERT ALL
INTO height_info VALUES(studno, name, height)
INTO weight_info VALUES(studno, name, weight)
SELECT studno, name, height, weight --subquery ����
FROM   student
WHERE  grade >= '2';


DELETE height_info;
DELETE weight_info;

-- �л� ���̺��� 2�г� �̻��� �л��� �˻��Ͽ� 
-- height_info ���̺��� Ű�� 170���� ū �л��� �й�, �̸�, Ű�� �Է�
-- weight_info ���̺��� �����԰� 70���� ū �л��� �й�, �̸�, �����Ը� 
-- ���� �Է��Ͽ���

-- INSERT ALL 
-- [WHEN ������1 THEN
-- INTO [table1] VLAUES[(column1, column2,��)]
-- [WHEN ������2 THEN
-- INTO [table2] VLAUES[(column1, column2,��)]
-- [ELSE
-- INTO [table3] VLAUES[(column1, column2,��)]
-- subquery;

INSERT ALL
WHEN height > 170 THEN
    INTO height_info VALUES(studno, name, height)
WHEN weight > 70 THEN
    INTO weight_info VALUES(studno, name, weight)
SELECT studno, name, height, weight
FROM   student
WHERE  grade >= '2';

-- ������ ���� ����
-- UPDATE ��ɹ��� ���̺� ����� ������ ������ ���� ���۾�
-- WHERE ���� �����ϸ� ���̺��� ��� ���� ����

--- Update 
-- ��1) ���� ��ȣ�� 9903�� ������ ���� ������ ���α������� �����Ͽ���
UPDATE professor
SET    position = '�α���'
WHERE  profno = 9903;

-- ���������� �̿��� ������ ���� ����
-- UPDATE ��ɹ��� SET ������ ���������� �̿�
-- �ٸ� ���̺� ����� ������ �˻��Ͽ� �Ѳ����� ���� Į������
-- SET ���� Į�� �̸��� ���������� Į�� �̸��� �޶� ��
-- ������ Ÿ�԰� Į�� ���� �ݵ�� ��ġ

-- ��2) ���������� �̿��Ͽ� �й��� 10201�� �л��� �г�� �а� ��ȣ��
-- 10103 �й� �л��� �г�� �а� ��ȣ�� �����ϰ� �����Ͽ���
UPDATE student
SET   (grade, deptno) = (SELECT grade, deptno
                         FROM   student
                         WHERE  studno = 10103)
WHERE  studno = 10201;

-- ������ ���� ����
-- DELETE ��ɹ��� ���̺� ����� ������ ������ ���� ���۾�
-- WHERE ���� �����ϸ� ���̺��� ��� �� ����

-- ��1) �л� ���̺��� �й��� 20103�� �л��� �����͸� ����
DELETE
FROM  student
WHERE studno = 20103; --������ PK�� ������ �ɾ��ش�. ����ġ���� ���� �߻� ����

-- ���������� �̿��� ������ ���� ����
-- WHERE ������ �������� �̿�
-- �ٸ� ���̺� ����� �����͸� �˻��Ͽ� �Ѳ����� �������� ������ ���� ��
-- WHERE ���� Į�� �̸��� ���������� Į�� �̸��� �޶� ��
-- ������ Ÿ�԰� Į�� ���� ��ġ


-- ��2) �л� ���̺��� ��ǻ�Ͱ��а��� �Ҽӵ� �л��� ��� �����Ͽ���. HomeWork --> Rollback
DELETE
FROM  student
WHERE deptno = (SELECT deptno
                FROM   department
                WHERE  dname = '��ǻ�Ͱ��а�');
ROLLBACK;


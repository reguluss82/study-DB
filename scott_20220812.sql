-- FK ***�������� �ٺ� RDB ���̺� ����.
-- 1. Restrict(�۾�����) : �ڽ� ���� ���� �ȵ�
--  1) ���� emp TABLE���� REFERENCES DEPT (DEPTNO)
--  2) ���� ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
     DELETE dept WHERE deptno = 10;

-- 2. Cascading Delete(���ӻ���) : ���� ����
--  1) ���ӻ��� ���� emp TABLE���� REFERENCES DEPT (DEPTNO) ON DELETE CASCADE
--  2) ���� emp(9999)  --> dept(76)
     DELETE dept WHERE deptno = 76;

-- 3. SET NULL 
--  1) ����NULL ���� emp TABLE���� REFERENCES DEPT (DEPTNO) ON DELETE SET NULL
--  2) ���� emp(5555)  --> dept(75)
     DELETE dept WHERE deptno = 75;


--------------------------------------------------------------------------------
--                            Backup Dir ���� --���� ������Ʈ�� ��� �߿��ϴ�.
--------------------------------------------------------------------------------
-- 1. �ൿ����
--  1) admin���� mdbackup directory�� ���� ȹ����
--   scott ��ü backup
--   C:\oraclexe\mdbackup>
EXPDP scott/tiger Directory=mdbackup DUMPFILE=scott.dmp --cmd���� ����

--  2) Oracle ��ü Restore (scott)
--   C:\oraclexe\mdbackup>
IMPDP scott/tiger Directory=mdbackup DUMPFILE=scott.dmp


-- Oracle �κ� Backup �� �κ� Restore (scott)
-- ���� ��Ŭ�� �Ӽ� ���� SID �˼����� scott�� xe
EXP scott/tiger@xe file=student.dmp tables=student

-- Oracle ��ü Restore (scott)
--   C:\oraclexe\mdbackup>
IMP scott/tiger@xe file=student.dmp full=y



--------------------------------------------------------------------------------
--   11. View 
--------------------------------------------------------------------------------
-- View : �ϳ� �̻��� �⺻ ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� ���� ���̺�
--        ��� �����͵�ųʸ� ���̺� �信 ���� ���Ǹ� ����
--       ���� : ����
--       ���� : Performance(����)�� �� ���� <-- ������ ���°��� �����̴�.

CREATE OR REPLACE VIEW view_professor AS
SELECT profno, name, userid, position, hiredate, deptno
FROM   professor;

CREATE OR REPLACE VIEW View_Professor2 AS
SELECT name, userid, position, hiredate, deptno
FROM   professor; --PK �� ����. <- INSERT �� �Ұ����ϴ�.

SELECT * FROM view_professor;


-- Ư�� 1. ���� table [professor]�� �Է� ����, ������ ���������� �״�� ����!
INSERT INTO view_professor VALUES(2000, 'veiw','userid','position',sysdate,101); --�������ǿ� �ɸ��� �ʴ´ٸ� �並 ���� �Է� ���� 
INSERT INTO view_professor (profno, userid, position, hiredate, deptno)
                            VALUES(2001,'userid2','position2',sysdate,101); --name�� �������� not null�� �ִµ� name�� �Է����� �ʾƼ� ����!
                            -- cannot insert NULL into ("SCOTT"."PROFESSOR"."NAME")


INSERT INTO view_professor2 ( userid, position, hiredate, deptno)
                            VALUES('userid3','position3',sysdate,101); --name�� �������� not null�� �ִµ� name�� �Է����� �ʾƼ� ����!
                            -- cannot insert NULL into ("SCOTT"."PROFESSOR"."NAME")


-- VIEW �̸� v_emp_sample  : emp(empno , ename , job, mgr,deptno)
CREATE  OR REPLACE VIEW v_emp_sample
AS
SELECT empno , ename , job, mgr,deptno
FROM   emp;


-- ���� VIEW / ��� VIEW  --> INSERT �ȵ�
CREATE OR REPLACE VIEW v_emp_complex
AS
SELECT *
FROM emp NATURAL JOIN dept;

INSERT INTO v_emp_complex (empno, ename, deptno)
                     VALUES(1500, 'ȫ�浿', 20);
INSERT INTO v_emp_complex (deptno, dname, loc)
                     VALUES(77, '������', '������');
INSERT INTO v_emp_complex (empno, ename, deptno, dname, loc)
                     VALUES(1500,'ȫ�浿', 77, '������', '������');

------     View  HomeWork     ----------------------------------------------------
---��1)  �л� ���̺��� 101�� �а� �л����� �й�, �̸�, �а� ��ȣ�� ���ǵǴ� �ܼ� �並 ����
---     �� �� :  v_stud_dept101
CREATE OR REPLACE VIEW v_stud_dept101
AS
SELECT studno, name, deptno
FROM   student
WHERE  deptno = 101;

-- ��2) �л� ���̺�� �μ� ���̺��� �����Ͽ� 102�� �а� �л����� �й�, �̸�, �г�, �а� �̸����� ���ǵǴ� ���� �並 ����
--      �� �� :   v_stud_dept102
CREATE OR REPLACE VIEW v_stud_dept102
AS
SELECT studno, name, grade, dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    deptno = 102;

-- ��3)  ���� ���̺��� �а��� ��� �޿���     �Ѱ�� ���ǵǴ� �並 ����
--  �� �� :  v_prof_avg_sal       Column �� :   avg_sal      sum_sal
CREATE OR REPLACE VIEW v_prof_avg_sal
AS
SELECT deptno, AVG(sal) avg_sal, SUM(sal) sum_sal
FROM   professor
GROUP BY deptno
ORDER BY deptno;

-- 2. GROUP �Լ� Column ��� �ȵ� 
INSERT INTO V_PROF_AVG_SAL
VALUES(203,600,300);
-- View ���� 
DROP VIEW v_stud_dept102;

SELECT view_name , text
FROM   USER_VIEWS;

-------------------------------------
---- ������ ���ǹ�
-------------------------------------
-- 1. ������ ������ ���̽� ���� ������� 2���� ���̺� ����
-- 2. ������ ������ ���̽����� �����Ͱ��� �θ� ���踦 ǥ���� �� �ִ� Į���� �����Ͽ� 
--    �������� ���踦 ǥ��
-- 3. �ϳ��� ���̺��� �������� ������ ǥ���ϴ� ���踦 ��ȯ����(recursive relationship)
-- 4. �������� �����͸� ������ Į�����κ��� �����͸� �˻��Ͽ� ���������� ��� ��� ����
--     LEVEL�÷��� ���� �ǻ��÷�(LEVEL Pseudocolumn)�̶�� �ϴµ� ������ ������ ǥ��
-- ����
-- SELECT ��ɹ����� START WITH�� CONNECT BY ���� �̿�
-- ������ ���ǹ������� �������� ��� ���İ� ���� ��ġ ����
-- ��� ������ top-down �Ǵ� bottom-up
-- ����) CONNECT BY PRIOR �� START WITH���� ANSI SQL ǥ���� �ƴ�

-- ��) ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �ܴ�,�к�
-- �а������� top-down ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 10�� �μ�
SELECT     deptno, dname, college
FROM       department
START WITH deptno = 10
CONNECT BY PRIOR deptno = college; -- colmn ������ �������, �ڽĺ���

-- ��2) ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �а�,�к�
-- �ܴ� ������ bottom-up ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 102�� �μ��̴�
SELECT     deptno, dname, college
FROM       department
START WITH deptno = 102
CONNECT BY PRIOR college = deptno; -- tod-down�� �Ųٷ�, �θ����

--- ��3) ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �μ� �̸��� �˻��Ͽ� �ܴ�, �к�, �а�����
---      top-down �������� ����Ͽ���. ��, ���� �����ʹ� ���������С��̰�,
---      �� LEVEL(����)���� �������� 2ĭ �̵��Ͽ� ���
SELECT     LPAD(' ', (LEVEL-1)*2) || dname ������
FROM       department
START WITH dname = '��������'
CONNECT BY PRIOR deptno = college;


------------------------------------------------------
---      TableSpace 
--�����ͺ��̽� ������Ʈ �� ���� �����͸� �����ϴ� �����̴�.
--�̰��� �����ͺ��̽��� �������� �κ��̸�, ���׸�Ʈ�� �����Ǵ� ��� DBMS�� ����
--�����(���׸�Ʈ)�� �Ҵ�
--�������� �Ҵ�
-------------------------------------------------------
-- 1. TableSpace ����
CREATE TABLESPACE user1 DATAFILE 'C:\oraclexe\tableSpace\user1.ora' SIZE 100M;
CREATE TABLESPACE user2 DATAFILE 'C:\oraclexe\tableSpace\user2.ora' SIZE 100M;
CREATE TABLESPACE user3 DATAFILE 'C:\oraclexe\tableSpace\user3.ora' SIZE 100M;
CREATE TABLESPACE user4 DATAFILE 'C:\oraclexe\tableSpace\user4.ora' SIZE 100M;
-- 2.Table�� TableSpace ����
--  1) ���̺��� INDEX�� Table�� ���̺� �����̽� ��ȸ
SELECT index_name, table_name, tablespace_name
FROM   user_indexes;
SELECT table_name, tablespace_name
FROM   user_tables;
--  2) �� ���̺� ���� TABLESPACE ����
--      �ش� INDEX ���� ���� �� TABLE�� TABLESPACE ����
ALTER INDEX SYS_C007014 REBUILD TABLESPACE user1;
ALTER TABLE job3 MOVE TABLESPACE user1;

-- 3. TABLESPACE SIZE ����
ALTER DATABASE DATAFILE 'C:\oraclexe\tableSpace\user1.ora' RESIZE 200M;

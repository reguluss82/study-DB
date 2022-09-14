--------------------------------------------------------------------------------
-- 9. JOIN *** -----------------------------------------------------------------
--------------------------------------------------------------------------------

--������ ����
-- �ϳ��� SQL ��ɹ��� ���� ���� ���̺� ����� �����͸� �ѹ��� ��ȸ�� �� �ִ� ���
-- ������ �����ͺ��̽� �о��� ǥ��
-- �ΰ� �̻��� ���̺��� �����ա� �Ѵٴ� �ǹ�

-- ex 1-1) �й��� 10101�� �л��� �̸��� �Ҽ� �а� �̸��� ����Ͽ��� 
SELECT studno, name, deptno
FROM   student
WHERE  studno = 10101;
-- ex 1-2)�а��� ������ �а��̸�
SELECT dname
FROM   department
WHERE  deptno = 101;
-- ex 1-3) ex 1-1 + 1-2  �ѹ��� ��ȸ  --> Join
SELECT studno, name,
            student.deptno, department. dname
FROM   student, department
WHERE  student . deptno = department . deptno;

-- Į�� �̸��� �ָŸ�ȣ�� �ذ���
-- ���� �ٸ� ���̺� �ִ� ������ Į�� �̸��� ������ ���
-- �÷� �̸��տ� ���̺� �̸��� ���λ�� ���
-- ���̺� �̸��� Į�� �̸��� ��(.)���� ����
-- SQL ��ɹ��� ���� �����м� �ð�(parsing time) ����

-- �ָŸ�ȣ�� (ambiguously)
SELECT studno, name, deptno, dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;

-- �ָŸ�ȣ�� (ambiguously) --> �ذ� : ���� (alias)
SELECT s.studno, s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;

--  ���̺� ����
-- ���̺� �̸��� �ʹ� �� ��� ���
-- ���̺� �̸��� ����ϴ� ���� ��� ����
-- FROM������ ���̺� �̸� ������ ������ �ΰ� ���� ����
--  ���̺� ���� �ۼ� ��Ģ
-- ���̺��� ������ 30�� ���� ����, �ʹ� ���� �ʰ� �ۼ�
-- FROM ������ ���̺� �̸��� ����ϰ� ������ �� ���� ���̺� ��������
-- �ϳ��� SQL ��ɹ����� ���̺� �̸��� ������ ȥ���� �� ����
-- ���̺��� ������ �ش� SQL ��ɹ� �������� ��ȿ


-- ������ �л��� �й�, �̸�, �а� �̸� �׸��� �а� ��ġ�� ���
SELECT s.studno, s.name, d.deptno, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.name   = '������';

-- �����԰� 80kg�̻��� �л��� �й�, �̸�, ü��, �а� �̸�, �а���ġ�� ���
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno  = d.deptno
AND    s.weight >= 80;

-- īƼ�� ��    - �˾Ƶθ� ����.
-- �� �� �̻��� ���̺� ���� ���� ������ ���� ��� ����
-- WHERE ������ ���� �������� �����ϰų� �߸� ������ ���
-- ��뷮 ���̺��� �߻��� ��� SQL��ɹ��� ó���ӵ� ����
-- �����ڰ� �ùķ��̼��� ���� ��뷮�� ����� �����͸� �����ϱ� ���� �ǵ������� ��� ����
-- ����Ŭ 9i ���� �������� FROM���� CROSS JOIN Ű���� ���

SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM   student s, department d; --7��*16�� �� �� ��ȸ�� 

SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM   student s CROSS JOIN department d; --cross join�� ����صа��� ���� �ǵ��� īƼ�ǰ�

-- EQUI JOIN *** 
-- ���� ��� ���̺��� ���� Į���� ��=��(equal) �񱳸� ����
-- ���� ���� ������ ���� �����Ͽ� ����� �����ϴ� ���� ���
-- SQL ��ɹ����� ���� ���� ����ϴ� ���� ���
-- �ڿ������� �̿��� EQUI JOIN
-- ����Ŭ 9i �������� EQUI JOIN�� �ڿ������̶� ���
-- WHERE ���� ������� �ʰ�  NATURAL JOIN Ű���� ���
-- ����Ŭ���� �ڵ������� ���̺��� ��� Į���� ������� ���� Į���� ���� ��, ���������� ���ι� ����

SELECT s.studno, s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;
-- Natual Join Convert Error --������ ������ �̷���
SELECT s.studno, s.name, s.weight, d.dname, d.loc, d.deptno --d.deptno
FROM   student s
       NATURAL JOIN department d;
-- Natual Join Convert Error �ذ�
-- NATURAL JOIN�� ���� ��Ʈ����Ʈ�� ���̺� ������ ����ϸ� ������ �߻�
SELECT s.studno, s.name, s.weight, d.dname, d.loc, deptno   --deptno
FROM   student s
       NATURAL JOIN department d;
       
-- NATURAL JOIN�� �̿��Ͽ� ���� ��ȣ, �̸�, �а� ��ȣ, �а� �̸��� ����Ͽ���
SELECT p.profno, p.name, deptno, d.dname
FROM   professor p
       NATURAL JOIN department d;
       
-- NATURAL JOIN�� �̿��Ͽ� 4�г� �л��� �̸�, �а� ��ȣ, �а��̸��� ����Ͽ���
SELECT s.name, d.dname, deptno, s.grade
FROM   student s
       NATURAL JOIN department d
WHERE  grade = '4';

-- JOIN ~ USING ���� �̿��� EQUI JOIN
-- USING���� ���� ��� Į���� ����
-- Į�� �̸��� ���� ��� ���̺��� ������ �̸����� ���ǵǾ� �־����

-- ��1) JOIN ~ USING ���� �̿��Ͽ� �й�, �̸�, �а���ȣ, �а��̸�, �а���ġ��
--      ����Ͽ���
SELECT s.studno, s.name, deptno, dname, loc
FROM   student s JOIN department
       USING(deptno); --�����̸� ����� �����ϹǷ� alias���� �� �ʿ䰡 ����.

-- EQUI JOIN�� 3���� ����� �̿��Ͽ� ���� ���衯���� �л����� �̸�, �а���ȣ, �а��̸��� ���
--1) WHERE ���� ����� ��� -���� ���� ����ϴ� ���, �������� ����. �ٸ�������� ���迡 ���´�.
SELECT s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.name LIKE '��%';

--2) NATURAL JOIN���� ����� ���
SELECT s.name, deptno, d.dname
FROM   student s NATURAL JOIN department d --���������� ���� �÷����� ã�� JOIN
WHERE  s.name LIKE '��%';

--3) JOIN~USING���� ����� ���
SELECT s.name, deptno, dname
FROM   student s JOIN department
       USING(deptno) --��������� �÷��� �����ִ� ȿ��
WHERE  s.name LIKE '��%';

--4) ANSI JOIN (INNER JOIN ~ ON) --�ڵ�ȭ ó���ϸ� ANSI������ �����⶧���� �˾Ƶ���.
SELECT s.name, d.deptno, d.dname
FROM   student s INNER JOIN department d
ON     s.deptno = d.deptno --WHERE �� �򰥸���.
WHERE  s.name LIKE '��%';

--------------------------------------------------------------------------------
-- NON-EQUI JOIN --** --�ǹ����� ���� ���� ��������
-- ��<��,BETWEEN a AND b �� ���� ��=�� ������ �ƴ� ������ ���

-- ���� ���̺�� �޿� ��� ���̺��� NON-EQUI JOIN�Ͽ� 
-- �������� �޿� ����� ����Ͽ���

CREATE TABLE "SCOTT"."SALGRADE2" 
   (   "GRADE" NUMBER(2,0), 
       "LOSAL" NUMBER(5,0), 
       "HISAL" NUMBER(5,0)
   );

SELECT p.profno , p.name , p.sal , s.grade
FROM   professor p , salgrade2 s
WHERE  p.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN -������ ���������� ���Ἲ���鿡�� �̵�
--EQUI JOIN�� ���� ���ǿ��� ���� Į�� �� ��, ��� �ϳ��� NULL �̸� ��=�� �� ����� ������ �Ǿ�
--NULL ���� ���� ���� ���� ����� ��� �Ұ�
--NULL �� ���ؼ� ��� ������ �����ϴ���� ���� ����� NULL

--�Ϲ����� EQUI JOIN �� �� : 
--�л� ���̺��� �а���ȣ Į���� �μ� ���̺��� �μ���ȣ Į���� ���� EQUI JOIN ( student.deptno = department.deptno ) �� ���
--�л� ���̺��� deptno Į���� NULL �� ��� �ش� �л��� ����� ��µ��� ����

--EQUI JOIN���� ���� Į�� ������ �ϳ��� NULL ������ ���� ����� ����� �ʿ䰡 �ִ� ���
--OUTER JOIN ���

--OUTER JOIN�� �� : 
--�л� ���̺�� ���� ���̺��� EQUI JOIN�Ͽ� �л��� ���� ���� �̸� ���
--���� : ���� �л��� �� �� �������� ���� ���� �̸��� �ݵ�� �Բ� ���

--(+) ��ȣ�� ����� OUTER JOIN
--WHERE ���� ���� ���ǿ��� OUTER JOIN �������� ��(+)�� ��ȣ ���
--���� ���ǹ����� NULL �� ��µǴ� ���̺��� Į���� (+) ��ȣ �߰�

-- �л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, ���������� �̸�, ������ ���
-- ��, ���������� �������� ���� �л��̸��� �Բ� ����Ͽ���.
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno; -- profno NULL �� �л� ��µ��� ����

SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno(+); --LEFT OUTER JOIN

--- ANSI OUTER JOIN
-- 1. ANSI LEFT OUTER JOIN
-- FROM ���� ���ʿ� ��ġ�� ���̺��� NULL �� ���� ��쿡 ���
-- WHERE���� ������ ��(+)�� ��ȣ�� �߰��� �Ͱ� ����
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       LEFT OUTER JOIN professor p
       ON s.profno = p.profno;
       
-- �л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, �������� �̸�, ������ ���
-- ��, �����л��� �������� ���� ���� �̸��� �Բ� ����Ͽ���
SELECT   s.name, s.grade, p.name, p.position
FROM     student s, professor p
WHERE    s.profno(+) = p.profno --RIGHT OUTER JOIN
ORDER BY p.profno;

--- ANSI OUTER JOIN
-- 2. ANSI RIGHT OUTER JOIN
-- FROM ���� �����ʿ� ��ġ�� ���̺��� NULL �� ���� ���, ���
-- WHERE ���� ����(+)�� ��ȣ�� �߰��� �Ͱ� ����

SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       RIGHT OUTER JOIN professor p
       ON s.profno = p.profno;

-- FULL OUTER JOIN
-- Oracle �������� -> ANSI��

-- �л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, �������� �̸�, ������ ���
-- ��, �����л��� �������� ���� ���� �̸� ��
-- ���������� �������� ���� �л��̸� �Բ� ����Ͽ���
SELECT   s.name, s.grade, p.name, p.position
FROM     student s, professor p
WHERE    s.profno(+) = p.profno(+) 
ORDER BY p.profno; -- ���� ORA-01468: a predicate may reference only one outer-joined table

--FULL OUTER ���  --> UNION
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno(+)
UNION
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno(+) = p.profno;

-- 3. ANSI FULL OUTER JOIN
-- LEFT OUTER JOIN �� RIGHT OUTER JOIN �� ���ÿ� ������ ����� ���
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       FULL OUTER JOIN professor p
       ON s.profno = p.profno;
       
       
----------------          SELF JOIN            ---------------
--�ϳ��� ���̺��� �ִ� Į������ �����ϴ� ������ �ʿ��� ��� ���
--���� ��� ���̺��� �ڽ� �ϳ���� �� �ܿ��� EQUI JOIN�� ����
--������ �����Ҷ� ���� ����
SELECT c.deptno, c.dname, c.college, d.dname college_name
       --�а�         �к�
FROM   department c, department d
WHERE  c.college = d.deptno;

-- SELF JOIN --> �μ� ��ȣ�� 201 �̻��� �μ� �̸��� ���� �μ��� �̸��� ���
-- ��� : xxx�Ҽ��� xxx�к�
SELECT dept.dname || '�� �Ҽ��� ' || org.dname
FROM   department dept, department org
WHERE  dept.college = org.deptno
AND    dept.deptno >= 201;


-- 08/09 HomeWork
-- 1. �̸�, �����ڸ�(emp TBL)  
SELECT w.ename, m.ename mgrname
FROM   emp w, emp m
WHERE  w.mgr = m.empno; --king�� �����ڳѹ� null�̹Ƿ� ��¾ȵ�

-- 2. �̸�,�޿�,�μ��ڵ�,�μ���,�ٹ���, ������ ��, ��ü����(emp ,dept TBL)
SELECT w.ename, w.sal, w.deptno, d.dname, d.loc, m.ename mgrname
FROM   emp w, emp m, dept d
WHERE  w.mgr    = m.empno(+) 
AND    w.deptno = d.deptno;

-- 3. �̸�,�޿�,���,�μ���,�����ڸ�, �޿��� 2000�̻��� ���
--    (emp, dept,salgrade TBL)
SELECT w.ename, w.sal, s.grade, d.dname, m.ename mgrname
FROM   emp w, emp m, salgrade s, dept d
WHERE  w.mgr = m.empno(+)
AND    w.deptno = d.deptno 
AND    w.sal BETWEEN s.losal(+) AND s.hisal(+)
AND    w.sal  >= 2000;

-- 4. ���ʽ��� �޴� ����� ���Ͽ� �̸�,�μ���,��ġ�� ����ϴ� SELECT ������ �ۼ�(emp ,dept TBL)
SELECT w.ename, d.dname, d.loc, w.comm
FROM   emp w, dept d
WHERE  w.deptno = d.deptno
AND    w.comm IS NOT NULL
AND    w.comm > 0;

-- 5. ���, �����, �μ��ڵ�, �μ����� �˻��϶�. ������������ ������������(emp ,dept TBL)
SELECT   w.empno, w.ename, w.deptno, d.dname
FROM     emp w, dept d
WHERE    w.deptno = d.deptno
ORDER BY w.ename;
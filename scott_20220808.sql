--1. salgrade ������ ��ü ����
SELECT * FROM salgrade;

--2. scott���� ��밡���� ���̺� ����
SELECT * FROM tab;

--3. emp Table���� ��� , �̸�, �޿�, ����, �Ի���
SELECT empno, ename, sal, job, hiredate
FROM   emp;

--4. emp Table���� �޿��� 2000�̸��� ��� �� ���� ���, �̸�, �޿� �׸� ��ȸ
SELECT empno, ename, sal
FROM   emp
WHERE  sal < 2000;

--5. emp Table���� 80/02���Ŀ� �Ի��� ����� ����  ���,�̸�,����,�Ի��� 
SELECT empno, ename, job, hiredate
FROM   emp
WHERE  hiredate >= '80/02/01';

--6. emp Table���� �޿��� 1500�̻��̰� 3000���� ���, �̸�, �޿�  ��ȸ
SELECT empno, ename, sal
FROM   emp
WHERE  sal BETWEEN 1500 AND 3000
--WHERE  sal >= 1500 AND sal <= 3000;

--7. emp Table���� ���, �̸�, ����, �޿� ��� [ �޿��� 2500�̻��̰�
--   ������ MANAGER�� ���]
SELECT empno, ename, job, sal
FROM   emp
WHERE  sal >= 2500 AND job = 'MANAGER';

--8. emp Table���� �̸�, �޿�, ���� ��ȸ 
   -- [�� ������  ���� = (�޿�+��) * 12  , null�� 0���� ����]
SELECT ename, sal, (sal+NVL(comm, 0)) * 12 ����
FROM   emp;

--9. emp Table����  81/02 ���Ŀ� �Ի��ڵ��� xxx�� �Ի����� xxX
--  [ ��ü Row ��� ] --> 2���� ��� ��
SELECT CONCAT(CONCAT(ename, '�� �Ի����� '), hiredate)
FROM   emp
WHERE  hiredate >= '81/02/01';

SELECT ename || '�� �Ի����� ' || hiredate
FROM   emp
WHERE  hiredate >= '81/02/01';

--10.emp Table���� �̸��ӿ� T�� �ִ� ���,�̸� ���
SELECT empno, ename
FROM   emp
WHERE  ename LIKE '%T%';


-- LAST_DAY , NEXT_DAY
-- LAST_DAY �ش� ��¥�� ���� ���� ������ ��¥�� ��ȯ�ϴ� �Լ�
-- NEXT_DAY �ش� ���� �������� ��õ� ������ ���� ��¥�� ��ȯ�ϴ� �Լ�
-- �ѱ� oracle���� ��day�� �� ��,ȭ,��,��,��,��,�� �� �ִ´�.
-- �̱� oracle���� ��day���� MON, TUE, WED, THU, FRI, SAT, SUN�� �ִ´�.


-- ������ ���� ���� ������ ��¥�� �ٰ����� �Ͽ����� ��¥�� ����Ͽ���
SELECT sysdate, LAST_DAY(sysdate), NEXT_DAY(sysdate, '��')
FROM   dual;
SELECT sysdate, LAST_DAY(sysdate), NEXT_DAY(sysdate, '��')
FROM   dual;

--��¥�Լ� ROUND, TRUNC
SELECT TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') NORMAL,
       TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') TRUNC,
       TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') ROUND
FROM   dual;


SELECT TO_CHAR(hiredate, 'YY/MM/DD HH24:MI:SS')   hiredate,
       TO_CHAR(ROUND(hiredate, 'dd'), 'YY/MM/DD') round_dd, -- 12��
       TO_CHAR(ROUND(hiredate, 'mm'), 'YY/MM/DD') round_mm, -- 16��
       TO_CHAR(ROUND(hiredate, 'yy'), 'YY/MM/DD') round_yy  -- 6��
FROM   professor;

-- TO_CHAR �Լ�
-- ��¥�� ���ڸ� ���ڷ� ��ȯ�ϱ� ���� ��� *** �ǹ����̾���
-- YYYY YY MM MON DD DY DAY

-- �л� ���̺��� ������ �л��� �й��� ������� �߿��� ����� ����Ͽ���
SELECT studno, TO_CHAR(birthdate, 'YYMM') birthdate
--SELECT studno, TO_CHAR(birthdate, 'YY/MM') birthdate --�ʿ��� ���Ĵ�� ���ڿ� �����ȴ�.
--SELECT studno, TO_CHAR(birthdate, 'YY-MM') birthdate --�ʿ��� ���Ĵ�� ���ڿ� �����ȴ�.
FROM   student
WHERE  name = '������';

-- ������ Ÿ���� ��ȯ
-- ���ڳ� ��¥ Ÿ���� ���ڿ� �Բ� �����ϰų� ���� ��Ŀ� ���߱� ���� �ַ� ��� 
-- �������� ������ Ÿ�� ��ȯ
-- �������� ������ Ÿ�� ��ȯ�� ��Ȯ�� ������ ���Ͽ� ����Ŭ���� ������ Ÿ���� ���������� ��ȯ�ϴ� ���
-- A�� Į�� B�� ���
-- A NUMBER = B VARCHAR2 �Ǵ� CHAR => B�� NUMBER Ÿ������ ��ȯ
-- A VARCHAR2 �Ǵ� CHAR = B NUMBER => A�� NUMBER Ÿ������ ��ȯ
-- ���� Ÿ���� ���� Ÿ������ ��ȯ�� ���ڿ��� ���ڷ� �������� ��쿡�� ����


-- ������� ������ Ÿ�� ��ȯ
-- ����ڰ� ������ Ÿ�� ��ȯ �Լ��� �̿��Ͽ� ��������� ������ Ÿ���� ��ȯ

-- ���ڸ� ���� �������� ��ȯ

-- TO_CHAR �Լ�
-- ��¥�� ���ڸ� ���ڷ� ��ȯ�ϱ� ���� ���
-- ��¥ ��� ���� ����

--���������� �޴� �������� �̸�, �޿�, ��������,
--�׸��� �޿��� ���������� ���� ���� 12�� ���� ����� �������� ����Ͽ���
SELECT name, sal, comm, TO_CHAR((sal+comm)*12, '9,999') anual_sal
FROM   professor
WHERE  comm IS NOT NULL;

-- TO_NUMBER �Լ�
-- ���ڷ� ������ ���ڿ��� ���� �����ͷ� ��ȯ�ϱ� ���� �Լ�

SELECT TO_NUMBER('123')
FROM   dual;

-- TO_DATE �Լ�
-- ���ڿ� ���ڷ� ������ ���ڿ��� ��¥ �����ͷ� ��ȯ�ϴ� �Լ�


--student Table �ֹε�Ϲ�ȣ���� ��������� �����Ͽ� ��YY/MM/DD�� ���·� ����Ͽ���(��ø�Լ�)
SELECT idnum, TO_CHAR(TO_DATE(SUBSTR(idnum, 1, 6), 'YYMMDD') , 'YY/MM/DD') BirthDate
FROM   student;
--SELECT idnum, TO_DATE(SUBSTR(idnum, 1, 6), 'YY/MM/DD') BirthDate
--FROM   student;

-- NVL �Լ�
-- NULL�� 0 �Ǵ� �ٸ� ������ ��ȯ�ϱ� ���� �Լ�

-- 201�� �а� ������ �̸�, ����, �޿�, ��������, �޿��� ���������� �հ踦 ����Ͽ���.
-- ��, ���������� NULL�� ��쿡�� ���������� 0���� ����Ѵ�

SELECT name, position, sal, comm, sal+comm,
       NVL(comm, 0) s1, NVL(sal+comm, 0) s2
FROM   professor
WHERE  deptno = 101;

-- NVL2 �Լ�
-- ù ��° �μ� ���� NULL�� �ƴϸ� �� ��° �μ� ���� ����ϰ�,
-- ù ��° �μ� ���� NULL�̸� �� ��° �μ� ���� ����ϴ� �Լ�

--102�� �а� �����߿��� ���������� �޴� ����� �޿��� ���������� ���� ���� �޿� �Ѿ����� ����Ͽ���. 
--��, ���������� ���� �ʴ� ������ �޿��� �޿� �Ѿ����� ����Ͽ���.

SELECT name, position, sal, comm,
       NVL2(comm, sal+comm, sal) total -- if else ���
FROM   professor
WHERE  deptno = 102;

-- NULLIF �Լ�
-- �� ���� ǥ������ ���Ͽ� ���� �����ϸ� NULL�� ��ȯ�ϰ�,
-- ��ġ���� ������ ù ��° ǥ������ ���� ��ȯ

-- ���� ���̺��� �̸��� ����Ʈ ���� ����� ���̵��� ����Ʈ ���� ���ؼ�
-- ������ NULL�� ��ȯ�ϰ�
-- ���� ������ �̸��� ����Ʈ ���� ��ȯ
SELECT name, userid , LENGTHB(name), LENGTHB(userid),
       NULLIF(LENGTHB(name), LENGTHB(userid)) nullif_result
FROM   professor;

-- COALESCE �Լ�(�Ϲ� �Լ� NVL Ȯ�� �Լ�)
-- �μ��߿���  NULL�� �ƴ� ù ��° �μ��� ��ȯ�ϴ� �Լ�

-- ��) ���� ���̺��� ���������� NULL�� �ƴϸ� ���������� ����ϰ�,
--     ���������� NULL�̰� �޿��� NULL�� �ƴϸ� �޿��� ���,
--     ��������� �޿��� NULL�̸� 0�� ���

SELECT name, comm, sal, COALESCE(comm, sal, 0) Co_result
FROM   professor;

-- DECODE �Լ� ***** �ǹ����� ������ ����
-- ���� ���α׷��� ���� IF���̳� CASE ������ ǥ���Ǵ� ������ �˰�����
-- �ϳ��� SQL ��ɹ����� �����ϰ� ǥ���� �� �ִ� ������ ��� 
-- DECODE �Լ����� �� �����ڴ� ��=���� ����

-- ��) ���� ���̺��� ������ �Ҽ� �а� ��ȣ�� �а� �̸����� ��ȯ�Ͽ� ����Ͽ���. 
--     �а� ��ȣ�� 101�̸� ����ǻ�Ͱ��а���, 102�̸� ����Ƽ�̵���а���, 201�̸� �����ڰ��а���, 
--     ������ �а� ��ȣ�� �������а���(default)�� ��ȯ
SELECT name, deptno,
       DECODE(deptno, 101, '��ǻ�Ͱ��а�',
                      102, '��Ƽ�̵���а�',
                      201, '���ڰ��а�',
                           '�����а�'
             ) deptname
FROM   professor;

-- CASE �Լ� - DECODE VS CASE �� �߿�
-- DECODE �Լ��� ����� Ȯ���� �Լ� 
-- DECODE �Լ��� ǥ���� �Ǵ� Į�� ���� ��=�� �񱳸� ���� ���ǰ� ��ġ�ϴ� ��쿡�� �ٸ� ������ ��ġ�� �� ������,
-- CASE �Լ������� ��� ����, ���� ����, �� ����� ���� �پ��� �񱳰� ����
-- ���� WHEN ������ ǥ������ �پ��ϰ� ����
-- 8.1.7�������� �����Ǿ�����, 9i���� SQL, PL/SQL���� �Ϻ��� ���� 
-- DECODE �Լ��� ���� �������� ����ü��� �پ��� �� ǥ���� ���

-- ��) DECODE ������ ������.
SELECT name, deptno,
       CASE WHEN deptno = 101 THEN '��ǻ�Ͱ��а�'
            WHEN deptno = 102 THEN '��Ƽ�̵���а�'
            WHEN deptno = 201 THEN '���ڰ��а�'
            ELSE                   '��ǻ�Ͱ��а�'
       END deptname
FROM   professor;

-- ���� ���̺��� �Ҽ� �а��� ���� ���ʽ��� �ٸ��� ����Ͽ� ����Ͽ���.
-- �а� ��ȣ���� ���ʽ��� ������ ���� ����Ѵ�.
-- �а� ��ȣ�� 101�̸� ���ʽ��� �޿��� 10%, 102�̸� 20%, 201�̸� 30%, ������ �а��� 0%
SELECT name, deptno, sal,
       CASE WHEN deptno = 101 THEN sal * 0.1
            WHEN deptno = 102 THEN sal * 0.2
            WHEN deptno = 201 THEN sal * 0.3
            ELSE                   sal * 0
       END bonus
FROM   professor;

---------------         Home Work           --------------------
--1. emp Table �� �̸��� �빮��, �ҹ���, ù���ڸ� �빮�ڷ� ���
SELECT ename, UPPER(ename), LOWER(ename), INITCAP(ename)
FROM   emp;

--2. emp Table ��  �̸�, ����, ������ 2-5���� ���� ���
SELECT ename, job, SUBSTR(job, 2, 5)
FROM   emp;

--3. emp Table �� �̸�, �̸��� 10�ڸ��� �ϰ� ���ʿ� #���� ä���
SELECT ename, LPAD(ename, 10, '#')
FROM   emp;

--4. emp Table ��  �̸�, ����, ������ MANAGER�� �����ڷ� ��� (V)
SELECT ename, job, REPLACE(job, 'MANAGER', '������') ������
FROM   emp;

--5. emp Table ��  �̸�, �޿�/7�� ���� ����, �Ҽ��� 1�ڸ�. 10������   �ݿø��Ͽ� ���
SELECT ename, sal/7, ROUND(sal/7), ROUND(sal/7, 1), ROUND(sal/7, -1)
FROM   emp;

--6.  emp Table ��  �̸�, �޿�/7�� ���� ����, �Ҽ��� 1�ڸ�. 10������ �����Ͽ� ���
SELECT ename, sal/7, TRUNC(sal/7), TRUNC(sal/7, 1), TRUNC(sal/7, -1)
FROM   emp;

--7. emp Table ��  �̸�, �޿�/7�� ����� �ݿø�,����,ceil,floor
SELECT ename, sal/7, ROUND(sal/7), TRUNC(sal/7), CEIL(sal/7), FLOOR(sal/7)
FROM   emp;

--8. emp Table ��  �̸�, �޿�, �޿�/7�� ������
SELECT ename, sal, MOD(sal, 7)
FROM   emp;

--9. emp Table �� �̸�, �޿�, �Ի���, �Ի�Ⱓ(���� ����,��)���
SELECT ename, sal, hiredate,
       ROUND(sysdate-hiredate) �Ի�Ⱓ��¥,
       ROUND(MONTHS_BETWEEN(sysdate, hiredate)) �Ի�Ⱓ��
FROM   emp;

--10.emp Table ��  job �� 'CLERK' �϶� 10% ,'ANALYST' �϶� 20% 
--                                 'MANAGER' �϶� 30% ,'PRESIDENT' �϶� 40%
--                                 'SALESMAN' �϶� 50% 
--                                 �׿��϶� 60% �λ� �Ͽ� 
--   empno, ename, job, sal, �� �� �λ� �޿��� ����ϼ���(CASE/Decode�� ���)
SELECT job, sal,
       DECODE(job, 'CLERK',     sal * 1.1,
                   'ANALYST',   sal * 1.2,
                   'MANAGER',   sal * 1.3,
                   'PRESIDENT', sal * 1.4,
                   'SALESMAN',  sal * 1.5,
                                sal * 1.6
             ) sal1
FROM   emp;

--------------------------------------------------------------------------------
-- 8��. �׷��Լ�
-- ���̺��� ��ü ���� �ϳ� �̻��� �÷��� �������� �׷�ȭ�Ͽ� �׷캰�� ����� ����ϴ� �Լ�
-- �׷��Լ��� ������� ����� ����ϴµ� ���� ���
-- �׷��Լ������� ���� Ű���� HAVING����. (�Ϲ��Լ��� WHERE) �߿�!
-- COUNT MAX MIN SUM AVG

-- 1) COUNT �Լ�
-- ���̺��� ������ �����ϴ� ���� ������ ��ȯ�ϴ� �Լ�
-- COUNT(*)�� NULL ���� ��� ���� ����
-- �Ϲ������� NULL ����

-- ��1) 101�� �а� �����߿��� ���������� �޴� ������ ���� ����Ͽ���
SELECT COUNT(comm) -- null���� ���� ������ ���ܵȴ�.
FROM   professor
WHERE  deptno=101;
-- ��2) 101�� �а� �����߿��� ������ ���� ����Ͽ���
SELECT COUNT(*) --*�� �ָ� null���� ������ �ʴ´�.
FROM   professor
WHERE  deptno=101;
-- 101�� �а� �л����� ������ ��հ� �հ踦 ����Ͽ���

-- AVG, SUM �Լ�
-- �μ��� ������ Į���� ���� ������ �����ϴ� ���߿��� NULL�� ������ ��� ���� �հ踦 ���ϴ� �Լ�
-- ���� ������ Ÿ�Կ��� ��� ����

SELECT AVG(weight), SUM(weight)
FROM   student
WHERE  deptno = 102;

-- STDDEV, VARIANCE �Լ�
-- �μ��� ������ Į���� ���� ������ �����ϴ� ���� ������� ǥ�������� �л��� ���ϴ� �Լ�
-- ���� ������ Ÿ�Կ��� ��� ����
-- NULL �� ���꿡�� ����

-- ���� ���̺��� �޿��� ǥ�������� �л��� ���
SELECT STDDEV(sal), VARIANCE(sal)
FROM   professor;


-- GROUP BY ��
-- Ư�� Į�� ���� �������� ���̺��� ��ü ���� �׷캰�� ������ ���� ��
-- ���� ���, ���� ���̺��� �Ҽ� �а����̳� ���޺��� ��� �޿��� ���ϴ� ���
-- GROUP BY ���� ��õ��� ���� Į���� �׷��Լ��� �Բ� ����� �� ����*

-- GROUP BY �� ���� ����Ǵ� ��Ģ
-- �׷��� ���� WHERE ���� ����Ͽ� �׷� ��� ������ ���� ����
-- GROUP BY ������ �ݵ�� Į�� �̸��� �����ؾ� �ϸ� Į�� ������ ����� �� ����*
-- �׷캰 ��� ������ ������������ ����
-- SELECT ������ ������ Į�� �̸��̳� ǥ������ GROUP BY ������ �ݵ�� ���*

--HAVING ���� WHERE ���� ���� ����
--HAVING ��
--���� ���� ������ ���� �׷�ȭ�� ��� ���տ� ���� �˻� ���� ����
--WHERE ��
--�׷�ȭ�ϱ� ���� ���� �˻� ���� ����
--�ǹ� �����ͺ��̽� ���������� ���� ����
--WHERE ���� �˻� ������ ���� �����ϴ� ����� ȿ����
--�׷�ȭ�ϴ� �� ������ �ٿ��� ���� ���� �ð��� ����
--SQL ó�� ���� ���


-- �а��� �л����� �ο���, ������ ��հ� �հ踦 ����Ͽ���
SELECT   deptno, COUNT(*), AVG(weight), SUM(weight)
FROM     student
GROUP BY deptno;

-- ���� ���̺��� �а����� ���� ���� ���������� �޴� ���� ���� ����Ͽ���
SELECT   deptno, COUNT(*), COUNT(comm)
FROM     professor
GROUP BY deptno;

-- ���� ���̺��� �а����� ���� ���� ���������� �޴� ���� ���� ����Ͽ���
-- �� �а��� ���� ���� 2�� �̻��� �а��� ���
SELECT   deptno, COUNT(*), COUNT(comm)
FROM     professor
GROUP BY deptno
HAVING   COUNT(*) > 1;

-- �л� ���� 4���̻��̰� ���Ű�� 168�̻���  �г⿡ ���ؼ� �г�, �л� ��, ��� Ű, ��� �����Ը� ���
-- ��, ��� Ű�� ��� �����Դ� �Ҽ��� �� ��° �ڸ����� �ݿø� �ϰ�, 
-- ��¼����� ��� Ű�� ���� ������ ������������ ��� --���� �ؼ����ض�. 
SELECT   grade, COUNT(*),
         ROUND(AVG(height), 1) avg_height,
         ROUND(AVG(weight), 1) avg_weight
FROM     student
GROUP BY grade
HAVING   COUNT(*) >= 4 AND ROUND(AVG(height)) > 168
ORDER BY avg_height DESC, avg_weight DESC;


-- MIN, MAX �Լ�
-- �μ��� ������ Į���� ���� ������ �����ϴ� ���߿��� �ּҰ��� �ִ� ���� ���ϴ� �Լ�
-- ������ AVG, SUM �Լ��� �����ϳ� ���� ������ Ÿ�Կ��� ��� ����

-- 1. �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
SELECT MIN(hiredate), MAX(hiredate)
FROM   emp;

-- 2. �μ��� �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
SELECT   deptno, MIN(hiredate), MAX(hiredate)
FROM     emp
GROUP BY deptno;

-- ���� Į���� �̿��� �׷���
-- �ϳ� �̻��� Į���� ����Ͽ� �׷��� ������, �׷캰�� �ٽ� ���� �׷��� ����
-- ��ü ������ �а����� ���� �׷����� ����, �а��� ������ ���޺��� �ٽ� �׷����ϴ� ���

-- 3. �μ���, ������ count & sum[�޿�]    (emp)
SELECT   deptno, job, COUNT(*), SUM(sal)
FROM     emp
GROUP BY deptno, job
ORDER BY deptno, job;

-- 4. �μ��� �޿��Ѿ� 3000�̻� �μ���ȣ,�μ��� �޿��ִ�    (emp)
SELECT   deptno, SUM(sal), MAX(sal)
FROM     emp
GROUP BY deptno
HAVING   SUM(sal) >= 3000;

-- 5. ��ü �л��� �Ҽ� �а����� ������, ���� �а� �л��� �ٽ� �г⺰�� �׷����Ͽ�, 
--   �а��� �г⺰ �ο���, ��� �����Ը� ���, 
-- (��, ��� �����Դ� �Ҽ��� ���� ù��° �ڸ����� �ݿø� )  STUDENT
SELECT   deptno, grade, COUNT(*), ROUND(AVG(weight))
FROM     student
GROUP BY deptno, grade;



-- ROLLUP ������ -�����迡�� ������ �Ѵ� - �ǹ����� ���� ��������� �ʴ´�.
-- GROUP BY ���� �׷� ���ǿ� ���� ��ü ���� �׷�ȭ�ϰ� �� �׷쿡 ���� �κ����� ���ϴ� ������

-- ��) �Ҽ� �а����� ���� �޿� �հ�� ��� �а� �������� �޿� �հ踦 ����Ͽ���
SELECT   deptno, SUM(sal)
FROM     professor
GROUP BY ROLLUP(deptno);

-- ��2) ROLLUP �����ڸ� �̿��Ͽ� �а� �� ���޺� ���� ��, �а��� ���� ��, ��ü ���� ���� ����Ͽ���
SELECT   deptno, position, COUNT(*)
FROM     professor
GROUP BY ROLLUP(deptno, position);

-- CUBE ������ -�����迡�� ������ �Ѵ� - �ǹ����� ���� ��������� �ʴ´�.
-- ROLLUP�� ���� �׷� ����� GROUP BY ���� ����� ���ǿ� ���� �׷� ������ ����� ������

-- ��1) CUBE �����ڸ� �̿��Ͽ� �а� �� ���޺� ���� ��, �а��� ���� ��, ��ü ���� ���� ����Ͽ���.
SELECT   deptno, position, COUNT(*)
FROM     professor
GROUP BY CUBE(deptno, position);


--------------------------------------------------------------------------------
------ 9-0 . DeadLock                                                 ----------------
--------------------------------------------------------------------------------
-- Transaction A
-- 1)
UPDATE emp
SET    sal   = sal * 1.1
WHERE  empno = 7369
;

UPDATE emp
SET    sal   = sal * 1.1
WHERE  empno = 7839
;

-- Transaction B
UPDATE emp
SET    comm  = 500
WHERE  empno = 7839
;

UPDATE emp
SET    comm  = 300
WHERE  empno = 7369
;



--------------------------------------------------------------------------------
------ 9 . JOIN                                                 ----------------
--------------------------------------------------------------------------------
-- 3 SPARC ANSI Modeling

-- ������ ����
-- �ϳ��� SQL ��ɹ��� ���� ���� ���̺� ����� �����͸� �ѹ��� ��ȸ�� �� �ִ� ���
-- ������ �����ͺ��̽� �о��� ǥ��
-- �ΰ� �̻��� ���̺��� �����ա� �Ѵٴ� �ǹ�

-- ������ �ʿ伺
-- ������ ������� �ʴ� �Ϲ����� ��
-- �л� �ּҷ��� ����ϱ� ���� �л����� �й�, �̸�, �Ҽ��а� �̸��� �˻�
-- �л��� ���� ���� �˻��ϴ� �ܰ� �ʿ�
-- �л� �������� �Ҽ��а���ȣ ������ �����Ͽ� �Ҽ��а� �̸��� �˻��ϴ� �ܰ� �ʿ�

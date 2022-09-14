COMMENT ON COLUMN EMP.HIREDATE IS '�Ի�����';  --"SCOTT"."EMP"."HIREDATE" scott�����̹Ƿ� scott ��������
--comment �߿��ϴ�. Ŀ�´����̼� ���. 

-- ������ : dept Table�� ROW ���� ��ŭ ����
SELECT sysdate FROM dept;

-- ������ : dept Table�� ROW ���� ��ŭ ���� --> DUAL
SELECT sysdate FROM DUAL;

-- DUAL���̺��� ������ ��ųʸ��� �Բ� Oracle�� ���� �ڵ����� �����Ǵ� ���̺� �Դϴ�. 
-- - DUAL���̺��� ����� SYS�� ��Ű���� ������ ��� ����ڴ� DUAL�̶�� �̸����� ������ �� �� �ֽ��ϴ�. 
-- - DUAL���̺��� VARCHAR2(1)���� ���ǵ� DUMMY��� �ϳ��� ���� ������ ���� ������ �ϳ��� �൵ ���ԵǾ� �ֽ��ϴ�. 
-- - DUAL���̺��� ����ڰ� ����̳� ����� �Լ����� �����ϰ��� �� ��쿡 ���� �մϴ�


-- WHERE��
-- ���̺� ����� ������ �߿��� ���ϴ� �����͸� ���������� �˻��ϴ� ���
-- WHERE ���� ���ǹ��� Į�� �̸�, ������, ���, ��� ǥ������ �����Ͽ� �پ��� ���·� ǥ�� ����
-- WHERE ������ ����ϴ� ������ Ÿ���� ����, ����, ��¥ Ÿ�� ��� ����
-- ���ڿ� ��¥ Ÿ���� ��� ���� ���� ����ǥ(����)�� ��� ǥ���ϰ� ���ڴ� �״�� ���
-- ��� ������ �����ڴ� ��ҹ��ڸ� ���� 

-- �л� ���̺��� 1�г� �л��� �˻��Ͽ� �й�, �̸�, �а� ��ȣ�� ���
SELECT studno, name, deptno 
FROM   student
WHERE  grade = 1;  -- grade�� VACHAR2 1�� ���ڴ�. �����ȹ�� ���� TO_NUMBER(GRADE)=1  <- ���������� ��ȯ���༭ �񱳰� ��������
--WHERE grade = '1'; ���ڿ� ���� ���ϸ� ������ ���ڿ� ���缭 ���κ�ȯ. TO NUMBER


-- �� ������ 
-- WHERE ������ ����, ����, ��¥�� ũ�⳪ ������ ���ϴ� ������
--<> ���� �ʴ�

-- �л� ���̺��� �����԰� 70kg ������ �л��� �˻��Ͽ� �й�, �̸�, �г�, �а���ȣ, �����Ը� ����Ͽ���
SELECT studno , name , grade , deptno , weight 
FROM   student
WHERE  weight <= 70;

-- �� ������
-- WHERE ������ ���� ���� ������ ������ ���
-- AND, OR, NOT�� ���� �� �����ڸ� ���

-- �л� ���̺��� 1�г� �̸鼭 �����԰� 70kg �̻��� �л��� �˻��Ͽ� �̸�, �г�, ������, �а���ȣ�� ���
SELECT name, grade, weight, deptno 
FROM   student
WHERE  grade = '1' 
AND    weight >= 70;

-- �л� ���̺��� 1�г��̰ų� �����԰� 70kg �̻��� �л��� �˻��Ͽ� �̸�, �г�, ������, �а���ȣ�� ���
SELECT name, grade, weight, deptno
FROM   student
WHERE  grade = '1'
OR     weight >= 70;

-- �л� ���̺��� �а���ȣ�� ��101���� �ƴ� �л��� �й��� �̸��� �а���ȣ�� ���
SELECT    studno, name, deptno
FROM      student
WHERE NOT deptno = 101;
--WHERE deptno != 101;


-- SQL ������ �ſ� �߿��ϴ�. �װ��� �� �˾Ƶ���.
-- SQL �����ڴ� SQL ���� ����
-- SQL �����ڴ� ��� ������ Ÿ�Կ� ���� ��� ����
-- BETWEEN a AND b  - a�� b���� �� a,b ����
-- IN(a,b,c,....,n) - a~n �� �ϳ��� ��ġ�ϸ� ��
-- LIKE             - ���� ���ϰ� �κ������� ��ġ'%,_'�ϸ� ��
-- IS NULL          - NULL �̸� ��

-- BETWEEN �����ڸ� ����Ͽ� -- �����ڵ� ���� ����Ѵ�
-- �����԰� 50kg���� 70kg ������ �л��� �й�, �̸�, �����Ը� ���
SELECT studno, name, weight
FROM   student
WHERE  weight BETWEEN 50 AND 70;

-- BETWEEN �л����̺��� 81�⿡�� 83�⵵�� �¾ �л��� �̸��� ��������� ���
SELECT name, birthdate
FROM   student
WHERE  birthdate BETWEEN '81/01/01' AND '83/12/31';

-- OR ������ / IN �����ڸ� ����Ͽ� 101�� �а���102�� �а��� 201�� �а� 
-- �л��� �̸�, �г�, �а���ȣ�� ���
SELECT name, grade, deptno
FROM   student
WHERE  deptno = 101
OR     deptno = 102
OR     deptno = 201;

SELECT name, grade, deptno
FROM   student
WHERE  deptno IN(101, 102, 201); --�����ڵ� ���̾���.

-- �л� ���̺��� ���� ���衯���� �л��� �̸�, �г�, �а� ��ȣ�� ���
SELECT name, grade, deptno
FROM   student
WHERE  name LIKE '��%';

-- �л� ���̺��� �������̸��� ���桯�� �л��� �̸�, �г�, �а� ��ȣ�� ���
SELECT name, grade, deptno
FROM   student
WHERE  name LIKE '%��';

-- �л� ���̺��� �̸��� 3����, ���� ���衯���� 
-- ������ ���ڰ� ���������� ������ �л��� �̸�, �г�, �а� ��ȣ�� ���
SELECT name, grade, deptno
FROM   student
WHERE  name LIKE '��_��';


-- NULL ����
-- NULL�� ��Ȯ�� ���̳� ���� ������� ���� ���� �ǹ� Unknown or N/A(Not Applicable)
-- 0�� �ƴϰ� ���鵵 �ƴ�
-- NULL ���� �����ϴ� ������ ��� ��� ���� NULL�̴�. �𸣴� �����Ϳ� ���ڸ� ���ϰų� ���� ����� ���������� �𸣴� �������� �Ͱ� ����.

-- �⺻ Ű(primary key)
-- �����̼ǿ� ����Ǵ� Ʃ���� ���ϼ��� �����ϱ� ���Ͽ� �ϳ� �̻��� �Ӽ����� �����Ǵ� �ĺ���
-- ���ϼ�(uniqueness)�� �ּҼ�(minimality)�� ����
-- * PK Ư¡ ****���� �ܰ�մ�. index�� �񱳵� 
-- 1) ���ϼ� : �ߺ��� Ű ���� �Ұ���
-- 2) Not Null : Null �� ���ִ´�
-- 3) �ּҼ� : �ּҷ� ���� �� ������ �ּҷ� ��Ƶξ��

-- NVL  NULL�� 0 �Ǵ� �ٸ� ������ ��ȯ�ϱ� ���� �Լ� --�ǹ����� ���̾�, if��ó�� ����.
-- NVL( expression1, expression2)
-- expression1 NULL�� �����ϴ� Į�� �Ǵ� ǥ���� -expression2 NULL�� ��ü�ϴ� �� -�Ѵ� ������ ������Ÿ���̾����
-- NVL2 �Ѽ��� ù ��° �μ� ���� NULL�� �ƴϸ� �� ��° �μ� ���� ����ϰ�, ù ��° �μ� ���� NULL�̸� �� ��° �μ� ���� ����ϴ� �Լ�
-- NVL2(expression1, expression2, expression3) 
-- expression1 : NULL�� �����ϴ� Į�� �Ǵ� ǥ���� -expression2 : expression1�� NULL�̾ƴҶ� ��ȯ�Ǵ� �� 
-- expression3 : expression1�� NULL�̸� ��ü�Ǵ� ��

-- ������ : comm�� NULL�϶� sal+comm�� NULL�̸�
SELECT empno, sal, comm, sal+comm --NULL�� �ٸ����� ���� ����� NULL
FROM   emp;
-- �ذ�å : comm�� NULL�϶� NVL �Ǵ� NVL2 ���
SELECT empno, sal, comm, sal+NVL(comm, 0); -- comm�� NULL�϶� comm�� 0����  
FROM   emp;

-- COMM�� NULL�ΰ� ��
SELECT * FROM emp
WHERE comm IS NULL;
-- COMM�� NULL�ƴѰ� �� 
SELECT * FROM emp
WHERE comm IS NOT NULL;

-- ���� ���̺��� ���������� ���� ������ �̸�, ����, ���������� ���
SELECT name, position, comm
FROM   professor
WHERE  comm IS NULL;

--���� ���̺��� �޿��� ���������� ���� ����
--sal_com�̶�� �������� ���(name, position, sal, comm) NULL�ذ�
SELECT name, position, sal, comm, sal+NVL(comm, 0) "sal_com"
FROM   professor;

-- 102�� �а��� �л� �߿��� 1�г� �Ǵ� 4�г� �л��� �̸�, �г�, �а� ��ȣ�� ���
SELECT name, grade, deptno
FROM   student
WHERE  deptno = 102
AND    (grade IN('1', '4'));
--AND    (grade = '1' OR grade = '4'); --��ȣ �߿�. ������� �޶����Ƿ�.

-- 1�г� �̸鼭 �����԰� 70kg �̻��� �л��� ���� --> Table stud_heavy
CREATE TABLE stud_heavy
AS
    SELECT *
    FROM   student
    WHERE  weight >= 70
    AND    grade = '1'
; -- �⺻���� ������ �����ϰ� ����������� �ֿ����������� ���� �ʴ� (PK ���°� Ȯ��)

-- 1�г� �̸鼭 101�� �а��� �Ҽӵ� �л�(stud_101)
CREATE TABLE stud_101
AS
    SELECT *
    FROM   student
    WHERE  deptno = 101
    AND    grade = '1'
;


-- ���� ������   - �ǹ����� ���̾���
-- ���̺��� �����ϴ� �����տ� ���� ���̺��� �κ� ������ ����� ��ȯ�ϴ� ������
-- �պ� ���� : ���� ������ ����� �Ǵ� �� ���̺��� Į������ ����, �����Ǵ� Į������ ������ Ÿ���� ����
-- UNION     �� ���տ� ���� �ߺ��Ǵ� ���� ������ ������
-- UNION ALL �� ���տ� ���� �ߺ��Ǵ� ���� ������ ������
-- MINUS     �� ���հ� ������
-- INTERSECT �� ���հ� ������

-- Union      ������ �ٸ� ��(Ÿ��,Į����) ���� �߻�
SELECT studno, name, userid
FROM   stud_heavy
UNION
SELECT studno, name
FROM   stud_101;

-- Union      �ߺ� ����  --���� ���� ��
SELECT studno, name
FROM   stud_heavy
UNION
SELECT studno, name
FROM   stud_101;

-- Union All  �ߺ� ���
SELECT studno, name
FROM   stud_heavy
UNION  ALL
SELECT studno, name
FROM   stud_101;

-- Intersect --> ����
SELECT studno, name
FROM   stud_heavy
INTERSECT
SELECT studno, name
FROM   stud_101;

-- Minus --> �� (�ڵ��� , ������) - (�ڹ̰�, ������)
SELECT studno, name
FROM   stud_heavy
MINUS
SELECT studno, name
FROM   stud_101;



--������ ���۾� (DML:Data Manpulation Language)��?
--���̺� ���ο� �����͸� �Է��ϰų� ���� �����͸� ���� �Ǵ� �����ϱ� ���� ��ɾ�


INSERT INTO emp VALUES 
(1000, '������', 'CLERK', 7902, TO_DATE('03-08-2022','dd-mm-yyyy'),2800, NULL, 20);
INSERT INTO emp VALUES 
(2000, 'test', 'CLERK', 7902, TO_DATE('03-08-2022','dd-mm-yyyy'),2800, NULL, 20);


-- ������
UPDATE EMP
SET    JOB = 'MANAGER'
             ,deptno = 10
WHERE  EMPNO = 1000; -- PK

COMMIT;

-- ������
DELETE EMP --WHERE �����ָ� ���̺� �� �����ȴ�.
WHERE  EMPNO = 2000; --PK�� �־��־�� �����ڰ� �ǵ�ġ ���� ������ �߻��� ����.

COMMIT;

INSERT INTO dept VALUES(51,'ȸ����','����')
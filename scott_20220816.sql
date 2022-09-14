------------------------------------------------------------------------
---    PL/SQL�� ���� Oracle's Procedural Language extension to SQL
---   1. Oracle���� �����ϴ� ���α׷��� ����� Ư���� ������ SQL�� Ȯ��
---   2. PL/SQL Block������ SQL�� DML(������ ���۾�)���� Query(�˻���)��, 
---      �׸��� ������ ���(IF, LOOP) ���� ����Ͽ� ���������� ���α׷����� �����ϰ� 
---      �� ������ Ʈ����� ���        - Ʈ����� Ư¡ ���� ������-> ACID 
---
---   1) ���� 
---      ���α׷� ������ ���ȭ : ������ ���α׷��� �ǹ��ְ� �� ���ǵ� ���� Block ����
---      ��������  : ���̺�� Į���� ������ Ÿ���� ������� �ϴ� �������� ������ ����
---      ����ó��  : Exception ó�� ��ƾ�� ����Ͽ� Oracle ���� ������ ó��
---      �̽ļ�    : Oracle�� PL/SQL�� �����ϴ¾ ȣ��Ʈ�ε� ���α׷� �̵� ����
---      ���� ��� : ���� ���α׷��� ������ ��� -�������� ����
---
---    PL/SQL ������ ������ ���� ���� ������������ function procedure trigger package
------------------------------------------------------------------------
-- FUNCTION : ����ȯ�濡 �ݵ�� �ϳ��� ���� ������� �Ǵ� ��쿡 Function�� ����
-- ��1) Ư���� ���� ������ 7%�� ����ϴ� Function�� �ۼ�
---  ���� 1 : Function --> tax
---  ���� 2 : parameter --> p_num (�޿�) 
---  ���� 3 : ����� ���� 7% ���� ������ 

CREATE OR REPLACE FUNCTION tax
    (p_num IN NUMBER)
RETURN NUMBER
IS
    v_tax NUMBER;
BEGIN
    v_tax := p_num * 0.07;  -- := ���� �Ѱ��ش�
    RETURN (v_tax);
END;

----
SELECT tax(100) FROM dual; --SELECT �ȿ� �Լ�ȣ���ؼ� �� �޾ƿ��� ����
SELECT tax(200) FROM dual;

SELECT empno, ename, tax(sal)
FROM   emp;

------------------------------------------------------------
--  EMP ���̺��� ����� �Է¹޾� �ش� ����� �޿��� ���� ������ ����.
-- �޿��� 1000 �̸��̸� �޿��� 5%, 
-- �޿��� 2000 �̸��̸� 7%, 
-- 3000 �̸��̸� 9%, 
-- �� �̻��� 12%�� ���� ����
--- FUNCTION  emp_tax
-- 1) Parameter : ��� p_empno
--      ����    :   v_sal(�޿�)
--                  v_pct(����)
-- 2) ����� ������ �޿��� ����
-- 3) �޿��� ������ ���� ��� 
-- 4) ��� �� �� Return number
-------------------------------------------------------------

CREATE OR REPLACE FUNCTION  emp_tax  -- �����ϵ� �Լ����� �ּ��� �ְ� ������ �Լ� ���ʿ� �ּ��� ������ �ȴ�
    (p_empno IN emp.empno%TYPE )  -- 1) Parameter : ���
RETURN NUMBER
IS
   v_sal emp.sal%TYPE;
   v_pct NUMBER(5,2);
   v_tax NUMBER;
BEGIN
  -- 2) ����� ������ �޿��� ����
   SELECT sal
   INTO   v_sal
   FROM   emp
   WHERE  empno = p_empno ;
   -- 3) �޿��� ������ ���� ��� 
   IF    v_sal <  1000  THEN
         v_pct := 0.05;
   ELSIF v_sal <  2000  THEN
         v_pct := 0.07;
   ELSIF v_sal <  3000  THEN
         v_pct := 0.09;
   ELSE      
         v_pct := 0.12;
   END IF;
   
   v_tax := v_sal * v_pct;
   
   RETURN (v_tax);
END emp_tax;

---   
SELECT ename, sal, EMP_TAX(empno) emp_rate
FROM   emp;


-----------------------------------------------------
--  Procedure up_emp ���� ���
-- SQL> EXECUTE up_emp(1200);  -- ��� 
-- ��� : �޿� �λ� ����
--              ���۹���
-- ���� : v_job(����)
          v_pct(����)
-- ���� 1) job = SALE����         v_pct : 10
--     2)       MAN               v_pct : 7  
--     3)                         v_pct : 5
--   job�� ���� �޿� �λ��� ����  sal = sal+sal*v_pct/100
-- Ȯ�� : DB -> TBL
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE up_emp
    (p_empno IN emp.empno%TYPE)
IS
    v_job emp.job%TYPE;
    v_pct NUMBER(3);
BEGIN
    SELECT job
    INTO   v_job
    FROM   emp
    WHERE  empno = p_empno;
    
    IF     v_job LIKE 'SALE%' THEN
           v_pct := 10;
    ELSIF  v_job LIKE 'MAN%' THEN
           v_pct := 7;
    ELSE
           v_pct := 5;
    END IF;
    UPDATE emp
    SET    sal = sal + sal * v_pct / 100
    WHERE  empno = p_empno;
END;


----------------------------------------------------------
-- PROCEDURE Delete_emp
-- SQL> EXECUTE Delete_emp(5555);
-- �����ȣ : 5555
-- ����̸� : 55
-- �� �� �� : 81/12/03
-- ������ ���� ����
--  1. Parameter : ��� �Է�
--  2. ��� �̿��� �����ȣ ,����̸� , �� �� �� ���
--  3. ��� �ش��ϴ� ������ ���� 
----------------------------------------------------------
CREATE OR REPLACE PROCEDURE Delete_emp
    (p_empno IN emp.empno%TYPE)
IS
    v_empno    emp.empno%TYPE;
    v_ename    emp.ename%TYPE;
    v_hiredate emp.hiredate%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT empno, ename, hiredate
    INTO   v_empno, v_ename, v_hiredate
    FROM   emp
    WHERE  empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_empno);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�� �� �� : ' || v_hiredate);
    DELETE
    FROM  emp
    WHERE empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('������ ���� ����');
END Delete_Emp;

EXEC Delete_emp(5555);
---------------------------------------------------------
-- �ൿ���� : �μ���ȣ �Է� �ش� emp ����  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(75);
--  ��ȸȭ�� :    ���    : 5555
--                �̸�    : ȫ�浿

CREATE OR REPLACE PROCEDURE DeptEmpSearch1
    (p_deptno IN emp.deptno%TYPE)
IS
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT empno, ename
    INTO   v_empno, v_ename
    FROM   emp
    WHERE  deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('��� : ' || v_empno);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || v_ename);
END DeptEmpSearch1;

EXEC DeptEmpSearch1(40);
------------------------------------------------------------------------------------
-- %ROWTYPE
--  �ϳ� �̻��� �����Ͱ��� ���� ������ Ÿ������ �迭�� ����� ������ �ϰ� ������ �����ϴ�.
--  %ROWTYPE ������ ����, PL/SQL���̺�� ���ڵ�� ���� ������ Ÿ�Կ� ���Ѵ�.

-- ���̺��̳� �� ������ �÷� ��������, ũ��, �Ӽ� ���� �״�� ��� �� �� �ִ�.
--  %ROWTYPE �տ� ���� ���� �����ͺ��̽� ���̺� �̸��̴�.
--  ������ ���̺��� ������ ������ ������ ���� ������ ���� �� �� �ִ�.
--  �����ͺ��̽� �÷����� ���� DATATYPE�� ���� ���� �� �� �ϴ�.
--  ���̺��� ������ �÷��� DATATYPE�� ���� �� ��� ���α׷��� ������� �ʿ䰡 ����.
------------------------------------------------------------------------------------
-- �ൿ���� : �μ���ȣ �Է� �ش� emp ����  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(75);
--  ��ȸȭ�� :    ���    : 5555
--                �̸�    : ȫ�浿
-- %ROWTYPE�� �̿��ϴ� ���
CREATE OR REPLACE PROCEDURE DeptEmpSearch2
    (p_deptno IN emp.deptno%TYPE)
IS
    v_emp emp%ROWTYPE;
--    v_empno emp.empno%TYPE;
--    v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT * -- * �� 1���� ����Ѵ�. deptno�� 10�� ���� ������ �̹Ƿ� �����߻� - ����ó�� �ʿ�
    INTO   v_emp
    FROM   emp
    WHERE  deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('��� : ' || v_emp.empno); -- ���� ���̺� v_emp�� empno
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || v_emp.ename);
END DeptEmpSearch2;


---------------------------------------------------------
-- �ൿ���� : �μ���ȣ �Է� �ش� emp ����  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(75);
--  ��ȸȭ�� :    ���    : 5555
--                �̸�    : ȫ�浿
-- %ROWTYPE�� �̿��ϴ� ���
-- EXCEPTION �̿��ϴ� ���
CREATE OR REPLACE PROCEDURE DeptEmpSearch3
    (p_deptno IN emp.deptno%TYPE)
IS
    v_emp emp%ROWTYPE;
--    v_empno emp.empno%TYPE;
--    v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT * -- * �� 1���� ����Ѵ�. deptno�� 10�� ���� ������ �̹Ƿ� �����߻� - ����ó�� �ʿ�
    INTO   v_emp
--    SELECT empno, ename  
--    INTO   v_emp.empno, v_emp.ename -- empno, ename�� ������ �ǵ��� �̷�������
    FROM   emp
    WHERE  deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('��� : ' || v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || v_emp.ename);
    EXCEPTION -- Multi Row Error --> ���� ������ �䱸�� �ͺ��� ���� ���� ���� ����
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : '  || TO_CHAR(SQLCODE)); --������ �� �߾��δ�
            DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : '  || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : ' || SQLERRM);
END DeptEmpSearch3;

EXEC DeptEmpSearch3(10);
------------------------------------------------------------------------------------
---- cursor    *** �����̳� ������ ����
-- 1. ���� : Oracle Server�� SQL���� �����ϰ� ó���� ������ �����ϱ� ����
--          "Private SQL Area" �̶�� �ϴ� �۾������� �̿�
--           �� ������ �̸��� �ο��ϰ� ����� ������ ó���� �� �ְ� ���ִµ� �̸� CURSOR
-- 2. ���� : Implicit(��������) CURSOR -> DML���� SELECT���� ���� ���������� ����
--           Explicit(�������) CURSOR -> ����ڰ� �����ϰ� �̸��� �����ؼ� ���
-- 3. attribute
--   1) SQL%ROWCOUNT : ���� �ֱ��� SQL���� ���� ó���� Row ��
--   2) SQL%FOUND    : ���� �ֱ��� SQL���� ���� ó���� Row�� ������ �� �� �̻��̸� True
--   3) SQL%NOTFOUND : ���� �ֱ��� SQL���� ���� ó���� Row�� ������ ������ True
-- 4. 4�ܰ� **
--   1) DECLARE �ܰ� : Ŀ���� �̸��� �ο��ϰ� Ŀ�������� ������ SELECT���� ���������ν� CURSOR�� ����
--   2) OPEN �ܰ�    : OPEN���� �����Ǵ� ������ �����ϰ�, SELECT���� ����
--   3) FETCH �ܰ�   : CURSOR�κ��� Pointer�� �����ϴ� Record�� ���� ������ ����
--   4) CLOSE �ܰ�   : Record�� Active Set�� �ݾ� �ְ�, �ٽ� ���ο� Active Set������� OPEN�� �� �ְ� ����
------------------------------------------------------------------------------------
---------------------------------------------------------
-- EXECUTE ���� �̿��� �Լ��� �����մϴ�.
-- SQL>EXECUTE show_emp3(7900);
---------------------------------------------------------
    
CREATE OR REPLACE PROCEDURE show_emp3
    (p_empno IN emp.empno%TYPE)
IS   -- DECLARE��� �ᵵ �Ǵµ� IS�� ���� ����
    -- 1.DECLARE �ܰ�
    CURSOR emp_cursor IS
    SELECT ename, job, sal
    FROM   emp
    WHERE  empno LIKE p_empno||'%';
   
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
    v_job   emp.job%TYPE;
   
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- 2) OPEN �ܰ�
    OPEN emp_cursor; 
        DBMS_OUTPUT.PUT_LINE ( '�̸�   ' || '����' || '�޿�' );
        DBMS_OUTPUT.PUT_LINE ( '---------------------------' );
    LOOP
        -- 3) FETCH �ܰ�
        FETCH emp_cursor INTO  v_ename, v_job, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( v_ename || '   ' || v_job || '   ' || v_sal );
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE ( emp_cursor%ROWCOUNT || '���� �� ����.' );
    -- 4) CLOSE �ܰ�
    CLOSE emp_cursor;
END;

EXEC show_emp3(76);

--SELECT ename, job, sal
--FROM   emp
--WHERE  empno LIKE '76'||'%'; --���ڿ� % CONCAT  �Ϸ��� ''�� ���ڿ��������.
-----------------------------------------------------
-- Fetch �� *** ���迡�� fetch �� �߳��´�. for����
-- SQL> EXECUTE  Cur_sal_Hap (5);
-- CURSOR �� �̿� ���� 
-- �μ���ŭ �ݺ� 
-- 	�μ��� : ACCOUNTING
-- 	�ο��� : 5
-- 	�޿��� : 5000
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE Cur_sal_Hap
    (p_deptno IN emp.deptno%TYPE)
IS
    CURSOR dept_sum IS
        SELECT dname, COUNT(*) cnt, SUM(sal) sumSal
        FROM   emp e, dept d
        WHERE  e.deptno = d.deptno
        AND    e.deptno LIKE p_deptno||'%'
        GROUP BY dname;
    
    vdname  dept.dname%TYPE;
    vcnt    NUMBER;
    vsumSal NUMBER;
BEGIN
    DBMS_OUTPUT.ENABLE;
    OPEN dept_sum;
    LOOP
        FETCH dept_sum INTO vdname, vcnt, vsumSal;
        EXIT WHEN dept_sum%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('�μ��� : ' || vdname);
        DBMS_OUTPUT.PUT_LINE('�ο��� : ' || vcnt);
        DBMS_OUTPUT.PUT_LINE('�޿��� : ' || vsumSal);
    END LOOP;
    
    CLOSE dept_sum;
END Cur_sal_Hap;

EXEC Cur_sal_Hap(5);
--------------------------------------------------------------------------------        
-- FOR���� ����ϸ� Ŀ���� OPEN, FETCH, CLOSE�� �ڵ� �߻��ϹǷ� 
-- ���� ����� �ʿ䰡 ����, ���ڵ� �̸��� �ڵ�
-- ����ǹǷ� ���� ������ �ʿ䰡 ����. --�ǹ� ���̾���
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ForCursor_sal_Hap
IS
CURSOR dept_sum IS
        SELECT d.dname, COUNT(e.empno) cnt, SUM(e.sal) sumSal
        FROM   emp e, dept d
        WHERE  e.deptno = d.deptno
        GROUP BY d.dname;
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- CURSOR�� FOR������ �����Ų�� --> OPEN, FETCH, CLOSE�� �ڵ� �߻�
    FOR emp_list IN dept_sum -- emp_list <-- record : ���̺� �ο� ��ü�� ��Ƶ� �� �ִ� ����Ŭ ������Ÿ��
--    FOR emp_list IN (SELECT d.dname, COUNT(e.empno) cnt, SUM(e.sal) sumSal 
--                     FROM   emp e, dept d
--                     WHERE  e.deptno = d.deptno
--                     GROUP BY d.dname) -- CURSOR �������� �ʰ� CURSOR�ڸ��� SELECT���� SUBQUERY�� �ִ� ���
    LOOP                     
        DBMS_OUTPUT.PUT_LINE('�μ��� : ' || emp_list.dname);
        DBMS_OUTPUT.PUT_LINE('�ο��� : ' || emp_list.cnt);
        DBMS_OUTPUT.PUT_LINE('�޿��� : ' || emp_list.sumSal);
    END LOOP;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM || '���� �߻�');
END;

EXEC ForCursor_sal_Hap;
--------------------------------------------------------------------------------
-- EXCEPTION
-- ����Ŭ PL/SQL�� ���� �Ͼ�� ��� ���ܸ� �̸� ������ ��������, 
-- �̷��� ���ܴ� �����ڰ� ���� ������ �ʿ䰡 ����.
-- �̸� ���ǵ� ������ ����
-- NO_DATA_FOUND    : SELECT���� �ƹ��� ������ ���� ��ȯ���� ���� ��
-- DUP_VAL_ON_INDEX : UNIQUE ������ ���� �÷��� �ߺ��Ǵ� ������ INSERT �� ��
-- ZERO_DIVIDE      : 0���� ���� ��
-- INVALID_CURSOR   : �߸��� Ŀ�� ����
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PreException
    (v_deptno IN emp.deptno%TYPE)
IS
    v_emp emp%ROWTYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    
    SELECT empno, ename, deptno  --�������� ������̶� ������ ����.
    INTO   v_emp.empno, v_emp.ename, v_emp.deptno
    FROM   emp
    WHERE  deptno = v_deptno;
    
    DBMS_OUTPUT.PUT_LINE('��� : '     || v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('�̸� : '     || v_emp.ename);
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : ' || v_emp.deptno);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('�ߺ� �����Ͱ� �����մϴ�.');
            DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX ���� �߻�');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS���� �߻�');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND���� �߻�');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�');
END;

--------------------------------------------------------------------------------
----   Procedure : in_emp
----   Action    : emp Insert
----   1. Error ����
---      1) DUP_VAL_ON_INDEX   : PreDefined --> Oracle ���� Error
---      2) User Defined Error : lowsal_err (�����޿� -> 1500)
-- ename unique �������� �ɷ�����
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE in_emp
    (p_name IN emp.ename%TYPE,  -- 1) DUP_VAL_ON_INDEX
     p_sal  IN emp.sal%TYPE,    -- 2) ������ Defined Error : lowsal_err (�����޿� -> 1500)
     p_job  IN emp.job%TYPE
     )
IS
    v_empno    emp.empno%TYPE;
    lowsal_err EXCEPTION; -- ������ Defined Error  - lowsal_err�� EXCEPTION ��ü�� ����
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT MAX(empno) + 1
    INTO   v_empno
    FROM   emp;
    
    IF p_sal >= 1500 THEN
        INSERT INTO emp(empno,   ename,  sal,   job,   deptno, hiredate)
        VALUES         (v_empno, p_name, p_sal, p_job, 10,     SYSDATE);
    ELSE
        RAISE lowsal_err; -- Block�� RAISE���� �Ἥ ��������� EXCEPTION�� �߻���Ű�� ���
                          -- BEGIN Section���� EXCEPTION�� �߻��ϸ� EXCEPTION Section��
                          -- �ش� EXCEPTION ó���η� ��� �Ѿ��.
    END IF;
    
    EXCEPTION
        -- Oracle PreDefined Error
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('�ߺ� ������ ename �����մϴ�.');
            DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX ���� �߻�');
        -- ������ Defined Error
        WHEN lowsal_err THEN
            DBMS_OUTPUT.PUT_LINE('ERROR!!! = ������ �޿��� �ʹ� �����ϴ�. 1500�̻����� �ٽ� �Է��ϼ���.');
            
END in_emp;

EXEC in_emp('������', 7000, '�屺');
EXEC in_emp('������', 3000, 'ȭ��');
EXEC in_emp('������', 1300, '�屺');

--------------------------------------------------------------------------------
--  20220817 HW1
-- 1. �Ķ��Ÿ : (p_empno, p_ename  , p_job,p_MGR ,p_sal,p_DEPTNO )
-- 2. emp TBL��  Insert_emp Procedure 
-- 3. v_job =  'MANAGER' -> v_comm  := 1000;
--              �ƴϸ�                 150; 
-- 4. Insert -> emp 
-- 5. �Ի����� ��������
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Insert_emp
    (p_empno  IN emp.empno%TYPE,
     p_ename  IN emp.ename%TYPE,
     p_job    IN emp.job%TYPE,
     p_mgr    IN emp.mgr%TYPE,
     p_sal    IN emp.sal%TYPE,
     p_deptno IN emp.deptno%TYPE)
IS
    v_comm emp.comm%TYPE;
BEGIN
    
    IF   p_job = 'MANAGER' THEN v_comm := 1000;
    ELSE                        v_comm := 150;
    END IF;
    
    INSERT INTO emp (empno,   ename,   job,   mgr,   hiredate, sal,   comm,   deptno)
             VALUES (p_empno, p_ename, p_job, p_mgr, SYSDATE,  p_sal, v_comm, p_deptno);
    COMMIT;
END;        
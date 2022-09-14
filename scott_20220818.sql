---------------------------------------------------------------------------------------
-----    Package
-- ���� ����ϴ� ���α׷��� ������ ���ȭ
-- ���� ���α׷��� ���� ���� �� �� ����
-- ���α׷��� ó�� �帧�� �������� �ʾ� ���� ����� ����
-- ���α׷��� ���� �������� �۾��� ��
-- ���� �̸��� ���ν����� �Լ��� ���� �� ����
----------------------------------------------------------------------------------------

--- 1.Header -->  ���� : ���� (Interface ����) --�������� ��������ϰ� �״����� �ٵ�
--    ���� PROCEDURE ���� ����
CREATE OR REPLACE PACKAGE emp_info AS
    PROCEDURE all_emp_info;  -- ��� ����� ��� ����
    PROCEDURE all_sal_info;  -- �μ��� �޿� ����
    -- Ư�� �μ��� ��� ����
    PROCEDURE dept_emp_info (p_deptno IN emp.deptno%TYPE); -- �Ķ���� Ÿ��(emp.deptno%TYPE) BODY �����ο� ��ġ�ؾ���.
    
END emp_info;

-- 2.Body ���� : ���� ����
CREATE OR REPLACE PACKAGE BODY emp_info AS
-----------------------------------------------------------------
    -- ��� ����� ��� ����(���, �̸�, �Ի���)
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> ���� �� �ٲپ� ���,�̸�,�Ի��� 
-----------------------------------------------------------------
    PROCEDURE all_emp_info
    IS
    CURSOR emp_cursor IS
        SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD') hiredate
        FROM   emp
        ORDER BY hiredate;
    BEGIN
        DBMS_OUTPUT.ENABLE;
        FOR emp IN emp_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('��  �� : ' || emp.empno);
            DBMS_OUTPUT.PUT_LINE('��  �� : ' || emp.ename);
            DBMS_OUTPUT.PUT_LINE('�Ի��� : ' || emp.hiredate);
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '���� �߻�');
    END all_emp_info;

-----------------------------------------------------------------------------------------
    -- ��� ����� �μ��� �޿� ����
    -- 1. CURSOR  : empdept_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> ���� �� �ٲپ� �μ��� ,��ü�޿���� , �ִ�޿��ݾ� , �ּұ޿��ݾ�
----------------------------------------------------------------
    PROCEDURE all_sal_info
    IS
    CURSOR empdept_cursor IS
        SELECT d.dname dname, ROUND(AVG(e.sal), 3) avg_sal, MAX(e.sal) max_sal, MIN(e.sal) min_sal
        FROM   emp e, dept d
        WHERE  e.deptno = d.deptno
        GROUP BY d.dname;
    BEGIN
        DBMS_OUTPUT.ENABLE;
        FOR empdept IN empdept_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('��   ��   �� : ' || empdept.dname);
            DBMS_OUTPUT.PUT_LINE('��ü�޿���� : ' || empdept.avg_sal);
            DBMS_OUTPUT.PUT_LINE('�ִ�޿��ݾ� : ' || empdept.max_sal);
            DBMS_OUTPUT.PUT_LINE('�ּұ޿��ݾ� : ' || empdept.min_sal);
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '���� �߻�');
    END all_sal_info;
    
-----------------------------------------------------------------
    --Ư�� �μ��� �ش��ϴ� ��� ���� PROCEDURE dept_emp_info
    -- parameter(p_deptno)
    -- 1. CURSOR  : empindept_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> Ư�� �μ��� �ش��ϴ� ��� ���,�̸�, �Ի��� 
-----------------------------------------------------------------
    PROCEDURE dept_emp_info
        (p_deptno emp.deptno%TYPE)
    IS
    CURSOR empindept_cursor IS
        SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD') hiredate
        FROM   emp
        WHERE  deptno = p_deptno
        ORDER BY hiredate;
    BEGIN
        DBMS_OUTPUT.ENABLE;
        FOR empindept IN empindept_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('��  �� : ' || empindept.empno);
            DBMS_OUTPUT.PUT_LINE('��  �� : ' || empindept.ename);
            DBMS_OUTPUT.PUT_LINE('�Ի��� : ' || empindept.hiredate);
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '���� �߻�');
    END dept_emp_info;

END emp_info;

-- BODY �� PROCEDURE ����
EXEC emp_info.dept_emp_info(50);
SET SERVEROUTPUT ON; -- ��ũ��Ʈ��¿� DBMS_OUTPUT.PUT_LINE�� ����ϱ� ���� ���





-------------------------------------------------------------------------------------
--�����͸𵨸�  
--���� -> ����
--Entity -> table
--attribute -> column

-- CRUD ��Ʈ����(Matrix)
--  ���� : �ý��� ���� �� ���μ���(�Ǵ� �޼ҵ�, Ŭ����)�� DB �� ����Ǵ� ������ ������
--         Dependency �� ��Ÿ���� ���� Matrix
--  ���� ���μ����� �����Ͱ� ��� �м�ǥ���� ���� ���� ���μ�����,
--  ���� ��ƼƼ Ÿ������ �����Ǹ� ��� ���� ������ �������� �߻� �� �̿뿡 ����
--  ����(Create), �̿�(Read), ����(Update), ����(Delete) ���¸� ǥ��

--  �ۼ�
--    �� ���μ��� ���� ����ϴ� ��ƼƼ�� ǥ���ϰ�
--    ������ ���μ����� �ش� ��ƼƼ�� ����(C), ��ȸ(R), ����(U), ����(D)
--    �ϴ°��� ���� ���θ� ǥ��

-- ERD(Entity Relation Diagram)
-- master data, tansaction data �� ���� ����

-------------------------------------------------------------------------------------
-- ����ȭ(Normalization)  --�������
-- ���� : ������ ������ �𵨿��� �������� �ߺ����� �����Ͽ� �̻� ������ �����ϰ�
--        �������� �ϰ����� ��Ȯ���� �����ϱ� ���� ����

--�̻������� ����
--  1. ���� �̻�
--   �� Ʃ���� ���������ν� �����ؾ� �� �������� �����Ǵ�
--   �������(triggered deletion) ������ �Ͼ�� �Ǿ� 
--   �����ս��� �߻��ϰ� �Ǵ� ����
--  2. ���� �̻�
--   � �����͸� �����Ϸ��� �� �� ���ʿ��ϰ� ������ �ʴ�
--   �����͵� �Բ� �����ؾ� �ϰ� �׷��� ������ ������ �����ʴ� ����
--  3. ���� �̻� 
--   �ߺ��� Ʃ�� �� �Ϻ� Ʃ���� ��Ʈ����Ʈ ������ �����Ͽ�
--   ������ ������� ����� ����

-- �Լ��� ���Ӽ��� ���� �� ����
--  1. �Լ��� ���Ӽ�(FD: Functional Dependency)�� ����
--      �����͵��� � ���� ���� ���� ���ӵǴ� ������ ��Ī
--      ���� ���� ������(determinant), ���ӵǴ� ���� ������/������ (dependent)
--      �κ� �Լ� ���Ӽ�(partial functional dependency)�� �� �� �Ǵ� �� �̻��� �Ӽ���
--      Primary key(PK) �� �Ϻκп� �Լ������� �����ϴ� ��
--  2. �Լ��� ���Ӽ��� ���
--       �̸�, �ּ�, ������ �ֹε�� ��ȣ �Ӽ��� ���ӵ�
--       ǥ���: �ֹε�Ϲ�ȣ �� [�̸�, �ּ�, ����]
--  ���Ӱ��� Ȯ���Ҷ� ���� �ڵ� -> �̸� 

-- �Լ����ӵ�(�Ͻ�Ʈ���� �Լ����ӱ�Ģ)
--��. �Լ��� ���Ӽ��� �߷б�Ģ
--  1) �Ͻ�Ʈ���� �߷� ��Ģ��
--    1. �ݻ� ��Ģ (��ͱ�Ģ) : �κ�����(��, ��)�� ����(Subset Property) // Y �� X�̸�, X �� Y�̴�.
--    2. ÷��(Augmentation) ��Ģ : ���� 
--          X �� Y�̸�, XZ �� YZ�̴�. (ǥ��: XZ�� X��Z�� �ǹ�)
--    3. ����(Transitivity) ��Ģ :
--          X �� Y�̰� Y �� Z�̸�, X �� Z�̴�.
--- A1, A2, A3�� Sound�ϰ� Complete �߷� ��Ģ ������ �����Ѵ�.
--- ������ Ư��: A1, A2, A3�κ��� ������ ��� �Լ��� ���Ӽ��� ��� �����̼� ���¿� ���� ������.
--  2) �߰������� ������ ������ �߷� ��Ģ��
--    4. ����(Decomposition) ��Ģ : 
--          X �� YZ�̸�, X �� Y�̰� X �� Z�̴�.
--    5. ����(Union) ��Ģ : ���� 
--          X �� Y�̰� X �� Z�̸�, X �� YZ�̴�.
--    6. �ǻ�����(Pseudotransivity) ��Ģ : ������ 
--          X �� Y�̰� WY �� Z�̸�, WX �� Z�̴�.
--- ������ Ư��: ���� �� ��Ģ �� �ƴ϶� �ٸ� �߷� ��Ģ�鵵 A1, A2, A3�����κ��� �߷� �����ϴ�.


--����ȭ(Normalization)�� ���� -- ���� 3������ ��.
--  ������ ����ȭ
--   1�� ����ȭ(1NF)
--     �ݺ��Ǵ� �Ӽ� ���� (PK����)
--     Relation R�� ���� ��� �������� ���ڰ�(atomicvalue)������ �Ǿ��ִ� ��� 
--   2�� ����ȭ(2NF)
--     �κ��Լ� ���Ӽ� ����
--     Relation R�� 1NF�̰� Relation�� �⺻ Ű�� �ƴ� �Ӽ����� �⺻ Ű�� ������ �Լ������� ������ ���
--     ����Ű�� ������ 2�� ����ȭ ����
--   3�� ����ȭ(3NF)
--     �����Լ� ���Ӽ� ����
--     Relation R�� 2NF�̰� �⺻ Ű�� �ƴ� ��� �Ӽ����� �⺻ Ű�� ���Ͽ� ������ �Լ� ���Ӽ�(Transitive FD)��
--     ���踦 ������ �ʴ� ���, �� �⺻ Ű ���� �Ӽ��鰣�� �Լ��� �������� ������ �ʴ� ���
--   BCNF(Boyce/CoddNF)
--     �������Լ� ���Ӽ� ����
--     Relation R�� ��� �����ڰ� �ĺ� Ű�� ���
--   4�� ����ȭ(4NF)
--?    ���߰� ���Ӽ� ����
--?    BCNF�� ������Ű�鼭 ���߰� ������ �������� �ʴ� ���
 
 
-- ���� ��� -������ Ǯ���������
-- ������ DB ���� �� ���̺�Ű��(R)�� �Լ����Ӽ�(FD)�� �Ʒ��� ���� �� ������ ���Ͻÿ�.
-- R(A, B, C, D, E, F, G, H, I)
-- FD : A -> B, A -> C, D -> E, AD -> I, D -> F, F -> G, AD -> H
-- 1) �Լ����ӵ�ǥ(FDD : Functional Dependency Diagram) �ۼ�
-- 2) ��Ű�� R(A, B, C, D, E, F, G, H, I)���� Key ���� ã�Ƴ��� �� ���� ����
-- 3) 2�� ������ ���̺� ����, �� ���̺��� Key �� ���
-- 4) 3�� ������ ���̺� ����, �� ���̺��� Key �� ���

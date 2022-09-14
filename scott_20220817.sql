SELECT * FROM emp;

-- 3. scott�� �ִ� student TBL�� Read ���� usertest04 �ּ���
GRANT SELECT ON scott.student TO usertest04;

-- 2-3.��SELECT ���� �ο� ������ ���� �ο� , WITH GRANT OPTION --> �ϰ� �ض� ���� �ο�
GRANT SELECT ON scott.emp TO usertest04 WITH GRANT OPTION;
 
-- 2-3.��SELECT ���� �ο� ������ ���� �ο� , WITH GRANT OPTION --> �ϰ� �ض� ���� �ο�
GRANT SELECT ON scott.dept TO usertest04 WITH GRANT OPTION;

---------------------------------------------------
---  ���� ȸ��
---------------------------------------------------

-- 1. ���� ���� �� �����ƴϸ� ���� ȸ�� �� ��
REVOKE SELECT ON scott.emp FROM usertest02;

-- ���� ���� �� �������� ���� ���� ȸ���� ���� ���ѵ� ��� ȸ�� ��
REVOKE SELECT ON scott.emp FROM usertest04; -- usertest04�� DBA������ ������


-----------------------------------------------------------------------
-- ���Ǿ�(synonym)
-- 1. ���� : �ϳ��� ��ü�� ���� �ٸ� �̸��� �����ϴ� ���
--   ���Ǿ�� ����(Alias) ������
--    ���Ǿ�� �����ͺ��̽� ��ü���� ���
--    ������ �ش� SQL ��ɹ������� ���
-- 2. ����
--   1) ���� ���Ǿ�(private synonym) 
--      ��ü�� ���� ���� ������ �ο� ���� ����ڰ� ������ ���Ǿ�� �ش� ����ڸ� ���
--
--   2) ���� ���Ǿ�(public synonym)
--      ������ �ִ� ����ڰ� ������ ���Ǿ�� ������ ���
--      DBA ������ ���� ����ڸ� ���� (�� : ������ ��ųʸ�)
--
-- �׳� �����
--Create (Public )Synonym ���� Rule
--1.  �ٸ� ������ Object �� ���ؼ���
--    ���� �̸��� Public , Private Synonym ���� ����, �� �� Private Synonym �� Public Synonym �� �켱 �Ѵ�.     
--2. �ڽ��� Object �� ���ؼ��� ���� �̸��� Public Synonym �� ���� ����,
--    Private Synonym �� ���� �Ұ� ( Owner ������ Object Name �� Unique �ؾ��� )      
--3. �ڽ��� Object �� ���ؼ��� �ٸ� �̸��� Public Synonym / Private Synonym ��� ���� ����     
-----------------------------------------------------------------------



------------------------------------------------------------------------------------------------------
------- Trigger 
-- 1. ���� : � ����� �߻����� �� ���������� ����ǵ��� �����ͺ��̽��� ����� ���ν���
--           Ʈ���Ű� ����Ǿ�� �� �̺�Ʈ �߻��� �ڵ����� ����Ǵ� ���ν���
--    - Ʈ���Ÿ� ���(Triggering Event)
--           ����Ŭ DML ���� INSERT, DELETE, UPDATE�� ����Ǹ� �ڵ����� ����
-- 2. ����Ŭ Ʈ���� ��� ����
--   1) �����ͺ��̽� ���̺� �����ϴ� �������� ���� ���Ἲ�� ������ ���Ἲ ���� ������ ���� ���� �����ϴ� ���
--       ��쿡���� �����Ҽ��ִ�.(DB ������ϸ� TRIGGER�� DISABLE���°� �ǹǷ�)
--   2) �����ͺ��̽� ���̺��� �����Ϳ� ����� �۾��� ����, ���� 
--   3) �����ͺ��̽� ���̺� ����� ��ȭ�� ���� �ʿ��� �ٸ� ���α׷��� �����ϴ� ��� 
--   4) ���ʿ��� Ʈ������� �����ϱ� ���� 
--   5) �÷��� ���� �ڵ����� �����ǵ��� �ϴ� ��� 
------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :old.dname);
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :new.dname);
END;


UPDATE dept
SET    dname = 'ȸ��2��'
WHERE  deptno = 72;
COMMIT;


----------------------------------------------------------
--HW2 ) emp Table�� �޿��� ��ȭ��
--       ȭ�鿡 ����ϴ� Trigger �ۼ�( emp_sal_change)
--       emp Table ������
--      ���� : �Է½ô� empno�� 0���� Ŀ����

--��°�� ����
--     �����޿�  : 10000
--     ��  �޿�  : 15000
 --    �޿� ���� :  5000
----------------------------------------------------------
CREATE OR REPLACE TRIGGER emp_sal_change
BEFORE
UPDATE OR DELETE OR INSERT ON emp
FOR EACH ROW
    WHEN (new.empno > 0)
    DECLARE
        sal_diff NUMBER;
BEGIN
    sal_diff := :new.sal - :old.sal;
    DBMS_OUTPUT.PUT_LINE('���� �޿�  : ' || :old.sal);
    DBMS_OUTPUT.PUT_LINE('��   �޿�  : ' || :new.sal);
    DBMS_OUTPUT.PUT_LINE('�޿� ���� : ' || sal_diff);  
END;

UPDATE emp
SET    sal = 1500
WHERE  empno = 7369;


-- ���� Ǭ��� -empno���� sal >0 ������ �ɰ� �غ�
CREATE OR REPLACE TRIGGER emp_sal_change2
BEFORE
UPDATE ON emp
FOR EACH ROW
BEGIN
    IF :new.sal > 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� �޿�  : ' || :old.sal);
        DBMS_OUTPUT.PUT_LINE('��   �޿�  : ' || :new.sal);
        DBMS_OUTPUT.PUT_LINE('�޿� ���� : ' || (:new.sal - :old.sal));
    ELSE
        DBMS_OUTPUT.PUT_LINE('�޿��� 0���� Ŀ���մϴ�. �ٽ� �Է����ּ���');
        RAISE_APPLICATION_ERROR(-20001,'�޿��� 0���� Ŀ���մϴ�.');
    END IF;
END;

UPDATE emp
SET    sal = 0
WHERE  empno = 0;

-----------------------------------------------------------
--  EMP ���̺� INSERT,UPDATE,DELETE������ �Ϸ翡 �� ���� ROW�� �߻��Ǵ��� ����
--  ���� ������ EMP_ROW_AUDIT�� 
--  ID ,����� �̸�, �۾� ����,�۾� ���ڽð��� �����ϴ� 
--  Ʈ���Ÿ� �ۼ�
-----------------------------------------------------------
-- 1.SEQUENCE
--DROP SEQUENCE emp_row_seq;
CREATE SEQUENCE emp_row_seq;
-- 2. Audit Table
--DROP TABLE emp_row_audit;
CREATE TABLE emp_row_audit(
    e_id    NUMBER(6) CONSTRAINT emp_row_pk PRIMARY KEY,
    e_newname VARCHAR2(30),
    e_oldname VARCHAR2(30),
    e_newsal  NUMBER(7, 2),
    e_oldsal  NUMBER(7, 2),
    e_gubun   VARCHAR2(10),
    e_date    DATE
);
-- 3. Trigger
CREATE OR REPLACE TRIGGER emp_row_aud3
AFTER INSERT OR UPDATE OR DELETE ON emp
FOR EACH ROW
BEGIN
    IF    INSERTING THEN
        INSERT INTO emp_row_audit(e_id, e_newname,  e_newsal, e_gubun,     e_date)
            VALUES(emp_row_seq.NEXTVAL, :new.ename, :new.sal, 'inserting', SYSDATE);
    ELSIF UPDATING  THEN
        INSERT INTO emp_row_audit(e_id, e_newname,  e_oldname,  e_newsal, e_oldsal, e_gubun,     e_date)
            VALUES(emp_row_seq.NEXTVAL, :new.ename, :old.ename, :new.sal, :old.sal, 'updating' , SYSDATE);
    ELSIF DELETING  THEN
        INSERT INTO emp_row_audit(e_id, e_oldname,  e_oldsal, e_gubun,     e_date)
            VALUES(emp_row_seq.NEXTVAL, :old.ename, :old.sal, 'deleting' , SYSDATE);
    END IF;
END;

INSERT INTO emp(empno, ename, sal, deptno)
    VALUES(3500, '������', 3500, 50);
INSERT INTO emp(empno, ename, sal, deptno)
    VALUES(3600, '������', 3500, 50);
    
UPDATE emp
SET    ename = '����', sal = 3000
WHERE  empno = 3600;

DELETE emp
WHERE  empno = 9999;
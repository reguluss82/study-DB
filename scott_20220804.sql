SELECT * FROM emp;

--PROCEDURE
--�ǹ����� DML�۾��� ���� ����.
--�Ϸ��� ������ ��ġ �ϳ��� �Լ�ó�� �����ϱ� ���� ������ �����̸�
--�Ϸ��� �۾��� ������ �����Դϴ�.
--���� �ܵ����� �����ؾ� �� �۾��� ���ӹ޾��� �� ����մϴ�.
--������� ��ȯ�ϰų� ��ȯ���� ���� �� �ִ�.
--�Ű������� �Է�,���,����� �������� ���� �� �ֽ��ϴ�.
--IN/OUT �Ű������� �ִ� ���ν���
-- IN �Ű����� : ���ν��� ���ο��� ���� ����
-- OUT �Ű����� : ���ν��� ȣ���(�ܺ�)���� ���� ���� ����� ����
--Ŭ���̾�Ʈ(ȭ��)���� ���� �ǳ׹޾� �������� �۾��� �� �� Ŭ���̾�Ʈ���� �����մϴ�.
--��, �������� ������ �Ǿ� �ӵ��鿡�� ���� ������ �����ݴϴ�.

CREATE OR REPLACE PROCEDURE Dept_Insert --OR REPLACE ������ ����� ������ ��ü�϶�
 (vdeptno IN dept.deptno%TYPE, --�� ���̺� Į���� Ÿ���� ���󰡰ڴ�
  vdname  IN dept.dname%TYPE,
  vloc    IN dept.loc%TYPE)
IS 
 -- ������
BEGIN
    INSERT INTO dept VALUES(vdeptno, vdname, vloc); -- ���� ���� �ִ� �࿡ �����ϸ� ����
    COMMIT;
END;


CREATE OR REPLACE PROCEDURE Emp_Info2
(p_empno IN emp.empno%TYPE,
 p_ename OUT emp.ename%TYPE,
 p_sal   OUT emp.sal%TYPE )
IS
    --%TYPE �������� ���� ����
  v_empno emp.empno%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- %TYPE �������� ���� ���
    SELECT empno, ename, sal
    INTO   v_empno, p_ename, p_sal
    FROM   emp
    WHERE  empno = p_empno;
    -- ����� ��� --chr(10) ASKII code��
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_empno || CHR(10) || CHR(13) || '�ٹٲ�');
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || p_ename);
    DBMS_OUTPUT.PUT_LINE('����޿� : ' || p_sal );
END;

--Function
--�ǹ����� ������ ��꿡 ����� ������.
--�ϳ��� Ư���� ������ �۾��� �����ϱ� ���� ���������� ����� �ڵ��� �����Դϴ�.
--��, �Լ��� ���� �۾��� ���� ����̶�� ���ν����� �۾��� ������ �����Դϴ�.
--���� ������ �����ִ� �����̸�, ������ ���, ��ġ ���� ��Ÿ�� �� ����մϴ�.
--���ν����� �ٸ��� OUT ������ ������� �ʾƵ� ���� ����� �ǵ��� ���� �� �ִ�.(RETURN)
--�Ű������� �Է� �������θ� ���� �� �ֽ��ϴ�.
--Ŭ���̾�Ʈ(ȭ��)���� ���� �ǳ� �ް� �������� �ʿ��� ���� �����ͼ� Ŭ���̾�Ʈ���� �۾��� �ϰ� ��ȯ�մϴ�.
--��, Ŭ���̾�Ʈ(ȭ��)���� ������ �Ǿ� ���ν������� �ӵ��� �����ϴ�.

CREATE OR REPLACE FUNCTION func_sal --  FUNCTION�� ���ϰ� �ݵ�� ������ �ݵ�� �ϳ���.
    (p_empno IN NUMBER)
RETURN NUMBER
IS
    vsal emp.sal%TYPE; -- emp table�� sal�� ���� Ÿ��
BEGIN
    UPDATE emp SET sal=sal*1.1
    WHERE empno=p_empno;
    COMMIT;
    SELECT sal INTO vsal --��ȸ�� �����Ϸ��� INTO ���
    FROM emp
    WHERE empno=p_empno;
    RETURN vsal;
END;



SELECT func_sal(7902) FROM dual; --����. �����Ϸ��� �����.�ϴ� eclipse��
      
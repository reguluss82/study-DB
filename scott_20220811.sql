---------------------------------------------------------------------------------------------
---- MERGE
-- 1. MERGE ����
--  ������ ���� �ΰ��� ���̺��� ���Ͽ� �ϳ��� ���̺�� ��ġ�� ���� ������ ���۾�
--  WHEN ���� ���������� ��� ���̺� �ش� ���� �����ϸ� UPDATE ��ɹ��� ���� ���ο� ������ ����,
--  �׷��� ������ INSERT ��ɹ����� ���ο� ���� ����
---------------------------------------------------------------------------------------------

-- 1] MERGE �����۾�
--  ��Ȳ 
-- 1) ������ �������� 2�� Update
-- 2) �赵�� ���� �ű� Insert

CREATE TABLE professor_temp
AS SELECT * FROM professor
WHERE  position = '����'; --CREATE DDL�̹Ƿ� AUTO COMMIT

UPDATE professor_temp
SET    position = '������'
WHERE  position = '����'; --UPDATE DML�̹Ƿ� COMMIT �������

INSERT INTO professor_temp
VALUES (9999,'�赵��', 'arom21', '���Ӱ���', 200, sysdate, 10, 101);

COMMIT;

-- 2] professor MERGE ����
-- ��ǥ : professor_temp�� �ִ� ���� ������ ������ professor Table�� UPDATE
--                  �赵�� ���� �ű� INSERT ������ professor Table�� INSERT
-- 1) ������ �������� 2�� Update
-- 2) �赵�� ���� �ű� Insert

MERGE INTO professor p
USING professor_temp f
ON   (p.profno = f.profno)
WHEN MATCHED THEN     --PK�� ������ ������ UPDATE
    UPDATE SET p.position = f.position
WHEN NOT MATCHED THEN --PK�� ������ �ű� INSERT
    INSERT VALUES (f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
    

---------------------------------------------------------------------------------------------
-- Ʈ����� ���� ***�ſ��߿��� ����
-- ������ �����ͺ��̽����� ����Ǵ� ���� ���� SQL��ɹ��� �ϳ��� ���� �۾� ������ ó���ϴ� ����
-- commit �� commmit ���� 

-- COMMIT   : Ʈ������� �������� ����
--            Ʈ����ǳ��� ��� SQL ��ɹ��� ���� ����� �۾� ������ ��ũ�� ���������� �����ϰ� Ʈ������� ����
--            �ش� Ʈ����ǿ� �Ҵ�� CPU, �޸� ���� �ڿ��� ����
--            ���� �ٸ� Ʈ������� �����ϴ� ����
--            COMMIT ��ɹ� �����ϱ� ���� �ϳ��� Ʈ����� ������ �����
--            �ٸ� Ʈ����ǿ��� ������ �� ������ �����Ͽ� �ϰ��� ���� <- ����

-- ROLLBACK : Ʈ������� ��ü ���
--            Ʈ����ǳ��� ��� SQL ��ɹ��� ���� ����� �۾� ������ ���� ����ϰ� Ʈ������� ����
--            CPU,�޸� ���� �ش� Ʈ����ǿ� �Ҵ�� �ڿ��� ����, Ʈ������� ���� ����
---------------------------------------------------------------------------------------------
--ACID ��������
--concurrent   ���α׷��� Ȥ�� �׷��� ���α׷����� �����Ϳ� ���� Ʈ�������� �����ϵ��� �����ϱ� ���ؼ� �����ؾ� �ϴ� Ư�������̴�. �����ͺ��̽� ������ Ʈ������� ��ǥ���� ���̴�.
--Atomicity   : ���ڼ�. Ʈ����ǰ� ���õ� ���� ��� ����Ǵ��� ��� ������� �ʵ��� �ϴ����� �����ϴ� Ư���̴�.
--Consistency : �ϰ���. Ʈ������� �����ߴٸ�, �����ͺ��̽��� �� �ϰ����� �����ؾ� �Ѵ�. �ϰ����� Ư���� ������ �ΰ�, �� ������ �����ϴ����� Ȯ���ϴ� ������� �˻��� �� �ִ�.
--Isolation   : ������. Ʈ������� �����ϴ� ���߿� �ٸ� �����۾��� ������� ���ϵ��� �Ѵ�. �Ӱ迵���� �δ� ������ �޼��� �� �ִ�.
--Durability  : ���Ӽ�. ���������� Ʈ������� ����Ǿ��ٸ�, �� ����� ������ �ݿ��� �Ǿ�� �Ѵ�. ������ �ݿ��Ǹ� �α׸� ����� �Ǵµ�, �Ŀ� �� �α׸� �̿��ؼ� Ʈ����� ������ ���·� �ǵ��� �� �־�� �Ѵ�. ������ Ʈ������� �α������� �Ϸ�� �������� ���ᰡ �Ǿ�� �Ѵ�.
---------------------------------------------------------------------------------------------

----------------------------------
-- SEQUENCE *** ���� ���δ�. ������Ʈ���� ���°� ����
-- ������ �ĺ���
-- �⺻ Ű ���� �ڵ����� �����ϱ� ���Ͽ� �Ϸù�ȣ ���� ��ü
-- ���� ���, �� �Խ��ǿ��� ���� ��ϵǴ� ������� ��ȣ�� �ϳ��� �Ҵ��Ͽ� �⺻Ű�� �����ϰ��� �Ҷ�
-- �������� ���ϰ� �̿�
-- ���� ���̺��� ���� ���� <- �Ϲ������δ� ������ ���
------ PK ������� : Ư����, Max, SEQUENCE �� ��������
-- ���ÿ� max���� �޾ƿ��� ��� conflict �߻� ���ɼ� 
-- SEQUENCE �� conflict �߻� ����. 
----------------------------------
-- 1) SEQUENCE ����
--CREATE SEQUENCE sequence
--[INCREMENT BY n]
--[START WITH n]
--[MAXVALUE n | NOMAXVALUE]
--[MINVALUE n | NOMINVALUE]
--[CYCLE | NOCYCLE]
--[CACHE n | NOCACHE];
--INCREMENT BY n    : ������ ��ȣ�� ����ġ�� �⺻�� 1,  �Ϲ������� ?1 ���
--START WITH n      : ������ ���۹�ȣ, �⺻���� 1
--MAXVALUE n        : ���� ������ �������� �ִ밪 --�� �������� �÷�����ϹǷ� �׳� �������ؼ� �ý��� �ִ밪���� ��
--MAXVALUE n        : ������ ��ȣ�� ��ȯ������ ����ϴ� cycle�� ������ ���, MAXVALUE�� ������ �� ���� �����ϴ� ��������
--CYCLE | NOCYCLE   : MAXVALUE �Ǵ� MINVALUE�� ������ �� �������� ��ȯ���� ������ ��ȣ�� ���� ���� ����
--CACHE n | NOCACHE : ������ ���� �ӵ� ������ ���� �޸𸮿� ĳ���ϴ� ������ ����, �⺻���� 20

-- 2) SEQUENCE sample ����1
CREATE SEQUENCE sample_seq
INCREMENT BY 1
START WITH   1;

SELECT sample_seq.NEXTVAL FROM dual;
SELECT sample_seq.CURRVAL FROM dual;

-- 3) SEQUENCE sample ����2 --> �� ��� ����
CREATE SEQUENCE dept_dno_seq
INCREMENT BY 1
START WITH   76;

-- 4) SEQUENCE dno_seq�� �̿� dept_second �Է� --> �� ��� ����
INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, 'Accounting', 'NEW YORK');
SELECT dept_dno_seq.CURRVAL FROM dual;

INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, 'ȸ��', '�̴�');
SELECT dept_dno_seq.CURRVAL FROM dual;

INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, '�λ���', '���');

-- MAX ��ȯ  -- ���ÿ� max���� �޾ƿ��� ��� conflict �߻� ���ɼ� commit���ѻ��¿��� �ٸ������ ���� max���� ����
                --SEQUENCE �� conflict �߻� ����. 
INSERT INTO dept_second
VALUES((SELECT MAX(deptno) + 1  FROM dept_second)
        , '�濵��'
        , '�븲'
        );
        

-- 5) SEQUENCE ����
DROP SEQUENCE sample_seq;

-- 6) DATA �������� ���� ��ȸ
SELECT sequence_name, min_value, max_value, increment_by
FROM   user_sequences;

---------------------------------------------------------
----                   TABLE ����                    ----
---------------------------------------------------------
-- 1. TABLE ����
CREATE TABLE address
( id    NUMBER(3),
  name  VARCHAR2(50),
  addr  VARCHAR2(100),
  phone VARCHAR2(30),
  email VARCHAR2(100)
);
INSERT INTO address
VALUES(1,'HGDONG','SEOUL','123-4567','gbhong@naver.com');

---    Homework

-- ��1) address��Ű��/Data �����ϸ�     addr_second Table ���� 
CREATE TABLE     addr_second (id, name, addr, phone, email) --Į�� ����صθ� ���������鿡�� ������
AS SELECT * FROM address;

-- ��2) address��Ű�� �����ϸ�  Data ���� ���� �ʰ�   addr_seven Table ���� 
CREATE TABLE     addr_seven (id, name, addr, phone, email)
AS SELECT * FROM address
WHERE            1 = 0;

-- ��3) address(�ּҷ�) ���̺��� id, name Į���� �����Ͽ� addr_third ���̺��� �����Ͽ���
CREATE TABLE addr_third
AS SELECT    id, name
FROM         address;

-- ��4) addr_second ���̺� �� addr_tmp�� �̸��� ���� �Ͻÿ�
RENAME addr_second TO addr_tmp;

---------------------------------------------------------
----                   ������ ����                    ----
-- ����ڿ� �����ͺ��̽� �ڿ��� ȿ�������� �����ϱ� ���� �پ��� ������ �����ϴ� �ý��� ���̺��� ����
-- ���� ������ ������ ����Ŭ ������ ����
-- ����Ŭ ������ ����Ÿ���̽��� ����, ����, ����� ����, ������ ���� ���� ������ �ݿ��ϱ� ����
-- ������ ���� �� ����
-- ����Ÿ���̽� �����ڳ� �Ϲ� ����ڴ� �б� ���� �信 ���� ������ ������ ������ ��ȸ�� ����
-- �ǹ������� ���̺�, Į��, �� ��� ���� ������ ��ȸ�ϱ� ���� ���

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------   ������ ���� ���� ����   
-- 1. �����ͺ��̽��� ������ ������ ��ü�� ���� ����
-- 2. ����Ŭ ����� �̸��� ��Ű�� ��ü �̸�
-- 3. ����ڿ��� �ο��� ���� ���Ѱ� ��
-- 4. ���Ἲ �������ǿ� ���� ����
-- 5. Į������ ������ �⺻��
-- 6. ��Ű�� ��ü�� �Ҵ�� ������ ũ��� ��� ���� ������ ũ�� ����
-- 7. ��ü ���� �� ���ſ� ���� ���� ����
-- 8. �����ͺ��̽� �̸�, ����, ������¥, ���۸��, �ν��Ͻ� �̸� ����
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------   ������ ���� ���� --�ϱ�x ����o
-- 1. USER_ : ��ü�� �����ڸ� ���� ������ ������ ���� ��
-- user_tables�� ����ڰ� ������ ���̺� ���� ������ ��ȸ�� �� �ִ� ������ ���� ���̴�.
SELECT table_name
FROM   user_tables;

SELECT *
FROM   user_catalog;

-- 2. ALL_  : �ڱ� ���� �Ǵ� ������ �ο� ���� ��ü�� ���� ������ ������ ���� ��
SELECT owner, table_name
FROM   all_tables;

-- 3. DBA_  : �����ͺ��̽� �����ڸ� ���� ������ ������ ���� ��
SELECT owner, table_name
FROM   dba_tables;
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
------------         ��������(Constraint)   *** �߿�! ������Ʈ-- ���� �Է��� �� �ȵǴ� ��� ���������� Ȯ���ض�  -----
-- ���� : �������� ��Ȯ���� �ϰ����� ����
-- 1. ���̺� ������ ���Ἲ ���������� ���� ����
-- 2. ���̺� ���� ����, ������ ��ųʸ��� ����ǹǷ� ���� ���α׷����� �Էµ�
--    ��� �����Ϳ� ���� �����ϰ� ����
-- 3. ���������� Ȱ��ȭ, ��Ȱ��ȭ �� �� �ִ� ���뼺
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
------------         ��������(Constraint)  ���� ***�������� ------------
-- 1. NOT NULL : ���� NULL�� ������ �� ����
-- 2. �⺻Ű(primary key) : UNIQUE + NOT NULL + �ּҼ� ���������� ������ ����
-- 3. ����Ű(foreign key) : ���̺��� ���� �ܷ� Ű ���踦 �����ϰ� *** �߿� RDB
-- 4. CHECK : �ش� Į���� ���� ������ ������ ���� ������ ���� ����
-----------------------------------------------------------------------------------------
-- 1. ��������(Constraint) ���� ���� ����(subject) ���̺� �ν��Ͻ� ����
CREATE TABLE subject (
    subno     NUMBER(5)    CONSTRAINT subject_no_pk   PRIMARY KEY,
    subname   VARCHAR2(20) CONSTRAINT subject_name_nn NOT NULL,
    term      VARCHAR2(1)  CONSTRAINT subject_term_ck CHECK(term IN('1', '2')),
    typeGubun VARCHAR2(1)
);

COMMENT ON COLUMN subject.subno   IS '������ȣ';
COMMENT ON COLUMN subject.subname IS '������ȣ';
COMMENT ON COLUMN subject.term    IS '�б�';

INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10000, '��ǻ�Ͱ���', '1', '1');
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10001, 'DB����', '2', '1');            
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10002, 'JSP����', '1', '1');
            
--------------------------------------------------------------------------------          
-- PK CONSTRAINT --> UNIQUE
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10001, 'SPRING����', '1', '1');
--���� ���� -
--ORA-00001: unique constraint (SCOTT.SUBJECT_NO_PK) violated

-------------------------------------------------------------------------------- 
-- PK CONSTRAINT --> NN
INSERT INTO subject(subname, term, typegubun)
            VALUES('SPRING����2', '1', '1');
--���� ���� -
--ORA-01400: cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNO")

-------------------------------------------------------------------------------- 
-- subname NN
INSERT INTO subject(subno, term, typegubun)
            VALUES(10003, '1', '1');
--���� ���� -
--ORA-01400: cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNAME")

-------------------------------------------------------------------------------- 
-- Check Constraint  --> term
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10004, 'SPRING����3', '5', '1');
--���� ���� -
--ORA-02290: check constraint (SCOTT.SUBJECT_TERM_CK) violated

-------------------------------------------------------------------------------- 

-- TABLE ����� CONSTRAINT ���Ѱ��� ���� ���� ����
-- student Table �� idnum�� unique�� ����
ALTER TABLE student
ADD CONSTRAINT stud_idnum_uk UNIQUE(idnum);


-- idnum  --> OK
INSERT INTO student(studno, name, idnum)
            VALUES(30101, '������', '8012301036613');
            
-- idnum  --> unique constraint
INSERT INTO student(studno, name, idnum)
            VALUES(30102, '������', '8012301036613');
--���� ���� -
--ORA-00001: unique constraint (SCOTT.STUD_IDNUM_UK) violated


-- student Table �� name�� NN�� ����
ALTER TABLE student
MODIFY (name CONSTRAINT stud_name_nn NOT NULL);

-- name  --> NN constraint
INSERT INTO student(studno, idnum)
            VALUES(30103, '8012301036614');
--���� ���� -
--ORA-01400: cannot insert NULL into ("SCOTT"."STUDENT"."NAME")


-- CONSTRAINT ��ȸ
SELECT CONSTRAINT_name, CONSTRAINT_Type
FROM   user_CONSTRAINTs
WHERE  table_name IN('SUBJECT','STUDENT');




---------------------------------------------------------------
-----      INDEX    ***��������
-- �ε����� SQL ��ɹ��� ó�� �ӵ��� ���(*)��Ű�� ���� Į���� ���� �����ϴ� ��ü
-- �ε����� ����Ʈ�� �̿��Ͽ� ���̺� ����� �����͸� ���� �׼����ϱ� ���� �������� ���
-- �ǹ������� SELECT �� ������ �ſ� �߿��ϴ�. -I/D/U�� ���� ��ROW�� ó���ؼ� �߿䵵�� ������

-- Index�� RDBMS���� �˻� �ӵ��� ���̱� ���� ����̴�.
-- TABLE�� �÷��� ����ȭ(���� ���Ϸ� ����)�Ͽ� �˻��� �ش� TABLE�� ���ڵ带 Full Scan �ϴ°� 
-- �ƴ϶� ����ȭ �Ǿ��ִ� INDEX ������ �˻��Ͽ� �˻��ӵ��� ������ �Ѵ�.
-- RDBMS���� ����ϴ� INDEX�� B-Tree ���� �Ļ��� B+ Tree �� ����ؼ� ����ȭ�Ѵ�.
-- ���� SELECT ������ WHERE���̳� JOIN ���� ��������� �ε����� ���Ǹ�
-- SELECT ������ �˻� �ӵ��� ������ �ϴµ� ������ �ΰ� �ִ�.
-- DELETE, INSERT, UPDATE �������� �ش� �����̾����� INDEX ���� ������ ��������
-- ���ݴ� �ڼ��� �˾ƺ���, SQL�������� �������� ���ڵ�� ���������� �ƹ��� �������� ����ȴ�.
-- �̶� ������ ���念���� Heap�̶�� �Ѵ�.
-- Heap������ �ε����� ���� ���̺��� �����͸� ã�� ��
-- ��ü ������ �������� ó�� ���ڵ���� �� �������� ������ ���ڵ���� ��� ��ȸ�Ͽ� �˻����ǰ� ���ϰ� �ȴ�.
-- �̷��� ������ �˻������ ���̺� ��ĵ(Table Scan) �Ǵ� Ǯ ��ĵ(Full Scan)�̶�� �Ѵ�.
-- �̷� ��� ���� ���� ���̺��� �Ϻκ��� �����͸� �ҷ� �� �� Ǯ ��ĵ�� �ϸ� ó�� ������ ��������.
-- �� �ε����� �����͸� SELECT �� �� ���� ã�� ���� ���ȴ�

-- [1]�ε����� ����
-- 1)���� �ε��� : ������ ���� ������ �÷��� ���� �����ϴ� �ε����� ��� �ε��� Ű��
--                ���̺��� �ϳ��� ��� ���� --null����
        CREATE UNIQUE INDEX idx_dept_name
        ON     department(dname);
-- 2)����� �ε���
-- ��) �л� ���̺��� birthdate Į���� ����� �ε����� �����Ͽ���
 CREATE INDEX idx_stud_birthdate
 ON student(birthdate);
 
 --����� �ε��� birthdate --> CONSTRAINT X, ���ɿ��� ���� ��ħ
 INSERT INTO student(studno, name, idnum, birthdate)
            VALUES(30102, '������', '8012301036614', '82/06/06');
-- 3)���� �ε��� - ���� �÷�
-- 4)���� �ε��� : ���� �ε����� �� �� �̻��� Į���� �����Ͽ� �����ϴ� �ε���
--  ��) �л� ���̺��� deptno, grade Į���� ���� �ε����� ����
--      ���� �ε����� �̸��� idx_stud_dno_grade �� ����
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade);

SELECT *
FROM  student
WHERE deptno = 101
AND   grade  = 2;

--WHERE grade  = 2;   <-- index ������� �ؾ� ����� index����ȴ�.
--AND   deptno = 101   grade�� �ɷ��� ���ɻ� �̵��� ���ϱ� ��ƴ�



-- 5)�Լ� ��� �ε��� (Function Based Index)
-- ����Ŭ 8i �������� �����ϴ� ���ο� ������ �ε����� 
-- Į���� ���� �����̳� �Լ��� ��� ����� �ε����� ���� ����
-- UPPER(column_name) �Ǵ� LOWER(column_name) Ű����� ���ǵ�  
-- �Լ� ��� �ε����� ����ϸ� ��ҹ��� ���� ���� �˻�
CREATE INDEX uppercase_idx ON emp (UPPER(ename));

SELECT * FROM emp WHERE UPPER(ename) = 'KING';

-- [2]�ε����� ȿ������ ��� 
-- 1) WHERE ���̳� ���� ���������� ���� ���Ǵ� Į��
-- 2) ��ü �������߿��� 10~15%�̳��� �����͸� �˻��ϴ� ���
-- 3) �� �� �̻��� Į���� WHERE���̳� ���� ���ǿ��� ���� ���Ǵ� ���
-- 4) ���̺� ����� �������� ������ �幮 ���
-- 5) ���� �� ���� ���� ���Ե� ���, ���� �������� ���� ���ԵȰ��

---------------------------------------------------------------
--+-------+-PK INDEX �� ��������------------------+
--|       |       PK        |          INDEX       |
--+-------+-----------------+----------------------+
--|  ����  | Table �� ������ |    Performance ���  |
--|        |    Row����      |       ���� ��ü      |     
--+--------+----------------+----------------------+
--| Count  |        1       | 200�� �̻�(7�� �̳�)  |
--+--------+----------------+----------------------+
--|�������|     unique      |   Index ���� ����    |
--|       |         NN       |   SELECT �������    |
--|       |      �ּҼ�      |   I/D/U �����϶�     |
--+-------+-----------------+----------------------+


-- �л� ���̺� ������ PK_STUDNO �ε����� �籸��
ALTER INDEX PK_STUDNO REBUILD;

--�ε��� ������ ���� �� Insert, Update, Delete���� �ݺ��ϴٺ��� ������ ���ϵȴ�.
--������ �ε����� Ʈ�������� �����µ�, ����,����,�������� �������� �Ͼ�ٺ��� Ʈ���� ������ ���ſ��� ��ü������ Ʈ���� ���̰� ������� �����̴�.
--�̷��� �������� ���� �ε����� �˻��ӵ��� �������Ƿ� �ֱ������� �������ϴ� �۾��� ��ġ�°��� ����.
-- �۾��� ��ũŸ�� ���ؼ� , �����췯 ����ϸ� ���

-- 1. INDEX ��ȸ
SELECT index_name, table_name, column_name
FROM   user_ind_columns;


-- 2. INDEX ���� emp(job)
CREATE INDEX idx_emp_job ON emp(job);

-- 3. ��ȸ
SELECT * FROM emp WHERE job = 'MANAGER';         -- =           index OK
SELECT * FROM emp WHERE job <> 'MANAGER';        -- <>          index NO
SELECT * FROM emp WHERE job LIKE '%NA%';         -- LIKE '%NA%' index NO
SELECT * FROM emp WHERE UPPER(job) = 'MANAGER';  -- UPPER(job)  index NO <--�Լ����INDEX������� �ذ�

--- Optimizer
--- 1) RBO ��Ģ��� �״��  
--- 2) ��ȸ���� ���ɿ� ���� ����ȭ, CBO ���� ��κ� CBO�� default
-- RBO ����
ALTER SESSION SET OPTIMIZER_MODE = RULE;

-- SESSION �󿡼� �����Ҷ� 
 alter session set optimizer_mode=rule       --RBO
 alter session set optimizer_mode=CHOOSE     --RBO OR CBO
 alter session set optimizer_mode=FIRST_ROWS --CBO
 alter session set optimizer_mode=ALL_ROWS   --CBO

-- SQL Optimizer
SELECT /*+ first_rows */ ename From emp;
SELECT /*+ rule */ ename From emp;

--OPTIMIZER MODE Ȯ��
SELECT NAME, VALUE, ISDEFAULT, ISMODIFIED, DESCRIPTION
FROM V$SYSTEM_PARAMETER
WHERE NAME LIKE '%optimizer_mode%';
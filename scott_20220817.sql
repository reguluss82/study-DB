SELECT * FROM emp;

-- 3. scott에 있는 student TBL에 Read 권한 usertest04 주세요
GRANT SELECT ON scott.student TO usertest04;

-- 2-3.현SELECT 권한 부여 개발자 권한 부여 , WITH GRANT OPTION --> 니가 해라 권한 부여
GRANT SELECT ON scott.emp TO usertest04 WITH GRANT OPTION;
 
-- 2-3.현SELECT 권한 부여 개발자 권한 부여 , WITH GRANT OPTION --> 니가 해라 권한 부여
GRANT SELECT ON scott.dept TO usertest04 WITH GRANT OPTION;

---------------------------------------------------
---  권한 회수
---------------------------------------------------

-- 1. 원래 권한 준 계정아니면 권한 회수 안 됨
REVOKE SELECT ON scott.emp FROM usertest02;

-- 원래 권한 준 계정으로 부터 권한 회수후 관련 권한도 모두 회수 됨
REVOKE SELECT ON scott.emp FROM usertest04; -- usertest04에 DBA권한이 있으면


-----------------------------------------------------------------------
-- 동의어(synonym)
-- 1. 정의 : 하나의 객체에 대해 다른 이름을 정의하는 방법
--   동의어와 별명(Alias) 차이점
--    동의어는 데이터베이스 전체에서 사용
--    별명은 해당 SQL 명령문에서만 사용
-- 2. 종류
--   1) 전용 동의어(private synonym) 
--      객체에 대한 접근 권한을 부여 받은 사용자가 정의한 동의어로 해당 사용자만 사용
--
--   2) 공용 동의어(public synonym)
--      권한을 주는 사용자가 정의한 동의어로 누구나 사용
--      DBA 권한을 가진 사용자만 생성 (예 : 데이터 딕셔너리)
--
-- 그냥 참고용
--Create (Public )Synonym 관련 Rule
--1.  다른 유저의 Object 에 대해서는
--    동일 이름의 Public , Private Synonym 생성 가능, 이 때 Private Synonym 이 Public Synonym 에 우선 한다.     
--2. 자신의 Object 에 대해서는 동일 이름의 Public Synonym 은 생성 가능,
--    Private Synonym 은 생성 불가 ( Owner 내에서 Object Name 은 Unique 해야함 )      
--3. 자신의 Object 에 대해서는 다른 이름의 Public Synonym / Private Synonym 모두 생성 가능     
-----------------------------------------------------------------------



------------------------------------------------------------------------------------------------------
------- Trigger 
-- 1. 정의 : 어떤 사건이 발생했을 때 내부적으로 실행되도록 데이터베이스에 저장된 프로시저
--           트리거가 실행되어야 할 이벤트 발생시 자동으로 실행되는 프로시저
--    - 트리거링 사건(Triggering Event)
--           오라클 DML 문인 INSERT, DELETE, UPDATE이 실행되면 자동으로 실행
-- 2. 오라클 트리거 사용 범위
--   1) 데이터베이스 테이블 생성하는 과정에서 참조 무결성과 데이터 무결성 등의 복잡한 제약 조건 생성하는 경우
--       경우에따라서 위험할수있다.(DB 재부팅하면 TRIGGER가 DISABLE상태가 되므로)
--   2) 데이터베이스 테이블의 데이터에 생기는 작업의 감시, 보완 
--   3) 데이터베이스 테이블에 생기는 변화에 따라 필요한 다른 프로그램을 실행하는 경우 
--   4) 불필요한 트랜잭션을 금지하기 위해 
--   5) 컬럼의 값을 자동으로 생성되도록 하는 경우 
------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : ' || :old.dname);
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : ' || :new.dname);
END;


UPDATE dept
SET    dname = '회계2팀'
WHERE  deptno = 72;
COMMIT;


----------------------------------------------------------
--HW2 ) emp Table의 급여가 변화시
--       화면에 출력하는 Trigger 작성( emp_sal_change)
--       emp Table 수정전
--      조건 : 입력시는 empno가 0보다 커야함

--출력결과 예시
--     이전급여  : 10000
--     신  급여  : 15000
 --    급여 차액 :  5000
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
    DBMS_OUTPUT.PUT_LINE('이전 급여  : ' || :old.sal);
    DBMS_OUTPUT.PUT_LINE('신   급여  : ' || :new.sal);
    DBMS_OUTPUT.PUT_LINE('급여 차액 : ' || sal_diff);  
END;

UPDATE emp
SET    sal = 1500
WHERE  empno = 7369;


-- 내가 푼방법 -empno말고 sal >0 조건을 걸고 해봄
CREATE OR REPLACE TRIGGER emp_sal_change2
BEFORE
UPDATE ON emp
FOR EACH ROW
BEGIN
    IF :new.sal > 0 THEN
        DBMS_OUTPUT.PUT_LINE('이전 급여  : ' || :old.sal);
        DBMS_OUTPUT.PUT_LINE('신   급여  : ' || :new.sal);
        DBMS_OUTPUT.PUT_LINE('급여 차액 : ' || (:new.sal - :old.sal));
    ELSE
        DBMS_OUTPUT.PUT_LINE('급여는 0보다 커야합니다. 다시 입력해주세요');
        RAISE_APPLICATION_ERROR(-20001,'급여는 0보다 커야합니다.');
    END IF;
END;

UPDATE emp
SET    sal = 0
WHERE  empno = 0;

-----------------------------------------------------------
--  EMP 테이블에 INSERT,UPDATE,DELETE문장이 하루에 몇 건의 ROW가 발생되는지 조사
--  조사 내용은 EMP_ROW_AUDIT에 
--  ID ,사용자 이름, 작업 구분,작업 일자시간을 저장하는 
--  트리거를 작성
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
    VALUES(3500, '김현진', 3500, 50);
INSERT INTO emp(empno, ename, sal, deptno)
    VALUES(3600, '박은주', 3500, 50);
    
UPDATE emp
SET    ename = '은주', sal = 3000
WHERE  empno = 3600;

DELETE emp
WHERE  empno = 9999;
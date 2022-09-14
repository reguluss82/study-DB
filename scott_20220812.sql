-- FK ***면접질문 근본 RDB 테이블간 관계.
-- 1. Restrict(작업없음) : 자식 존재 삭제 안됨
--  1) 선언 emp TABLE에서 REFERENCES DEPT (DEPTNO)
--  2) 예시 ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
     DELETE dept WHERE deptno = 10;

-- 2. Cascading Delete(종속삭제) : 같이 죽자
--  1) 종속삭제 선언 emp TABLE에서 REFERENCES DEPT (DEPTNO) ON DELETE CASCADE
--  2) 예시 emp(9999)  --> dept(76)
     DELETE dept WHERE deptno = 76;

-- 3. SET NULL 
--  1) 종속NULL 선언 emp TABLE에서 REFERENCES DEPT (DEPTNO) ON DELETE SET NULL
--  2) 예시 emp(5555)  --> dept(75)
     DELETE dept WHERE deptno = 75;


--------------------------------------------------------------------------------
--                            Backup Dir 생성 --실제 프로젝트때 백업 중요하다.
--------------------------------------------------------------------------------
-- 1. 행동강령
--  1) admin에서 mdbackup directory와 권한 획득후
--   scott 전체 backup
--   C:\oraclexe\mdbackup>
EXPDP scott/tiger Directory=mdbackup DUMPFILE=scott.dmp --cmd에서 실행

--  2) Oracle 전체 Restore (scott)
--   C:\oraclexe\mdbackup>
IMPDP scott/tiger Directory=mdbackup DUMPFILE=scott.dmp


-- Oracle 부분 Backup 후 부분 Restore (scott)
-- 계정 우클릭 속성 보면 SID 알수있음 scott은 xe
EXP scott/tiger@xe file=student.dmp tables=student

-- Oracle 전체 Restore (scott)
--   C:\oraclexe\mdbackup>
IMP scott/tiger@xe file=student.dmp full=y



--------------------------------------------------------------------------------
--   11. View 
--------------------------------------------------------------------------------
-- View : 하나 이상의 기본 테이블이나 다른 뷰를 이용하여 생성되는 가상 테이블
--        뷰는 데이터딕셔너리 테이블에 뷰에 대한 정의만 저장
--       장점 : 보안
--       단점 : Performance(성능)은 더 저하 <-- 요즘은 쓰는것이 권장이다.

CREATE OR REPLACE VIEW view_professor AS
SELECT profno, name, userid, position, hiredate, deptno
FROM   professor;

CREATE OR REPLACE VIEW View_Professor2 AS
SELECT name, userid, position, hiredate, deptno
FROM   professor; --PK 가 없다. <- INSERT 가 불가능하다.

SELECT * FROM view_professor;


-- 특성 1. 원래 table [professor]에 입력 가능, 하지만 제약조건은 그대로 따름!
INSERT INTO view_professor VALUES(2000, 'veiw','userid','position',sysdate,101); --제약조건에 걸리지 않는다면 뷰를 통한 입력 가능 
INSERT INTO view_professor (profno, userid, position, hiredate, deptno)
                            VALUES(2001,'userid2','position2',sysdate,101); --name에 제약조건 not null이 있는데 name을 입력하지 않아서 에러!
                            -- cannot insert NULL into ("SCOTT"."PROFESSOR"."NAME")


INSERT INTO view_professor2 ( userid, position, hiredate, deptno)
                            VALUES('userid3','position3',sysdate,101); --name에 제약조건 not null이 있는데 name을 입력하지 않아서 에러!
                            -- cannot insert NULL into ("SCOTT"."PROFESSOR"."NAME")


-- VIEW 이름 v_emp_sample  : emp(empno , ename , job, mgr,deptno)
CREATE  OR REPLACE VIEW v_emp_sample
AS
SELECT empno , ename , job, mgr,deptno
FROM   emp;


-- 복합 VIEW / 통계 VIEW  --> INSERT 안됨
CREATE OR REPLACE VIEW v_emp_complex
AS
SELECT *
FROM emp NATURAL JOIN dept;

INSERT INTO v_emp_complex (empno, ename, deptno)
                     VALUES(1500, '홍길동', 20);
INSERT INTO v_emp_complex (deptno, dname, loc)
                     VALUES(77, '공무팀', '낙성대');
INSERT INTO v_emp_complex (empno, ename, deptno, dname, loc)
                     VALUES(1500,'홍길동', 77, '공무팀', '낙성대');

------     View  HomeWork     ----------------------------------------------------
---문1)  학생 테이블에서 101번 학과 학생들의 학번, 이름, 학과 번호로 정의되는 단순 뷰를 생성
---     뷰 명 :  v_stud_dept101
CREATE OR REPLACE VIEW v_stud_dept101
AS
SELECT studno, name, deptno
FROM   student
WHERE  deptno = 101;

-- 문2) 학생 테이블과 부서 테이블을 조인하여 102번 학과 학생들의 학번, 이름, 학년, 학과 이름으로 정의되는 복합 뷰를 생성
--      뷰 명 :   v_stud_dept102
CREATE OR REPLACE VIEW v_stud_dept102
AS
SELECT studno, name, grade, dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    deptno = 102;

-- 문3)  교수 테이블에서 학과별 평균 급여와     총계로 정의되는 뷰를 생성
--  뷰 명 :  v_prof_avg_sal       Column 명 :   avg_sal      sum_sal
CREATE OR REPLACE VIEW v_prof_avg_sal
AS
SELECT deptno, AVG(sal) avg_sal, SUM(sal) sum_sal
FROM   professor
GROUP BY deptno
ORDER BY deptno;

-- 2. GROUP 함수 Column 등록 안됨 
INSERT INTO V_PROF_AVG_SAL
VALUES(203,600,300);
-- View 삭제 
DROP VIEW v_stud_dept102;

SELECT view_name , text
FROM   USER_VIEWS;

-------------------------------------
---- 계층적 질의문
-------------------------------------
-- 1. 관계형 데이터 베이스 모델은 평면적인 2차원 테이블 구조
-- 2. 관계형 데이터 베이스에서 데이터간의 부모 관계를 표현할 수 있는 칼럼을 지정하여 
--    계층적인 관계를 표현
-- 3. 하나의 테이블에서 계층적인 구조를 표현하는 관계를 순환관계(recursive relationship)
-- 4. 계층적인 데이터를 저장한 칼럼으로부터 데이터를 검색하여 계층적으로 출력 기능 제공
--     LEVEL컬럼은 레벨 의사컬럼(LEVEL Pseudocolumn)이라고 하는데 계층형 정보를 표현
-- 사용법
-- SELECT 명령문에서 START WITH와 CONNECT BY 절을 이용
-- 계층적 질의문에서는 계층적인 출력 형식과 시작 위치 제어
-- 출력 형식은 top-down 또는 bottom-up
-- 참고) CONNECT BY PRIOR 및 START WITH절은 ANSI SQL 표준이 아님

-- 문) 계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 단대,학부
-- 학과순으로 top-down 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 10번 부서
SELECT     deptno, dname, college
FROM       department
START WITH deptno = 10
CONNECT BY PRIOR deptno = college; -- colmn 쓰여진 순서대로, 자식부터

-- 문2) 계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 학과,학부
-- 단대 순으로 bottom-up 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 102번 부서이다
SELECT     deptno, dname, college
FROM       department
START WITH deptno = 102
CONNECT BY PRIOR college = deptno; -- tod-down의 거꾸로, 부모부터

--- 문3) 계층적 질의문을 사용하여 부서 테이블에서 부서 이름을 검색하여 단대, 학부, 학과순의
---      top-down 형식으로 출력하여라. 단, 시작 데이터는 ‘공과대학’이고,
---      각 LEVEL(레벨)별로 우측으로 2칸 이동하여 출력
SELECT     LPAD(' ', (LEVEL-1)*2) || dname 조직도
FROM       department
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;


------------------------------------------------------
---      TableSpace 
--데이터베이스 오브젝트 내 실제 데이터를 저장하는 공간이다.
--이것은 데이터베이스의 물리적인 부분이며, 세그먼트로 관리되는 모든 DBMS에 대해
--저장소(세그먼트)를 할당
--업무별로 할당
-------------------------------------------------------
-- 1. TableSpace 생성
CREATE TABLESPACE user1 DATAFILE 'C:\oraclexe\tableSpace\user1.ora' SIZE 100M;
CREATE TABLESPACE user2 DATAFILE 'C:\oraclexe\tableSpace\user2.ora' SIZE 100M;
CREATE TABLESPACE user3 DATAFILE 'C:\oraclexe\tableSpace\user3.ora' SIZE 100M;
CREATE TABLESPACE user4 DATAFILE 'C:\oraclexe\tableSpace\user4.ora' SIZE 100M;
-- 2.Table의 TableSpace 변경
--  1) 테이블의 INDEX와 Table의 테이블 스페이스 조회
SELECT index_name, table_name, tablespace_name
FROM   user_indexes;
SELECT table_name, tablespace_name
FROM   user_tables;
--  2) 각 테이블 별로 TABLESPACE 변경
--      해당 INDEX 먼저 변경 후 TABLE의 TABLESPACE 변경
ALTER INDEX SYS_C007014 REBUILD TABLESPACE user1;
ALTER TABLE job3 MOVE TABLESPACE user1;

-- 3. TABLESPACE SIZE 변경
ALTER DATABASE DATAFILE 'C:\oraclexe\tableSpace\user1.ora' RESIZE 200M;

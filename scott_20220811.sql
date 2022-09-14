---------------------------------------------------------------------------------------------
---- MERGE
-- 1. MERGE 개요
--  구조가 같은 두개의 테이블을 비교하여 하나의 테이블로 합치기 위한 데이터 조작어
--  WHEN 절의 조건절에서 결과 테이블에 해당 행이 존재하면 UPDATE 명령문에 의해 새로운 값으로 수정,
--  그렇지 않으면 INSERT 명령문으로 새로운 행을 삽입
---------------------------------------------------------------------------------------------

-- 1] MERGE 예비작업
--  상황 
-- 1) 교수가 명예교수로 2행 Update
-- 2) 김도경 씨가 신규 Insert

CREATE TABLE professor_temp
AS SELECT * FROM professor
WHERE  position = '교수'; --CREATE DDL이므로 AUTO COMMIT

UPDATE professor_temp
SET    position = '명예교수'
WHERE  position = '교수'; --UPDATE DML이므로 COMMIT 해줘야함

INSERT INTO professor_temp
VALUES (9999,'김도경', 'arom21', '전임강사', 200, sysdate, 10, 101);

COMMIT;

-- 2] professor MERGE 수행
-- 목표 : professor_temp에 있는 직위 수정된 내용을 professor Table에 UPDATE
--                  김도경 씨가 신규 INSERT 내용을 professor Table에 INSERT
-- 1) 교수가 명예교수로 2행 Update
-- 2) 김도경 씨가 신규 Insert

MERGE INTO professor p
USING professor_temp f
ON   (p.profno = f.profno)
WHEN MATCHED THEN     --PK가 같으면 직위를 UPDATE
    UPDATE SET p.position = f.position
WHEN NOT MATCHED THEN --PK가 없으면 신규 INSERT
    INSERT VALUES (f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
    

---------------------------------------------------------------------------------------------
-- 트랜잭션 개요 ***매우중요한 개념
-- 관계형 데이터베이스에서 실행되는 여러 개의 SQL명령문을 하나의 논리적 작업 단위로 처리하는 개념
-- commit 과 commmit 사이 

-- COMMIT   : 트랜잭션의 정상적인 종료
--            트랜잭션내의 모든 SQL 명령문에 의해 변경된 작업 내용을 디스크에 영구적으로 저장하고 트랜잭션을 종료
--            해당 트랜잭션에 할당된 CPU, 메모리 같은 자원이 해제
--            서로 다른 트랜잭션을 구분하는 기준
--            COMMIT 명령문 실행하기 전에 하나의 트랜잭션 변경한 결과를
--            다른 트랜잭션에서 접근할 수 없도록 방지하여 일관성 유지 <- 고립성

-- ROLLBACK : 트랜잭션의 전체 취소
--            트랜잭션내의 모든 SQL 명령문에 의해 변경된 작업 내용을 전부 취소하고 트랜잭션을 종료
--            CPU,메모리 같은 해당 트랜잭션에 할당된 자원을 해제, 트랜잭션을 강제 종료
---------------------------------------------------------------------------------------------
--ACID 면접질문
--concurrent   프로그래밍 혹은 그러한 프로그램에서 데이터에 대한 트랜젝션이 안전하도록 보장하기 위해서 만족해야 하는 특성모음이다. 데이터베이스 에서의 트랜잭션이 대표적인 예이다.
--Atomicity   : 원자성. 트랜잭션과 관련된 일은 모두 실행되던지 모두 실행되지 않도록 하던지를 보장하는 특성이다.
--Consistency : 일관성. 트랜잭션이 성공했다면, 데이터베이스는 그 일관성을 유지해야 한다. 일관성은 특정한 조건을 두고, 그 조건을 만족하는지를 확인하는 방식으로 검사할 수 있다.
--Isolation   : 독립성. 트랜잭션을 수행하는 도중에 다른 연산작업이 끼어들지 못하도록 한다. 임계영역을 두는 것으로 달성할 수 있다.
--Durability  : 지속성. 성공적으로 트랜잭션이 수행되었다면, 그 결과는 완전히 반영이 되어야 한다. 완전히 반영되면 로그를 남기게 되는데, 후에 이 로그를 이용해서 트랜잭션 수행전 상태로 되돌릴 수 있어야 한다. 때문에 트랜잭션은 로그저장이 완료된 시점에서 종료가 되어야 한다.
---------------------------------------------------------------------------------------------

----------------------------------
-- SEQUENCE *** 많이 쓰인다. 프로젝트에서 쓰는게 권장
-- 유일한 식별자
-- 기본 키 값을 자동으로 생성하기 위하여 일련번호 생성 객체
-- 예를 들면, 웹 게시판에서 글이 등록되는 순서대로 번호를 하나씩 할당하여 기본키로 지정하고자 할때
-- 시퀀스를 편리하게 이용
-- 여러 테이블에서 공유 가능 <- 일반적으로는 개별적 사용
------ PK 생성방법 : 특정값, Max, SEQUENCE 비교 면접질문
-- 동시에 max값을 받아오는 경우 conflict 발생 가능성 
-- SEQUENCE 는 conflict 발생 안함. 
----------------------------------
-- 1) SEQUENCE 형식
--CREATE SEQUENCE sequence
--[INCREMENT BY n]
--[START WITH n]
--[MAXVALUE n | NOMAXVALUE]
--[MINVALUE n | NOMINVALUE]
--[CYCLE | NOCYCLE]
--[CACHE n | NOCACHE];
--INCREMENT BY n    : 시퀀스 번호의 증가치로 기본은 1,  일반적으로 ?1 사용
--START WITH n      : 시퀀스 시작번호, 기본값은 1
--MAXVALUE n        : 생성 가능한 시퀀스의 최대값 --다 차버리면 늘려줘야하므로 그냥 지정안해서 시스템 최대값으로 둠
--MAXVALUE n        : 시퀀스 번호를 순환적으로 사용하는 cycle로 지정한 경우, MAXVALUE에 도달한 후 새로 시작하는 시퀀스값
--CYCLE | NOCYCLE   : MAXVALUE 또는 MINVALUE에 도달한 후 시퀀스의 순환적인 시퀀스 번호의 생성 여부 지정
--CACHE n | NOCACHE : 시퀀스 생성 속도 개선을 위해 메모리에 캐쉬하는 시퀀스 개수, 기본값은 20

-- 2) SEQUENCE sample 예시1
CREATE SEQUENCE sample_seq
INCREMENT BY 1
START WITH   1;

SELECT sample_seq.NEXTVAL FROM dual;
SELECT sample_seq.CURRVAL FROM dual;

-- 3) SEQUENCE sample 예시2 --> 실 사용 예시
CREATE SEQUENCE dept_dno_seq
INCREMENT BY 1
START WITH   76;

-- 4) SEQUENCE dno_seq를 이용 dept_second 입력 --> 실 사용 예시
INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, 'Accounting', 'NEW YORK');
SELECT dept_dno_seq.CURRVAL FROM dual;

INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, '회계', '이대');
SELECT dept_dno_seq.CURRVAL FROM dual;

INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, '인사팀', '당산');

-- MAX 전환  -- 동시에 max값을 받아오는 경우 conflict 발생 가능성 commit안한상태에서 다른사람도 같은 max값을 받음
                --SEQUENCE 는 conflict 발생 안함. 
INSERT INTO dept_second
VALUES((SELECT MAX(deptno) + 1  FROM dept_second)
        , '경영팀'
        , '대림'
        );
        

-- 5) SEQUENCE 삭제
DROP SEQUENCE sample_seq;

-- 6) DATA 사전에서 정보 조회
SELECT sequence_name, min_value, max_value, increment_by
FROM   user_sequences;

---------------------------------------------------------
----                   TABLE 조작                    ----
---------------------------------------------------------
-- 1. TABLE 생성
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

-- 문1) address스키마/Data 유지하며     addr_second Table 생성 
CREATE TABLE     addr_second (id, name, addr, phone, email) --칼럼 명시해두면 유지보수면에서 유리함
AS SELECT * FROM address;

-- 문2) address스키마 유지하며  Data 복제 하지 않고   addr_seven Table 생성 
CREATE TABLE     addr_seven (id, name, addr, phone, email)
AS SELECT * FROM address
WHERE            1 = 0;

-- 문3) address(주소록) 테이블에서 id, name 칼럼만 복사하여 addr_third 테이블을 생성하여라
CREATE TABLE addr_third
AS SELECT    id, name
FROM         address;

-- 문4) addr_second 테이블 을 addr_tmp로 이름을 변경 하시요
RENAME addr_second TO addr_tmp;

---------------------------------------------------------
----                   데이터 사전                    ----
-- 사용자와 데이터베이스 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블의 집합
-- 사전 내용의 수정은 오라클 서버만 가능
-- 오라클 서버는 데이타베이스의 구조, 감사, 사용자 권한, 데이터 등의 변경 사항을 반영하기 위해
-- 지속적 수정 및 관리
-- 데이타베이스 관리자나 일반 사용자는 읽기 전용 뷰에 의해 데이터 사전의 내용을 조회만 가능
-- 실무에서는 테이블, 칼럼, 뷰 등과 같은 정보를 조회하기 위해 사용

-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------   데이터 사전 관리 정보   
-- 1. 데이터베이스의 물리적 구조와 객체의 논리적 구조
-- 2. 오라클 사용자 이름과 스키마 객체 이름
-- 3. 사용자에게 부여된 접근 권한과 롤
-- 4. 무결성 제약조건에 대한 정보
-- 5. 칼럼별로 지정된 기본값
-- 6. 스키마 객체에 할당된 공간의 크기와 사용 중인 공간의 크기 정보
-- 7. 객체 접근 및 갱신에 대한 감사 정보
-- 8. 데이터베이스 이름, 버전, 생성날짜, 시작모드, 인스턴스 이름 정보
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------   데이터 사전 종류 --암기x 참조o
-- 1. USER_ : 객체의 소유자만 접근 가능한 데이터 사전 뷰
-- user_tables는 사용자가 소유한 테이블에 대한 정보를 조회할 수 있는 데이터 사전 뷰이다.
SELECT table_name
FROM   user_tables;

SELECT *
FROM   user_catalog;

-- 2. ALL_  : 자기 소유 또는 권한을 부여 받은 객체만 접근 가능한 데이터 사전 뷰
SELECT owner, table_name
FROM   all_tables;

-- 3. DBA_  : 데이터베이스 관리자만 접근 가능한 데이터 사전 뷰
SELECT owner, table_name
FROM   dba_tables;
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
------------         제약조건(Constraint)   *** 중요! 프로젝트-- 보통 입력이 잘 안되는 경우 제약조건을 확인해라  -----
-- 정의 : 데이터의 정확성과 일관성을 보장
-- 1. 테이블 생성시 무결성 제약조건을 정의 가능
-- 2. 테이블에 대해 정의, 데이터 딕셔너리에 저장되므로 응용 프로그램에서 입력된
--    모든 데이터에 대해 동일하게 적용
-- 3. 제약조건을 활성화, 비활성화 할 수 있는 융통성
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
------------         제약조건(Constraint)  종류 ***면접질문 ------------
-- 1. NOT NULL : 열이 NULL을 포함할 수 없음
-- 2. 기본키(primary key) : UNIQUE + NOT NULL + 최소성 제약조건을 결합한 형태
-- 3. 참조키(foreign key) : 테이블의 간에 외래 키 관계를 설정하고 *** 중요 RDB
-- 4. CHECK : 해당 칼럼에 저장 가능한 데이터 값의 범위나 조건 지정
-----------------------------------------------------------------------------------------
-- 1. 제약조건(Constraint) 적용 위한 강좌(subject) 테이블 인스턴스 생성
CREATE TABLE subject (
    subno     NUMBER(5)    CONSTRAINT subject_no_pk   PRIMARY KEY,
    subname   VARCHAR2(20) CONSTRAINT subject_name_nn NOT NULL,
    term      VARCHAR2(1)  CONSTRAINT subject_term_ck CHECK(term IN('1', '2')),
    typeGubun VARCHAR2(1)
);

COMMENT ON COLUMN subject.subno   IS '수강번호';
COMMENT ON COLUMN subject.subname IS '수강번호';
COMMENT ON COLUMN subject.term    IS '학기';

INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10000, '컴퓨터개론', '1', '1');
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10001, 'DB개론', '2', '1');            
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10002, 'JSP개론', '1', '1');
            
--------------------------------------------------------------------------------          
-- PK CONSTRAINT --> UNIQUE
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10001, 'SPRING개론', '1', '1');
--오류 보고 -
--ORA-00001: unique constraint (SCOTT.SUBJECT_NO_PK) violated

-------------------------------------------------------------------------------- 
-- PK CONSTRAINT --> NN
INSERT INTO subject(subname, term, typegubun)
            VALUES('SPRING개론2', '1', '1');
--오류 보고 -
--ORA-01400: cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNO")

-------------------------------------------------------------------------------- 
-- subname NN
INSERT INTO subject(subno, term, typegubun)
            VALUES(10003, '1', '1');
--오류 보고 -
--ORA-01400: cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNAME")

-------------------------------------------------------------------------------- 
-- Check Constraint  --> term
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES(10004, 'SPRING개론3', '5', '1');
--오류 보고 -
--ORA-02290: check constraint (SCOTT.SUBJECT_TERM_CK) violated

-------------------------------------------------------------------------------- 

-- TABLE 선언시 CONSTRAINT 못한것을 추후 정의 가능
-- student Table 의 idnum을 unique로 선언
ALTER TABLE student
ADD CONSTRAINT stud_idnum_uk UNIQUE(idnum);


-- idnum  --> OK
INSERT INTO student(studno, name, idnum)
            VALUES(30101, '대조영', '8012301036613');
            
-- idnum  --> unique constraint
INSERT INTO student(studno, name, idnum)
            VALUES(30102, '강감찬', '8012301036613');
--오류 보고 -
--ORA-00001: unique constraint (SCOTT.STUD_IDNUM_UK) violated


-- student Table 의 name을 NN로 선언
ALTER TABLE student
MODIFY (name CONSTRAINT stud_name_nn NOT NULL);

-- name  --> NN constraint
INSERT INTO student(studno, idnum)
            VALUES(30103, '8012301036614');
--오류 보고 -
--ORA-01400: cannot insert NULL into ("SCOTT"."STUDENT"."NAME")


-- CONSTRAINT 조회
SELECT CONSTRAINT_name, CONSTRAINT_Type
FROM   user_CONSTRAINTs
WHERE  table_name IN('SUBJECT','STUDENT');




---------------------------------------------------------------
-----      INDEX    ***면접질문
-- 인덱스는 SQL 명령문의 처리 속도를 향상(*)시키기 위해 칼럼에 대해 생성하는 객체
-- 인덱스는 포인트를 이용하여 테이블에 저장된 데이터를 랜덤 액세스하기 위한 목적으로 사용
-- 실무에서는 SELECT 의 성능이 매우 중요하다. -I/D/U는 거의 한ROW씩 처리해서 중요도가 낮아짐

-- Index는 RDBMS에서 검색 속도를 높이기 위한 기술이다.
-- TABLE의 컬럼을 색인화(따로 파일로 저장)하여 검색시 해당 TABLE의 레코드를 Full Scan 하는게 
-- 아니라 색인화 되어있는 INDEX 파일을 검색하여 검색속도를 빠르게 한다.
-- RDBMS에서 사용하는 INDEX는 B-Tree 에서 파생된 B+ Tree 를 사용해서 색인화한다.
-- 보통 SELECT 쿼리의 WHERE절이나 JOIN 예약어를 사용했을때 인덱스가 사용되며
-- SELECT 쿼리의 검색 속도를 빠르게 하는데 목적을 두고 있다.
-- DELETE, INSERT, UPDATE 쿼리에는 해당 사항이없으며 INDEX 사용시 오히려 느려진다
-- 조금더 자세히 알아보면, SQL서버에서 데이터의 레코드는 내부적으로 아무런 순서없이 저장된다.
-- 이때 데이터 저장영역을 Heap이라고 한다.
-- Heap에서는 인덱스가 없는 테이블의 데이터를 찾을 때
-- 전체 데이터 페이지의 처음 레코드부터 끝 페이지의 마지막 레코드까지 모두 조회하여 검색조건과 비교하게 된다.
-- 이러한 데이터 검색방법을 테이블 스캔(Table Scan) 또는 풀 스캔(Full Scan)이라고 한다.
-- 이럴 경우 양이 많은 테이블에서 일부분의 데이터만 불러 올 때 풀 스캔을 하면 처리 성능이 떨어진다.
-- 즉 인덱스는 데이터를 SELECT 할 때 빨리 찾기 위해 사용된다

-- [1]인덱스의 종류
-- 1)고유 인덱스 : 유일한 값을 가지는 컬럼에 대해 생성하는 인덱스로 모든 인덱스 키는
--                테이블의 하나의 행과 연결 --null가능
        CREATE UNIQUE INDEX idx_dept_name
        ON     department(dname);
-- 2)비고유 인덱스
-- 문) 학생 테이블의 birthdate 칼럼을 비고유 인덱스로 생성하여라
 CREATE INDEX idx_stud_birthdate
 ON student(birthdate);
 
 --비고유 인덱스 birthdate --> CONSTRAINT X, 성능에만 영향 미침
 INSERT INTO student(studno, name, idnum, birthdate)
            VALUES(30102, '김유신', '8012301036614', '82/06/06');
-- 3)단일 인덱스 - 단일 컬럼
-- 4)결합 인덱스 : 결합 인덱스는 두 개 이상의 칼럼을 결합하여 생성하는 인덱스
--  문) 학생 테이블의 deptno, grade 칼럼을 결합 인덱스로 생성
--      결합 인덱스의 이름은 idx_stud_dno_grade 로 정의
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade);

SELECT *
FROM  student
WHERE deptno = 101
AND   grade  = 2;

--WHERE grade  = 2;   <-- index 순서대로 해야 제대로 index적용된다.
--AND   deptno = 101   grade만 걸려서 성능상 이득을 취하기 어렵다



-- 5)함수 기반 인덱스 (Function Based Index)
-- 오라클 8i 버전부터 지원하는 새로운 형태의 인덱스로 
-- 칼럼에 대한 연산이나 함수의 계산 결과를 인덱스로 생성 가능
-- UPPER(column_name) 또는 LOWER(column_name) 키워드로 정의된  
-- 함수 기반 인덱스를 사용하면 대소문자 구분 없이 검색
CREATE INDEX uppercase_idx ON emp (UPPER(ename));

SELECT * FROM emp WHERE UPPER(ename) = 'KING';

-- [2]인덱스가 효율적인 경우 
-- 1) WHERE 절이나 조인 조건절에서 자주 사용되는 칼럼
-- 2) 전체 데이터중에서 10~15%이내의 데이터를 검색하는 경우
-- 3) 두 개 이상의 칼럼이 WHERE절이나 조인 조건에서 자주 사용되는 경우
-- 4) 테이블에 저장된 데이터의 변경이 드문 경우
-- 5) 열에 널 값이 많이 포함된 경우, 열에 광범위한 값이 포함된경우

---------------------------------------------------------------
--+-------+-PK INDEX 비교 면접질문------------------+
--|       |       PK        |          INDEX       |
--+-------+-----------------+----------------------+
--|  개념  | Table 내 유일한 |    Performance 향상  |
--|        |    Row보장      |       위한 객체      |     
--+--------+----------------+----------------------+
--| Count  |        1       | 200개 이상(7개 이내)  |
--+--------+----------------+----------------------+
--|고려사항|     unique      |   Index 따로 생성    |
--|       |         NN       |   SELECT 성능향상    |
--|       |      최소성      |   I/D/U 성능하락     |
--+-------+-----------------+----------------------+


-- 학생 테이블에 생성된 PK_STUDNO 인덱스를 재구성
ALTER INDEX PK_STUDNO REBUILD;

--인덱스 파일은 생성 후 Insert, Update, Delete등을 반복하다보면 성능이 저하된다.
--생성된 인덱스는 트리구조를 가지는데, 삽입,수정,삭제등이 오랫동안 일어나다보면 트리의 한쪽이 무거워져 전체적으로 트리의 깊이가 깊어지기 때문이다.
--이러한 현상으로 인해 인덱스의 검색속도가 떨어지므로 주기적으로 리빌딩하는 작업을 거치는것이 좋다.
-- 작업은 피크타임 피해서 , 스케쥴러 사용하면 편안

-- 1. INDEX 조회
SELECT index_name, table_name, column_name
FROM   user_ind_columns;


-- 2. INDEX 생성 emp(job)
CREATE INDEX idx_emp_job ON emp(job);

-- 3. 조회
SELECT * FROM emp WHERE job = 'MANAGER';         -- =           index OK
SELECT * FROM emp WHERE job <> 'MANAGER';        -- <>          index NO
SELECT * FROM emp WHERE job LIKE '%NA%';         -- LIKE '%NA%' index NO
SELECT * FROM emp WHERE UPPER(job) = 'MANAGER';  -- UPPER(job)  index NO <--함수기반INDEX사용으로 해결

--- Optimizer
--- 1) RBO 규칙대로 그대로  
--- 2) 조회량과 성능에 따라 최적화, CBO 요즘 대부분 CBO가 default
-- RBO 변경
ALTER SESSION SET OPTIMIZER_MODE = RULE;

-- SESSION 상에서 변경할때 
 alter session set optimizer_mode=rule       --RBO
 alter session set optimizer_mode=CHOOSE     --RBO OR CBO
 alter session set optimizer_mode=FIRST_ROWS --CBO
 alter session set optimizer_mode=ALL_ROWS   --CBO

-- SQL Optimizer
SELECT /*+ first_rows */ ename From emp;
SELECT /*+ rule */ ename From emp;

--OPTIMIZER MODE 확인
SELECT NAME, VALUE, ISDEFAULT, ISMODIFIED, DESCRIPTION
FROM V$SYSTEM_PARAMETER
WHERE NAME LIKE '%optimizer_mode%';
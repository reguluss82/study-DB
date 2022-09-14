---------------------------------------------------------
----- SUB Query  ***
-- 하나의 SQL 명령문의 결과를 다른 SQL 명령문에 전달하기 위해 
-- 두 개 이상의 SQL 명령문을 하나의 SQL명령문으로 연결하여 처리하는 방법
--처리과정
--1. 서브쿼리는 메인쿼리가 실행되기 전에 한번씩 실행됨
--2. 서브쿼리에서 실행된 결과가 메인 쿼리에 전달되어 최종적인 결과를 출력

-- 종류
-- 1) 단일행 서브쿼리
-- 2) 다중행 서브쿼리
---------------------------------------------------------
--  1. 목표 : 교수 테이블에서 ‘전은지’ 교수와 직급이 동일한 모든 교수의 이름 검색
--       1-1 교수 테이블에서 ‘전은지’ 교수의 직급 검색 SQL 명령문 실행
--           9907	전은지	totoro	전임강사	210	01/01/01		101
        SELECT position
        FROM   professor
        WHERE  name = '전은지';
--       1-2 교수 테이블의 직급 칼럼에서 1 에서 얻은 결과 값과 동일한 직급을 가진 교수 검색 명령문 실행
        SELECT name, position
        FROM   professor
        WHERE  position = '전임강사';
        
        
-- 1. 목표 : 교수 테이블에서 ‘전은지’ 교수와 직급이 동일한 모든 교수의 이름 검색--> SUB Query
SELECT name, position
FROM   professor
WHERE  position = (SELECT position
                   FROM   professor
                   WHERE  name = '전은지');

-- 종류
-- 1) 단일행 서브쿼리
-- 서브쿼리에서 단 하나의 행만을 검색하여 메인쿼리에 반환하는 질의문
-- 메인쿼리의 WHERE 절에서 서브쿼리의 결과와 비교할 경우에는 
-- 반드시 단일행 비교 연산자 중 하나만 사용해야함
-- 서브쿼리의 결과로 하나의 행만이 출력되어야 함

-- 문1) 사용자 아이디가 ‘jun123’인 학생과 같은 학년인 학생의 학번, 이름, 학년을 출력하여라
SELECT studno, name, grade
FROM   student
WHERE  grade = (SELECT grade
                FROM   student
                WHERE  userid = 'jun123'); --PK 인것을 알기때문에 단일행 반환될 것을 안다.
                                           --PK가 아니면 다중행 가능성을 염두
-- 문2) 101번 학과 학생들의 평균 몸무게보다 몸무게가 적은
-- 학생의 이름, 학년, 학과번호, 몸무게를 출력
-- 조건 : 학과별 출력
SELECT name, grade, deptno, weight
FROM   student
WHERE  weight < (SELECT AVG(weight) --집계함수가 있으므로 단일행임을 안다.
                 FROM   student
                 WHERE  deptno = 101)
ORDER BY deptno;

-- 문3)  20101번 학생과 학년이 같고, 키는 20101번 학생보다 큰 학생의 
-- 이름, 학년, 키를 출력하여라
-- 조건 : 학과별 출력
SELECT name, grade, height
FROM   student
WHERE  grade  = (SELECT grade
                 FROM   student
                 WHERE  studno = 20101)
AND    height > (SELECT height
                 FROM   student
                 WHERE  studno = 20101)
ORDER BY deptno;

 --  문3-1) 20101번 학생과 학년이 같고, 키는 20101번 학생보다 큰 학생의 
--  이름, 학년, 키, 학과명를 출력하여라
--  조건 : 학과명별 출력
SELECT s.name, s.grade, s.height, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.grade  = (SELECT grade
                   FROM   student
                   WHERE  studno = 20101)
AND    s.height > (SELECT height
                   FROM   student
                   WHERE  studno = 20101)
ORDER BY d.dname;

-- 문4) 101번 학과 학생들의 평균 몸무게보다 몸무게가 적은 학생의 
-- 이름, 학과번호, 몸무게를 출력하여라
-- 조건 : 학과별 출력
SELECT name, deptno, weight
FROM   student
WHERE  weight < (SELECT AVG(weight)
                 FROM   student
                 WHERE  deptno = 101)
ORDER BY deptno;

-- 2)다중행 서브쿼리
-- 서브쿼리에서 반환되는 결과 행이 하나 이상일 때 사용하는 서브쿼리
-- 메인쿼리의 WHERE 절에서 서브쿼리의 결과와 비교할 경우에는 다중 행 비교 연산자 를 사용하여 비교
-- 다중 행 비교 연산자는 단일 행 비교 연산자와 결합하여 사용 가능
-- 다중 행 비교 연산자 : IN, ANY, SOME, ALL, EXISTS
-- 1) IN        : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 하나라도 일치하면 참, ‘=‘비교만 가능
-- 2) ANY, SOME : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 하나라도 일치하면 참, ‘=‘, '<, >' 가능
-- 3) ALL       : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 모든값이 일치하면 참
-- 4) EXISTS    : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 만족하는 값이 하나라도 존재하면 참, 
             -- EXISTS *** 서브쿼리의 조건은 메인쿼리와 상관없음 참 거짓만 받고 메인쿼리가 실행

-- 1. IN 연산자를 이용한 다중 행 서브쿼리
-- error ORA-01427: single-row subquery returns more than one row
SELECT name, grade, deptno
FROM   student
WHERE  deptno = (SELECT deptno
                 FROM   department
                 WHERE  college = 100); --SUB QUERY에 다중행 반환 --> 오류
                 
SELECT name, grade, deptno
FROM   student
WHERE  deptno IN (SELECT deptno -- 101, 102
                  FROM   department
                  WHERE  college = 100);
-- ‘=‘ 연산자를 OR로 연결한 것과 같은 의미

SELECT name, grade, deptno
FROM   student
WHERE  deptno IN (101, 102);


-- 2. ANY 연산자를 이용한 다중 행 서브쿼리
-- 문) 모든 학생 중에서 4학년 학생 중에서 키가 제일 작은 학생보다 키가 큰 학생의 학번, 이름, 키를 출력하여라
SELECT studno, name, height
FROM   student
WHERE  height > ANY (SELECT height  --175,176,177 이 값중에 어떤것보다도 커야함 -> 최소값인 175 기준
                     FROM   student
                     WHERE  grade = '4');


SELECT studno, name, height
FROM   student
WHERE  height > ANY 
                (SELECT MIN(height)
                 FROM   student
                 WHERE  grade = '4');
                   

-- 3. ALL 연산자를 이용한 다중 행 서브쿼리
-- ANY 연산자와 차이점
-- ‘>ANY’ : 서브쿼리의 결과 중에서 최소 값보다 크면 메인쿼리의 비교 조건이 참
-- ‘>ALL’ : 서브쿼리의 결과 중에서 최대 값보다 크면 메인쿼리의 비교 조건이 참

SELECT studno, name, height
FROM   student
WHERE  height > ALL 
                (SELECT height  --175,176,177 모든조건이 참이어야 하므로 -> 최대값인 177 기준
                 FROM   student
                 WHERE  grade = '4');
                    

-- 4. EXISTS 연산자를 이용한 다중 행 서브쿼리 --성능 목적 사용
SELECT profno, name, sal, comm, position
FROM   professor
WHERE  EXISTS 
        (SELECT position
         FROM   professor
         WHERE  comm IS NOT NULL);
               --comm받는 교수가 한명 이상 존재 ->참 ->main query실행
               -- -> sub의 조건이 아닌 교수테이블 모든 행 출력

SELECT profno, name, sal, comm, position
FROM   professor
WHERE  EXISTS 
        (SELECT sal
         FROM   professor
         WHERE  position = '교수');
               

SELECT profno, name, sal, comm, position
FROM   professor
WHERE  EXISTS 
        (SELECT *
         FROM   emp
         WHERE  empno = 1000); 
               

-- 문1) 보직수당을 받는 교수가 한 명이라도 있으면 
--    모든 교수의 교수 번호, 이름, 보직수당 그리고 급여와 보직수당의 합을 출력
SELECT profno, name, sal, comm, sal+NVL(comm, 0)
FROM   professor
WHERE  EXISTS 
        (SELECT name
         FROM   professor
         WHERE  comm IS NOT NULL);


-- 문2) 학생 중에서 ‘goodstudent’이라는 사용자 아이디가 없으면 1을 출력하여라
SELECT 1 userid_exist
FROM   dual
WHERE  NOT EXISTS 
            (SELECT userid
             FROM   student
             WHERE  userid = 'goodstudent');
             

-- 다중 컬럼 서브쿼리
-- 서브쿼리에서 여러 개의 칼럼 값을 검색하여 메인쿼리의 조건절과 비교하는 서브쿼리
-- 메인쿼리의 조건절에서도 서브쿼리의 칼럼 수만큼 지정해야 함
-- 종류
-- 1) PAIRWISE   : 칼럼을 쌍으로 묶어서 동시에 비교하는 방식
--                 메인쿼리와 서브쿼리에서 비교하는 칼럼의 수는 반드시 동일해야 함
-- 2) UNPAIRWISE : 칼럼별로 나누어서 비교한 후, AND 연산을 하는 방식

-- 1) PAIRWISE 다중 칼럼 서브쿼리

-- 문1) PAIRWISE 비교 방법에 의해 학년별로 몸무게가 최소인 
--      학생의 이름, 학년, 몸무게를 출력하여라
SELECT name, grade, weight
FROM   student
WHERE (grade, weight) IN (SELECT   grade, MIN(weight)
                          FROM     student
                          GROUP BY grade);
                          
-- 2) UNPAIRWISE : 칼럼별로 나누어서 비교한 후, AND 연산을 하는 방식
--                 각 칼럼이 동시에 만족하지 않더라도 개별적으로 만족하는 경우에는 비교 조건이 참이 되어 결과를 출력 가능

-- UNPAIRWISE 비교 방법에 의해 학년별로 몸무게가 최소인 학생의 이름, 학년, 몸무게를 출력
SELECT name, grade, weight
FROM   student
WHERE grade  IN (SELECT   grade -- 1, 2, 3, 4
                 FROM     student
                 GROUP BY grade)
AND   weight IN (SELECT   MIN(weight) -- 52, 42, 70, 72
                 FROM     student
                 GROUP BY grade);
-- 개발자가 생각한대로 잘 안될수 있다.


-- 상호연관 서브쿼리 *** 모르면 개발시간이 늘어난다!
-- 메인쿼리절과 서브쿼리간에 검색 결과를 교환하는 서브쿼리 메서메 순으로 실행됨
-- 메인쿼리와 서브쿼리간의 결과를 교환하기 위하여 서브쿼리의 WHERE 조건절에서 메인쿼리의 테이블과 연결
-- 주의 : 행을 비교할 때마다 결과를 메인으로 반환하는 관계로 처리 성능이 저하될 수 있음

-- 문1) 각 학과 학생의 평균 키보다 키가 큰 학생의 이름, 학과 번호, 키를 출력하여라
--         실행순서 1
--         실행순서 3
SELECT deptno, name, grade, height
FROM   student s1
WHERE  height > (SELECT AVG(height)
                 FROM   student s2
                 -- WHERE s2.deptno = 101  <--테스트
                 --         실행순서 2
                 WHERE  s2.deptno = s1.deptno)
ORDER BY deptno;

--sub query test
SELECT AVG(height)
FROM   student s2
WHERE  s2.deptno = 101;  <--테스트



-------------  HW  -----------------------
--  1. Blake와 같은 부서에 있는 모든 사원에 대해서 사원 이름과 입사일을 디스플레이하라
SELECT ename, hiredate
FROM   emp
WHERE  deptno = (SELECT deptno
                 FROM   emp
                 WHERE  UPPER(ename) = 'BLAKE'); --BLAKE 소문자인지 대문자인지 모름. 따라서 INITCAP
                 -- WHERE  INITCAP(ename) = 'Blake'
                 -- WHERE  LOWER(ename) = 'blake'
--  2. 평균 급여 이상을 받는 모든 사원에 대해서 사원 번호와 이름을 디스플레이하는 질의문을 생성. 
--     단 출력은 급여 내림차순 정렬하라
SELECT empno, ename
FROM   emp
WHERE  sal > (SELECT AVG(sal)
              FROM   emp);
ORDER BY sal DESC;

--  3. 보너스를 받는 어떤 사원의 부서 번호와 
--      급여에 일치하는 사원의 이름, 부서 번호 그리고 급여를 디스플레이하라.
SELECT ename, deptno, sal
FROM   emp
WHERE (deptno, sal) IN (SELECT deptno, sal
                        FROM   emp
                        WHERE  comm IS NOT NULL
                        AND    comm > 0);


--------------------------------------------------------------------------------
-- 데이터 조작어 (DML:Data Manpulation Language) **         -------------------
-- 1.정의 : 테이블에 새로운 데이터를 입력하거나 기존 데이터를 수정 또는 삭제하기 위한 명령어
-- 2.종류
-- 1) INSERT : 새로운 데이터 입력 명령어
-- 2) UPDATE : 기존 데이터 수정 명령어
-- 3) DELETE : 기존 데이터 삭제 명령어
-- 4) MERGE  : 두개의 테이블을 하나의 테이블로 병합하는 명령어
-- 5) SELECT
-- 트랜잭션
--  여러 개의 명령문을 하나의 논리적인 작업단위로 처리하는 기능
-- 트랜잭셔 관리 명령어
--  COMMIT : 트랜잭션의 정상적인 종료를 위한 명령어
--  ROLLBACK : 트랜잭션의 비정상적인 중단을 위한 명령어
-- 특징 ACID

-- 1) Insert
--단일 행 입력 : 한번에 하나의 행을 테이블에 입력하는 방법
-- INTO 절에 명시한 칼럼에 VALUES 절에서 지정한 칼럼 값을 입력
-- INTO 절에 칼럼을 명시하지 않으면 테이블 생성시 정의한 칼럼 순서와 동일한 순서로 입력
-- 입력되는 데이터 타입은 칼럼의 데이터 타입과 동일해야 함
-- 입력되는 데이터의 크기는 칼럼의 크기보다 작거나 동일해야 함
-- CHAR, VARCHAR2, DATE 타입의 입력 데이터는 단일인용부호(‘’)로 묶어서 입력

-- NULL 입력
-- 데이터를 입력하는 시점에서 해당 컬럼 값을 모르거나, 미확정
-- 묵시적인 방법
-- INSERT INTO 절에 해당 칼럼 이름과 값을 생략
-- 해당 칼럽에 NOT NULL 제약조건이 지정된 경우 불가능
-- 명시적 방법
-- VALUES 절의 칼럽 값에 NULL , ‘’ 사용


INSERT INTO dept VALUES (71, '인사'); --INSERT 안됨 명확하게 -칼럼명을 입력해줘야 한다.
INSERT INTO dept VALUES (71, '인사', '이대'); -- 칼럼 순서대로 INSERT 된다.
INSERT INTO dept (deptno, dname, loc) VALUES (72, '회계팀', '충정로');
INSERT INTO dept (deptno, dname, loc) VALUES (75, '자재팀', '신대방'); --PK 유일성 위반
INSERT INTO dept (deptno, loc, dname) VALUES (75, '충정로', '회계팀'); --칼럼명을 정해주면 순서가 바뀌어도 문제없음
INSERT INTO dept (deptno, loc) VALUES (73, '홍대'); -- dname은 null 로 INSERT
INSERT INTO dept (deptno, loc) VALUES (77, '당산'); -- dname에 not null 제약조건걸면 INSERT안됨 -INSERT가 안되면 제약조건 확인해라.

INSERT INTO professor (profno, name, position, hiredate, deptno)
            VALUES (9910, '박미선', '전임강사', TO_DATE('2006/01/01', 'YYYY/MM/DD'), 101);
INSERT INTO professor (profno, name, position, hiredate, deptno)
            VALUES (9920, '최윤식', '조교수', sysdate, 102);

DROP TABLE JOB3;
CREATE TABLE JOB3
( jobno NUMBER(2) PRIMARY KEY, --PK 이름 설정안해주면 시스템에서 알아서 해주는데 외우기 어렵다.
  jobname VARCHAR2(20)
  ) ;
INSERT INTO JOB3 VALUES (10, '학교');
INSERT INTO JOB3 VALUES (11, '공무원');
INSERT INTO JOB3 (jobname, jobno) VALUES ('공기업', 12);
INSERT INTO JOB3 (jobno, jobname) VALUES (13, '대기업');
INSERT INTO JOB3 (jobno, jobname) VALUES (14, '중소기업');

CREATE TABLE Religion
( religion_no   NUMBER(2) CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
  religion_name VARCHAR2(20)
) ;

INSERT INTO religion VALUES(10, '기독교');
INSERT INTO religion (religion_no, religion_name) VALUES (20, '카톨릭교');
INSERT INTO religion (religion_name, religion_no) VALUES ('불교', 30);
INSERT INTO religion (religion_no, religion_name) VALUES (40, '무교');




COMMIT;

ROLLBACK;


--------------------------------------------------------------------------------
----- 다중 행 입력                                                          -----
--------------------------------------------------------------------------------
-- 1. 생성된 TBL이용 신규 TBL 생성
CREATE TABLE dept_second
AS SELECT * FROM dept; --PK는 복사되지않는다

-- 2. TBL 가공 생성
CREATE TABLE emp20
AS SELECT empno, ename, sal*12 annsal
FROM      emp
WHERE     deptno = 20;

-- 3. TBL 구조만
CREATE TABLE dept30
AS SELECT deptno, dname
FROM      dept
WHERE     0 = 1; --FALSE 로 만들면 된다

-- 4. Column 추가
ALTER TABLE dept30
ADD(birth Date);

INSERT INTO dept30 VALUES(10, '중앙학교', sysdate);

-- 5. Column 변경
-- ORA-01441: cannot decrease column length because some value is too big --> 기존 Data보다 크기가 작으면 안 됨
ALTER TABLE dept30
MODIFY dname VARCHAR2(11);

ALTER TABLE dept30
MODIFY dname VARCHAR2(30);

ALTER TABLE dept30
MODIFY dname VARCHAR2(20);

-- 6. Column 삭제
ALTER TABLE dept30
DROP COLUMN dname;

-- 7. TBL 명 변경
RENAME dept30 TO dept35;

-- 8. TBL 제거
DROP TABLE dept35;

-- 9. TRUNCATE
TRUNCATE TABLE dept_second;

--|delete, drop, truncate 비교 암기 면접질문 ***
--+----------+------------+------------+---------+----------+------------+
--|          | 테이블정의 |  저장공간   |  데이터  | 작업속도 | SQL문 종류 |
--+----------+------------+------------+---------+----------+------------+
--|  DELETE  |    존재    |    유지    |   삭제   |   느림   |    DML     |
--| TRUNCATE |    존재    |    반납    |   삭제   |   빠름   |    DDL     |
--|   DROP   |    삭제    |    반납    |   삭제   |   빠름   |    DDL     |
--+----------+------------+------------+---------+----------+------------+  
--데이터베이스의 데이터를 관리하는 데 사용됩니다. DML 명령은 자동으로 커밋되지 않습니다.
--즉, DML 명령에 의한 변경은 데이터베이스에 영구적이지 않으므로 롤백할 수 있습니다.
--DML(INSERT, UPDATE, DELETE, SELECT) 명령어의 경우,
--조작하려는 테이블을 메모리 버퍼에 올려놓고 작업을 하기 때문에
--실시간으로 테이블에 영향을 미치는 것은 아니다.
--따라서 버퍼에서 처리한 DML 명령어가 실제 테이블에 반영되기 위해서는
--COMMIT 명령어를 입력하여 TRANSACTION을 종료해야 한다.


CREATE TABLE height_info
(sutdNo NUMBER(5),
 name   VARCHAR2(20),
 height NUMBER(5,2)
);
CREATE TABLE weight_info
(studNo NUMBER(5),
 name   VARCHAR2(20),
 weight NUMBER(5,2)
);

-- INSERT ALL(unconditional INSERT ALL) 명령문
-- 서브쿼리의 결과 집합을 조건없이 여러 테이블에 동시에 입력
-- 서브쿼리의 컬럼 이름과 데이터가 입력되는 테이블의 칼럼이 반드시 동일해야 함
-- data conversion에 유용
INSERT ALL
INTO height_info VALUES(studno, name, height)
INTO weight_info VALUES(studno, name, weight)
SELECT studno, name, height, weight --subquery 시작
FROM   student
WHERE  grade >= '2';


DELETE height_info;
DELETE weight_info;

-- 학생 테이블에서 2학년 이상의 학생을 검색하여 
-- height_info 테이블에는 키가 170보다 큰 학생의 학번, 이름, 키를 입력
-- weight_info 테이블에는 몸무게가 70보다 큰 학생의 학번, 이름, 몸무게를 
-- 각각 입력하여라

-- INSERT ALL 
-- [WHEN 조건절1 THEN
-- INTO [table1] VLAUES[(column1, column2,…)]
-- [WHEN 조건절2 THEN
-- INTO [table2] VLAUES[(column1, column2,…)]
-- [ELSE
-- INTO [table3] VLAUES[(column1, column2,…)]
-- subquery;

INSERT ALL
WHEN height > 170 THEN
    INTO height_info VALUES(studno, name, height)
WHEN weight > 70 THEN
    INTO weight_info VALUES(studno, name, weight)
SELECT studno, name, height, weight
FROM   student
WHERE  grade >= '2';

-- 데이터 수정 개요
-- UPDATE 명령문은 테이블에 저장된 데이터 수정을 위한 조작어
-- WHERE 절을 생략하면 테이블의 모든 행을 수정

--- Update 
-- 문1) 교수 번호가 9903인 교수의 현재 직급을 ‘부교수’로 수정하여라
UPDATE professor
SET    position = '부교수'
WHERE  profno = 9903;

-- 서브쿼리를 이용한 데이터 수정 개요
-- UPDATE 명령문의 SET 절에서 서브쿼리를 이용
-- 다른 테이블에 저장된 데이터 검색하여 한꺼번에 여러 칼럼수정
-- SET 절의 칼럼 이름은 서브쿼리의 칼럼 이름과 달라도 됨
-- 데이터 타입과 칼럼 수는 반드시 일치

-- 문2) 서브쿼리를 이용하여 학번이 10201인 학생의 학년과 학과 번호를
-- 10103 학번 학생의 학년과 학과 번호와 동일하게 수정하여라
UPDATE student
SET   (grade, deptno) = (SELECT grade, deptno
                         FROM   student
                         WHERE  studno = 10103)
WHERE  studno = 10201;

-- 데이터 삭제 개요
-- DELETE 명령문은 테이블에 저장된 데이터 삭제를 위한 조작어
-- WHERE 절을 생략하면 테이블의 모든 행 삭제

-- 문1) 학생 테이블에서 학번이 20103인 학생의 데이터를 삭제
DELETE
FROM  student
WHERE studno = 20103; --권장은 PK로 조건을 걸어준다. 예기치못한 문제 발생 예방

-- 서브쿼리를 이용한 데이터 삭제 개요
-- WHERE 절에서 서브쿼리 이용
-- 다른 테이블에 저장된 데이터를 검색하여 한꺼번에 여러행의 내용을 삭제 함
-- WHERE 절의 칼럼 이름은 서브쿼리의 칼럼 이름과 달라도 됨
-- 데이터 타입과 칼럼 수는 일치


-- 문2) 학생 테이블에서 컴퓨터공학과에 소속된 학생을 모두 삭제하여라. HomeWork --> Rollback
DELETE
FROM  student
WHERE deptno = (SELECT deptno
                FROM   department
                WHERE  dname = '컴퓨터공학과');
ROLLBACK;


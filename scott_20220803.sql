COMMENT ON COLUMN EMP.HIREDATE IS '입사일자';  --"SCOTT"."EMP"."HIREDATE" scott계정이므로 scott 생략가능
--comment 중요하다. 커뮤니케이션 비용. 

-- 문제점 : dept Table의 ROW 갯수 만큼 나옴
SELECT sysdate FROM dept;

-- 문제점 : dept Table의 ROW 갯수 만큼 나옴 --> DUAL
SELECT sysdate FROM DUAL;

-- DUAL테이블은 데이터 딕셔너리와 함께 Oracle에 의해 자동으로 생성되는 테이블 입니다. 
-- - DUAL테이블은 사용자 SYS의 스키마에 있지만 모든 사용자는 DUAL이라는 이름으로 엑세스 할 수 있습니다. 
-- - DUAL테이블은 VARCHAR2(1)으로 정의된 DUMMY라는 하나의 열이 있으며 값을 가지는 하나의 행도 포함되어 있습니다. 
-- - DUAL테이블은 사용자가 계산이나 사용자 함수등을 실행하고자 할 경우에 유용 합니다


-- WHERE절
-- 테이블에 저장된 데이터 중에서 원하는 데이터만 선택적으로 검색하는 기능
-- WHERE 절의 조건문은 칼럼 이름, 연산자, 상수, 산술 표현식을 결합하여 다양한 형태로 표현 가능
-- WHERE 절에서 사용하는 데이터 타입은 문자, 숫자, 날짜 타입 사용 가능
-- 문자와 날짜 타입의 상수 값은 작은 따옴표(‘’)로 묶어서 표현하고 숫자는 그대로 사용
-- 상수 값에서 영문자는 대소문자를 구별 

-- 학생 테이블에서 1학년 학생만 검색하여 학번, 이름, 학과 번호를 출력
SELECT studno, name, deptno 
FROM   student
WHERE  grade = 1;  -- grade는 VACHAR2 1은 숫자다. 실행계획을 보면 TO_NUMBER(GRADE)=1  <- 내부적으로 변환해줘서 비교가 가능해짐
--WHERE grade = '1'; 숫자와 변수 비교하면 변수가 숫자에 맞춰서 내부변환. TO NUMBER


-- 비교 연산자 
-- WHERE 절에서 숫자, 문자, 날짜의 크기나 순서를 비교하는 연산자
--<> 같지 않다

-- 학생 테이블에서 몸무게가 70kg 이하인 학생만 검색하여 학번, 이름, 학년, 학과번호, 몸무게를 출력하여라
SELECT studno , name , grade , deptno , weight 
FROM   student
WHERE  weight <= 70;

-- 논리 연산자
-- WHERE 절에서 여러 개의 조건을 결합할 경우
-- AND, OR, NOT과 같은 논리 연산자를 사용

-- 학생 테이블에서 1학년 이면서 몸무게가 70kg 이상인 학생만 검색하여 이름, 학년, 몸무게, 학과번호를 출력
SELECT name, grade, weight, deptno 
FROM   student
WHERE  grade = '1' 
AND    weight >= 70;

-- 학생 테이블에서 1학년이거나 몸무게가 70kg 이상인 학생만 검색하여 이름, 학년, 몸무게, 학과번호를 출력
SELECT name, grade, weight, deptno
FROM   student
WHERE  grade = '1'
OR     weight >= 70;

-- 학생 테이블에서 학과번호가 ‘101’이 아닌 학생의 학번과 이름과 학과번호를 출력
SELECT    studno, name, deptno
FROM      student
WHERE NOT deptno = 101;
--WHERE deptno != 101;


-- SQL 연산자 매우 중요하다. 네가지 다 알아두자.
-- SQL 연산자는 SQL 언어에만 제공
-- SQL 연산자는 모든 데이터 타입에 대해 사용 가능
-- BETWEEN a AND b  - a와 b사이 값 a,b 포함
-- IN(a,b,c,....,n) - a~n 중 하나라도 일치하면 참
-- LIKE             - 문자 패턴과 부분적으로 일치'%,_'하면 참
-- IS NULL          - NULL 이면 참

-- BETWEEN 연산자를 사용하여 -- 개발자들 많이 사용한다
-- 몸무게가 50kg에서 70kg 사이인 학생의 학번, 이름, 몸무게를 출력
SELECT studno, name, weight
FROM   student
WHERE  weight BETWEEN 50 AND 70;

-- BETWEEN 학생테이블에서 81년에서 83년도에 태어난 학생의 이름과 생년월일을 출력
SELECT name, birthdate
FROM   student
WHERE  birthdate BETWEEN '81/01/01' AND '83/12/31';

-- OR 연산자 / IN 연산자를 사용하여 101번 학과와102번 학과와 201번 학과 
-- 학생의 이름, 학년, 학과번호를 출력
SELECT name, grade, deptno
FROM   student
WHERE  deptno = 101
OR     deptno = 102
OR     deptno = 201;

SELECT name, grade, deptno
FROM   student
WHERE  deptno IN(101, 102, 201); --개발자들 많이쓴다.

-- 학생 테이블에서 성이 ‘김’씨인 학생의 이름, 학년, 학과 번호를 출력
SELECT name, grade, deptno
FROM   student
WHERE  name LIKE '김%';

-- 학생 테이블에서 마지막이름이 ‘경’인 학생의 이름, 학년, 학과 번호를 출력
SELECT name, grade, deptno
FROM   student
WHERE  name LIKE '%경';

-- 학생 테이블에서 이름이 3글자, 성은 ‘김’씨고 
-- 마지막 글자가 ‘영’으로 끝나는 학생의 이름, 학년, 학과 번호를 출력
SELECT name, grade, deptno
FROM   student
WHERE  name LIKE '김_영';


-- NULL 개념
-- NULL은 미확인 값이나 아직 적용되지 않은 값을 의미 Unknown or N/A(Not Applicable)
-- 0도 아니고 공백도 아님
-- NULL 값을 포함하는 연산의 경우 결과 값도 NULL이다. 모르는 데이터에 숫자를 더하거나 빼도 결과는 마찬가지로 모르는 데이터인 것과 같다.

-- 기본 키(primary key)
-- 릴레이션에 저장되는 튜플의 유일성을 보장하기 위하여 하나 이상의 속성으로 구성되는 식별자
-- 유일성(uniqueness)과 최소성(minimality)을 만족
-- * PK 특징 ****면접 단골손님. index와 비교도 
-- 1) 유일성 : 중복된 키 존재 불가능
-- 2) Not Null : Null 값 못넣는다
-- 3) 최소성 : 최소로 잡을 수 있으면 최소로 잡아두어라

-- NVL  NULL을 0 또는 다른 값으로 변환하기 위한 함수 --실무에서 많이씀, if문처럼 쓰임.
-- NVL( expression1, expression2)
-- expression1 NULL을 포함하는 칼럼 또는 표현식 -expression2 NULL을 대체하는 값 -둘다 동일한 데이터타입이어야함
-- NVL2 한수는 첫 번째 인수 값이 NULL이 아니면 두 번째 인수 값을 출력하고, 첫 번째 인수 값이 NULL이면 세 번째 인수 값을 출력하는 함수
-- NVL2(expression1, expression2, expression3) 
-- expression1 : NULL을 포함하는 칼럼 또는 표현식 -expression2 : expression1이 NULL이아닐때 반환되는 값 
-- expression3 : expression1이 NULL이면 대체되는 값

-- 문제점 : comm이 NULL일때 sal+comm도 NULL이면
SELECT empno, sal, comm, sal+comm --NULL과 다른값과 연산 결과는 NULL
FROM   emp;
-- 해결책 : comm이 NULL일때 NVL 또는 NVL2 사용
SELECT empno, sal, comm, sal+NVL(comm, 0); -- comm이 NULL일때 comm을 0으로  
FROM   emp;

-- COMM이 NULL인것 비교
SELECT * FROM emp
WHERE comm IS NULL;
-- COMM이 NULL아닌것 비교 
SELECT * FROM emp
WHERE comm IS NOT NULL;

-- 교수 테이블에서 보직수당이 없는 교수의 이름, 직급, 보직수당을 출력
SELECT name, position, comm
FROM   professor
WHERE  comm IS NULL;

--교수 테이블에서 급여에 보직수당을 더한 값은
--sal_com이라는 별명으로 출력(name, position, sal, comm) NULL해결
SELECT name, position, sal, comm, sal+NVL(comm, 0) "sal_com"
FROM   professor;

-- 102번 학과의 학생 중에서 1학년 또는 4학년 학생의 이름, 학년, 학과 번호를 출력
SELECT name, grade, deptno
FROM   student
WHERE  deptno = 102
AND    (grade IN('1', '4'));
--AND    (grade = '1' OR grade = '4'); --괄호 중요. 연산순서 달라지므로.

-- 1학년 이면서 몸무게가 70kg 이상인 학생의 집합 --> Table stud_heavy
CREATE TABLE stud_heavy
AS
    SELECT *
    FROM   student
    WHERE  weight >= 70
    AND    grade = '1'
; -- 기본적인 구조는 동일하게 만들어졌지만 주요제약조건은 같지 않다 (PK 없는거 확인)

-- 1학년 이면서 101번 학과에 소속된 학생(stud_101)
CREATE TABLE stud_101
AS
    SELECT *
    FROM   student
    WHERE  deptno = 101
    AND    grade = '1'
;


-- 집합 연산자   - 실무에서 많이쓰임
-- 테이블을 구성하는 행집합에 대해 테이블의 부분 집합을 결과로 반환하는 연산자
-- 합병 가능 : 집합 연산의 대상이 되는 두 테이블의 칼럼수가 같고, 대응되는 칼럼끼리 데이터 타입이 동일
-- UNION     두 집합에 대해 중복되는 행을 제외한 합집합
-- UNION ALL 두 집합에 대해 중복되는 행을 포함한 합집합
-- MINUS     두 집합간 차집합
-- INTERSECT 두 집합간 교집합

-- Union      구조가 다를 때(타입,칼럼수) 오류 발생
SELECT studno, name, userid
FROM   stud_heavy
UNION
SELECT studno, name
FROM   stud_101;

-- Union      중복 제거  --가장 많이 씀
SELECT studno, name
FROM   stud_heavy
UNION
SELECT studno, name
FROM   stud_101;

-- Union All  중복 허용
SELECT studno, name
FROM   stud_heavy
UNION  ALL
SELECT studno, name
FROM   stud_101;

-- Intersect --> 공통
SELECT studno, name
FROM   stud_heavy
INTERSECT
SELECT studno, name
FROM   stud_101;

-- Minus --> 차 (박동진 , 서재진) - (박미경, 서재진)
SELECT studno, name
FROM   stud_heavy
MINUS
SELECT studno, name
FROM   stud_101;



--데이터 조작어 (DML:Data Manpulation Language)란?
--테이블에 새로운 데이터를 입력하거나 기존 데이터를 수정 또는 삭제하기 위한 명령어


INSERT INTO emp VALUES 
(1000, '공현지', 'CLERK', 7902, TO_DATE('03-08-2022','dd-mm-yyyy'),2800, NULL, 20);
INSERT INTO emp VALUES 
(2000, 'test', 'CLERK', 7902, TO_DATE('03-08-2022','dd-mm-yyyy'),2800, NULL, 20);


-- 수정시
UPDATE EMP
SET    JOB = 'MANAGER'
             ,deptno = 10
WHERE  EMPNO = 1000; -- PK

COMMIT;

-- 삭제시
DELETE EMP --WHERE 안해주면 테이블 다 삭제된다.
WHERE  EMPNO = 2000; --PK를 넣어주어야 개발자가 의도치 않은 삭제가 발생을 방지.

COMMIT;

INSERT INTO dept VALUES(51,'회계팀','신촌')
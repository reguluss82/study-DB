--1. salgrade 데이터 전체 보기
SELECT * FROM salgrade;

--2. scott에서 사용가능한 테이블 보기
SELECT * FROM tab;

--3. emp Table에서 사번 , 이름, 급여, 업무, 입사일
SELECT empno, ename, sal, job, hiredate
FROM   emp;

--4. emp Table에서 급여가 2000미만인 사람 에 대한 사번, 이름, 급여 항목 조회
SELECT empno, ename, sal
FROM   emp
WHERE  sal < 2000;

--5. emp Table에서 80/02이후에 입사한 사람에 대한  사번,이름,업무,입사일 
SELECT empno, ename, job, hiredate
FROM   emp
WHERE  hiredate >= '80/02/01';

--6. emp Table에서 급여가 1500이상이고 3000이하 사번, 이름, 급여  조회
SELECT empno, ename, sal
FROM   emp
WHERE  sal BETWEEN 1500 AND 3000
--WHERE  sal >= 1500 AND sal <= 3000;

--7. emp Table에서 사번, 이름, 업무, 급여 출력 [ 급여가 2500이상이고
--   업무가 MANAGER인 사람]
SELECT empno, ename, job, sal
FROM   emp
WHERE  sal >= 2500 AND job = 'MANAGER';

--8. emp Table에서 이름, 급여, 연봉 조회 
   -- [단 조건은  연봉 = (급여+상여) * 12  , null을 0으로 변경]
SELECT ename, sal, (sal+NVL(comm, 0)) * 12 연봉
FROM   emp;

--9. emp Table에서  81/02 이후에 입사자들중 xxx는 입사일이 xxX
--  [ 전체 Row 출력 ] --> 2가지 방법 다
SELECT CONCAT(CONCAT(ename, '는 입사일이 '), hiredate)
FROM   emp
WHERE  hiredate >= '81/02/01';

SELECT ename || '는 입사일이 ' || hiredate
FROM   emp
WHERE  hiredate >= '81/02/01';

--10.emp Table에서 이름속에 T가 있는 사번,이름 출력
SELECT empno, ename
FROM   emp
WHERE  ename LIKE '%T%';


-- LAST_DAY , NEXT_DAY
-- LAST_DAY 해당 날짜가 속한 달의 마지막 날짜를 반환하는 함수
-- NEXT_DAY 해당 일을 기준으로 명시된 요일의 다음 날짜를 변환하는 함수
-- 한국 oracle에는 ‘day’ 에 월,화,수,목,금,토,일 을 넣는다.
-- 미국 oracle에는 ‘day’에 MON, TUE, WED, THU, FRI, SAT, SUN을 넣는다.


-- 오늘이 속한 달의 마지막 날짜와 다가오는 일요일의 날짜를 출력하여라
SELECT sysdate, LAST_DAY(sysdate), NEXT_DAY(sysdate, '일')
FROM   dual;
SELECT sysdate, LAST_DAY(sysdate), NEXT_DAY(sysdate, '토')
FROM   dual;

--날짜함수 ROUND, TRUNC
SELECT TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') NORMAL,
       TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') TRUNC,
       TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') ROUND
FROM   dual;


SELECT TO_CHAR(hiredate, 'YY/MM/DD HH24:MI:SS')   hiredate,
       TO_CHAR(ROUND(hiredate, 'dd'), 'YY/MM/DD') round_dd, -- 12시
       TO_CHAR(ROUND(hiredate, 'mm'), 'YY/MM/DD') round_mm, -- 16일
       TO_CHAR(ROUND(hiredate, 'yy'), 'YY/MM/DD') round_yy  -- 6월
FROM   professor;

-- TO_CHAR 함수
-- 날짜나 숫자를 문자로 변환하기 위해 사용 *** 실무많이쓰임
-- YYYY YY MM MON DD DY DAY

-- 학생 테이블에서 전인하 학생의 학번과 생년월일 중에서 년월만 출력하여라
SELECT studno, TO_CHAR(birthdate, 'YYMM') birthdate
--SELECT studno, TO_CHAR(birthdate, 'YY/MM') birthdate --필요한 서식대로 문자열 만들면된다.
--SELECT studno, TO_CHAR(birthdate, 'YY-MM') birthdate --필요한 서식대로 문자열 만들면된다.
FROM   student
WHERE  name = '전인하';

-- 데이터 타입의 변환
-- 숫자나 날짜 타입을 문자와 함께 결합하거나 보고서 양식에 맞추기 위해 주로 사용 
-- 묵시적인 데이터 타입 변환
-- 묵시적인 데이터 타입 변환은 정확한 연산을 위하여 오라클에서 데이터 타입을 내부적으로 변환하는 경우
-- A는 칼럼 B는 상수
-- A NUMBER = B VARCHAR2 또는 CHAR => B가 NUMBER 타입으로 변환
-- A VARCHAR2 또는 CHAR = B NUMBER => A가 NUMBER 타입으로 변환
-- 문자 타입의 순자 타입으로 변환은 문자열이 숫자로 구성도니 경우에만 가능


-- 명시적인 데이터 타입 변환
-- 사용자가 데이터 타입 변환 함수를 이용하여 명시적으로 데이터 타입을 변환

-- 숫자를 문자 형식으로 변환

-- TO_CHAR 함수
-- 날짜나 숫자를 문자로 변환하기 위해 사용
-- 날짜 출력 형식 변경

--보직수당을 받는 교수들의 이름, 급여, 보직수당,
--그리고 급여와 보직수당을 더한 값에 12를 곱한 결과를 연봉으로 출력하여라
SELECT name, sal, comm, TO_CHAR((sal+comm)*12, '9,999') anual_sal
FROM   professor
WHERE  comm IS NOT NULL;

-- TO_NUMBER 함수
-- 숫자로 구성된 문자열을 숫자 데이터로 변환하기 위한 함수

SELECT TO_NUMBER('123')
FROM   dual;

-- TO_DATE 함수
-- 숫자와 문자로 구성된 문자열을 날짜 테이터로 변환하는 함수


--student Table 주민등록번호에서 생년월일을 추출하여 ‘YY/MM/DD’ 형태로 출력하여라(중첩함수)
SELECT idnum, TO_CHAR(TO_DATE(SUBSTR(idnum, 1, 6), 'YYMMDD') , 'YY/MM/DD') BirthDate
FROM   student;
--SELECT idnum, TO_DATE(SUBSTR(idnum, 1, 6), 'YY/MM/DD') BirthDate
--FROM   student;

-- NVL 함수
-- NULL을 0 또는 다른 값으로 변환하기 위한 함수

-- 201번 학과 교수의 이름, 직급, 급여, 보직수당, 급여와 보직수당의 합계를 출력하여라.
-- 단, 보직수당이 NULL인 경우에는 보직수당을 0으로 계산한다

SELECT name, position, sal, comm, sal+comm,
       NVL(comm, 0) s1, NVL(sal+comm, 0) s2
FROM   professor
WHERE  deptno = 101;

-- NVL2 함수
-- 첫 번째 인수 값이 NULL이 아니면 두 번째 인수 값을 출력하고,
-- 첫 번째 인수 값이 NULL이면 세 번째 인수 값을 출력하는 함수

--102번 학과 교수중에서 보직수당을 받는 사람은 급여와 보직수당을 더한 값을 급여 총액으로 출력하여라. 
--단, 보직수당을 받지 않는 교수는 급여만 급여 총액으로 출력하여라.

SELECT name, position, sal, comm,
       NVL2(comm, sal+comm, sal) total -- if else 비슷
FROM   professor
WHERE  deptno = 102;

-- NULLIF 함수
-- 두 개의 표현식을 비교하여 값이 동일하면 NULL을 반환하고,
-- 일치하지 않으면 첫 번째 표현식의 값을 반환

-- 교수 테이블에서 이름의 바이트 수와 사용자 아이디의 바이트 수를 비교해서
-- 같으면 NULL을 반환하고
-- 같지 않으면 이름의 바이트 수를 반환
SELECT name, userid , LENGTHB(name), LENGTHB(userid),
       NULLIF(LENGTHB(name), LENGTHB(userid)) nullif_result
FROM   professor;

-- COALESCE 함수(일반 함수 NVL 확장 함수)
-- 인수중에서  NULL이 아닌 첫 번째 인수를 반환하는 함수

-- 문) 교수 테이블에서 보직수당이 NULL이 아니면 보직수당을 출력하고,
--     보직수당이 NULL이고 급여가 NULL이 아니면 급여를 출력,
--     보직수당과 급여가 NULL이면 0을 출력

SELECT name, comm, sal, COALESCE(comm, sal, 0) Co_result
FROM   professor;

-- DECODE 함수 ***** 실무에서 무조건 쓴다
-- 기존 프로그래밍 언어에서 IF문이나 CASE 문으로 표현되는 복잡한 알고리즘을
-- 하나의 SQL 명령문으로 간단하게 표현할 수 있는 유용한 기능 
-- DECODE 함수에서 비교 연산자는 ‘=‘만 가능

-- 문) 교수 테이블에서 교수의 소속 학과 번호를 학과 이름으로 변환하여 출력하여라. 
--     학과 번호가 101이면 ‘컴퓨터공학과’, 102이면 ‘멀티미디어학과’, 201이면 ‘전자공학과’, 
--     나머지 학과 번호는 ‘기계공학과’(default)로 변환
SELECT name, deptno,
       DECODE(deptno, 101, '컴퓨터공학과',
                      102, '멀티미디어학과',
                      201, '전자공학과',
                           '기계공학과'
             ) deptname
FROM   professor;

-- CASE 함수 - DECODE VS CASE 비교 중요
-- DECODE 함수의 기능을 확장한 함수 
-- DECODE 함수는 표현식 또는 칼럼 값이 ‘=‘ 비교를 통해 조건과 일치하는 경우에만 다른 값으로 대치할 수 있지만,
-- CASE 함수에서는 산술 연산, 관계 연산, 논리 연산과 같은 다양한 비교가 가능
-- 또한 WHEN 절에서 표현식을 다양하게 정의
-- 8.1.7에서부터 지원되었으며, 9i에서 SQL, PL/SQL에서 완벽히 지원 
-- DECODE 함수에 비해 직관적인 문법체계와 다양한 비교 표현식 사용

-- 문) DECODE 문제와 동일함.
SELECT name, deptno,
       CASE WHEN deptno = 101 THEN '컴퓨터공학과'
            WHEN deptno = 102 THEN '멀티미디어학과'
            WHEN deptno = 201 THEN '전자공학과'
            ELSE                   '컴퓨터공학과'
       END deptname
FROM   professor;

-- 교수 테이블에서 소속 학과에 따라 보너스를 다르게 계산하여 출력하여라.
-- 학과 번호별로 보너스는 다음과 같이 계산한다.
-- 학과 번호가 101이면 보너스는 급여의 10%, 102이면 20%, 201이면 30%, 나머지 학과는 0%
SELECT name, deptno, sal,
       CASE WHEN deptno = 101 THEN sal * 0.1
            WHEN deptno = 102 THEN sal * 0.2
            WHEN deptno = 201 THEN sal * 0.3
            ELSE                   sal * 0
       END bonus
FROM   professor;

---------------         Home Work           --------------------
--1. emp Table 의 이름을 대문자, 소문자, 첫글자만 대문자로 출력
SELECT ename, UPPER(ename), LOWER(ename), INITCAP(ename)
FROM   emp;

--2. emp Table 의  이름, 업무, 업무를 2-5사이 문자 출력
SELECT ename, job, SUBSTR(job, 2, 5)
FROM   emp;

--3. emp Table 의 이름, 이름을 10자리로 하고 왼쪽에 #으로 채우기
SELECT ename, LPAD(ename, 10, '#')
FROM   emp;

--4. emp Table 의  이름, 업무, 업무가 MANAGER면 관리자로 출력 (V)
SELECT ename, job, REPLACE(job, 'MANAGER', '관리자') 관리자
FROM   emp;

--5. emp Table 의  이름, 급여/7을 각각 정수, 소숫점 1자리. 10단위로   반올림하여 출력
SELECT ename, sal/7, ROUND(sal/7), ROUND(sal/7, 1), ROUND(sal/7, -1)
FROM   emp;

--6.  emp Table 의  이름, 급여/7을 각각 정수, 소숫점 1자리. 10단위로 절사하여 출력
SELECT ename, sal/7, TRUNC(sal/7), TRUNC(sal/7, 1), TRUNC(sal/7, -1)
FROM   emp;

--7. emp Table 의  이름, 급여/7한 결과를 반올림,절사,ceil,floor
SELECT ename, sal/7, ROUND(sal/7), TRUNC(sal/7), CEIL(sal/7), FLOOR(sal/7)
FROM   emp;

--8. emp Table 의  이름, 급여, 급여/7한 나머지
SELECT ename, sal, MOD(sal, 7)
FROM   emp;

--9. emp Table 의 이름, 급여, 입사일, 입사기간(각각 날자,월)출력
SELECT ename, sal, hiredate,
       ROUND(sysdate-hiredate) 입사기간날짜,
       ROUND(MONTHS_BETWEEN(sysdate, hiredate)) 입사기간월
FROM   emp;

--10.emp Table 의  job 이 'CLERK' 일때 10% ,'ANALYST' 일때 20% 
--                                 'MANAGER' 일때 30% ,'PRESIDENT' 일때 40%
--                                 'SALESMAN' 일때 50% 
--                                 그외일때 60% 인상 하여 
--   empno, ename, job, sal, 및 각 인상 급여를 출력하세요(CASE/Decode문 사용)
SELECT job, sal,
       DECODE(job, 'CLERK',     sal * 1.1,
                   'ANALYST',   sal * 1.2,
                   'MANAGER',   sal * 1.3,
                   'PRESIDENT', sal * 1.4,
                   'SALESMAN',  sal * 1.5,
                                sal * 1.6
             ) sal1
FROM   emp;

--------------------------------------------------------------------------------
-- 8장. 그룹함수
-- 테이블의 전체 행을 하나 이상의 컬럼을 기준으로 그룹화하여 그룹별로 결과를 출력하는 함수
-- 그룹함수는 통계적인 결과를 출력하는데 자주 사용
-- 그룹함수에서는 조건 키워드 HAVING으로. (일반함수는 WHERE) 중요!
-- COUNT MAX MIN SUM AVG

-- 1) COUNT 함수
-- 테이블에서 조건을 만족하는 행의 갯수를 반환하는 함수
-- COUNT(*)은 NULL 포함 모든 행의 개수
-- 일반적으로 NULL 제외

-- 문1) 101번 학과 교수중에서 보직수당을 받는 교수의 수를 출력하여라
SELECT COUNT(comm) -- null값을 가진 교수는 제외된다.
FROM   professor
WHERE  deptno=101;
-- 문2) 101번 학과 교수중에서 교수의 수를 출력하여라
SELECT COUNT(*) --*을 주면 null값을 따지지 않는다.
FROM   professor
WHERE  deptno=101;
-- 101번 학과 학생들의 몸무게 평균과 합계를 출력하여라

-- AVG, SUM 함수
-- 인수로 지정된 칼럼에 대해 조건을 만족하는 행중에서 NULL을 제외한 평균 값과 합계를 구하는 함수
-- 숫자 데이터 타입에만 사용 가능

SELECT AVG(weight), SUM(weight)
FROM   student
WHERE  deptno = 102;

-- STDDEV, VARIANCE 함수
-- 인수로 지정된 칼럼에 대해 조건을 만족하는 행을 대상으로 표준편차와 분산을 구하는 함수
-- 숫자 데이터 타입에만 사용 가능
-- NULL 은 연산에서 제외

-- 교수 테이블에서 급여의 표준편차와 분산을 출력
SELECT STDDEV(sal), VARIANCE(sal)
FROM   professor;


-- GROUP BY 절
-- 특정 칼럼 값을 기준으로 테이블의 전체 행을 그룹별로 나누기 위한 절
-- 예를 들어, 교수 테이블에서 소속 학과별이나 직급별로 평균 급여를 구하는 경우
-- GROUP BY 절에 명시되지 않은 칼럼은 그룹함수와 함께 사용할 수 없음*

-- GROUP BY 절 사용시 적용되는 규칙
-- 그룹핑 전에 WHERE 절을 사용하여 그룹 대상 집합을 먼저 선택
-- GROUP BY 절에는 반드시 칼럼 이름을 포함해야 하며 칼럼 별명은 사용할 수 없음*
-- 그룹별 출력 순서는 오름차순으로 정렬
-- SELECT 절에서 나열된 칼럼 이름이나 표현식은 GROUP BY 절에서 반드시 명시*

--HAVING 절과 WHERE 절의 성능 차이
--HAVING 절
--내부 정렬 과정에 의해 그룹화된 결과 집합에 대해 검색 조건 실행
--WHERE 절
--그룹화하기 전에 먼저 검색 조건 실행
--실무 데이터베이스 관점에서의 성능 차이
--WHERE 절의 검색 조건을 먼저 실행하는 방법이 효율적
--그룹화하는 행 집합을 줄여서 내부 정렬 시간을 단축
--SQL 처리 성능 향상


-- 학과별 학생들의 인원수, 몸무게 평균과 합계를 출력하여라
SELECT   deptno, COUNT(*), AVG(weight), SUM(weight)
FROM     student
GROUP BY deptno;

-- 교수 테이블에서 학과별로 교수 수와 보직수당을 받는 교수 수를 출력하여라
SELECT   deptno, COUNT(*), COUNT(comm)
FROM     professor
GROUP BY deptno;

-- 교수 테이블에서 학과별로 교수 수와 보직수당을 받는 교수 수를 출력하여라
-- 단 학과별 교수 수가 2명 이상인 학과만 출력
SELECT   deptno, COUNT(*), COUNT(comm)
FROM     professor
GROUP BY deptno
HAVING   COUNT(*) > 1;

-- 학생 수가 4명이상이고 평균키가 168이상인  학년에 대해서 학년, 학생 수, 평균 키, 평균 몸무게를 출력
-- 단, 평균 키와 평균 몸무게는 소수점 두 번째 자리에서 반올림 하고, 
-- 출력순서는 평균 키가 높은 순부터 내림차순으로 출력 --문제 해석잘해라. 
SELECT   grade, COUNT(*),
         ROUND(AVG(height), 1) avg_height,
         ROUND(AVG(weight), 1) avg_weight
FROM     student
GROUP BY grade
HAVING   COUNT(*) >= 4 AND ROUND(AVG(height)) > 168
ORDER BY avg_height DESC, avg_weight DESC;


-- MIN, MAX 함수
-- 인수로 지정된 칼럼에 대해 조건을 만족하는 행중에서 최소값과 최대 값을 구하는 함수
-- 사용법은 AVG, SUM 함수와 동일하나 문자 데이터 타입에도 사용 가능

-- 1. 최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
SELECT MIN(hiredate), MAX(hiredate)
FROM   emp;

-- 2. 부서별 최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
SELECT   deptno, MIN(hiredate), MAX(hiredate)
FROM     emp
GROUP BY deptno;

-- 다중 칼럼을 이용한 그룹핑
-- 하나 이상의 칼럼을 사용하여 그룹을 나누고, 그룹별로 다시 서브 그룹을 나눔
-- 전체 교수를 학과별로 먼저 그룹핑한 다음, 학과별 교수를 직급별로 다시 그룹핑하는 경우

-- 3. 부서별, 직업별 count & sum[급여]    (emp)
SELECT   deptno, job, COUNT(*), SUM(sal)
FROM     emp
GROUP BY deptno, job
ORDER BY deptno, job;

-- 4. 부서별 급여총액 3000이상 부서번호,부서별 급여최대    (emp)
SELECT   deptno, SUM(sal), MAX(sal)
FROM     emp
GROUP BY deptno
HAVING   SUM(sal) >= 3000;

-- 5. 전체 학생을 소속 학과별로 나누고, 같은 학과 학생은 다시 학년별로 그룹핑하여, 
--   학과와 학년별 인원수, 평균 몸무게를 출력, 
-- (단, 평균 몸무게는 소수점 이하 첫번째 자리에서 반올림 )  STUDENT
SELECT   deptno, grade, COUNT(*), ROUND(AVG(weight))
FROM     student
GROUP BY deptno, grade;



-- ROLLUP 연산자 -기사시험에서 나오긴 한다 - 실무에서 많이 사용하지는 않는다.
-- GROUP BY 절의 그룹 조건에 따라 전체 행을 그룹화하고 각 그룹에 대해 부분합을 구하는 연산자

-- 문) 소속 학과별로 교수 급여 합계와 모든 학과 교수들의 급여 합계를 출력하여라
SELECT   deptno, SUM(sal)
FROM     professor
GROUP BY ROLLUP(deptno);

-- 문2) ROLLUP 연산자를 이용하여 학과 및 직급별 교수 수, 학과별 교수 수, 전체 교수 수를 출력하여라
SELECT   deptno, position, COUNT(*)
FROM     professor
GROUP BY ROLLUP(deptno, position);

-- CUBE 연산자 -기사시험에서 나오긴 한다 - 실무에서 많이 사용하지는 않는다.
-- ROLLUP에 의한 그룹 결과와 GROUP BY 절에 기술된 조건에 따라 그룹 조합을 만드는 연산자

-- 문1) CUBE 연산자를 이용하여 학과 및 직급별 교수 수, 학과별 교수 수, 전체 교수 수를 출력하여라.
SELECT   deptno, position, COUNT(*)
FROM     professor
GROUP BY CUBE(deptno, position);


--------------------------------------------------------------------------------
------ 9-0 . DeadLock                                                 ----------------
--------------------------------------------------------------------------------
-- Transaction A
-- 1)
UPDATE emp
SET    sal   = sal * 1.1
WHERE  empno = 7369
;

UPDATE emp
SET    sal   = sal * 1.1
WHERE  empno = 7839
;

-- Transaction B
UPDATE emp
SET    comm  = 500
WHERE  empno = 7839
;

UPDATE emp
SET    comm  = 300
WHERE  empno = 7369
;



--------------------------------------------------------------------------------
------ 9 . JOIN                                                 ----------------
--------------------------------------------------------------------------------
-- 3 SPARC ANSI Modeling

-- 조인의 개념
-- 하나의 SQL 명령문에 의해 여러 테이블에 저장된 데이터를 한번에 조회할 수 있는 기능
-- 관계형 데이터베이스 분야의 표준
-- 두개 이상의 테이블을 ‘결합’ 한다는 의미

-- 조인의 필요성
-- 조인을 사용하지 않는 일반적인 예
-- 학생 주소록을 출력하기 위해 학생들의 학번, 이름, 소속학과 이름을 검색
-- 학생에 대한 정보 검색하는 단계 필요
-- 학생 정보에서 소속학과번호 정보를 추출하여 소속학과 이름을 검색하는 단계 필요

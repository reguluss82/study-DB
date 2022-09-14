-- 정렬(sorting)
-- SQL 명령문에서 검색된 결과는 테이블에 데이터가 입력된 순서대로 출력
-- 하지만, 데이터의 출력 순서를 특정 컬럼을 기준으로 오름차순 또는 내림차순으로 정렬하는 경우가 자주 발생
-- 여러 개의 칼럼에 대해 정렬 순서를 정하는 경우도 발생
-- ex)학생 테이블에서 학번순이나 교수 테이블에서 급여순으로 정렬하는 경우
-- 오름차순에서 NULL은 맨 마지막에 출력되지만, 내림차순에서는 NULL은 맨 처음 출력
-- OREDER BY : 칼럼이나 표현식을 기준으로 출력 결과를 정렬할 때 사용
-- ASC       : 오름차순으로 정렬하는 경우에 사용하며, 기본 값
-- DESC      : 내림차순으로 정렬하는 경우에 사용하며, 생략 불가능

-- 학생 테이블에서 학년을 오름차(내림차)순으로 정렬하여 이름, 학년, 전화번호를 출력
SELECT   name, grade, tel
FROM     student
--ORDER BY grade ASC; --기본ASC
ORDER BY grade DESC;

-- 모든 사원의 이름과 급여 및 부서번호를 출력하는데,  
-- 부서 번호로 결과를 정렬한 다음 급여에 대해서는 내림차순으로 정렬 -기본 부서번호오름차순
SELECT   ename, sal, deptno
FROM     emp
ORDER BY deptno, sal DESC;
--결과 -부서번호 오름차 각 부서번호 내에서 급여내림차

-- 부서 10과 30에 속하는 모든 사원의 이름과 부서번호를 이름의 알파벳 순으로 
-- 정렬되도록 질의문(emp)
SELECT   ename, deptno
FROM     emp
WHERE    deptno IN(10, 30)
ORDER BY ename;

-- 1982년에 입사한 모든 사원의 이름과 입사일을 구하는 질의문
SELECT ename, hiredate
FROM   emp
--WHERE hiredate BETWEEN '82/01/01' AND '82/12/31';
--WHERE  hiredate LIKE '82%'; -- 자동으로 형변환 해준다.
WHERE  TO_CHAR(hiredate, 'yymmdd') LIKE '82%'; --hiredate 를 char로 직접 형변환 해주고 비교
-- 보너스를 받는 모든 사원에 대해서 이름, 급여 그리고 보너스를 출력하는 질의문을 형성. 
-- 단 급여와 보너스에 대해서 급여/보너스순으로 내림차순 정렬
SELECT   ename, sal, comm
FROM     emp
WHERE    comm IS NOT NULL
AND      comm > 0
ORDER BY sal DESC, comm DESC;

-- 보너스가 급여의 20% 이상이고 부서번호가 30인 모든 사원에 대해서 
-- 이름, 급여, 보너스, 부서번호를 출력하는 질의문을 형성하라
SELECT ename, sal, comm, deptno
FROM   emp
WHERE  comm  >= sal*0.2
AND    deptno = 30;



--SQL 함수
-- 칼럼의 값이나 데이터 타입의 변경하는 경우
-- 숫자 또는 날짜 데이터의 출력 형식 변경하는 경우
-- 하나 이상의 행에 대한 집계(aggregation)를 하는 경우
--SQL 함수의 유형
--단일행 함수 : 테이블에 저장되어 있는 개별 행을 대상으로 함수를 적용하여 하나의 결과를 반환하는 함수
--복수행 함수 : 조건에 따라 여러 행을 그룹화하여 그룹별로 결과를 하나씩 반환하는 함수

-- 문자 함수
-- 문자 데이터를 입력하여 문자나 숫자를 결과로 반환하는 함수


-- INITCAP 함수 : 인수로 입력되는 칼럼이나 표현식의 문자열에서 첫 번째 영문자를 대문자로 변환하는 함수
-- LOWER 함수   : 인수로 입력되는 칼럼이나 표현식의 문자열 전체를 소문자로 변환하는 함수
-- UPPER 함수   : 문자열 전체를 대문자로 변환하는 함수

--대소문자 변환
SELECT ename, UPPER(ename), LOWER(ename), INITCAP(ename)
FROM   emp;

--소문자로 맞춰주기
-- scott이 있는것은 알지만 대문자인지 소문자인지 모를때 scott 조회방법
SELECT ename, sal, deptno
FROM   emp
WHERE LOWER(ename) = 'scott'; 

-- 학생 테이블에서 학번이 ‘20101’인 학생의 사용자 아이디를
-- 소문자와 대문자로 변환하여 출력
SELECT userid, LOWER(userid), UPPER(userid)
FROM   student
WHERE  studno =20101;


-- 문자열 길이 반환 함수
-- LENGTH 함수 : 인수로 입력되는 칼럼이나 표현식의 문자열의 길이를 반환하는 함수이고,
-- LENGTHB 함수 : 문자열의 바이트 수를 반환하는 함수이다.
-- utf-8 한글 3byte, utf-16 한글 2byte

--오라클 설치 시 문자 집합을 어떻게 설정했느냐에 따라 한글을 인식하는 Byte의 길이가 달라짐
--? KO16KSC5601이나 KO16MSWIN949는 한글 한 글자를 2Byte로 인식
--? UTF8이나 AL32UTF8의 경우 한글 한 글자를 3Byte로 인식 → 한글 정렬이 가능하다는 장점이 있음
--→ 아래 코드는 사용중인 문자 집합을 확인할 수 있음
---- SQL PLUS 접속
--SQL > SELECT * FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER LIKE '%CHARACTERSET%';
----*VARCHAR2
----영문데이터형과 테이블에 설정된 기본 언어타입을 저장할때 사용
----*NVARCHAR2
----유니코드지원을 위한 데이터형 VARCHAR2보다 동일 데이터 저장시 공간을 2배 사용 다국어 지원이 필요한 DB일경우에 사용하는 데이터형

--문자열 길이
SELECT dname, LENGTH(dname), LENGTHB(dname)
FROM   dept;

--한글 문자열 길이 Test --> Insert 안 된 표본 utf-8
INSERT INTO DEPT VALUES (59,'경경지원팀','충정로');
--오류 보고 -
--ORA-12899: value too large for column "SCOTT"."DEPT"."DNAME" (actual: 15, maximum: 14)


--------------------------------------------------------------------------
------ 내장함수                                          ------------------
--------------------------------------------------------------------------

-- CONCAT 함수
-- 두 문자열을 결합, || 와 동일
-- data conversion 때 많이 쓰임
SELECT CONCAT(CONCAT(name, '의 직책은 '), position) --이중함수
FROM   professor;

-- SUBSTR 함수
-- 특정 문자 또는 문자열의 일부를 추출하는 함수

-- 학생 테이블에서 1학년 학생의 주민등록 번호에서 생년월일과 태어난 달을 추출하여
-- 이름, 주민번호, 생년월일, 태어난 달을 출력하여라
--                                1번째 포함, 1번째부터 6번째까지
SELECT name, idnum, SUBSTR(idnum, 1, 6) birth_date, SUBSTR(idnum, 3, 2) birth_mon
FROM   student
WHERE  grade = 1;

-- INSTR 함수
-- 특정 문자가 출현하는 첫 번째 위치를 반환

-- 학과 테이블의 부서 이름 칼럼에서 ‘과’ 글자의 위치를 출력하여라
SELECT dname, INSTR(dname , '과')
FROM   department;

-- LPAD, RPAD 함수
-- 문자열이 일정한 크기가 되도록 왼쪽 또는 오른쪽에 지정한 문자를 삽입하는 함수

-- 교수테이블에서 직급 칼럼의 왼쪽에 ‘*’ 문자를 삽입하여 10바이트로 출력하고
-- 교수 아이다 칼럼은 오른쪽에 ‘+’문자를 삽입하여 12바이트로 출력하여라
SELECT position, LPAD(position, 10, '*') lpad_position,
       userid,   RPAD(userid, 12,'+')    rpad_userid
FROM   professor;


-- LTRIM, RTRIM 함수
-- 문자열에서 특정 문자를 삭제하기 위해 사용
-- 함수의 인수에서 삭제할 문자를 지정하지 않으면 문자열의 앞뒤 부분에 있는 공백 문자를 삭제
-- LTRIM : 왼쪽의 지정 문자를 삭제
-- RTRIM : 오른쪽의 지정 문자를 삭제
SELECT LTRIM('  abcdefg  ', ' ') FROM dual;

-- 학과 테이블에서 부서 이름의 마지막 글자인 ‘과’를 삭제하여 출력하여라
SELECT dname, RTRIM(dname, '과')
FROM   department;

------------------------------------------------------------------------
-------숫자 함수 ***----------------------------------------------------
------------------------------------------------------------------------
--1)ROUND 함수
-- 지정한 자리 이하에서 반올림한 결과 값을 반환하는 함수

-- 교수 테이블에서 101학과 교수의 일급을 계산(월 근무일은 22일)하여 소수점 첫째 자리와
-- 셋째 자리에서 반올림 한 값과 소숫점 왼쪽 첫째 자리에서 반올림한 값을 출력하여라
SELECT name, sal, sal/22, ROUND(sal/22), ROUND(sal/22, 2), ROUND(sal/22, -1)
FROM   professor
WHERE  deptno = 101;

--2)TRUNC 함수
-- 지정한 소수점 자리수 이하를 절삭한 결과 값을 반환하는 함수

-- 교수 테이블에서 101학과 교수의 일급을 계산(월 근무일은 22일)하여 소수점 첫째 자리와
-- 셋째 자리에서 절삭 한 값과 소숫점 왼쪽 첫째 자리에서 절삭한 값을 출력하여라
SELECT name, sal, sal/22, TRUNC(sal/22), TRUNC(sal/22, 2), TRUNC(sal/22, -1)
FROM   professor
WHERE  deptno = 101;

--3)MOD 함수 
-- MOD 함수는 나누기 연산후에 나머지를 출력하는 함수

-- 교수 테이블에서 101번 학과 교수의 급여를 보직수당으로 나눈 나머지를 계산하여 출력하여라
SELECT name, sal, comm, MOD(sal, comm)
FROM   professor
WHERE  deptno = 101;

--4)CEIL, FLOOR 함수
-- CEIL  : 지정한 숫자보다 크거나 같은 정수 중에서 최소 값을 출력하는 함수
-- FLOOR : 지정한 숫자보다 작거나 같은 정수 중에서 최대 값을 출력하는 함수

-- 19.7보다 큰 정수 중에서 가장 작은 정수와 12.345보다 작은 정수 중에서 가장 큰 정수를 출력하여라
SELECT CEIL(19.7), FLOOR(12.345)
FROM   dual;

------------------------------------------------------------------------
-----------날짜 함수 ***------------------------------------------------
------------------------------------------------------------------------
--날짜함수는 날짜 데이터 타입에 사용하는 함수
--날짜 계산은 날짜 데이터에 더하기, 빼기의 연산을 하는 기능


-- 1)날짜 + 숫자 = 날짜(날짜에 일수를 가산)
-- 교수 번호가 9908인 교수의 입사일을 기준으로 입사 30일 후와 60일 후의 날짜를 출력
SELECT name, hiredate, hiredate+30, hiredate+60
FROM   professor
WHERE  profno = 9908;

-- 2)날짜 - 숫자 = 날짜(날짜에 일수를 감산)
-- 

-- 3)날짜 - 날짜 = 일수(날짜에 날짜를 감산)
--
SELECT name, hiredate, hiredate+30, hiredate+60
FROM   professor
WHERE  profno = 9908;
-- 4)SYSDATE 함수
-- 시스템에 저장된 현재 날짜를 반환하는 함수로서, 초 단위까지 반환
SELECT sysdate
FROM   dual;

-- 5)MONTHS_BETWEEN : date1과 date2 사이의 개월 수를 계산
--   ADD_MONTHS : date에 개월 수를 더한 날짜 계산
-- 월 단위로 날짜 연산을 하는 함수 

-- 입사한지 120개월 미만인 교수의 교수번호, 입사일, 입사일로 부터 현재일까지의 개월 수,
-- 입사일에서 6개월 후의 날짜를 출력하여라
SELECT profno, hiredate,
       MONTHS_BETWEEN(SYSDATE,hiredate) working_day,
       ADD_MONTHS(hiredate, 6) hire_6after
FROM   professor
WHERE  MONTHS_BETWEEN(SYSDATE,hiredate) < 120;
--------------------------------------------------------------------------------
-- 9. JOIN *** -----------------------------------------------------------------
--------------------------------------------------------------------------------

--조인의 개념
-- 하나의 SQL 명령문에 의해 여러 테이블에 저장된 데이터를 한번에 조회할 수 있는 기능
-- 관계형 데이터베이스 분야의 표준
-- 두개 이상의 테이블을 ‘결합’ 한다는 의미

-- ex 1-1) 학번이 10101인 학생의 이름과 소속 학과 이름을 출력하여라 
SELECT studno, name, deptno
FROM   student
WHERE  studno = 10101;
-- ex 1-2)학과를 가지고 학과이름
SELECT dname
FROM   department
WHERE  deptno = 101;
-- ex 1-3) ex 1-1 + 1-2  한번에 조회  --> Join
SELECT studno, name,
            student.deptno, department. dname
FROM   student, department
WHERE  student . deptno = department . deptno;

-- 칼럼 이름의 애매모호성 해결방법
-- 서로 다른 테이블에 있는 동일한 칼럼 이름을 연결할 경우
-- 컬럼 이름앞에 테이블 이름을 접두사로 사용
-- 테이블 이름과 칼럼 이름은 점(.)으로 구분
-- SQL 명령문에 대한 구문분석 시간(parsing time) 줄임

-- 애매모호성 (ambiguously)
SELECT studno, name, deptno, dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;

-- 애매모호성 (ambiguously) --> 해결 : 별명 (alias)
SELECT s.studno, s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;

--  테이블 별명
-- 테이블 이름이 너무 긴 경우 사용
-- 테이블 이름을 대신하는 별명 사용 가능
-- FROM절에서 테이블 이름 다음에 공백을 두고 별명 정의
--  테이블 별명 작성 규칙
-- 테이블의 별명은 30자 까지 가능, 너무 길지 않게 작성
-- FROM 절에서 테이블 이름을 명시하고 공백을 둔 다음 테이블 별명지정
-- 하나의 SQL 명령문에서 테이블 이름과 별명을 혼용할 수 없다
-- 테이블의 별명은 해당 SQL 명령문 내에서만 유효


-- 전인하 학생의 학번, 이름, 학과 이름 그리고 학과 위치를 출력
SELECT s.studno, s.name, d.deptno, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.name   = '전인하';

-- 몸무게가 80kg이상인 학생의 학번, 이름, 체중, 학과 이름, 학과위치를 출력
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM   student s, department d
WHERE  s.deptno  = d.deptno
AND    s.weight >= 80;

-- 카티션 곱    - 알아두면 좋다.
-- 두 개 이상의 테이블에 대해 연결 가능한 행을 모두 결합
-- WHERE 절에서 조인 조건절을 생략하거나 잘못 설정한 경우
-- 대용량 테이블에서 발생할 경우 SQL명령문의 처리속도 저하
-- 개발자가 시뮬레이션을 위한 대용량의 실험용 데이터를 생성하기 위해 의도적으로 사용 가능
-- 오라클 9i 이후 버전에서 FROM절에 CROSS JOIN 키워드 사용

SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM   student s, department d; --7행*16행 개 행 조회됨 

SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM   student s CROSS JOIN department d; --cross join을 명시해둔것을 보아 의도적 카티션곱

-- EQUI JOIN *** 
-- 조인 대상 테이블에서 공통 칼럼을 ‘=‘(equal) 비교를 통해
-- 같은 값을 가지는 행을 연결하여 결과를 생성하는 조인 방법
-- SQL 명령문에서 가장 많이 사용하는 조인 방법
-- 자연조인을 이용한 EQUI JOIN
-- 오라클 9i 버전부터 EQUI JOIN을 자연조인이라 명명
-- WHERE 절을 사용하지 않고  NATURAL JOIN 키워드 사용
-- 오라클에서 자동적으로 테이블의 모든 칼럼을 대상으로 공통 칼럼을 조사 후, 내부적으로 조인문 생성

SELECT s.studno, s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;
-- Natual Join Convert Error --기사시험 문제가 이런식
SELECT s.studno, s.name, s.weight, d.dname, d.loc, d.deptno --d.deptno
FROM   student s
       NATURAL JOIN department d;
-- Natual Join Convert Error 해결
-- NATURAL JOIN시 조인 애트리뷰트에 테이블 별명을 사용하면 오류가 발생
SELECT s.studno, s.name, s.weight, d.dname, d.loc, deptno   --deptno
FROM   student s
       NATURAL JOIN department d;
       
-- NATURAL JOIN을 이용하여 교수 번호, 이름, 학과 번호, 학과 이름을 출력하여라
SELECT p.profno, p.name, deptno, d.dname
FROM   professor p
       NATURAL JOIN department d;
       
-- NATURAL JOIN을 이용하여 4학년 학생의 이름, 학과 번호, 학과이름을 출력하여라
SELECT s.name, d.dname, deptno, s.grade
FROM   student s
       NATURAL JOIN department d
WHERE  grade = '4';

-- JOIN ~ USING 절을 이용한 EQUI JOIN
-- USING절에 조인 대상 칼럼을 지정
-- 칼럼 이름은 조인 대상 테이블에서 동일한 이름으로 정의되어 있어야함

-- 문1) JOIN ~ USING 절을 이용하여 학번, 이름, 학과번호, 학과이름, 학과위치를
--      출력하여라
SELECT s.studno, s.name, deptno, dname, loc
FROM   student s JOIN department
       USING(deptno); --같은이름 사용해 조인하므로 alias명을 줄 필요가 없다.

-- EQUI JOIN의 3가지 방법을 이용하여 성이 ‘김’씨인 학생들의 이름, 학과번호, 학과이름을 출력
--1) WHERE 절을 사용한 방법 -가장 많이 사용하는 방법, 가독성도 좋다. 다른방법들은 시험에 나온다.
SELECT s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.name LIKE '김%';

--2) NATURAL JOIN절을 사용한 방법
SELECT s.name, deptno, d.dname
FROM   student s NATURAL JOIN department d --내부적으로 같은 컬럼명을 찾아 JOIN
WHERE  s.name LIKE '김%';

--3) JOIN~USING절을 사용한 방법
SELECT s.name, deptno, dname
FROM   student s JOIN department
       USING(deptno) --명시적으로 컬럼을 정해주는 효과
WHERE  s.name LIKE '김%';

--4) ANSI JOIN (INNER JOIN ~ ON) --자동화 처리하면 ANSI문법을 따르기때문에 알아두자.
SELECT s.name, d.deptno, d.dname
FROM   student s INNER JOIN department d
ON     s.deptno = d.deptno --WHERE 랑 헷갈린다.
WHERE  s.name LIKE '김%';

--------------------------------------------------------------------------------
-- NON-EQUI JOIN --** --실무에서 많이 쓰임 범위조인
-- ‘<‘,BETWEEN a AND b 와 같이 ‘=‘ 조건이 아닌 연산자 사용

-- 교수 테이블과 급여 등급 테이블을 NON-EQUI JOIN하여 
-- 교수별로 급여 등급을 출력하여라

CREATE TABLE "SCOTT"."SALGRADE2" 
   (   "GRADE" NUMBER(2,0), 
       "LOSAL" NUMBER(5,0), 
       "HISAL" NUMBER(5,0)
   );

SELECT p.profno , p.name , p.sal , s.grade
FROM   professor p , salgrade2 s
WHERE  p.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN -성능은 떨어지지만 무결성측면에서 이득
--EQUI JOIN의 조인 조건에서 양측 칼럼 값 중, 어느 하나라도 NULL 이면 ‘=‘ 비교 결과가 거짓이 되어
--NULL 값을 가진 행은 조인 결과로 출력 불가
--NULL 에 대해서 어떠한 연산을 적용하더라고 연산 결과는 NULL

--일반적인 EQUI JOIN 의 예 : 
--학생 테이블의 학과번호 칼럼과 부서 테이블의 부서번호 칼럼에 대한 EQUI JOIN ( student.deptno = department.deptno ) 한 경우
--학생 테이블의 deptno 칼럼이 NULL 인 경우 해당 학생은 결과로 출력되지 못함

--EQUI JOIN에서 양측 칼럼 값중의 하나가 NULL 이지만 조인 결과로 출력할 필요가 있는 경우
--OUTER JOIN 사용

--OUTER JOIN의 예 : 
--학생 테이블과 교수 테이블을 EQUI JOIN하여 학생의 지도 교수 이름 출력
--조건 : 지도 학생을 한 명도 배정받지 못한 교수 이름도 반드시 함께 출력

--(+) 기호를 사용한 OUTER JOIN
--WHERE 절의 조인 조건에서 OUTER JOIN 연산자인 ‘(+)’ 기호 사용
--조인 조건문에서 NULL 이 출력되는 테이블의 칼럼에 (+) 기호 추가

-- 학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수의 이름, 직급을 출력
-- 단, 지도교수가 배정되지 않은 학생이름도 함께 출력하여라.
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno; -- profno NULL 인 학생 출력되지 못함

SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno(+); --LEFT OUTER JOIN

--- ANSI OUTER JOIN
-- 1. ANSI LEFT OUTER JOIN
-- FROM 절의 왼쪽에 위치한 테이블이 NULL 을 가질 경우에 사용
-- WHERE절의 오른편에 ‘(+)’ 기호를 추가한 것과 동일
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       LEFT OUTER JOIN professor p
       ON s.profno = p.profno;
       
-- 학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수 이름, 직급을 출력
-- 단, 지도학생을 배정받지 않은 교수 이름도 함께 출력하여라
SELECT   s.name, s.grade, p.name, p.position
FROM     student s, professor p
WHERE    s.profno(+) = p.profno --RIGHT OUTER JOIN
ORDER BY p.profno;

--- ANSI OUTER JOIN
-- 2. ANSI RIGHT OUTER JOIN
-- FROM 절의 오른쪽에 위치한 테이블이 NULL 을 가질 경우, 사용
-- WHERE 절의 왼편’(+)’ 기호를 추가한 것과 동일

SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       RIGHT OUTER JOIN professor p
       ON s.profno = p.profno;

-- FULL OUTER JOIN
-- Oracle 지원안함 -> ANSI로

-- 학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수 이름, 직급을 출력
-- 단, 지도학생을 배정받지 않은 교수 이름 및
-- 지도교수가 배정되지 않은 학생이름 함께 출력하여라
SELECT   s.name, s.grade, p.name, p.position
FROM     student s, professor p
WHERE    s.profno(+) = p.profno(+) 
ORDER BY p.profno; -- 오류 ORA-01468: a predicate may reference only one outer-joined table

--FULL OUTER 모방  --> UNION
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno(+)
UNION
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno(+) = p.profno;

-- 3. ANSI FULL OUTER JOIN
-- LEFT OUTER JOIN 과 RIGHT OUTER JOIN 을 동시에 실행한 결과를 출력
SELECT s.studno, s.name, s.profno, p.name
FROM   student s
       FULL OUTER JOIN professor p
       ON s.profno = p.profno;
       
       
----------------          SELF JOIN            ---------------
--하나의 테이블내에 있는 칼럼끼리 연결하는 조인이 필요한 경우 사용
--조인 대상 테이블이 자신 하나라는 것 외에는 EQUI JOIN과 동일
--조직도 구성할때 많이 쓰임
SELECT c.deptno, c.dname, c.college, d.dname college_name
       --학과         학부
FROM   department c, department d
WHERE  c.college = d.deptno;

-- SELF JOIN --> 부서 번호가 201 이상인 부서 이름과 상위 부서의 이름을 출력
-- 결과 : xxx소속은 xxx학부
SELECT dept.dname || '의 소속은 ' || org.dname
FROM   department dept, department org
WHERE  dept.college = org.deptno
AND    dept.deptno >= 201;


-- 08/09 HomeWork
-- 1. 이름, 관리자명(emp TBL)  
SELECT w.ename, m.ename mgrname
FROM   emp w, emp m
WHERE  w.mgr = m.empno; --king은 관리자넘버 null이므로 출력안됨

-- 2. 이름,급여,부서코드,부서명,근무지, 관리자 명, 전체직원(emp ,dept TBL)
SELECT w.ename, w.sal, w.deptno, d.dname, d.loc, m.ename mgrname
FROM   emp w, emp m, dept d
WHERE  w.mgr    = m.empno(+) 
AND    w.deptno = d.deptno;

-- 3. 이름,급여,등급,부서명,관리자명, 급여가 2000이상인 사람
--    (emp, dept,salgrade TBL)
SELECT w.ename, w.sal, s.grade, d.dname, m.ename mgrname
FROM   emp w, emp m, salgrade s, dept d
WHERE  w.mgr = m.empno(+)
AND    w.deptno = d.deptno 
AND    w.sal BETWEEN s.losal(+) AND s.hisal(+)
AND    w.sal  >= 2000;

-- 4. 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력하는 SELECT 문장을 작성(emp ,dept TBL)
SELECT w.ename, d.dname, d.loc, w.comm
FROM   emp w, dept d
WHERE  w.deptno = d.deptno
AND    w.comm IS NOT NULL
AND    w.comm > 0;

-- 5. 사번, 사원명, 부서코드, 부서명을 검색하라. 사원명기준으로 오름차순정열(emp ,dept TBL)
SELECT   w.empno, w.ename, w.deptno, d.dname
FROM     emp w, dept d
WHERE    w.deptno = d.deptno
ORDER BY w.ename;
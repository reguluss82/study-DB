------------------------------------------------------------------------
---    PL/SQL의 개념 Oracle's Procedural Language extension to SQL
---   1. Oracle에서 지원하는 프로그래밍 언어의 특성을 수용한 SQL의 확장
---   2. PL/SQL Block내에서 SQL의 DML(데이터 조작어)문과 Query(검색어)문, 
---      그리고 절차형 언어(IF, LOOP) 등을 사용하여 절차적으로 프로그래밍을 가능하게 
---      한 강력한 트랜잭션 언어        - 트랜잭션 특징 질문 대답못함-> ACID 
---
---   1) 장점 
---      프로그램 개발의 모듈화 : 복잡한 프로그램을 의미있고 잘 정의된 작은 Block 분해
---      변수선언  : 테이블과 칼럼의 데이터 타입을 기반으로 하는 유동적인 변수를 선언
---      에러처리  : Exception 처리 루틴을 사용하여 Oracle 서버 에러를 처리
---      이식성    : Oracle과 PL/SQL을 지원하는어떤 호스트로도 프로그램 이동 가능
---      성능 향상 : 응용 프로그램의 성능을 향상 -서버에서 실행
---
---    PL/SQL 종류와 간단한 각각 설명 면접질문가능 function procedure trigger package
------------------------------------------------------------------------
-- FUNCTION : 실행환경에 반드시 하나의 값을 돌려줘야 되는 경우에 Function을 생성
-- 문1) 특정한 수에 세금을 7%로 계산하는 Function을 작성
---  조건 1 : Function --> tax
---  조건 2 : parameter --> p_num (급여) 
---  조건 3 : 계산을 통해 7% 값을 돌려줌 

CREATE OR REPLACE FUNCTION tax
    (p_num IN NUMBER)
RETURN NUMBER
IS
    v_tax NUMBER;
BEGIN
    v_tax := p_num * 0.07;  -- := 값을 넘겨준다
    RETURN (v_tax);
END;

----
SELECT tax(100) FROM dual; --SELECT 안에 함수호출해서 값 받아오기 가능
SELECT tax(200) FROM dual;

SELECT empno, ename, tax(sal)
FROM   emp;

------------------------------------------------------------
--  EMP 테이블에서 사번을 입력받아 해당 사원의 급여에 따른 세금을 구함.
-- 급여가 1000 미만이면 급여의 5%, 
-- 급여가 2000 미만이면 7%, 
-- 3000 미만이면 9%, 
-- 그 이상은 12%로 세율 적용
--- FUNCTION  emp_tax
-- 1) Parameter : 사번 p_empno
--      변수    :   v_sal(급여)
--                  v_pct(세율)
-- 2) 사번을 가지고 급여를 구함
-- 3) 급여를 가지고 세금 계산 
-- 4) 계산 된 값 Return number
-------------------------------------------------------------

CREATE OR REPLACE FUNCTION  emp_tax  -- 컴파일된 함수에도 주석을 넣고 싶으면 함수 안쪽에 주석문 넣으면 된다
    (p_empno IN emp.empno%TYPE )  -- 1) Parameter : 사번
RETURN NUMBER
IS
   v_sal emp.sal%TYPE;
   v_pct NUMBER(5,2);
   v_tax NUMBER;
BEGIN
  -- 2) 사번을 가지고 급여를 구함
   SELECT sal
   INTO   v_sal
   FROM   emp
   WHERE  empno = p_empno ;
   -- 3) 급여를 가지고 세금 계산 
   IF    v_sal <  1000  THEN
         v_pct := 0.05;
   ELSIF v_sal <  2000  THEN
         v_pct := 0.07;
   ELSIF v_sal <  3000  THEN
         v_pct := 0.09;
   ELSE      
         v_pct := 0.12;
   END IF;
   
   v_tax := v_sal * v_pct;
   
   RETURN (v_tax);
END emp_tax;

---   
SELECT ename, sal, EMP_TAX(empno) emp_rate
FROM   emp;


-----------------------------------------------------
--  Procedure up_emp 실행 결과
-- SQL> EXECUTE up_emp(1200);  -- 사번 
-- 결과 : 급여 인상 저장
--              시작문자
-- 변수 : v_job(업무)
          v_pct(세율)
-- 조건 1) job = SALE포함         v_pct : 10
--     2)       MAN               v_pct : 7  
--     3)                         v_pct : 5
--   job에 따른 급여 인상을 수행  sal = sal+sal*v_pct/100
-- 확인 : DB -> TBL
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE up_emp
    (p_empno IN emp.empno%TYPE)
IS
    v_job emp.job%TYPE;
    v_pct NUMBER(3);
BEGIN
    SELECT job
    INTO   v_job
    FROM   emp
    WHERE  empno = p_empno;
    
    IF     v_job LIKE 'SALE%' THEN
           v_pct := 10;
    ELSIF  v_job LIKE 'MAN%' THEN
           v_pct := 7;
    ELSE
           v_pct := 5;
    END IF;
    UPDATE emp
    SET    sal = sal + sal * v_pct / 100
    WHERE  empno = p_empno;
END;


----------------------------------------------------------
-- PROCEDURE Delete_emp
-- SQL> EXECUTE Delete_emp(5555);
-- 사원번호 : 5555
-- 사원이름 : 55
-- 입 사 일 : 81/12/03
-- 데이터 삭제 성공
--  1. Parameter : 사번 입력
--  2. 사번 이용해 사원번호 ,사원이름 , 입 사 일 출력
--  3. 사번 해당하는 데이터 삭제 
----------------------------------------------------------
CREATE OR REPLACE PROCEDURE Delete_emp
    (p_empno IN emp.empno%TYPE)
IS
    v_empno    emp.empno%TYPE;
    v_ename    emp.ename%TYPE;
    v_hiredate emp.hiredate%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT empno, ename, hiredate
    INTO   v_empno, v_ename, v_hiredate
    FROM   emp
    WHERE  empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_empno);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('입 사 일 : ' || v_hiredate);
    DELETE
    FROM  emp
    WHERE empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('데이터 삭제 성공');
END Delete_Emp;

EXEC Delete_emp(5555);
---------------------------------------------------------
-- 행동강령 : 부서번호 입력 해당 emp 정보  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(75);
--  조회화면 :    사번    : 5555
--                이름    : 홍길동

CREATE OR REPLACE PROCEDURE DeptEmpSearch1
    (p_deptno IN emp.deptno%TYPE)
IS
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT empno, ename
    INTO   v_empno, v_ename
    FROM   emp
    WHERE  deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || v_empno);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || v_ename);
END DeptEmpSearch1;

EXEC DeptEmpSearch1(40);
------------------------------------------------------------------------------------
-- %ROWTYPE
--  하나 이상의 데이터값을 갖는 데이터 타입으로 배열과 비슷한 역할을 하고 재사용이 가능하다.
--  %ROWTYPE 데이터 형과, PL/SQL테이블과 레코드는 복합 데이터 타입에 속한다.

-- 테이블이나 뷰 내부의 컬럼 데이터형, 크기, 속성 등을 그대로 사용 할 수 있다.
--  %ROWTYPE 앞에 오는 것은 데이터베이스 테이블 이름이다.
--  지정된 테이블의 구조와 동일한 구조를 갖는 변수를 선언 할 수 있다.
--  데이터베이스 컬럼들의 수나 DATATYPE을 알지 못할 때 편리 하다.
--  테이블의 데이터 컬럼의 DATATYPE이 변경 될 경우 프로그램을 재수정할 필요가 없다.
------------------------------------------------------------------------------------
-- 행동강령 : 부서번호 입력 해당 emp 정보  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(75);
--  조회화면 :    사번    : 5555
--                이름    : 홍길동
-- %ROWTYPE를 이용하는 방법
CREATE OR REPLACE PROCEDURE DeptEmpSearch2
    (p_deptno IN emp.deptno%TYPE)
IS
    v_emp emp%ROWTYPE;
--    v_empno emp.empno%TYPE;
--    v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT * -- * 행 1개만 출력한다. deptno가 10은 행이 여러개 이므로 오류발생 - 예외처리 필요
    INTO   v_emp
    FROM   emp
    WHERE  deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || v_emp.empno); -- 변수 테이블 v_emp의 empno
    DBMS_OUTPUT.PUT_LINE('이름 : ' || v_emp.ename);
END DeptEmpSearch2;


---------------------------------------------------------
-- 행동강령 : 부서번호 입력 해당 emp 정보  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(75);
--  조회화면 :    사번    : 5555
--                이름    : 홍길동
-- %ROWTYPE를 이용하는 방법
-- EXCEPTION 이용하는 방법
CREATE OR REPLACE PROCEDURE DeptEmpSearch3
    (p_deptno IN emp.deptno%TYPE)
IS
    v_emp emp%ROWTYPE;
--    v_empno emp.empno%TYPE;
--    v_ename emp.ename%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT * -- * 행 1개만 출력한다. deptno가 10은 행이 여러개 이므로 오류발생 - 예외처리 필요
    INTO   v_emp
--    SELECT empno, ename  
--    INTO   v_emp.empno, v_emp.ename -- empno, ename만 쓰려는 의도면 이런식으로
    FROM   emp
    WHERE  deptno = p_deptno;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || v_emp.ename);
    EXCEPTION -- Multi Row Error --> 실제 인출은 요구된 것보다 많은 수의 행을 추출
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : '  || TO_CHAR(SQLCODE)); --세가지 다 잘쓰인다
            DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : '  || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : ' || SQLERRM);
END DeptEmpSearch3;

EXEC DeptEmpSearch3(10);
------------------------------------------------------------------------------------
---- cursor    *** 면접이나 기사시험 질문
-- 1. 정의 : Oracle Server는 SQL문을 실행하고 처리한 정보를 저장하기 위해
--          "Private SQL Area" 이라고 하는 작업영역을 이용
--           이 영역에 이름을 부여하고 저장된 정보를 처리할 수 있게 해주는데 이를 CURSOR
-- 2. 종류 : Implicit(묵시적인) CURSOR -> DML문과 SELECT문에 의해 내부적으로 선언
--           Explicit(명시적인) CURSOR -> 사용자가 선언하고 이름을 정의해서 사용
-- 3. attribute
--   1) SQL%ROWCOUNT : 가장 최근의 SQL문에 의해 처리된 Row 수
--   2) SQL%FOUND    : 가장 최근의 SQL문에 의해 처리된 Row의 개수가 한 개 이상이면 True
--   3) SQL%NOTFOUND : 가장 최근의 SQL문에 의해 처리된 Row의 개수가 없으면 True
-- 4. 4단계 **
--   1) DECLARE 단계 : 커서에 이름을 부여하고 커서내에서 수행할 SELECT문을 정의함으로써 CURSOR를 선언
--   2) OPEN 단계    : OPEN문은 참조되는 변수를 연결하고, SELECT문을 실행
--   3) FETCH 단계   : CURSOR로부터 Pointer가 존재하는 Record의 값을 변수에 전달
--   4) CLOSE 단계   : Record의 Active Set을 닫아 주고, 다시 새로운 Active Set을만들어 OPEN할 수 있게 해줌
------------------------------------------------------------------------------------
---------------------------------------------------------
-- EXECUTE 문을 이용해 함수를 실행합니다.
-- SQL>EXECUTE show_emp3(7900);
---------------------------------------------------------
    
CREATE OR REPLACE PROCEDURE show_emp3
    (p_empno IN emp.empno%TYPE)
IS   -- DECLARE라고 써도 되는데 IS를 많이 쓴다
    -- 1.DECLARE 단계
    CURSOR emp_cursor IS
    SELECT ename, job, sal
    FROM   emp
    WHERE  empno LIKE p_empno||'%';
   
    v_ename emp.ename%TYPE;
    v_sal   emp.sal%TYPE;
    v_job   emp.job%TYPE;
   
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- 2) OPEN 단계
    OPEN emp_cursor; 
        DBMS_OUTPUT.PUT_LINE ( '이름   ' || '업무' || '급여' );
        DBMS_OUTPUT.PUT_LINE ( '---------------------------' );
    LOOP
        -- 3) FETCH 단계
        FETCH emp_cursor INTO  v_ename, v_job, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( v_ename || '   ' || v_job || '   ' || v_sal );
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE ( emp_cursor%ROWCOUNT || '개의 행 선택.' );
    -- 4) CLOSE 단계
    CLOSE emp_cursor;
END;

EXEC show_emp3(76);

--SELECT ename, job, sal
--FROM   emp
--WHERE  empno LIKE '76'||'%'; --숫자와 % CONCAT  하려고 ''로 문자열만들었다.
-----------------------------------------------------
-- Fetch 문 *** 시험에는 fetch 더 잘나온다. for보다
-- SQL> EXECUTE  Cur_sal_Hap (5);
-- CURSOR 문 이용 구현 
-- 부서만큼 반복 
-- 	부서명 : ACCOUNTING
-- 	인원수 : 5
-- 	급여합 : 5000
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE Cur_sal_Hap
    (p_deptno IN emp.deptno%TYPE)
IS
    CURSOR dept_sum IS
        SELECT dname, COUNT(*) cnt, SUM(sal) sumSal
        FROM   emp e, dept d
        WHERE  e.deptno = d.deptno
        AND    e.deptno LIKE p_deptno||'%'
        GROUP BY dname;
    
    vdname  dept.dname%TYPE;
    vcnt    NUMBER;
    vsumSal NUMBER;
BEGIN
    DBMS_OUTPUT.ENABLE;
    OPEN dept_sum;
    LOOP
        FETCH dept_sum INTO vdname, vcnt, vsumSal;
        EXIT WHEN dept_sum%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('부서명 : ' || vdname);
        DBMS_OUTPUT.PUT_LINE('인원수 : ' || vcnt);
        DBMS_OUTPUT.PUT_LINE('급여합 : ' || vsumSal);
    END LOOP;
    
    CLOSE dept_sum;
END Cur_sal_Hap;

EXEC Cur_sal_Hap(5);
--------------------------------------------------------------------------------        
-- FOR문을 사용하면 커서의 OPEN, FETCH, CLOSE가 자동 발생하므로 
-- 따로 기술할 필요가 없고, 레코드 이름도 자동
-- 선언되므로 따로 선언할 필요가 없다. --실무 많이쓰임
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ForCursor_sal_Hap
IS
CURSOR dept_sum IS
        SELECT d.dname, COUNT(e.empno) cnt, SUM(e.sal) sumSal
        FROM   emp e, dept d
        WHERE  e.deptno = d.deptno
        GROUP BY d.dname;
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- CURSOR를 FOR문에서 실행시킨다 --> OPEN, FETCH, CLOSE가 자동 발생
    FOR emp_list IN dept_sum -- emp_list <-- record : 테이블 로우 전체를 담아둘 수 있는 오라클 데이터타입
--    FOR emp_list IN (SELECT d.dname, COUNT(e.empno) cnt, SUM(e.sal) sumSal 
--                     FROM   emp e, dept d
--                     WHERE  e.deptno = d.deptno
--                     GROUP BY d.dname) -- CURSOR 선언하지 않고 CURSOR자리에 SELECT문을 SUBQUERY로 넣는 방법
    LOOP                     
        DBMS_OUTPUT.PUT_LINE('부서명 : ' || emp_list.dname);
        DBMS_OUTPUT.PUT_LINE('인원수 : ' || emp_list.cnt);
        DBMS_OUTPUT.PUT_LINE('급여합 : ' || emp_list.sumSal);
    END LOOP;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
END;

EXEC ForCursor_sal_Hap;
--------------------------------------------------------------------------------
-- EXCEPTION
-- 오라클 PL/SQL은 자주 일어나는 몇가지 예외를 미리 정의해 놓았으며, 
-- 이러한 예외는 개발자가 따로 선언할 필요가 없다.
-- 미리 정의된 예외의 종류
-- NO_DATA_FOUND    : SELECT문이 아무런 데이터 행을 반환하지 못할 때
-- DUP_VAL_ON_INDEX : UNIQUE 제약을 갖는 컬럼에 중복되는 데이터 INSERT 될 때
-- ZERO_DIVIDE      : 0으로 나눌 때
-- INVALID_CURSOR   : 잘못된 커서 연산
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PreException
    (v_deptno IN emp.deptno%TYPE)
IS
    v_emp emp%ROWTYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    
    SELECT empno, ename, deptno  --다중행이 결과값이라 오류가 난다.
    INTO   v_emp.empno, v_emp.ename, v_emp.deptno
    FROM   emp
    WHERE  deptno = v_deptno;
    
    DBMS_OUTPUT.PUT_LINE('사번 : '     || v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('이름 : '     || v_emp.ename);
    DBMS_OUTPUT.PUT_LINE('부서번호 : ' || v_emp.deptno);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('중복 데이터가 존재합니다.');
            DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX 에러 발생');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS에러 발생');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND에러 발생');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('기타 에러 발생');
END;

--------------------------------------------------------------------------------
----   Procedure : in_emp
----   Action    : emp Insert
----   1. Error 유형
---      1) DUP_VAL_ON_INDEX   : PreDefined --> Oracle 선언 Error
---      2) User Defined Error : lowsal_err (최저급여 -> 1500)
-- ename unique 제약조건 걸려있음
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE in_emp
    (p_name IN emp.ename%TYPE,  -- 1) DUP_VAL_ON_INDEX
     p_sal  IN emp.sal%TYPE,    -- 2) 개발자 Defined Error : lowsal_err (최저급여 -> 1500)
     p_job  IN emp.job%TYPE
     )
IS
    v_empno    emp.empno%TYPE;
    lowsal_err EXCEPTION; -- 개발자 Defined Error  - lowsal_err을 EXCEPTION 객체로 선언
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT MAX(empno) + 1
    INTO   v_empno
    FROM   emp;
    
    IF p_sal >= 1500 THEN
        INSERT INTO emp(empno,   ename,  sal,   job,   deptno, hiredate)
        VALUES         (v_empno, p_name, p_sal, p_job, 10,     SYSDATE);
    ELSE
        RAISE lowsal_err; -- Block에 RAISE문을 써서 명시적으로 EXCEPTION을 발생시키는 방법
                          -- BEGIN Section에서 EXCEPTION이 발생하면 EXCEPTION Section의
                          -- 해당 EXCEPTION 처리부로 제어가 넘어간다.
    END IF;
    
    EXCEPTION
        -- Oracle PreDefined Error
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('중복 데이터 ename 존재합니다.');
            DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX 에러 발생');
        -- 개발자 Defined Error
        WHEN lowsal_err THEN
            DBMS_OUTPUT.PUT_LINE('ERROR!!! = 지정한 급여가 너무 적습니다. 1500이상으로 다시 입력하세요.');
            
END in_emp;

EXEC in_emp('김유신', 7000, '장군');
EXEC in_emp('김유신', 3000, '화랑');
EXEC in_emp('김유신', 1300, '장군');

--------------------------------------------------------------------------------
--  20220817 HW1
-- 1. 파라메타 : (p_empno, p_ename  , p_job,p_MGR ,p_sal,p_DEPTNO )
-- 2. emp TBL에  Insert_emp Procedure 
-- 3. v_job =  'MANAGER' -> v_comm  := 1000;
--              아니면                 150; 
-- 4. Insert -> emp 
-- 5. 입사일은 현재일자
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Insert_emp
    (p_empno  IN emp.empno%TYPE,
     p_ename  IN emp.ename%TYPE,
     p_job    IN emp.job%TYPE,
     p_mgr    IN emp.mgr%TYPE,
     p_sal    IN emp.sal%TYPE,
     p_deptno IN emp.deptno%TYPE)
IS
    v_comm emp.comm%TYPE;
BEGIN
    
    IF   p_job = 'MANAGER' THEN v_comm := 1000;
    ELSE                        v_comm := 150;
    END IF;
    
    INSERT INTO emp (empno,   ename,   job,   mgr,   hiredate, sal,   comm,   deptno)
             VALUES (p_empno, p_ename, p_job, p_mgr, SYSDATE,  p_sal, v_comm, p_deptno);
    COMMIT;
END;        
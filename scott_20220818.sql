---------------------------------------------------------------------------------------
-----    Package
-- 자주 사용하는 프로그램과 로직을 모듈화
-- 응용 프로그램을 쉽게 개발 할 수 있음
-- 프로그램의 처리 흐름을 노출하지 않아 보안 기능이 좋음
-- 프로그램에 대한 유지보수 작업이 편리
-- 같은 이름의 프로시저와 함수를 여러 개 생성
----------------------------------------------------------------------------------------

--- 1.Header -->  역할 : 선언 (Interface 역할) --컴파일은 헤더부터하고 그다음에 바디
--    여러 PROCEDURE 선언 가능
CREATE OR REPLACE PACKAGE emp_info AS
    PROCEDURE all_emp_info;  -- 모든 사원의 사원 정보
    PROCEDURE all_sal_info;  -- 부서별 급여 정보
    -- 특정 부서의 사원 정보
    PROCEDURE dept_emp_info (p_deptno IN emp.deptno%TYPE); -- 파라미터 타입(emp.deptno%TYPE) BODY 구현부와 일치해야함.
    
END emp_info;

-- 2.Body 역할 : 실제 구현
CREATE OR REPLACE PACKAGE BODY emp_info AS
-----------------------------------------------------------------
    -- 모든 사원의 사원 정보(사번, 이름, 입사일)
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 각각 줄 바꾸어 사번,이름,입사일 
-----------------------------------------------------------------
    PROCEDURE all_emp_info
    IS
    CURSOR emp_cursor IS
        SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD') hiredate
        FROM   emp
        ORDER BY hiredate;
    BEGIN
        DBMS_OUTPUT.ENABLE;
        FOR emp IN emp_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('사  번 : ' || emp.empno);
            DBMS_OUTPUT.PUT_LINE('이  름 : ' || emp.ename);
            DBMS_OUTPUT.PUT_LINE('입사일 : ' || emp.hiredate);
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
    END all_emp_info;

-----------------------------------------------------------------------------------------
    -- 모든 사원의 부서별 급여 정보
    -- 1. CURSOR  : empdept_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 각각 줄 바꾸어 부서명 ,전체급여평균 , 최대급여금액 , 최소급여금액
----------------------------------------------------------------
    PROCEDURE all_sal_info
    IS
    CURSOR empdept_cursor IS
        SELECT d.dname dname, ROUND(AVG(e.sal), 3) avg_sal, MAX(e.sal) max_sal, MIN(e.sal) min_sal
        FROM   emp e, dept d
        WHERE  e.deptno = d.deptno
        GROUP BY d.dname;
    BEGIN
        DBMS_OUTPUT.ENABLE;
        FOR empdept IN empdept_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('부   서   명 : ' || empdept.dname);
            DBMS_OUTPUT.PUT_LINE('전체급여평균 : ' || empdept.avg_sal);
            DBMS_OUTPUT.PUT_LINE('최대급여금액 : ' || empdept.max_sal);
            DBMS_OUTPUT.PUT_LINE('최소급여금액 : ' || empdept.min_sal);
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
    END all_sal_info;
    
-----------------------------------------------------------------
    --특정 부서의 해당하는 사원 정보 PROCEDURE dept_emp_info
    -- parameter(p_deptno)
    -- 1. CURSOR  : empindept_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 특정 부서의 해당하는 사원 사번,이름, 입사일 
-----------------------------------------------------------------
    PROCEDURE dept_emp_info
        (p_deptno emp.deptno%TYPE)
    IS
    CURSOR empindept_cursor IS
        SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD') hiredate
        FROM   emp
        WHERE  deptno = p_deptno
        ORDER BY hiredate;
    BEGIN
        DBMS_OUTPUT.ENABLE;
        FOR empindept IN empindept_cursor
        LOOP
            DBMS_OUTPUT.PUT_LINE('사  번 : ' || empindept.empno);
            DBMS_OUTPUT.PUT_LINE('이  름 : ' || empindept.ename);
            DBMS_OUTPUT.PUT_LINE('입사일 : ' || empindept.hiredate);
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
    END dept_emp_info;

END emp_info;

-- BODY 의 PROCEDURE 실행
EXEC emp_info.dept_emp_info(50);
SET SERVEROUTPUT ON; -- 스크립트출력에 DBMS_OUTPUT.PUT_LINE을 출력하기 위해 사용





-------------------------------------------------------------------------------------
--데이터모델링  
--개념 -> 물리
--Entity -> table
--attribute -> column

-- CRUD 메트릭스(Matrix)
--  정의 : 시스템 개발 시 프로세스(또는 메소드, 클래스)와 DB 에 저장되는 데이터 사이의
--         Dependency 를 나타내기 위한 Matrix
--  업무 프로세스와 데이터간 상관 분석표에서 행은 업무 프로세스로,
--  열은 엔티티 타입으로 구성되며 행과 열이 만나는 교차점에 발생 및 이용에 대한
--  생성(Create), 이용(Read), 수정(Update), 삭제(Delete) 상태를 표시

--  작성
--    각 프로세스 마다 사용하는 엔티티를 표기하고
--    각각의 프로세스가 해당 엔티티를 생성(C), 조회(R), 변경(U), 삭제(D)
--    하는가에 대한 여부를 표기

-- ERD(Entity Relation Diagram)
-- master data, tansaction data 비교 면접 질문

-------------------------------------------------------------------------------------
-- 정규화(Normalization)  --기사시험용
-- 정의 : 관계형 데이터 모델에서 데이터의 중복성을 제거하여 이상 현상을 방지하고
--        데이터의 일관성과 정확성을 유지하기 위한 과정

--이상현상의 종류
--  1. 삭제 이상
--   한 튜플을 삭제함으로써 유지해야 할 정보까지 삭제되는
--   연쇄삭제(triggered deletion) 현상이 일어나게 되어 
--   정보손실이 발생하게 되는 현상
--  2. 삽입 이상
--   어떤 데이터를 삽입하려고 할 때 불필요하고 원하지 않는
--   데이터도 함께 삽입해야 하고 그렇지 않으면 삽입이 되지않는 현상
--  3. 갱신 이상 
--   중복된 튜플 중 일부 튜플의 어트리뷰트 값만을 갱신하여
--   정보의 모순성이 생기는 현상

-- 함수적 종속성의 개념 및 절차
--  1. 함수적 종속성(FD: Functional Dependency)의 개념
--      데이터들이 어떤 기준 값에 의해 종속되는 현상을 지칭
--      기준 값은 결정자(determinant), 종속되는 값은 종속자/의존자 (dependent)
--      부분 함수 종속성(partial functional dependency)은 한 개 또는 그 이상의 속성이
--      Primary key(PK) 의 일부분에 함수적으로 종속하는 것
--  2. 함수적 종속성의 사례
--       이름, 주소, 성별은 주민등록 번호 속성에 종속됨
--       표기법: 주민등록번호 → [이름, 주소, 성별]
--  종속관계 확인할때 보통 코드 -> 이름 

-- 함수종속도(암스트롱의 함수종속규칙)
--가. 함수적 종속성의 추론규칙
--  1) 암스트롱의 추론 규칙들
--    1. 반사 규칙 (재귀규칙) : 부분집합(⊆, ⊇)의 성질(Subset Property) // Y ⊆ X이면, X → Y이다.
--    2. 첨가(Augmentation) 규칙 : 증가 
--          X → Y이면, XZ → YZ이다. (표기: XZ는 X∪Z를 의미)
--    3. 이행(Transitivity) 규칙 :
--          X → Y이고 Y → Z이면, X → Z이다.
--- A1, A2, A3는 Sound하고 Complete 추론 규칙 집합을 형성한다.
--- 건전성 특성: A1, A2, A3로부터 유도된 모든 함수적 종속성은 모든 릴레이션 상태에 대해 성립함.
--  2) 추가적으로 유용한 유도된 추론 규칙들
--    4. 분해(Decomposition) 규칙 : 
--          X → YZ이면, X → Y이고 X → Z이다.
--    5. 결합(Union) 규칙 : 연합 
--          X → Y이고 X → Z이면, X → YZ이다.
--    6. 의사이행(Pseudotransivity) 규칙 : 가이행 
--          X → Y이고 WY → Z이면, WX → Z이다.
--- 완전성 특성: 위의 세 규칙 뿐 아니라 다른 추론 규칙들도 A1, A2, A3만으로부터 추론 가능하다.


--정규화(Normalization)의 절차 -- 보통 3차까지 함.
--  기초적 정규화
--   1차 정규화(1NF)
--     반복되는 속성 제거 (PK도출)
--     Relation R에 속한 모든 도메인이 원자값(atomicvalue)만으로 되어있는 경우 
--   2차 정규화(2NF)
--     부분함수 종속성 제거
--     Relation R이 1NF이고 Relation의 기본 키가 아닌 속성들이 기본 키에 완전히 함수적으로 종속할 경우
--     복합키가 없으면 2차 정규화 만족
--   3차 정규화(3NF)
--     이행함수 종속성 제거
--     Relation R이 2NF이고 기본 키가 아닌 모든 속성들이 기본 키에 대하여 이행적 함수 종속성(Transitive FD)의
--     관계를 가지지 않는 경우, 즉 기본 키 외의 속성들간에 함수적 종속적을 가지지 않는 경우
--   BCNF(Boyce/CoddNF)
--     결정자함수 종속성 제거
--     Relation R의 모든 결정자가 후보 키일 경우
--   4차 정규화(4NF)
--?    다중값 종속성 제거
--?    BCNF를 만족시키면서 다중값 종속을 포함하지 않는 경우
 
 
-- 예시 사례 -실제로 풀어보도록하자
-- 관계형 DB 설계 시 테이블스키마(R)와 함수종속성(FD)이 아래와 같을 때 질문에 답하시오.
-- R(A, B, C, D, E, F, G, H, I)
-- FD : A -> B, A -> C, D -> E, AD -> I, D -> F, F -> G, AD -> H
-- 1) 함수종속도표(FDD : Functional Dependency Diagram) 작성
-- 2) 스키마 R(A, B, C, D, E, F, G, H, I)에서 Key 값을 찾아내고 그 과정 설명
-- 3) 2차 정규형 테이블 설계, 각 테이블의 Key 값 명시
-- 4) 3차 정규형 테이블 설계, 각 테이블의 Key 값 명시

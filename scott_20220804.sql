SELECT * FROM emp;

--PROCEDURE
--실무에서 DML작업에 많이 쓴다.
--일련의 쿼리를 마치 하나의 함수처럼 실행하기 위한 쿼리의 집합이며
--일련의 작업을 정리한 절차입니다.
--보통 단독으로 실행해야 할 작업을 위임받았을 때 사용합니다.
--결과값을 반환하거나 반환하지 않을 수 있다.
--매개변수를 입력,출력,입출력 형식으로 받을 수 있습니다.
--IN/OUT 매개변수가 있는 프로시저
-- IN 매개변수 : 프로시저 내부에서 사용될 변수
-- OUT 매개변수 : 프로시저 호출부(외부)에서 사용될 값을 담아줄 변수
--클라이언트(화면)에서 값을 건네받아 서버에서 작업을 한 뒤 클라이언트에게 전달합니다.
--즉, 서버에서 실행이 되어 속도면에서 빠른 성능을 보여줍니다.

CREATE OR REPLACE PROCEDURE Dept_Insert --OR REPLACE 없으면 만들고 있으면 교체하라
 (vdeptno IN dept.deptno%TYPE, --그 테이블 칼럼의 타입을 따라가겠다
  vdname  IN dept.dname%TYPE,
  vloc    IN dept.loc%TYPE)
IS 
 -- 변수명
BEGIN
    INSERT INTO dept VALUES(vdeptno, vdname, vloc); -- 원래 값이 있는 행에 실행하면 오류
    COMMIT;
END;


CREATE OR REPLACE PROCEDURE Emp_Info2
(p_empno IN emp.empno%TYPE,
 p_ename OUT emp.ename%TYPE,
 p_sal   OUT emp.sal%TYPE )
IS
    --%TYPE 데이터형 변수 선언
  v_empno emp.empno%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- %TYPE 데이터형 변수 사용
    SELECT empno, ename, sal
    INTO   v_empno, p_ename, p_sal
    FROM   emp
    WHERE  empno = p_empno;
    -- 결과값 출력 --chr(10) ASKII code로
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_empno || CHR(10) || CHR(13) || '줄바뀜');
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || p_ename);
    DBMS_OUTPUT.PUT_LINE('사원급여 : ' || p_sal );
END;

--Function
--실무에서 간단한 계산에 사용을 많이함.
--하나의 특별한 목적의 작업을 수행하기 위해 독립적으로 설계된 코드의 집합입니다.
--즉, 함수가 여러 작업을 위한 기능이라면 프로시저는 작업을 정리한 절차입니다.
--보통 로직을 도와주는 역할이며, 간단한 계산, 수치 등을 나타낼 때 사용합니다.
--프로시저와 다르게 OUT 변수를 사용하지 않아도 실행 결과를 되돌려 받을 수 있다.(RETURN)
--매개변수를 입력 형식으로만 받을 수 있습니다.
--클라이언트(화면)에서 값을 건네 받고 서버에서 필요한 값을 가져와서 클라이언트에서 작업을 하고 반환합니다.
--즉, 클라이언트(화면)에서 실행이 되어 프로시저보단 속도가 느립니다.

CREATE OR REPLACE FUNCTION func_sal --  FUNCTION은 리턴값 반드시 있으며 반드시 하나다.
    (p_empno IN NUMBER)
RETURN NUMBER
IS
    vsal emp.sal%TYPE; -- emp table에 sal와 같은 타입
BEGIN
    UPDATE emp SET sal=sal*1.1
    WHERE empno=p_empno;
    COMMIT;
    SELECT sal INTO vsal --조회후 저장하려면 INTO 써야
    FROM emp
    WHERE empno=p_empno;
    RETURN vsal;
END;



SELECT func_sal(7902) FROM dual; --오류. 설명하려면 깊어짐.일단 eclipse로
      
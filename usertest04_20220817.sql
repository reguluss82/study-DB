-- Read X --> 권한없음
SELECT * FROM scott.emp; --ORA-00942: table or view does not exist
-- Read OK --> scott가 권한 할당
SELECT * FROM scott.student;
-- Read X --> scott가 Read 권한만 할당
UPDATE scott.student
SET    userid = 'kkk'
WHERE  studno = 10101;

-- 3. scott에 있는 student TBL에 Read 권한 usertest03 주세요 --> X(권한없음)
GRANT SELECT ON scott.student TO usertest03;

-- Read OK --> scott가 권한 할당
SELECT * FROM scott.emp;

-- 4. scott에 있는 emp TBL에 Read 권한 usertest03 주세요 -->

-- Read OK --> scott가 권한 할당
SELECT * FROM scott.dept;

GRANT SELECT ON scott.dept TO usertest03 WITH GRANT OPTION;


-------------------------------------------------------------------------------------------------
-- system으로부터 Read 권한 부여 받고 조회가능
SELECT * FROM system.systemTBL;

-- 권한 부여 받았지만 번거로움 --> 공용 동의어(public sysnonym) 이용
-- CREATE PUBLIC SYNONYM pub_system FOR systemTBL; <-- system이 만든후
SELECT * FROM pub_system;
SELECT * FROM systemTBL;
GRANT SELECT ON systemTBL TO usertest03;

-------------------------------------------------------------------------------------------------
-- sampleTBL 이용한 전용 동의어 생성 --user04만 사용가능
SELECT * FROM system.sampleTBL; -- system으로부터 권한 받음
CREATE synonym priv_sampleTBL FOR system.sampleTBL; --전용 동의어 생성
-- synonym을 만들 권한이 없다는 오류. 
-- system 계정에서 CONNECT, RESOURCE ROLE 받았지만 오류발생
-- 교재에는 CONNECT에 부여된 권한 중 CREATE SYNONYM이 포함되어있었으나
-- 실제로 developer에서 CONNECT에 부여된 권한을 조회해보니 CREATE SESSION만 있었다.
-- 버전별로 롤에 부여된 권한들이 다르다. 9버전에서는 더 많은 권한이 부여되어 있다.
-- 10버전부터 CONNECT에 부여된 권한이 CREATE SESSION 하나만 부여된다.
-- 따라서 직접 system에서 CREATE SYNONYM 권한을 부여해주거나 DBA ROLE 을 주어야 한다.
-- GRANT CREATE SYNONYM TO usertest04; 또는 GRANT DBA TO usertest04;
-- 실무에서 업무의 단순화? 귀찮음으로 인해 DBA권한을 주는 방법을 자주쓴다고 한다.

SELECT * FROM priv_sampleTBL; -- 전용 동의어 이용 SELECT

GRANT SELECT ON system.sampleTBL TO usertest03;

CREATE TABLE sampleTBL(
     memo varchar2(50)
     );
INSERT INTO sampleTBL values('오월 푸름');
INSERT INTO sampleTBL values('결실을 맺으리라');

-- Read OK --> scott가 권한 할당
SELECT * FROM scott.emp;

GRANT SELECT ON scott.emp TO usertest02;


-- Read OK --> scott가 권한 할당
SELECT * FROM scott.dept;

GRANT SELECT ON scott.dept TO usertest02;

SELECT * FROM systemTBL; -- 공용동의어도 권한없으면 불가능



-- system이 공용 동의어(public sysnonym) 생성

SELECT * FROM systemTBL;


-- 전용동의어 SELECT test
SELECT * FROM system.sampleTBL; -- 권한 획득했으므로 SELECT가능
SELECT * FROM priv_sampleTBL;   -- 전용 동의어이므로 SELECT불가, user04만 가능


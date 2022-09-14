CREATE TABLE sampleTBL(
     memo varchar2(50)
     );
INSERT INTO sampleTBL values('오월 푸름');
INSERT INTO sampleTBL values('결실을 맺으리라');

-- Read OK --> scott가 권한 할당
SELECT * FROM scott.emp;

-- Read OK --> scott가 권한 할당
SELECT * FROM scott.dept;

GRANT SELECT ON scott.dept TO usertest01;
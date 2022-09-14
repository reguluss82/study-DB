--------------------------------------------------------------------------------
--                            Backup Dir 생성
--------------------------------------------------------------------------------
-- 1. 행동강령
--  1) HDD c:\mdbackup 생성
--  2) admin에서 directory와 권한 설정
      CREATE OR REPLACE DIRECTORY mdBackup AS 'c:\oraclexe\mdbackup';
      GRANT READ, WRITE ON DIRECTORY mdBackup TO scott;


-- 1. TableSpace 생성      
      CREATE TABLESPACE user5 DATAFILE 'C:\oraclexe\tableSpace\user5.ora' SIZE 100M;
      CREATE TABLESPACE user6 DATAFILE 'C:\oraclexe\tableSpace\user6.ora' SIZE 100M;
      
 --테이블의 테이블 스페이스 변경
 ALTER TABLE scott.weight_info MOVE user5; --오류. sql 문 누락. 이부분 무시하라
 ------------------------------------------------------
---     유저생성
---   scott3/tiger
-------------------------------------------------------
CREATE USER scott3 IDENTIFIED BY tiger
DEFAULT TABLESPACE user1; --보통 업무별 유저 생성시 테이블스페이스 할당
GRANT DBA TO scott3;
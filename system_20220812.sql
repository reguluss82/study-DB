--------------------------------------------------------------------------------
--                            Backup Dir ����
--------------------------------------------------------------------------------
-- 1. �ൿ����
--  1) HDD c:\mdbackup ����
--  2) admin���� directory�� ���� ����
      CREATE OR REPLACE DIRECTORY mdBackup AS 'c:\oraclexe\mdbackup';
      GRANT READ, WRITE ON DIRECTORY mdBackup TO scott;


-- 1. TableSpace ����      
      CREATE TABLESPACE user5 DATAFILE 'C:\oraclexe\tableSpace\user5.ora' SIZE 100M;
      CREATE TABLESPACE user6 DATAFILE 'C:\oraclexe\tableSpace\user6.ora' SIZE 100M;
      
 --���̺��� ���̺� �����̽� ����
 ALTER TABLE scott.weight_info MOVE user5; --����. sql �� ����. �̺κ� �����϶�
 ------------------------------------------------------
---     ��������
---   scott3/tiger
-------------------------------------------------------
CREATE USER scott3 IDENTIFIED BY tiger
DEFAULT TABLESPACE user1; --���� ������ ���� ������ ���̺����̽� �Ҵ�
GRANT DBA TO scott3;
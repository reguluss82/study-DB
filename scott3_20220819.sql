-- �����(Header)  -> interface
CREATE OR REPLACE PACKAGE kk_collection_pkg AS
    g_in_sawonid VARCHAR2(4) := 'S003'; --- �տ��� (���� �Է� ��� ����) �۷ι� ���� ��Ű���ȿ��� ��밡��
    g_prod_cnt   NUMBER(9)   := 0;
---------------------------------------------------------------------------------------                                
------- �ൿ���� :  1. ������� �԰� ������ �����Ѵ�.
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_prc1(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------                                
-------       2. ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ ���� PGM    
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_prc2(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------                                
-------       3. ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)������ ���� PGM                                
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_prc3(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------
----------    5. ��ü���� ó���� ��ü PGM ���� Main Procedure
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_main(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------
----------    9. ��ü���Ҹ����� MMSUMM30�� SMSALE�� ���� STCK_QTY ���� �� ���� ó���۾�  
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_end(p_sum_yymm IN VARCHAR2);

END kk_collection_pkg;



-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY kk_collection_pkg AS
---------------------------------------------------------------------------------------
----------    5. ��ü���� ó���� ��ü PGM ���� Main Procedure
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_main (p_sum_yymm IN VARCHAR2)
    IS
    BEGIN
        DELETE MMSUM30
        WHERE  SUM_YYMM = p_sum_yymm;
         -- ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)���� �ش�� ����
        DELETE SMCP10
        WHERE  SUBSTR(YYMMDD , 1 , 6) = p_sum_yymm;
         -- ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)���� �ش�� ����
        DELETE SMProd10
        WHERE  SUBSTR(YYMMDD , 1 , 6) = p_sum_yymm;
         -- ���ں� �ǸŽ��� ������Ȳ(SMSALE_ERR)���� �ش�� ����
        DELETE SMSALE_ERR
        WHERE  YYMM = p_sum_yymm;
        DBMS_OUTPUT.ENABLE;
        DBMS_OUTPUT.PUT_LINE('kk_collection_main p_sum_yymm => ' || p_sum_yymm);
        
         -- 1. ������� �԰� ������ �����Ѵ�.
        kk_collection_prc1(p_sum_yymm); -- (p_sum_yymm => p_sum_yymm) ���� �ǹ̴�.
         -- 2. ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ ���� PGM
        kk_collection_prc2(p_sum_yymm => p_sum_yymm);
         -- 3. ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)������ ���� PGM
        kk_collection_prc3(p_sum_yymm => p_sum_yymm);
         -- 9. ��ü���Ҹ����� MMSUMM30�� SMSALE�� ���� STCK_QTY ���� �� ���� ó���۾�
        kk_collection_end (p_sum_yymm => p_sum_yymm);
    END kk_collection_main;
    
    /***************************************************************************
     Procedure Name : KK_COLLECTION_PRC1
     Description    : ������� �԰� ������ �����Ѵ�.
    ***************************************************************************/
    PROCEDURE kk_collection_prc1(p_sum_yymm IN VARCHAR2)
    IS
    
    BEGIN
        DBMS_OUTPUT.ENABLE;
        DBMS_OUTPUT.PUT_LINE('kk_collection_prc1 p_sum_ymm => ' ||p_sum_yymm);
        -- 1) ��� ���� �԰� ������ �����Ѵ�
        INSERT INTO MMSUM30
            (
            SUM_YYMM ,
            ITEM_CODE ,
            ITEM_GUBN ,
            STCK_QTY ,
            SawonID ,
            RegiDate
            )
            (
            SELECT p_sum_yymm , --multi row �̹Ƿ� VALUE ���� �ʴ´�.
                   ITEM_CODE ,
                   '0' , -- ����
                   STCK_QTY ,
                   SawonID ,
                   SYSDATE
            FROM   MMSUM30             -- ��¥������ ���� ���ϱ�
            WHERE  SUM_YYMM  = TO_CHAR(ADD_MONTHS(TO_DATE(p_sum_yymm , 'YYYYMM') , -1) , 'YYYYMM')
            AND    ITEM_GUBN = '1' --�⸻
            );       
    END kk_collection_prc1;

/**************************************************************************************
   Project        : KK ����������Ȳ
   Module         : ���Ұ���
   Procedure Name : KK_COLLECTION_PRC2 
   Description    : ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ �����Ѵ�.
                   - �Ϻ� �ǸŽ��� ��Ȳ(SMSALE)�� �о� ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ ����
                   - �Ϻ� �ǸŽ��� ��Ȳ , ��ǰ(Product) ���̺� JOIN
                   - ����� global ������ g_in_sawonid ���� �Է�
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2022.02.23 ���±�            1.0      �����ۼ�
*************************************************************************************/
    PROCEDURE kk_collection_prc2(p_sum_yymm IN VARCHAR2)
    IS
    CURSOR csr_smsale IS
        SELECT s.YYMMDD    YYMMDD ,
               s.CustomID  CustomID ,
               s.ITEM_CODE ITEM_CODE ,
               s.STCK_QTY  STCK_QTY ,
               p.Danga     Danga 
        FROM   SMSALE s , Product p
        WHERE  s.ITEM_CODE = p.ITEM_CODE
        AND    SUBSTR(s.YYMMDD , 1 , 6) = p_sum_yymm; -- ����
--        AND    TO_DATE(s.YYMMDD , 'YYMMDD') = TO_DATE(p_sum_yymm , 'YYMMDD');
--        AND    SUBSTR(s.YYMMDD , 3) = p_sum_yymm;
--        AND    s.YYMMDD LIKE %||p_sum_yymm||'%';
    BEGIN
        FOR rec_smsale IN csr_smsale
        LOOP
            INSERT INTO SMCP10
                (
                 YYMMDD ,
                 CustomID ,
                 ITEM_CODE ,
                 STCK_QTY ,
                 Danga ,
                 SawonID ,
                 RegiDate
                 )
                VALUES -- �ϳ��� ���ڵ� rec_smsale �� ���Ƿ�
                    (
                     rec_smsale.YYMMDD ,
                     rec_smsale.CustomID ,
                     rec_smsale.ITEM_CODE ,
                     rec_smsale.STCK_QTY ,
                     rec_smsale.Danga ,
                     g_in_sawonid , -- �۷ι� ����
                     SYSDATE
                     );
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '���� �߻�');
            
    END kk_collection_prc2;

  /**************************************************************************************************
   Project        : KK ����������Ȳ
   Module         : ���Ұ���
   Procedure Name : KK_COLLECTION_PRC3 
   Description    :  ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)������ �����Ѵ�.
                   - �Ϻ� �ǸŽ��� ��Ȳ(SMSALE)�� �о� ���ں�  ��ǰ�� �Ǹ���Ȳ(SMProd10)������ ����
                   - STCK_QTY -> SUM, Danga -> AVG
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2022.02.23 ���±�            1.0      �����ۼ�
  ************************************************************************************************/
    PROCEDURE kk_collection_prc3(p_sum_yymm IN VARCHAR2)
    IS
    CURSOR csr_smsale IS
        SELECT s.YYMMDD        YYMMDD ,
               s.ITEM_CODE     ITEM_CODE ,
               SUM(s.STCK_QTY) sum_STCK_QTY ,
               AVG(p.Danga)    avg_Danga
        FROM   SMSALE s , Product p
        WHERE  s.ITEM_CODE = p.ITEM_CODE
        AND    SUBSTR(s.YYMMDD , 1 , 6) = p_sum_yymm --����
        GROUP BY s.YYMMDD , s.ITEM_CODE;
    BEGIN
        FOR rec_smsale_item IN csr_smsale
        LOOP
        -------------
        -- initialize
        -------------
            INSERT INTO SMProd10
                (
                YYMMDD ,
                ITEM_CODE ,
                STCK_QTY ,
                Danga ,
                SawonID ,
                RegiDate
                )
                VALUES
                    (
                     rec_smsale_item.YYMMDD ,
                     rec_smsale_item.ITEM_CODE ,
                     rec_smsale_item.sum_STCK_QTY ,
                     rec_smsale_item.avg_Danga ,
                     g_in_sawonid ,
                     SYSDATE
                    );
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '���� �߻�');
    END kk_collection_prc3;
    
    /**************************************************************************************************
   Project        : KK ����������Ȳ
   Module         : ���Ұ���
   Procedure Name : KK_COLLECTION_END 
   Description    : ��ü ���Ҹ����� MMSUMM30�� SMSALE�� ���� STCK_QTY 
                        ���� �� ���� ó���۾�   
    1.  ���� â�� ������� �Ǹŷ����� ũ�ٸ� �⸻��� �Է�       
    2.  ���� â�� ������� �Ǹŷ����� �۴ٸ� SMSALE_ERR �Է�    
    CUSOR csr_store_remain
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2022.02.23 ���±�            1.0      �����ۼ�
  ************************************************************************************************/
    PROCEDURE kk_collection_end (p_sum_yymm IN VARCHAR2)
    IS 
        --- MMSUMM30�� SMSALE�� ���Ͽ� YYMMDD, ITEM_CODE�� ���� �հ� ����
        CURSOR csr_store_remain IS
            SELECT 
                   SUBSTR(s.YYMMDD , 1 , 6) YYMM ,
                   s.ITEM_CODE            ITEM_CODE ,
                   SUM(s.STCK_QTY)        S_STCK_QTY ,
                   AVG(m.STCK_QTY)        M_STCK_QTY --�ϳ����ۿ� ��� AVG
            FROM   (
                   SELECT * FROM SMSALE
                   WHERE SUBSTR(YYMMDD , 1 , 6) = p_sum_yymm
                   ) s ,
                   (
                   SELECT * FROM MMSUM30
                   WHERE SUM_YYMM               = p_sum_yymm 
                   AND   ITEM_GUBN = '0'-- ������� ����
                   ) m   -- â����� MMSUM30���̺�
            WHERE  s.ITEM_CODE = m.ITEM_CODE
            GROUP BY SUBSTR(s.YYMMDD , 1 , 6) , s.ITEM_CODE;
    BEGIN
        DBMS_OUTPUT.ENABLE;
        FOR rec_store_remain IN csr_store_remain
        LOOP
            IF rec_store_remain.M_STCK_QTY > rec_store_remain.S_STCK_QTY THEN
                INSERT INTO MMSUM30
                    (
                    SUM_YYMM ,
                    ITEM_CODE ,
                    ITEM_GUBN ,
                    STCK_QTY ,
                    SawonID ,
                    RegiDate
                    )
                    VALUES
                        (
                        rec_store_remain.YYMM ,
                        rec_store_remain.ITEM_CODE ,
                        '1' , --�⸻���
                        rec_store_remain.M_STCK_QTY - rec_store_remain.S_STCK_QTY ,
                        g_in_sawonid ,
                        SYSDATE
                        );
            ELSE 
                INSERT INTO SMSALE_ERR
                    (
                    YYMM ,
                    ITEM_CODE ,
                    MMSUM30_QTY ,
                    SMSALE_QTY ,
                    SawonID ,
                    regidate
                    )
                    VALUES
                        (
                        rec_store_remain.YYMM ,
                        rec_store_remain.ITEM_CODE ,
                        rec_store_remain.M_STCK_QTY ,
                        rec_store_remain.S_STCK_QTY ,
                        g_in_sawonid ,
                        SYSDATE
                        );
            g_prod_cnt := rec_store_remain.M_STCK_QTY - rec_store_remain.S_STCK_QTY;
            DBMS_OUTPUT.PUT_LINE(rec_store_remain.YYMM || '�����' 
                                 || rec_store_remain.ITEM_CODE || '������ �� =>' || g_prod_cnt);

            END IF;
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
            DBMS_output.put_line(SQLERRM || '�����߻�');
    END kk_collection_end;
    
END kk_collection_pkg;

EXEC kk_collection_pkg.kk_collection_prc1(202202);
EXEC kk_collection_pkg.kk_collection_prc2(202202);
EXEC kk_collection_pkg.kk_collection_prc3(202202);
EXEC kk_collection_pkg.kk_collection_end(202202);
EXEC kk_collection_pkg.kk_collection_main(202202);


-------------------DB ������-----------------------
------- �߰������� ������ ���ΰŸ���----------------
-- Ʃ��
-- select join �� ���� ��ȹ���� Hash JoinȮ��
-- join ���� Ȯ��
-- ��Ƽ�������� operater join -> DBMS join ���� ���������� ��ȯ
-- �������鿡�� DBMS join �� ����
-- ��Ʈ������ DBMS join �ϵ��� ����

-- ������ ������
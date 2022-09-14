-- 선언부(Header)  -> interface
CREATE OR REPLACE PACKAGE kk_collection_pkg AS
    g_in_sawonid VARCHAR2(4) := 'S003'; --- 손예진 (임의 입력 사원 지정) 글로벌 변수 패키지안에서 사용가능
    g_prod_cnt   NUMBER(9)   := 0;
---------------------------------------------------------------------------------------                                
------- 행동강령 :  1. 당월기초 입고 수량을 생성한다.
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_prc1(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------                                
-------       2. 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성 PGM    
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_prc2(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------                                
-------       3. 일자별 제품별 판매현황(SMProd10)정보를 생성 PGM                                
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_prc3(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------
----------    5. 전체수불 처리시 전체 PGM 조율 Main Procedure
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_main(p_sum_yymm IN VARCHAR2);
---------------------------------------------------------------------------------------
----------    9. 전체수불마감후 MMSUMM30을 SMSALE에 따라 STCK_QTY 차감 및 마감 처리작업  
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_end(p_sum_yymm IN VARCHAR2);

END kk_collection_pkg;



-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY kk_collection_pkg AS
---------------------------------------------------------------------------------------
----------    5. 전체수불 처리시 전체 PGM 조율 Main Procedure
---------------------------------------------------------------------------------------
    PROCEDURE kk_collection_main (p_sum_yymm IN VARCHAR2)
    IS
    BEGIN
        DELETE MMSUM30
        WHERE  SUM_YYMM = p_sum_yymm;
         -- 일자별 거래처 제품별 판매현황(SMCP10)정보 해당월 삭제
        DELETE SMCP10
        WHERE  SUBSTR(YYMMDD , 1 , 6) = p_sum_yymm;
         -- 일자별 제품별 판매현황(SMProd10)정보 해당월 삭제
        DELETE SMProd10
        WHERE  SUBSTR(YYMMDD , 1 , 6) = p_sum_yymm;
         -- 일자별 판매실적 오류현황(SMSALE_ERR)정보 해당월 삭제
        DELETE SMSALE_ERR
        WHERE  YYMM = p_sum_yymm;
        DBMS_OUTPUT.ENABLE;
        DBMS_OUTPUT.PUT_LINE('kk_collection_main p_sum_yymm => ' || p_sum_yymm);
        
         -- 1. 당월기초 입고 수량을 생성한다.
        kk_collection_prc1(p_sum_yymm); -- (p_sum_yymm => p_sum_yymm) 같은 의미다.
         -- 2. 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성 PGM
        kk_collection_prc2(p_sum_yymm => p_sum_yymm);
         -- 3. 일자별 제품별 판매현황(SMProd10)정보를 생성 PGM
        kk_collection_prc3(p_sum_yymm => p_sum_yymm);
         -- 9. 전체수불마감후 MMSUMM30을 SMSALE에 따라 STCK_QTY 차감 및 마감 처리작업
        kk_collection_end (p_sum_yymm => p_sum_yymm);
    END kk_collection_main;
    
    /***************************************************************************
     Procedure Name : KK_COLLECTION_PRC1
     Description    : 당월기초 입고 수량을 생성한다.
    ***************************************************************************/
    PROCEDURE kk_collection_prc1(p_sum_yymm IN VARCHAR2)
    IS
    
    BEGIN
        DBMS_OUTPUT.ENABLE;
        DBMS_OUTPUT.PUT_LINE('kk_collection_prc1 p_sum_ymm => ' ||p_sum_yymm);
        -- 1) 당월 기초 입고 수량을 생성한다
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
            SELECT p_sum_yymm , --multi row 이므로 VALUE 쓰지 않는다.
                   ITEM_CODE ,
                   '0' , -- 기초
                   STCK_QTY ,
                   SawonID ,
                   SYSDATE
            FROM   MMSUM30             -- 날짜연산자 전월 구하기
            WHERE  SUM_YYMM  = TO_CHAR(ADD_MONTHS(TO_DATE(p_sum_yymm , 'YYYYMM') , -1) , 'YYYYMM')
            AND    ITEM_GUBN = '1' --기말
            );       
    END kk_collection_prc1;

/**************************************************************************************
   Project        : KK 영업매출현황
   Module         : 수불관리
   Procedure Name : KK_COLLECTION_PRC2 
   Description    : 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성한다.
                   - 일별 판매실적 현황(SMSALE)을 읽어 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성
                   - 일별 판매실적 현황 , 제품(Product) 테이블 JOIN
                   - 사원은 global 변수인 g_in_sawonid 으로 입력
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2022.02.23 강태광            1.0      최초작성
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
        AND    SUBSTR(s.YYMMDD , 1 , 6) = p_sum_yymm; -- 월별
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
                VALUES -- 하나의 레코드 rec_smsale 씩 들어가므로
                    (
                     rec_smsale.YYMMDD ,
                     rec_smsale.CustomID ,
                     rec_smsale.ITEM_CODE ,
                     rec_smsale.STCK_QTY ,
                     rec_smsale.Danga ,
                     g_in_sawonid , -- 글로벌 변수
                     SYSDATE
                     );
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
            
    END kk_collection_prc2;

  /**************************************************************************************************
   Project        : KK 영업매출현황
   Module         : 수불관리
   Procedure Name : KK_COLLECTION_PRC3 
   Description    :  일자별 제품별 판매현황(SMProd10)정보를 생성한다.
                   - 일별 판매실적 현황(SMSALE)을 읽어 일자별  제품별 판매현황(SMProd10)정보를 생성
                   - STCK_QTY -> SUM, Danga -> AVG
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2022.02.23 강태광            1.0      최초작성
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
        AND    SUBSTR(s.YYMMDD , 1 , 6) = p_sum_yymm --월별
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
                DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
    END kk_collection_prc3;
    
    /**************************************************************************************************
   Project        : KK 영업매출현황
   Module         : 수불관리
   Procedure Name : KK_COLLECTION_END 
   Description    : 전체 수불마감후 MMSUMM30을 SMSALE에 따라 STCK_QTY 
                        차감 및 마감 처리작업   
    1.  만약 창고 기초재고가 판매량보다 크다면 기말재고 입력       
    2.  만약 창고 기초재고가 판매량보다 작다면 SMSALE_ERR 입력    
    CUSOR csr_store_remain
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2022.02.23 강태광            1.0      최초작성
  ************************************************************************************************/
    PROCEDURE kk_collection_end (p_sum_yymm IN VARCHAR2)
    IS 
        --- MMSUMM30을 SMSALE에 대하여 YYMMDD, ITEM_CODE별 수량 합계 차감
        CURSOR csr_store_remain IS
            SELECT 
                   SUBSTR(s.YYMMDD , 1 , 6) YYMM ,
                   s.ITEM_CODE            ITEM_CODE ,
                   SUM(s.STCK_QTY)        S_STCK_QTY ,
                   AVG(m.STCK_QTY)        M_STCK_QTY --하나씩밖에 없어서 AVG
            FROM   (
                   SELECT * FROM SMSALE
                   WHERE SUBSTR(YYMMDD , 1 , 6) = p_sum_yymm
                   ) s ,
                   (
                   SELECT * FROM MMSUM30
                   WHERE SUM_YYMM               = p_sum_yymm 
                   AND   ITEM_GUBN = '0'-- 기초재고에 한해
                   ) m   -- 창고재고 MMSUM30테이블
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
                        '1' , --기말재고
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
            DBMS_OUTPUT.PUT_LINE(rec_store_remain.YYMM || '년월에' 
                                 || rec_store_remain.ITEM_CODE || '재고부족 양 =>' || g_prod_cnt);

            END IF;
        END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
            DBMS_output.put_line(SQLERRM || '에러발생');
    END kk_collection_end;
    
END kk_collection_pkg;

EXEC kk_collection_pkg.kk_collection_prc1(202202);
EXEC kk_collection_pkg.kk_collection_prc2(202202);
EXEC kk_collection_pkg.kk_collection_prc3(202202);
EXEC kk_collection_pkg.kk_collection_end(202202);
EXEC kk_collection_pkg.kk_collection_main(202202);


-------------------DB 마무리-----------------------
------- 추가적으로 볼만한 공부거리들----------------
-- 튜닝
-- select join 문 실행 계획에서 Hash Join확인
-- join 종류 확인
-- 옵티마이저가 operater join -> DBMS join 으로 내부적으로 변환
-- 성능측면에서 DBMS join 이 우위
-- 힌트문으로 DBMS join 하도록 유도

-- 순공학 역공학
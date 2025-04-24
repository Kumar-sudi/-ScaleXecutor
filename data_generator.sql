-- Assumptions:
-- 1. A table named `txn_data` exists or will be created.
-- 2. Simulates financial transactions with randomized data.
-- 3. Designed for repeat execution and scalable volume generation.

-- Create table if not exists (run once)
BEGIN
  EXECUTE IMMEDIATE '
    CREATE TABLE txn_data (
      txn_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      customer_id    NUMBER,
      account_no     VARCHAR2(20),
      amount         NUMBER(10, 2),
      txn_type       VARCHAR2(10),
      txn_status     VARCHAR2(10),
      txn_time       TIMESTAMP DEFAULT SYSTIMESTAMP
    )';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -955 THEN
      RAISE;
    END IF;
END;
/

-- Procedure to generate test data
CREATE OR REPLACE PROCEDURE generate_transactions(p_count IN NUMBER) IS
  v_txn_type   VARCHAR2(10);
  v_txn_status VARCHAR2(10);
BEGIN
  FOR i IN 1..p_count LOOP
    SELECT CASE MOD(DBMS_RANDOM.VALUE(1, 5), 3)
             WHEN 0 THEN 'CREDIT'
             WHEN 1 THEN 'DEBIT'
             ELSE 'REVERSAL'
           END,
           CASE MOD(DBMS_RANDOM.VALUE(1, 4), 2)
             WHEN 0 THEN 'SUCCESS'
             ELSE 'FAIL'
           END
    INTO v_txn_type, v_txn_status
    FROM dual;

    INSERT INTO txn_data (
      customer_id,
      account_no,
      amount,
      txn_type,
      txn_status,
      txn_time
    ) VALUES (
      TRUNC(DBMS_RANDOM.VALUE(1000, 9999)),
      TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10000000, 99999999))),
      ROUND(DBMS_RANDOM.VALUE(10, 10000), 2),
      v_txn_type,
      v_txn_status,
      SYSTIMESTAMP
    );

    -- Optional COMMIT every 1000 records for performance
    IF MOD(i, 1000) = 0 THEN
      COMMIT;
    END IF;
  END LOOP;
  COMMIT;
END;
/

-- Execute to generate 10,000 transactions
BEGIN
  generate_transactions(10000);
END;
/

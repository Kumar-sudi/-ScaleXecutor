CREATE OR REPLACE PACKAGE thread_processor_pkg AS
  PROCEDURE dynamic_thread_creation;
END thread_processor_pkg;


CREATE OR REPLACE PACKAGE BODY thread_processor_pkg AS

  PROCEDURE dynamic_thread_creation IS
    CURSOR cur_trans IS
      SELECT transaction_id
      FROM main_transaction_table
      WHERE status = 'PENDING'
        AND ROWNUM <= 1000;  -- Limit to avoid overloading

    v_tid        main_transaction_table.transaction_id%TYPE;
    v_thread_num NUMBER;
  BEGIN
    FOR txn IN cur_trans LOOP
      v_tid := txn.transaction_id;
      v_thread_num := TO_NUMBER(SUBSTR(v_tid, -3));

      IF MOD(v_thread_num, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Assigning to Thread A: ' || v_tid);
        -- Process logic or insert into thread_A_queue
      ELSE
        DBMS_OUTPUT.PUT_LINE('Assigning to Thread B: ' || v_tid);
        -- Process logic or insert into thread_B_queue
      END IF;

      -- Optional: More threads based on DB load (handled later)
    END LOOP;
  END dynamic_thread_creation;

END thread_processor_pkg;

CREATE OR REPLACE PACKAGE batch_deferral_pkg AS
  PROCEDURE pause_low_priority_batches;
  PROCEDURE resume_batches;
END batch_deferral_pkg;

CREATE OR REPLACE PACKAGE BODY batch_deferral_pkg AS

  PROCEDURE pause_low_priority_batches IS
  BEGIN
    UPDATE batch_schedule_table
    SET status = 'PAUSED',
        last_update = SYSTIMESTAMP
    WHERE priority_level >= 2
      AND status = 'SCHEDULED';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Low priority batches paused.');
  END pause_low_priority_batches;

  PROCEDURE resume_batches IS
  BEGIN
    UPDATE batch_schedule_table
    SET status = 'SCHEDULED',
        last_update = SYSTIMESTAMP
    WHERE status = 'PAUSED';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Paused batches resumed.');
  END resume_batches;

END batch_deferral_pkg;

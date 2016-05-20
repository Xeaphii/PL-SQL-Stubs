/* Formatted on 5/20/2016 11:53:45 AM (QP5 v5.227.12220.39724) */
CREATE OR REPLACE FUNCTION fn_dynamic_select (tbl                 VARCHAR2,
                                              excluded_columns    VARCHAR2)
   RETURN VARCHAR2
IS
   l_output_query   VARCHAR2 (10000);
BEGIN
   SELECT    'SELECT '
          || LISTAGG (column_name, ',') WITHIN GROUP (ORDER BY COLUMN_ID)
          || ' FROM '
          || tbl
          || ';'
     INTO l_output_query
     FROM all_tab_columns
    WHERE     table_name = 'SMTB_USER'
          AND column_name NOT IN
                 (WITH DATA AS (SELECT excluded_columns str FROM DUAL)
                      SELECT TRIM (REGEXP_SUBSTR (str,
                                                  '[^,]+',
                                                  1,
                                                  LEVEL))
                                str
                        FROM DATA
                  CONNECT BY INSTR (str,
                                    ',',
                                    1,
                                    LEVEL - 1) > 0);

   RETURN l_output_query;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN '';
END;
/* Formatted on 5/20/2016 11:34:52 AM (QP5 v5.227.12220.39724) */
CREATE OR REPLACE FUNCTION fn_dynamic_select (tbl                 VARCHAR2,
                                              excluded_columns    VARCHAR2)
   RETURN VARCHAR2
IS
   l_output_query   VARCHAR2 (1000);
BEGIN
     SELECT WM_CONCAT (column_name)
       INTO l_output_query
       FROM all_tab_columns
      WHERE table_name = tbl AND column_name <> excluded_columns
   GROUP BY table_name;

   RETURN 'SELECT ' || l_output_query || ' FROM ' || tbl;
EXCEPTION
   WHEN others
   THEN
      RETURN '';
END;
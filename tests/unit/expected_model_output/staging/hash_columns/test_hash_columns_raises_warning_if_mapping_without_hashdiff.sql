CAST((MD5_BINARY(NULLIF(UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR))), ''))) AS BINARY(16)) AS BOOKING_PK,
CAST((MD5_BINARY(NULLIF(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), ''))) AS BINARY(16)) AS CUSTOMER_PK,
CAST(MD5_BINARY(CONCAT(
    IFNULL(NULLIF(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR))), ''), '^^') ))
AS BINARY(16)) AS CUSTOMER_BOOKING_PK,
CAST(MD5_BINARY(CONCAT(
    IFNULL(NULLIF(UPPER(TRIM(CAST(PHONE AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(NATIONALITY AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), ''), '^^') ))
AS BINARY(16)) AS BOOK_CUSTOMER_HASHDIFF,
CAST(MD5_BINARY(CONCAT(
    IFNULL(NULLIF(UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(BOOKING_DATE AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(DEPARTURE_DATE AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(PRICE AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(DESTINATION AS VARCHAR))), ''), '^^') ))
AS BINARY(16)) AS BOOK_BOOKING_HASHDIFF
CAST((MD5_BINARY(NULLIF(UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR))), ''))) AS BINARY(16)) AS BOOKING_PK,
CAST(MD5_BINARY(CONCAT(
    IFNULL(NULLIF(UPPER(TRIM(CAST(ADDRESS AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(NAME AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST(PHONE AS VARCHAR))), ''), '^^') ))
AS BINARY(16)) AS CUSTOMER_DETAILS
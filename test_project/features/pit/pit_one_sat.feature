@fixture.set_workdir
Feature: pit

# todo (or rather toanswer): will we allow the AS OF dates to be DATE in the PIT table or are we always going to convert them into DATETIME?

  # DATES
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with AS OF dates in between LDTS and some in the future
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-04 |
      | 2018-06-06 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2016-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-06 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2016-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2016-06-04 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2016-06-06 | md5('1002')             | 2018-06-05                |
      | md5('1003') | 2016-06-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2016-06-04 | md5('1003')             | 2018-06-03                |
      | md5('1003') | 2016-06-06 | md5('1003')             | 2018-06-05                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with AS OF dates in the past and in between LDTS
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-04 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates with an encompassing range of AS OF dates
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-03 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-05 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-06 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-05 | md5('1002')             | 2018-06-05                |
      | md5('1002') | 2018-06-06 | md5('1002')             | 2018-06-05                |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-03 | md5('1003')             | 2018-06-03                |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03                |
      | md5('1003') | 2018-06-05 | md5('1003')             | 2018-06-05                |
      | md5('1003') | 2018-06-06 | md5('1003')             | 2018-06-05                |

  # TIMESTAMPS
  # todo: enhance data (see pit_two_sat and #dates above)
  # todo: needs a new fixture - @fixture.pit_one_sat_ts
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with timestamps with AS OF timestamps in the future
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-06-01 00:00:15.000000 |
      | 2019-06-01 00:00:30.000000 |
      | 2019-06-01 00:00:45.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2019-06-01 00:00:15.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2019-06-01 00:00:30.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2019-06-01 00:00:45.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-06-01 00:00:15.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-06-01 00:00:30.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-06-01 00:00:45.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-06-01 00:00:15.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-06-01 00:00:30.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-06-01 00:00:45.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with timestamps with AS OF timestamps in the past
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 23:59:15.000000 |
      | 2018-05-31 23:59:30.000000 |
      | 2018-05-31 23:59:45.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:15.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 23:59:30.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:15.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:30.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:15.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:30.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:45.000000 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-01 00:00:15.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:15.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:15.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:15.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |

  # AS OF DATES - LOWER GRANULARITY
  # todo: enhance data (see pit_two_sat and #dates above)
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-LOWER-GRAN] Base load into a pit table from one satellite with timestamps where AS OF dates are in the future
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000002 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-03 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1002') | 2018-06-03 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01 00:00:00.000002 |
      | md5('1003') | 2018-06-03 | md5('1003')             | 2018-06-01 00:00:00.000002 |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-01 00:00:00.000002 |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-LOWER-GRAN] Base load into a pit table from one satellite with timestamps where AS OF dates are in the past
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-29 |
      | 2018-05-30 |
      | 2018-05-31 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000002 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-LOWER-GRAN] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01 00:00:00.000002 |

  # AS OF DATES - HIGHER GRANULARITY
  # todo: enhance data (see pit_two_sat and #dates above)
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-HIGHER-GRAN] Base load into a pit table from one satellite with dates where AS OF timestamps are in the future
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-06-01 00:00:00.000001 |
      | 2018-06-01 12:00:00.000001 |
      | 2018-06-02 00:00:00.000001 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 | *      |
      | md5('1002') | 1002        | 2018-06-01 | *      |
      | md5('1003') | 1003        | 2018-06-01 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 12:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 12:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 00:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 12:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 00:00:00.000001 | md5('1003')             | 2018-06-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-HIGHER-GRAN] Base load into a pit table from one satellite with dates where AS OF timestamps are in the past
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 00:00:00.000000 |
      | 2018-05-31 12:30:00.000001 |
      | 2018-05-31 23:59:59.999999 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 | *      |
      | md5('1002') | 1002        | 2018-06-01 | *      |
      | md5('1003') | 1003        | 2018-06-01 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-HIGHER-GRAN] Base load into a pit table from one satellite with dates with an encompassing range of AS OF timestamps
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:59.999999 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-01 00:00:00.000001 |
      | 2018-06-01 23:59:59.999999 |
      | 2018-06-02 00:00:00.000001 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 23:59:59.999999 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 1900-01-01                |
      | md5('1002') | 2018-06-01 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 23:59:59.999999 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 1900-01-01                |
      | md5('1003') | 2018-06-01 00:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 23:59:59.999999 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 00:00:00.000001 | md5('1003')             | 2018-06-01                |


#  # NULLS
#  @fixture.pit_one_sat
#  Scenario: [BASE-LOAD-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the future
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUBS         | LINKS | SATS                 | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I create the STG_CUSTOMER_DETAILS stage
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2019-01-02 |
#      | 2019-01-03 |
#      | 2019-01-04 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2019-01-02 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
#      | md5('1003') | 2019-01-02 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |
#
#  @fixture.pit_one_sat
#  Scenario: [BASE-LOAD-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the past
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUBS         | LINKS | SATS                 | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I create the STG_CUSTOMER_DETAILS stage
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2018-01-02 |
#      | 2018-01-03 |
#      | 2018-01-04 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
#
#  @fixture.pit_one_sat
#  Scenario: [BASE-LOAD-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & some as of dates are in the past
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUBS         | LINKS | SATS                 | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I create the STG_CUSTOMER_DETAILS stage
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2018-01-02 |
#      | 2019-06-01 |
#      | 2019-06-02 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
#      | md5('1003') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |

  # DUPLICATES
  #todo: probably a cycles duplicates simple test should suffice; no need for individual loads duplicates tests
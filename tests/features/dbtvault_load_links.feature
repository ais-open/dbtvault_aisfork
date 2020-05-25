Feature: Links
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 21.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# 24.09.19 NS  1.2     Reviewed and updated.
# =============================================================================

# -----------------------------------------------------------------------------
# Testing insertion of records into a link which doesn't yet exist
# -----------------------------------------------------------------------------
  Scenario: [BASE-LOAD-SINGLE] Load a simple stage table into an empty link table
    Given a TEST_LINK_CUSTOMER_NATION table does not exist
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  Scenario: [SINGLE-SOURCE] Load a stage table with duplicates into an empty link table
    Given I have an empty LINK_CUSTOMER_NATION table
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |

    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  Scenario: [BASE-LOAD-SINGLE] Load a simple stage table into an empty link table and exclude Links with NULL foreign keys
    Given a TEST_LINK_CUSTOMER_NATION table does not exist
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | <null>     | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |

# -----------------------------------------------------------------------------
# Test the load of one stage table feeding an empty link.
# -----------------------------------------------------------------------------
  Scenario: [SINGLE-SOURCE] Load a simple stage table into an empty link table
    Given I have an empty LINK_CUSTOMER_NATION table
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  Scenario: [SINGLE-SOURCE] Loading a stage table with duplicates into an empty link table
    Given I have an empty LINK_CUSTOMER_NATION table
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |

    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |


# -----------------------------------------------------------------------------
# Test the load of one stage table feeding a populated link.
# -----------------------------------------------------------------------------
  Scenario: [SINGLE-SOURCE] Load a simple stage table into a populated link.
    Given there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  Scenario: [SINGLE-SOURCE] Load a stage table with duplicates into a populated link.
    Given there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  Scenario: [SINGLE-SOURCE] Load a stage table where a foreign key is NULL, no link is inserted.
    Given there are records in the TEST_STG_CRM_CUSTOMER table
     | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
     | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
     | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
     | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
     | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
     | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
     | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
     | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
     | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
     | 1007         | <null>     | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
     | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
     | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
     | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
     | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
     | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
     | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
     | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
     | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
     | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
     | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
     | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
     | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
     | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |


# -----------------------------------------------------------------------------------------
# Test union of different staging tables to insert records into links which don't yet exist
# -----------------------------------------------------------------------------------------
  Scenario: [BASE-LOAD-UNION] Union three staging tables to feed a link which does not exist.
    Given a TEST_LINK_CUSTOMER_NATION_UNION table does not exist
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | ITA        | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | SAP    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | SAP    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | WEB    |

# -----------------------------------------------------------------------------
# Test the union of three stage tables feeding an empty link.
# -----------------------------------------------------------------------------
  Scenario: [UNION] Union three staging tables to feed empty link.
    Given I have an empty LINK_CUSTOMER_NATION_UNION table
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | ITA        | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | SAP    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | SAP    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | WEB    |

  Scenario: [UNION] Union three staging tables with duplicates to feed populated link.
    Given I have an empty LINK_CUSTOMER_NATION_UNION table
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | ITA        | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And there are records in the LINK_CUSTOMER_NATION_UNION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | WEB    |

  Scenario: [UNION] Load a stage table where a foreign key is NULL, no link is inserted.
    Given there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | <null>    | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | <null>    | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | <null>     | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | <null>     | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And there are records in the LINK_CUSTOMER_NATION_UNION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |

   Scenario: [UNION] Union three staging tables to feed empty link where NULL foreign keys are not added.
    Given I have an empty LINK_CUSTOMER_NATION_UNION table
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | <null>      | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | <null>       | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | <null>     | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | SAP    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | SAP    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |

# -----------------------------------------------------------------------------
# Test the load of one stage table feeding a populated multi-part link.
# -----------------------------------------------------------------------------
  Scenario: [SINGLE-SOURCE] Load a stage table into an empty multi-part link
    Given I have an empty LINK_CUSTOMER_ORDER_MULTIPART table
    And there are records in the TEST_STG_EFF_SAT_HASHED table
     | CUSTOMER_ORDER_PK                                | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | NATION_FK  | NATION_ID | PRODUCT_FK    | PRODUCT_GROUP | ORGANISATION_FK  | ORGANISATION_ID |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | WEB    | md5('1000') | 1000        | md5('AAA') | AAA      | md5('DEU') | DEU       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | WEB    | md5('2000') | 2000        | md5('BBB') | BBB      | md5('GBR') | GBR       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | 2020-01-14 | WEB    | md5('3000') | 3000        | md5('CCC') | CCC      | md5('AUS') | AUS       | md5('SHOP')   | SHOP          | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-14 | WEB    | md5('4000') | 4000        | md5('DDD') | DDD      | md5('POL') | POL       | md5('ONLINE') | ONLINE        | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | WEB    | md5('5000') | 5000        | md5('FFF') | FFF      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       |
     | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | WEB    | md5('6000') | 6000        | md5('GGG') | GGG      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       |
    When I load the TEST_LINK_CUSTOMER_ORDER_MULTIPART table
    Then the LINK_CUSTOMER_ORDER_MULTIPART should contain
     | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-14 | WEB    |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-14 | WEB    |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-14 | WEB    |
     | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('DDD') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-14 | WEB    |
     | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('FRA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | WEB    |
     | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | md5('6000') | md5('FRA') | md5('GGG') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | WEB    |

  Scenario: [SINGLE-SOURCE] Loading a stage table into an existing multi-part link table
    Given there are records in the TEST_STG_EFF_SAT_HASHED table
     | CUSTOMER_ORDER_PK                                | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | NATION_FK  | NATION_ID | PRODUCT_FK    | PRODUCT_GROUP | ORGANISATION_FK  | ORGANISATION_ID |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | WEB    | md5('1000') | 1000        | md5('AAA') | AAA      | md5('DEU') | DEU       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | WEB    | md5('2000') | 2000        | md5('BBB') | BBB      | md5('GBR') | GBR       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | 2020-01-14 | WEB    | md5('3000') | 3000        | md5('CCC') | CCC      | md5('AUS') | AUS       | md5('SHOP')   | SHOP          | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-14 | WEB    | md5('4000') | 4000        | md5('DDD') | DDD      | md5('POL') | POL       | md5('ONLINE') | ONLINE        | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | WEB    | md5('5000') | 5000        | md5('FFF') | FFF      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       |
     | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | WEB    | md5('6000') | 6000        | md5('GGG') | GGG      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       |
    And there are records in the LINK_CUSTOMER_CUSTOMER_ORDER_MULTIPART table
     | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | WEB    |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | WEB    |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-13 | WEB    |
    When I load the TEST_LINK_CUSTOMER_ORDER_MULTIPART table
    Then the LINK_CUSTOMER_ORDER_MULTIPART should contain
     | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | WEB    |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-13 | WEB    |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-13 | WEB    |
     | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('DDD') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-14 | WEB    |
     | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('FRA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | WEB    |
     | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | md5('6000') | md5('FRA') | md5('GGG') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | WEB    |

  Scenario: [Union] Union load of into a multi-part link
    Given I have an empty LINK_CUSTOMER_ORDER_MULTIPART_UNION table
    And there are records in the TEST_STG_EFF_SAT_HASHED table
     | CUSTOMER_ORDER_PK                                | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | NATION_FK  | NATION_ID | PRODUCT_FK    | PRODUCT_GROUP | ORGANISATION_FK  | ORGANISATION_ID |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | CRM    | md5('1000') | 1000        | md5('AAA') | AAA      | md5('DEU') | DEU       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | CRM    | md5('2000') | 2000        | md5('BBB') | BBB      | md5('GBR') | GBR       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | 2020-01-14 | CRM    | md5('3000') | 3000        | md5('CCC') | CCC      | md5('AUS') | AUS       | md5('SHOP')   | SHOP          | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | 2020-01-14 | CRM    | md5('4000') | 4000        | md5('DDD') | DDD      | md5('POL') | POL       | md5('ONLINE') | ONLINE        | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | CRM    | md5('5000') | 5000        | md5('FFF') | FFF      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       |
     | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | 2020-01-14 | CRM    | md5('6000') | 6000        | md5('GGG') | GGG      | md5('FRA') | FRA       | md5('SHOP')   | SHOP          | md5('DATAVAULT') | DATAVAULT       |
    And there are records in the TEST_STG_CRM_CUSTOMER_ORDER_HASHED table
     | CUSTOMER_ORDER_PK                                | LOADDATE   | Source | CUSTOMER_FK | CUSTOMER_ID | ORDER_FK   | ORDER_ID | NATION_FK  | NATION_ID | PRODUCT_FK    | PRODUCT_GROUP | ORGANISATION_FK  | ORGANISATION_ID |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | WEB    | md5('1000') | 1000        | md5('AAA') | AAA      | md5('DEU') | DEU       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | 2020-01-14 | WEB    | md5('2000') | 2000        | md5('BBB') | BBB      | md5('GBR') | GBR       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | 2020-01-14 | WEB    | md5('3000') | 3000        | md5('CCC') | CCC      | md5('AUS') | AUS       | md5('SHOP')   | SHOP          | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('7000\|\|DEU\|\|HHH\|\|SHOP\|\|BUSSTHINK')   | 2020-01-15 | WEB    | md5('7000') | 7000        | md5('HHH') | HHH      | md5('DEU') | DEU       | md5('SHOP')   | SHOP          | md5('BUSSTHINK') | BUSSTHINK       |
     | md5('8000\|\|SPA\|\|III\|\|ONLINE\|\|DATAVAULT') | 2020-01-15 | WEB    | md5('8000') | 8000        | md5('III') | III      | md5('SPA') | SPA       | md5('ONLINE') | ONLINE        | md5('DATAVAULT') | DATAVAULT       |
    When I load the TEST_LINK_CUSTOMER_ORDER_MULTIPART_UNION table
    Then the LINK_CUSTOMER_ORDER_MULTIPART_UNION should contain
     | CUSTOMER_ORDER_PK                                | CUSTOMER_FK | NATION_FK  | ORDER_FK   | PRODUCT_FK    | ORGANISATION_FK  | LOADDATE   | SOURCE |
     | md5('1000\|\|DEU\|\|AAA\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('DEU') | md5('AAA') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-14 | CRM    |
     | md5('2000\|\|GBR\|\|BBB\|\|ONLINE\|\|DATAVAULT') | md5('2000') | md5('GBR') | md5('BBB') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-14 | CRM    |
     | md5('3000\|\|AUS\|\|CCC\|\|SHOP\|\|BUSSTHINK')   | md5('3000') | md5('AUS') | md5('CCC') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-14 | CRM    |
     | md5('4000\|\|POL\|\|DDD\|\|ONLINE\|\|BUSSTHINK') | md5('4000') | md5('POL') | md5('DDD') | md5('ONLINE') | md5('BUSSTHINK') | 2020-01-14 | CRM    |
     | md5('5000\|\|FRA\|\|FFF\|\|SHOP\|\|DATAVAULT')   | md5('5000') | md5('FRA') | md5('FFF') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | CRM    |
     | md5('6000\|\|FRA\|\|GGG\|\|SHOP\|\|DATAVAULT')   | md5('6000') | md5('FRA') | md5('GGG') | md5('SHOP')   | md5('DATAVAULT') | 2020-01-14 | CRM    |
     | md5('7000\|\|DEU\|\|HHH\|\|SHOP\|\|BUSSTHINK')   | md5('7000') | md5('DEU') | md5('HHH') | md5('SHOP')   | md5('BUSSTHINK') | 2020-01-15 | WEB    |
     | md5('8000\|\|SPA\|\|III\|\|ONLINE\|\|DATAVAULT') | md5('8000') | md5('SPA') | md5('III') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-15 | WEB    |

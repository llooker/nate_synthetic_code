view: dcorders {
  sql_table_name: [DATA_SOURCE].[dbo].[nv_doDetail] ;;

#######################
### Original Dimensions
#######################

  dimension: facility {
    type: string
    sql: ${TABLE}.facility ;;
  }

  dimension: pat_urn {
    type: string
    sql: ${TABLE}.patURN ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

#######################
### Derived Dimensions
#######################

  dimension: facility_length {
    type: string
    sql: case when charindex('-', ${facility}) = 0 then len(${facility}) else charindex('-', ${facility}, 1) -1 end) ;;
  }

#######################
### Measures
#######################

}

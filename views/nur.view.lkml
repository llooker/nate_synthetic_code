view: nur {
  sql_table_name: [DATA_SOURCE].[dbo].[nv_nurdetail] ;;

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

#######################
### Measures
#######################

}

view: nur {
  sql_table_name:  ;;

#######################
### Original Dimensions
#######################

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

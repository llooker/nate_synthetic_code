view: beds {
  sql_table_name:  ;;

#######################
### Original Dimensions
#######################

  dimension: facility {
    type: string
    sql: ${TABLE}.facility ;;
  }

  dimension: room_overflow {
    type: string
    sql: ${TABLE}.roomOverflow ;;
  }

  dimension: roombed {
    type: string
    sql: ${TABLE}.roombed ;;
  }

  dimension: roomname {
    type: string
    sql: ${TABLE}.roomname ;;
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
      year,
      day_of_week,
      week_of_year,
      month_name,
      hour_of_day
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

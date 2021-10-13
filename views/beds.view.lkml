view: beds {
  sql_table_name: [DATA_SOURCE].[dbo].nv_BedsHCA ;;

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
    label: "Room Bed"
    type: string
    sql: ${TABLE}.roombed ;;
  }

  dimension: roomname {
    label: "Room Name"
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

  measure: latest_time {
    type: date_time
    sql: max(${timestamp_time}) ;;
  }
}

view: beds {
  sql_table_name: [DATA_SOURCE].[dbo].nv_BedsHCA ;;

#######################
### Original Dimensions
#######################

  dimension: facility {
    type: string
    sql: rtrim(${TABLE}.facility) ;;
  }

  dimension: room_overflow {
    type: string
    sql: ${TABLE}.roomOverflow ;;
  }

  dimension: bed {
    type: string
    sql: ${TABLE}.roomBed ;;
  }

  dimension: unit {
    type: string
    sql: ${TABLE}.roomLoc ;;
  }

  dimension: room {
    type: string
    sql: ${TABLE}.roomName ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.roomstate ;;
  }

  dimension: blocked_reason {
    type: string
    sql: ${TABLE}.evsreason ;;
  }

  dimension: blocked_reason_comment {
    type: string
    sql: ${TABLE}.evscomment ;;
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

## Simple changes

  dimension: mnemonic {
    type: string
    sql: ${facility} ;;
  }

  dimension: bed_id {
    type: string
    sql: concat(${room}, '-', ${bed}) ;;
  }

  dimension: name {
    type: string
    sql: ${bed_id} ;;
  }

  dimension: is_patient_absent {
    type: yesno
    sql: ${pat.patient_row_number} is null ;;
  }

#######################
### Measures
#######################

  measure: latest_time {
    type: date_time
    sql: max(${timestamp_time}) ;;
  }

  measure: total_beds {
    type: count
  }

  measure: total_available_beds {
    type: count
    filters: [is_patient_absent: "Yes"]
  }

  measure: total_occupied_beds {
    type: number
    sql: ${total_beds} - ${total_available_beds} ;;
  }

  measure: percent_occupied_beds {
    type: number
    sql: ${total_occupied_beds} / nullif(${total_beds},0) ;;
    value_format_name: percent_1
  }
}

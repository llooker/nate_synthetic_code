view: pat {
  sql_table_name:  ;;

#######################
### Original Dimensions
#######################

  dimension: accid {
    type: number
    sql: ${TABLE}.accid ;;
  }

  dimension_group: dis_time {
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
    sql: ${TABLE}.dis_time ;;
  }

  dimension: facility {
    type: string
    sql: ${TABLE}.facility ;;
  }

  dimension: pat_status {
    type: string
    sql: ${TABLE}.pat_status ;;
  }

  dimension: patient_row_number {
    type: string
    sql: ${TABLE}.patient_row_number ;;
  }

  dimension: roombed {
    type: string
    sql: ${TABLE}.roombed ;;
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

  dimension: facility_join {
    type: string
    sql:
      case
        when left(rtrim(${facility},5) = 'COCWM' then 'COCWM'
        else rtrim(${facility}
      end
    ;;
  }

#######################
### Measures
#######################


}

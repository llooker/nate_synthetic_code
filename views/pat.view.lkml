view: pat {
  sql_table_name: [DATA_SOURCE].[dbo].[nv_patDetail] ;;

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
    sql: ${TABLE}.disTime ;;
  }

  dimension: facility {
    type: string
    sql: ${TABLE}.facility ;;
  }

  dimension_group: last_update {
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
    sql: ${TABLE}.lastUpdate ;;
  }

  dimension: pat_status {
    type: string
    sql: ${TABLE}.patStatus ;;
  }

  dimension: patient_row_number {
    type: string
    sql: ${TABLE}.patient_row_number ;;
  }

  dimension: pat_urn {
    type: string
    sql: ${TABLE}.patURN ;;
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

  dimension: facility_length {
    type: string
    sql: case when charindex('-', ${facility}) = 0 then len(${facility}) else charindex('-', ${facility}, 1) -1 end) ;;
  }

#######################
### Measures
#######################

  measure: max_last_update {
    type: time
    sql: max(${last_update_raw}) ;;
  }

}

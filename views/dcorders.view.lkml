view: dcorders {
  sql_table_name: [DATA_SOURCE].[dbo].[nv_doDetail] ;;

#######################
### Original Dimensions
#######################

  dimension: discharge_order_conditions_physician {
    type: string
    sql: ${TABLE}.doWPdoc ;;
  }

  dimension_group: do_rtd {
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
    sql: ${TABLE}.doRTDtime ;;
  }

  dimension: do_rtd_nurse {
    type: string
    sql: ${TABLE}.doRTDnurse ;;
  }

  dimension_group: do_wp {
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
    sql: ${TABLE}.dowptime ;;
  }

  dimension: discharge_order_conditions {
    type: string
    sql: ${TABLE}.doWPConditions ;;
  }

  dimension_group: discharge_order_ts {
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
    sql: convert(varchar,${TABLE}.doUNCONDTime, 126)  ;;
  }

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

  dimension: is_discharge_order {
    type: yesno
    sql:
          (${discharge_order_ts_raw} is not null and ${do_wp_raw} is not null and ${discharge_order_ts_raw} > ${do_wp_raw})
      OR  (${discharge_order_ts_raw} is not null and ${do_wp_raw} is null )
    ;;
  }

  dimension: d_dis_order {
    type: yesno
    sql:
          (${discharge_order_ts_raw} is not null and ${do_wp_raw} is not null and ${discharge_order_ts_raw} > ${do_wp_raw})
      OR  (${discharge_order_ts_raw} is not null and ${do_wp_raw} is null )
    ;;
  }

  dimension: is_pending_discharge_order {
    type: yesno
    sql:
          (${discharge_order_ts_raw} is null and ${do_wp_raw} is not null)
      OR  (${discharge_order_ts_raw} is not null and ${do_rtd_raw} is null )
    ;;
  }

  dimension_group: pending_discharge_ts {
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
    sql:
      case
        when ${discharge_order_ts_raw} is not null and ${do_wp_raw} is not null and ${discharge_order_ts_raw} > ${do_wp_raw} then null
        when ${do_rtd_raw} is not null then convert(varchar, ${do_rtd_raw}, 126)
        else convert(varchar,${do_wp_raw}, 126)
      end
    ;;
  }

  dimension_group: current_time {
    type: time
    timeframes: [
      raw
    ]
    sql: CURRENT_TIMESTAMP ;;
  }

  dimension_group: pending_until_departure {
    type: duration
    timeframes: [hour]
    sql_start: ${current_time_raw} ;;
    sql_end: ${pending_discharge_ts_raw} ;;
  }

#######################
### Measures
#######################

  measure: total_potential_discharges_today {
    type: count
    filters: [hours_pending_until_departure: "<24"]
  }

  measure: total_potential_discharges_tomorrow {
    type: count
    filters: [hours_pending_until_departure: ">24,<48"]
  }

}

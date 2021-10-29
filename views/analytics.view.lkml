
##################
### Analytics
##################

view: analytics {

  parameter: real_time_vs_historical {
    type: unquoted
    default_value: "real_time"
    allowed_value: {
      label: "Real Time"
      value: "real_time"
    }
    allowed_value: {
      label: "Historical"
      value: "historical"
    }
  }
}

##################
### PDTs
##################

view: update_time {
  derived_table: {
    explore_source: beds_latest_time {
      column: latest_time { field: beds.latest_time }
    }
  }
  dimension: last_update {
    type: date_time
    sql: ${TABLE}.latest_time ;;
  }

  dimension: bmac_update_time {
    type: date_time
    sql: left(Convert(varchar, ${last_update} AT TIME ZONE 'Eastern Standard Time' AT TIME ZONE 'UTC', 126), 19) ;;
  }
}

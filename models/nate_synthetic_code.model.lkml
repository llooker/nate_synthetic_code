connection: "gcp_hca_poc"

# # include all the views
include: "/views/**/*.view"

explore: beds {
  view_label: "Beds"

  sql_always_where:
    NOT (${beds.room_overflow} = 1 and ${pat.accid} is null)
    AND
      {% if analytics.real_time_vs_historical._parameter_value == 'real_time' %} ${update_time.last_update} is not null
      {% elsif analytics.real_time_vs_historical._parameter_value == 'historical' %} 1 = 1
      {% else %} ${update_time.last_update} is not null
      {% endif %}
  ;;

  always_filter: {
    filters: [analytics.real_time_vs_historical: "real^_time"]
  }

  join: pat {
    view_label: "Patients"
    relationship: one_to_one
    sql_on:
           ${beds.timestamp_raw} = ${pat.timestamp_raw}
       AND rtrim(${beds.facility}) = ${pat.facility_join}
       AND ${beds.bed_id} = rtrim(${pat.room_bed})
     ;;
    sql_where:
          ${pat.dis_raw} is null
      AND ${pat.patient_status} in ('ADM IN', 'PRE ER', 'REG ER', 'REG CLI', 'REG RCR', 'REG SDC')
      AND ${pat.patient_row_number} = 1
      ;;
  }

  join: dcorders {
    view_label: "DC Orders"
    relationship: one_to_one
    sql_on:
          ${beds.timestamp_raw} = ${dcorders.timestamp_raw}
      AND left(${pat.facility}, ${pat.facility_length}) = left(${dcorders.facility},${dcorders.facility_length})
      AND ${pat.urn}=${dcorders.pat_urn}
    ;;
  }

  join: nur {
    view_label: "Nurses"
    relationship: one_to_one
    sql_on:
          ${beds.timestamp_raw} = ${nur.timestamp_raw}
      AND ${pat.facility} = ${nur.facility}
      AND ${pat.urn} = ${nur.pat_urn}
    ;;
  }

  join: analytics {
    relationship: one_to_one
    sql: ;;
  }

  join: update_time {
    relationship: one_to_one
    sql_on: ${beds.timestamp_time} = ${update_time.last_update} ;;
  }
}

explore: beds_latest_time {
  hidden: yes
  from: beds
  view_name: beds

  # Note: add a cross-join folder and remove this later
  join: pat {
    relationship: one_to_one
    fields: []
    sql: ;;
  }
}

datagroup: nate_synthetic_code_default_datagroup {
  sql_trigger: SELECT MAX(timestamp) FROM [DATA_SOURCE].[dbo].nv_BedsHCA ;;
  max_cache_age: "1 hour"
}

persist_with: nate_synthetic_code_default_datagroup

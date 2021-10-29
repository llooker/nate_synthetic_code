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

  dimension_group: o2_device06_ts {
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
    sql: ${TABLE}.o2_device06_ts ;;
  }

  dimension_group: o2_device10_ts {
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
    sql: ${TABLE}.o2_device10_ts ;;
  }

  dimension: o2_device06 {
    type: string
    sql: ${TABLE}.o2Device06 ;;
  }

  dimension: o2_device10 {
    type: string
    sql: ${TABLE}.o2Device10 ;;
  }

  dimension: sp_o2 {
    type: number
    sql: TRY_CONVERT(float,${TABLE}.o2Saturation) ;;
  }

  dimension_group: sp_o2_ts {
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
    sql: convert(varchar, ${TABLE}.o2SaturationTs, 126) ;;
  }

  dimension: o2_fi {
    type: string
    sql: ${TABLE}.o2Fi ;;
  }

  dimension_group: o2_fi_ts {
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
    sql: convert(varchar, ${TABLE}.o2FiTs, 126) ;;
  }

  dimension: o2_liters {
    type: string
    sql: ${TABLE}.o2Liters ;;
  }

  dimension_group: o2_liters_ts {
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
    sql: ${TABLE}.o2LitersTs ;;
  }

  dimension: weight {
    type: number
    sql: rtrim(cast(${TABLE}.wtkg) as char)) ;;
  }

  dimension_group: vent_ts {
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
    sql: ${TABLE}.ventStart ;;
  }

#######################
### Derived Dimensions
#######################

## O2 Device

  dimension: o2_device {
    type: string
    sql:
      case
        when (${o2_device06_ts_raw} >= ${o2_device10_ts_raw} OR ${o2_device10} is null) then ${o2_device06}
        else ${o2_device10}
      end
    ;;
  }

  dimension_group: o2_device_ts {
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
        when (${o2_device06_ts_raw} >= ${o2_device10_ts_raw} OR ${o2_device10} is null) then ${o2_device06_ts_raw}
        else ${o2_device10_ts_raw}
      end
    ;;
  }

  dimension_group: oxygen_therapy_ts {
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
    sql: convert(varchar, ${o2_device_ts_raw}, 126) ;;
  }

  dimension: oxygen_therapy_type {
    type: string
    sql: ${o2_device} ;;
  }

  dimension: bipap_ind {
    type: yesno
    sql: ${o2_device} like '%BiPAP%' ;;
  }

  dimension: cpap_ind {
    type: yesno
    sql: ${o2_device} like '%CPAP%' ;;
  }

  dimension: high_flow_nc_ind {
    type: yesno
    sql: ${o2_device} like '%High Flow%' ;;
  }

  dimension: nc_ind {
    type: yesno
    sql: ${o2_device} = 'Nasal cannula' ;;
  }

  dimension: room_air_ind {
    type: yesno
    sql: ${o2_device} = 'Room air' ;;
  }

  dimension: patient_on_vent_flag {
    type: yesno
    sql: ${o2_device} = 'Ventilator' ;;
  }

  dimension: oxygen_therapy_desc {
    type: string
    sql:
      case
        when ${o2_device} IN ('Nasal Cannula', 'High flow nasal cannula') THEN concat(TRY_CONVERT(Integer, ${o2_liters}), 'L')
        ELSE null
      end
    ;;
  }

  dimension: o2_flow_rate {
    type: number
    sql: TRY_CONVERT(float, ${o2_liters}) ;;
  }

  dimension_group: o2_flow_ts {
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
    sql: CASE WHEN ${o2_device} IN ('Nasal Cannula', 'High flow nasal cannula') THEN convert(varchar, ${o2_liters_ts_raw}, 126) END ;;
  }

#######################
### Measures
#######################

}

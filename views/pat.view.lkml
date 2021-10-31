view: pat {
  sql_table_name:
  (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY pat.facility, pat.roombed ORDER BY pat.lastUpdate DESC) as patient_row_number
  [DATA_SOURCE].[dbo].[nv_patDetail] pat
  );;

#######################
### Original Dimensions
#######################

  dimension: adm_doc {
    type: string
    sql: ${TABLE}.admDoc ;;
  }

  dimension: adm_doc_name {
    type: string
    sql: ${TABLE}.admDocName ;;
  }

  dimension: adm_doc_spec_code {
    type: string
    sql: ${TABLE}.admDocSpecCode ;;
  }

  dimension_group: admitTs {
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
    sql: convert(varchar, ${TABLE}.admTime, 126) ;;
  }

  dimension_group: arrivalTs {
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
    sql: convert(varchar, ${TABLE}.arrTime, 126) ;;
  }

  dimension: attending_physician {
    type: string
    sql: ${TABLE}.attDoc ;;
  }

  dimension: att_doc_name {
    type: string
    sql: ${TABLE}.attDocName ;;
  }

  dimension: attending_physician_group {
    type: string
    sql: coalesce(${TABLE}.attDocGroup, 'None on record') ;;
  }

  dimension: covid19_vac_status {
    type: string
    sql: ${TABLE}.covid19VacStatus ;;
  }

  dimension: covid19_vac_status_assess {
    type: string
    sql: ${TABLE}.covid19VacStatusAssess ;;
  }

  dimension: covid19_vac_status_assess_ts {
    type: string
    sql: convert(varchar, ${TABLE}.covid19VacStatusAssessTS, 126) ;;
  }

  dimension: covid19_vac_man1 {
    type: string
    sql: ${TABLE}.covid19VacMan1 ;;
  }

  dimension: covid19_vac_man2 {
    type: string
    sql: ${TABLE}.covid19VacMan2 ;;
  }

  dimension_group: dis {
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
    sql: rtrim(${TABLE}.facility) ;;
  }

  dimension: icu {
    type: string
    sql: ${TABLE}.icu ;;
  }

  dimension: icu_rev {
    type: yesno
    sql: ${TABLE}.icuRev = '1' ;;
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

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: loc_type {
    type: string
    sql: ${TABLE}.locType ;;
  }

  dimension_group: obs {
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
    sql: convert(varchar, ${TABLE}.obsTime, 126) ;;
  }

  dimension: accid {
    type: number
    sql: cast(rtrim(${TABLE}.patAcctNo) as char) ;;
  }

  dimension: age {
    type: number
    sql: rtrim(cast(${TABLE}.patAge as char)) ;;
  }

  dimension: pat_fc {
    type: string
    sql: ${TABLE}.patFc ;;
  }

  dimension: financial_class {
    type: string
    sql: rtrim(cast(${TABLE}.patFcCode as char)) ;;
  }

  dimension: insurance {
    type: string
    sql: ${TABLE}.patIPlan ;;
  }

  dimension: pat_name {
    type: string
    sql: ${TABLE}.patName ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.patSex ;;
  }

  dimension: patient_status {
    type: string
    sql: ${TABLE}.patStatus ;;
  }

  dimension: patient_row_number {
    type: string
    sql: ${TABLE}.patient_row_number ;;
  }

  dimension: urn {
    type: string
    sql: rtrim(${TABLE}.patUrn) ;;
  }

  dimension: chief_complaint {
    type: string
    sql: ${TABLE}.rfv ;;
  }

  dimension: room_bed {
    type: string
    sql: ${TABLE}.roomBed ;;
  }

  dimension: service_level {
    type: string
    sql: ${TABLE}.roomSvcCode ;;
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

### COVID logic

  dimension: covid19_vac_status_flag {
    type: yesno
    sql:
          (${covid19_vac_status} = 'Up to Date')
      OR  (${covid19_vac_man1} = 'Pfizer' and ${covid19_vac_man2} = 'Pfizer')
      OR  (${covid19_vac_man1} = 'Moderna' and ${covid19_vac_man2} = 'Moderna')
      OR  (${covid19_vac_man1} = 'Jannsen/J and J')
    ;;
  }

  dimension: covid19_vac_status_text {
    type: yesno
    sql:
      case
        when ${covid19_vac_status_flag} then 'Fully vaxxed'
        when ${covid19_vac_man1} = 'Pfizer' and (${covid19_vac_man2} = 'Unknown' or ${covid19_vac_man2} is null) then 'Partially vaxxed'
        when ${covid19_vac_man1} = 'Moderna' and (${covid19_vac_man2} = 'Unknown' or ${covid19_vac_man2} is null) then 'Partially vaxxed'
        when ${covid19_vac_man1} = 'Pfizer' and ${covid19_vac_man2} = 'Moderna' then 'Partially vaxxed'
        when ${covid19_vac_man1} = 'Moderna' and ${covid19_vac_man2} = 'Pfizer' then 'Partially vaxxed'
        when ${covid19_vac_man1} = 'Unkown' then 'Unknown'
        when ${covid19_vac_man1} is null and ${covid19_vac_man2} is null and (${covid19_vac_status} like '%unknown%' or ${covid19_vac_status} like '%Unable to assess%') then 'Unknown'
        when ${covid19_vac_man1} is null and ${covid19_vac_man2} is null and (${covid19_vac_status} like '%candidate%' or ${covid19_vac_status} like '%declines%') then 'Not vaxxes'
        else 'Unknown'
      end
    ;;
  }

  dimension: fully_vac_flag {
    type: yesno
    sql: ${covid19_vac_status_text} = 'Fully vaxxed' ;;
  }

  dimension: partially_vac_flag {
    type: yesno
    sql: ${covid19_vac_status_text} = 'Partially vaxxed' ;;
  }

  dimension: fully_or_patially_vac {
    type: yesno
    sql: ${fully_vac_flag} or ${partially_vac_flag} ;;
  }

  dimension: not_vac_flag {
    type: yesno
    sql: ${covid19_vac_status_text} = 'Not vaxxed' ;;
  }

  dimension: unknown_vac_flag {
    type: yesno
    sql: ${covid19_vac_status_text} = 'Unknown' ;;
  }

### Join Logic

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

## Payor Type

  dimension: payor_type {
    type: string
    sql:
        case
            when patFc in ('NULL', '***UNKNOWN','UNASSIGNED', 'UNKNOWN', 'UNKNOWN***********8', 'UNKNOWN*INACTIVE*', 'UNKNOWN/HOSPICE') then 'N/A'
            when patFc in ('PREPAY/NO STATEMENT', 'PRIVATE PAY', 'SELF PAY', 'SELF PAY  (NO INSURANCE)', 'SELF PAY (NO INSURANCE)', '99 SELF PAY','99 SELF-PAY','15 CHARITY','CHARITY') then 'Self Pay'
            when patFc like ('%Unknown%') then 'N/A'
            when patFc like ('%Unassigned%') then 'N/A'
            when patFc like ('%Inactive%') then 'N/A'
            when patFc like ('%Self%') then 'Self Pay'
            when patFc like ('%Charity%') then 'Self Pay'
            when patFc like ('%Private%') then 'Self Pay'
            when patFc like ('%Prepay%') then 'Self Pay'
            else 'Insured'
          end
    ;;
  }

## Length of Stay

  dimension_group: current_time {
    type: time
    timeframes: [
      raw
    ]
    sql: CURRENT_TIMESTAMP ;;
  }

  dimension_group: obs_los {
    type: duration
    timeframes: [hour]
    sql_start: ${obs_raw} ;;
    sql_end: ${current_time_raw} ;;
  }

### Name

  dimension: last_name {
    type: string
    sql: substring(${pat_name}, 1, CHARINDEX(',',${pat_name})-1) ;;
  }

  dimension: first_name {
    type: string
    sql: substring(${pat_name}, CHARINDEX(',',${pat_name})+1, LEN(${pat_name})) ;;
  }

### Unsure dimensions

  dimension: covid_status {
    type: string
    sql: 'unknown' ;;
  }

  dimension: is_covid_positive {
    type: yesno
    sql: ${covid_status} = 'Positive' ;;
  }

  dimension: encounter_type {
    type: string
    sql: 'unknown' ;;
  }

  dimension: is_ed {
    type: yesno
    sql: ${encounter_type} = 'ED' ;;
  }

#######################
### Measures
#######################

  measure: max_last_update {
    type: time
    sql: max(${last_update_raw}) ;;
  }

  measure: total_known_patients_vaccinated {
    type: count
    filters: [fully_or_patially_vac: "Yes"]
  }

  measure: total_covid_positive_known_vaccinated {
    type: count
    filters: [is_covid_positive: "Yes", fully_vac_flag: "Yes"]
  }

  measure: total_covid_positive {
    type: count
    filters: [is_covid_positive: "Yes"]
  }

  measure: percent_covid_positive_known_vaccinated {
    type: number
    sql: ${total_covid_positive_known_vaccinated} / nullif(${total_covid_positive},0) ;;
    value_format_name: percent_1
  }

  measure: total_ed_patients {
    type: count
    filters: [is_ed: "Yes"]
  }
}

connection: "gcp_hca_poc"

# # include all the views
# include: "/views/**/*.view"

# explore: beds {
#   view_label: "Beds"

#   sql_always_where: NOT (${beds.room_overflow} = 1 and ${pat.accid} is null)  ;;

#   join: pat {
#     view_label: "Patients"
#     relationship: one_to_one
#     sql_on:
#           ${beds.timestamp_raw} = ${pat.timestamp_raw}
#       AND rtrim(${beds.facility}) =
#         case
#           when left(rtrim(${pat.facility},5) = 'COCWM' then 'COCWM'
#           else rtrim(${pat.facility}
#         end
#       AND rtrim(${beds.roomname} || '-' || ${beds.roombed}) = rtrim(${pat.roombed})
#     ;;
#     sql_where:
#           ${pat.dis_time} is null
#       AND ${pat.pat_status} in ('ADM IN', 'PRE ER', 'REG ER', 'REG CLI', 'REG RCR', 'REG SDC')
#       AND ${pat.patient_row_number} = 1
#       ;;
#   }

#   join: dcorders {
#     view_label: "DC Orders"
#     relationship: one_to_one
#     sql_on:
#           ${beds.timestamp_raw} = ${dcorders.timestamp_raw}
#       AND left(${pat.facility}, ${pat.facility_length}) = left(${dcorders.facility},${dcorders.facility_length})
#       AND ${pat.pat_urn}=${dcorders.pat_urn}
#     ;;
#   }

#   join: nur {
#     view_label: "Nurses"
#     relationship: one_to_one
#     sql_on:
#           ${beds.timestamp_raw} = ${nur.timestamp_raw}
#       AND ${pat.facility} = ${nur.facility}
#       AND ${pat.pat_urn} = ${nur.pat_urn}
#     ;;
#   }

#   join: update_time {
#     relationship: one_to_one
#     sql_on: 1 = 1  ;;
#   }
# }

# # Facility facility_length
# # case when  charindex('-', pat.facility ) = 0 then len(pat.facility) else charindex('-', pat.facility, 1) -1 end)

# # Facility pat_URN
# # patURN

# # dcorders facility_length
# # case when  charindex('-', dcorders.facility ) = 0 then len(dcorders.facility) else charindex('-', dcorders.facility, 1) -1 end)

# # dcorders pat_URN
# # patURN

# # nurses pat_URN
# # patURN

# # patient dis_time
# # pat.disTime

# # pat pat_status
# # pat.patStatus



# # SELECT
# # FROM [DATA_SOURCE].[dbo].nv_BedsHCA beds
# # LEFT JOIN
# # (
# #     Select
# #     from
# #     (
# #         select
# #         from [DATA_SOURCE].[dbo].[nv_patDetail] pat
# #         left join [DATA_SOURCE].[dbo].[nv_doDetail] dcorders
# #         on left(pat.facility,
# #             case when  charindex('-', pat.facility ) = 0 then len(pat.facility)
# #                     else charindex('-', pat.facility, 1) -1 end) = left(dcorders.facility,
# #             case when  charindex('-', dcorders.facility ) = 0 then len(dcorders.facility)
# #                     else charindex('-', dcorders.facility, 1) -1 end)
# #             and pat.patURN=dcorders.patURN
# #             and pat.patURN=dcorders.patURN
# #         left join [DATA_SOURCE].[dbo].[nv_nurdetail] nur
# #             on pat.facility = nur.facility
# #             and pat.patURN=nur.patURN
# #         where 1=1
# #         and pat.disTime is null
# #         and pat.patStatus in ('ADM IN', 'PRE ER', 'REG ER', 'REG CLI', 'REG RCR', 'REG SDC')
# #     ) pat
# #     where pat.patient_row_number = 1
# # ) pat
# #     on
# #         case when
# #         left(rtrim(pat.facility), 5) = 'COCWM' then 'COCWM'
# #         else rtrim(pat.facility)
# #         end = rtrim(beds.facility)
# #     and rtrim(pat.roombed) = concat(rtrim(beds.roomname), '-', rtrim(beds.roombed))
# # Left Join (
# #     select max(lastUpdate) as lastUpdate from [DATA_SOURCE].[dbo].[nv_patDetail] pat
# # ) update_time
# #     on 1=1
# # where not (beds.roomOverflow = 1 and pat.accid is null)




# datagroup: nate_synthetic_code_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "1 hour"
# }

# persist_with: nate_synthetic_code_default_datagroup

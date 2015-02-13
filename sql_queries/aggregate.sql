insert into request_logs (reques_id, created_at, stopped, answered, cancelled, stopped_at, answered_at, cancelled_at, wait_length, call_length)(
select distinct requests.id, request_createds.created_at,  
CASE WHEN request_stoppeds.id is not null then 'yes' else 'no' end as stopped, 
CASE WHEN request_answereds.id is not null then 'yes' else 'no' end as answered,
CASE WHEN request_cancelleds.id is not null then 'yes' else 'no' end as cancelled,
request_stoppeds.created_at as stopped_at,
request_answereds.created_at as answered_at,
request_cancelleds.created_at as cancelled_at,
request_answereds.created_at- request_createds.created_at as wait_length,
request_stoppeds.created_at - request_answereds.created_at as call_length
from requests
left outer join request_stoppeds 
on request_stoppeds.request_id = requests.id
left outer join request_answereds 
on request_answereds.request_id = requests.id
left outer join request_cancelleds 
on request_cancelleds.request_id = requests.id
left outer join request_createds 
on request_createds.request_id = requests.id);

select requests.id, request_createds.created_at,  
CASE WHEN request_stoppeds.id is not null then 1 else 0 end as stopped, 
CASE WHEN request_answereds.id is not null then 1 else 0 end as answered,
CASE WHEN request_cancelleds.id is not null then 1 else 0 end as cancelled,
request_stoppeds.created_at as stopped_at,
request_answereds.created_at as answered_at,
request_cancelleds.created_at as cancelled_at
from requests
left outer join request_stoppeds 
on request_stoppeds.request_id = requests.id
left outer join request_answereds 
on request_answereds.request_id = requests.id
left outer join request_cancelleds 
on request_cancelleds.request_id = requests.id
left outer join request_createds 
on request_createds.request_id = requests.id;
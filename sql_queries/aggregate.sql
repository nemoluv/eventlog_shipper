select requests.id, request_createds.created_at,  request_stoppeds.id as stopped, request_answereds.id as answered, request_cancelleds.id as cancelled
from requests
left outer join request_stoppeds 
on request_stoppeds.request_id = requests.id
left outer join request_answereds 
on request_answereds.request_id = requests.id
left outer join request_cancelleds 
on request_cancelleds.request_id = requests.id
left outer join request_createds 
on request_createds.request_id = requests.id
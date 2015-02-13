insert into request_logs (reques_id, created_at, stopped, answered, cancelled, stopped_at, answered_at, cancelled_at, wait_length, call_length)(
select distinct requests.id, cr.created_at,  
CASE WHEN s.request_id is not null then 'yes' else 'no' end as stopped, 
CASE WHEN a.request_id is not null then 'yes' else 'no' end as answered,
CASE WHEN c.request_id is not null then 'yes' else 'no' end as cancelled,
s.created_at as stopped_at,
a.created_at as answered_at,
c.created_at as cancelled_at,
a.created_at- cr.created_at as wait_length,
s.created_at - a.created_at as call_length
from requests
left outer join  (select distinct on (request_id) request_id, created_at from request_stoppeds) as s
on s.request_id = requests.id
left outer join  (select distinct on (request_id) request_id, created_at from request_answereds) as a
on a.request_id = requests.id
left outer join  (select distinct on (request_id) request_id, created_at from request_cancelleds) as c
on c.request_id = requests.id
left outer join  (select distinct on (request_id) request_id, created_at from request_createds) as cr
on cr.request_id = requests.id);

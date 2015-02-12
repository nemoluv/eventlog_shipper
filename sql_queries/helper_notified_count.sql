SELECT requests.id, count(*)
FROM requests 
JOIN helper_notifieds ON (helper_notifieds.request_id = requests.id)
GROUP BY requests.id
CREATE TABLE request_logs
(
  reques_id text,
  created_at timestamp without time zone,
  stopped text,
  answered text,
  cancelled text,
  stopped_at timestamp without time zone,
  answered_at timestamp without time zone,
  cancelled_at timestamp without time zone,
  wait_length interval,
  call_length interval,
  helpers_notified integer
)

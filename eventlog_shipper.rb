require 'mongo_mapper'
require 'rubygems'
require 'yaml'
require 'sequel'
require 'json'
require_relative './models/event_log'
require_relative './models/event_log_object'

def load_config
  YAML.load_file('config/config.yml')
end

def setup_mongo config
  db_config = config['database']
  MongoMapper.connection = Mongo::Connection.new(db_config['host'])
  MongoMapper.database = db_config['name']
  if db_config.has_key? 'username'
    MongoMapper.connection[db_config['name']].authenticate(db_config['username'], db_config['password'])
  else
    MongoMapper.connection[db_config['name']]
  end
end

def connect_pg
  $db = Sequel.connect('postgres://khebbie:@localhost:5432/bme_analytics')
  Sequel::Model.db= $db
end

def create_tables
  $db.run('CREATE TABLE requests (id text CONSTRAINT firstkey PRIMARY KEY);')
  $db.run('CREATE TABLE request_createds
(
  id SERIAL,
  request_id text NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  CONSTRAINT pk_request_created PRIMARY KEY (id),
  CONSTRAINT fk1_request_created FOREIGN KEY (request_id)
      REFERENCES requests (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)')
  $db.run('CREATE TABLE request_answereds
(
  id SERIAL,
  request_id text NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  CONSTRAINT pk_request_answered PRIMARY KEY (id),
  CONSTRAINT fk1_request_answered FOREIGN KEY (request_id)
      REFERENCES requests (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)')
  $db.run('CREATE TABLE request_stoppeds
(
  id SERIAL,
  request_id text NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  CONSTRAINT pk_request_stopped PRIMARY KEY (id),
  CONSTRAINT fk1_request_stopped FOREIGN KEY (request_id)
      REFERENCES requests (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)')
  $db.run('CREATE TABLE request_cancelleds
(
  id SERIAL,
  request_id text NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  CONSTRAINT pk_request_cancelled PRIMARY KEY (id),
  CONSTRAINT fk1_request_cancelled FOREIGN KEY (request_id)
      REFERENCES requests (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)')
  $db.run('CREATE TABLE helper_notifieds
(
  id SERIAL,
  request_id text NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  CONSTRAINT pk_helper_notified PRIMARY KEY (id),
  CONSTRAINT fk1_helper_notified FOREIGN KEY (request_id)
      REFERENCES requests (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)')
end

def ship_event(event_name, klass)
  EventLog.find_each(name:event_name) do |el|
    print '.'
    json_serialized = el.event_log_objects[0].json_serialized
    request_id = JSON.load(json_serialized)
    unless request_id.is_a? String
      request_id = request_id["id"]
    end

    begin
      Object.const_get(klass).insert(:request_id => request_id, :created_at => el.created_at, :updated_at => el.updated_at)
    rescue => e
      puts "request not found #{request_id}, error #{e}"
    end
  end
end


config = load_config
setup_mongo config
connect_pg
# by design sequel expects a connection before requiring models
require_relative './pg_models/request'
require_relative './pg_models/events'
#create_tables

EventLog.find_each(name:'request_created') do |el|
  print '.'
  json_serialized = el.event_log_objects[0].json_serialized
  request_id = JSON.load(json_serialized)
  Request.insert(:id => request_id)
  Object.const_get("RequestCreated").insert(:request_id => request_id, :created_at => el.created_at, :updated_at => el.updated_at)
end

ship_event 'request_answered','RequestAnswered'
ship_event 'request_stopped','RequestStopped'
ship_event 'request_cancelled','RequestCancelled'
ship_event 'helper_notified','HelperNotified'


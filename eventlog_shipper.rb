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
  $db.run('CREATE TABLE request_created
(
  id integer NOT NULL,
  request_id text NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  CONSTRAINT pk_request_created PRIMARY KEY (id),
  CONSTRAINT fk1_request_created FOREIGN KEY (request_id)
      REFERENCES requests (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)')
end


config = load_config
setup_mongo config
connect_pg
# by design sequel expects a connection before requiring models
require_relative './pg_models/request'
require_relative './pg_models/request_created'
#create_tables

el =  EventLog.first(name:'request_created')
json_serialized = el.event_log_objects[0].json_serialized
request_id = JSON.load(json_serialized)
Request.insert(:id => request_id)

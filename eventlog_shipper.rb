require 'mongo_mapper'
require 'rubygems'
require 'yaml'
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

config = load_config
setup_mongo config

p EventLog.first


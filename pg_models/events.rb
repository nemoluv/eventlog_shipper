class RequestCreated< Sequel::Model
    set_primary_key :id
    many_to_one :request
end

class RequestAnswered< Sequel::Model
    set_primary_key :id
    many_to_one :request
end

class RequestStopped< Sequel::Model
    set_primary_key :id
    many_to_one :request
end

class RequestCancelled< Sequel::Model
    set_primary_key :id
    many_to_one :request
end

class HelperNotified< Sequel::Model
    set_primary_key :id
    many_to_one :request
end



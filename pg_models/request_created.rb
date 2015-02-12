class RequestCreated< Sequel::Model
    set_primary_key :id
    many_to_one :request
end


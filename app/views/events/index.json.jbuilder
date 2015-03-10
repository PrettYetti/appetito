json.array!(@events) do |event|
  json.extract! event, :id, :user_id, :when, :location, :finalized, :type
  json.url event_url(event, format: :json)
end

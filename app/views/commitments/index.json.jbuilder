json.array!(@commitments) do |commitment|
  json.extract! commitment, :id, :user_id, :date, :type
  json.url commitment_url(commitment, format: :json)
end

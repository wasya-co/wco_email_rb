
json.datapoints @results do |pt|
  next if !pt['_id']
  json.date  pt['_id']
  json.value pt['total']
end


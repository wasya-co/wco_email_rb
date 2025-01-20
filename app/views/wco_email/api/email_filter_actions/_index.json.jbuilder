
json.actions do
  json.array! items do |item|
    json.id    item.id.to_s
    json.kind  item.kind
    json.value item.value
  end
end


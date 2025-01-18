
json.actions do
  json.array! items do |item|
    json.kind  item.kind
    # json.name  item.to_s
    json.value item.value
  end
end


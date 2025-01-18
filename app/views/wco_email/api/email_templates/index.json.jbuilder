
json.items do
  json.array! @items do |item|
    json.label item.to_s
    json.value item.id.to_s
  end
end

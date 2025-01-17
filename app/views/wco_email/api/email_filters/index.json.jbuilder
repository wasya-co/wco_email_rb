
json.items do
  json.array! @items do |item|
    json.name item.to_s
  end
end


json.email_templates do
  json.array! @items do |item|
    json.label item.to_s
    json.vaue item.id.to_s
  end
end

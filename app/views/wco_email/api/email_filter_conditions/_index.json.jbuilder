
name ||= 'conditions'

json.set! name do
  json.array! items do |item|
    json.id        item.id.to_s
    json.field     item.field
    json.operator  item.operator
    json.value     item.value
  end
end


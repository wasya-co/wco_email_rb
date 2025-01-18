
name ||= 'conditions'

json.set! name do
  json.array! items do |item|
    json.field     item.field
    json.matchtype item.matchtype
    # json.name      item.to_s
    json.value     item.value
  end
end


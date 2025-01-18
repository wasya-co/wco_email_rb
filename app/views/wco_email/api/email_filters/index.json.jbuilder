
json.items do
  json.array! @items do |item|
    json.id item.id.to_s
    json.name item.to_s
    json.partial!( 'wco_email/api/email_filter_actions/index',    items: item.actions )
    json.partial!( 'wco_email/api/email_filter_conditions/index', items: item.conditions )
    json.partial!( 'wco_email/api/email_filter_conditions/index', items: item.skip_conditions, name: 'skip_conditions' )
  end
end

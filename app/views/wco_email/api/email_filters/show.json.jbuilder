
json.id @filter.id.to_s
json.name 'filter name'
json.partial! 'wco_email/api/email_filter_actions/index',    items: @filter.actions
json.partial! 'wco_email/api/email_filter_conditions/index', items: @filter.conditions
json.partial! 'wco_email/api/email_filter_conditions/index', items: @filter.skip_conditions, name: 'skip_conditions'

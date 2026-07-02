
tags_h = {
  '658db0d00f5b4f4471bdb3b7' => Wco::Tag.trash,
  '65a491e5689a5198434ecdb4' => Wco::Tag.spam,
  '658db0d00f5b4f4471bdb3b6' => Wco::Tag.inbox,
}

filters = JSON.parse File.read( 'tmp/filters.json' )

=begin
2113 total
-=---
512 trash
747 spam
123 inbox
479 autorespond-template (many)
247 autorespond-email-action
=end

## on annesque, move to trash
trash_filter = WcoEmail::EmailFilter.find '6a42e32fa68b1e6162c5c877'
## email.local, move to trash
trash_filter = WcoEmail::EmailFilter.find '678f62425fe5e54306118477'

## old trash: from_exact, subject_exact, and one subject_regex, 512
  filters.select { |f| f['kind'] == 'add-tag' &&
                      f['tag_id']['$oid'] == '658db0d00f5b4f4471bdb3b7' }.length
  filters.select { |f| f['kind'] == 'add-tag' &&
                      f['tag_id']['$oid'] == '658db0d00f5b4f4471bdb3b7' }.each_with_index do |old, idx|
    if old['from_exact'].length > 0
      cond = WcoEmail::EmailFilterCondition.new({
        field: WcoEmail::EmailFilterCondition::FIELD_FROM,
        operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
        value: old['from_exact'],
      })
    elsif old['subject_exact'].length > 0
      cond = WcoEmail::EmailFilterCondition.new({
        field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
        operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
        value: old['subject_exact'],
      })
    elsif old['subject_regex'].length > 0
      cond = WcoEmail::EmailFilterCondition.new({
        field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
        operator: WcoEmail::EmailFilterCondition::OPERATOR_REGEX,
        value: old['subject_regex'],
      })
    else
      puts old.inspect
      throw "unexpected ^ filter"
    end

    trash_filter.conditions << cond
    print "#{idx}."
  end
  trash_filter.save
##

## annesque
spam_filter = WcoEmail::EmailFilter.find '6a440471342ea3b6653f1fdc'
## old spam, 747
  filters.select { |f| f['kind'] == 'add-tag' && f['tag_id']['$oid'] == '65a491e5689a5198434ecdb4' }.length
  filters.select { |f| f['kind'] == 'add-tag' && f['tag_id']['$oid'] == '65a491e5689a5198434ecdb4' }.each_with_index do |old, idx|
    if old['from_exact'] == nil
      print "#{idx}."
    end
  end; nil
  filters.select { |f| f['kind'] == 'add-tag' && f['tag_id']['$oid'] == '65a491e5689a5198434ecdb4' }.drop(...).each_with_index do |old, idx|

    if old['from_exact'].length > 0
      cond = WcoEmail::EmailFilterCondition.new({
        field: WcoEmail::EmailFilterCondition::FIELD_FROM,
        operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
        value: old['from_exact'],
      })
    elsif old['subject_exact'].length > 0
      cond = WcoEmail::EmailFilterCondition.new({
        field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
        operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
        value: old['subject_exact'],
      })
    else
      puts old.inspect
      throw "unexpected ^ filter"
    end

    spam_filter.conditions << cond
    print "#{idx}."
  end ; nil
##





## old remove-tag inbox, 123
noinbox_filter = WcoEmail::EmailFilter.find '6a4431b2342ea3b6653f1fe7' ## annesque
filters.select { |f| f['kind'] == 'remove-tag' }.length
filters.select { |f| f['kind'] == 'remove-tag' && f['tag_id']['$oid'] == '658db0d00f5b4f4471bdb3b6' }.each_with_index do |old, idx|

  if old['from_exact'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_FROM,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
      value: old['from_exact'],
    })
  elsif old['subject_exact'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
      value: old['subject_exact'],
    })
  elsif old['subject_regex'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_REGEX,
      value: old['subject_regex'],
    })
  else
    puts old.inspect
    throw "unexpected ^ filter"
  end

  noinbox_filter.conditions << cond
  print "#{idx}."
end ; nil
##



## autorespond-template, 479
filters.select { |f| f['kind'] == 'autorespond-template' }.length
filters.select { |f| f['kind'] == 'autorespond-template' }.drop(1+267+192).each_with_index do |old, idx|
  nxt_action = WcoEmail::EmailFilterAction.find_or_create_by({
    kind: WcoEmail::EmailFilterAction::KIND_AUTORESPOND,
    aject: WcoEmail::EmailTemplate.find( old['email_template_id']['$oid'] ),
  })
  if !nxt_action.email_filter
    nxt_action.email_filter = WcoEmail::EmailFilter.new
    nxt_action.save
    nxt_action.email_filter.save
  end

  if old['from_exact'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_FROM,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
      value: old['from_exact'],
    })
  elsif old['subject_exact'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
      value: old['subject_exact'],
    })
  elsif old['subject_regex'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_REGEX,
      value: old['subject_regex'],
    })
  else
    puts old.inspect
    throw "unexpected ^ filter"
  end

  nxt_action.email_filter.conditions << cond
  print "#{idx}."
end ; nil
##


## autorespond-email-action, 247
filters.select { |f| f['kind'] == 'autorespond-email-action' }.length
filters.select { |f| f['kind'] == 'autorespond-email-action' }.drop(166+28+34+13+2).each_with_index do |old, idx|
  nxt_action = WcoEmail::EmailFilterAction.find_or_create_by({
    kind: WcoEmail::EmailFilterAction::KIND_EAT,
    aject: WcoEmail::EmailActionTemplate.find( old['email_action_template_id']['$oid'] ),
  })
  if !nxt_action.email_filter
    nxt_action.email_filter = WcoEmail::EmailFilter.new
    nxt_action.save
    nxt_action.email_filter.save
  end

  if old['from_exact'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_FROM,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
      value: old['from_exact'],
    })
  elsif old['subject_exact'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_MATCH,
      value: old['subject_exact'],
    })
  elsif old['subject_regex'].length > 0
    cond = WcoEmail::EmailFilterCondition.new({
      field: WcoEmail::EmailFilterCondition::FIELD_SUBJECT,
      operator: WcoEmail::EmailFilterCondition::OPERATOR_REGEX,
      value: old['subject_regex'],
    })
  else
    puts old.inspect
    throw "unexpected ^ filter"
  end

  nxt_action.email_filter.conditions << cond
  print "#{idx}."
end ; nil
##

##
## mongo
##

mongodump --uri="mongodb://127.0.0.1:27017/annesque_email_production"


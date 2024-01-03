
## clean
WcoEmail::EmailAction.each do |act|
  if !act.lead
    act.delete
  end
end
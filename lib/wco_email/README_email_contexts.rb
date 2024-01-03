
## clean
WcoEmail::Context.each do |ttt|
  if !ttt.lead
    ttt.delete
  end
end
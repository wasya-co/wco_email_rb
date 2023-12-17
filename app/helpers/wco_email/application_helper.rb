
module WcoEmail::ApplicationHelper

  def pretty_date date
    # date.to_s[0, 10]
    date&.strftime('%Y-%m-%d')
  end
  def pp_date a; pretty_date a; end

  def pp_datetime date
    date&.strftime('%Y-%m-%d %l:%M%P %z')
  end

  def pp_time date
    return nil if !date
    # return date.strftime('%l:%M%P %z')
    return date.in_time_zone( Rails.application.config.time_zone ).strftime('%l:%M%P')
  end

end

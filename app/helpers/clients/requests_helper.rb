module Clients::RequestsHelper
  def deadline_days_left(deadline)
    days_left = (deadline.to_date - Time.zone.today).to_i
    if days_left >= 0
      "あと#{days_left}日"
    else
      "募集締め切りました"
    end
  end
end

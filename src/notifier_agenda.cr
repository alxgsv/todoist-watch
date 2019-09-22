require "./notifier"
require "./telegram"

class NotifierAgenda < Notifier
  def initialize()
    @notified_days = [] of String
  end

  def notify(todoist, at = nil)
    time = at || Time.now(Time::Location.load("Europe/Samara"))

    return true if notified_at?(time)
    return true if !time_to_notify?(time)

    @notified_days << key_for_day(time)
    message = "Good morning! Your shopping list:\n"
    Telegram.notify(message + tasks_to_list(todoist.tasks))
  end

  def notified_at?(time)
    @notified_days.includes?(key_for_day(time))
  end

  def time_to_notify?(time)
    if time.day_of_week.saturday? || time.day_of_week.sunday?
      return true if time.hour == 10
    else
      return true if time.hour == 8
    end

    false
  end

  def key_for_day(time)
    time.to_s("%Y-%m-%d")
  end
end

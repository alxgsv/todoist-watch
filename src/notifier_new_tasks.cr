require "./notifier"
require "./telegram"

class NotifierNewTasks < Notifier
  def notify(tasks)
    return false if tasks.empty?

    Telegram.notify(tasks_to_list(tasks, "+"))
  end
end

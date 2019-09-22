require "./todoist"
require "./notifier_agenda"
require "./notifier_new_tasks"

todoist = Todoist.new
agenda_notifier = NotifierAgenda.new
new_tasks_notifier = NotifierNewTasks.new

todoist.sync

while true
  new_tasks = begin
    todoist.sync["new"]
  rescue
    sleep 30
    next
  end

  agenda_notifier.notify(todoist)
  new_tasks_notifier.notify(new_tasks)

  sleep 30
end

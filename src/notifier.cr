require "./task"

class Notifier
  def tasks_to_list(tasks = [] of Task, bullet = nil)
    tasks.map_with_index do |task, index|
      if bullet == nil
        "#{ index + 1}. #{task.content}"
      else
        "#{ bullet } #{task.content}"
      end
    end.join("\n")
  end
end

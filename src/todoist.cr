require "json"
require "http/client"

require "./task"

class Todoist
  def initialize
    @tasks = [] of Task
  end

  def tasks
    @tasks
  end

  def remote_tasks
    response = HTTP::Client.get(
      "https://api.todoist.com/rest/v1/tasks?project_id=#{ENV["TODOIST_PROJECT_ID"]}",
      headers: HTTP::Headers{"Authorization" => "Bearer #{ENV["TODOIST_API_TOKEN"]}"}
    )

    raise "Todoist API Error" if response.status_code != 200

    Array(Task).from_json(response.body)
  end

  def sync
    new_tasks = remote_tasks
    result = tasks_diff(new_tasks)
    @tasks = new_tasks
    result
  end

  def tasks_diff(new_tasks = [] of Task)
    diff_new = new_tasks.select{ |new_task| @tasks.find{ |old_task| old_task.id == new_task.id }.nil? }
    {
      "new" => diff_new
    }
  end
end

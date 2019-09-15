require "http/client"
require "json"
require "colorize"
require "uri"

class Task
  JSON.mapping(
    id: Int64,
    project_id: Int64,
    order: Int64,
    content: String,
    completed: Bool,
    label_ids: Array(Int64),
    priority: Int64,
    comment_count: Int64,
    created: String,
    url: String
  )

  def ==(other)
    id == other.id
  end
end

def get_state
  response = HTTP::Client.get(
    "https://api.todoist.com/rest/v1/tasks?project_id=#{ENV["TODOIST_PROJECT_ID"]}",
    headers: HTTP::Headers{"Authorization" => "Bearer #{ENV["TODOIST_API_TOKEN"]}"}
  )

  raise "Todoist API Error" if response.status_code != 200

  Array(Task).from_json(response.body)
end

def find_new_task_ids(new_state = [] of Task, old_state = [] of Task)
  new_state.map(&.id) - old_state.map(&.id)
end

def notify
  chat_ids = ENV["TELEGRAM_CHAT_IDS"].split(",")
  message = URI.escape("<a href='todoist://project?id=#{ENV["TODOIST_PROJECT_ID"]}'>New todo task in Products!</a>")
  chat_ids.each do |chat_id|
    url = "https://api.telegram.org/bot#{ENV["TELEGRAM_BOT_TOKEN"]}/sendMessage?chat_id=#{chat_id}&parse_mode=HTML&text=" + message
    begin
      if ENV["TELEGRAM_PROXY_URL"]
        HTTP::Client.get("#{ENV["TELEGRAM_PROXY_URL"]}/?url=#{URI.escape(url)}")
      else
        HTTP::Client.get(url)
      end
    rescue
    end
  end
end

def watch
  state = Array(Task).new
  state_present = false
  while true
    begin
      new_state = get_state
    rescue
      next
    end

    if !state_present
      state = new_state
      state_present = true
      next
    end

    new_task_ids = find_new_task_ids(new_state, state)

    if new_task_ids.size > 0
      puts new_task_ids.inspect.colorize(:green)
      notify
    end

    state = new_state

    sleep 10
  end
end

watch

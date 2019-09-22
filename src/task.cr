require "json"

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

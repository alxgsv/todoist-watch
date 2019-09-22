require "spec"
require "../src/notifier_agenda"
require "../src/todoist"

describe NotifierAgenda do
  it "shouldn't notify more that once a day" do
    notifier = NotifierAgenda.new
    todoist = Todoist.new
    now = Time.new(2019, 9, 22, 10, 20, 30, location: Time::Location.load("Europe/Samara"))
    notifier.notified_at?(now).should be_false
    notifier.notify(todoist, now)
    notifier.notified_at?(now).should be_true
  end
end

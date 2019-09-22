require "http/client"
require "uri"

class Telegram
  def self.notify(message : String)
    chat_ids = ENV["TELEGRAM_CHAT_IDS"]?.to_s.split(",")
    message = URI.escape("<a href='todoist://project?id=#{ENV["TODOIST_PROJECT_ID"]?}'>#{message}</a>")
    chat_ids.each do |chat_id|
      url = "https://api.telegram.org/bot#{ENV["TELEGRAM_BOT_TOKEN"]?}/sendMessage?chat_id=#{chat_id}&parse_mode=HTML&text=" + message
      begin
        if ENV["TELEGRAM_PROXY_URL"]
          HTTP::Client.get("#{ENV["TELEGRAM_PROXY_URL"]?}/?url=#{URI.escape(url)}")
        else
          HTTP::Client.get(url)
        end
      rescue
      end
    end
  end
end

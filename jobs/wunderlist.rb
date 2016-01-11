require 'wunderlist'
require 'json'

access_token = ENV['ACCESS_TOKEN']
client_id = ENV['CLIENT_ID']
list_name = "To-Do List"
max_items = 8

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10m', :first_in => 0 do |job|
  wl = Wunderlist::API.new({
    :access_token => access_token,
    :client_id => client_id
  })

  data = []
  list = wl.list(list_name)

  if list
    list.tasks.each do |task|
      data << {
        title: task.title,
        createddate: task.created_at,
        duedate: task.due_date,
        starred: task.starred
      }
    end
    data.sort! {|a,b| [b[:starred].to_s, a[:title].to_s] <=> [a[:starred].to_s, b[:title].to_s]}
    send_event('wunderlist', { title: list.title, :items => data })
  end
end
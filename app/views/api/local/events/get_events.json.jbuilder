json.array! @events do |event|
  json.id event.id
  json.title event.title
  json.started_at event.started_at.strftime("%Y.%m.%d %I:%M")
  json.finished_at event.finished_at.strftime("%Y.%m.%d %I:%M")
  json.city do
    json.id event.city.id.to_s
    json.name event.city.name
  end
end

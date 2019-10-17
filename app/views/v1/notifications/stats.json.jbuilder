json.events @notifications.zip(@totals, @assists, @views, @not_views, @related_kids) do |notification, total, assist, view, not_view, related_kids|
  json.category notification.category
  json.title notification.title
  json.description notification.description
  json.publication_date notification.publication_date
  json.role notification.role
  json.campus notification.campus
  json.grade notification.grade
  json.group notification.group
  json.total total
  json.assist assist
  json.view view
  json.not_view not_view
  json.kids related_kids
end

json.events_found @events_found
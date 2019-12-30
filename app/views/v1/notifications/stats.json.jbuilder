json.events @notifications.zip(@totals, @assists, @views, @not_views, @parents, @total_kids) do |notification, total, assist, view, not_view, parent, total_kids|
  json.id notification.id
  json.category notification.category
  json.title notification.title
  json.description notification.description
  json.publication_date notification.publication_date
  json.role notification.role
  json.campus notification.campus
  json.grade notification.grade
  json.group notification.group
  json.updated_at notification.updated_at
  json.total total
  json.assist assist
  json.view view
  json.not_view not_view
  json.total_kids total_kids
  json.parents parent
end

json.events_found @events_found
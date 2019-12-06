json.events @notifications.zip(@totals, @assists, @views, @not_views, @related_kids, @parents_email) do |notification, total, assist, view, not_view, related_kids, parent_email|
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
  json.email_parent parent_email
  json.kids related_kids
end

json.events_found @events_found
json.notifications @notifications do |notification|
  json.category notification.category
  json.title notification.title
  json.description notification.description
  json.publication_date notification.publication_date
  json.role notification.role
  json.campus notification.campus
  json.grade notification.grade
  json.group notification.group
end
json.totals @totals do |total|
  json.total total
end
json.assists @assists do |assist|
  json.assist assist
end
json.views @views do |view|
  json.view view
end
json.not_views @not_views do |not_view|
  json.not_view not_view
end
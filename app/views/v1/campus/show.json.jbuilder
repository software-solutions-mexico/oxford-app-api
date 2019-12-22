json.campus @campus do |campus|
  json.id campus.id
  json.name campus.name
  json.grades campus.groups
  json.created_at campus.created_at
  json.updated_at campus.updated_at
end
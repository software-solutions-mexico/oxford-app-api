json.users_created_succesfully @users_created

json.users_not_created do
  json.total @users_not_created
  json.emails_already_registered do
    json.total @emails_already_registered.count
    json.emails @emails_already_registered
  end
  json.emails_without_family_key_registered do
    json.total @emails_not_created.count
    json.emails @emails_not_created
  end
end

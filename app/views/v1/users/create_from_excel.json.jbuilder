json.users_created_succesfully @users_created

json.users_not_created do
  json.total @users_not_created
  json.emails_already_registered @emails_already_registered
  json.emails_without_family_key_registered @emails_not_created
end

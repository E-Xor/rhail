require 'sequel'

DB = Sequel.sqlite('db/database.sqlite3')

DB.run "DROP TABLE IF EXISTS addresses"
DB.run "DROP TABLE IF EXISTS people"

DB.create_table :addresses do
  primary_key :id
  String      :street_1,  :size => 255
  String      :street_2,  :size => 255
  String      :city
  String      :state,   :size => 2
  String      :zipcode, :size => 5
end

DB.run "INSERT INTO addresses(city, state, zipcode) VALUES('Atlanta', 'GA', '30305')"
DB.run "INSERT INTO addresses(city, state, zipcode) VALUES('Houston', 'TX', '77001')"
DB.run "INSERT INTO addresses(city, state, zipcode) VALUES('Fargo', 'ND', '58102')"


DB.create_table :people do
  primary_key :id
  String      :name,  :size => 255
  Integer     :address_id
end

DB.run "INSERT INTO people(name, address_id) VALUES('George', 1)"
DB.run "INSERT INTO people(name, address_id) VALUES('Thomas', 2)"
DB.run "INSERT INTO people(name, address_id) VALUES('Douglas', 3)"


#run this script when I want to create a new database table. Otherwise, ignore.

require 'sequel'
DB = Sequel.connect('sqlite://bot.db')
DB.create_table :score do
  primary_key :id
  String :nick
  Integer :points
end
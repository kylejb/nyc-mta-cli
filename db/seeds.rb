require 'csv'

FavoriteStation.destroy_all
User.destroy_all
TrainStation.destoy_all

# Populates Database with MTA Subway Station Stop information sourced from the MTA
table = CSV.read(("./db/Stations.csv"), headers: true)
table.each do |row|
  TrainStation.create(name: row["Stop Name"], stop_id: row["GTFS Stop ID"], route_id: row["Daytime Routes"], latitude: row["GTFS Latitude"], longitude: row["GTFS Longitude"])
end

## Remove '#' on Line 16 to initialize database with that data
## Change the quoted values to a username and password of your choice
# User.create(name: "user", password: "change_this_password")

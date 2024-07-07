require 'csv'

FavoriteStation.destroy_all
User.destroy_all
TrainStation.destroy_all

# Seed database with MTA Subway Station information
table = CSV.read(("./db/Stations.csv"), headers: true)
table.each do |row|
  TrainStation.create(name: row["Stop Name"], stop_id: row["GTFS Stop ID"], route_id: row["Daytime Routes"], latitude: row["GTFS Latitude"], longitude: row["GTFS Longitude"])
end

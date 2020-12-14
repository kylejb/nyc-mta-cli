FavoriteStation.destroy_all
User.destroy_all
TrainStation.destoy_all

require 'csv'

table = CSV.read(("./db/Stations.csv"), headers: true)

table.each do |row| 
    TrainStation.create(name: row["Stop Name"], stop_id: row["GTFS Stop ID"], route_id: row["Daytime Routes"], latitude: row["GTFS Latitude"], longitude: row["GTFS Longitude"])
end

# user1 = User.create(name: "kylejb", password: "secure_password1")
# fav1 = FavoriteStation.create(user: user1, train_station: TrainStation.find_by(name: "Times Sq - 42 St"))


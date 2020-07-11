class RemoveDepartureColumnsTrainStations < ActiveRecord::Migration[5.2]
  def change
    remove_column :train_stations, :next_departure_route_id
    remove_column :train_stations, :next_departure_time
  end
end

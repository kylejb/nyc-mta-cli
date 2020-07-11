class AddColumnRouteIdToTrainStations < ActiveRecord::Migration[5.2]
  def change
    add_column :train_stations, :route_id, :string
  end
end

class AddColumnsLongAndLatToTrainStations < ActiveRecord::Migration[5.2]
  def change
    add_column :train_stations, :latitude, :float
    add_column :train_stations, :longitude, :float
  end
end

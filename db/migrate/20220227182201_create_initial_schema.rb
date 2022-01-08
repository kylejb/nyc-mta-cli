class CreateInitialSchema < ActiveRecord::Migration[7.0]
    def change
      create_table :favorite_stations do |t|
        t.integer :user_id
        t.integer :train_station_id
      end

      create_table :train_stations do |t|
        t.string :name
        t.string :stop_id
        t.string :route_id
        t.float :latitude
        t.float :longitude
      end

      create_table :users do |t|
        t.string :name
        t.string :password
      end

    end
  end

class CreateFilterCitiesTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :filters, :cities do |t|
      t.index [:filter_id, :city_id]
    end
  end
end

class CreateFilters < ActiveRecord::Migration[5.1]
  def change
    create_table :filters do |t|
      t.references :user, index: true
      t.datetime :started_at, index: true
      t.datetime :finished_at, index: true

      t.timestamps
    end
  end
end

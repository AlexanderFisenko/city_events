class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :city, index: true
      t.datetime :started_at, index: true
      t.datetime :finished_at, index: true
      t.string :title, index: true

      t.timestamps
    end
  end
end

class CreateEventNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :event_notifications do |t|
      t.boolean :seen, default: false, null: false
      t.references :user, foreign_key: true, index: true
      t.references :event, foreign_key: true, index: true

      t.timestamps
    end
  end
end

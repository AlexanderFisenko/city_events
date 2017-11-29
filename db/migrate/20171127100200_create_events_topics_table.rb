class CreateEventsTopicsTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :events, :topics do |t|
      t.index [:event_id, :topic_id]
    end
  end
end

class CreateFilterTopicsTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :filters, :topics do |t|
      t.index [:filter_id, :topic_id]
    end
  end
end

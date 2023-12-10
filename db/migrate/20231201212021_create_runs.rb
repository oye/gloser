class CreateRuns < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_table :runs, id: :uuid do |t|
      t.string :player_name
      t.integer :score
      t.integer :week
      t.integer :current_level_id

      t.timestamps
    end
  end
end

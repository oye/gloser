class CreateWords < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change # rubocop:disable Metrics/MethodLength
    create_table :words do |t|
      t.string :norwegian, null: false
      t.string :english, null: false
      t.string :wrong_norwegian1, null: false
      t.string :wrong_norwegian2, null: false
      t.string :wrong_norwegian3, null: false
      t.string :wrong_english1, null: false
      t.string :wrong_english2, null: false
      t.string :wrong_english3, null: false
      t.integer :week, null: false
      t.timestamps
    end
  end
end

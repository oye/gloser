class CreateLevels < ActiveRecord::Migration[7.1]
  def change
    create_table :levels do |t|
      t.integer :current_word_id
      t.boolean :current_word_english
      t.boolean :current_word_completed
      t.boolean :current_word_correct
      t.string :current_word_guess
      t.integer :options_order, array: true
      t.integer :level_number
      t.references :run, type: :uuid, null: false, foreign_key: true
      t.integer :word_ids, array: true
      t.timestamps
    end
  end
end

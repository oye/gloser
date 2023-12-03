class Level < ApplicationRecord
  belongs_to :run
  belongs_to :current_word, foreign_key: :current_word_id, class_name: 'Word', optional: true

  def current_word_language
    current_word_english? ? 'english' : 'norwegian'
  end

  def current_word_options_language
    current_word_english? ? 'norwegian' : 'english'
  end
end

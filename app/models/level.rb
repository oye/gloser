class Level < ApplicationRecord
  belongs_to :run
  belongs_to :current_word, foreign_key: :current_word_id, class_name: 'Word', optional: true

  def current_word_language
    current_word_english? ? 'english' : 'norwegian'
  end

  def current_word_options_language
    current_word_english? ? 'norwegian' : 'english'
  end

  def current_word_adjective
    current_word_english? ? 'norsk' : 'engelsk'
  end

  def current_word_shuffled_solution
    shuffled_scentence = shuffle_sentence(current_word[current_word_options_language])
    while current_word[current_word_options_language] == shuffled_scentence
      shuffled_scentence = shuffle_sentence(current_word[current_word_options_language])
    end
    shuffled_scentence
  end

  private

  def shuffle_sentence(sentence)
    sentence.split.map { |word| word.chars.shuffle.join }.join(' ')
  end
end

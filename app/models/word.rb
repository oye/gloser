class Word < ApplicationRecord # rubocop:disable Style/Documentation
  has_many :levels, foreign_key: :current_word_id, dependent: :nullify, inverse_of: :current_word
  has_many :runs, through: :levels
end

class Run < ApplicationRecord
  has_many :levels, dependent: :destroy
  belongs_to :current_level, foreign_key: :current_level_id, class_name: 'Level', optional: true

  before_create :set_week, :set_player_name
  after_create :create_levels, :set_current_level

  def max_score
    levels = self.levels.count
    levels + levels * 2
  end

  private

  def create_levels
    2.times do |i|
      word_ids = Word.where(week:).order('random()').collect(&:id)
      levels.create!(level_number: i + 1, current_word_id: word_ids.first, word_ids:, run: self,
                     options_order: [nil, 1, 2, 3].shuffle, current_word_english: [true, false].sample)
    end
  end

  def set_week
    self.week = Date.today.cweek
  end

  def set_player_name
    self.player_name = "Spiller #{Run.count + 1}" if player_name.blank?
  end

  def set_current_level
    self.current_level = levels.where(level_number: 1).first
    save!
  end
end

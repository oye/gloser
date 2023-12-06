class Run < ApplicationRecord
  has_many :levels, dependent: :destroy
  belongs_to :current_level, foreign_key: :current_level_id, class_name: 'Level', optional: true

  before_create :set_week, :set_player_name
  after_create :create_levels, :set_current_level

  def max_score
    # 1 point for each correct word in level 1 and 2, 2 points for each correct word in level 3
    current_level&.word_ids&.size.to_i * 4
  end

  def current_task_number
    (current_level.level_number - 1) * current_level&.word_ids&.size.to_i + current_level.word_ids.index(current_level.current_word_id) + 1
  end

  def total_number_of_tasks
    current_level&.word_ids&.size.to_i * levels.size
  end

  private

  def create_levels
    word_ids = Word.where(week:).collect(&:id)
    3.times do |i|
      shuffled_word_ids = word_ids.shuffle
      levels.create!(level_number: i + 1,
                     current_word_id: shuffled_word_ids.first,
                     word_ids: shuffled_word_ids,
                     run: self,
                     options_order: [nil, 1, 2, 3].shuffle,
                     current_word_english: [true, false].sample)
    end
  end

  def set_week
    self.week = Date.today.cweek
  end

  def set_player_name
    self.player_name = "Spiller #{Run.count + 1}"
  end

  def set_current_level
    self.current_level = levels.where(level_number: 1).first
    save!
  end
end

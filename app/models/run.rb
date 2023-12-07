class Run < ApplicationRecord
  attr_accessor :selected_levels

  has_many :levels, dependent: :destroy
  belongs_to :current_level, foreign_key: :current_level_id, class_name: 'Level', optional: true

  before_create :set_week, :set_player_name
  after_create :create_levels, :set_current_level

  def max_score
    # 1 point for each correct word in level 1 and 2, 2 points for each correct word in level 3
    levels.sum { |level| level.level_number == 3 ? level.word_ids.size * 2 : level.word_ids.size }
  end

  def current_task_number
    current_level.word_ids.index(current_level.current_word_id) + 1 + levels.where('level_number < ?',
                                                                                   current_level.level_number).count * current_level.word_ids.size
  end

  def total_number_of_tasks
    current_level&.word_ids&.size.to_i * levels.size
  end

  private

  def create_levels
    word_ids = Word.where(week:).collect(&:id)
    selected_levels.each do |level_number|
      shuffled_word_ids = word_ids.shuffle
      levels.create!(level_number:,
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
    self.current_level = levels.order(:level_number).first
    save!
  end
end

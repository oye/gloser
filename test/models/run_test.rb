require 'test_helper'

class RunTest < ActiveSupport::TestCase
  setup do
    @run = Run.new(selected_levels: [1, 2, 3], week: Time.zone.today.cweek, year: Time.zone.today.year)
  end

  test 'should save run' do
    assert @run.save
  end

  test 'should create levels after create' do
    @run.save
    assert_equal @run.selected_levels.size, @run.levels.size
  end

  test 'should calculate max_score correctly' do
    @run.save
    assert_equal @run.levels.sum { |level|
                   level.level_number == 3 ? level.word_ids.size * 2 : level.word_ids.size
                 }, @run.max_score
  end

  test 'should calculate current_task_number correctly' do
    @run.save
    assert_equal @run.current_level.word_ids.index(@run.current_level.current_word_id) + 1, @run.current_task_number
  end

  test 'should destroy run' do
    @run.save
    assert @run.destroy
  end
end

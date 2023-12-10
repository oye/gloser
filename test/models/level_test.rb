require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  setup do
    @run = runs(:one)
    @level = Level.new(run: @run)
  end

  test 'should save level' do
    assert @level.save
  end

  test 'should return current_word_shuffled_solution' do
    # Assuming you have a method to set current_word and current_word_options_language
    @level.current_word = words(:one) # Assuming you have a fixture for words
    @level.current_word_english = true
    assert_not_equal @level.current_word['norwegian'], @level.current_word_shuffled_solution
  end

  test 'should destroy level' do
    @level.save
    assert @level.destroy
  end
end

require 'test_helper'

class RunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @run = runs(:one)
    @selected_levels_sets = [[1, 2, 3], [1, 2], [1], [2], [3], [1, 3], [2, 3]]
    post runs_url, params: { run: { selected_levels: [1, 2, 3], year: @run.year, week: @run.week } }
    @common_run = Run.order(:created_at).last
  end

  test 'should get new' do
    get new_run_url
    assert_response :success
  end

  test 'should create run with selected_levels' do
    @selected_levels_sets.each do |selected_levels|
      assert_difference('Run.count') do
        post runs_url, params: { run: { selected_levels: } }
      end
      if selected_levels.include?(1)
        assert_redirected_to level_one_run_path(Run.order(:created_at).last)
      else
        assert_redirected_to level_two_run_path(Run.order(:created_at).last)
      end
    end
  end

  test 'should get level_one' do
    get level_one_run_url(@common_run)
    assert_response :success
  end

  test 'should get level_two' do
    get level_two_run_url(@common_run)
    assert_response :success
  end

  test 'should post level_one_answer with correct guess and redirect to level_one' do
    @common_run.current_level.current_word[@common_run.current_level.current_word_options_language] = 'correct_guess'
    post level_one_answer_run_url(@common_run), params: { guess: 'correct_guess' }
    assert_redirected_to level_one_run_url(@common_run)
  end

  test 'should post level_one_answer with incorrect guess and redirect to level_one' do
    @common_run.current_level.current_word[@common_run.current_level.current_word_options_language] = 'correct_guess'
    post level_one_answer_run_url(@common_run), params: { guess: 'incorrect_guess' }
    assert_redirected_to level_one_run_url(@common_run)
  end

  test 'should post level_two_answer with correct guess and redirect to level_two' do
    @common_run.current_level.current_word[@common_run.current_level.current_word_options_language] = 'I`m feeling sick'
    post level_two_answer_run_url(@common_run), params: { guess: 'Im feeling sick.' }
    assert_redirected_to level_two_run_url(@common_run)
  end

  test 'should post level_two_answer with incorrect guess and redirect to level_two' do
    @common_run.current_level.current_word[@common_run.current_level.current_word_options_language] = 'correct_guess'
    post level_two_answer_run_url(@common_run), params: { guess: 'incorrect_guess' }
    assert_redirected_to level_two_run_url(@common_run)
  end

  test 'should post next and redirect to correct level' do
    @common_run.current_level.current_word_id = @common_run.current_level.word_ids.sample
    @common_run.current_level.save
    post next_run_url(@common_run)

    current_word_index = @common_run.current_level.word_ids.index(@common_run.current_level.current_word_id)
    last_word_index = @common_run.current_level.word_ids.length - 1

    if current_word_index == last_word_index
      assert_redirected_to level_two_run_url(@common_run)
    else
      assert_redirected_to level_one_run_url(@common_run)
    end
  end

  test 'should get completed and destroy run' do
    get completed_run_url(@common_run)
    assert_not Run.exists?(@common_run.id)
  end
end

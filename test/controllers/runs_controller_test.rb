require 'test_helper'

class RunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @run = runs(:one)
    @selected_levels_sets = [[1, 2, 3], [1, 2], [1], [2], [3], [1, 3], [2, 3]]
    post runs_url, params: { run: { selected_levels: [1, 2, 3] } }
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

  test 'should post level_one_answer and redirect to level_one' do
    post level_one_answer_run_url(@common_run), params: { guess: 'guess' }
    assert_redirected_to level_one_run_url(@common_run)
  end

  test 'should post level_two_answer and redirect to level_two' do
    post level_two_answer_run_url(@common_run), params: { guess: 'guess' }
    assert_redirected_to level_two_run_url(@common_run)
  end

  test 'should post next and redirect to correct level' do
    @common_run.current_level.current_word_id = @common_run.current_level.word_ids.sample
    @common_run.current_level.save
    post next_run_url(@common_run)
    if @common_run.current_level.word_ids.index(@common_run.current_level.current_word_id) == @common_run.current_level.word_ids.length - 1
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

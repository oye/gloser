class RunsController < ApplicationController # rubocop:disable Style/Documentation,Metrics/ClassLength
  before_action :set_run,
                only: %i[level_one level_two level_one_answer level_two_answer next]

  # GET /runs/new
  def new
    @current_date = Time.zone.today
    if params[:week].present?
      begin
        @current_date = Date.parse(params[:week])
      rescue Date::Error => e
        flash[:error] = "Ugyldig dato: #{e}"
      end
    end
    @this_weeks_words = Word.where(week: @current_date.cweek, year: @current_date.year)
    @run = Run.new
  end

  # GET /runs/1/level_one
  def level_one; end

  # GET /runs/1/level_two
  def level_two; end

  # POST /runs/1/level_one_answer
  def level_one_answer
    process_answer
    redirect_to level_one_run_url(@run)
  end

  # POST /runs/1/level_two_answer
  def level_two_answer
    process_answer
    redirect_to level_two_run_url(@run)
  end

  # POST /runs/1/next
  def next
    current_word_index = @run.current_level.word_ids.index(@run.current_level.current_word_id)
    if current_word_index == @run.current_level.word_ids.length - 1
      process_next_level
    else
      process_next_word(current_word_index)
    end
  end

  # GET /runs/1/completed
  def completed
    @run = Run.find_by(id: params[:id])
    return unless @run

    session[:score] = @run.score
    session[:max_score] = @run.max_score
    @run.destroy
  end

  # POST /runs or /runs.json
  def create
    @run = Run.new(run_params)
    respond_to do |format|
      if @run.save
        process_run_creation(format)
      else
        handle_run_creation_failure(format)
      end
    end
  end

  private

  def process_next_level
    next_level = @run.levels.where('level_number > ?', @run.current_level.level_number).first
    if next_level.nil?
      redirect_to completed_run_url(@run)
    else
      @run.current_level = next_level
      @run.save!
      redirect_to level_two_run_url(@run)
    end
  end

  def process_next_word(current_word_index)
    @run.current_level.current_word_id = @run.current_level.word_ids[current_word_index + 1]
    reset_current_word
    @run.current_level.current_word_english = [true, false].sample
    @run.current_level.save!
    redirect_to_correct_level
  end

  def shuffle_options_and_randomize_language
    @run.current_level.options_order = @run.current_level.options_order.shuffle
    @run.current_level.current_word_english = [true, false].sample
  end

  def redirect_to_correct_level
    if @run.current_level.level_number == 1
      redirect_to level_one_run_url(@run)
    else
      redirect_to level_two_run_url(@run)
    end
  end

  def reset_current_word
    @run.current_level.current_word_completed = false
    @run.current_level.current_word_guess = nil
    @run.current_level.current_word_correct = nil
  end

  def process_run_creation(format)
    format.html do
      redirect_to @run.current_level.level_number == 1 ? level_one_run_url(@run) : level_two_run_url(@run)
    end
    format.json { render :show, status: :created, location: @run }
  end

  def handle_run_creation_failure(format)
    format.html { render :new, status: :unprocessable_entity }
    format.json { render json: @run.errors, status: :unprocessable_entity }
  end

  def process_answer
    @run.current_level.current_word_completed = true
    @run.current_level.current_word_guess = params[:guess]&.strip
    update_scores if correct_guess?
    save_changes
  end

  def update_scores
    @run.current_level.current_word_correct = true
    @run.score = @run.score.to_i + (@run.current_level.level_number == 3 ? 2 : 1)
  end

  def correct_guess?
    guess = @run.current_level.current_word_guess.downcase.gsub(/[^a-zæøå0-9\s]/i, '')
    correct_word = @run.current_level.current_word[@run.current_level.current_word_options_language].downcase.gsub(
      /[^a-zæøå0-9\s]/i, ''
    )
    guess == correct_word
  end

  def save_changes
    @run.current_level.save!
    @run.save!
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_run
    @run = Run.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def run_params
    params.require(:run).permit(:quess, :year, :week, selected_levels: [])
  end
end

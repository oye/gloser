class RunsController < ApplicationController
  before_action :set_run,
                only: %i[show edit update destroy level_one level_two level_one_answer level_two_answer next completed]

  # GET /runs or /runs.json
  def index
    @runs = Run.all
  end

  # GET /runs/1 or /runs/1.json
  def show; end

  # GET /runs/new
  def new
    @run = Run.new
  end

  # GET /runs/1/edit
  def edit; end

  def level_one; end

  def level_two; end

  def level_one_answer
    @run.current_level.current_word_completed = true
    @run.current_level.current_word_guess = params[:guess]
    if params[:guess].downcase == @run.current_level.current_word[@run.current_level.current_word_options_language].downcase
      @run.current_level.current_word_correct = true
      @run.score = @run.score.to_i + 1
    end
    @run.current_level.save!
    @run.save!
    redirect_to level_one_run_url(@run)
  end

  def level_two_answer
    @run.current_level.current_word_completed = true
    @run.current_level.current_word_guess = params[:guess]&.strip
    if @run.current_level.current_word_guess.downcase == @run.current_level.current_word[@run.current_level.current_word_options_language].downcase
      @run.current_level.current_word_correct = true
      @run.score = @run.score.to_i + 2
    end
    @run.current_level.save!
    @run.save!
    redirect_to level_two_run_url(@run)
  end

  def next
    # move to the next level or end the game
    current_word_index = @run.current_level.word_ids.index(@run.current_level.current_word_id)
    if current_word_index == @run.current_level.word_ids.length - 1
      if @run.current_level.level_number == 2
        redirect_to completed_run_url(@run)
      else
        @run.current_level = @run.levels.where(level_number: 2).first
        @run.save!
        redirect_to level_two_run_url(@run)
      end
    else
      # move to the next word
      @run.current_level.current_word_id = @run.current_level.word_ids[current_word_index + 1]
      @run.current_level.current_word_completed = false
      @run.current_level.current_word_guess = nil
      @run.current_level.current_word_correct = nil
      @run.current_level.options_order = @run.current_level.options_order.shuffle
      @run.current_level.current_word_english = [true, false].sample
      @run.current_level.save!
      if @run.current_level.level_number == 1
        redirect_to level_one_run_url(@run)
      else
        redirect_to level_two_run_url(@run)
      end
    end
  end

  # GET /runs/1/completed
  def completed; end

  # POST /runs or /runs.json
  def create
    @run = Run.new(run_params)

    respond_to do |format|
      if @run.save
        format.html { redirect_to level_one_run_url(@run), notice: "Velkommen #{@run.player_name}!" }
        format.json { render :show, status: :created, location: @run }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /runs/1 or /runs/1.json
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html { redirect_to run_url(@run), notice: 'Run was successfully updated.' }
        format.json { render :show, status: :ok, location: @run }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1 or /runs/1.json
  def destroy
    @run.destroy!

    respond_to do |format|
      format.html { redirect_to runs_url, notice: 'Run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_run
    @run = Run.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def run_params
    params.require(:run).permit(:player_name, :quess)
  end
end

class LinksController < ApplicationController
  before_action :set_link, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[index edit update destroy]

  # GET /links or /links.json
  def index
    @links = Link.all
  end

  # GET /links/1 or /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end
  
  # GET /links/1/edit
  def edit
  end

  # POST /links or /links.json
  def create
    if !valid_url?(link_params["url"])
      flash[:alert] = "Niepoprawny URL, przekierowano na stronę główną."
      redirect_to root_path and return
    end

    @link = Link.new(link_params)
    @link.user = current_user if user_signed_in?
    @link.user_id = current_user ? current_user.id : 1


    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to link_url(@link), notice: "Link was successfully updated." }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  def destroy
    @link.destroy

    respond_to do |format|
      format.html { redirect_to links_url, notice: "Link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def redirect_to_original
    @link = Link.find_by(url_short: params[:short_url]+"==")
    if @link
      redirect_to @link.url, allow_other_host: true
    else
      # Dodaj obsługę przypadku, gdy skrócony link nie istnieje
      render plain: 'Skrócony link nie istnieje', status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:url, :url_short, :category)
    end

    def valid_url?(url)
      url_pattern = /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
      url =~ url_pattern
    end
end

class ToolsController < ApplicationController
  before_action :set_tool, only: [:show, :edit, :update, :destroy]

  # GET /tools
  # GET /tools.json
  def index
    @tools = Tool.all
  end

  # GET /tools/1
  # GET /tools/1.json
  def show
  end

  # GET /tools/new
  def new
    @tool = Tool.new
  end

  # GET /tools/1/edit
  def edit
  end

  # POST /tools
  # POST /tools.json
  def create
    create_tool = Tools::Creator.new.call(tool_params.to_h)

    if create_tool.success?
      redirect_to create_tool.success, notice: "Tool was successfully created."
    else
      @tool = Tool.new(tool_params)
      @errors = create_tool.failure
      render :new
    end
  end

  # PATCH/PUT /tools/1
  # PATCH/PUT /tools/1.json
  def update
    update_tool = Tools::Updater.new.call(@tool)

    if update_tool.success?
      redirect_to @tool, notice: "Tool was successfully updated! Pull Request created!"
    else
      redirect_to @tool, notice: update_tool.failure.first
    end
  end

  # DELETE /tools/1
  # DELETE /tools/1.json
  def destroy
    @tool.destroy
    respond_to do |format|
      format.html { redirect_to tools_url, notice: "Tool was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tool
    @tool = Tool.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tool_params
    params.fetch(:tool).permit(:name, :language)
  end
end

class RecordsController < ApplicationController
  before_action :set_record, only: %i[show edit update destroy publish unpublish]
  before_action :authenticate_user!, except: %i[index show]

  # GET /records
  def index
    @records = Record.all
  end

  # GET /records/1
  def show
    @remote_metadata = JSON.parse(DataMarketplaceConnector.get(@record).body) if @record.published?
  rescue JSON::ParserError
    @remote_metadata = DataMarketplaceConnector.get(@record).body
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit; end

  # POST /records
  def create
    @record = Record.new(record_params)

    if @record.save
      redirect_to @record, notice: "Record was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /records/1
  def update
    if @record.update(record_params)
      DataMarketplaceConnector.update(@record) if @record.published? # rubocop:disable Rails/SaveBang
      redirect_to @record, notice: "Record was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /records/1
  def destroy
    @record.destroy!
    redirect_to records_path, notice: "Record was successfully destroyed.", status: :see_other
  end

  # POST /records/1/publish
  def publish
    response = DataMarketplaceConnector.create(@record) # rubocop:disable Rails/SaveBang
    if response.success?
      @record.update!(remote_id: response.env.response_headers["location"].split("/").last)
      redirect_to @record, notice: "Record successfully published to Data Marketplace"
    else
      body = JSON.parse(response.body)
      Rails.logger.error "Publishing to Data Market place failed for record #{@record.id}: #{body}"
      redirect_to @record, alert: "Record publishing to Data Marketplace failed: #{body['message']}"
    end
  end

  # POST /records/1/unpublish
  def unpublish
    response = DataMarketplaceConnector.remove(@record)
    if response.success?
      @record.update!(remote_id: nil)
      redirect_to @record, notice: "Record successfully removed from the Data Marketplace"
    else
      body = JSON.parse(response.body)
      Rails.logger.error "Unpublishing to Data Market place failed for record #{@record.id}: #{body}"
      redirect_to @record, alert: "Record unpublishing/removal from Data Marketplace failed: #{body['message']}"
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_record
    @record = Record.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def record_params
    params.expect(record: %i[name metadata])
  end
end

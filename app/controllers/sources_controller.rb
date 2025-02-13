class SourcesController < ApplicationController
  def index
    @sources = Record.distinct.pluck(:source).compact
  end

  def show
    @source = params[:id]
    @records = Record.where(source: @source)
  end
end

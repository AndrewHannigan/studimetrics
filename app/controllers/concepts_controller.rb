class ConceptsController < ApplicationController
  def index
    @concepts = Concept.filtered
  end

  def show
    @concept = Concept.find params[:id]
  end
end

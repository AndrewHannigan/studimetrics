class ConceptsController < ApplicationController
  def index
    @concepts = Concept.for_sidebar
  end

  def show
    @concept = Concept.find params[:id]
  end
end

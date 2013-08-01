class ConceptsController < ApplicationController
  def index
    @concepts = Concept.all
  end
end

class ManagementController < ApplicationController
  def view_roster
    @affiliations = Affiliation.all.order(affiliation_type_id: :asc)
  end

  def view_terms
    @terms = Term.all
  end

  def new_term
    @term = Term.new
  end

  def destroy_term
    Term.find(params[:id]).destroy

    redirect_to action: :view_terms
  end

  def create_term
    Term.create term_params

    redirect_to action: :view_terms
  end

  private
  def term_params
    params.require(:term).permit(:begin, :end, :name)
  end
end

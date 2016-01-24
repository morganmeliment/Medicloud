class MedicationsController < ApplicationController
  def index
  	@medications = Medication.where(:userid => viewuser.id)
    @medarray = []
    for med in @medications
      @medarray.push med
    end
    @medarray.sort! {|x, y| x.id <=> y.id}
    @medications = @medarray
  end

  def completemedsearch
  	fin = []
    #.split(' ').map(&:capitalize).join(' ')
  	MedDb.search(params[:term].downcase).each do |med|
  		if med.name.length < 15
  			fin.push med.name.split(' ').map(&:capitalize).join(' ')
  		end
  	end
  	fini = fin.sort_by(&:length)
    render json: fini[0..5]
  end
end

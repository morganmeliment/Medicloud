class NotesController < ApplicationController

  def index
  	@notes = []
  	Note.all.each do |no|
  		if decrypt(no.userid) == viewuser.id
  			@notes.push no
  		end
  	end
    @notes.sort! {|x, y| x.id <=> y.id}
  end

  def create
  	@note = Note.new(:userid => params[:auth], :name => encrypt(params[:notename]), :notecontent => encrypt(params[:notecontent]))
	  @note.save
	  redirect_to notes_index_path
  end

  def update
    @note = Note.update(params[:ident], :name => encrypt(params[:notename]), :notecontent => encrypt(params[:notecontent]))
    @note.save
    redirect_to notes_index_path
  end

  def delete
    notes = []
    Note.all.each do |no|
      if decrypt(no.userid) == viewuser.id
        notes.push no
      end
    end
    notes.sort! {|x, y| x.id <=> y.id}
    Note.destroy(notes[decrypt(params[:ncount]).to_i - 1].id)
    redirect_to notes_index_path
  end
end

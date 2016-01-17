class NotesController < ApplicationController
  def index
  	@notes = Note.where(:userid => viewuser.id)
  end
end

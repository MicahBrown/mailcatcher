class ProjectsController < ApplicationController
  def index
  end

  def show
    @project = authorize!(Project.find(params[:id]))
  end

  def clear_inbox
  end
end

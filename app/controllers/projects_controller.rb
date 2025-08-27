class ProjectsController < ApplicationController
  def index
  end

  def show
    @project = authorize!(Project.find(params[:id]))
  end

  def clear_inbox
    @project = authorize!(Project.find(params[:project_id]))
    @project.messages.destroy_all

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("messages", partial: "projects/messages/list", locals: {project: @project.reload})
      end
    end
  end
end

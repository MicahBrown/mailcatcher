class Projects::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  allow_unauthenticated_access only: :create

  def index
    @project = authorize!(Project.find(params[:project_id]))
    render partial: "list", locals: {project: @project}
  end

  def show
    @project = authorize!(Project.find(params[:project_id]))
    @message = @project.messages.find(params[:id])

    if params[:html] == "true"
      render partial: "content_html", locals: {project: @project, message: @message}
    else
      render partial: "content", locals: {project: @project, message: @message}
    end
  end

  def create
    @project = Project.find_by!(token: params[:project_id])

    @message = @project.build_message(attachment_params)

    respond_to do |format|
      if @message.save
        format.json { render json: @message, status: :ok }
      else
        format.json { render json: {errors: @message.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  private

    def attachment_params
      permitted = params.require(:message).permit(:subject, :to, :from, to: [], from: [], content: ["text/html; charset=UTF-8", "text/plain; charset=UTF-8"])

      if params[:message][:attachments].present?
        params[:message][:attachments].each do |attachment|
          permitted[:attachments] ||= []
          permitted[:attachments] << attachment.permit(:filename, :content_type, :content)
        end
      end

      permitted
    end
end

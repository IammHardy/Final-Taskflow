class CommentsController < ApplicationController
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user    = current_user
    @comment.company = current_user.company
    authorize @comment

    if @comment.save
      redirect_to @task, notice: "Comment added."
    else
      redirect_to @task, alert: "Comment can't be blank."
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to @task, notice: "Comment deleted."
  end

  private

  def set_task = @task = Task.find(params[:task_id])
  def comment_params = params.require(:comment).permit(:body)
end
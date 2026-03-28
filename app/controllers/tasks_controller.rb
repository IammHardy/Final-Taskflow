class TasksController < ApplicationController
    before_action :set_task, only: [:show, :edit, :update, :destroy, :update_status]
  def index
    @tasks = policy_scope(Task).includes(:assignee, :sector, :creator)
    @tasks = @tasks.by_status(params[:status])   if params[:status].present?
    @tasks = @tasks.where(sector_id: params[:sector_id]) if params[:sector_id].present?
    @tasks = @tasks.assigned_to(current_user)    if params[:mine] == "1"
    @tasks = @tasks.order(priority: :desc, due_date: :asc)
   
  end

  def show
    authorize @task
    @comments = @task.comments.includes(:user).order(:created_at)
    @comment  = Comment.new
    @subtasks = @task.subtasks.includes(:assignee)
  end

  def new
    @task = Task.new
    authorize @task
  end

  def create
  @task = Task.new(task_params)
  @task.company = current_user.company
  @task.creator = current_user
  authorize @task

  if @task.save
    redirect_to @task, notice: "Task created successfully."
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit = authorize @task

  def update
    authorize @task
    if @task.update(task_params)
      redirect_to @task, notice: "Task updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted."
  end

  def update_status
    authorize @task, :update?
    @task.update!(status: params[:status])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("task_#{@task.id}", partial: "tasks/task_row", locals: { task: @task }) }
      format.html         { redirect_back fallback_location: tasks_path }
    end
  end

  private

  def set_task = @task = Task.find(params[:id])

  def task_params
    params.require(:task).permit(
      :title, :description, :status, :priority,
      :due_date, :assignee_id, :sector_id, :parent_task_id
    )
  end
end
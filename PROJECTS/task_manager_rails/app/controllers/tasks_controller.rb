class TasksController < ApplicationController
  before_action :set_task, only: %i[update show destroy edit]

  def create
    task = Task.create(task_params)

    redirect_to table_path, notice: "Your task is created!"
  end

  def update
    @task.update(task_params)

    redirect_to table_path, notice: "Task updated!"
  end

  def destroy
    @task.destroy

    redirect_to table_path, notice: "Task is deleted!"
  end

  def table
    @task = Task.all
  end

  def index
    @task = Task.all
  end

  def new
    @task = Task.new
  end

  def edit
  end

  private

  def task_params
    params.require(:task).permit(:body, :expiration_date, :user_id)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end

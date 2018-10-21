##
# This class represents a meeting of the Senate
class MeetingsController < ApplicationController
  before_action :require_active_user
  before_action :empty_meeting, only: :new
  before_action :require_admin, only: %i[new create edit update]

  def index
    @meetings = Meeting.all.order date: :desc
  end

  def new; end

  def create
    meeting = Meeting.create(meeting_params)

    redirect_to action: :show, id: meeting.id
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    Meeting.find(params[:id]).update_attributes! meeting_params

    redirect_to action: :show
  end

  def show
    @meeting = Meeting.find params[:id]
  end

  def open
    meeting = Meeting.find params[:id]

    begin
      meeting.open
    rescue
      flash[:alert] = 'There is already a meeting open or something else went wrong.'
      redirect_to controller: :meetings, action: :show and return
    end

    flash[:open] = true

    redirect_to action: :attendance, anchor: 'a-begin'
  end

  def close
    meeting = Meeting.find params[:id]
    meeting.close

    flash[:open] = true

    redirect_to action: :attendance, anchor: 'a-end'
  end

  def unclose
    meeting = Meeting.find params[:id]
    meeting.unclose

    redirect_to action: :show, anchor: 'm-controls'
  end

  def reset
    meeting = Meeting.find params[:id]
    meeting.reset

    redirect_to action: :show, anchor: 'm-controls'
  end

  def attendance
    require_admin

    @meeting = Meeting.find params[:id]

    render 'meetings/edit_attendance'
  end

  def destroy
    Meeting.find(params[:id]).destroy

    redirect_to action: :index
  end

  private
  def empty_meeting
    @meeting = Meeting.new
  end

  def meeting_params
    params.require(:meeting).permit(:agenda, :minutes, :name, :date, :begin, :end, attendance_records_attributes: [:id, :who, :netid, :status, :sub, :late, :end_status])
  end
end

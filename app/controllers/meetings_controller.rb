# frozen_string_literal: true

# That line is here because Rubocop wouldn't stop yelling at me about it
# I don't know what it does

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

  def edit; end

  def update
    meeting = Meeting.find params[:id]

    meeting.update_attributes(meeting_params)

    if params[:meeting]['begin(4i)'].blank? || params[:meeting]['begin(5i)'].blank?

    end

    if params[:meeting]['end(5i)'].blank? || params[:meeting]['end(5i)'].blank?

    end

    redirect_to action: :show, id: meeting.id
  end

  def show
    @meeting = Meeting.find params[:id]
  end

  def open
    meeting = Meeting.find params[:id]

    begin
      meeting.open
    rescue
      flash[:alert] = "There is already a meeting open. Close that one before opening this one."
      redirect_to controller: :meetings, action: :show, id: meeting.id and return
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

  def attendance
    require_admin

    @meeting = Meeting.find params[:id]

    render 'meetings/edit_attendance'
  end

  def update_attendance
    params[:meeting][:attendance_record].each do |id, data|
      record = AttendanceRecord.find(id)

      data[:who] ||= record.affiliation.user.name
      data[:netid] ||= record.affiliation.user.netid
      data[:late] = false if data[:late].nil?

      record.update_attributes(attendance_record_params(data))
    end

    redirect_to action: :show
  end

  def empty_meeting
    @meeting = Meeting.new
  end

  private

  def meeting_params
    params.require(:meeting).permit(:agenda, :minutes, :name, :date, :begin, :end)
  end

  def attendance_record_params(pms)
    pms.permit(:who, :netid, :status, :sub, :late)
  end
end

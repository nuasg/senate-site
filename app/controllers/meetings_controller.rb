##
# This class represents a meeting of the Senate
class MeetingsController < ApplicationController
  before_action :empty_meeting, only: :new
  before_action :require_admin, except: [:index, :show]

  def index
    @meetings_grouped = Meeting.all.order(date: :desc).group_by(&:term)
  end

  def new; end

  def create
    meeting = Meeting.new meeting_params

    message = 'Failed to create meeting.'
    message = 'Created meeting.' if meeting.save

    show_message text: message, redirect: {action: :index}
  end

  def edit
    @meeting = Meeting.find params[:id]
  end

  def update
    meeting = Meeting.find params[:id]

    message = 'Failed to update meeting.'
    message = 'Updated meeting.' if meeting.update_attributes meeting_params

    show_message text: message, redirect: {action: :show}
  end

  def show
    @meeting = Meeting.find params[:id]
  end

  def open
    meeting = Meeting.find params[:id]

    message = 'Failed to open meeting.'
    message = 'Meeting opened.' if meeting.open

    flash[:open] = true

    show_message text: message, redirect: {action: :attendance, anchor: 'a-begin'}
  end

  def close
    meeting = Meeting.find params[:id]

    message = 'Failed to close meeting.'
    message = 'Meeting closed.' if meeting.close

    flash[:open] = true

    show_message text: message, redirect: {action: :attendance, anchor: 'a-end'}
  end

  def reopen
    meeting = Meeting.find params[:id]

    message = 'Failed to reopen meeting.'
    message = 'Meeting reopened.' if meeting.reopen

    show_message text: message, redirect: {action: :show, anchor: 'm-controls'}
  end

  def reset
    meeting = Meeting.find params[:id]

    message = 'Failed to reset meeting.'
    message = 'Meeting reset.' if meeting.reset

    show_message text: message, redirect: {action: :show, anchor: 'm-controls'}
  end

  def attendance
    @meeting = Meeting.find params[:id]

    render 'meetings/edit_attendance'
  end

  def destroy
    message = 'Failed to destroy meeting.'
    message = 'Meeting destroyed.' if Meeting.destroy params[:id]

    show_message text: message, redirect: {action: :index}
  end

  private
  def empty_meeting
    @meeting = Meeting.new
  end

  def meeting_params
    params.require(:meeting).permit(:agenda,
                                    :minutes,
                                    :name,
                                    :date,
                                    :begin,
                                    :end,
                                    :embed,
                                    attendance_records_attributes: [:id,
                                                                    :who,
                                                                    :netid,
                                                                    :status,
                                                                    :sub,
                                                                    :late,
                                                                    :end_status])
  end
end

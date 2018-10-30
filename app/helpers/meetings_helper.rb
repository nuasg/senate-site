module MeetingsHelper
  def term_url(term)
    url_for controller: :meetings, action: :index, year: term.year, quarter: term.quarter
  end

  def term_options(selected = -1)
    y = Term.all.order(end: :desc).collect do |term|
      [term.name, term.id, {data: {url: term_url(term)}}]
    end

    options_for_select y, selected
  end

  def meeting_date(meeting)
    meeting.date.strftime '%b %-d, %Y'
  end

  def meeting_edit_button(meeting)
    link_to 'Edit',
            controller: :meetings, action: :edit, id: meeting.id
  end

  def meeting_delete_button(meeting)
    link_to 'Delete',
            {controller: :meetings, action: :destroy, id: meeting.id},
            method: :delete,
            data: {confirm: 'Are you sure you want to delete this?'}
  end

  def record_who(record)
    (record.who || '') + (record.sub ? ' (Sub)' : '')
  end

  def record_who_field(form_record)
    form_record.text_field :who,
                           readonly: record_who_readonly(form_record.object),
                           placeholder: 'Sub Name',
                           id: "sub-name-#{form_record.object&.affiliation&.id}",
                           value: form_record.object.current_or_default_who
  end

  def record_netid_field(form_record)
    form_record.text_field :netid,
                           readonly: record_who_readonly(form_record.object),
                           placeholder: 'Sub NetID',
                           id: "sub-netid-#{form_record.object&.affiliation&.id}",
                           value: form_record.object.current_or_default_netid
  end

  def record_sub_checkbox(form_record)
    form_record.check_box :sub,
                          id: "sub-checkbox-#{form_record.object.affiliation_id}",
                          data: {affiliation: form_record.object.affiliation_id},
                          checked: record_sub_checked(form_record.object),
                          disabled: form_record.object&.affiliation&.user.nil?
  end

  def record_status_select(form_record)
    form_record.select :status,
                       options_for_select(AttendanceRecord.statuses_for_select, form_record.object.status)
  end

  def record_end_status_select(form_record)
    form_record.select :end_status,
                       options_for_select(AttendanceRecord.end_statuses_for_select, form_record.object.end_status)
  end

  def record_who_readonly(record)
    !record&.affiliation&.user.nil? && !record&.sub
  end

  def record_sub_checked(record)
    record&.affiliation&.user.nil? || record&.sub
  end

  def edit_attendance_link
    content_tag(:p,
                link_to('Edit Attendance', {controller: :meetings, action: :attendance}),
                {class: 'text-right'}) if is_admin? && (@meeting.open? || @meeting.closed?)
  end
end

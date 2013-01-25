helpers do
  def show_flash(flash)
    return if flash.first.nil?
    m = flash.first
    "<div class='alert alert-#{m[0].to_s}'><a class='close' data-dismiss='alert' href='#'>&times;</a>#{m[1]}</div>"
  end

  def generate_options(array, selected=nil, name={})
    selected = [selected] if !selected.is_a? Array
    array.map {|e| %Q{<option value='#{e}' #{selected.include?(e) ? "selected='selected'" : nil}'>#{name[e] || e}</option>} }.join
  end

  def show_status(status)
    tag = status=="success" ? 'success' : 'important'
    %Q{ <span class='label label-#{tag}'>#{status}</span>}
  end

  def split_for_selected(array)
    return nil if array.nil?
    array.split(',')
  end

  def show_schedule_detail(frequence, date, time, interval_time, interval_unit)
    text = case frequence
      when 'weekly' then "#{date.split(",").map{ |k| WEEKDAYS[k][0..2]}.join(",")} #{time}"
      when 'interval' then "every #{interval_time} #{interval_unit}#{interval_time.to_i > 1 ? "s" : nil}"
      else "#{date} #{time}"
      end
  end
end

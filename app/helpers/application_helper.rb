module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then 'bg-green-100 border border-green-500 text-green-700'
    when :alert  then 'bg-red-100 border border-red-400 text-red-700'
    else 'bg-yellow-100 border border-yellow-500 text-yellow-700'
    end
  end
end

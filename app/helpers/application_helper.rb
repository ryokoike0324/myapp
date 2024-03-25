module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then 'bg-green-100 border border-green-500 text-green-700'
    when :alert  then 'bg-red-100 border border-red-400 text-red-700'
    else 'bg-yellow-100 border border-yellow-500 text-yellow-700'
    end
  end

  # フォームフィールドのエラースタイル適用
  # errorsに何か入っていれば、borderが赤くなる
  def form_field_error_class(object, field)
    "shadow appearance-none border #{'border-red-500' if object.errors[field].any?} rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline mb-1"
  end

  # エラーメッセージの表示
  # errorsに何か入っていれば、表示させる
  def display_field_error_messages(object, field)
    if object.errors[field].any?
      messages = object.errors[field].map do |msg|
        content_tag(:div, msg, class: 'text-red-500 text-xs italic')
      end
      content_tag(:div, safe_join(messages), class: 'min-h-5')
    else
      # エラーメッセージがない場合でも、スペースを確保する空のdivを返す
      content_tag(:div, '', class: 'min-h-5')
    end
    # binding.pry_remote
  end
end

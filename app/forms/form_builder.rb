class FormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::OutputSafetyHelper

  %w(text_field email_field password_field).each do |selector|
   class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
     def #{selector}(method, options = {})
       super(method, insert_class("form-control", options))
     end
   RUBY_EVAL
 end

  def group(method, &block)
    if object.errors.has_key?(method)
      class_names = "form-group has-error"
    else
      class_names = "form-group"
    end

    content = @template.capture(&block)

    raw(%Q(<div class="#{class_names}">#{content}</div>))
  end

  def label(method, text = nil, options = {}, &block)
    super(method, text, insert_class('control-label', options), &block)
  end

  def errors(method)
    raw(object.errors.messages[method].map { |m| help_block(m) }.join)
  end

  private

  def insert_class(class_name, options)
    output = options.dup
    output[:class] = ((output[:class] || '') + " #{class_name}").strip
    output
  end

  def help_block(message)
    raw(%Q(<span class="help-block">#{message.humanize}</span>))
  end
end

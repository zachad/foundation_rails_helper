require 'action_view/helpers'

module FoundationRailsHelper
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    def error_for(attribute)
      content_tag(:small, object.errors[attribute].join(', '), :class => :error) unless object.errors[attribute].blank?
    end
  
    %w(file_field email_field text_field text_area select).each do |method_name|
      define_method(method_name) do |attribute, options = {}|
        field(attribute, options) do |class_name|
          super(attribute, :class => class_name) 
        end  
      end
    end
  
    def password_field(attribute, options = {})
      field attribute, options do |class_name|
        super(attribute, :class => class_name, :autocomplete => :off)
      end
    end
    
    def datetime_select(attribute, options = {})
      field attribute, options do |class_name|
        super(attribute, {}, :class => class_name, :autocomplete => :off)
      end
    end
  
    def date_select(attribute, options = {})
      field attribute, options do |class_name|
        super(attribute, {}, :class => class_name, :autocomplete => :off)
      end
    end
  
    def autocomplete(attribute, url, options = {})
      field attribute, options do |class_name|
        autocomplete_field(attribute, url, :class => class_name, 
                                           :update_elements => options[:update_elements],
                                           :min_lenth => 0,
                                           :value => object.send(attribute)) 
      end                                          
    end

    def submit(value=nil, options={})
      options[:class] ||= "nice small radius blue button"
      super(value, options)
    end
    

  private
    def custom_label(attribute, text = nil)
      has_error = !object.errors[attribute].blank?
      label(attribute, text, :class => has_error ? :red : '')
    end
  
    def error_and_hint(attribute)
      html = ""
      html += content_tag(:span, options[:hint], :class => :hint) if options[:hint]
      html += error_for(attribute) || ""
      html.html_safe
    end
  
    def field(attribute, options, &block)
      html = custom_label(attribute, options[:label]) 
      html += yield("#{options[:class] || "medium"} input-text placeholder")
      html += error_and_hint(attribute)
    end
  end
end

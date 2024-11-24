module MessageFormattable
  extend ActiveSupport::Concern

  class_methods do
    def delimited_count_error_message(compare_type)
      lambda do |object, data|
        I18n.t(
          "errors.#{compare_type}",
          count: ActiveSupport::NumberHelper.number_to_delimited(data[:count])
        )
      end
    end
  end
end

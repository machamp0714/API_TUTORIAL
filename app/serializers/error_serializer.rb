# frozen_string_literal: true

class ErrorSerializer
  def initialize(model)
    @model = model
  end

  def serialized_json
    errors = @model.errors.messages.map do |attribute, errors_messages|
      errors_messages.map do |error_message|
        {
          source: { pointer: "/data/attributes/#{attribute}" },
          detail: error_message
        }
      end
    end
    errors.flatten
  end
end

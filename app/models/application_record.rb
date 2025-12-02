class ApplicationRecord < BaseRecord
  self.abstract_class = true

  attribute :id, :uuid, default: -> { ActiveRecord::Type::Uuid.generate }
end

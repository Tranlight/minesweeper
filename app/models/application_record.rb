class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  LIMIT_INTEGER = 2_147_483_647
end

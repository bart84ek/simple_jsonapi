class Author < ApplicationRecord
  has_many :articles, autosave: false
end

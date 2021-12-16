class Article < ApplicationRecord
  belongs_to :author, autosave: false
end

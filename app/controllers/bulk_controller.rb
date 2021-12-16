# BulkController
class BulkController < ApplicationController
  def operations
    render json: { ok: true }
  end
end

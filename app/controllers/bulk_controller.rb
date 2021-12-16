# BulkController
class BulkController < ApplicationController
  include Jsonapi::Deserializer
  rescue_from ActionController::ParameterMissing, with: :handle_missing_param

  def operations
    operations = operations_deserializer(bulk_params)
    bulk_add.execute(operations.select { |o| o.action == :add })

    if bulk_add.errors?
      render json: { ok: false, errors: bulk_add.errors }, status: 422
    else
      render json: { ok: true }
    end
  end

  private

  def bulk_add
    @bulk_add ||= BulkAddOperations.new({ authors: Author, articles: Article })
  end

  def handle_missing_param(error)
    error = "param '#{error.param}' is missing"
    render json: { ok: false, errors: [error] }, status: 422
  end

  def article_attributes
    [:title]
  end

  def author_attributes
    [:name]
  end

  def bulk_params
    attributes = article_attributes + author_attributes
    relation_attributes = { data: [:type, :lid] }
    relationships = [author: relation_attributes]
    data = [:type, :lid, { attributes: attributes }, { relationships: relationships }]
    operations = [:op, { ref: [:type] }, { data: data }]
    params.require(:bulk).permit(operations: operations)
  end
end

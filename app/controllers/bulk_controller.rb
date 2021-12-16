# BulkController
class BulkController < ApplicationController
  include Jsonapi::Deserializer

  def operations
    operations = operations_deserializer(bulk_params)
    op = BulkAddOperations.new({ authors: Author, articles: Article })
    op.execute(operations)

    if op.errors?
      render json: { ok: false, errors: op.errors }, status: 422
    else
      render json: { ok: true }
    end
  end

  private

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

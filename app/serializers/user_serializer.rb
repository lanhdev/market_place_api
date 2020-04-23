class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :auth_token

  attribute :product_ids
end

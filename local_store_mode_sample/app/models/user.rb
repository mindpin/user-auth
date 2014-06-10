class User
  include UserAuth::LocalStoreMode
  auth_field :login#, :length => {:in => 7..8}
  def id
    attributes["_id"].to_s
  end


end

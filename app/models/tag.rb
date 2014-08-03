class Tag

  include DataMapper::Resource

  has n, :links, :through => Resource
  # has is the method, n is the parameter (could be 1, 2 etc)

  property :id, Serial
  property :text, String

end
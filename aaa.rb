require "json"

class A
  def initialize(string, number)
    @string = string
    @number = number
  end

  def to_s
    "In A:\n   #{@string}, #{@number}\n"
  end

  def to_json(*a)
    {
        "json_class"   => self.class.name,
        "data"         => {"string" => @string, "number" => @number }
    }.to_json(*a)
  end

  def self.json_create(o)
    new(o["data"]["string"], o["data"]["number"])
  end
end

a = A.new("hello world", 5)
json_string = a.to_json
puts json_string
_aa =JSON.load(json_string)
puts _aa
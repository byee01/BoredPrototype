module EventsHelper
	class Category
		attr_accessor :name, :value
		
		def initialize(name, value)
			@name = name;
			@value = value;
		end
	end
	
	@@category_hash = {
	"Arts" => 1, 
	"Sports" =>2, 
	"Gaming" => 3,
	"Professional" => 4,
	"Greek" => 5,
	"Cultural" => 6,
	"Music" => 7,
	"Movies" => 8,
	"Academic" => 9,
	"Social" => 10,
	"Service" => 11
	}
	
	@@category_hash_rev = @@category_hash.invert
	
	def self.all_categories
		categories = []
		@@category_hash.each do |c|
			categories << Category.new(c[0], Integer(c[1]))
		end
		return categories
	end
	
	def self.to_category(val)
		if @@category_hash_rev.key? Integer(val)
			return Category.new(@@category_hash_rev.fetch(Integer(val)), Integer(val))
		end
		return nil
	end
end

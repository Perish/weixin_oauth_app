module M
  def self.included(base)
  	puts "base ====="
  	puts base.inspect
  	base.extend ClassMethods
  	base.class_eval do
  		def haha  # 这是一个实例方法
	  		puts "eeeee"
  		end
  		# scope :disabled, -> { where(disabled: true) }

  		def self.wuwu # 这是一个类方法
  			puts "eeeefff"
  		end
  	end
  end

  module ClassMethods
  	def hi
  		puts "hello world"
  	end
  end
end

class N
	include M
end



# puts M::ClassMethods.hi


n = N.new
n.haha
N.hi
N.wuwu
puts "n"
puts n.singleton_methods
puts "N"
puts N.singleton_methods
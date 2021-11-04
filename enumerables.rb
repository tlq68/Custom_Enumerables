module Enumerable
    # my_each
    def my_each(&block)
        if block_given?    
            for el in self do
                yield el
            end
        elsif LocalJumpError
            puts "You need to pass a block to use this method."
        end
    end

    # my_each_with_index
    def my_each_with_index(&block)
        if block_given?
            for el in self do
                yield(el, self.find_index(el))
            end
        elsif LocalJumpError
            puts "You need to pass a block to use this method."
        end
    end

    # my_select
    def my_select(&block)
        arr = []
        hash = Hash.new()
        if block_given?
            self.my_each do |k,v|
                if yield(k,v) == true
                    case self
                    in Array
                        arr.push(k)
                    in Hash
                        hash[k.to_sym] = v
                    else
                        puts self.class
                        puts "why are we here?"
                    end
                end
            end
        end
        return arr if self.class == Array
        return hash if self.class == Hash
    end

    # my_all?
    def my_all?(&block)
        all_same = true
        if block_given?
            self.my_each do |k,v|
                if yield(k,v) == false
                    all_same = false
                    break
                end
            end
        end
        all_same
    end

    # my_any?
    def my_any?(&block)
        any_same = false
        if block_given?
            self.my_each do |k,v|
                if yield(k,v) == true
                    any_same = true
                    break
                end
            end
        end
        any_same
    end

    # my_none?
    def my_none?(&block)
        none_exist = true
        if block_given?
            self.my_each do |k,v|
                if yield(k,v) == true
                    none_exist = false
                    break
                end
            end
        end
        none_exist
    end

    # my_count
    def my_count(&block)
        counter = 0
        if block_given?
            self.my_each do |k,v|
                counter += 1 if yield(k,v) == true
            end
        end
        counter
    end

    # my_map
    def my_map(&block)
        arr = []
        if block_given?
            self.my_each do |k,v|
                arr.push(yield(k,v))
            end
        end
        arr
    end

    # my_inject
    def my_inject(num = nil, &block)
        result = ''
        if block_given?
            self.my_each do |item|
                if num 
                    result = yield(num, item)
                    num = result
                else
                    num = self[0]
                    result = yield(num, item)
                end
            end
        end
        result
    end
end

numbers = [1, 2, 3, 4]
names = ["Tex", "Timmy", "John", "Fred"]
names_with_multiples = ["Jason", "Tex", "Timmy", "John", "Fred", "Jason", "Tex", "Tex"]
my_hash = {a:"a", b:"b", c:"c", d: "delta", e: "epsilon"}
all_test_true = [1, 1, 1, 1, 1, 1]
all_test_false = [1, 1, 1, 1, 4, 1]
inject_hash_1 = [1, 2, 5, 7, 4, 12, 9, 11, 3, 9, 20, 2, 14]
inject_hash_2 = [[3, 6], [10, 4], [8, 1], [2, 7]]

puts "\nmy_each vs. each"
numbers.my_each {|x| p x}
puts "---"
numbers.each {|x| p x}

puts "\nmy_each_with_index vs. each_with_index"
names.my_each_with_index do |item, index|
    p item
    p index
end
puts "---"
names.each_with_index do |item, index|
    p item
    p index
end

puts "\nmy_select vs. select"
p numbers.my_select {|x| x < 3}
p my_hash.my_select {|k,v| k.to_s == v}
puts "---"
p numbers.select {|x| x < 3}
p my_hash.select {|k,v| k.to_s == v}

puts "\nmy_all? vs. all?"
p all_test_true.my_all? {|x| x == 1}
p all_test_false.my_all? {|x| x == 1}
puts "---"
p all_test_true.all? {|x| x == 1}
p all_test_false.all? {|x| x == 1}

puts "\nmy_any? vs. any?"
p all_test_true.my_any? {|x| x == 4}
p all_test_false.my_any? {|x| x == 4}
p names.my_any? {|x| x == 'Tex'}
p my_hash.my_any? {|k,v| k.to_s == v }
puts "---"
p all_test_true.any? {|x| x == 4}
p all_test_false.any? {|x| x == 4}
p names.any? {|x| x == 'Tex'}
p my_hash.any? {|k,v| k.to_s == v}

puts "\nmy_none? vs. none?"
p all_test_true.my_none? {|x| x == 2}
p all_test_false.my_none? {|x| x == 1}
p my_hash.my_none? {|k,v| k.to_s == '4'}
p my_hash.my_none? {|k,v| k.to_s == v}
puts "---"
p all_test_true.none? {|x| x == 2}
p all_test_false.none? {|x| x == 1}
p my_hash.none? {|k,v| k.to_s == '4'}
p my_hash.none? {|k,v| k.to_s == v}

puts "\nmy_count vs. count"
p all_test_true.my_count {|x| x == 1}
p all_test_false.my_count {|x| x == 1}
p my_hash.my_count {|k,v| k.to_s == v}
puts "---"
p all_test_true.count {|x| x == 1}
p all_test_false.count {|x| x == 1}
p my_hash.count {|k,v| k.to_s == v}

puts "\nmy_map vs map"
p numbers.my_map {|x| x * 7}
p my_hash.my_map {|k,v| v.upcase}
puts "---"
p numbers.map {|x| x * 7}
p my_hash.map {|k,v| v.upcase}

puts "\nmy_inject vs. inject"
hash_test_1 = inject_hash_1.inject(0) do |item, value|
    item + value
end
p hash_test_1
puts "---"
hash_test_1 = inject_hash_1.my_inject(0) do |item, value|
    item + value
end
p hash_test_1
puts ''

hash_test_2 = inject_hash_2.inject([0,0]) do |acc, stock| 
    (acc.last - acc.first) > (stock.last - stock.first) ? [acc.first, acc.last] : stock
end
p hash_test_2
puts "---"
hash_test_2 = inject_hash_2.my_inject([0,0]) do |acc, stock| 
    (acc.last - acc.first) > (stock.last - stock.first) ? [acc.first, acc.last] : stock
end
p hash_test_2
puts ''

hash_test_3 = names_with_multiples.inject({}) do |acc, name|
    acc[name] ||= 0
    acc[name] += 1
    acc
end
p hash_test_3
puts "---"

hash_test_3 = names_with_multiples.my_inject({}) do |acc, name|
    acc[name] ||= 0
    acc[name] += 1
    acc
end
p hash_test_3

puts "\nmy_map proc test"
a_proc = Proc.new {|x| puts x.upcase}
b_proc = Proc.new {|x| puts x * 7}

names.my_map(&a_proc)
all_test_true.my_map(&b_proc)
puts "---"
names.map(&a_proc)
all_test_true.map(&b_proc)

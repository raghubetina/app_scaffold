require 'csv'

class AssociationBuilder
  def build_associations
    puts "Building associations."
    CSV.foreach("models.csv") do |row|
      model = row.shift
    
      row.compact.each do |column|
        parsed = column.split(':').first.split('_')
        ending = parsed.last
        if ending == "id"
          foreign_key = parsed.first
          puts foreign_key
        end
      end
    end
  end
  

end

a = AssociationBuilder.new
a.build_associations
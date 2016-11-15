require 'csv'
require 'pry'

class Kunde

  def initialize(name, bezahlt)

    @name = name
    if bezahlt >0
      @bezahlt=bezahlt
    else
      @nichtbezahlt=1
    end

    @summe=bezahlt

  end
end

# Klasse in Ruby
class Report

  def lade_CSV(file="./usage-data-2016-11-15.csv")

    @file = file
    #puts @file
  end


  def generiere_bezahlReport(one, two)

    @sum=0

    ausgabeHash = {}


    CSV.foreach(@file,:headers=>false) do |row|
       #print row[1..2]

      kunde = row[one]
      bezahl = row[two].to_i


      ausgabeHash[kunde] = 0 if ausgabeHash[kunde].nil?
      ausgabeHash[kunde] += bezahl

      @sum+= bezahl

    end

    @report=ausgabeHash.drop(1)
    #ausgabe(ausgabeHash.drop(1),@sum)

  end


  def ausgabe(tabsigns)

    printf "%-#{tabsigns}s %s\n","Kunde","Bezahlt\n"
#p @report

    @report.sort do |a, b|
      a.last == b.last ? a.first <=> b.first :
      b.last <=> a.last
    end.each do |key, value|

    printf("%-#{tabsigns}s %s\n",key, value)
    end

    printf("\n")
    printf("%-#{tabsigns}s %s\n","Gesamt Summe", @sum)
    print"\n"
  end

end


report = Report.new()
report.lade_CSV()
report.generiere_bezahlReport(1,2)
report.ausgabe(40)
require 'csv'
require 'pry'

class Kunde
  attr_accessor :summe, :name    #ruby statt setter und getters (attr_accessor fasst attr_reader und attr_writer zusammen)

  def initialize(name, bezahlt)

    @name = name
    if bezahlt >0
      @bezahlt=0
    else
      @nichtbezahlt=0
    end

    @summe=bezahlt

  end


  def summe=(summe)
    @summe = summe
    if summe==0
      @nichtbezahlt+=1
    end
  end
end


# Klasse in Ruby
class Report

  def lade_CSV(file="./usage-data-2016-11-15.csv")

    @file = file
    #puts @file
  end


  def generiere_bezahlReport(one, two)

    @gesamtsum=0

    ausgabeHash = {}


    CSV.foreach(@file,:headers=>false) do |row|
       #print row[1..2]

      kunde = row[one]
      bezahl = row[two].to_i

      ausgabeHash[kunde] = Kunde.new(kunde,0) if ausgabeHash[kunde].nil?   #if not set: init with 0


      #ausgabeHash[kunde] = 0 if ausgabeHash[kunde].nil?   #if not set: init with 0

      #ausgabeHash[kunde] += bezahl

      ausgabeHash[kunde].summe += bezahl  #wir speichern unsere daten nun in der klasse 'kunde' in instanz-variablen

      @gesamtsum+= bezahl

    end


    @report=ausgabeHash.drop(1)
    #ausgabe(ausgabeHash.drop(1),@sum)
    p ausgabeHash

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
    printf("%-#{tabsigns}s %s\n","Gesamt Summe", @gesamtsum)
    print"\n"
  end

end


report = Report.new()
report.lade_CSV()
report.generiere_bezahlReport(1,2)
#report.ausgabe(40)
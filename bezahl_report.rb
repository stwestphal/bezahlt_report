require 'csv'
require 'pry'

class Kunde
  attr_accessor :summe, :name, :bezahlt, :nichtbezahlt   #ruby statt setter und getters (attr_accessor fasst attr_reader und attr_writer zusammen)

  def initialize(name)

    @name = name

      @bezahlt=0
      @nichtbezahlt=0

    @summe=0
  end


  def summe=(summe)

    @summe = summe

    if summe==0
      @nichtbezahlt+=1
    else
      @bezahlt+=1
    end
  end

end


# Klasse in Ruby
class Report

  @report={}

  def lade_CSV(file)

    file
  end


  def generiere_bezahlReport(file, name_colum, price_colum)

    @gesamtsum=0
    ausgabeHash = {}


    CSV.foreach(file,:headers=>false) do |row|
       #print row[1..2]

      kunden_name = row[name_colum]
      bezahl = row[price_colum].to_i

      ausgabeHash[kunden_name] = Kunde.new(kunden_name) if ausgabeHash[kunden_name].nil?   #if not set: init with 0

      ausgabeHash[kunden_name].summe += bezahl  #wir speichern unsere daten nun in der klasse 'kunde' in instanz-variablen

      @gesamtsum+= bezahl

    end

    @report = ausgabeHash.drop(1)
  end


  def ausgabe(kundenreport, tabsigns, bezahltsigns)

    printf "%-#{tabsigns}s %-#{bezahltsigns}s %-#{bezahltsigns}s %s\n","Kunde","Bezahlt", "Bezahlt", "Nicht Bezahlt\n"
      #p @report

    # @report.sort do |a, b|
    #   a.last == b.last ? a.first <=> b.first :
    #   b.last <=> a.last
    # end.each do |key, value|

    #list = ["Albania", "anteater", "zorilla", "Zaire"]
    #puts list.sort_by { |x| x.downcase }

    #kundenreport.sort_by{ |kunde| kunde.to_s.downcase }

    kundenreport.sort_by{ |kunde| kunde.to_s.downcase }.each do |_, kunde|
      printf("%-#{tabsigns}s %-#{bezahltsigns}i %-#{bezahltsigns}i %i\n", kunde.name, kunde.summe, kunde.bezahlt, kunde.nichtbezahlt)
    end

    printf("\n")
    printf("%-#{tabsigns}s %i\n","Gesamt Summe", @gesamtsum)
    print"\n"
  end

end


report = Report.new
file=report.lade_CSV("./usage-data-2016-11-15.csv")
kundenreport =report.generiere_bezahlReport(file,1,2)
report.ausgabe(kundenreport,40,10)
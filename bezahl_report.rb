#!/usr/bin/env ruby
require 'optparse'
require 'ostruct'
require 'csv'
require 'pry'

# Klasse Kunde
# speichert den Namen, Bezahltsumme, Bezahlt-zaehler, Nichtbezahlt-zaehler
class Kunde
  attr_accessor :summe, :name, :bezahlt, :nichtbezahlt
  # ruby statt setter und getters
  # (attr_accessor fasst attr_reader und attr_writer zusammen)

  # Konstruktor in Ruby
  def initialize(name)
    @name = name

    @bezahlt = 0
    @nichtbezahlt = 0

    @summe = 0
  end

  # addiert geparste summe, vergleicht ob diese 0 ist,
  # increment entsprechend nichtbezahlt-, oder bezahlt-zaehler
  def summe=(summe)
    @summe += summe

    if summe.zero?
      @nichtbezahlt += 1
    else
      @bezahlt += 1
    end
  end
end

# ----------------------------
# generiert Hilfsausgabe, fuer Aufrufe ohne parameter
class CommandLineParser
  def self.parse_command_line
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{$PROGRAM_NAME} usage_data.csv\n"\
                    "Bezahl Reporting als csv ausgeben.\n"
    end

    opt_parser.parse!

    unless ARGV.count == 1
      $stderr.puts opt_parser.help
      exit(1)
    end
    options.usage_data_filename = ARGV[0]
    # speichert den Eingabeparameter in options.usage_data_filename
    options
  end
end

# Klasse Report
# parst das Eingabe-file
# generiert formatierte Ausgabe
class Report
  @report = {}

  def initialize(options = {})
    @options = options
  end

  def generiere_bezahl_report(name_colum, price_colum)
    @gesamtsum = 0
    ausgabe_hash = {}

    # puts @options.usage_data_csv
    CSV.foreach(@options.usage_data_filename, headers: true) do |row|
      # print row[1..2]

      kunden_name = row[name_colum]
      bezahl = row[price_colum].to_i

      if ausgabe_hash[kunden_name].nil?
        ausgabe_hash[kunden_name] = Kunde.new(kunden_name)
      end
      # if not set: init with 0

      ausgabe_hash[kunden_name].summe = bezahl
      # wir speichern unsere daten in der klasse 'kunde' in instanz-variablen

      @gesamtsum += bezahl
    end

    @report = ausgabe_hash.drop(1)
    # erste CSV-Parsezeile mit row-Benennungen wegschmeissen
  end

  def ausgabe(kundenreport, tabsigns, bezahltsigns)
    printf "%-#{tabsigns}s \t%-#{bezahltsigns}s ", 'Kunde', 'Summe'
    printf "\t%-#{bezahltsigns}s \t%s\n", 'Bezahlt', 'Nicht Bezahlt'
    # p @report

    # @report.sort do |a, b|
    #   a.last == b.last ? a.first <=> b.first :
    #   b.last <=> a.last
    # end.each do |key, value|

    kundenreport.sort_by { |kunde| kunde.to_s.downcase }.each do |_, kunde|
      # to_s.downcase: kleinbuchstaben werden einsortiert
      printf("%-#{tabsigns}s \t%-#{bezahltsigns}i ", kunde.name, kunde.summe)
      printf("\t%-#{bezahltsigns}i \t%i\n", kunde.bezahlt, kunde.nichtbezahlt)
    end

    printf("%-#{tabsigns}s \t%i\n", 'Gesamt Summe', @gesamtsum)
    print"\n"
  end
end

options = CommandLineParser.parse_command_line
report = Report.new(options)
kundenreport = report.generiere_bezahl_report('Text', 'Price net cents')
report.ausgabe(kundenreport, 40, 10)

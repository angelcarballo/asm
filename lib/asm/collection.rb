require 'erb'

class Asm::Collection
  DEFAULT_ENDPOINT = 'http://www.asmred.com/WebSrvs/b2b.asmx?op=GrabaServicios'
  TEMPLATE = File.expand_path("../../../templates/collection.xml.erb", __FILE__)
  ALLOWED_OPTIONS = [:client_uid, :date, :time_from, :time_to, :reference_number, :name,
                     :address, :city, :state, :country_code, :zipcode, :phone, :mobile, :email]

  attr_accessor *ALLOWED_OPTIONS

  def initialize(options = {})
    ALLOWED_OPTIONS.each do |option|
      instance_variable_set "@#{option}", options[option]
    end
  end

  def xml_message
    ERB.new(File.read(TEMPLATE)).result(binding)
  end
end

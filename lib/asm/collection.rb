require 'erb'

class Asm::Collection
  DEFAULT_ENDPOINT = 'http://www.asmred.com/WebSrvs/b2b.asmx?op=GrabaServicios'
  TEMPLATE = File.expand_path("../../../templates/collection.xml.erb", __FILE__)
  OPTIONS = [:client_uid, :date, :time_from, :time_to, :reference_number, :name,
                     :address, :city, :state, :country_code, :zipcode, :phone, :mobile, :email]

  attr_accessor *OPTIONS

  def initialize(options = {})
    OPTIONS.each do |op|
      instance_variable_set "@#{op}", options[op]
    end
  end

  def xml_message
    ERB.new(File.read(TEMPLATE)).result(binding)
  end
end

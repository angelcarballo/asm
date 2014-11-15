class Asm::Address
  MANDATORY_KEYS = %i(name address city country_code zipcode)
  OPTIONAL_KEYS = %i(state phone observations mobile email)
  KEYS = MANDATORY_KEYS + OPTIONAL_KEYS

  attr_reader *KEYS

  def initialize(options = {})
    raise Asm::InvalidConfig, 'expected Hash for address options' unless options.is_a? Hash
    KEYS.each do |key|
      instance_variable_set "@#{key}", options[key]
    end
  end

  def validate_for!(service)
    keys_to_valide = MANDATORY_KEYS
    keys_to_valide << :mobile << :email if service == :euro_standar
    for key in keys_to_valide
       raise Asm::InvalidConfig, "#{key} must be defined" unless public_send(key)
    end
  end
end

class Serialization
  def self.defenitions
    defenitions = JSON.parse(File.read('./lib/defenitions.json'))
    fields = defenitions['FIELDS'].reduce({}) do |hash, (k, v)|
      hash.merge(k => v)
    end
    defenitions['FIELDS'] = fields
    defenitions
  end

  def self.sign(private_key, message)
    priv_key_bytes = [private_key].pack('H*')
    instance = Ed25519::SigningKey.new(priv_key_bytes)
    signature = instance.sign(message)
    signature.unpack1('H*').upcase
  end

  def self.serialize(data_map, signature_mode = false)
    data = data_map.map do |key, value|
      next unless Serialization.should_serialize?(key, signature_mode)

      if key == 'TransactionType'
        value = Serialization.defenitions['TRANSACTION_TYPES'][value]
      else
        value
      end

      field_info = Serialization.defenitions['FIELDS'][key]
      field_type = field_info['type']

      #  For to_i in the argument we indicate in what form we are passing the value. For example '0x40'- hex => .to_i(16)
      value = case field_type
              when 'Amount'
                (value | '0x4000000000000000'.to_i(16)).to_s(2).rjust(64, '0')
              when 'UInt16'
                value.to_s(2).rjust(16, '0')
              when 'UInt32'
                value.to_s(2).rjust(32, '0')
              else
                value
              end

      if field_info['isVLEncoded']
        case field_type
        when 'AccountID'
          value = [('14' + value)].pack('H*').unpack1('B*')
        when 'Blob'
          prefix = Serialization.blob_length(value.to_i(16).to_s(2).bytesize / 8)
          value = prefix + value.to_i(16).to_s(2)
        end
      else
        value
      end

      type_code = Serialization.defenitions['TYPES'][field_type]
      field_code = field_info['nth']

      prefix_field_id = if type_code < 16 && field_code < 16
                          type_code.to_s(2).rjust(4, '0') + field_code.to_s(2).rjust(4, '0')
                        elsif type_code >= 16 && field_code < 16
                          0.to_s(2).rjust(4, '0') + field_code.to_s(2).rjust(4, '0') + type_code.to_s(2).rjust(8, '0')
                        elsif type_code < 16 && field_code >= 16
                          type_code.to_s(2).rjust(4, '0') + 0.to_s(2).rjust(4, '0') + field_code.to_s(2).rjust(8, '0')
                        else
                          0.to_s(2).rjust(8, '0') + type_code.to_s(2).rjust(8, '0') + field_code.to_s(2).rjust(8, '0')
                        end
      value = value.insert(0, prefix_field_id)
      [type_code, field_code, key, value]
    end
    # data.compact.sort.each { |i| p i }
    sequence = data.compact.sort.map { |i| i[3] }.join
    # arr = sequence.map { |i| i[3].to_i(2).to_s(16) }
    # arr.join
  end

  def self.blob_length(size)
    if size <= 192
      size.to_s(2).rjust(8, '0')

    elsif size <= 12_480
      virtual_size = size - 193
      units = virtual_size.to_s(2).rjust(16, '0')
      byte1 = (units.first(8).to_i(2) + 193).to_s(2)
      byte2 = units.last(8)
      byte1 + byte2

    else
      size <= 918_744
      virtual_size = size - 12_481
      units = virtual_size.to_s(2).rjust(24, '0')
      byte1 = (units.first(8).to_i(2) + 241).to_s(2)
      byte1 + units.last(16)
    end
  end

  def self.should_serialize?(key, signature_mode)
    field_info = Serialization.defenitions['FIELDS']
    return false unless field_info.include?(key)

    if signature_mode == true
      field_info[key].fetch('isSigningField')
    else
      field_info[key].fetch('isSerialized')
    end
  end
end

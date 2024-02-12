require 'base58'
class AddressEncoder
  def self.to_account_id(address)
    bin = Base58.base58_to_binary(address, :ripple)
    bin.unpack1('H*')[2..41].upcase # return upcase hex
  end
end

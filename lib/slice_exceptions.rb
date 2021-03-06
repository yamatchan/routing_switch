class Slice
  # Slice not found.
  class SliceNotFoundError < StandardError; end
  # Port not found.
  class PortNotFoundError < StandardError; end
  # MAC address not found.
  class MacAddressNotFoundError < StandardError; end

  # Slice already exists.
  class SliceAlreadyExistsError < StandardError; end
  # Port already exists.
  class PortAlreadyExistsError < StandardError; end
  # MAC address already exists.
  class MacAddressAlreadyExistsError < StandardError; end
end

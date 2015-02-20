$LOAD_PATH.unshift __dir__

require 'link'
require 'observer'

# Topology information containing the list of known switches, ports,
# and links.
class Topology
  include Observable

  attr_reader :links
  attr_reader :ports

  def initialize(view)
    @ports = Hash.new { [].freeze }
    @links = []
    add_observer view
  end

  def switches
    @ports.keys
  end

  def add_switch(dpid, ports)
    ports.each { |each| add_port(each) }
    changed
    notify_observers :add_switch, dpid, self
  end

  def delete_switch(dpid)
    @ports[dpid].each { |each| delete_port(each) }
    @ports.delete dpid
    changed
    notify_observers :delete_switch, dpid, self
  end

  def add_port(port)
    @ports[port.dpid] += [port]
    changed
    notify_observers :add_port, port, self
  end

  def delete_port(port)
    @ports[port.dpid].delete_if { |each| each.number == port.number }
    changed
    notify_observers :delete_port, port, self
    maybe_delete_link port
  end

  def maybe_add_link(link)
    return if @links.include?(link)
    @links << link
    changed
    notify_observers :add_link, link, self
  end

  private

  def maybe_delete_link(port)
    @links.each do |each|
      next unless each.connect_to?(port)
      changed
      @links -= [each]
      notify_observers :delete_link, each, self
    end
  end
end

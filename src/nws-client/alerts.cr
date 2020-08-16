require "../nws-client"
require "../types/alerts"

module NWSClient
  def self.alerts
    Alerts.fetch with: CLIENT
  end

  def self.active_alerts
    Alerts.fetch_active with: CLIENT
  end
end

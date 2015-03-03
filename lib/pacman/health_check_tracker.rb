require 'statsd-instrument'

class HealthCheckTracker
  def initialize consumer_name
    @consumer_name = consumer_name
    config_statsd
  end

  def track event
    return unless match? event

    StatsD.gauge metrics_key, delay(event), sample_rate: 1.0
  end

  private

  attr_reader :consumer_name

  def delay event
    Time.now.to_i - event.time
  end

  def metrics_key
    @metrics_key ||= "#{metrics_key_prefix}.#{consumer_name}.delay"
  end

  def match? event
    target_event_name == event.name
  end

  def target_event_name
    @target_event_name ||=
      ENV.fetch 'PACMAN_HEALTH_CHECK_EVENT', 'kinesis_consumer_health_check'
  end

  def metrics_key_prefix
    @metrics_key_prefix ||=
      ENV.fetch 'PACMAN_METRICS_KEY_PREFIX', 'KinesisConsumer'
  end

  def tracker_host
    ENV['PLAIN_HOST_IP']
  end

  def config_statsd
    return unless tracker_host

    StatsD.backend =
      StatsD::Instrument::Backends::UDPBackend.new "#{tracker_host}:8125", :statsd
  end
end

#pacman-rb

![Pacman logo](https://cloud.githubusercontent.com/assets/7110204/4536930/d3ddafd6-4dd0-11e4-94a7-148f42515402.png)

**Pacman** is a ruby based Kafka consumer consuming events generated through **cheese** (https://github.com/everydayhero/cheese).

The following shows a typical use case:

```ruby
consumer = Pacman::Consumer.with_config do |config|
  config.load_from_env
  config.consumer_name = 'test_consumer'
end

consumer.consume do |events|
  p events
end
```

The consumer accepts the following environment variables:

```ruby
# EVENT_QUEUE_TOPIC=events
# EVENT_QUEUE_HOSTS=kafka_queue_host1:9092,kafka_queue_host2:9092
# EVENT_QUEUE_ZOOKEEPER_HOSTS=zookeeper_host1:2181,zookeeper_host2:2181
```

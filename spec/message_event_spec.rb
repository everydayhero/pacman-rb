require 'spec_helper'

describe Pacman::MessageEvent do
  describe '.from_message' do
    subject { Pacman::MessageEvent.from_message raw_message }

    context 'When with raw event contains invalid JSON payload' do
      let(:raw_message) { Poseidon::Message.new value: 'bad' }

      it { is_expected.to be_a Pacman::NullEvent }
    end

    context 'When with valid raw event' do
      let(:time) { Time.now.to_i }
      let(:payload) { { ping: 'pong' } }
      let(:message_json) {
        {
          name: 'test_event',
          time: time,
          payload: payload
        }.to_json
      }
      let(:raw_message) { Poseidon::Message.new value: message_json }

      it { is_expected.to have_attributes name: 'test_event' }
      it { is_expected.to have_attributes time: time }
      it { is_expected.to have_attributes payload: { 'ping' => 'pong' } }
      it { is_expected.to have_attributes message_id: raw_message.offset }
    end
  end
end

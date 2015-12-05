# encoding: utf-8

RSpec.describe TTY::Prompt::Question, '#read' do

  subject(:prompt) { TTY::TestPrompt.new }

  context 'with no mask' do
    it 'asks with echo on' do
      prompt.input << "password"
      prompt.input.rewind
      answer = prompt.ask("What is your password?") { |q| q.echo(true) }
      expect(answer).to eql("password")
      expect(prompt.output.string).to eq([
        "What is your password? ",
        "\e[1A\e[1000D\e[K",
        "What is your password? \e[32mpassword\e[0m"
      ].join)
    end

    it 'asks with echo off' do
      prompt.input << "password"
      prompt.input.rewind
      answer = prompt.ask("What is your password?") { |q| q.echo(false) }
      expect(answer).to eql("password")
      expect(prompt.output.string).to eq([
        "What is your password? ",
        "\e[1A\e[1000D\e[K",
        "What is your password? "
      ].join)
    end
  end

  context 'with mask' do
    it 'masks output with character' do
      prompt.input << "password\n"
      prompt.input.rewind
      answer = prompt.ask("What is your password?") { |q| q.mask('*') }
      expect(answer).to eql("password")
      expect(prompt.output.string).to eq([
        "What is your password? ********",
        "\e[1A\e[1000D\e[K",
        "What is your password? ********"
      ].join)
    end

    it 'ignores mask if echo is off' do
      prompt.input << "password"
      prompt.input.rewind
      answer = prompt.ask('What is your password?') do |q|
        q.echo false
        q.mask '*'
      end
      expect(answer).to eql("password")
      expect(prompt.output.string).to eq([
        "What is your password? ",
        "\e[1A\e[1000D\e[K",
        "What is your password? "
      ].join)
    end
  end

  context 'with mask and echo as options' do
    it 'asks with options' do
      prompt.input << "password"
      prompt.input.rewind
      answer = prompt.ask("What is your password:", echo: false, mask: '*')
      expect(answer).to eq("password")
    end

    it 'asks with block' do
      prompt.input << "password"
      prompt.input.rewind
      answer = prompt.ask "What is your password:" do |q|
        q.echo  false
        q.mask '*'
      end
      expect(answer).to eq("password")
    end
  end
end
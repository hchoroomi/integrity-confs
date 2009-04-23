#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/integrity-config"
require "notifier/email"

Integrity::Notifier.register(Integrity::Notifier::Email)

Integrity::App.set(:environment, ENV["RACK_ENV"] || :production)
Integrity::App.disable(:run, :reload)
run Integrity::App
